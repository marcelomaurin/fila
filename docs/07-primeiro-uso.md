# Primeiro uso do sistema

Este guia mostra como fazer o primeiro teste do sistema depois da instalação.

Siga a ordem com calma. O objetivo é confirmar que o Fila, o Guichê, o Painel e a impressora estão funcionando juntos.

---

## Antes do teste

Confira:

- o Fila está instalado;
- o Guichê está instalado;
- o Painel está instalado;
- a impressora está instalada, se for usada;
- todos os computadores estão na mesma rede;
- o IP do Fila está anotado;
- o IP do Painel está anotado;
- o firewall foi liberado.

---

## Passo 1: abrir o Fila

No computador da recepção:

1. abra o programa **Fila**;
2. confira o nome da empresa/unidade;
3. confira os tipos de fila;
4. confira a impressora;
5. salve a configuração;
6. deixe o Fila aberto.

---

## Passo 2: emitir uma senha de teste

No Fila:

1. clique em uma fila, por exemplo `Normal`;
2. aguarde a senha ser gerada;
3. verifique se a senha apareceu no sistema;
4. verifique se o ticket foi impresso.

Exemplo de senha:

```text
N001
```

---

## Passo 3: abrir o Painel

No computador/TV do painel:

1. abra o **PainelDesk**;
2. deixe o painel visível na tela;
3. confira se não apareceu erro;
4. confira se o computador está com som, se for usar aviso sonoro.

---

## Passo 4: abrir o Guichê

No computador do atendente:

1. abra o programa **Guichê**;
2. confira o IP do Fila;
3. confira o número do guichê;
4. confira o IP do Painel;
5. salve a configuração.

---

## Passo 5: chamar a senha

No Guichê:

1. clique no botão da fila que possui senha aguardando;
2. aguarde a resposta;
3. veja se a senha aparece no Guichê;
4. veja se a senha aparece no Painel.

---

## Resultado esperado

O resultado correto é:

- o Fila emitiu a senha;
- a impressora imprimiu o ticket;
- o Guichê chamou a senha;
- o Painel mostrou a senha e o guichê;
- o som ou fala funcionou, se estiver configurado.

---

## Teste com mais de uma senha

Faça mais um teste:

1. emita três senhas no Fila;
2. chame uma por uma no Guichê;
3. confira se a ordem está correta;
4. confira se o Painel mostra o histórico.

---

## Teste de fila vazia

Depois de chamar todas as senhas:

1. tente chamar novamente;
2. o sistema deve informar que a fila está vazia.

Isso é normal.

---

## Teste de rechamada

No Guichê:

1. chame uma senha;
2. clique em rechamar;
3. confira se o Painel mostra a mesma senha novamente.

Use essa função quando o usuário não ouviu ou não viu a chamada.

---

## Se algo não funcionar

Consulte:

- [Solução de problemas](09-solucao-de-problemas.md)

Problemas comuns no primeiro uso:

- IP do Fila errado no Guichê;
- IP do Painel errado no Guichê;
- firewall bloqueando;
- Painel fechado;
- Fila fechado;
- impressora não instalada;
- porta da impressora errada.
