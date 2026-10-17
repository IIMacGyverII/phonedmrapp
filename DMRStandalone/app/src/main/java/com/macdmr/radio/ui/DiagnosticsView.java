package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.text.method.ScrollingMovementMethod;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/** Engine log and link controls (the spike UI), reachable from Settings → Diagnostics. */
public class DiagnosticsView extends LinearLayout implements RadioService.Listener {
    private final TextView log, state;
    private final SimpleDateFormat tf = new SimpleDateFormat("HH:mm:ss.SSS", Locale.US);
    private RadioService svc;

    public DiagnosticsView(Context c) {
        super(c);
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        int pad = Theme.dp(c, 10); setPadding(pad, pad, pad, pad);
        state = Theme.label(c, "", Theme.CYAN, 13, false); state.setTypeface(Typeface.MONOSPACE); addView(state);
        LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER);
        TextView up = Theme.pillButton(c, "Bring radio up"), down = Theme.pillButton(c, "Release (stock app on)"), rssi = Theme.pillButton(c, "RSSI"), clear = Theme.pillButton(c, "Clear");
        for (TextView t : new TextView[] { up, down, rssi, clear }) { LayoutParams p = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); p.setMargins(4, 8, 4, 8); row.addView(t, p); }
        addView(row);
        up.setOnClickListener(v -> { if (svc != null) svc.bringUp(); });
        down.setOnClickListener(v -> { if (svc != null) svc.shutDown(true); });
        rssi.setOnClickListener(v -> { if (svc != null) svc.pollRssi(); });
        ScrollView sv = new ScrollView(c);
        log = new TextView(c); log.setTextSize(11); log.setTypeface(Typeface.MONOSPACE); log.setTextColor(0xFFB0E8F0); log.setMovementMethod(new ScrollingMovementMethod());
        sv.addView(log);
        clear.setOnClickListener(v -> log.setText(""));
        addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
    }

    public void attach(RadioService s) { svc = s; s.addListener(this); state.setText("profile " + s.profile().name + " · uart " + s.profile().controlPort + " · audio " + s.profile().audio); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    private void say(String s) { log.append(tf.format(new Date()) + " " + s + "\n"); }

    @Override public void onChannel(ChannelStore.Channel ch) { say("channel " + ch.number + " " + ch.name); }
    @Override public void onRx(boolean r) { say(r ? "RECEIVE_START" : "RECEIVE_STOP"); }
    @Override public void onTx(boolean t) { say(t ? "SEND_START" : "SEND_STOP"); }
    @Override public void onRssi(int dbm) { say("RSSI " + dbm + " dBm"); }
    @Override public void onAudioLevel(int a) { }
    @Override public void onHistory(String line) { }
    @Override public void onCaller(String text) { say("caller " + text); }
    @Override public void onLog(String s) { say(s); }
    @Override public void onLink(String st) { say("link: " + st); }
    @Override public void onSms(int from, int type, String text) { }
    @Override public void onSmsResult(boolean ok) { }
    @Override public void onLocation(String text) { }
    @Override public void onModes(boolean a, int b, boolean c2, boolean d2, boolean e, boolean f2, boolean g, String z) { }
}
