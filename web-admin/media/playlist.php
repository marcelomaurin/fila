<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-cache, must-revalidate');

$mediaDir = __DIR__ . '/files';
$configPath = __DIR__ . '/playlist-config.json';

if (!is_dir($mediaDir)) {
    @mkdir($mediaDir, 0775, true);
}

$extensions = [
    'jpg' => 'image',
    'jpeg' => 'image',
    'png' => 'image',
    'webp' => 'image',
    'mp4' => 'video',
    'webm' => 'video',
];

$config = ['items' => []];
if (is_file($configPath)) {
    $raw = file_get_contents($configPath);
    $decoded = $raw === false ? null : json_decode($raw, true);
    if (is_array($decoded) && isset($decoded['items']) && is_array($decoded['items'])) {
        $config = $decoded;
    }
}

$cfgMap = [];
foreach ($config['items'] as $cfg) {
    if (!is_array($cfg) || empty($cfg['file'])) continue;
    $cfgMap[(string)$cfg['file']] = $cfg;
}

$scheme = 'http';
if (!empty($_SERVER['HTTP_X_FORWARDED_PROTO'])) {
    $scheme = strtolower(trim(explode(',', (string)$_SERVER['HTTP_X_FORWARDED_PROTO'])[0]));
} elseif (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
    $scheme = 'https';
}

$host = $_SERVER['HTTP_HOST'] ?? 'localhost';
$script = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '/media/playlist.php');
$basePath = rtrim(dirname($script), '/') . '/files/';

$items = [];
$files = scandir($mediaDir) ?: [];
foreach ($files as $file) {
    if ($file === '.' || $file === '..' || str_starts_with($file, '.')) continue;

    $path = $mediaDir . '/' . $file;
    if (!is_file($path)) continue;

    $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
    if (!isset($extensions[$ext])) continue;

    $type = $extensions[$ext];
    $cfg = $cfgMap[$file] ?? [];
    $enabled = array_key_exists('enabled', $cfg) ? (bool)$cfg['enabled'] : true;
    if (!$enabled) continue;

    $items[] = [
        'type' => $type,
        'url' => $scheme . '://' . $host . $basePath . rawurlencode($file),
        'duration' => $type === 'image'
            ? max(1, min(3600, (int)($cfg['duration'] ?? 12)))
            : 0,
        'name' => pathinfo($file, PATHINFO_FILENAME),
        '_order' => (int)($cfg['order'] ?? 999999),
    ];
}

usort($items, static function(array $a, array $b): int {
    $order = $a['_order'] <=> $b['_order'];
    return $order !== 0 ? $order : strnatcasecmp($a['name'], $b['name']);
});

foreach ($items as &$item) {
    unset($item['_order']);
}
unset($item);

echo json_encode([
    'ok' => true,
    'generated_at' => date(DATE_ATOM),
    'items' => $items,
], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
