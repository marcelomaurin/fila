package br.com.maurinsoft.painelandroid;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.FileProvider;

import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public final class UpdateManager {
    private static final String TAG = "UpdateManager";
    public static final int NOTIFICATION_ID = 2700;
    private static final long MAX_APK_BYTES = 250L * 1024L * 1024L;

    private final Context context;
    private final AppPreferences preferences;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    public interface Listener {
        void onChecked(boolean updateAvailable, String versionName, String error);
    }

    public UpdateManager(Context context, AppPreferences preferences) {
        this.context = context.getApplicationContext();
        this.preferences = preferences;
    }

    public void checkAndPrepare(Listener listener) {
        if (!preferences.isCentralAdminEnabled()) {
            if (listener != null) listener.onChecked(false, "", "Central não configurada");
            return;
        }

        executor.execute(() -> {
            try {
                JSONObject meta = fetchMetadata();
                int remoteCode = meta.optInt("version_code", 0);
                String remoteName = meta.optString("version_name", "");
                if (remoteCode <= getInstalledVersionCode()) {
                    if (listener != null) listener.onChecked(false, remoteName, "");
                    return;
                }

                String apkUrl = meta.optString("url", "");
                String expectedSha = meta.optString("sha256", "").toLowerCase(Locale.ROOT);
                if (apkUrl.isEmpty() || !expectedSha.matches("[0-9a-f]{64}")) {
                    throw new IllegalStateException("Metadata de atualização incompleta");
                }

                File apk = downloadApk(apkUrl, remoteCode);
                String actualSha = sha256(apk);
                if (!expectedSha.equals(actualSha)) {
                    apk.delete();
                    throw new IllegalStateException("SHA-256 do APK não confere");
                }

                showInstallNotification(apk, remoteName, remoteCode);
                preferences.markUpdateCheck(System.currentTimeMillis(), remoteName, "");
                if (listener != null) listener.onChecked(true, remoteName, "");
            } catch (Exception e) {
                Log.w(TAG, "Update check failed", e);
                preferences.markUpdateCheck(System.currentTimeMillis(), "", e.getMessage());
                if (listener != null) listener.onChecked(false, "", e.getMessage());
            }
        });
    }

    private JSONObject fetchMetadata() throws Exception {
        URL url = new URL(preferences.getAdminUrl() + "/api/panel/update.php");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setConnectTimeout(5000);
        connection.setReadTimeout(7000);
        connection.setRequestProperty("X-Panel-Token", preferences.getPanelToken());

        int status = connection.getResponseCode();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(
                status >= 200 && status < 300
                        ? connection.getInputStream()
                        : connection.getErrorStream(),
                StandardCharsets.UTF_8))) {
            StringBuilder text = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) text.append(line);
            if (status < 200 || status >= 300) {
                throw new IllegalStateException("HTTP " + status + ": " + text);
            }
            JSONObject root = new JSONObject(text.toString());
            if (!root.optBoolean("ok", false)) {
                throw new IllegalStateException(root.optString("error", "Atualização indisponível"));
            }
            return root;
        } finally {
            connection.disconnect();
        }
    }

    private File downloadApk(String urlText, int versionCode) throws Exception {
        URL url = new URL(urlText);
        String protocol = url.getProtocol();
        if (!"http".equalsIgnoreCase(protocol) && !"https".equalsIgnoreCase(protocol)) {
            throw new IllegalArgumentException("URL de APK deve usar HTTP/HTTPS");
        }

        File dir = new File(context.getCacheDir(), "updates");
        if (!dir.exists() && !dir.mkdirs()) {
            throw new IllegalStateException("Não foi possível criar cache de atualização");
        }

        File destination = new File(dir, "PainelAndroid-" + versionCode + ".apk");
        File tmp = new File(destination.getAbsolutePath() + ".tmp");

        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setConnectTimeout(7000);
        connection.setReadTimeout(30000);
        connection.setInstanceFollowRedirects(true);

        int status = connection.getResponseCode();
        if (status < 200 || status >= 300) {
            connection.disconnect();
            throw new IllegalStateException("HTTP " + status + " no download do APK");
        }

        long declared = connection.getContentLengthLong();
        if (declared > MAX_APK_BYTES) {
            connection.disconnect();
            throw new IllegalStateException("APK excede limite de tamanho");
        }

        long total = 0L;
        try (BufferedInputStream in = new BufferedInputStream(connection.getInputStream());
             FileOutputStream out = new FileOutputStream(tmp)) {
            byte[] buffer = new byte[8192];
            int n;
            while ((n = in.read(buffer)) != -1) {
                total += n;
                if (total > MAX_APK_BYTES) {
                    throw new IllegalStateException("APK excede limite de tamanho");
                }
                out.write(buffer, 0, n);
            }
        } finally {
            connection.disconnect();
        }

        if (destination.exists()) destination.delete();
        if (!tmp.renameTo(destination)) {
            throw new IllegalStateException("Falha ao finalizar download do APK");
        }
        return destination;
    }

    private void showInstallNotification(File apk, String versionName, int versionCode) {
        Uri uri = FileProvider.getUriForFile(
                context,
                context.getPackageName() + ".fileprovider",
                apk
        );

        Intent install = new Intent(Intent.ACTION_VIEW);
        install.setDataAndType(uri, "application/vnd.android.package-archive");
        install.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_ACTIVITY_NEW_TASK);

        PendingIntent pending = PendingIntent.getActivity(
                context,
                versionCode,
                install,
                PendingIntent.FLAG_UPDATE_CURRENT |
                        (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ? PendingIntent.FLAG_IMMUTABLE : 0)
        );

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "painel_service")
                .setSmallIcon(R.drawable.ic_launcher)
                .setContentTitle("Atualização do Painel disponível")
                .setContentText("Versão " + versionName + " pronta para instalar")
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)
                .setContentIntent(pending);

        try {
            NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, builder.build());
        } catch (SecurityException e) {
            Log.w(TAG, "Sem permissão para notificação da atualização", e);
        }
    }

    private int getInstalledVersionCode() throws PackageManager.NameNotFoundException {
        PackageInfo info = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            return (int)Math.min(Integer.MAX_VALUE, info.getLongVersionCode());
        }
        return info.versionCode;
    }

    private static String sha256(File file) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        try (BufferedInputStream in = new BufferedInputStream(new java.io.FileInputStream(file))) {
            byte[] buffer = new byte[8192];
            int n;
            while ((n = in.read(buffer)) != -1) {
                digest.update(buffer, 0, n);
            }
        }

        StringBuilder hex = new StringBuilder();
        for (byte b : digest.digest()) {
            hex.append(String.format(Locale.ROOT, "%02x", b));
        }
        return hex.toString();
    }

    public void shutdown() {
        executor.shutdownNow();
    }
}
