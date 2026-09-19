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
FILA_PANEL_TOKEN=um-token-compartilhado-com-as-tvs
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


## Administração central dos Painéis TV

Abra `panels.php` para acompanhar os PainelAndroid registrados.

Cada TV pode configurar:

- ID estável do painel;
- nome amigável;
- unidade/local;
- URL do `web-admin`;
- token do painel.

O `PanelService` envia heartbeat a cada 30 segundos para:

```text
POST api/panel/heartbeat.php
X-Panel-Token: FILA_PANEL_TOKEN
```

A central considera o painel online quando recebeu heartbeat nos últimos 90 segundos.

### Ações remotas

A página de painéis permite:

- chamada de teste;
- reinício do servidor TCP;
- atualização de nome/unidade;
- alteração da porta TCP;
- habilitar/desabilitar TTS;
- habilitar/desabilitar alerta sonoro;
- alterar a URL de mídia/anúncios.

Os comandos são enfileirados no SQLite. A TV os recebe no heartbeat e confirma a execução no heartbeat seguinte. Se a resposta se perder, comandos enviados sem confirmação podem ser entregues novamente após 60 segundos.

A administração central é opcional: se URL/token não forem configurados na TV, o painel continua operando normalmente pelo protocolo TCP local.


## Mídia institucional

O diretório:

```text
web-admin/media/files/
```

pode receber arquivos:

- JPG/JPEG;
- PNG;
- WEBP;
- MP4;
- WEBM.

O endpoint:

```text
web-admin/media/playlist.php
```

varre essa pasta e gera automaticamente uma playlist JSON, com imagens configuradas por padrão para 12 segundos.

Exemplo de URL a configurar no painel:

```text
http://servidor/fila/web-admin/media/playlist.php
```

Também existe `media/playlist.sample.json` como referência para playlists mantidas manualmente.


## Gestão de mídia pelo navegador

Abra `media.php`.

A interface permite:

- upload de JPG/JPEG/PNG/WEBP/MP4/WEBM;
- exclusão;
- ativar/desativar item;
- ordenar a playlist;
- configurar duração das imagens;
- copiar a URL da playlist usada pelas TVs.

As alterações são persistidas em `media/playlist-config.json`, criado em runtime. Os arquivos continuam em `media/files/`.

A configuração do PHP deve permitir o tamanho desejado de upload (`upload_max_filesize` e `post_max_size`). A aplicação limita cada mídia a 200 MB.

## Releases do PainelAndroid

Abra `releases.php` para publicar o APK de produção.

Informe:

- `version_name`;
- `version_code`;
- APK release assinado.

O servidor:

- aceita APK de até 250 MB;
- calcula SHA-256;
- grava em `releases/`;
- atualiza `releases/latest.json`;
- disponibiliza a metadata em `api/panel/update.php`.

A TV nunca instala um APK cujo SHA-256 seja diferente do valor publicado.
