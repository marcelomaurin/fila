import socket
import threading
from gtts import gTTS
import os
import pygame
import time

# Configurações do servidor
HOST = '0.0.0.0'
PORT = 8096
BUFFER_SIZE = 1024

contador_audio = 1  # Número sequencial do áudio

def limpar_mp3():
    """Apaga todos os arquivos .mp3 no diretório atual."""
    for arquivo in os.listdir():
        if arquivo.endswith(".mp3"):
            try:
                os.remove(arquivo)
                print(f"Arquivo {arquivo} apagado na inicialização.")
            except Exception as e:
                print(f"Erro ao apagar {arquivo}: {e}")

def texto_para_voz(texto):
    """Converte texto em fala e reproduz."""
    global contador_audio
    print(f"Recebido: {texto}")
    
    filename = f"audio_{contador_audio}.mp3"
    contador_audio += 1  # Incrementa o número do áudio
    
    try:
        tts = gTTS(text=texto, lang='pt', slow=False)
        tts.save(filename)
        
        pygame.mixer.init()
        pygame.mixer.music.load(filename)
        pygame.mixer.music.play()
        
        while pygame.mixer.music.get_busy():
            time.sleep(0.1)
            
    except Exception as e:
        print(f"Erro ao reproduzir áudio: {e}")
    finally:
        #if os.path.exists(filename):
        #    os.remove(filename)
        print(f"Arquivo {filename} falado!.")

def Setup():
    """Configura o servidor socket e limpa arquivos .mp3."""
    limpar_mp3()
    global server_socket
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((HOST, PORT))
    server_socket.listen(5)
    print(f"Servidor iniciado na porta {PORT}")

def Loop():
    """Loop principal que aceita conexões e processa mensagens."""
    while True:
        client_socket, addr = server_socket.accept()
        print(f"Conexão de {addr}")
        threading.Thread(target=handle_client, args=(client_socket,)).start()

def handle_client(client_socket):
    """Processa dados do cliente."""
    with client_socket as sock:
        data = sock.recv(BUFFER_SIZE)
        if data:
            texto = data.decode('utf-8')
            texto_para_voz(texto)

if __name__ == "__main__":
    Setup()
    Loop()
