# PainelAndroid (Android TV / TV Box)

Módulo de exibição de chamadas de senhas para **Smart TVs Android** e **TV Boxes** do **Projeto Fila**, baseado na interface, protocolo e lógica do **PainelDesk**.

---

## 📺 Principais Funcionalidades

- **Layout 16:9 Widescreen otimizado para TV (10-foot UI)**: visualização nítida de senhas e guichês a longa distância.
- **Navegação 100% via controle remoto (D-Pad)**: compatível com controle de TV / TV Box.
- **Servidor TCP integrado na porta `8196`**: recebe comandos diretamente do módulo `Guichê`.
- **Exibição do IP local**: facilita saber o IP para cadastrar nos guichês.
- **Animação de chamada**: destaque visual com pisca em vermelho e alerta sonoro.
- **Voz / Text-To-Speech (TTS pt-BR)**: sintetiza e anuncia *"Senha [SENHA], dirija-se ao guichê [GUICHÊ]"*.
- **Histórico de Últimas Chamadas (Anteriores)**: exibe até as últimas 4 senhas chamadas.
- **Relógio e Data em tempo real** e barra de mensagens no rodapé.
- **Tela de Configurações**: ajuste de porta TCP, ativação de voz/som, URL de mídia e simulação de chamada.

---

## 📡 Protocolo de Rede (TCP)

O aplicativo escuta conexões TCP na porta configurada (padrão `8196`).

### Formatos de Mensagem Suportados:
1. `FILA:>GUICHE:SENHA;` (exemplo: `FILA:>01:A001;`)
2. `GUICHE:...`

---

## 📦 Instalação e Execução

O pacote compilado está localizado em:
`fila/bin/PainelAndroid.apk`

1. Copie o arquivo `PainelAndroid.apk` para um pendrive ou instale via `adb install PainelAndroid.apk`.
2. Abra o aplicativo na Smart TV ou TV Box.
3. Observe o endereço IP exibido no cabeçalho superior (ex: `IP: 192.168.1.100 | Porta: 8196`).
4. Configure esse IP e Porta no módulo **Guichê** no campo de destino do painel.

---

## 🛠️ Compilação via Código-Fonte

Pré-requisitos:
- Android SDK (API 34)
- Java JDK 17 ou 21

No terminal:
```bash
cd D:\projetos\maurinsoft\fila\PainelAndroid
gradlew assembleDebug
```
O APK será gerado em `app/build/outputs/apk/debug/app-debug.apk`.


## Robustez TCP e persistência

A versão 2.3.0 não usa mais leitura por linha. O servidor acumula o stream TCP até o delimitador `;`, permitindo:

- mensagem dividida em vários pacotes;
- várias mensagens no mesmo pacote;
- mensagens sem `\n`;
- limite de tamanho para evitar crescimento indefinido do buffer.

A chamada atual e as quatro chamadas anteriores são persistidas localmente e restauradas após reinício da Activity/aplicativo.

## CI Android

O workflow `PainelAndroid build` executa testes unitários JVM e gera o APK debug automaticamente com Android SDK 34 / Java 17.


## Operação contínua em TV / TV Box

O receptor TCP foi movido para `PanelService`, executado como `ForegroundService`.

Com isso:

- o servidor TCP não depende mais da `MainActivity`;
- recriar ou fechar a tela não encerra a recepção de chamadas;
- o serviço usa `START_STICKY`;
- alterações de porta reiniciam somente o servidor TCP;
- som e TTS são executados pelo serviço;
- a Activity recebe eventos internos e apenas atualiza a interface;
- `BootReceiver` inicia o serviço após `BOOT_COMPLETED`;
- a chamada atual e o histórico são restaurados depois de reinício.

O manifesto declara as permissões de foreground service e inicialização após boot necessárias para Android TV/TV Box.


## PainelAndroid 2.4.0 — operação autônoma

A versão 2.4.0 adiciona recursos para uso prolongado em TV/TV Box:

- reabertura automática do servidor TCP após falha;
- espera progressiva de 2, 5, 10 e 30 segundos entre tentativas;
- verificação periódica do estado do servidor;
- registro persistente de status online/offline e último erro;
- contador de chamadas recebidas;
- registro de data/hora da última chamada;
- contador de tentativas de reconexão;
- horário de início do serviço para cálculo de uptime;
- modo imersivo (fullscreen + ocultação das barras do sistema);
- tela mantida ligada enquanto o painel está em exibição;
- seção de diagnóstico nas configurações com versão, IP, porta, TCP, uptime, chamadas, última chamada, reconexões e último erro.

O modo imersivo não depende de privilégios de Device Owner e continua permitindo acesso às configurações pela tecla Menu/Settings do controle.


## PainelAndroid 2.5.0 — administração central

A versão 2.5.0 permite cadastrar cada TV em uma central web.

O painel mantém um `panel_id` persistente e envia heartbeat periódico com estado operacional, IP, porta, versão, uptime, contador de chamadas, última senha, último erro e configurações de áudio.

A central pode responder com configuração desejada e comandos remotos. Atualmente são suportados:

- `TEST_CALL`;
- `RESTART_TCP`;
- `CONFIG`.

O protocolo administrativo usa HTTP/JSON e token separado do token do administrador web. A ausência da central não interrompe o recebimento TCP local.


## PainelAndroid 2.6.0 — mídia institucional

A versão 2.6.0 transforma `adsUrl` em uma playlist real de mídia institucional.

### Formato da playlist

A URL deve retornar JSON:

```json
{
  "items": [
    {"type":"image","url":"https://servidor/banner.jpg","duration":12},
    {"type":"video","url":"https://servidor/video.mp4","duration":0}
  ]
}
```

Tipos aceitos:

- `image`: JPG/JPEG/PNG/WEBP; `duration` define por quantos segundos a imagem fica na tela;
- `video`: MP4/WEBM; o vídeo avança quando a reprodução termina.

### Comportamento

- depois do tempo ocioso configurado, a playlist ocupa a área principal do painel;
- uma nova chamada interrompe imediatamente imagem/vídeo;
- senha e guichê voltam à frente;
- depois do novo período de ociosidade, a playlist recomeça;
- a playlist é atualizada periodicamente;
- os arquivos são armazenados no cache interno do aplicativo;
- se a rede cair, a última playlist e os arquivos já baixados continuam disponíveis;
- arquivos individuais são limitados a 200 MB e a playlist a 50 itens.

Para forçar atualização de um arquivo mantendo o mesmo nome no servidor, prefira alterar a URL (por exemplo usando `?v=2`) ou publicar com novo nome.

### Tempo ocioso

A tela Configurações permite escolher o tempo antes da mídia, entre 5 e 3600 segundos.


## PainelAndroid 2.7.0 — release e atualização

A versão 2.7.0 adiciona o fluxo de atualização assistida.

A TV consulta periodicamente:

```text
GET web-admin/api/panel/update.php
X-Panel-Token: FILA_PANEL_TOKEN
```

Quando existe `version_code` maior que o instalado:

1. baixa o APK em cache privado;
2. limita o APK a 250 MB;
3. calcula SHA-256;
4. compara com o hash publicado pela central;
5. cria notificação de atualização;
6. ao selecionar a notificação, abre o instalador oficial do Android.

Android comum não permite instalação silenciosa sem Device Owner/root. Por isso a atualização é automática até o download/validação, mas a confirmação final de instalação permanece no sistema operacional.

A tela Configurações também possui **Verificar Atualização** para checagem imediata.

### Assinatura de release no GitHub Actions

Configure estes GitHub Actions Secrets:

```text
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
```

`ANDROID_KEYSTORE_BASE64` deve conter o keystore codificado em Base64. Com os quatro Secrets presentes, o workflow gera o artefato `PainelAndroid-release` com APK assinado e `update.json`.

Sem os Secrets, o CI continua compilando a variante release não assinada para detectar regressões, mas não publica artefato de produção.

## Soak test em TV real

O utilitário:

```text
tools/panel_android_soak.py
```

envia chamadas reais para a porta TCP da TV e registra sucessos/falhas.

Exemplos:

```bash
python tools/panel_android_soak.py --host 192.168.1.50 --hours 24
python tools/panel_android_soak.py --host 192.168.1.50 --hours 72 --interval 2
python tools/panel_android_soak.py --host 192.168.1.50 --hours 168 --mode mixed
```

O modo `mixed` alterna mensagens normais, fragmentadas, agrupadas e reconexões. O relatório é gravado em `panel-soak-report.json`.

Além disso, o CI executa `PanelProtocolSoakTest`, com dezenas de milhares de mensagens, em toda alteração do PainelAndroid.
