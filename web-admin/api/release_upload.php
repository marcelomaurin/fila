<?php
declare(strict_types=1);

require_once __DIR__ . '/../db.php';
require_admin_token();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['ok' => false, 'error' => 'Método não permitido.'], 405);
}

$versionName = trim((string)($_POST['version_name'] ?? ''));
$versionCode = (int)($_POST['version_code'] ?? 0);

if (!preg_match('/^[0-9]+(?:\.[0-9]+){1,3}(?:[-+][A-Za-z0-9._-]+)?$/', $versionName)) {
    json_response(['ok' => false, 'error' => 'version_name inválido.'], 422);
}
if ($versionCode < 1) {
    json_response(['ok' => false, 'error' => 'version_code inválido.'], 422);
}

if (!isset($_FILES['apk']) || !is_array($_FILES['apk'])) {
    json_response(['ok' => false, 'error' => 'APK não enviado.'], 422);
}

$file = $_FILES['apk'];
if (($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
    json_response(['ok' => false, 'error' => 'Falha no upload do APK.'], 400);
}

$size = (int)($file['size'] ?? 0);
if ($size <= 0 || $size > 250 * 1024 * 1024) {
    json_response(['ok' => false, 'error' => 'APK deve ter até 250 MB.'], 422);
}

$original = (string)($file['name'] ?? '');
if (strtolower(pathinfo($original, PATHINFO_EXTENSION)) !== 'apk') {
    json_response(['ok' => false, 'error' => 'Arquivo precisa ter extensão .apk.'], 422);
}

$tmp = (string)($file['tmp_name'] ?? '');
if (!is_uploaded_file($tmp)) {
    json_response(['ok' => false, 'error' => 'Upload inválido.'], 400);
}

$finfo = new finfo(FILEINFO_MIME_TYPE);
$mime = $finfo->file($tmp) ?: '';
$accepted = [
    'application/vnd.android.package-archive',
    'application/zip',
    'application/octet-stream',
];
if (!in_array($mime, $accepted, true)) {
    json_response(['ok' => false, 'error' => 'Tipo de arquivo APK inválido: ' . $mime], 422);
}

$dir = __DIR__ . '/../releases';
if (!is_dir($dir) && !mkdir($dir, 0775, true) && !is_dir($dir)) {
    json_response(['ok' => false, 'error' => 'Não foi possível criar diretório de releases.'], 500);
}

$safeVersion = preg_replace('/[^A-Za-z0-9._-]/', '-', $versionName);
$filename = 'PainelAndroid-' . $safeVersion . '.apk';
$destination = $dir . '/' . $filename;

if (!move_uploaded_file($tmp, $destination)) {
    json_response(['ok' => false, 'error' => 'Não foi possível publicar o APK.'], 500);
}

$sha256 = hash_file('sha256', $destination);
$meta = [
    'version_name' => $versionName,
    'version_code' => $versionCode,
    'sha256' => $sha256,
    'size' => filesize($destination),
    'file' => $filename,
    'published_at' => date(DATE_ATOM),
];

if (file_put_contents(
    $dir . '/latest.json',
    json_encode($meta, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT)
) === false) {
    @unlink($destination);
    json_response(['ok' => false, 'error' => 'Não foi possível salvar metadata da release.'], 500);
}

json_response(['ok' => true, 'release' => $meta]);
