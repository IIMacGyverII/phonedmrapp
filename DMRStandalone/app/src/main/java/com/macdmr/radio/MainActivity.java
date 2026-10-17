package com.macdmr.radio;

import android.Manifest;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import com.macdmr.radio.ui.DiagnosticsView;
import com.macdmr.radio.ui.IntercomView;
import com.macdmr.radio.ui.Theme;

/** App shell: bottom navigation (Intercom · Channels · Contacts · Messages · Settings) over one content frame. */
public class MainActivity extends AppCompatActivity {
    private FrameLayout content;
    private IntercomView intercom;
    private DiagnosticsView diagnostics;
    private RadioService svc;
    private final TextView[] tabs = new TextView[5], tabEmoji = new TextView[5];
    private final View[] tabInd = new View[5];
    private final String[] tabIcons = { "🎙️", "📋", "👤", "💬", "📻" };
    private final String[] tabNames = { "Intercom", "Channel", "Contact", "Message", "Device" };
    private int tab = 0;
    private final Handler ui = new Handler(Looper.getMainLooper());
    private final Runnable rssiTick = new Runnable() { @Override public void run() { if (svc != null && svc.isReady() && tab == 0) svc.pollRssi(); ui.postDelayed(this, 2000); } };

    private final ServiceConnection conn = new ServiceConnection() {
        @Override public void onServiceConnected(ComponentName n, IBinder b) {
            svc = ((RadioService.LocalBinder) b).get();
            intercom.attach(svc); diagnostics.attach(svc);
            if (!svc.isReady()) svc.bringUp();
            ui.post(rssiTick);
        }
        @Override public void onServiceDisconnected(ComponentName n) { svc = null; }
    };

    @Override protected void onCreate(Bundle b) {
        super.onCreate(b);
        LinearLayout root = new LinearLayout(this); root.setOrientation(LinearLayout.VERTICAL); root.setBackgroundColor(Theme.BG);
        content = new FrameLayout(this);
        root.addView(content, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f));
        LinearLayout nav = new LinearLayout(this); nav.setBackgroundColor(0xFF060D1A); nav.setPadding(0, Theme.dp(this, 6), 0, Theme.dp(this, 6));
        for (int i = 0; i < 5; i++) {
            final int idx = i;
            LinearLayout tab = new LinearLayout(this); tab.setOrientation(LinearLayout.VERTICAL); tab.setGravity(Gravity.CENTER_HORIZONTAL);
            TextView e = new TextView(this); e.setGravity(Gravity.CENTER); e.setTextSize(22); e.setText(tabIcons[i]);
            TextView t = new TextView(this); t.setGravity(Gravity.CENTER); t.setTextSize(10); t.setText(tabNames[i]);
            View ind = new View(this); LinearLayout.LayoutParams il = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, Theme.dp(this, 2)); il.setMargins(Theme.dp(this, 8), Theme.dp(this, 2), Theme.dp(this, 8), 0);
            tab.addView(e); tab.addView(t); tab.addView(ind, il);
            tab.setOnClickListener(v -> show(idx));
            tabs[i] = t; tabEmoji[i] = e; tabInd[i] = ind;
            nav.addView(tab, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        }
        root.addView(nav);
        setContentView(root);
        getWindow().setStatusBarColor(Theme.TITLE_BG); getWindow().setNavigationBarColor(Theme.NAV_BG);

        intercom = new IntercomView(this);
        diagnostics = new DiagnosticsView(this);
        show(0);

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED)
            ActivityCompat.requestPermissions(this, new String[] { Manifest.permission.RECORD_AUDIO, Manifest.permission.POST_NOTIFICATIONS }, 1);
        Intent si = new Intent(this, RadioService.class);
        startForegroundService(si);
        bindService(si, conn, Context.BIND_AUTO_CREATE);
    }

    private void show(int idx) {
        tab = idx;
        content.removeAllViews();
        View v;
        switch (idx) {
            case 0: v = intercom; break;
            case 4: v = diagnostics; break;
            default: v = placeholder(tabNames[idx]);
        }
        content.addView(v, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        for (int i = 0; i < 5; i++) {
            boolean a = i == idx;
            tabs[i].setTextColor(a ? Theme.CYAN : 0xFF705090);
            if (a) tabEmoji[i].setShadowLayer(8f, 0f, 0f, Theme.CYAN); else tabEmoji[i].setShadowLayer(0f, 0f, 0f, 0);
            tabInd[i].setBackgroundColor(a ? Theme.CYAN : 0x00000000);
        }
    }

    private View placeholder(String name) {
        TextView t = Theme.label(this, name + "\n\ncoming next", 0xFF8A7FB0, 18, false); t.setGravity(Gravity.CENTER); return t;
    }

    @Override protected void onDestroy() {
        super.onDestroy();
        ui.removeCallbacks(rssiTick);
        if (svc != null) { intercom.detach(); diagnostics.detach(); }
        try { unbindService(conn); } catch (Throwable ignored) { }
    }
}
