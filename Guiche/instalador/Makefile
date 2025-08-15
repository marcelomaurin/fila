# Makefile simplificado para apenas construir o pacote .deb da aplicação Guiche e copiar para a pasta bin
# Assume que a estrutura de pastas (guiche_1.22_x86/) já está preparada manualmente

PACKAGE = guiche
VERSION = 2.11
ARCH = x86
DEB_DIR = /home/mmm/projetos/maurinsoft/fila/Guiche/instalador/guiche_1.22_x86

# Diretório fixo corrigido para 'instalador'
DEB_FILE = $(DEB_DIR).deb
TARGET_DEB = guiche_$(VERSION)_$(ARCH).deb  # Nome do arquivo .deb com a versão
BIN_DIR = /home/mmm/projetos/maurinsoft/fila/bin/Guiche/linux/  # Pasta de destino para cópia

all: build

# Target principal: constrói o .deb, renomeia para incluir a versão correta, e copia para bin
# (Assume que permissões e arquivos já estão configurados, incluindo Version: $(VERSION) no control)
build:
	dpkg-deb --build $(DEB_DIR)
	mv $(DEB_FILE) $(TARGET_DEB)
	mkdir -p $(BIN_DIR)
	cp $(TARGET_DEB) $(BIN_DIR)
	@echo "Pacote $(TARGET_DEB) criado e copiado para $(BIN_DIR)."
