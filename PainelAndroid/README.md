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
