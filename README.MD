# Projeto Fila

Sistema de controle de filas, emissão de tickets, chamada de senhas e exibição em painel, desenvolvido principalmente em **Lazarus / Free Pascal**.

O projeto foi criado para cenários de atendimento em balcão, recepção, unidades públicas, postos de atendimento, unidades de saúde, repartições, escolas, clínicas ou qualquer ambiente onde seja necessário emitir uma senha, organizar a ordem de chamada e mostrar o atendimento em um painel.

Site do projeto: http://maurinsoft.com.br/index.php/projeto-fila/

Vídeo demonstrativo:

[![Demonstração do Projeto Fila](https://img.youtube.com/vi/wPoVD_J6qp4/0.jpg)](https://www.youtube.com/watch?v=wPoVD_J6qp4)

---

## Visão geral

O **Projeto Fila** é formado por vários módulos independentes que trabalham em conjunto por rede local e arquivos de configuração.

A ideia central é simples:

1. o usuário retira uma senha no módulo **Fila**;
2. a senha entra em uma lista de atendimento;
3. o atendente usa o módulo **Guichê** para chamar a próxima senha;
4. o módulo **Fila** devolve a senha chamada;
5. o **Guichê** envia a chamada para o **PainelDesk**;
6. o painel exibe a senha, o guichê e mantém o histórico visual das últimas chamadas;
7. opcionalmente, o módulo **Contador** registra a chamada em banco SQLite.

---

## Documentação dos módulos

Cada módulo possui uma documentação própria:

| Módulo | Documentação | Função principal |
|---|---|---|
| Fila | [Fila/README.md](Fila/README.md) | servidor/emissor de senhas e controlador das filas |
| Guichê | [Guiche/README.md](Guiche/README.md) | terminal do atendente para chamar senhas |
| PainelDesk | [PainelDesk/README.md](PainelDesk/README.md) | painel desktop TCP para exibir senhas chamadas |
| Contador | [Contador/README.md](Contador/README.md) | executável auxiliar para registrar chamadas em SQLite |

---

## Arquitetura geral

```text
+-------------------+          TCP 8095           +-------------------+
|      Guichê       |  ------------------------->  |       Fila        |
| terminal atendente|   solicita próxima senha     | servidor/emissor  |
+-------------------+                              +-------------------+
          |
          | TCP 8196
          | envia senha chamada
          v
+-------------------+
|    PainelDesk     |
| painel de chamada |
+-------------------+

Opcional:

+-------------------+
|     Contador      |
| registra chamada  |
| em SQLite         |
+-------------------+
```

---

## Módulos do sistema

### Fila

O módulo **Fila** é o núcleo do sistema.

Ele permite configurar até cinco filas, emitir tickets, controlar a numeração, salvar a lista de senhas pendentes, escutar os guichês pela porta `8095` e fornecer informações de painel pela porta `8096`.

Também concentra configurações como empresa, localização, tipo de impressora, modelo de impressora, tipo de papel, imagem, fala, painel, fonte, reset programado e integração externa por executável.

![Fila](img/fila.png)

---

### Guichê

O módulo **Guichê** é usado pelo atendente.

Ele conecta ao servidor Fila, chama a próxima senha de uma fila, mantém histórico local, permite rechamar senha e envia a senha chamada para até três painéis configurados.

![Guichê](img/Guiche.png)

---

### PainelDesk

O **PainelDesk** é o painel desktop do sistema.

Ele escuta chamadas TCP na porta `8196`, interpreta mensagens de chamada, exibe a senha atual, mostra o guichê, guarda um pequeno histórico visual, emite alerta sonoro e pode falar a senha usando o módulo auxiliar de fala.

Também possui área de anúncios, com download de imagens a partir de uma URL configurada.

![Painel Desktop](img/paineldesktop.png)

---

### Contador

O **Contador** é um utilitário de console.

Ele recebe parâmetros pela linha de comando e grava registros na tabela `registro` de um banco SQLite. Pode ser usado como integração externa do Fila para persistir eventos de chamada.

Exemplo conceitual:

```text
contador.exe 3 A015 2
```

Nesse exemplo:

- `3` é o número do guichê;
- `A015` é a senha;
- `2` é o tipo de evento.

---

## Portas de comunicação

| Porta | Origem | Destino | Uso |
|---:|---|---|---|
| `8095` | Guichê | Fila | solicitar próxima senha |
| `8096` | Painel/cliente | Fila | consulta/envio de informações de painel no módulo Fila |
| `8196` | Guichê | PainelDesk | enviar senha chamada ao painel |

Em ambiente real, essas portas devem estar liberadas no firewall.

---

## Fluxo funcional

```text
Usuário toca/clica no terminal Fila
        ↓
Fila gera a próxima senha do tipo selecionado
        ↓
Fila imprime o ticket
        ↓
Senha é adicionada à lista da fila correspondente
        ↓
Atendente pressiona o botão da fila no Guichê
        ↓
Guichê envia requisição para o Fila pela porta 8095
        ↓
Fila remove a primeira senha da lista e devolve ao Guichê
        ↓
Guichê mostra a senha chamada e registra no histórico
        ↓
Guichê envia a chamada ao PainelDesk pela porta 8196
        ↓
PainelDesk exibe senha, guichê, pisca, emite som e pode falar a chamada
        ↓
Opcionalmente, Contador registra a chamada no SQLite
```

---

## Estrutura do repositório

```text
fila/
├── Contador/              # utilitário console para registro de chamadas em SQLite
│   └── README.md
├── Fila/                  # aplicação principal de emissão e controle de fila
│   └── README.md
├── Guiche/                # aplicação usada pelo atendente
│   └── README.md
├── Painel/Painel_Laz/     # módulo antigo/Android LAMW relacionado a painel
├── PainelDesk/            # painel desktop TCP
│   └── README.md
├── bin/                   # binários e arquivos de distribuição
├── drivers/               # drivers e dependências externas
├── img/                   # imagens usadas na documentação
├── tools/SQLiteStudio/    # ferramenta auxiliar para SQLite
├── README.MD              # documentação central
└── readme.txt             # instruções antigas de build Android/LAMW
```

---

## Tecnologias usadas

- Lazarus / Free Pascal;
- LCL;
- lNet / `lnetvisual`;
- Indy / `indylaz`;
- Synapse / `laz_synapse`;
- UniqueInstance;
- RxLib / `rxnew`;
- LazSerialPort;
- DataPortLasarus;
- Fortes Report for Lazarus;
- ZeosDB no módulo Contador;
- SQLite no módulo Contador;
- LAMW em parte do projeto Android;
- Inno Setup em materiais de empacotamento Windows.

---

## Requisitos gerais para desenvolvimento

- Lazarus instalado;
- Free Pascal compatível;
- pacotes Lazarus exigidos por cada projeto;
- drivers de impressora térmica, quando usados;
- `sqlite3.dll` compatível com a arquitetura do executável, quando usar o Contador;
- permissões de firewall para as portas `8095`, `8096` e `8196`;
- permissão de porta serial, quando usar impressora serial;
- ambiente LAMW configurado, caso vá trabalhar com a versão Android.

---

## Compilação rápida

### Fila

Abra no Lazarus:

```text
Fila/Fila.lpi
```

Compile o projeto e execute a aplicação `Fila`.

### Guichê

Abra no Lazarus:

```text
Guiche/Guiche.lpi
```

Compile o projeto e execute a aplicação `Guiche`.

### PainelDesk

Abra o projeto do painel desktop na pasta:

```text
PainelDesk/
```

Compile e execute o painel.

### Contador

Abra no Lazarus:

```text
Contador/src/contador.lpi
```

Compile o executável de console.

---

## Configuração básica de implantação

Exemplo de rede local:

```text
Computador 1 - Servidor Fila
IP: 192.168.0.10
Portas: 8095 e 8096
Impressora térmica conectada

Computador 2 - Guichê 1
IP Fila: 192.168.0.10
Número do guichê: 1
Painel 1: 192.168.0.20

Computador 3 - PainelDesk
IP: 192.168.0.20
Porta: 8196
```

Ordem recomendada de execução:

1. iniciar o **Fila**;
2. configurar e iniciar o **PainelDesk**;
3. configurar e iniciar o **Guichê**;
4. testar emissão de senha;
5. testar chamada pelo guichê;
6. validar exibição no painel.

---

## Protocolos de mensagem observados

O sistema usa mensagens simples em texto.

Exemplos observados nos fontes:

```text
Fila:<tipo>><guiche>;
Fila:<senha>
FILA:<senha>><guiche>;
GUICHE><guiche>:<senha>;
GRUPO><grupo>:<descricao>;
```

Essas mensagens são usadas entre Fila, Guichê e PainelDesk.

---

## Observações importantes

- O Fila deve estar ativo antes do Guichê solicitar senhas.
- O PainelDesk precisa estar escutando a porta `8196` para receber chamadas.
- O firewall pode bloquear a comunicação TCP.
- As configurações são salvas em arquivos locais.
- O módulo Contador depende de SQLite, Zeos e `sqlite3.dll` no Windows.
- Existem partes antigas do projeto, principalmente relacionadas ao Android/LAMW.
- A estrutura tem histórico de evolução, portanto alguns nomes e pastas ainda refletem decisões legadas.

---

## Status do projeto

O projeto é funcional e possui histórico de uso real.

Órgão citado na documentação original:

- Secretaria da Saúde de Ribeirão Preto

---

## Melhorias recomendadas

Para evolução futura:

- formalizar o protocolo de comunicação em um arquivo próprio;
- criar releases por versão com executáveis separados;
- revisar nomes de pastas e padronizar caixa alta/baixa;
- adicionar licença explícita ao repositório;
- revisar módulos antigos do Android/LAMW;
- criar instalador atualizado para Windows;
- separar documentação de usuário, instalação e desenvolvedor;
- adicionar prints atualizados de todos os módulos;
- adicionar testes de comunicação TCP;
- validar compatibilidade Windows/Linux por módulo.

---

## Autor

Desenvolvido por **Marcelo Maurin Martins**.

GitHub: https://github.com/marcelomaurin

Site: http://maurinsoft.com.br/

---

## English summary

**Fila** is a queue management system built mainly with Lazarus / Free Pascal.

It includes:

- a ticket issuing server/application;
- a counter desk application to call the next ticket;
- a desktop display panel;
- a console helper to register calls in SQLite;
- TCP communication over a local network;
- configurable queue types;
- thermal printer support.

Main ports:

- `8095`: Guichê to Fila;
- `8096`: Fila panel/query channel;
- `8196`: Guichê to PainelDesk.

---

## Resumen en español

**Fila** es un sistema de control de turnos desarrollado principalmente con Lazarus / Free Pascal.

Incluye:

- aplicación principal para emisión de tickets;
- módulo de guiché para llamar el próximo número;
- panel desktop para mostrar las llamadas;
- utilitario de consola para registrar llamadas en SQLite;
- comunicación TCP en red local;
- soporte para impresoras térmicas.

Puertos principales:

- `8095`: Guiché hacia Fila;
- `8096`: canal de panel/consulta de Fila;
- `8196`: Guiché hacia PainelDesk.
