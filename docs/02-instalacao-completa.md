# Instalação completa do sistema

Este guia explica como instalar o sistema completo em uma rede local.

Use este documento quando for instalar o **Fila**, o **Guichê**, o **Painel** e a impressora.

---

## Antes de começar

Verifique se você tem:

- os arquivos executáveis do sistema;
- um computador para o Fila;
- um computador para cada Guichê;
- um computador ou TV para o Painel;
- rede local funcionando;
- impressora térmica, se for imprimir tickets;
- acesso de administrador no Windows, se precisar instalar driver ou liberar firewall.

---

## Ordem correta de instalação

Instale nesta ordem:

1. impressora no computador do Fila;
2. programa **Fila**;
3. programa **Painel**;
4. programa **Guichê**;
5. teste completo de emissão e chamada.

---

## Exemplo de distribuição dos computadores

```text
Computador da recepção
  Programa: Fila
  Impressora: conectada aqui
  IP sugerido: 192.168.0.10

Computador do atendente 1
  Programa: Guichê
  Número do guichê: 1

Computador do atendente 2
  Programa: Guichê
  Número do guichê: 2

TV ou computador do painel
  Programa: PainelDesk
  IP sugerido: 192.168.0.20
```

---

## Configurar IP fixo ou reservado

É recomendado que o computador do **Fila** e o computador do **Painel** tenham IP fixo ou IP reservado no roteador.

Isso evita que o IP mude sozinho e o Guichê pare de localizar o Fila ou o Painel.

Anote:

```text
IP do Fila:   ______________________
IP do Painel: ______________________
```

---

## Liberar firewall

O sistema usa comunicação pela rede.

Libere as portas:

| Porta | Onde liberar | Finalidade |
|---:|---|---|
| 8095 | computador do Fila | receber chamadas dos guichês |
| 8096 | computador do Fila | comunicação auxiliar/painel |
| 8196 | computador do Painel | receber chamadas dos guichês |

No Windows, quando o sistema perguntar se permite acesso à rede, escolha permitir em rede privada/local.

---

## Instalar o Fila

1. Copie a pasta ou executável do **Fila** para o computador da recepção.
2. Execute o programa.
3. Configure empresa, local, filas e impressora.
4. Salve a configuração.
5. Inicie o funcionamento.

Detalhes: [Instalação e configuração do Fila](03-instalar-fila.md)

---

## Instalar o Painel

1. Copie a pasta ou executável do **PainelDesk** para o computador/TV do painel.
2. Execute o programa.
3. Configure IP, porta e opções de fala, se necessário.
4. Deixe o Painel aberto.

Detalhes: [Instalação e configuração do Painel](05-instalar-painel.md)

---

## Instalar o Guichê

1. Copie a pasta ou executável do **Guichê** para o computador do atendente.
2. Execute o programa.
3. Configure o IP do Fila.
4. Configure o número do guichê.
5. Configure o IP do Painel.
6. Salve a configuração.
7. Teste a chamada.

Detalhes: [Instalação e configuração do Guichê](04-instalar-guiche.md)

---

## Teste final

Depois de instalar tudo:

1. abra o Fila;
2. abra o Painel;
3. abra o Guichê;
4. emita uma senha no Fila;
5. no Guichê, clique para chamar a próxima senha;
6. confira se a senha aparece no Painel;
7. confira se a impressora imprimiu corretamente.

---

## Se o teste falhar

Veja:

- [Solução de problemas](09-solucao-de-problemas.md)

Os problemas mais comuns são:

- IP errado;
- firewall bloqueando;
- Painel fechado;
- Fila fechado;
- impressora sem driver;
- porta de impressora incorreta.
