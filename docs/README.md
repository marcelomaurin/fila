# Documentação do Usuário - Projeto Fila

Esta pasta contém a documentação para usuários finais, técnicos de suporte e responsáveis pela instalação do sistema **Fila**.

A linguagem desta documentação é simples e prática. O objetivo é permitir que uma pessoa sem conhecimento de programação consiga instalar, configurar e operar o sistema.

---

## Ordem recomendada de leitura

1. [Visão geral para usuários](01-visao-geral.md)
2. [Instalação completa do sistema](02-instalacao-completa.md)
3. [Instalação e configuração do Fila](03-instalar-fila.md)
4. [Instalação e configuração do Guichê](04-instalar-guiche.md)
5. [Instalação e configuração do Painel](05-instalar-painel.md)
6. [Instalação e configuração da impressora](06-instalar-impressora.md)
7. [Primeiro uso do sistema](07-primeiro-uso.md)
8. [Operação diária](08-operacao-diaria.md)
9. [Solução de problemas](09-solucao-de-problemas.md)
10. [Glossário](10-glossario.md)

---

## Componentes do sistema

O sistema é formado por três programas principais:

| Programa | Quem usa | Para que serve |
|---|---|---|
| Fila | recepção ou local de retirada de senha | emite a senha e controla a fila |
| Guichê | atendente | chama a próxima senha |
| Painel | público | mostra a senha chamada |

Também existe um módulo auxiliar chamado **Contador**, usado para registrar chamadas em banco de dados quando configurado.

---

## Instalação mínima

Para o sistema funcionar, normalmente você precisa de:

- 1 computador para rodar o **Fila**;
- 1 impressora térmica, se quiser imprimir tickets;
- 1 ou mais computadores com **Guichê** para os atendentes;
- 1 computador, TV ou monitor com **Painel**;
- rede local funcionando entre os computadores.

---

## Exemplo simples de instalação

```text
Recepção:
  Programa: Fila
  Impressora: conectada ao computador da recepção
  IP: 192.168.0.10

Guichê 1:
  Programa: Guichê
  IP do Fila configurado: 192.168.0.10
  Número do guichê: 1

Painel:
  Programa: PainelDesk
  IP: 192.168.0.20
  Recebe chamadas do Guichê
```

---

## Quando algo não funcionar

Consulte primeiro:

- [Solução de problemas](09-solucao-de-problemas.md)

Os erros mais comuns são:

- IP configurado errado;
- firewall bloqueando a comunicação;
- Fila não iniciado antes do Guichê;
- Painel não iniciado;
- impressora sem driver;
- porta de impressora errada;
- cabo USB/serial desconectado.
