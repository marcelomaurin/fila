package br.com.maurinsoft.painelandroid;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.util.Log;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class CentralAdminClient {
    private static final String TAG = "CentralAdminClient";
    private final Context context;
    private final AppPreferences preferences;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    public interface Callback {
        void onRemoteConfig(JSONObject config);
        void onRemoteCommand(long id, String type, JSONObject payload);
        void onHeartbeatResult(boolean ok, String error);
    }

    public CentralAdminClient(Context context, AppPreferences preferences) {
        this.context = context.getApplicationContext();
        this.preferences = preferences;
    }

    public void sendHeartbeat(Callback callback) {
        if (!preferences.isCentralAdminEnabled()) {
            if (callback != null) callback.onHeartbeatResult(false, "Administração central não configurada");
            return;
        }

        executor.execute(() -> {
            HttpURLConnection connection = null;
            try {
                URL url = new URL(preferences.getAdminUrl() + "/api/panel/heartbeat.php");
                connection = (HttpURLConnection) url.openConnection();
                connection.setConnectTimeout(5000);
                connection.setReadTimeout(7000);
                connection.setRequestMethod("POST");
                connection.setDoOutput(true);
                connection.setRequestProperty("Content-Type", "application/json; charset=utf-8");
                connection.setRequestProperty("X-Panel-Token", preferences.getPanelToken());

                JSONObject body = new JSONObject();
                body.put("panel_id", preferences.getPanelId());
                body.put("name", preferences.getPanelName());
                body.put("unit", preferences.getPanelUnit());
                body.put("ip", NetworkUtils.getLocalIpAddress(context));
                body.put("version", getVersionName());
                body.put("port", preferences.getPort());
                body.put("tcp_online", preferences.isServerRunning());

                long startedAt = preferences.getServiceStartedAt();
                long uptime = startedAt > 0
                        ? Math.max(0L, (System.currentTimeMillis() - startedAt) / 1000L)
                        : 0L;
                body.put("uptime_sec", uptime);
                body.put("call_count", preferences.getCallCount());
                body.put("last_ticket", preferences.getCurrentSenha());
                body.put("last_desk", preferences.getCurrentGuiche());
                body.put("last_error", preferences.getLastError());
                body.put("tts_enabled", preferences.isTtsEnabled());
                body.put("chime_enabled", preferences.isChimeEnabled());
                body.put("ads_url", preferences.getAdsUrl());

                long ackId = preferences.getAckCommandId();
                if (ackId > 0) {
                    body.put("ack_command_id", ackId);
                    body.put("ack_result", preferences.getAckCommandResult());
                }

                byte[] payload = body.toString().getBytes(StandardCharsets.UTF_8);
                connection.setFixedLengthStreamingMode(payload.length);

                try (OutputStream out = connection.getOutputStream()) {
                    out.write(payload);
                }

                int status = connection.getResponseCode();
                BufferedReader reader = new BufferedReader(new InputStreamReader(
                        status >= 200 && status < 300
                                ? connection.getInputStream()
                                : connection.getErrorStream(),
                        StandardCharsets.UTF_8
                ));

                StringBuilder responseText = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    responseText.append(line);
                }
                reader.close();

                if (status < 200 || status >= 300) {
                    throw new IllegalStateException("HTTP " + status + ": " + responseText);
                }

                JSONObject response = new JSONObject(responseText.toString());
                if (!response.optBoolean("ok", false)) {
                    throw new IllegalStateException(response.optString("error", "Heartbeat rejeitado"));
                }

                if (ackId > 0) {
                    preferences.clearCommandAck();
                }

                preferences.markHeartbeat(System.currentTimeMillis(), "");

                JSONObject config = response.optJSONObject("config");
                if (config != null && callback != null) {
                    callback.onRemoteConfig(config);
                }

                JSONObject command = response.optJSONObject("command");
                if (command != null && callback != null) {
                    callback.onRemoteCommand(
                            command.optLong("id", 0L),
                            command.optString("type", ""),
                            command.optJSONObject("payload") == null
                                    ? new JSONObject()
                                    : command.optJSONObject("payload")
                    );
                }

                if (callback != null) callback.onHeartbeatResult(true, "");
            } catch (Exception e) {
                Log.w(TAG, "Heartbeat failed", e);
                preferences.markHeartbeat(System.currentTimeMillis(), e.getMessage());
                if (callback != null) callback.onHeartbeatResult(false, e.getMessage());
            } finally {
                if (connection != null) connection.disconnect();
            }
        });
    }

    private String getVersionName() {
        try {
            PackageInfo info = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            return info.versionName == null ? "?" : info.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            return "?";
        }
    }

    public void shutdown() {
        executor.shutdownNow();
    }
}
