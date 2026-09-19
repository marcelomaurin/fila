<?php
declare(strict_types=1);

require_once __DIR__ . '/../db.php';
require_admin_token();

$limit = (int)($_GET['limit'] ?? 100);
$limit = max(1, min(500, $limit));

$stmt = db()->prepare(
    'SELECT id,codigo,fila_id,prioridade,status,emitida_em,chamada_em,' .
    'inicio_atendimento_em,fim_atendimento_em,guiche,motivo_fim ' .
    'FROM senha ORDER BY id DESC LIMIT :limite'
);
$stmt->bindValue(':limite', $limit, PDO::PARAM_INT);
$stmt->execute();

json_response(['ok' => true, 'tickets' => $stmt->fetchAll()]);
