# Instalação e configuração da impressora

A impressora é usada pelo módulo **Fila** para imprimir o ticket de senha.

Normalmente é uma impressora térmica de cupom, parecida com impressoras de caixa.

---

## Tipos de impressora suportados pelo sistema

O sistema possui suporte a:

- impressora instalada pelo driver do sistema operacional;
- impressora serial;
- impressora bluetooth;
- modelos Elgin;
- impressora térmica genérica 58 mm.

---

## Onde a impressora deve ficar

A impressora deve ficar conectada ao computador onde roda o programa **Fila**.

Exemplo:

```text
Computador da recepção
  Programa: Fila
  Impressora térmica conectada por USB ou serial
```

---

## Antes de configurar no Fila

Confira:

- a impressora está ligada;
- tem papel;
- a tampa está fechada;
- o cabo USB/serial está conectado;
- o driver foi instalado;
- o Windows/Linux reconheceu a impressora;
- a impressora consegue imprimir uma página de teste.

---

## Instalação pelo driver do Windows

1. Conecte a impressora no computador.
2. Instale o driver do fabricante.
3. Abra o painel de impressoras do Windows.
4. Verifique se a impressora aparece na lista.
5. Imprima uma página de teste.
6. Abra o programa Fila.
7. Configure o tipo de impressora como driver/sistema, quando disponível.
8. Salve e teste a emissão de uma senha.

---

## Instalação por porta serial

Algumas impressoras usam porta serial real ou adaptador USB-serial.

Nesse caso, você precisa saber o nome da porta.

No Windows, normalmente é algo como:

```text
COM1
COM2
COM3
COM13
```

No Linux, normalmente é algo como:

```text
/dev/ttyS0
/dev/ttyUSB0
```

No Fila, configure essa porta no campo de porta da impressora.

---

## Como descobrir a porta no Windows

1. Clique com botão direito no menu iniciar.
2. Abra **Gerenciador de Dispositivos**.
3. Procure por **Portas (COM e LPT)**.
4. Veja o número da COM.

Exemplo:

```text
USB-SERIAL CH340 (COM5)
```

Nesse caso, configure:

```text
COM5
```

---

## Como descobrir a porta no Linux

Abra o terminal e use:

```bash
dmesg | grep tty
```

ou:

```bash
ls /dev/ttyUSB*
```

Exemplo:

```text
/dev/ttyUSB0
```

---

## Permissão no Linux

Se o sistema não conseguir acessar a impressora serial no Linux, pode ser falta de permissão.

Geralmente o usuário precisa estar no grupo `dialout`.

Exemplo:

```bash
sudo usermod -a -G dialout $USER
```

Depois reinicie a sessão ou o computador.

---

## Configurar no Fila

No programa **Fila**, configure:

- tipo da impressora;
- modelo da impressora;
- porta;
- tamanho do papel.

Tamanhos comuns:

| Papel | Uso comum |
|---|---|
| 58 mm | impressora pequena |
| 80 mm | impressora maior |

---

## Teste de impressão

Depois de configurar:

1. salve a configuração;
2. emita uma senha de teste;
3. veja se o ticket sai corretamente;
4. confira se o corte está bom;
5. confira se o texto está legível.

---

## Problemas comuns

### A impressora não imprime nada

Verifique:

- está ligada;
- está com papel;
- cabo conectado;
- driver instalado;
- porta correta;
- modelo correto no Fila;
- o Windows imprime página de teste.

---

### Imprime caracteres estranhos

Pode ser configuração errada de modelo, protocolo ou codificação.

Tente:

- trocar o modelo da impressora no Fila;
- usar impressora genérica;
- verificar driver correto;
- verificar se o papel e linguagem da impressora são compatíveis.

---

### Imprime, mas não corta papel

Nem toda impressora suporta corte automático.

Verifique:

- modelo da impressora;
- driver correto;
- configuração de corte no driver;
- se a impressora tem guilhotina.

---

### Erro de porta COM

Verifique:

- número correto da COM;
- se outro programa está usando a impressora;
- se o cabo USB mudou de porta;
- se o adaptador USB-serial foi reconhecido.

---

### Funcionava e parou após trocar USB

O Windows pode mudar o número da porta COM quando a impressora é conectada em outra entrada USB.

Solução:

1. veja a nova porta no Gerenciador de Dispositivos;
2. abra o Fila;
3. atualize a porta;
4. salve;
5. teste novamente.
