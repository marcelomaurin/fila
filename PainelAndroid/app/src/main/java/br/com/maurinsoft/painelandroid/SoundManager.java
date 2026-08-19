package br.com.maurinsoft.painelandroid;

import android.content.Context;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.ToneGenerator;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.speech.tts.TextToSpeech;
import android.speech.tts.UtteranceProgressListener;
import android.util.Log;

import java.util.Locale;

public class SoundManager implements TextToSpeech.OnInitListener {
    private static final String TAG = "SoundManager";
    private TextToSpeech tts;
    private boolean ttsReady = false;
    private ToneGenerator toneGenerator;
    private final Context context;
    private final Handler handler = new Handler(Looper.getMainLooper());

    public SoundManager(Context context) {
        this.context = context.getApplicationContext();
        try {
            this.toneGenerator = new ToneGenerator(AudioManager.STREAM_MUSIC, 100);
        } catch (Exception e) {
            Log.e(TAG, "Error initializing ToneGenerator", e);
        }
        this.tts = new TextToSpeech(this.context, this);
    }

    @Override
    public void onInit(int status) {
        if (status == TextToSpeech.SUCCESS) {
            int result = tts.setLanguage(new Locale("pt", "BR"));
            if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                result = tts.setLanguage(Locale.getDefault());
            }
            tts.setSpeechRate(0.95f);
            tts.setPitch(1.0f);
            ttsReady = (result != TextToSpeech.LANG_MISSING_DATA && result != TextToSpeech.LANG_NOT_SUPPORTED);
        } else {
            Log.e(TAG, "TTS Initialization failed");
        }
    }

    public void playChime() {
        try {
            if (toneGenerator != null) {
                toneGenerator.startTone(ToneGenerator.TONE_CDMA_ALERT_CALL_GUARD, 400);
            }
        } catch (Exception e) {
            Log.e(TAG, "Error playing chime", e);
        }
    }

    public void speakCall(String guiche, String senha, boolean chimeEnabled, boolean ttsEnabled) {
        if (chimeEnabled) {
            playChime();
        }

        if (!ttsEnabled || !ttsReady || tts == null) return;

        handler.postDelayed(() -> {
            try {
                String textToSpeak = "Senha " + senha + ", dirija-se ao guichê " + guiche;
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    tts.speak(textToSpeak, TextToSpeech.QUEUE_FLUSH, null, "CALL_" + System.currentTimeMillis());
                } else {
                    tts.speak(textToSpeak, TextToSpeech.QUEUE_FLUSH, null);
                }
            } catch (Exception e) {
                Log.e(TAG, "Error speaking", e);
            }
        }, chimeEnabled ? 500 : 0);
    }

    public void release() {
        if (tts != null) {
            tts.stop();
            tts.shutdown();
            tts = null;
        }
        if (toneGenerator != null) {
            toneGenerator.release();
            toneGenerator = null;
        }
    }
}
