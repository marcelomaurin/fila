package br.com.maurinsoft.painelandroid;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

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

    private AppPreferences preferences;
    private SoundManager soundManager;
    private TcpServerManager tcpServer;

    @Override
    public void onCreate() {
        super.onCreate();
        preferences = new AppPreferences(this);
        soundManager = new SoundManager(this);
        createNotificationChannel();
        startForeground(NOTIFICATION_ID, buildNotification("Inicializando painel"));
        startTcpServer();
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
        if (tcpServer != null) {
            tcpServer.stop();
        }
        tcpServer = new TcpServerManager(preferences.getPort(), this);
        tcpServer.start();
    }

    private void restartTcpServer() {
        startTcpServer();
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
    public void onStatusChanged(boolean running, String ip, int port) {
        Intent event = new Intent(ACTION_STATUS);
        event.setPackage(getPackageName());
        event.putExtra(EXTRA_RUNNING, running);
        event.putExtra(EXTRA_PORT, port);
        sendBroadcast(event);

        updateNotification(running
                ? "Painel online na porta " + port
                : "Painel offline");
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
        if (tcpServer != null) {
            tcpServer.stop();
            tcpServer = null;
        }
        if (soundManager != null) {
            soundManager.release();
            soundManager = null;
        }
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
