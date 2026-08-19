package br.com.maurinsoft.painelandroid;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SwitchCompat;

public class SettingsActivity extends AppCompatActivity {

    private EditText etPort;
    private SwitchCompat switchTts;
    private SwitchCompat switchChime;
    private EditText etAdsUrl;
    private Button btnSave;
    private Button btnTestCall;
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

        loadPreferences();

        btnSave.setOnClickListener(v -> saveAndExit());
        btnTestCall.setOnClickListener(v -> simulateTestCall());
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
