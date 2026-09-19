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

if (!in_array($action, ['INICIAR', 'FINALIZAR', 'AUSENTE', 'CANCELAR'], true)) {
    json_response(['ok' => false, 'error' => 'Ação inválida.'], 422);
}
if ($codigo === '') {
    json_response(['ok' => false, 'error' => 'Código da senha obrigatório.'], 422);
}

$host = getenv('FILA_HOST');
$host = ($host === false || trim($host) === '') ? '127.0.0.1' : trim($host);
$port = (int)(getenv('FILA_PORT') ?: 8095);
if ($port < 1 || $port > 65535) {
    $port = 8095;
}

// O protocolo V2 de ciclo usa ">" e ";" como delimitadores.
$clean = static fn(string $s): string => str_replace(['>', ';', "", "
"], ' ', $s);
$command = 'ATENDIMENTO:' . $action . '>' . $clean($codigo) . '>' .
    $clean($guiche) . '>' . $clean($motivo) . ';';

$errno = 0;
$errstr = '';
$socket = @fsockopen($host, $port, $errno, $errstr, 3.0);
if ($socket === false) {
    json_response([
        'ok' => false,
        'error' => "Servidor Fila indisponível em {$host}:{$port}: {$errstr}"
    ], 503);
}

stream_set_timeout($socket, 3);
fwrite($socket, $command);
$response = trim((string)fgets($socket, 2048));
fclose($socket);

$expected = 'ATENDIMENTO:OK>' . $action . '>' . $codigo . ';';
if (strcasecmp($response, $expected) !== 0) {
    json_response([
        'ok' => false,
        'error' => 'Operação recusada pelo servidor Fila.',
        'response' => $response
    ], 409);
}

json_response([
    'ok' => true,
    'action' => $action,
    'codigo' => $codigo,
    'server' => "{$host}:{$port}"
]);
