# Módulo Guichê

O **Guichê** é o módulo usado pelo atendente para chamar a próxima senha.

Ele conecta ao módulo **Fila**, solicita uma senha e envia a chamada para o **PainelDesk**.

---

## Função no sistema

```text
Atendente clica em chamar
        ↓
Guichê solicita próxima senha ao Fila
        ↓
Guichê recebe a senha
        ↓
Guichê envia a chamada ao Painel
```

---


## Ciclo de atendimento no Guichê

A partir da versão **1.28**, o Guichê possui uma barra inferior criada em tempo de execução com as ações:

- **Iniciar atendimento** — disponível quando a senha está em `CHAMADA`;
- **Finalizar** — disponível quando a senha está em `EM_ATENDIMENTO`;
- **Ausente** — disponível para senha chamada ou em atendimento;
- **Cancelar** — disponível para senha chamada ou em atendimento e solicita um motivo.

As ações são enviadas ao servidor Fila pela porta `8095` usando o protocolo de ciclo de atendimento. O Guichê aguarda a confirmação `ATENDIMENTO:OK` antes de atualizar o estado local.

A árvore de senhas continua funcionando como histórico e rechamada. As ações de ciclo atuam somente sobre a **senha ativa do guichê**, evitando alterar acidentalmente uma senha antiga selecionada no histórico.

Em erro de conexão, a operação pendente é cancelada localmente e os botões são liberados novamente.

---
## Principais funcionalidades

- chamada da próxima senha;
- seleção do tipo de fila;
- rechamada da última senha;
- configuração do IP do Fila;
- configuração do número do guichê;
- envio da senha chamada para até três painéis;
- histórico visual de senhas chamadas;
- gravação de logs locais.

---

## Projeto Lazarus

Arquivo do projeto:

```text
Guiche/Guiche.lpi
```

Principais arquivos:

| Arquivo | Descrição |
|---|---|
| `src/main.pas` | tela principal e comunicação TCP |
| `setup.pas` | configuração de IPs, painel e número do guichê |
| `setmain.pas` | persistência das configurações |
| `log.pas` | janela/log de operação |

---

## Integração

O Guichê integra-se com:

- **Fila** pela porta `8095`, para solicitar a próxima senha;
- **PainelDesk** pela porta `8196`, para exibir a senha chamada;
- até três painéis configuráveis.

---

## Documentação para usuário

- [Instalar e configurar o Guichê](../docs/04-instalar-guiche.md)
- [Operação diária](../docs/08-operacao-diaria.md)
- [Solução de problemas](../docs/09-solucao-de-problemas.md)


## Build reproduzível no Linux

O Guichê agora possui compilação integral automatizada em `.github/workflows/guiche-build.yml`.

O workflow:

- instala Lazarus, Free Pascal e GTK2;
- baixa o lNet 0.6.5;
- compila e registra `lnetbase` e `lnetvisual`;
- executa `lazbuild Guiche/Guiche.lpi`;
- verifica o executável produzido;
- publica o artefato `Guiche-linux-x86_64`.

As dependências antigas `DataPortLasarus` e `indylaz` foram removidas do Guichê porque os componentes associados não participavam mais do fluxo ativo. A comunicação do Guichê permanece baseada em lNet.

Isso torna a compilação Linux reproduzível no CI sem depender da configuração pessoal do Lazarus/Online Package Manager.
