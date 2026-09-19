package br.com.maurinsoft.painelandroid;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class TcpServerManager {
    private static final String TAG = "TcpServerManager";
    private static final int MAX_MESSAGE_LENGTH = 4096;

    public interface OnCallReceivedListener {
        void onCallReceived(String guiche, String senha);
        void onGroupReceived(String groupId, String description);
        void onStatusChanged(boolean running, String ip, int port);
    }

    private final int port;
    private final OnCallReceivedListener listener;
    private ServerSocket serverSocket;
    private volatile boolean isRunning = false;
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
                    clientSocket.setSoTimeout(15000);
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

    /**
     * O protocolo do Projeto Fila termina cada mensagem com ';'.
     * Não usamos readLine(), pois o Guichê não é obrigado a enviar '\n'.
     */
    private void handleClient(Socket socket) {
        StringBuilder pending = new StringBuilder();
        char[] buffer = new char[512];

        try (InputStreamReader reader = new InputStreamReader(
                socket.getInputStream(), StandardCharsets.UTF_8)) {
            int count;
            while (isRunning && (count = reader.read(buffer)) != -1) {
                for (int i = 0; i < count; i++) {
                    char ch = buffer[i];

                    if (ch == ';') {
                        if (pending.length() > 0) {
                            processMessage(pending.toString() + ";");
                            pending.setLength(0);
                        }
                        continue;
                    }

                    if (pending.length() >= MAX_MESSAGE_LENGTH) {
                        Log.w(TAG, "TCP message discarded: exceeded " + MAX_MESSAGE_LENGTH + " chars");
                        pending.setLength(0);
                        continue;
                    }

                    pending.append(ch);
                }
            }
        } catch (Exception e) {
            if (isRunning) {
                Log.d(TAG, "Client disconnected or read error: " + e.getMessage());
            }
        } finally {
            try {
                socket.close();
            } catch (Exception ignored) {
            }
        }
    }

    public void processMessage(String msg) {
        if (msg == null || msg.trim().isEmpty()) return;

        PanelProtocol.Message parsed = PanelProtocol.parse(msg);
        Log.i(TAG, "Received TCP message: " + msg + " => " + parsed.getType());

        if (parsed.getType() == PanelProtocol.Type.CALL) {
            mainHandler.post(() -> {
                if (listener != null) {
                    listener.onCallReceived(parsed.getDesk(), parsed.getTicket());
                }
            });
        } else if (parsed.getType() == PanelProtocol.Type.GROUP) {
            mainHandler.post(() -> {
                if (listener != null) {
                    listener.onGroupReceived(parsed.getGroupId(), parsed.getGroupDescription());
                }
            });
        } else {
            Log.w(TAG, "Unsupported or malformed panel message: " + msg);
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
        executor.shutdownNow();
        notifyStatus(false);
    }
}
