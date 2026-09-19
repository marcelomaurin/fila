package br.com.maurinsoft.painelandroid;

import android.content.Context;
import android.content.SharedPreferences;

public class AppPreferences {
    private static final String PREF_NAME = "painel_tv_prefs";
    private static final String KEY_PORT = "tcp_port";
    private static final String KEY_TTS_ENABLED = "tts_enabled";
    private static final String KEY_CHIME_ENABLED = "chime_enabled";
    private static final String KEY_ADS_URL = "ads_url";
    private static final String KEY_IDLE_SECONDS = "idle_seconds";
    private static final String KEY_CURRENT_GUICHE = "current_guiche";
    private static final String KEY_CURRENT_SENHA = "current_senha";
    private static final String KEY_HISTORY_COUNT = "history_count";
    private static final String KEY_HISTORY_GUICHE_PREFIX = "history_guiche_";
    private static final String KEY_HISTORY_SENHA_PREFIX = "history_senha_";
    private static final String KEY_GROUP_PREFIX = "group_";
    private static final String KEY_SERVICE_STARTED_AT = "service_started_at";
    private static final String KEY_LAST_CALL_AT = "last_call_at";
    private static final String KEY_CALL_COUNT = "call_count";
    private static final String KEY_SERVER_RUNNING = "server_running";
    private static final String KEY_RETRY_COUNT = "retry_count";
    private static final String KEY_LAST_ERROR = "last_error";
    private static final String KEY_PANEL_ID = "panel_id";
    private static final String KEY_PANEL_NAME = "panel_name";
    private static final String KEY_PANEL_UNIT = "panel_unit";
    private static final String KEY_ADMIN_URL = "admin_url";
    private static final String KEY_PANEL_TOKEN = "panel_token";
    private static final String KEY_LAST_HEARTBEAT_AT = "last_heartbeat_at";
    private static final String KEY_LAST_HEARTBEAT_ERROR = "last_heartbeat_error";
    private static final String KEY_ACK_COMMAND_ID = "ack_command_id";
    private static final String KEY_ACK_COMMAND_RESULT = "ack_command_result";
    private static final String KEY_LAST_UPDATE_CHECK_AT = "last_update_check_at";
    private static final String KEY_LAST_UPDATE_VERSION = "last_update_version";
    private static final String KEY_LAST_UPDATE_ERROR = "last_update_error";

    private final SharedPreferences prefs;

    public AppPreferences(Context context) {
        this.prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
    }

    public int getPort() {
        return prefs.getInt(KEY_PORT, 8196);
    }

    public void setPort(int port) {
        prefs.edit().putInt(KEY_PORT, port).apply();
    }

    public boolean isTtsEnabled() {
        return prefs.getBoolean(KEY_TTS_ENABLED, true);
    }

    public void setTtsEnabled(boolean enabled) {
        prefs.edit().putBoolean(KEY_TTS_ENABLED, enabled).apply();
    }

    public boolean isChimeEnabled() {
        return prefs.getBoolean(KEY_CHIME_ENABLED, true);
    }

    public void setChimeEnabled(boolean enabled) {
        prefs.edit().putBoolean(KEY_CHIME_ENABLED, enabled).apply();
    }

    public String getAdsUrl() {
        return prefs.getString(KEY_ADS_URL, "");
    }

    public void setAdsUrl(String url) {
        prefs.edit().putString(KEY_ADS_URL, url).apply();
    }

    public int getIdleSeconds() {
        return prefs.getInt(KEY_IDLE_SECONDS, 60);
    }

    public void setIdleSeconds(int seconds) {
        prefs.edit().putInt(KEY_IDLE_SECONDS, seconds).apply();
    }

    public void savePanelState(String currentGuiche, String currentSenha,
                               java.util.List<CallHistoryItem> history) {
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString(KEY_CURRENT_GUICHE, currentGuiche == null ? "" : currentGuiche);
        editor.putString(KEY_CURRENT_SENHA, currentSenha == null ? "" : currentSenha);

        int count = Math.min(history == null ? 0 : history.size(), 4);
        editor.putInt(KEY_HISTORY_COUNT, count);

        for (int i = 0; i < 4; i++) {
            if (i < count) {
                CallHistoryItem item = history.get(i);
                editor.putString(KEY_HISTORY_GUICHE_PREFIX + i, item.getGuiche());
                editor.putString(KEY_HISTORY_SENHA_PREFIX + i, item.getSenha());
            } else {
                editor.remove(KEY_HISTORY_GUICHE_PREFIX + i);
                editor.remove(KEY_HISTORY_SENHA_PREFIX + i);
            }
        }
        editor.apply();
    }

    public String getCurrentGuiche() {
        return prefs.getString(KEY_CURRENT_GUICHE, "");
    }

    public String getCurrentSenha() {
        return prefs.getString(KEY_CURRENT_SENHA, "");
    }

    public java.util.List<CallHistoryItem> loadHistory() {
        java.util.List<CallHistoryItem> result = new java.util.ArrayList<>();
        int count = Math.max(0, Math.min(4, prefs.getInt(KEY_HISTORY_COUNT, 0)));

        for (int i = 0; i < count; i++) {
            String guiche = prefs.getString(KEY_HISTORY_GUICHE_PREFIX + i, "");
            String senha = prefs.getString(KEY_HISTORY_SENHA_PREFIX + i, "");
            if (senha != null && !senha.trim().isEmpty()) {
                result.add(new CallHistoryItem(
                        guiche == null ? "" : guiche,
                        senha
                ));
            }
        }
        return result;
    }

    public void setGroupDescription(String groupId, String description) {
        if (groupId == null || groupId.trim().isEmpty()) return;
        prefs.edit().putString(KEY_GROUP_PREFIX + groupId.trim(),
                description == null ? "" : description.trim()).apply();
    }

    public String getGroupDescription(String groupId) {
        if (groupId == null) return "";
        return prefs.getString(KEY_GROUP_PREFIX + groupId.trim(), "");
    }

    public void markServiceStarted(long timestamp) {
        prefs.edit()
                .putLong(KEY_SERVICE_STARTED_AT, timestamp)
                .putInt(KEY_RETRY_COUNT, 0)
                .apply();
    }

    public long getServiceStartedAt() {
        return prefs.getLong(KEY_SERVICE_STARTED_AT, 0L);
    }

    public void markCallReceived(long timestamp) {
        prefs.edit()
                .putLong(KEY_LAST_CALL_AT, timestamp)
                .putLong(KEY_CALL_COUNT, getCallCount() + 1L)
                .apply();
    }

    public long getLastCallAt() {
        return prefs.getLong(KEY_LAST_CALL_AT, 0L);
    }

    public long getCallCount() {
        return prefs.getLong(KEY_CALL_COUNT, 0L);
    }

    public void setServerRunning(boolean running) {
        prefs.edit().putBoolean(KEY_SERVER_RUNNING, running).apply();
    }

    public boolean isServerRunning() {
        return prefs.getBoolean(KEY_SERVER_RUNNING, false);
    }

    public void setRetryCount(int count) {
        prefs.edit().putInt(KEY_RETRY_COUNT, Math.max(0, count)).apply();
    }

    public int getRetryCount() {
        return prefs.getInt(KEY_RETRY_COUNT, 0);
    }

    public void setLastError(String error) {
        prefs.edit().putString(KEY_LAST_ERROR, error == null ? "" : error).apply();
    }

    public String getLastError() {
        return prefs.getString(KEY_LAST_ERROR, "");
    }

    public String getPanelId() {
        String id = prefs.getString(KEY_PANEL_ID, "");
        if (id == null || id.trim().isEmpty()) {
            id = "TV-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            prefs.edit().putString(KEY_PANEL_ID, id).apply();
        }
        return id;
    }

    public void setPanelId(String id) {
        prefs.edit().putString(KEY_PANEL_ID, id == null ? "" : id.trim()).apply();
    }

    public String getPanelName() {
        return prefs.getString(KEY_PANEL_NAME, "");
    }

    public void setPanelName(String value) {
        prefs.edit().putString(KEY_PANEL_NAME, value == null ? "" : value.trim()).apply();
    }

    public String getPanelUnit() {
        return prefs.getString(KEY_PANEL_UNIT, "");
    }

    public void setPanelUnit(String value) {
        prefs.edit().putString(KEY_PANEL_UNIT, value == null ? "" : value.trim()).apply();
    }

    public String getAdminUrl() {
        return prefs.getString(KEY_ADMIN_URL, "");
    }

    public void setAdminUrl(String value) {
        String url = value == null ? "" : value.trim();
        while (url.endsWith("/")) {
            url = url.substring(0, url.length() - 1);
        }
        prefs.edit().putString(KEY_ADMIN_URL, url).apply();
    }

    public String getPanelToken() {
        return prefs.getString(KEY_PANEL_TOKEN, "");
    }

    public void setPanelToken(String value) {
        prefs.edit().putString(KEY_PANEL_TOKEN, value == null ? "" : value.trim()).apply();
    }

    public boolean isCentralAdminEnabled() {
        return !getAdminUrl().isEmpty() && !getPanelToken().isEmpty();
    }

    public void markHeartbeat(long timestamp, String error) {
        prefs.edit()
                .putLong(KEY_LAST_HEARTBEAT_AT, timestamp)
                .putString(KEY_LAST_HEARTBEAT_ERROR, error == null ? "" : error)
                .apply();
    }

    public long getLastHeartbeatAt() {
        return prefs.getLong(KEY_LAST_HEARTBEAT_AT, 0L);
    }

    public String getLastHeartbeatError() {
        return prefs.getString(KEY_LAST_HEARTBEAT_ERROR, "");
    }

    public void setCommandAck(long commandId, String result) {
        prefs.edit()
                .putLong(KEY_ACK_COMMAND_ID, commandId)
                .putString(KEY_ACK_COMMAND_RESULT, result == null ? "OK" : result)
                .apply();
    }

    public long getAckCommandId() {
        return prefs.getLong(KEY_ACK_COMMAND_ID, 0L);
    }

    public String getAckCommandResult() {
        return prefs.getString(KEY_ACK_COMMAND_RESULT, "");
    }

    public void clearCommandAck() {
        prefs.edit()
                .remove(KEY_ACK_COMMAND_ID)
                .remove(KEY_ACK_COMMAND_RESULT)
                .apply();
    }

    public void markUpdateCheck(long timestamp, String version, String error) {
        prefs.edit()
                .putLong(KEY_LAST_UPDATE_CHECK_AT, timestamp)
                .putString(KEY_LAST_UPDATE_VERSION, version == null ? "" : version)
                .putString(KEY_LAST_UPDATE_ERROR, error == null ? "" : error)
                .apply();
    }

    public long getLastUpdateCheckAt() {
        return prefs.getLong(KEY_LAST_UPDATE_CHECK_AT, 0L);
    }

    public String getLastUpdateVersion() {
        return prefs.getString(KEY_LAST_UPDATE_VERSION, "");
    }

    public String getLastUpdateError() {
        return prefs.getString(KEY_LAST_UPDATE_ERROR, "");
    }
}
