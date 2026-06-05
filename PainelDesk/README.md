# Módulo PainelDesk

O **PainelDesk** é o painel desktop do sistema Fila.

Ele recebe as chamadas enviadas pelo **Guichê** e exibe para o público a senha chamada e o número do guichê.

---

## Função no sistema

```text
Guichê chama senha
        ↓
Guichê envia mensagem TCP para o PainelDesk
        ↓
PainelDesk mostra senha e guichê
        ↓
Painel emite alerta visual/sonoro
```

---

## Principais funcionalidades

- escuta TCP na porta `8196`;
- exibe senha atual;
- exibe número do guichê;
- mantém histórico visual das últimas chamadas;
- emite alerta sonoro;
- pode falar a senha chamada usando serviço auxiliar de fala;
- pode exibir imagens/anúncios baixados de uma URL configurada.

---

## Principais arquivos

| Arquivo | Descrição |
|---|---|
| `main.pas` | tela principal, servidor TCP e exibição das chamadas |
| `setmain.pas` | configuração do painel, IP, porta, URL e fala |
| `toolsfalar.pas` | integração com serviço de fala |
| `funcoes.pas` | funções auxiliares |

---

## Integração

O PainelDesk integra-se com:

- **Guichê**, recebendo a senha chamada pela porta `8196`;
- serviço opcional de fala;
- URL externa para baixar imagens/anúncios.

---

## Documentação para usuário

- [Instalar e configurar o Painel](../docs/05-instalar-painel.md)
- [Primeiro uso](../docs/07-primeiro-uso.md)
- [Solução de problemas](../docs/09-solucao-de-problemas.md)
