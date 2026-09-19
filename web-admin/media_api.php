<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';
require_admin_token();

const MEDIA_MAX_BYTES = 200 * 1024 * 1024;
const MEDIA_ALLOWED = [
    'jpg' => 'image',
    'jpeg' => 'image',
    'png' => 'image',
    'webp' => 'image',
    'mp4' => 'video',
    'webm' => 'video',
];

function media_dir(): string
{
    $dir = __DIR__ . '/media/files';
    if (!is_dir($dir) && !mkdir($dir, 0775, true) && !is_dir($dir)) {
        throw new RuntimeException('Não foi possível criar diretório de mídia.');
    }
    return $dir;
}

function media_config_path(): string
{
    return __DIR__ . '/media/playlist-config.json';
}

function load_media_config(): array
{
    $path = media_config_path();
    if (!is_file($path)) return ['items' => []];

    $raw = file_get_contents($path);
    $data = $raw === false ? null : json_decode($raw, true);
    return is_array($data) && isset($data['items']) && is_array($data['items'])
        ? $data
        : ['items' => []];
}

function save_media_config(array $config): void
{
    $json = json_encode($config, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
    if ($json === false || file_put_contents(media_config_path(), $json, LOCK_EX) === false) {
        throw new RuntimeException('Não foi possível salvar configuração da playlist.');
    }
}

function normalized_media_name(string $name): string
{
    $name = basename($name);
    $name = preg_replace('/[^A-Za-z0-9._ -]/u', '_', $name) ?? '';
    return trim($name);
}

function list_media_items(): array
{
    $config = load_media_config();
    $cfgMap = [];
    foreach ($config['items'] as $item) {
        if (isset($item['file'])) $cfgMap[(string)$item['file']] = $item;
    }

    $result = [];
    $files = scandir(media_dir()) ?: [];
    foreach ($files as $file) {
        if ($file === '.' || $file === '..' || str_starts_with($file, '.')) continue;
        $path = media_dir() . '/' . $file;
        if (!is_file($path)) continue;

        $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
        if (!isset(MEDIA_ALLOWED[$ext])) continue;

        $type = MEDIA_ALLOWED[$ext];
        $cfg = $cfgMap[$file] ?? [];
        $result[] = [
            'file' => $file,
            'type' => $type,
            'size' => filesize($path),
            'enabled' => array_key_exists('enabled', $cfg) ? (bool)$cfg['enabled'] : true,
            'duration' => $type === 'image'
                ? max(1, min(3600, (int)($cfg['duration'] ?? 12)))
                : 0,
            'order' => (int)($cfg['order'] ?? 999999),
        ];
    }

    usort($result, static function(array $a, array $b): int {
        $order = $a['order'] <=> $b['order'];
        return $order !== 0 ? $order : strnatcasecmp($a['file'], $b['file']);
    });

    foreach ($result as $i => &$item) {
        if ($item['order'] === 999999) $item['order'] = $i + 1;
    }
    unset($item);

    return $result;
}

try {
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        json_response(['ok' => true, 'items' => list_media_items()]);
    }

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        json_response(['ok' => false, 'error' => 'Método não permitido.'], 405);
    }

    $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
    if (str_starts_with(strtolower($contentType), 'multipart/form-data')) {
        $action = strtoupper(trim((string)($_POST['action'] ?? 'UPLOAD')));
        if ($action !== 'UPLOAD') {
            json_response(['ok' => false, 'error' => 'Ação multipart inválida.'], 422);
        }

        if (!isset($_FILES['file']) || !is_array($_FILES['file'])) {
            json_response(['ok' => false, 'error' => 'Arquivo não enviado.'], 422);
        }

        $upload = $_FILES['file'];
        if (($upload['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
            json_response(['ok' => false, 'error' => 'Falha no upload.'], 400);
        }

        $size = (int)($upload['size'] ?? 0);
        if ($size <= 0 || $size > MEDIA_MAX_BYTES) {
            json_response(['ok' => false, 'error' => 'Arquivo deve ter até 200 MB.'], 422);
        }

        $name = normalized_media_name((string)($upload['name'] ?? ''));
        $ext = strtolower(pathinfo($name, PATHINFO_EXTENSION));
        if ($name === '' || !isset(MEDIA_ALLOWED[$ext])) {
            json_response(['ok' => false, 'error' => 'Formato de mídia não permitido.'], 422);
        }

        $tmp = (string)($upload['tmp_name'] ?? '');
        if (!is_uploaded_file($tmp)) {
            json_response(['ok' => false, 'error' => 'Upload inválido.'], 400);
        }

        $finfo = new finfo(FILEINFO_MIME_TYPE);
        $mime = $finfo->file($tmp) ?: '';
        $allowedMime = [
            'image/jpeg','image/png','image/webp',
            'video/mp4','video/webm','application/octet-stream',
        ];
        if (!in_array($mime, $allowedMime, true)) {
            json_response(['ok' => false, 'error' => 'MIME não permitido: ' . $mime], 422);
        }

        $destination = media_dir() . '/' . $name;
        if (!move_uploaded_file($tmp, $destination)) {
            json_response(['ok' => false, 'error' => 'Não foi possível salvar mídia.'], 500);
        }

        $items = list_media_items();
        $config = ['items' => array_map(static fn(array $item): array => [
            'file' => $item['file'],
            'enabled' => $item['enabled'],
            'duration' => $item['duration'],
            'order' => $item['order'],
        ], $items)];
        save_media_config($config);

        json_response(['ok' => true, 'items' => list_media_items()]);
    }

    $input = json_decode(file_get_contents('php://input'), true);
    if (!is_array($input)) {
        json_response(['ok' => false, 'error' => 'JSON inválido.'], 400);
    }

    $action = strtoupper(trim((string)($input['action'] ?? '')));

    if ($action === 'DELETE') {
        $file = normalized_media_name((string)($input['file'] ?? ''));
        if ($file === '') json_response(['ok' => false, 'error' => 'Arquivo obrigatório.'], 422);

        $path = media_dir() . '/' . $file;
        if (is_file($path) && !unlink($path)) {
            json_response(['ok' => false, 'error' => 'Não foi possível excluir mídia.'], 500);
        }

        $config = load_media_config();
        $config['items'] = array_values(array_filter(
            $config['items'],
            static fn(array $item): bool => (string)($item['file'] ?? '') !== $file
        ));
        save_media_config($config);
        json_response(['ok' => true, 'items' => list_media_items()]);
    }

    if ($action === 'SAVE') {
        $items = $input['items'] ?? null;
        if (!is_array($items)) {
            json_response(['ok' => false, 'error' => 'Lista de itens inválida.'], 422);
        }

        $existing = [];
        foreach (list_media_items() as $item) $existing[$item['file']] = $item;

        $configItems = [];
        $order = 1;
        foreach ($items as $item) {
            if (!is_array($item)) continue;
            $file = normalized_media_name((string)($item['file'] ?? ''));
            if ($file === '' || !isset($existing[$file])) continue;

            $type = $existing[$file]['type'];
            $duration = $type === 'image'
                ? max(1, min(3600, (int)($item['duration'] ?? 12)))
                : 0;

            $configItems[] = [
                'file' => $file,
                'enabled' => !empty($item['enabled']),
                'duration' => $duration,
                'order' => $order++,
            ];
        }

        save_media_config(['items' => $configItems]);
        json_response(['ok' => true, 'items' => list_media_items()]);
    }

    json_response(['ok' => false, 'error' => 'Ação inválida.'], 422);
} catch (Throwable $e) {
    json_response(['ok' => false, 'error' => $e->getMessage()], 500);
}
