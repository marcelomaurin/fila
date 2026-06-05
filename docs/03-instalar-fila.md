# Instalação e configuração do Fila

O **Fila** é o programa principal do sistema.

Ele deve ficar no computador onde as senhas serão emitidas e, normalmente, onde a impressora térmica está conectada.

---

## Para que serve o Fila

O Fila serve para:

- emitir senhas;
- imprimir tickets;
- controlar a ordem das filas;
- responder aos guichês;
- guardar as senhas que ainda não foram chamadas;
- configurar os nomes das filas;
- configurar a impressora;
- configurar imagem, empresa e local.

---

## Onde instalar

Instale o Fila no computador da recepção ou do local onde o usuário retira senha.

Exemplo:

```text
Computador da recepção
Programa: Fila
Impressora: conectada neste computador
IP: 192.168.0.10
```

---

## Antes de abrir o Fila

Confira:

- o computador está na rede;
- a impressora está instalada, se for usada;
- o cabo USB/serial da impressora está conectado;
- o firewall permite comunicação local;
- você sabe o IP deste computador.

---

## Como descobrir o IP do computador

No Windows:

1. pressione `Windows + R`;
2. digite `cmd`;
3. pressione Enter;
4. digite:

```text
ipconfig
```

5. procure o campo `Endereço IPv4`.

Exemplo:

```text
192.168.0.10
```

Esse IP será usado nos Guichês.

---

## Primeira execução

1. Abra o programa **Fila**.
2. Informe o nome da empresa ou unidade.
3. Informe a localização.
4. Configure os tipos de fila.
5. Configure a impressora.
6. Configure a imagem/logotipo, se desejar.
7. Clique em salvar.
8. Inicie o modo de emissão de senhas.

---

## Configurar nome da empresa

Use este campo para informar o nome que será exibido no sistema ou ticket.

Exemplos:

```text
Secretaria Municipal da Saúde
Unidade Básica Central
Recepção Principal
```

---

## Configurar localização

Use para indicar o local físico do atendimento.

Exemplos:

```text
Recepção
Ambulatório
Farmácia
Protocolo
```

---

## Configurar tipos de fila

O sistema permite até cinco filas.

Exemplo de configuração:

| Fila | Nome sugerido | Abreviação sugerida |
|---:|---|---|
| 1 | Normal | N |
| 2 | Prioridade | P |
| 3 | Idoso | I |
| 4 | Retorno | R |
| 5 | Exames | E |

Se não quiser usar alguma fila, desmarque ou desabilite aquela fila.

---

## Configurar abreviações

A abreviação aparece antes do número da senha.

Exemplo:

```text
N001
P001
I001
```

Use abreviações curtas, de preferência com uma ou duas letras.

---

## Configurar impressora

No Fila, configure:

- tipo de impressora;
- modelo da impressora;
- porta usada;
- tamanho do papel.

Tipos comuns:

- driver do Windows;
- porta serial;
- bluetooth.

Tamanhos comuns:

- 58 mm;
- 80 mm.

Detalhes: [Instalação e configuração da impressora](06-instalar-impressora.md)

---

## Configurar imagem/logotipo

Se quiser exibir uma imagem ou logotipo:

1. escolha uma imagem no computador;
2. prefira arquivo pequeno;
3. evite imagem muito grande;
4. teste se aparece corretamente na tela de emissão.

---

## Iniciar o atendimento

Depois de configurar:

1. salve as configurações;
2. inicie o modo de atendimento;
3. teste um botão de senha;
4. verifique se a senha aparece na lista;
5. verifique se imprime.

---

## Reset de senhas

O Fila permite resetar a numeração.

Use esta função quando quiser recomeçar do zero.

Exemplo:

- início do dia;
- troca de turno;
- finalização de expediente;
- teste do sistema.

Atenção: use com cuidado, pois isso zera a contagem.

---

## Reset programado

Se ativado, o sistema pode resetar automaticamente em um horário definido.

Exemplo:

```text
06:00
```

Use quando o atendimento sempre começa com senha nova em determinado horário.

---

## Integração externa

O Fila pode chamar um programa externo quando uma senha é chamada.

Essa opção é avançada.

Ela pode ser usada para:

- registrar chamadas em banco de dados;
- gerar estatísticas;
- integrar com outro sistema;
- usar o módulo Contador.

Se não souber o que é isso, deixe desativado.

---

## Portas usadas pelo Fila

O Fila usa:

| Porta | Uso |
|---:|---|
| 8095 | recebe chamadas dos Guichês |
| 8096 | comunicação auxiliar com Painel |

Se o Guichê não conseguir chamar senha, verifique se essas portas estão bloqueadas pelo firewall.

---

## Teste básico do Fila

Faça este teste:

1. abra o Fila;
2. emita uma senha Normal;
3. confira se a senha foi criada;
4. confira se imprimiu;
5. abra o Guichê em outro computador;
6. chame a senha;
7. veja se a senha sai da lista.

---

## Problemas comuns

### A senha não imprime

Verifique:

- impressora ligada;
- cabo conectado;
- driver instalado;
- porta correta;
- papel colocado;
- impressora definida corretamente no Fila.

### O Guichê não chama senha

Verifique:

- o Fila está aberto;
- o IP configurado no Guichê está correto;
- os computadores estão na mesma rede;
- o firewall está liberado;
- a porta 8095 está liberada.

### O sistema perdeu a configuração

Verifique se o usuário do Windows tem permissão para gravar arquivos na pasta de configuração do aplicativo.
