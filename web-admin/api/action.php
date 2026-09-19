<?php
declare(strict_types=1);

require_once __DIR__ . '/../db.php';
require_admin_token();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['ok' => false, 'error' => 'Método não permitido.'], 405);
}

$input = json_decode(file_get_contents('php://input'), true);
if (!is_array($input)) {
    $input = $_POST;
}

$action = strtoupper(trim((string)($input['action'] ?? '')));
$codigo = trim((string)($input['codigo'] ?? ''));
$guiche = trim((string)($input['guiche'] ?? ''));
$motivo = trim((string)($input['motivo'] ?? ''));

if ($codigo === '') {
    json_response(['ok' => false, 'error' => 'Código da senha obrigatório.'], 422);
}

$map = [
    'INICIAR' => [['CHAMADA'], 'EM_ATENDIMENTO', 'inicio_atendimento_em', 'INICIO_ATENDIMENTO'],
    'FINALIZAR' => [['EM_ATENDIMENTO'], 'FINALIZADA', 'fim_atendimento_em', 'FINALIZADA'],
    'AUSENTE' => [['CHAMADA', 'EM_ATENDIMENTO'], 'AUSENTE', 'fim_atendimento_em', 'AUSENTE'],
    'CANCELAR' => [['AGUARDANDO', 'CHAMADA', 'EM_ATENDIMENTO'], 'CANCELADA', 'fim_atendimento_em', 'CANCELADA'],
];

if (!isset($map[$action])) {
    json_response(['ok' => false, 'error' => 'Ação inválida.'], 422);
}

[$from, $to, $dateColumn, $eventType] = $map[$action];
$pdo = db();
$pdo->beginTransaction();

try {
    $id = latest_ticket_id($pdo, $codigo, $from);
    if ($id === null) {
        $pdo->rollBack();
        json_response(['ok' => false, 'error' => 'Transição não permitida para a senha informada.'], 409);
    }

    $sql = "UPDATE senha SET status=:status, {$dateColumn}=:data";
    if ($guiche !== '') {
        $sql .= ', guiche=:guiche';
    }
    if ($action === 'CANCELAR') {
        $sql .= ', motivo_fim=:motivo';
    }
    $sql .= ' WHERE id=:id';

    $stmt = $pdo->prepare($sql);
    $params = [
        ':status' => $to,
        ':data' => date('Y-m-d\TH:i:s.v'),
        ':id' => $id,
    ];
    if ($guiche !== '') {
        $params[':guiche'] = $guiche;
    }
    if ($action === 'CANCELAR') {
        $params[':motivo'] = $motivo;
    }
    $stmt->execute($params);

    $evt = $pdo->prepare(
        'INSERT INTO evento(senha_id,codigo,fila_id,guiche,tipo,detalhes,criado_em) ' .
        'SELECT id,codigo,fila_id,:guiche,:tipo,:detalhes,:data FROM senha WHERE id=:id'
    );
    $evt->execute([
        ':guiche' => $guiche,
        ':tipo' => $eventType,
        ':detalhes' => $motivo,
        ':data' => date('Y-m-d\TH:i:s.v'),
        ':id' => $id,
    ]);

    $pdo->commit();
    json_response(['ok' => true, 'action' => $action, 'codigo' => $codigo, 'status' => $to]);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    json_response(['ok' => false, 'error' => $e->getMessage()], 500);
}
