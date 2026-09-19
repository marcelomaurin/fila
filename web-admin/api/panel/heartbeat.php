<?php
declare(strict_types=1);

require_once __DIR__ . '/../../db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['ok' => false, 'error' => 'Método não permitido.'], 405);
}

require_panel_token();
$pdo = db();
ensure_panel_schema($pdo);

$input = json_decode(file_get_contents('php://input'), true);
if (!is_array($input)) {
    json_response(['ok' => false, 'error' => 'JSON inválido.'], 400);
}

$panelId = trim((string)($input['panel_id'] ?? ''));
if ($panelId === '' || !preg_match('/^[A-Za-z0-9._-]{3,80}$/', $panelId)) {
    json_response(['ok' => false, 'error' => 'panel_id inválido.'], 422);
}

$ackId = (int)($input['ack_command_id'] ?? 0);
if ($ackId > 0) {
    $ack = $pdo->prepare(
        "UPDATE painel_comando SET status='CONCLUIDO', concluido_em=datetime('now'), resultado=:resultado " .
        "WHERE id=:id AND painel_id=:painel"
    );
    $ack->execute([
        ':resultado' => (string)($input['ack_result'] ?? 'OK'),
        ':id' => $ackId,
        ':painel' => $panelId,
    ]);
}

$sql = <<<'SQL'
INSERT INTO painel(
    painel_id,nome,unidade,ip,versao,porta,tcp_status,uptime_seg,call_count,
    ultima_senha,ultimo_guiche,ultimo_erro,last_seen,tts_enabled,chime_enabled,ads_url
) VALUES(
    :painel_id,:nome,:unidade,:ip,:versao,:porta,:tcp_status,:uptime_seg,:call_count,
    :ultima_senha,:ultimo_guiche,:ultimo_erro,datetime('now'),:tts_enabled,:chime_enabled,:ads_url
)
ON CONFLICT(painel_id) DO UPDATE SET
    nome=excluded.nome,
    unidade=excluded.unidade,
    ip=excluded.ip,
    versao=excluded.versao,
    porta=excluded.porta,
    tcp_status=excluded.tcp_status,
    uptime_seg=excluded.uptime_seg,
    call_count=excluded.call_count,
    ultima_senha=excluded.ultima_senha,
    ultimo_guiche=excluded.ultimo_guiche,
    ultimo_erro=excluded.ultimo_erro,
    last_seen=datetime('now'),
    tts_enabled=excluded.tts_enabled,
    chime_enabled=excluded.chime_enabled,
    ads_url=excluded.ads_url
SQL;

$stmt = $pdo->prepare($sql);
$stmt->execute([
    ':painel_id' => $panelId,
    ':nome' => trim((string)($input['name'] ?? '')),
    ':unidade' => trim((string)($input['unit'] ?? '')),
    ':ip' => trim((string)($input['ip'] ?? '')),
    ':versao' => trim((string)($input['version'] ?? '')),
    ':porta' => (int)($input['port'] ?? 8196),
    ':tcp_status' => !empty($input['tcp_online']) ? 'ONLINE' : 'OFFLINE',
    ':uptime_seg' => max(0, (int)($input['uptime_sec'] ?? 0)),
    ':call_count' => max(0, (int)($input['call_count'] ?? 0)),
    ':ultima_senha' => trim((string)($input['last_ticket'] ?? '')),
    ':ultimo_guiche' => trim((string)($input['last_desk'] ?? '')),
    ':ultimo_erro' => trim((string)($input['last_error'] ?? '')),
    ':tts_enabled' => !empty($input['tts_enabled']) ? 1 : 0,
    ':chime_enabled' => !empty($input['chime_enabled']) ? 1 : 0,
    ':ads_url' => trim((string)($input['ads_url'] ?? '')),
]);

$cfg = $pdo->prepare(
    'SELECT desired_port,desired_tts,desired_chime,desired_ads_url FROM painel WHERE painel_id=:id'
);
$cfg->execute([':id' => $panelId]);
$config = $cfg->fetch() ?: [];

$cmd = $pdo->prepare(
    "SELECT id,tipo,payload FROM painel_comando " .
    "WHERE painel_id=:painel AND (" .
    "status='PENDENTE' OR (status='ENVIADO' AND enviado_em <= datetime('now','-60 seconds'))" .
    ") ORDER BY id LIMIT 1"
);
$cmd->execute([':painel' => $panelId]);
$command = $cmd->fetch();

$responseCommand = null;
if ($command) {
    $mark = $pdo->prepare(
        "UPDATE painel_comando SET status='ENVIADO', enviado_em=datetime('now') WHERE id=:id"
    );
    $mark->execute([':id' => (int)$command['id']]);

    $payload = json_decode((string)($command['payload'] ?? ''), true);
    if (!is_array($payload)) {
        $payload = [];
    }

    $responseCommand = [
        'id' => (int)$command['id'],
        'type' => (string)$command['tipo'],
        'payload' => $payload,
    ];
}

json_response([
    'ok' => true,
    'server_time' => date(DATE_ATOM),
    'config' => [
        'port' => isset($config['desired_port']) ? $config['desired_port'] : null,
        'tts_enabled' => isset($config['desired_tts']) ? $config['desired_tts'] : null,
        'chime_enabled' => isset($config['desired_chime']) ? $config['desired_chime'] : null,
        'ads_url' => $config['desired_ads_url'] ?? null,
    ],
    'command' => $responseCommand,
]);
