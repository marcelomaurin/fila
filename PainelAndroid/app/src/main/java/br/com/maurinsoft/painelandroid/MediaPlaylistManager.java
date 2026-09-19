package br.com.maurinsoft.painelandroid;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public final class MediaPlaylistManager {
    private static final String TAG = "MediaPlaylist";
    private static final String CACHE_DIR = "media-cache";
    private static final String PLAYLIST_CACHE = "playlist.json";
    private static final int MAX_ITEMS = 50;
    private static final long MAX_FILE_BYTES = 200L * 1024L * 1024L;

    public interface Listener {
        void onPlaylistReady(List<MediaItem> items, boolean fromCache);
        void onPlaylistError(String error);
    }

    private final Context context;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    public MediaPlaylistManager(Context context) {
        this.context = context.getApplicationContext();
    }

    public void load(String playlistUrl, Listener listener) {
        executor.execute(() -> {
            try {
                if (playlistUrl == null || playlistUrl.trim().isEmpty()) {
                    postError(listener, "URL de mídia não configurada");
                    return;
                }

                String json = downloadText(playlistUrl.trim());
                saveText(new File(cacheDir(), PLAYLIST_CACHE), json);
                List<MediaItem> items = parseAndCache(json);
                postReady(listener, items, false);
            } catch (Exception onlineError) {
                Log.w(TAG, "Falha online, tentando cache", onlineError);
                try {
                    File cachedPlaylist = new File(cacheDir(), PLAYLIST_CACHE);
                    if (!cachedPlaylist.isFile()) throw onlineError;
                    String json = readText(cachedPlaylist);
                    List<MediaItem> items = parseCachedOnly(json);
                    if (items.isEmpty()) throw onlineError;
                    postReady(listener, items, true);
                } catch (Exception cacheError) {
                    postError(listener, onlineError.getMessage());
                }
            }
        });
    }

    private List<MediaItem> parseAndCache(String json) throws Exception {
        List<MediaItem> items = parse(json);
        List<MediaItem> usable = new ArrayList<>();

        for (MediaItem item : items) {
            try {
                File cached = cacheFileFor(item.getUrl());
                if (!cached.isFile() || cached.length() == 0) {
                    downloadFile(item.getUrl(), cached);
                }
                item.setCachedFile(cached);
                usable.add(item);
            } catch (Exception e) {
                Log.w(TAG, "Falha ao cachear " + item.getUrl(), e);
            }
        }
        return usable;
    }

    private List<MediaItem> parseCachedOnly(String json) throws Exception {
        List<MediaItem> result = new ArrayList<>();
        for (MediaItem item : parse(json)) {
            File cached = cacheFileFor(item.getUrl());
            if (cached.isFile() && cached.length() > 0) {
                item.setCachedFile(cached);
                result.add(item);
            }
        }
        return result;
    }

    private List<MediaItem> parse(String json) throws Exception {
        JSONObject root = new JSONObject(json);
        JSONArray array = root.optJSONArray("items");
        if (array == null) throw new IllegalArgumentException("Playlist sem campo items");

        List<MediaItem> result = new ArrayList<>();
        int count = Math.min(array.length(), MAX_ITEMS);
        for (int i = 0; i < count; i++) {
            JSONObject obj = array.optJSONObject(i);
            if (obj == null) continue;

            String url = obj.optString("url", "").trim();
            String type = obj.optString("type", "").trim().toLowerCase(Locale.ROOT);
            int duration = obj.optInt("duration", 10);
            if (url.isEmpty()) continue;

            MediaItem.Type mediaType;
            if ("image".equals(type)) mediaType = MediaItem.Type.IMAGE;
            else if ("video".equals(type)) mediaType = MediaItem.Type.VIDEO;
            else continue;

            result.add(new MediaItem(mediaType, url, duration));
        }
        return result;
    }

    private String downloadText(String urlText) throws Exception {
        HttpURLConnection connection = open(urlText);
        connection.setReadTimeout(10000);
        int status = connection.getResponseCode();
        if (status < 200 || status >= 300) throw new IllegalStateException("HTTP " + status);

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(
                connection.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder out = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) out.append(line).append('\n');
            return out.toString();
        } finally {
            connection.disconnect();
        }
    }

    private void downloadFile(String urlText, File destination) throws Exception {
        HttpURLConnection connection = open(urlText);
        connection.setReadTimeout(30000);
        int status = connection.getResponseCode();
        if (status < 200 || status >= 300) throw new IllegalStateException("HTTP " + status);

        long contentLength = connection.getContentLengthLong();
        if (contentLength > MAX_FILE_BYTES) throw new IllegalStateException("Arquivo de mídia muito grande");

        File tmp = new File(destination.getAbsolutePath() + ".tmp");
        long total = 0;
        try (BufferedInputStream in = new BufferedInputStream(connection.getInputStream());
             FileOutputStream out = new FileOutputStream(tmp)) {
            byte[] buffer = new byte[8192];
            int n;
            while ((n = in.read(buffer)) != -1) {
                total += n;
                if (total > MAX_FILE_BYTES) throw new IllegalStateException("Arquivo de mídia excedeu limite");
                out.write(buffer, 0, n);
            }
        } finally {
            connection.disconnect();
        }

        if (!tmp.renameTo(destination)) {
            throw new IllegalStateException("Não foi possível finalizar cache de mídia");
        }
    }

    private HttpURLConnection open(String urlText) throws Exception {
        URL url = new URL(urlText);
        String protocol = url.getProtocol();
        if (!"http".equalsIgnoreCase(protocol) && !"https".equalsIgnoreCase(protocol)) {
            throw new IllegalArgumentException("URL de mídia deve usar HTTP/HTTPS");
        }

        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setConnectTimeout(7000);
        connection.setInstanceFollowRedirects(true);
        connection.setRequestProperty("User-Agent", "Fila-PainelAndroid");
        return connection;
    }

    private File cacheDir() {
        File dir = new File(context.getFilesDir(), CACHE_DIR);
        if (!dir.exists()) dir.mkdirs();
        return dir;
    }

    private File cacheFileFor(String url) throws Exception {
        String ext = "";
        int q = url.indexOf('?');
        String clean = q >= 0 ? url.substring(0, q) : url;
        int dot = clean.lastIndexOf('.');
        if (dot >= 0 && clean.length() - dot <= 8) ext = clean.substring(dot).toLowerCase(Locale.ROOT);

        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(url.getBytes(StandardCharsets.UTF_8));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) hex.append(String.format(Locale.ROOT, "%02x", b));
        return new File(cacheDir(), hex + ext);
    }

    private static void saveText(File file, String text) throws Exception {
        try (FileOutputStream out = new FileOutputStream(file)) {
            out.write(text.getBytes(StandardCharsets.UTF_8));
        }
    }

    private static String readText(File file) throws Exception {
        try (FileInputStream in = new FileInputStream(file);
             BufferedReader reader = new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8))) {
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) result.append(line).append('\n');
            return result.toString();
        }
    }

    private void postReady(Listener listener, List<MediaItem> items, boolean fromCache) {
        mainHandler.post(() -> listener.onPlaylistReady(items, fromCache));
    }

    private void postError(Listener listener, String error) {
        mainHandler.post(() -> listener.onPlaylistError(error == null ? "Erro de mídia" : error));
    }

    public void shutdown() {
        executor.shutdownNow();
    }
}
