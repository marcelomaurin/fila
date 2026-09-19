package br.com.maurinsoft.painelandroid;

import android.animation.ArgbEvaluator;
import android.animation.ValueAnimator;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.KeyEvent;
import android.widget.Button;
import android.widget.TextView;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.core.content.ContextCompat;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    private TextView tvHeaderTitle;
    private TextView tvIpStatus;
    private Button btnOpenSettings;

    private CardView currentCallCard;
    private TextView lblGuiche;
    private TextView tvCurrentGuiche;
    private TextView lblSenha;
    private TextView tvCurrentSenha;

    private TextView tvHistGuiche1, tvHistSenha1;
    private TextView tvHistGuiche2, tvHistSenha2;
    private TextView tvHistGuiche3, tvHistSenha3;
    private TextView tvHistGuiche4, tvHistSenha4;

    private TextView tvDate, tvTime, tvMarqueeMessage;

    private AppPreferences preferences;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
    private final SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());

    private final List<CallHistoryItem> historyList = new ArrayList<>();
    private ActivityResultLauncher<Intent> settingsLauncher;
    private boolean receiverRegistered = false;

    private final BroadcastReceiver panelReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent == null || intent.getAction() == null) return;

            if (PanelService.ACTION_CALL.equals(intent.getAction())) {
                restorePanelState();
                startBlinkAnimation();
            } else if (PanelService.ACTION_STATUS.equals(intent.getAction())) {
                boolean running = intent.getBooleanExtra(PanelService.EXTRA_RUNNING, false);
                int port = intent.getIntExtra(PanelService.EXTRA_PORT, preferences.getPort());
                updateConnectionStatus(running, port);
            } else if (PanelService.ACTION_GROUP.equals(intent.getAction())) {
                String id = intent.getStringExtra(PanelService.EXTRA_GROUP_ID);
                String description = intent.getStringExtra(PanelService.EXTRA_GROUP_DESCRIPTION);
                if (id != null && description != null) {
                    preferences.setGroupDescription(id, description);
                }
            }
        }
    };

    private final Runnable clockRunnable = new Runnable() {
        @Override
        public void run() {
            Date now = new Date();
            tvDate.setText(dateFormat.format(now));
            tvTime.setText(timeFormat.format(now));
            handler.postDelayed(this, 1000);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        preferences = new AppPreferences(this);

        initViews();
        restorePanelState();
        setupSettingsLauncher();
        startClock();
        showConfiguredEndpoint();
        startPanelService();
    }

    @Override
    protected void onStart() {
        super.onStart();
        registerPanelReceiver();
        restorePanelState();
    }

    @Override
    protected void onStop() {
        unregisterPanelReceiver();
        super.onStop();
    }

    private void initViews() {
        tvHeaderTitle = findViewById(R.id.tvHeaderTitle);
        tvIpStatus = findViewById(R.id.tvIpStatus);
        btnOpenSettings = findViewById(R.id.btnOpenSettings);

        currentCallCard = findViewById(R.id.currentCallCard);
        lblGuiche = findViewById(R.id.lblGuiche);
        tvCurrentGuiche = findViewById(R.id.tvCurrentGuiche);
        lblSenha = findViewById(R.id.lblSenha);
        tvCurrentSenha = findViewById(R.id.tvCurrentSenha);

        tvHistGuiche1 = findViewById(R.id.tvHistGuiche1);
        tvHistSenha1 = findViewById(R.id.tvHistSenha1);
        tvHistGuiche2 = findViewById(R.id.tvHistGuiche2);
        tvHistSenha2 = findViewById(R.id.tvHistSenha2);
        tvHistGuiche3 = findViewById(R.id.tvHistGuiche3);
        tvHistSenha3 = findViewById(R.id.tvHistSenha3);
        tvHistGuiche4 = findViewById(R.id.tvHistGuiche4);
        tvHistSenha4 = findViewById(R.id.tvHistSenha4);

        tvDate = findViewById(R.id.tvDate);
        tvTime = findViewById(R.id.tvTime);
        tvMarqueeMessage = findViewById(R.id.tvMarqueeMessage);
        tvMarqueeMessage.setSelected(true);

        btnOpenSettings.setOnClickListener(v -> openSettings());
        tvIpStatus.setOnClickListener(v -> openSettings());
    }

    private void setupSettingsLauncher() {
        settingsLauncher = registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                result -> {
                    if (result.getResultCode() != RESULT_OK) return;

                    Intent restart = new Intent(this, PanelService.class);
                    restart.setAction(PanelService.ACTION_RESTART_SERVER);
                    ContextCompat.startForegroundService(this, restart);

                    if (result.getData() != null
                            && result.getData().getBooleanExtra("SIMULATE_CALL", false)) {
                        Intent simulate = new Intent(this, PanelService.class);
                        simulate.setAction(PanelService.ACTION_SIMULATE);
                        simulate.putExtra(PanelService.EXTRA_GUICHE,
                                result.getData().getStringExtra("TEST_GUICHE"));
                        simulate.putExtra(PanelService.EXTRA_SENHA,
                                result.getData().getStringExtra("TEST_SENHA"));
                        ContextCompat.startForegroundService(this, simulate);
                    }

                    showConfiguredEndpoint();
                }
        );
    }

    private void openSettings() {
        settingsLauncher.launch(new Intent(this, SettingsActivity.class));
    }

    private void startClock() {
        handler.post(clockRunnable);
    }

    private void startPanelService() {
        Intent serviceIntent = new Intent(this, PanelService.class);
        ContextCompat.startForegroundService(this, serviceIntent);
    }

    private void registerPanelReceiver() {
        if (receiverRegistered) return;

        IntentFilter filter = new IntentFilter();
        filter.addAction(PanelService.ACTION_CALL);
        filter.addAction(PanelService.ACTION_GROUP);
        filter.addAction(PanelService.ACTION_STATUS);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(panelReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(panelReceiver, filter);
        }
        receiverRegistered = true;
    }

    private void unregisterPanelReceiver() {
        if (!receiverRegistered) return;
        unregisterReceiver(panelReceiver);
        receiverRegistered = false;
    }

    private void showConfiguredEndpoint() {
        String localIp = NetworkUtils.getLocalIpAddress(this);
        tvIpStatus.setText(String.format(Locale.getDefault(),
                "IP: %s | Porta: %d", localIp, preferences.getPort()));
    }

    private void updateConnectionStatus(boolean running, int port) {
        if (running) {
            String localIp = NetworkUtils.getLocalIpAddress(this);
            tvIpStatus.setText(String.format(Locale.getDefault(),
                    "● ONLINE | IP: %s | Porta: %d", localIp, port));
        } else {
            tvIpStatus.setText(R.string.status_error);
        }
    }

    private void restorePanelState() {
        String currentGuiche = preferences.getCurrentGuiche();
        String currentSenha = preferences.getCurrentSenha();

        if (currentGuiche != null && !currentGuiche.trim().isEmpty()) {
            tvCurrentGuiche.setText(currentGuiche);
        }
        if (currentSenha != null && !currentSenha.trim().isEmpty()) {
            tvCurrentSenha.setText(currentSenha);
        }

        historyList.clear();
        historyList.addAll(preferences.loadHistory());
        updateHistoryUI();
    }

    private void updateHistoryUI() {
        TextView[] guiches = {tvHistGuiche1, tvHistGuiche2, tvHistGuiche3, tvHistGuiche4};
        TextView[] senhas = {tvHistSenha1, tvHistSenha2, tvHistSenha3, tvHistSenha4};

        for (int i = 0; i < guiches.length; i++) {
            if (i < historyList.size()) {
                guiches[i].setText("Guichê " + historyList.get(i).getGuiche());
                senhas[i].setText(historyList.get(i).getSenha());
            } else {
                guiches[i].setText("Guichê --");
                senhas[i].setText("----");
            }
        }
    }

    private void startBlinkAnimation() {
        int colorNormal = ContextCompat.getColor(this, R.color.bg_surface);
        int colorHighlight = Color.parseColor("#7F1D1D");

        ValueAnimator anim = ValueAnimator.ofObject(
                new ArgbEvaluator(), colorNormal, colorHighlight, colorNormal);
        anim.setDuration(600);
        anim.setRepeatCount(3);
        anim.addUpdateListener(animator ->
                currentCallCard.setCardBackgroundColor((int) animator.getAnimatedValue()));
        anim.start();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_MENU || keyCode == KeyEvent.KEYCODE_SETTINGS) {
            openSettings();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onDestroy() {
        handler.removeCallbacks(clockRunnable);
        unregisterPanelReceiver();
        super.onDestroy();
    }
}
