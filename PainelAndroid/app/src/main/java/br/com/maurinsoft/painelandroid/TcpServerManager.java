package br.com.maurinsoft.painelandroid;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class TcpServerManager {
    private static final String TAG = "TcpServerManager";

    public interface OnCallReceivedListener {
        void onCallReceived(String guiche, String senha);
        void onStatusChanged(boolean running, String ip, int port);
    }

    private final int port;
    private final OnCallReceivedListener listener;
    private ServerSocket serverSocket;
    private boolean isRunning = false;
    private final ExecutorService executor = Executors.newCachedThreadPool();
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    public TcpServerManager(int port, OnCallReceivedListener listener) {
        this.port = port;
        this.listener = listener;
    }

    public void start() {
        if (isRunning) return;
        isRunning = true;
        executor.execute(this::runServer);
    }

    private void runServer() {
        try {
            serverSocket = new ServerSocket(port);
            serverSocket.setReuseAddress(true);
            Log.i(TAG, "TCP Server started on port " + port);

            notifyStatus(true);

            while (isRunning && !serverSocket.isClosed()) {
                try {
                    Socket clientSocket = serverSocket.accept();
                    executor.execute(() -> handleClient(clientSocket));
                } catch (SocketException se) {
                    if (!isRunning) break;
                    Log.e(TAG, "SocketException in accept", se);
                }
            }
        } catch (Exception e) {
            Log.e(TAG, "Error starting server on port " + port, e);
            notifyStatus(false);
        }
    }

    private void handleClient(Socket socket) {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                processMessage(line.trim());
            }
        } catch (Exception e) {
            Log.d(TAG, "Client disconnected or read error: " + e.getMessage());
        } finally {
            try {
                socket.close();
            } catch (Exception ignored) {}
        }
    }

    public void processMessage(String msg) {
        if (msg == null || msg.isEmpty()) return;
        Log.i(TAG, "Received TCP message: " + msg);

        // Protocol formats:
        // 1) FILA:>GUICHE:CODIGO; (e.g. FILA:>01:A001;)
        // 2) GUICHE:...
        // 3) GRUPO:...

        int colonIdx = msg.indexOf(':');
        if (colonIdx <= 0) return;

        String comando = msg.substring(0, colonIdx);
        String info = msg.substring(colonIdx + 1);

        if ("FILA".equalsIgnoreCase(comando)) {
            parseFilaMessage(info);
        } else if ("GUICHE".equalsIgnoreCase(comando)) {
            parseGuicheMessage(info);
        }
    }

    private void parseFilaMessage(String info) {
        // info: >GUICHE:CODIGO;  or  >1:A001;
        info = info.replace("\r", "").replace("\n", "");
        int posMaior = info.indexOf('>');
        int posDoisPontos = info.indexOf(':');
        int posPontoVirgula = info.indexOf(';');

        if (posMaior != -1 && posDoisPontos != -1 && posPontoVirgula != -1) {
            String guiche = info.substring(posMaior + 1, posDoisPontos).trim();
            String codigo = info.substring(posDoisPontos + 1, posPontoVirgula).trim();

            if (!guiche.isEmpty() && !codigo.isEmpty()) {
                mainHandler.post(() -> {
                    if (listener != null) {
                        listener.onCallReceived(guiche, codigo);
                    }
                });
            }
        }
    }

    private void parseGuicheMessage(String info) {
        int posMaior = info.indexOf('>');
        int posDoisPontos = info.indexOf(':');
        int posPontoVirgula = info.indexOf(';');

        if (posDoisPontos != -1 && posPontoVirgula != -1) {
            String guiche = posMaior != -1 ? info.substring(posMaior + 1, posDoisPontos).trim() : "1";
            String codigo = info.substring(posDoisPontos + 1, posPontoVirgula).trim();

            if (!codigo.isEmpty()) {
                mainHandler.post(() -> {
                    if (listener != null) {
                        listener.onCallReceived(guiche, codigo);
                    }
                });
            }
        }
    }

    private void notifyStatus(boolean running) {
        mainHandler.post(() -> {
            if (listener != null) {
                listener.onStatusChanged(running, "", port);
            }
        });
    }

    public void stop() {
        isRunning = false;
        try {
            if (serverSocket != null && !serverSocket.isClosed()) {
                serverSocket.close();
            }
        } catch (Exception e) {
            Log.e(TAG, "Error closing serverSocket", e);
        }
        notifyStatus(false);
    }
}
