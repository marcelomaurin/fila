# Instalação e configuração do Painel

O **Painel** é o programa que mostra para o público qual senha foi chamada e para qual guichê a pessoa deve ir.

No repositório, o módulo de painel desktop é chamado de **PainelDesk**.

---

## Para que serve o Painel

O Painel serve para:

- mostrar a senha chamada;
- mostrar o número do guichê;
- exibir chamadas anteriores;
- emitir som de alerta;
- opcionalmente falar a senha;
- exibir imagens/anúncios quando não houver chamada ativa.

---

## Onde instalar

Instale o Painel no computador que será ligado à TV ou ao monitor do público.

Exemplo:

```text
Computador do Painel
Programa: PainelDesk
IP: 192.168.0.20
Porta: 8196
Ligado à TV por HDMI
```

---

## Antes de configurar

Confira:

- o computador está na rede;
- o IP do computador é conhecido;
- a TV ou monitor está ligado;
- o som está funcionando, se for usar aviso sonoro;
- o firewall permite entrada na porta 8196.

Anote:

```text
IP do Painel: ______________________
```

Esse IP será configurado no Guichê.

---

## Primeira execução

1. Abra o programa **PainelDesk**.
2. Configure o IP/porta do painel, se necessário.
3. Configure o serviço de fala, se for usar.
4. Configure a URL de imagens/anúncios, se for usar.
5. Salve.
6. Deixe o Painel aberto.
7. Faça um teste chamando uma senha pelo Guichê.

---

## Porta do Painel

O Painel recebe chamadas pela porta:

```text
8196
```

Essa porta precisa estar liberada no firewall do computador do Painel.

---

## Configurar o Guichê para enviar ao Painel

No computador do atendente, abra o **Guichê** e informe o IP do Painel.

Exemplo:

```text
Painel 1: 192.168.0.20
```

Se tiver mais de um painel, configure Painel 2 e Painel 3 também.

---

## Teste básico

1. Abra o Painel.
2. Abra o Fila.
3. Emita uma senha no Fila.
4. Abra o Guichê.
5. Chame a senha.
6. Verifique se aparece no Painel.

---

## Como deve aparecer

Quando uma senha é chamada, o Painel deve mostrar:

- senha atual;
- número do guichê;
- histórico das últimas chamadas;
- aviso sonoro ou fala, se configurado.

---

## Anúncios e imagens

O Painel pode exibir imagens em uma área de anúncios.

Ele possui configuração de URL para baixar imagens.

Use essa função apenas se houver uma pasta ou endereço web preparado com imagens.

Recomendações:

- use imagens leves;
- prefira JPG ou PNG;
- evite arquivos muito grandes;
- teste antes de colocar em produção.

---

## Serviço de fala

O Painel pode tentar falar a senha chamada usando configuração de IP e porta do serviço de fala.

Se você não usa esse recurso, deixe a configuração padrão ou desative.

Se usar, confira:

- serviço de fala está ativo;
- IP correto;
- porta correta;
- som do computador está ligado.

---

## Problemas comuns

### A senha não aparece no Painel

Verifique:

- o Painel está aberto;
- o IP do Painel está correto no Guichê;
- o Guichê está com a opção de painel ativada;
- a porta 8196 está liberada;
- os computadores estão na mesma rede.

---

### O Painel aparece, mas não faz som

Verifique:

- volume do Windows/Linux;
- caixa de som ligada;
- saída de áudio correta;
- serviço de fala, se estiver usando fala.

---

### O Painel não baixa imagens

Verifique:

- o computador tem internet ou acesso à URL configurada;
- a URL está correta;
- a pasta tem imagens válidas;
- o antivírus/firewall não bloqueia o acesso.

---

### O Painel abre em monitor errado

Se houver mais de uma tela:

1. configure no sistema operacional qual tela é a principal;
2. arraste o Painel para a TV/monitor correto;
3. deixe em tela cheia ou maximizado, se necessário.
