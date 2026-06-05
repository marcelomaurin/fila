# Módulo Fila

O **Fila** é o módulo principal do sistema. Ele emite senhas, controla as filas, imprime tickets e atende as solicitações vindas dos guichês.

---

## Função no sistema

```text
Usuário retira senha
        ↓
Fila gera e imprime ticket
        ↓
Guichê solicita próxima senha
        ↓
Fila devolve a senha ao Guichê
```

---

## Principais funcionalidades

- emissão de tickets;
- controle de até cinco filas;
- impressão em impressora térmica;
- configuração de empresa e localização;
- configuração de nomes e abreviações das filas;
- comunicação com Guichê pela porta `8095`;
- comunicação auxiliar/painel pela porta `8096`;
- reset manual e programado da numeração;
- salvamento das listas pendentes;
- integração opcional com executável externo.

---

## Projeto Lazarus

Arquivo do projeto:

```text
Fila/Fila.lpi
```

Principais arquivos:

| Arquivo | Descrição |
|---|---|
| `main.pas` | tela principal, configuração e servidor TCP |
| `menu.pas` | tela de emissão de senhas |
| `setmain.pas` | configurações salvas em `fila.cfg` |
| `printer/` | rotinas de impressão |
| `toolsfalar.pas` | integração com fala |

---

## Integração

O Fila integra-se com:

- **Guichê**: recebe pedido de próxima senha;
- **PainelDesk**: fornece informações auxiliares de painel;
- **impressora térmica**: imprime o ticket;
- **Contador ou outro executável externo**: registra evento de chamada, se configurado.

---

## Documentação para usuário

- [Instalar e configurar o Fila](../docs/03-instalar-fila.md)
- [Primeiro uso](../docs/07-primeiro-uso.md)
- [Solução de problemas](../docs/09-solucao-de-problemas.md)
