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
