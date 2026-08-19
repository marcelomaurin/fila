package br.com.maurinsoft.painelandroid;

import android.animation.ArgbEvaluator;
import android.animation.ValueAnimator;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
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

public class MainActivity extends AppCompatActivity implements TcpServerManager.OnCallReceivedListener {

    private TextView tvHeaderTitle;
    private TextView tvIpStatus;
    private Button btnOpenSettings;

    private CardView currentCallCard;
    private TextView lblGuiche;
    private TextView tvCurrentGuiche;
    private TextView lblSenha;
    private TextView tvCurrentSenha;

    // History Views
    private TextView tvHistGuiche1, tvHistSenha1;
    private TextView tvHistGuiche2, tvHistSenha2;
    private TextView tvHistGuiche3, tvHistSenha3;
    private TextView tvHistGuiche4, tvHistSenha4;

    // Footer Views
    private TextView tvDate, tvTime, tvMarqueeMessage;

    private AppPreferences preferences;
    private SoundManager soundManager;
    private TcpServerManager tcpServer;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
    private final SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());

    private final List<CallHistoryItem> historyList = new ArrayList<>();
    private ActivityResultLauncher<Intent> settingsLauncher;

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
        soundManager = new SoundManager(this);

        initViews();
        setupSettingsLauncher();
        startClock();
        startTcpServer();
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
                if (result.getResultCode() == RESULT_OK) {
                    // Restart TCP Server if port changed
                    restartTcpServer();
                    if (result.getData() != null && result.getData().getBooleanExtra("SIMULATE_CALL", false)) {
                        String g = result.getData().getStringExtra("TEST_GUICHE");
                        String s = result.getData().getStringExtra("TEST_SENHA");
                        onCallReceived(g != null ? g : "01", s != null ? s : "A001");
                    }
                }
            }
        );
    }

    private void openSettings() {
        Intent intent = new Intent(this, SettingsActivity.class);
        settingsLauncher.launch(intent);
    }

    private void startClock() {
        handler.post(clockRunnable);
    }

    private void startTcpServer() {
        int port = preferences.getPort();
        String ip = NetworkUtils.getLocalIpAddress(this);
        tvIpStatus.setText(String.format(Locale.getDefault(), "IP: %s | Porta: %d", ip, port));

        tcpServer = new TcpServerManager(port, this);
        tcpServer.start();
    }

    private void restartTcpServer() {
        if (tcpServer != null) {
            tcpServer.stop();
        }
        startTcpServer();
    }

    @Override
    public void onCallReceived(String guiche, String senha) {
        // Shift previous current call to history
        String oldGuiche = tvCurrentGuiche.getText().toString();
        String oldSenha = tvCurrentSenha.getText().toString();

        if (!oldSenha.equals("A000") && !oldSenha.equals("----") && !oldSenha.equals(senha)) {
            historyList.add(0, new CallHistoryItem(oldGuiche, oldSenha));
            if (historyList.size() > 4) {
                historyList.remove(historyList.size() - 1);
            }
            updateHistoryUI();
        }

        // Update Current Call Display
        tvCurrentGuiche.setText(guiche);
        tvCurrentSenha.setText(senha);

        // Visual blinking animation
        startBlinkAnimation();

        // Sound chime and speech announcement
        soundManager.speakCall(guiche, senha, preferences.isChimeEnabled(), preferences.isTtsEnabled());
    }

    private void updateHistoryUI() {
        if (historyList.size() > 0) {
            tvHistGuiche1.setText("Guichê " + historyList.get(0).getGuiche());
            tvHistSenha1.setText(historyList.get(0).getSenha());
        }
        if (historyList.size() > 1) {
            tvHistGuiche2.setText("Guichê " + historyList.get(1).getGuiche());
            tvHistSenha2.setText(historyList.get(1).getSenha());
        }
        if (historyList.size() > 2) {
            tvHistGuiche3.setText("Guichê " + historyList.get(2).getGuiche());
            tvHistSenha3.setText(historyList.get(2).getSenha());
        }
        if (historyList.size() > 3) {
            tvHistGuiche4.setText("Guichê " + historyList.get(3).getGuiche());
            tvHistSenha4.setText(historyList.get(3).getSenha());
        }
    }

    private void startBlinkAnimation() {
        int colorNormal = ContextCompat.getColor(this, R.color.bg_surface);
        int colorHighlight = Color.parseColor("#7F1D1D"); // Deep Red

        ValueAnimator anim = ValueAnimator.ofObject(new ArgbEvaluator(), colorNormal, colorHighlight, colorNormal);
        anim.setDuration(600);
        anim.setRepeatCount(3);
        anim.addUpdateListener(animator -> {
            int color = (int) animator.getAnimatedValue();
            currentCallCard.setCardBackgroundColor(color);
        });
        anim.start();
    }

    @Override
    public void onStatusChanged(boolean running, String ip, int port) {
        String localIp = NetworkUtils.getLocalIpAddress(this);
        if (running) {
            tvIpStatus.setText(String.format(Locale.getDefault(), "IP: %s | Porta: %d", localIp, preferences.getPort()));
        } else {
            tvIpStatus.setText(R.string.status_error);
        }
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
        super.onDestroy();
        handler.removeCallbacks(clockRunnable);
        if (tcpServer != null) {
            tcpServer.stop();
        }
        if (soundManager != null) {
            soundManager.release();
        }
    }
}
