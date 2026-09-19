<?php
declare(strict_types=1);

require_once __DIR__ . '/../db.php';
require_admin_token();

$pdo = db();
ensure_panel_schema($pdo);

$rows = $pdo->query(
    "SELECT painel_id,nome,unidade,ip,versao,porta,tcp_status,uptime_seg,call_count," .
    "ultima_senha,ultimo_guiche,ultimo_erro,last_seen,tts_enabled,chime_enabled,ads_url," .
    "desired_port,desired_tts,desired_chime,desired_ads_url," .
    "CASE WHEN last_seen IS NOT NULL AND " .
    "(strftime('%s','now') - strftime('%s',last_seen)) <= 90 THEN 1 ELSE 0 END AS online " .
    "FROM painel ORDER BY online DESC, unidade, nome, painel_id"
)->fetchAll();

json_response(['ok' => true, 'panels' => $rows]);
