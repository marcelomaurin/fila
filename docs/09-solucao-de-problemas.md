# Solução de problemas

Este guia ajuda a resolver os problemas mais comuns do sistema Fila.

Comece sempre verificando:

- o Fila está aberto;
- o Guichê está aberto;
- o Painel está aberto;
- os computadores estão na mesma rede;
- os IPs estão corretos;
- o firewall não está bloqueando;
- a impressora está ligada e com papel.

---

## O Guichê não chama senha

### Possíveis causas

- o Fila não está aberto;
- o IP do Fila está errado no Guichê;
- o computador do Guichê está fora da rede;
- o firewall bloqueou a porta 8095;
- não há senha aguardando naquela fila.

### Como resolver

1. Confira se o Fila está aberto.
2. Confira o IP do computador do Fila.
3. Abra a configuração do Guichê.
4. Corrija o IP do Fila.
5. Verifique se existe senha emitida naquela fila.
6. Libere a porta 8095 no firewall.
7. Teste novamente.

---

## Aparece mensagem de fila vazia

### O que significa

A fila selecionada não possui senha aguardando.

### Como resolver

1. Vá até o Fila.
2. Emita uma senha daquele tipo.
3. Volte ao Guichê.
4. Chame novamente.

---

## A senha aparece no Guichê, mas não aparece no Painel

### Possíveis causas

- Painel fechado;
- IP do Painel errado no Guichê;
- opção de painel desativada;
- firewall do Painel bloqueando a porta 8196;
- Painel e Guichê em redes diferentes.

### Como resolver

1. Abra o Painel.
2. Descubra o IP do computador do Painel.
3. Corrija o IP no Guichê.
4. Verifique se a opção de painel está ativada.
5. Libere a porta 8196 no firewall do Painel.
6. Teste novamente.

---

## A impressora não imprime

### Possíveis causas

- impressora desligada;
- falta de papel;
- cabo desconectado;
- driver não instalado;
- porta errada;
- modelo errado no Fila;
- outro programa usando a impressora.

### Como resolver

1. Ligue a impressora.
2. Coloque papel.
3. Confira o cabo.
4. Teste a impressão pelo Windows/Linux.
5. Abra o Fila.
6. Confira tipo, modelo e porta da impressora.
7. Salve.
8. Emita uma senha de teste.

---

## A impressora imprime caracteres estranhos

### Possíveis causas

- modelo incorreto;
- protocolo incompatível;
- driver errado;
- configuração de codificação incorreta.

### Como resolver

1. Altere o modelo da impressora no Fila.
2. Teste como impressora genérica.
3. Reinstale o driver correto.
4. Faça um teste de impressão.

---

## O Painel não faz som

### Possíveis causas

- volume baixo ou mudo;
- caixa de som desligada;
- saída de som errada;
- serviço de fala não configurado;
- computador sem dispositivo de áudio.

### Como resolver

1. Aumente o volume.
2. Teste o som no Windows/Linux.
3. Confira a caixa de som.
4. Verifique a saída de áudio.
5. Se usa fala, confira IP e porta do serviço de fala.

---

## O Painel não abre ou trava

### Possíveis causas

- arquivo faltando;
- permissão insuficiente;
- antivírus bloqueando;
- configuração corrompida;
- problema ao baixar imagens/anúncios.

### Como resolver

1. Abra como administrador, se estiver no Windows.
2. Verifique se todos os arquivos do Painel estão na pasta.
3. Desative temporariamente o antivírus para teste.
4. Remova ou corrija a URL de imagens.
5. Reinicie o programa.

---

## O sistema funcionava e parou depois que mudou de computador

### Possíveis causas

- IP mudou;
- firewall novo bloqueando;
- impressora não instalada no novo computador;
- faltam arquivos na pasta;
- configurações antigas não foram copiadas.

### Como resolver

1. Confira o novo IP.
2. Atualize o IP no Guichê.
3. Reinstale a impressora.
4. Libere as portas no firewall.
5. Faça teste completo.

---

## O sistema funcionava e parou depois que reiniciou o roteador

### Possível causa

O roteador pode ter mudado os IPs dos computadores.

### Como resolver

1. Descubra novamente o IP do Fila.
2. Descubra novamente o IP do Painel.
3. Atualize os IPs no Guichê.
4. Se possível, configure IP fixo ou reserva DHCP no roteador.

---

## O Fila perdeu configuração

### Possíveis causas

- usuário sem permissão para gravar configuração;
- pasta de configuração apagada;
- programa executado com outro usuário do Windows;
- arquivo de configuração corrompido.

### Como resolver

1. Configure novamente.
2. Salve.
3. Feche e abra o programa.
4. Verifique se a configuração permaneceu.
5. Se não salvou, execute como administrador ou verifique permissões.

---

## Portas usadas pelo sistema

| Porta | Programa | Uso |
|---:|---|---|
| 8095 | Fila | recebe chamada dos guichês |
| 8096 | Fila | comunicação auxiliar/painel |
| 8196 | Painel | recebe senha chamada |

---

## Teste rápido de rede

No computador do Guichê, tente pingar o computador do Fila.

No Windows:

```text
ping 192.168.0.10
```

Troque `192.168.0.10` pelo IP real do Fila.

Se não responder, pode haver problema de rede, IP ou firewall.

---

## Checklist de atendimento técnico

```text
[ ] Fila aberto
[ ] Guichê aberto
[ ] Painel aberto
[ ] IP do Fila correto
[ ] IP do Painel correto
[ ] Porta 8095 liberada
[ ] Porta 8196 liberada
[ ] Impressora ligada
[ ] Papel OK
[ ] Driver instalado
[ ] Teste de senha realizado
```
