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
}
