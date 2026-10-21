package com.macdmr.radio;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

/**
 * After a reboot the radio must never be left ownerless: while this app owns it the stock walkie-talkie
 * app is disabled, and a reboot (or a crash) in that state used to leave the phone with no radio app at all.
 * At boot either this app takes the radio again (Device tab: "Own the radio at boot") or the stock app is
 * re-enabled.
 */
public class BootReceiver extends BroadcastReceiver {
    @Override public void onReceive(final Context ctx, Intent intent) {
        if (intent == null || !Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) return;
        ProfileRegistry.init(ctx);
        final boolean own = ctx.getSharedPreferences("radio", Context.MODE_PRIVATE).getBoolean("ownAtBoot", false);
        if (!DeviceProfile.detect().supported) return;
        if (own && DeviceProfile.detect().verified) {                       // an untested profile never takes the radio by itself
            Intent svc = new Intent(ctx, RadioService.class).putExtra("bringUp", true);
            if (Build.VERSION.SDK_INT >= 26) ctx.startForegroundService(svc); else ctx.startService(svc);
            return;
        }
        final PendingResult pr = goAsync();
        new Thread(() -> {
            try {
                DeviceProfile p = DeviceProfile.detect();
                if (p != null && !RootSetup.stockAppEnabled(p)) RootSetup.stockApp(p, true);
            } catch (Throwable ignored) { }
            finally { pr.finish(); }
        }, "boot-restore").start();
    }
}
