package br.com.maurinsoft.painelandroid;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import org.json.JSONObject;

import java.util.List;

public class PanelService extends Service implements TcpServerManager.OnCallReceivedListener {
    public static final String ACTION_CALL = "br.com.maurinsoft.painelandroid.CALL";
    public static final String ACTION_GROUP = "br.com.maurinsoft.painelandroid.GROUP";
    public static final String ACTION_STATUS = "br.com.maurinsoft.painelandroid.STATUS";
    public static final String ACTION_RESTART_SERVER = "br.com.maurinsoft.painelandroid.RESTART_SERVER";
    public static final String ACTION_SIMULATE = "br.com.maurinsoft.painelandroid.SIMULATE";

    public static final String EXTRA_GUICHE = "guiche";
    public static final String EXTRA_SENHA = "senha";
    public static final String EXTRA_GROUP_ID = "group_id";
    public static final String EXTRA_GROUP_DESCRIPTION = "group_description";
    public static final String EXTRA_RUNNING = "running";
    public static final String EXTRA_PORT = "port";

    private static final String CHANNEL_ID = "painel_service";
    private static final int NOTIFICATION_ID = 8196;
    private static final long[] RETRY_DELAYS_MS = {2000L, 5000L, 10000L, 30000L};

    private AppPreferences preferences;
    private SoundManager soundManager;
    private TcpServerManager tcpServer;
    private CentralAdminClient centralAdminClient;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private int retryCount = 0;
    private boolean destroyed = false;
    private boolean retryScheduled = false;
    private final Runnable retryRunnable = () -> {
        retryScheduled = false;
        startTcpServer();
    };
    private final Runnable heartbeatRunnable = new Runnable() {
        @Override
        public void run() {
            if (!destroyed && preferences.isCentralAdminEnabled()) {
                centralAdminClient.sendHeartbeat(new CentralAdminClient.Callback() {
                    @Override
                    public void onRemoteConfig(JSONObject config) {
                        handler.post(() -> applyRemoteConfig(config));
                    }

                    @Override
                    public void onRemoteCommand(long id, String type, JSONObject payload) {
                        handler.post(() -> executeRemoteCommand(id, type, payload));
                    }

                    @Override
                    public void onHeartbeatResult(boolean ok, String error) {
                        // O diagnóstico é persistido pelo cliente.
                    }
                });
            }
            if (!destroyed) {
                handler.postDelayed(this, 30000L);
            }
        }
    };

    private final Runnable watchdogRunnable = new Runnable() {
        @Override
        public void run() {
            if (!destroyed && !preferences.isServerRunning()) {
                scheduleRetry("Servidor TCP permaneceu offline");
            }
            if (!destroyed) {
                handler.postDelayed(this, 60000L);
            }
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        preferences = new AppPreferences(this);
        soundManager = new SoundManager(this);
        centralAdminClient = new CentralAdminClient(this, preferences);
        preferences.markServiceStarted(System.currentTimeMillis());
        createNotificationChannel();
        startForeground(NOTIFICATION_ID, buildNotification("Inicializando painel"));
        startTcpServer();
        handler.postDelayed(heartbeatRunnable, 5000L);
        handler.postDelayed(watchdogRunnable, 60000L);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null) {
            String action = intent.getAction();
            if (ACTION_RESTART_SERVER.equals(action)) {
                restartTcpServer();
            } else if (ACTION_SIMULATE.equals(action)) {
                String guiche = intent.getStringExtra(EXTRA_GUICHE);
                String senha = intent.getStringExtra(EXTRA_SENHA);
                onCallReceived(guiche == null ? "01" : guiche,
                        senha == null ? "A001" : senha);
            }
        }
        return START_STICKY;
    }

    private void startTcpServer() {
        if (destroyed) return;

        handler.removeCallbacks(retryRunnable);
        retryScheduled = false;
        if (tcpServer != null) {
            tcpServer.stop();
        }

        preferences.setServerRunning(false);
        tcpServer = new TcpServerManager(preferences.getPort(), this);
        tcpServer.start();
    }

    private void restartTcpServer() {
        retryCount = 0;
        preferences.setRetryCount(0);
        startTcpServer();
    }

    private void scheduleRetry(String reason) {
        if (destroyed || retryScheduled) return;

        int index = Math.min(retryCount, RETRY_DELAYS_MS.length - 1);
        long delay = RETRY_DELAYS_MS[index];
        retryCount++;

        preferences.setRetryCount(retryCount);
        preferences.setLastError(reason == null ? "Servidor TCP offline" : reason);
        retryScheduled = true;
        handler.postDelayed(retryRunnable, delay);
        updateNotification("Reconectando em " + (delay / 1000L) + "s");
    }

    @Override
    public void onCallReceived(String guiche, String senha) {
        List<CallHistoryItem> history = preferences.loadHistory();
        String oldGuiche = preferences.getCurrentGuiche();
        String oldSenha = preferences.getCurrentSenha();

        if (oldSenha != null && !oldSenha.trim().isEmpty()
                && !"A000".equals(oldSenha) && !"----".equals(oldSenha)
                && !oldSenha.equals(senha)) {
            history.add(0, new CallHistoryItem(oldGuiche == null ? "" : oldGuiche, oldSenha));
            while (history.size() > 4) {
                history.remove(history.size() - 1);
            }
        }

        preferences.savePanelState(guiche, senha, history);
        preferences.markCallReceived(System.currentTimeMillis());
        soundManager.speakCall(guiche, senha,
                preferences.isChimeEnabled(), preferences.isTtsEnabled());

        Intent event = new Intent(ACTION_CALL);
        event.setPackage(getPackageName());
        event.putExtra(EXTRA_GUICHE, guiche);
        event.putExtra(EXTRA_SENHA, senha);
        sendBroadcast(event);

        updateNotification("Última chamada: " + senha + " / Guichê " + guiche);
    }

    @Override
    public void onGroupReceived(String groupId, String description) {
        preferences.setGroupDescription(groupId, description);

        Intent event = new Intent(ACTION_GROUP);
        event.setPackage(getPackageName());
        event.putExtra(EXTRA_GROUP_ID, groupId);
        event.putExtra(EXTRA_GROUP_DESCRIPTION, description);
        sendBroadcast(event);
    }

    @Override
    public void onStatusChanged(boolean running, String ip, int port, String errorMessage) {
        if (destroyed) return;

        preferences.setServerRunning(running);

        if (running) {
            retryCount = 0;
            preferences.setRetryCount(0);
            preferences.setLastError("");
            handler.removeCallbacks(retryRunnable);
            retryScheduled = false;
        } else if (!"stopped".equalsIgnoreCase(errorMessage)) {
            String reason = (errorMessage == null || errorMessage.trim().isEmpty())
                    ? "Servidor TCP offline"
                    : errorMessage.trim();
            scheduleRetry(reason);
        }

        Intent event = new Intent(ACTION_STATUS);
        event.setPackage(getPackageName());
        event.putExtra(EXTRA_RUNNING, running);
        event.putExtra(EXTRA_PORT, port);
        event.putExtra("retry_count", retryCount);
        event.putExtra("error", errorMessage == null ? "" : errorMessage);
        sendBroadcast(event);

        updateNotification(running
                ? "Painel online na porta " + port
                : "Painel offline");
    }

    private void applyRemoteConfig(JSONObject config) {
        if (config == null) return;

        int oldPort = preferences.getPort();

        if (config.has("name") && !config.isNull("name")) {
            preferences.setPanelName(config.optString("name", ""));
        }
        if (config.has("unit") && !config.isNull("unit")) {
            preferences.setPanelUnit(config.optString("unit", ""));
        }
        if (config.has("port") && !config.isNull("port")) {
            int port = config.optInt("port", oldPort);
            if (port >= 1 && port <= 65535) {
                preferences.setPort(port);
            }
        }
        if (config.has("tts_enabled") && !config.isNull("tts_enabled")) {
            preferences.setTtsEnabled(config.optInt("tts_enabled", 1) != 0);
        }
        if (config.has("chime_enabled") && !config.isNull("chime_enabled")) {
            preferences.setChimeEnabled(config.optInt("chime_enabled", 1) != 0);
        }
        if (config.has("ads_url") && !config.isNull("ads_url")) {
            preferences.setAdsUrl(config.optString("ads_url", ""));
        }

        if (preferences.getPort() != oldPort) {
            restartTcpServer();
        }
    }

    private void executeRemoteCommand(long commandId, String type, JSONObject payload) {
        if (commandId <= 0 || type == null) return;

        String normalized = type.trim().toUpperCase();
        String result = "OK";

        try {
            if ("TEST_CALL".equals(normalized)) {
                String ticket = payload.optString("ticket", "T001");
                String desk = payload.optString("desk", "01");
                onCallReceived(desk, ticket);
            } else if ("RESTART_TCP".equals(normalized)) {
                restartTcpServer();
            } else if ("CONFIG".equals(normalized)) {
                applyRemoteConfig(payload);
            } else {
                result = "Comando não suportado: " + normalized;
            }
        } catch (Exception e) {
            result = "ERRO: " + e.getMessage();
        }

        preferences.setCommandAck(commandId, result);
        handler.removeCallbacks(heartbeatRunnable);
        handler.postDelayed(heartbeatRunnable, 1000L);
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    CHANNEL_ID,
                    "Serviço do Painel",
                    NotificationManager.IMPORTANCE_LOW
            );
            channel.setDescription("Mantém o receptor TCP do painel de senhas ativo.");
            NotificationManager manager = getSystemService(NotificationManager.class);
            if (manager != null) {
                manager.createNotificationChannel(channel);
            }
        }
    }

    private Notification buildNotification(String text) {
        return new NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_launcher)
                .setContentTitle("Painel de Senhas")
                .setContentText(text)
                .setOngoing(true)
                .setOnlyAlertOnce(true)
                .build();
    }

    private void updateNotification(String text) {
        NotificationManager manager = getSystemService(NotificationManager.class);
        if (manager != null) {
            manager.notify(NOTIFICATION_ID, buildNotification(text));
        }
    }

    @Override
    public void onDestroy() {
        destroyed = true;
        handler.removeCallbacks(retryRunnable);
        retryScheduled = false;
        handler.removeCallbacks(heartbeatRunnable);
        handler.removeCallbacks(watchdogRunnable);
        preferences.setServerRunning(false);
        if (tcpServer != null) {
            tcpServer.stop();
            tcpServer = null;
        }
        if (soundManager != null) {
            soundManager.release();
            soundManager = null;
        }
        if (centralAdminClient != null) {
            centralAdminClient.shutdown();
            centralAdminClient = null;
        }
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
