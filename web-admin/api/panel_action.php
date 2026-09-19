<?php
declare(strict_types=1);

require_once __DIR__ . '/../db.php';
require_admin_token();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['ok' => false, 'error' => 'Método não permitido.'], 405);
}

$pdo = db();
ensure_panel_schema($pdo);
$input = json_decode(file_get_contents('php://input'), true);
if (!is_array($input)) {
    $input = $_POST;
}

$panelId = trim((string)($input['panel_id'] ?? ''));
$action = strtoupper(trim((string)($input['action'] ?? '')));
if ($panelId === '') {
    json_response(['ok' => false, 'error' => 'Painel obrigatório.'], 422);
}

$exists = $pdo->prepare('SELECT COUNT(*) FROM painel WHERE painel_id=:id');
$exists->execute([':id' => $panelId]);
if ((int)$exists->fetchColumn() === 0) {
    json_response(['ok' => false, 'error' => 'Painel não encontrado.'], 404);
}

$payload = [];

if ($action === 'TEST_CALL') {
    $payload = [
        'ticket' => trim((string)($input['ticket'] ?? 'T001')),
        'desk' => trim((string)($input['desk'] ?? '01')),
    ];
} elseif ($action === 'RESTART_TCP') {
    $payload = [];
} elseif ($action === 'CONFIG') {
    $port = isset($input['port']) ? (int)$input['port'] : null;
    if ($port !== null && ($port < 1 || $port > 65535)) {
        json_response(['ok' => false, 'error' => 'Porta inválida.'], 422);
    }

    $tts = isset($input['tts_enabled']) ? (!empty($input['tts_enabled']) ? 1 : 0) : null;
    $chime = isset($input['chime_enabled']) ? (!empty($input['chime_enabled']) ? 1 : 0) : null;
    $ads = array_key_exists('ads_url', $input) ? trim((string)$input['ads_url']) : null;

    $upd = $pdo->prepare(
        'UPDATE painel SET desired_port=:port,desired_tts=:tts,desired_chime=:chime,' .
        'desired_ads_url=:ads,nome=COALESCE(:nome,nome),unidade=COALESCE(:unidade,unidade) ' .
        'WHERE painel_id=:id'
    );
    $upd->execute([
        ':port' => $port,
        ':tts' => $tts,
        ':chime' => $chime,
        ':ads' => $ads,
        ':nome' => array_key_exists('name', $input) ? trim((string)$input['name']) : null,
        ':unidade' => array_key_exists('unit', $input) ? trim((string)$input['unit']) : null,
        ':id' => $panelId,
    ]);

    $payload = [
        'port' => $port,
        'tts_enabled' => $tts,
        'chime_enabled' => $chime,
        'ads_url' => $ads,
    ];
} else {
    json_response(['ok' => false, 'error' => 'Ação inválida.'], 422);
}

$stmt = $pdo->prepare(
    "INSERT INTO painel_comando(painel_id,tipo,payload,status,criado_em) " .
    "VALUES(:painel,:tipo,:payload,'PENDENTE',datetime('now'))"
);
$stmt->execute([
    ':painel' => $panelId,
    ':tipo' => $action,
    ':payload' => json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
]);

json_response([
    'ok' => true,
    'command_id' => (int)$pdo->lastInsertId(),
    'panel_id' => $panelId,
    'action' => $action,
]);
