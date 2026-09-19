<?php
declare(strict_types=1);

require_once __DIR__ . '/../db.php';
require_admin_token();

$pdo = db();
$sql = <<<'SQL'
SELECT
  SUM(CASE WHEN status='AGUARDANDO' THEN 1 ELSE 0 END) aguardando,
  SUM(CASE WHEN status='CHAMADA' THEN 1 ELSE 0 END) chamadas,
  SUM(CASE WHEN status='EM_ATENDIMENTO' THEN 1 ELSE 0 END) em_atendimento,
  SUM(CASE WHEN status='FINALIZADA' AND substr(fim_atendimento_em,1,10)=date('now','localtime') THEN 1 ELSE 0 END) finalizadas_hoje,
  SUM(CASE WHEN status='AUSENTE' AND substr(fim_atendimento_em,1,10)=date('now','localtime') THEN 1 ELSE 0 END) ausentes_hoje,
  SUM(CASE WHEN status='CANCELADA' AND substr(fim_atendimento_em,1,10)=date('now','localtime') THEN 1 ELSE 0 END) canceladas_hoje,
  AVG(CASE WHEN chamada_em IS NOT NULL THEN (julianday(chamada_em)-julianday(emitida_em))*86400 END) espera_media_seg,
  AVG(CASE WHEN fim_atendimento_em IS NOT NULL AND inicio_atendimento_em IS NOT NULL
    THEN (julianday(fim_atendimento_em)-julianday(inicio_atendimento_em))*86400 END) atendimento_medio_seg
FROM senha
SQL;

$row = $pdo->query($sql)->fetch() ?: [];

json_response(['ok' => true, 'metrics' => $row]);
