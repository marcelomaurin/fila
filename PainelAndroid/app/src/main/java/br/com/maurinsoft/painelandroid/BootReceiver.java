package br.com.maurinsoft.painelandroid;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.core.content.ContextCompat;

public class BootReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent == null || !Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            return;
        }

        Intent serviceIntent = new Intent(context, PanelService.class);
        ContextCompat.startForegroundService(context, serviceIntent);
    }
}
