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

function ensure_panel_schema(PDO $pdo): void
{
    static $done = false;
    if ($done) {
        return;
    }

    $pdo->exec(
        "CREATE TABLE IF NOT EXISTS painel (" .
        "painel_id TEXT PRIMARY KEY," .
        "nome TEXT," .
        "unidade TEXT," .
        "ip TEXT," .
        "versao TEXT," .
        "porta INTEGER," .
        "tcp_status TEXT," .
        "uptime_seg INTEGER NOT NULL DEFAULT 0," .
        "call_count INTEGER NOT NULL DEFAULT 0," .
        "ultima_senha TEXT," .
        "ultimo_guiche TEXT," .
        "ultimo_erro TEXT," .
        "last_seen TEXT," .
        "tts_enabled INTEGER NOT NULL DEFAULT 1," .
        "chime_enabled INTEGER NOT NULL DEFAULT 1," .
        "ads_url TEXT NOT NULL DEFAULT ''," .
        "desired_port INTEGER," .
        "desired_tts INTEGER," .
        "desired_chime INTEGER," .
        "desired_ads_url TEXT" .
        ")"
    );

    $pdo->exec(
        "CREATE TABLE IF NOT EXISTS painel_comando (" .
        "id INTEGER PRIMARY KEY AUTOINCREMENT," .
        "painel_id TEXT NOT NULL," .
        "tipo TEXT NOT NULL," .
        "payload TEXT," .
        "status TEXT NOT NULL DEFAULT 'PENDENTE'," .
        "criado_em TEXT NOT NULL," .
        "enviado_em TEXT," .
        "concluido_em TEXT," .
        "resultado TEXT" .
        ")"
    );
    $pdo->exec(
        "CREATE INDEX IF NOT EXISTS idx_painel_comando_estado " .
        "ON painel_comando(painel_id, status, id)"
    );

    $done = true;
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
