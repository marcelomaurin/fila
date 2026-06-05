# Visão geral para usuários

O **Projeto Fila** é um sistema para controlar atendimento por senha.

Ele serve para lugares onde as pessoas retiram uma senha e aguardam serem chamadas em um painel, como:

- recepções;
- unidades de saúde;
- departamentos públicos;
- clínicas;
- escolas;
- balcões de atendimento;
- laboratórios;
- setores administrativos.

---

## O que o sistema faz

O sistema permite:

- emitir uma senha para o cidadão/cliente;
- imprimir um ticket em impressora térmica;
- separar senhas por tipo de atendimento;
- chamar a próxima senha no guichê;
- mostrar a senha chamada em um painel;
- informar o número do guichê;
- rechamar uma senha;
- reiniciar a numeração quando necessário;
- manter histórico visual no painel.

---

## Programas do sistema

O sistema possui três programas principais.

### 1. Fila

É o programa instalado no computador onde as senhas são emitidas.

Normalmente fica na recepção ou no local onde o usuário retira a senha.

Ele é responsável por:

- criar a senha;
- imprimir o ticket;
- guardar as senhas aguardando atendimento;
- responder aos guichês quando eles chamam a próxima senha.

---

### 2. Guichê

É o programa instalado no computador do atendente.

Ele é responsável por:

- chamar a próxima senha;
- escolher qual tipo de fila será chamada;
- mostrar ao atendente qual senha foi chamada;
- enviar a senha para o painel.

---

### 3. Painel

É o programa instalado no computador, TV ou monitor onde o público vê as senhas chamadas.

Ele é responsável por:

- mostrar a senha atual;
- mostrar o número do guichê;
- mostrar chamadas anteriores;
- emitir som de alerta;
- opcionalmente falar a senha chamada.

---

## Como os programas se comunicam

Os programas precisam estar na mesma rede local.

Exemplo:

```text
Fila    → computador da recepção
Guichê  → computador do atendente
Painel  → computador ligado na TV
```

O Guichê conversa com o Fila para pedir a próxima senha.

Depois, o Guichê conversa com o Painel para mostrar a senha chamada.

---

## Exemplo do uso no dia a dia

1. O usuário chega na recepção.
2. Ele toca/clica no botão da fila desejada.
3. O sistema imprime a senha.
4. O usuário aguarda.
5. O atendente clica em chamar no Guichê.
6. O sistema mostra a senha chamada no Painel.
7. O usuário vai até o guichê indicado.

---

## Tipos de fila

O sistema pode trabalhar com até cinco tipos de fila.

Exemplo:

- Normal;
- Prioridade;
- Idoso;
- Especial;
- Retorno.

Os nomes podem ser configurados.

---

## O que precisa estar funcionando

Para o sistema funcionar bem, confira:

- os computadores estão ligados;
- todos estão na mesma rede;
- o Fila está aberto;
- o Guichê está configurado com o IP correto do Fila;
- o Painel está aberto;
- a impressora está instalada, se for usada;
- o firewall não está bloqueando as portas do sistema.
