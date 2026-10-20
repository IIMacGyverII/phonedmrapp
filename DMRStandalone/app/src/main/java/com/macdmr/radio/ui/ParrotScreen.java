package com.macdmr.radio.ui;

import android.content.Context;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.Parrot;

/** The simplex repeater (parrot): what it is doing now, how many transmissions it has repeated, and stop. */
public final class ParrotScreen extends ModeScreen {
    private final Parrot parrot;
    private final TextView now, count, last;

    public ParrotScreen(Context c, RadioService svc, Runnable onClose) {
        super(c, svc, "Parrot", "repeaters", Neo.AMBER, onClose);
        parrot = svc.parrot();
        ScrollView sv = new ScrollView(c); sv.setVerticalScrollBarEnabled(false);
        LinearLayout body = new LinearLayout(c); body.setOrientation(VERTICAL); body.setPadding(dp(14), dp(10), dp(14), dp(10));
        sv.addView(body);
        now = Neo.text(c, "", Neo.AMBER_LIGHT, 24, Neo.display(c)); now.setGravity(Gravity.CENTER); now.setPadding(0, dp(18), 0, dp(6));
        body.addView(now);
        LinearLayout stats = new LinearLayout(c); stats.setPadding(0, dp(10), 0, dp(10));
        count = stat(stats, "REPEATED"); last = stat(stats, "LAST HEARD");
        body.addView(stats);
        body.addView(Neo.sheetHint(c, "Everything the radio hears on this channel (up to " + Parrot.MAX_MS / 1000 + " s) is recorded and sent back a second after the other station stops, so they can check how they sound through you. With a callsign set, it adds your callsign in Morse to a replay at most every " + Parrot.ID_EVERY_MS / 60000 + " minutes. The radio's 30-second transmit limit caps each replay."));
        content.addView(sv);
        LinearLayout r = buttonRow();
        button(r, "Stop the parrot", "stop", Neo.RED, v -> { toast(svc.setParrot(false)); close(); });
    }

    private TextView stat(LinearLayout row, String label) {
        LinearLayout box = new LinearLayout(c); box.setOrientation(VERTICAL); box.setGravity(Gravity.CENTER);
        box.setBackground(Neo.card(c, Neo.LINE_SOFT, 10)); box.setPadding(dp(4), dp(10), dp(4), dp(10));
        TextView v = Neo.text(c, "0", Neo.TEXT, 24, Neo.display(c)); v.setGravity(Gravity.CENTER);
        TextView l = Neo.text(c, label, Neo.DIM, 11, Neo.ui(c)); l.setGravity(Gravity.CENTER); l.setLetterSpacing(0.08f);
        box.addView(v); box.addView(l);
        LayoutParams lp = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); lp.setMargins(dp(3), 0, dp(3), 0);
        row.addView(box, lp); return v;
    }

    @Override protected boolean stillRunning() { return parrot.enabled(); }
    @Override protected void refresh() {
        com.macdmr.radio.ChannelStore.Channel ch = svc.current();
        setSubtitle("Repeating on " + (ch != null ? "Ch " + ch.number + " · " + ch.name : "this channel"));
        set(now, parrot.playing() ? "REPLAYING" : parrot.recording() ? "RECORDING" : "WAITING");
        color(now, parrot.playing() ? Neo.RED : parrot.recording() ? Neo.GREEN_LIGHT : Neo.AMBER_LIGHT);
        set(count, String.valueOf(parrot.played()));
        set(last, parrot.lastHeardMs() <= 0 ? "—" : ago(parrot.lastHeardMs()).replace(" ago", ""));
    }
}
