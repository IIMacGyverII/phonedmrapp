package com.macdmr.radio;

import android.Manifest;
import android.content.pm.PackageManager;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.method.ScrollingMovementMethod;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Radio-engine spike UI: every step of bringing the radio up without the stock app, one button each,
 * with a live log. Order: Root setup → Stock app OFF → Open UART → Power on → Version → Tune → Audio RX.
 */
public class MainActivity extends AppCompatActivity implements RadioEngine.Events {
    private TextView log, state;
    private final Handler ui = new Handler(Looper.getMainLooper());
    private final SimpleDateFormat tf = new SimpleDateFormat("HH:mm:ss.SSS", Locale.US);
    private DeviceProfile profile;
    private RadioEngine engine;
    private TinyServiceAudio audio;
    private EditText freq;
    private volatile int lastRssi = -999;
    private volatile String lastStatus = "-";

    @Override protected void onCreate(Bundle b) {
        super.onCreate(b);
        profile = DeviceProfile.detect();
        engine = new RadioEngine(profile, this);

        LinearLayout root = new LinearLayout(this); root.setOrientation(LinearLayout.VERTICAL);
        int pad = (int) (8 * getResources().getDisplayMetrics().density); root.setPadding(pad, pad, pad, pad);
        state = new TextView(this); state.setTextSize(14); state.setTypeface(Typeface.MONOSPACE); root.addView(state);

        freq = new EditText(this); freq.setHint("RX=TX MHz (e.g. 162.500)"); freq.setText("162.500"); root.addView(freq);

        LinearLayout r1 = row(root), r2 = row(root), r3 = row(root), r4 = row(root);
        btn(r1, "Root setup", v -> bg(() -> {
            say("root: " + (RootSetup.haveRoot() ? "yes" : "NO"));
            try { say("sepolicy: " + RootSetup.applySepolicy(getFilesDir(), profile)); } catch (Exception e) { say("sepolicy: " + e); }
            say("stty: " + RootSetup.ensureTty(profile));
        }));
        btn(r1, "Stock app OFF", v -> bg(() -> say("disable: " + RootSetup.stockApp(profile, false))));
        btn(r1, "Stock app ON", v -> bg(() -> say("enable: " + RootSetup.stockApp(profile, true))));
        btn(r2, "Open UART", v -> bg(() -> { try { engine.open(); } catch (Exception e) { say("open: " + e); } }));
        btn(r2, "Power on", v -> bg(() -> { try { engine.powerOn(); } catch (Exception e) { say("power: " + e); } }));
        btn(r2, "Power cycle", v -> bg(() -> { try { engine.powerCycle(); } catch (Exception e) { say("power: " + e); } }));
        btn(r2, "Version", v -> bg(() -> { try { engine.queryVersion(); } catch (Exception e) { say(e.toString()); } }));
        btn(r3, "Tune FM", v -> bg(() -> {
            try {
                int hz = (int) Math.round(Double.parseDouble(freq.getText().toString().trim()) * 1e6);
                engine.setAnalog(hz, hz, hz < 300_000_000 ? 1 : 0, 0, 0, 0, 0, 0, 0, 8, 0);
            } catch (Exception e) { say("tune: " + e); }
        }));
        btn(r3, "RSSI", v -> bg(() -> { try { engine.queryRssi(); } catch (Exception e) { say(e.toString()); } }));
        btn(r3, "Audio RX on", v -> bg(() -> { try { if (audio == null) audio = new TinyServiceAudio(); say(audio.startRx(true)); } catch (Exception e) { say("audio: " + e); } }));
        btn(r3, "Audio RX off", v -> bg(() -> { if (audio != null) say(audio.stopRx()); }));
        Button ptt = btn(r4, "HOLD = PTT (voice)", null);
        ptt.setOnTouchListener((v, ev) -> {
            if (ev.getAction() == MotionEvent.ACTION_DOWN) { bg(() -> { try { engine.ptt(true); if (audio == null) audio = new TinyServiceAudio(); say(audio.startTx()); } catch (Exception e) { say("ptt: " + e); } }); }
            else if (ev.getAction() == MotionEvent.ACTION_UP || ev.getAction() == MotionEvent.ACTION_CANCEL) { bg(() -> { try { if (audio != null) say(audio.stopTx()); engine.ptt(false); } catch (Exception e) { say("ptt: " + e); } }); }
            return false;
        });
        btn(r4, "Close UART", v -> bg(() -> engine.close()));
        btn(r4, "Clear", v -> log.setText(""));

        ScrollView sv = new ScrollView(this);
        log = new TextView(this); log.setTextSize(11); log.setTypeface(Typeface.MONOSPACE); log.setMovementMethod(new ScrollingMovementMethod());
        sv.addView(log);
        root.addView(sv, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f));
        setContentView(root);

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED)
            ActivityCompat.requestPermissions(this, new String[] { Manifest.permission.RECORD_AUDIO }, 1);
        say("profile: " + profile.name + "  uart=" + profile.controlPort + "  audio=" + profile.audio + "  power=" + profile.powerNode);
        refreshState();
    }

    private LinearLayout row(LinearLayout parent) {
        LinearLayout r = new LinearLayout(this); r.setOrientation(LinearLayout.HORIZONTAL); r.setGravity(Gravity.CENTER);
        parent.addView(r); return r;
    }

    private Button btn(LinearLayout r, String text, View.OnClickListener l) {
        Button b = new Button(this); b.setText(text); b.setAllCaps(false); b.setTextSize(12);
        if (l != null) b.setOnClickListener(l);
        r.addView(b, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)); return b;
    }

    private void bg(Runnable r) { new Thread(r).start(); }

    private void say(String s) {
        final String line = tf.format(new Date()) + " " + s + "\n";
        ui.post(() -> { log.append(line); refreshState(); });
    }

    private void refreshState() {
        state.setText(String.format(Locale.US, "%s | uart %s | power %s | status %s | rssi %s",
                profile.name, engine.isOpen() ? "open" : "closed", engine.powerState(), lastStatus,
                lastRssi == -999 ? "-" : lastRssi + " dBm"));
    }

    // RadioEngine.Events
    @Override public void log(String s) { say(s); }
    @Override public void status(int code, String name) { lastStatus = name; say("STATUS " + code + " " + name); }
    @Override public void rssi(int raw, double dbm) { lastRssi = (int) Math.round(dbm); say("RSSI raw " + raw + " = " + dbm + " dBm"); }
    @Override public void version(int v, String text) { say("VERSION " + v + " (" + text + ")"); }
    @Override public void callerInfo(int type, int caller, int target) { say("CALLER type=" + type + " id=" + caller + " target=" + target); }
    @Override public void ack(int cmd, boolean ok) { say(String.format(Locale.US, "ACK 0x%02X %s", cmd, ok ? "ok" : "FAIL")); }
    @Override public void booted(String banner) { say("MODULE BOOTED: " + banner); }

    @Override protected void onDestroy() { super.onDestroy(); if (audio != null) { audio.stopRx(); } engine.close(); }
}
