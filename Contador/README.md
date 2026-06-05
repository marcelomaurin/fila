# Módulo Contador

O **Contador** é um utilitário de console usado para registrar chamadas em banco SQLite.

Ele pode ser chamado pelo módulo **Fila** como executável externo, por meio da configuração de análise/evento.

---

## Função no sistema

```text
Fila chama senha
        ↓
Fila executa programa externo configurado
        ↓
Contador recebe guichê, senha e tipo
        ↓
Contador grava registro no SQLite
```

---

## Principais funcionalidades

- execução por linha de comando;
- leitura de parâmetros obrigatórios;
- conexão com SQLite usando Zeos;
- criação de arquivo de configuração padrão;
- validação de `sqlite3.dll` no Windows;
- gravação na tabela `registro`.

---

## Projeto Lazarus

Arquivo do projeto:

```text
Contador/src/contador.lpi
```

Arquivo principal:

```text
Contador/src/contador.lpr
```

---

## Uso básico

Formato:

```text
contador.exe <guiche> <senha> <tipo>
```

Exemplo:

```text
contador.exe 3 A015 2
```

Significado:

| Parâmetro | Descrição |
|---|---|
| `3` | número do guichê |
| `A015` | senha chamada |
| `2` | tipo de evento |

---

## Banco de dados

O Contador usa SQLite.

Arquivo de configuração padrão:

```text
config.cfg
```

Exemplo de configuração:

```ini
[database]
protocol=sqlite-3
dbpath=.\
database=contador.db
driverpath=.\sqlite3.dll
```

A tabela esperada é:

```sql
registro (guiche, senha, tipo)
```

---

## Integração

O Contador pode ser usado pelo módulo **Fila** quando `PATHANALISE` aponta para o executável do Contador.

Assim, cada chamada de senha pode ser registrada em SQLite.

---

## Observações

- No Windows, a `sqlite3.dll` precisa ser compatível com a arquitetura do executável.
- Executável 64 bits deve usar DLL 64 bits.
- Executável 32 bits deve usar DLL 32 bits.
- O banco pode ser criado automaticamente, mas a tabela `registro` precisa existir com as colunas esperadas.
