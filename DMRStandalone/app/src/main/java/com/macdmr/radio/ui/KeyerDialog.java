package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.InputType;
import android.view.Gravity;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.VoiceKeyer;

import java.util.Locale;

/** Voice keyer: three recorded messages to send with one tap, and the ten-minute identification timer. */
public final class KeyerDialog {
    private KeyerDialog() { }

    public static void show(Context c, RadioService svc) {
        float d = Theme.dp(c);
        final VoiceKeyer k = svc.keyer();
        LinearLayout body = Neo.sheetBody(c, "Voice keyer");
        body.addView(Neo.sheetHint(c, "Record with the phone's microphone (Record, speak, Stop; up to 25 seconds, silence at the ends is trimmed). Listen plays it on the phone; Send transmits it on the current channel. With Morse ID on, your callsign follows in Morse on amateur channels."));
        final Handler h = new Handler(Looper.getMainLooper());
        final TextView[] info = new TextView[VoiceKeyer.SLOTS], recB = new TextView[VoiceKeyer.SLOTS], idB = new TextView[VoiceKeyer.SLOTS];
        final Runnable[] paint = new Runnable[1];
        for (int i = 0; i < VoiceKeyer.SLOTS; i++) {
            final int s = i;
            LinearLayout card = new LinearLayout(c); card.setOrientation(LinearLayout.VERTICAL); card.setBackground(Neo.rowCard(c)); card.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
            LinearLayout top = new LinearLayout(c); top.setGravity(Gravity.CENTER_VERTICAL);
            TextView name = Neo.text(c, k.name(s), Neo.TEXT, 16, Neo.ui(c));
            top.addView(name, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
            info[s] = Neo.text(c, "", Neo.MUTED, 13, Neo.uiMedium(c)); top.addView(info[s]);
            card.addView(top);
            name.setOnClickListener(v -> {
                final EditText e = new EditText(c); e.setText(k.name(s)); e.setSingleLine(true); e.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES);
                new AlertDialog.Builder(c).setTitle("Name this message").setView(e).setPositiveButton("OK", (dd, w) -> { String n = e.getText().toString().trim(); if (!n.isEmpty()) { k.setName(s, n); name.setText(n); } }).setNegativeButton("Cancel", null).show();
            });
            LinearLayout r = new LinearLayout(c); r.setBaselineAligned(false);
            recB[s] = Neo.button(c, "Record", "rec", Neo.RED);
            TextView listen = Neo.button(c, "Listen", "volume", Neo.CYAN), send = Neo.button(c, "Send", "send", Neo.GREEN);
            idB[s] = Neo.button(c, "", null, Neo.VIOLET);
            for (TextView b : new TextView[] { recB[s], listen, send, idB[s] }) { b.setTextSize(13); Neo.fit(b); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (2 * d), (int) (6 * d), (int) (2 * d), 0); r.addView(b, lp); }
            card.addView(r);
            LinearLayout.LayoutParams cl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); cl.bottomMargin = (int) (8 * d);
            body.addView(card, cl);
            recB[s].setOnClickListener(v -> {
                if (k.recordingSlot() == s) { k.stop(); return; }
                if (k.recordingSlot() >= 0) return;
                String e = k.start(s, () -> h.post(paint[0]));
                if (e != null) Toast.makeText(c, e, Toast.LENGTH_LONG).show();
                paint[0].run();
            });
            listen.setOnClickListener(v -> { if (k.has(s)) k.preview(s); else Toast.makeText(c, "Nothing recorded yet", Toast.LENGTH_SHORT).show(); });
            send.setOnClickListener(v -> { String e = svc.sendKeyer(s); Toast.makeText(c, e == null ? "Sending " + k.name(s) : e, Toast.LENGTH_SHORT).show(); });
            idB[s].setOnClickListener(v -> { k.setAddId(s, !k.addId(s)); paint[0].run(); });
        }
        body.addView(Neo.sheetSection(c, "Identification"));
        final TextView idClock = Neo.text(c, "", Neo.CYAN_LIGHT, 22, Neo.display(c)); idClock.setGravity(Gravity.CENTER); body.addView(idClock);
        body.addView(Neo.sheetHint(c, "Amateur rules ask for your callsign every ten minutes while you talk and at the end. The timer starts with your first transmission on an amateur channel after you last identified; when it runs out, the phone vibrates and reminds you as you key. A Morse ID (PKT, the keyer or after talking) restarts it, or tap I just identified after saying your callsign."));
        TextView done = Neo.button(c, "I just identified", "check", Neo.GREEN); body.addView(done);
        done.setOnClickListener(v -> { svc.markIdentified(); paint[0].run(); });
        paint[0] = () -> {
            for (int s = 0; s < VoiceKeyer.SLOTS; s++) {
                boolean recording = k.recordingSlot() == s;
                recB[s].setText(recording ? "Stop" : "Record");
                info[s].setText(recording ? "recording…" : k.has(s) ? String.format(Locale.US, "%.1f s", k.lengthMs(s) / 1000.0) : "empty");
                idB[s].setText(k.addId(s) ? "ID: on" : "ID: off");
            }
            long due = svc.idDueInMs();
            idClock.setText(due == Long.MAX_VALUE ? "ID timer idle" : due > 0 ? String.format(Locale.US, "ID due in %d:%02d", due / 60000, due / 1000 % 60) : "Identify now");
            idClock.setTextColor(due == Long.MAX_VALUE ? Neo.MUTED : due > 60_000 ? Neo.CYAN_LIGHT : Neo.AMBER_LIGHT);
        };
        final Runnable tick = new Runnable() { @Override public void run() { paint[0].run(); h.postDelayed(this, 1000); } };
        h.post(tick);
        AlertDialog a = Neo.showSheet(c, body);
        a.setOnDismissListener(x -> { h.removeCallbacks(tick); if (k.recordingSlot() >= 0) k.stop(); });
    }
}
