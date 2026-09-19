package br.com.maurinsoft.painelandroid;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SwitchCompat;

public class SettingsActivity extends AppCompatActivity {

    private EditText etPort;
    private SwitchCompat switchTts;
    private SwitchCompat switchChime;
    private EditText etAdsUrl;
    private Button btnSave;
    private Button btnTestCall;
    private TextView tvDiagnostics;
    private AppPreferences preferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);

        preferences = new AppPreferences(this);

        etPort = findViewById(R.id.etPort);
        switchTts = findViewById(R.id.switchTts);
        switchChime = findViewById(R.id.switchChime);
        etAdsUrl = findViewById(R.id.etAdsUrl);
        btnSave = findViewById(R.id.btnSave);
        btnTestCall = findViewById(R.id.btnTestCall);
        tvDiagnostics = findViewById(R.id.tvDiagnostics);

        loadPreferences();
        refreshDiagnostics();

        btnSave.setOnClickListener(v -> saveAndExit());
        btnTestCall.setOnClickListener(v -> simulateTestCall());
    }

    @Override
    protected void onResume() {
        super.onResume();
        refreshDiagnostics();
    }

    private void refreshDiagnostics() {
        if (tvDiagnostics == null) return;

        long now = System.currentTimeMillis();
        long startedAt = preferences.getServiceStartedAt();
        long uptimeMs = startedAt > 0 ? Math.max(0L, now - startedAt) : 0L;
        long uptimeSeconds = uptimeMs / 1000L;
        long hours = uptimeSeconds / 3600L;
        long minutes = (uptimeSeconds % 3600L) / 60L;
        long seconds = uptimeSeconds % 60L;

        String lastCall = "Nunca";
        long lastCallAt = preferences.getLastCallAt();
        if (lastCallAt > 0) {
            lastCall = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss", Locale.getDefault())
                    .format(new Date(lastCallAt));
        }

        String status = preferences.isServerRunning() ? "ONLINE" : "OFFLINE";
        String lastError = preferences.getLastError();
        if (lastError == null || lastError.trim().isEmpty()) {
            lastError = "Nenhum";
        }

        String diagnostics = String.format(Locale.getDefault(),
                "Versão: %s\nIP: %s\nPorta: %d\nTCP: %s\nUptime: %02d:%02d:%02d\n" +
                        "Chamadas recebidas: %d\nÚltima chamada: %s\nTentativas de reconexão: %d\nÚltimo erro: %s",
                getAppVersionName(),
                NetworkUtils.getLocalIpAddress(this),
                preferences.getPort(),
                status,
                hours, minutes, seconds,
                preferences.getCallCount(),
                lastCall,
                preferences.getRetryCount(),
                lastError);

        tvDiagnostics.setText(diagnostics);
    }

    private String getAppVersionName() {
        try {
            PackageInfo info = getPackageManager().getPackageInfo(getPackageName(), 0);
            return info.versionName == null ? "?" : info.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            return "?";
        }
    }

    private void loadPreferences() {
        etPort.setText(String.valueOf(preferences.getPort()));
        switchTts.setChecked(preferences.isTtsEnabled());
        switchChime.setChecked(preferences.isChimeEnabled());
        etAdsUrl.setText(preferences.getAdsUrl());
    }

    private void saveAndExit() {
        try {
            int port = Integer.parseInt(etPort.getText().toString().trim());
            preferences.setPort(port);
            preferences.setTtsEnabled(switchTts.isChecked());
            preferences.setChimeEnabled(switchChime.isChecked());
            preferences.setAdsUrl(etAdsUrl.getText().toString().trim());

            Toast.makeText(this, "Configurações salvas!", Toast.LENGTH_SHORT).show();
            setResult(RESULT_OK);
            finish();
        } catch (NumberFormatException e) {
            Toast.makeText(this, "Porta inválida!", Toast.LENGTH_SHORT).show();
        }
    }

    private void simulateTestCall() {
        Intent resultIntent = new Intent();
        resultIntent.putExtra("SIMULATE_CALL", true);
        resultIntent.putExtra("TEST_GUICHE", "01");
        resultIntent.putExtra("TEST_SENHA", "A001");
        setResult(RESULT_OK, resultIntent);
        finish();
    }
}
