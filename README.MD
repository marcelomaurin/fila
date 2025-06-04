# Projeto Fila

## Visao Geral
O Projeto **Fila** oferece um sistema simples de gerenciamento de senhas. Ele permite imprimir tickets numerados, chamar o proximo cliente pelos guiches e exibir as senhas atendidas em um painel. O codigo fonte esta dividido em diversos modulos escritos em Lazarus (Pascal) e Python.

## Componentes
- **Fila** – Aplicacao responsavel por emitir o ticket de senha. Normalmente utiliza uma impressora termica e pode ser executada em um terminal touch screen.
- **Guiche** – Programa utilizado pelo atendente para chamar o proximo numero na fila.
- **Painel** – Aplicacao que exibe em uma tela (tablet, TV ou computador) as chamadas realizadas.
- **PainelDesk** – Versao para desktop do painel, incluindo o script `srvfalar.py` que sintetiza voz das chamadas.

## Instalacao
1. Compile os projetos Lazarus localizados nas pastas `Fila`, `Guiche`, `Painel` e `PainelDesk`. Os executaveis prontos tambem estao em `bin/`.
2. Instale as dependencias do servidor de voz:
   ```bash
   pip install -r requirements.txt
   ```
3. Execute `srvfalar.py` para iniciar o servico de audio:
   ```bash
   python PainelDesk/srvfalar.py
   ```

## Estrutura do Repositorio
- `Fila/`, `Guiche/`, `Painel/` e `PainelDesk/` – Codigo fonte dos aplicativos.
- `bin/` – Binarios pre-compilados para Windows.
- `drivers/` – Instaladores de drivers para impressoras termicas.

Assista a [demonstracao em video](https://youtu.be/wPoVD_J6qp4) para ver o funcionamento completo.

## Licenca
O projeto sera distribuido sob a licenca indicada em [`LICENSE`](LICENSE) quando o arquivo estiver disponivel.
