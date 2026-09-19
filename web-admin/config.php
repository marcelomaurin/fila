<?php
declare(strict_types=1);

const DEFAULT_DB_RELATIVE = '../fila.db';

function fila_db_path(): string
{
    $env = getenv('FILA_DB_PATH');
    if ($env !== false && trim($env) !== '') {
        return $env;
    }

    return __DIR__ . '/' . DEFAULT_DB_RELATIVE;
}

function fila_admin_token(): string
{
    $token = getenv('FILA_ADMIN_TOKEN');
    return $token === false ? '' : trim($token);
}

function require_admin_token(): void
{
    $expected = fila_admin_token();
    if ($expected === '') {
        http_response_code(503);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode([
            'ok' => false,
            'error' => 'FILA_ADMIN_TOKEN não configurado no servidor.'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    $provided = $_SERVER['HTTP_X_ADMIN_TOKEN'] ?? ($_POST['token'] ?? '');
    if (!hash_equals($expected, (string)$provided)) {
        http_response_code(401);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['ok' => false, 'error' => 'Token inválido.'], JSON_UNESCAPED_UNICODE);
        exit;
    }
}
