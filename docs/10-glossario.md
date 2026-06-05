# Glossário

Este glossário explica os principais termos usados no sistema Fila.

---

## Fila

É o programa principal do sistema.

Ele emite senhas, imprime tickets e controla a ordem de atendimento.

---

## Guichê

É o programa usado pelo atendente para chamar a próxima senha.

Também pode significar o local físico onde o atendente fica.

Exemplo:

```text
Guichê 1
Guichê 2
```

---

## Painel

É a tela vista pelo público.

Mostra a senha chamada e o número do guichê.

---

## Senha

É o código entregue ao usuário para aguardar atendimento.

Exemplo:

```text
N001
P002
I003
```

---

## Ticket

É o papel impresso com a senha.

Normalmente é impresso em impressora térmica.

---

## Impressora térmica

É uma impressora de cupom, parecida com impressora de caixa.

Ela usa papel térmico e normalmente não usa tinta.

---

## IP

É o endereço do computador na rede.

Exemplo:

```text
192.168.0.10
```

O Guichê precisa saber o IP do Fila e o IP do Painel.

---

## Rede local

É a rede interna do local.

Normalmente é a rede do roteador, cabo ou Wi-Fi.

Os computadores do Fila, Guichê e Painel precisam estar na mesma rede local.

---

## Firewall

É uma proteção do sistema operacional que pode bloquear comunicação de rede.

Se o firewall bloquear, o Guichê pode não conseguir falar com o Fila ou com o Painel.

---

## Porta de rede

É um número usado para um programa receber comunicação.

O sistema usa principalmente:

| Porta | Uso |
|---:|---|
| 8095 | Guichê chama senha no Fila |
| 8096 | comunicação auxiliar do Fila |
| 8196 | Guichê envia senha ao Painel |

---

## Porta COM

É o nome de uma porta serial no Windows.

Exemplo:

```text
COM3
COM5
COM13
```

Pode ser usada por impressoras seriais ou adaptadores USB-serial.

---

## Driver

É o programa que permite ao sistema operacional conversar com um equipamento.

Exemplo:

- driver da impressora;
- driver USB-serial.

---

## Reset de senha

É a ação de zerar a numeração das senhas.

Use com cuidado, normalmente no início do expediente.

---

## Rechamar

É chamar novamente a última senha.

Use quando a pessoa não ouviu ou não viu a chamada.

---

## Fila vazia

Significa que não existe senha aguardando naquela fila.

Para resolver, emita uma nova senha no Fila.

---

## Contador

É um programa auxiliar que pode registrar chamadas em banco SQLite.

Normalmente é usado em configurações mais avançadas.

---

## SQLite

É um banco de dados simples em arquivo.

No projeto, pode ser usado pelo módulo Contador para registrar chamadas.

---

## Serviço de fala

É um recurso opcional para falar a senha chamada.

Exemplo:

```text
Senha N001, dirija-se ao guichê 1
```

Se não for usado, o sistema continua funcionando normalmente.
