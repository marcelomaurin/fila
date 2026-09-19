<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-cache, must-revalidate');

$mediaDir = __DIR__ . '/files';
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

$items = [];
$files = is_dir($mediaDir) ? scandir($mediaDir) : [];
if ($files === false) {
    $files = [];
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

foreach ($files as $file) {
    if ($file === '.' || $file === '..' || str_starts_with($file, '.')) {
        continue;
    }

    $path = $mediaDir . '/' . $file;
    if (!is_file($path)) {
        continue;
    }

    $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
    if (!isset($extensions[$ext])) {
        continue;
    }

    $type = $extensions[$ext];
    $items[] = [
        'type' => $type,
        'url' => $scheme . '://' . $host . $basePath . rawurlencode($file),
        'duration' => $type === 'image' ? 12 : 0,
        'name' => pathinfo($file, PATHINFO_FILENAME),
    ];
}

usort($items, static fn(array $a, array $b): int => strnatcasecmp($a['name'], $b['name']));

echo json_encode([
    'ok' => true,
    'generated_at' => date(DATE_ATOM),
    'items' => $items,
], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
