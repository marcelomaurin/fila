package br.com.maurinsoft.painelandroid;

import java.io.File;

public final class MediaItem {
    public enum Type { IMAGE, VIDEO }

    private final Type type;
    private final String url;
    private final int durationSeconds;
    private File cachedFile;

    public MediaItem(Type type, String url, int durationSeconds) {
        this.type = type;
        this.url = url;
        this.durationSeconds = durationSeconds <= 0 ? 10 : durationSeconds;
    }

    public Type getType() { return type; }
    public String getUrl() { return url; }
    public int getDurationSeconds() { return durationSeconds; }
    public File getCachedFile() { return cachedFile; }
    public void setCachedFile(File cachedFile) { this.cachedFile = cachedFile; }
}
