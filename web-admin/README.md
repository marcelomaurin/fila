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
```

Sem `FILA_ADMIN_TOKEN`, as APIs retornam HTTP 503.

Abra `index.php`, informe o token e use o painel. O token fica armazenado apenas no navegador via `localStorage` e é enviado no cabeçalho `X-Admin-Token`.

## APIs

- `GET api/stats.php` — indicadores;
- `GET api/tickets.php?limit=200` — senhas recentes;
- `POST api/action.php` — ações `INICIAR`, `FINALIZAR`, `AUSENTE` e `CANCELAR`.

O painel não substitui o protocolo TCP do Guichê; ele é uma interface administrativa adicional.
