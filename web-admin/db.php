<?php
declare(strict_types=1);

require_once __DIR__ . '/config.php';

function db(): PDO
{
    static $pdo = null;
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $path = fila_db_path();
    $pdo = new PDO('sqlite:' . $path, null, null, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    $pdo->exec('PRAGMA busy_timeout=3000');

    return $pdo;
}

function json_response(array $payload, int $status = 200): never
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function latest_ticket_id(PDO $pdo, string $codigo, array $statuses): ?int
{
    if ($statuses === []) {
        return null;
    }

    $holders = implode(',', array_fill(0, count($statuses), '?'));
    $sql = "SELECT id FROM senha WHERE codigo=? AND status IN ($holders) ORDER BY id DESC LIMIT 1";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(array_merge([$codigo], $statuses));
    $id = $stmt->fetchColumn();

    return $id === false ? null : (int)$id;
}
