<?php
declare(strict_types=1);

require_once __DIR__ . '/../../config.php';
require_once __DIR__ . '/../../db.php';

require_panel_token();

$dir = realpath(__DIR__ . '/../../releases');
if ($dir === false) {
    json_response(['ok' => false, 'error' => 'Nenhuma release publicada.'], 404);
}

$metaPath = $dir . DIRECTORY_SEPARATOR . 'latest.json';
if (!is_file($metaPath)) {
    json_response(['ok' => false, 'error' => 'Nenhuma release publicada.'], 404);
}

$raw = file_get_contents($metaPath);
$meta = $raw === false ? null : json_decode($raw, true);
if (!is_array($meta)) {
    json_response(['ok' => false, 'error' => 'Metadata de release inválida.'], 500);
}

$file = basename((string)($meta['file'] ?? ''));
$apkPath = $dir . DIRECTORY_SEPARATOR . $file;
if ($file === '' || !is_file($apkPath)) {
    json_response(['ok' => false, 'error' => 'APK publicado não encontrado.'], 404);
}

$scheme = 'http';
if (!empty($_SERVER['HTTP_X_FORWARDED_PROTO'])) {
    $scheme = strtolower(trim(explode(',', (string)$_SERVER['HTTP_X_FORWARDED_PROTO'])[0]));
} elseif (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
    $scheme = 'https';
}

$host = $_SERVER['HTTP_HOST'] ?? 'localhost';
$script = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '/api/panel/update.php');
$webAdminBase = preg_replace('#/api/panel$#', '', dirname($script));
$url = $scheme . '://' . $host . rtrim((string)$webAdminBase, '/') . '/releases/' . rawurlencode($file);

json_response([
    'ok' => true,
    'version_name' => (string)($meta['version_name'] ?? ''),
    'version_code' => (int)($meta['version_code'] ?? 0),
    'sha256' => (string)($meta['sha256'] ?? ''),
    'size' => (int)($meta['size'] ?? filesize($apkPath)),
    'published_at' => (string)($meta['published_at'] ?? ''),
    'url' => $url,
]);
