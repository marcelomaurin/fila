# Administração Web do Projeto Fila

Painel PHP simples para consultar o mesmo `fila.db` usado pelo núcleo Lazarus.

## Requisitos

- PHP 8.x;
- extensão `pdo_sqlite`;
- servidor web com acesso de leitura/escrita ao arquivo `fila.db`.

## Configuração

Defina no ambiente do servidor web:

```text
FILA_DB_PATH=/caminho/para/fila.db
FILA_ADMIN_TOKEN=um-token-longo-e-secreto
FILA_HOST=127.0.0.1
FILA_PORT=8095
```

Sem `FILA_ADMIN_TOKEN`, as APIs retornam HTTP 503.

Abra `index.php`, informe o token e use o painel. O token fica armazenado apenas no navegador via `localStorage` e é enviado no cabeçalho `X-Admin-Token`.

## APIs

- `GET api/stats.php` — indicadores;
- `GET api/tickets.php?limit=200` — senhas recentes;
- `POST api/action.php` — ações `INICIAR`, `FINALIZAR`, `AUSENTE` e `CANCELAR`.

As consultas leem o `fila.db`. As ações administrativas são enviadas ao servidor Fila por TCP (`FILA_HOST`/`FILA_PORT`) para manter SQLite, memória e arquivos TXT sincronizados. O painel não substitui o protocolo do Guichê; ele é uma interface administrativa adicional.
