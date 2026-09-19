package br.com.maurinsoft.painelandroid;

import android.Manifest;
import android.animation.ArgbEvaluator;
import android.animation.ValueAnimator;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.VideoView;

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
    private FrameLayout mediaOverlay;
    private ImageView mediaImage;
    private VideoView mediaVideo;
    private TextView mediaStatus;

    private AppPreferences preferences;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
    private final SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());

    private final List<CallHistoryItem> historyList = new ArrayList<>();
    private ActivityResultLauncher<Intent> settingsLauncher;
    private boolean receiverRegistered = false;
    private MediaPlaylistManager mediaPlaylistManager;
    private final List<MediaItem> mediaItems = new ArrayList<>();
    private int mediaIndex = 0;
    private boolean mediaActive = false;
    private boolean playlistFromCache = false;

    private final Runnable idleMediaRunnable = this::startMediaIfAvailable;
    private final Runnable nextMediaRunnable = this::showNextMedia;
    private final Runnable refreshPlaylistRunnable = new Runnable() {
        @Override
        public void run() {
            loadPlaylist();
            handler.postDelayed(this, 15 * 60 * 1000L);
        }
    };

    private final BroadcastReceiver panelReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent == null || intent.getAction() == null) return;

            if (PanelService.ACTION_CALL.equals(intent.getAction())) {
                stopMediaForCall();
                restorePanelState();
                startBlinkAnimation();
                scheduleMediaAfterIdle();
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
        requestNotificationPermissionIfNeeded();
        mediaPlaylistManager = new MediaPlaylistManager(this);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        applyImmersiveMode();

        initViews();
        restorePanelState();
        setupSettingsLauncher();
        startClock();
        showConfiguredEndpoint();
        startPanelService();
        loadPlaylist();
        scheduleMediaAfterIdle();
        handler.postDelayed(refreshPlaylistRunnable, 15 * 60 * 1000L);
    }

    private void requestNotificationPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU
                && checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)
                != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.POST_NOTIFICATIONS}, 2700);
        }
    }

    private void applyImmersiveMode() {
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                        | View.SYSTEM_UI_FLAG_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
        );
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            applyImmersiveMode();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        registerPanelReceiver();
        restorePanelState();
        scheduleMediaAfterIdle();
    }

    @Override
    protected void onStop() {
        handler.removeCallbacks(idleMediaRunnable);
        handler.removeCallbacks(nextMediaRunnable);
        stopMedia();
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

        mediaOverlay = findViewById(R.id.mediaOverlay);
        mediaImage = findViewById(R.id.mediaImage);
        mediaVideo = findViewById(R.id.mediaVideo);
        mediaStatus = findViewById(R.id.mediaStatus);

        mediaVideo.setOnCompletionListener(mp -> showNextMedia());
        mediaVideo.setOnErrorListener((mp, what, extra) -> {
            showNextMedia();
            return true;
        });

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
                    loadPlaylist();
                    scheduleMediaAfterIdle();
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

    private void loadPlaylist() {
        String url = preferences.getAdsUrl();
        if (url == null || url.trim().isEmpty()) {
            mediaItems.clear();
            stopMedia();
            return;
        }

        mediaPlaylistManager.load(url, new MediaPlaylistManager.Listener() {
            @Override
            public void onPlaylistReady(List<MediaItem> items, boolean fromCache) {
                mediaItems.clear();
                mediaItems.addAll(items);
                playlistFromCache = fromCache;
                if (mediaIndex >= mediaItems.size()) mediaIndex = 0;
                if (mediaActive && !mediaItems.isEmpty()) {
                    showCurrentMedia();
                }
            }

            @Override
            public void onPlaylistError(String error) {
                if (mediaItems.isEmpty()) {
                    stopMedia();
                }
            }
        });
    }

    private void scheduleMediaAfterIdle() {
        handler.removeCallbacks(idleMediaRunnable);
        handler.removeCallbacks(nextMediaRunnable);

        if (preferences.getAdsUrl() == null || preferences.getAdsUrl().trim().isEmpty()) {
            stopMedia();
            return;
        }

        int seconds = Math.max(5, preferences.getIdleSeconds());
        handler.postDelayed(idleMediaRunnable, seconds * 1000L);
    }

    private void startMediaIfAvailable() {
        if (mediaItems.isEmpty()) {
            loadPlaylist();
            handler.postDelayed(idleMediaRunnable, 5000L);
            return;
        }

        mediaActive = true;
        mediaOverlay.setVisibility(View.VISIBLE);
        showCurrentMedia();
    }

    private void showCurrentMedia() {
        if (!mediaActive || mediaItems.isEmpty()) return;

        handler.removeCallbacks(nextMediaRunnable);
        if (mediaIndex < 0 || mediaIndex >= mediaItems.size()) mediaIndex = 0;

        MediaItem item = mediaItems.get(mediaIndex);
        if (item.getCachedFile() == null || !item.getCachedFile().isFile()) {
            showNextMedia();
            return;
        }

        mediaStatus.setVisibility(playlistFromCache ? View.VISIBLE : View.GONE);

        if (item.getType() == MediaItem.Type.IMAGE) {
            mediaVideo.stopPlayback();
            mediaVideo.setVisibility(View.GONE);
            mediaImage.setVisibility(View.VISIBLE);
            mediaImage.setImageURI(Uri.fromFile(item.getCachedFile()));
            handler.postDelayed(nextMediaRunnable, item.getDurationSeconds() * 1000L);
        } else {
            mediaImage.setVisibility(View.GONE);
            mediaVideo.setVisibility(View.VISIBLE);
            mediaVideo.setVideoURI(Uri.fromFile(item.getCachedFile()));
            mediaVideo.start();
        }
    }

    private void showNextMedia() {
        if (!mediaActive || mediaItems.isEmpty()) return;
        mediaIndex = (mediaIndex + 1) % mediaItems.size();
        showCurrentMedia();
    }

    private void stopMediaForCall() {
        stopMedia();
    }

    private void stopMedia() {
        mediaActive = false;
        handler.removeCallbacks(nextMediaRunnable);
        if (mediaVideo != null) {
            mediaVideo.stopPlayback();
            mediaVideo.setVisibility(View.GONE);
        }
        if (mediaImage != null) {
            mediaImage.setImageDrawable(null);
            mediaImage.setVisibility(View.GONE);
        }
        if (mediaOverlay != null) {
            mediaOverlay.setVisibility(View.GONE);
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
        handler.removeCallbacks(idleMediaRunnable);
        handler.removeCallbacks(nextMediaRunnable);
        handler.removeCallbacks(refreshPlaylistRunnable);
        stopMedia();
        if (mediaPlaylistManager != null) {
            mediaPlaylistManager.shutdown();
            mediaPlaylistManager = null;
        }
        unregisterPanelReceiver();
        super.onDestroy();
    }
}
