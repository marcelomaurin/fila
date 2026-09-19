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
