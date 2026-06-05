# Instalação e configuração do Guichê

O **Guichê** é o programa usado pelo atendente para chamar a próxima senha.

Ele deve ser instalado em cada computador de atendimento.

---

## Para que serve o Guichê

O Guichê serve para:

- chamar a próxima senha;
- escolher qual fila será chamada;
- mostrar ao atendente a senha chamada;
- rechamar uma senha;
- enviar a chamada para o Painel;
- manter histórico local das senhas chamadas.

---

## Onde instalar

Instale o Guichê no computador de cada atendente.

Exemplo:

```text
Computador do atendente 1
Programa: Guichê
Número do guichê: 1
IP do Fila: 192.168.0.10
IP do Painel: 192.168.0.20
```

Se existirem vários atendentes, cada computador deve ter um número de guichê diferente.

---

## Antes de configurar

Você precisa saber:

- o IP do computador onde o Fila está rodando;
- o número deste guichê;
- o IP do Painel, se for usar painel;
- se o computador está na mesma rede do Fila.

Anote:

```text
IP do Fila:   ______________________
IP do Painel: ______________________
Número do guichê: _________________
```

---

## Primeira execução

1. Abra o programa **Guichê**.
2. Acesse a tela de configuração.
3. Informe o IP do Fila.
4. Informe o número do guichê.
5. Informe o IP do Painel.
6. Marque a opção de enviar para o painel, se existir.
7. Salve.
8. Teste chamando uma senha.

---

## Configurar IP do Fila

O IP do Fila é o endereço do computador onde o programa **Fila** está aberto.

Exemplo:

```text
192.168.0.10
```

Se esse IP estiver errado, o Guichê não conseguirá chamar senha.

---

## Configurar número do guichê

Cada atendente deve ter um número.

Exemplo:

```text
Guichê 1
Guichê 2
Guichê 3
```

No sistema, informe apenas o número:

```text
1
2
3
```

Esse número aparecerá no Painel quando a senha for chamada.

---

## Configurar Painel

O Guichê pode enviar chamadas para até três painéis.

Em uma instalação simples, use apenas o Painel 1.

Exemplo:

```text
Painel 1: 192.168.0.20
Painel 2: vazio
Painel 3: vazio
```

Se não houver painel, desative a opção de painel.

---

## Como chamar uma senha

1. Abra o Guichê.
2. Escolha o tipo de fila.
3. Clique no botão correspondente.
4. Aguarde a resposta do Fila.
5. A senha chamada aparecerá na tela.
6. Se o painel estiver configurado, a senha também aparecerá no Painel.

---

## Como rechamar uma senha

Use a opção de rechamar quando o usuário não viu ou não ouviu a chamada.

A rechamada envia novamente a última senha ao Painel.

---

## Histórico de chamadas

O Guichê mantém uma lista visual das senhas chamadas.

Essa lista ajuda o atendente a consultar chamadas recentes.

---

## Logs

O Guichê grava logs locais na pasta:

```text
logs/
```

O arquivo tem nome parecido com:

```text
guiche_2026-06-05.log
```

Use esses logs para verificar erros de conexão.

---

## Portas usadas

| Porta | Destino | Uso |
|---:|---|---|
| 8095 | Fila | solicitar próxima senha |
| 8196 | Painel | enviar senha chamada |

---

## Teste básico do Guichê

1. Abra o Fila.
2. Emita uma senha.
3. Abra o Painel.
4. Abra o Guichê.
5. Clique para chamar a fila correspondente.
6. Confira se a senha aparece no Guichê.
7. Confira se a senha aparece no Painel.

---

## Problemas comuns

### Mensagem de fila vazia

Significa que não há senha aguardando naquela fila.

Emita uma senha no Fila e tente novamente.

---

### Guichê não conecta no Fila

Verifique:

- o Fila está aberto;
- o IP do Fila está correto;
- o computador do Guichê está na mesma rede;
- a porta 8095 está liberada;
- o firewall do computador do Fila permite conexão.

---

### A senha aparece no Guichê, mas não aparece no Painel

Verifique:

- o Painel está aberto;
- o IP do Painel está correto no Guichê;
- a opção de painel está marcada;
- a porta 8196 está liberada no computador do Painel;
- o firewall do computador do Painel permite conexão.

---

### Número do guichê aparece errado

Abra a configuração do Guichê e corrija o número.

Cada computador de atendimento deve ter seu próprio número.
