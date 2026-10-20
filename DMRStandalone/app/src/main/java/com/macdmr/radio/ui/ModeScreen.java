package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

/**
 * A full-screen page for a mode that takes the radio over (APRS monitoring, SSTV receive, the parrot): what the
 * radio is doing right now (frequency, listening / receiving / transmitting, signal, time running), the mode's own
 * content, and its controls. Leaving the page (back arrow, Back key) keeps the mode running; the main screen then
 * shows a bar that brings the page back. Stop ends the mode and closes the page.
 */
public abstract class ModeScreen extends LinearLayout implements RadioService.Listener {
    protected final RadioService svc;
    protected final Context c;
    protected final float d;
    private final Runnable onClose;
    protected final LinearLayout header;
    private final TextView stateText, freqText, timeText, signalText;
    private final View stateDot;
    private final SignalBar signal;
    protected final FrameLayout content;
    protected final LinearLayout footer;
    private final Handler ui = new Handler(Looper.getMainLooper());
    private boolean rx, tx;
    private final long openedAt = System.currentTimeMillis();
    private final Runnable tick = new Runnable() { @Override public void run() {
        if (!stillRunning()) { onClose.run(); return; }      // the mode was stopped elsewhere
        showWaiting();
        if (!waiting) set(timeText, elapsed(since()));
        refresh();
        ui.postDelayed(this, 1000);
    } };

    protected ModeScreen(Context c, RadioService svc, String title, String accentIcon, int accent, Runnable onClose) {
        super(c);
        this.c = c; this.svc = svc; this.onClose = onClose; d = Theme.dp(c);
        setOrientation(VERTICAL);
        setBackground(Neo.page(c));
        setClickable(true);                                  // nothing underneath takes touches

        header = Neo.header(c, title, "");
        ImageView back = Neo.iconButton(c, "left", Neo.CYAN, "Back to the intercom (keeps running)");
        back.setOnClickListener(v -> onClose.run());
        LayoutParams bl = new LayoutParams(dp(44), dp(44)); bl.rightMargin = dp(12);
        header.addView(back, 0, bl);
        ImageView mark = Neo.iconTile(c, accentIcon, accent, 40);
        mark.setContentDescription("All packet tools"); mark.setOnClickListener(v -> PktDialog.show(c, svc));   // the whole PKT sheet, without leaving the mode
        Neo.addAction(header, mark);
        addView(header);

        // ---- live strip: state, frequency, signal, running time ----
        LinearLayout strip = new LinearLayout(c); strip.setOrientation(VERTICAL);
        strip.setBackground(Neo.card(c, Neo.alpha(accent, 0x55), 14)); strip.setPadding(dp(14), dp(10), dp(14), dp(10));
        LayoutParams sl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); sl.setMargins(dp(14), dp(10), dp(14), dp(6));
        LinearLayout top = new LinearLayout(c); top.setGravity(Gravity.CENTER_VERTICAL);
        stateDot = new View(c); stateDot.setBackground(Neo.outline(c, Neo.CYAN, 0xFF, 6, 0));
        LayoutParams dl = new LayoutParams(dp(10), dp(10)); dl.rightMargin = dp(8);
        top.addView(stateDot, dl);
        stateText = Neo.text(c, "LISTENING", Neo.CYAN, 15, Neo.ui(c)); stateText.setLetterSpacing(0.12f);
        top.addView(stateText, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        timeText = Neo.text(c, "", Neo.MUTED, 14, Neo.mono(c));
        top.addView(timeText);
        strip.addView(top);
        LinearLayout mid = new LinearLayout(c); mid.setGravity(Gravity.CENTER_VERTICAL); mid.setPadding(0, dp(6), 0, 0);
        freqText = Neo.text(c, "", Neo.TEXT, 26, Neo.display(c)); freqText.setSingleLine(true);
        mid.addView(freqText, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        LinearLayout sig = new LinearLayout(c); sig.setOrientation(VERTICAL); sig.setGravity(Gravity.END);
        signal = new SignalBar(c);
        sig.addView(signal, new LayoutParams(dp(120), dp(14)));
        signalText = Neo.text(c, "no signal", Neo.DIM, 12, Neo.mono(c)); signalText.setGravity(Gravity.END); signalText.setPadding(0, dp(3), 0, 0);
        sig.addView(signalText);
        mid.addView(sig);
        strip.addView(mid);
        addView(strip, sl);

        content = new FrameLayout(c);
        addView(content, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));

        footer = new LinearLayout(c); footer.setOrientation(VERTICAL); footer.setPadding(dp(14), dp(6), dp(14), dp(10));
        footer.setBackgroundColor(Neo.alpha(Neo.BAR, 0xF0));
        addView(footer);
    }

    // ---- what each mode supplies ----
    /** The mode is still on (false closes the page). */
    protected abstract boolean stillRunning();
    /** Once a second, and after radio events: update the mode's own content. */
    protected abstract void refresh();
    /** When the mode started (for the running time). */
    protected long since() { long s = svc.modeSince(); return s > 0 ? s : openedAt; }
    /** The line under the title. */
    protected void setSubtitle(String s) { TextView t = Neo.headerSubtitle(header); if (t != null) set(t, s); }
    /** Change a label only when its text differs (no relayout, no accessibility event every second). */
    protected static void set(TextView t, CharSequence s) { if (!android.text.TextUtils.equals(t.getText(), s)) t.setText(s); }
    protected static void color(TextView t, int col) { if (t.getCurrentTextColor() != col) t.setTextColor(col); }

    // ---- helpers for subclasses ----
    protected int dp(float v) { return Math.round(v * d); }
    protected LinearLayout buttonRow() {
        LinearLayout r = new LinearLayout(c); r.setOrientation(HORIZONTAL); r.setGravity(Gravity.CENTER_VERTICAL);
        LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.topMargin = dp(4); r.setLayoutParams(lp);
        footer.addView(r); return r;
    }
    protected TextView button(LinearLayout row, String label, String icon, int accent, View.OnClickListener l) {
        TextView b = Neo.button(c, label, icon, accent); b.setTextSize(14); Neo.fit(b); b.setOnClickListener(l);
        LayoutParams lp = new LayoutParams(0, dp(48), 1f); lp.setMargins(dp(3), 0, dp(3), 0);
        row.addView(b, lp); return b;
    }
    protected void toast(String s) { if (s != null) android.widget.Toast.makeText(c, s, android.widget.Toast.LENGTH_LONG).show(); }
    protected void close() { onClose.run(); }
    protected static String ago(long ts) {
        if (ts <= 0) return "—";
        long s = Math.max(0, (System.currentTimeMillis() - ts) / 1000);
        return s < 60 ? s + " s ago" : s < 3600 ? (s / 60) + " min ago" : (s / 3600) + " h " + (s % 3600 / 60) + " min ago";
    }
    private static String elapsed(long since) {
        long s = Math.max(0, (System.currentTimeMillis() - since) / 1000);
        return s >= 3600 ? String.format(java.util.Locale.US, "%d:%02d:%02d", s / 3600, s % 3600 / 60, s % 60) : String.format(java.util.Locale.US, "%02d:%02d", s / 60, s % 60);
    }
    /** A satellite pass the mode waits for: the frequency it will use (0 = not waiting). The radio stays on the
     *  channel until a minute before the pass, so the strip shows the pass frequency, dimmed, not the channel's. */
    protected long waitingHz() { return 0; }
    /** When the radio leaves the channel for the pass (with {@link #waitingHz}). */
    protected long waitingUntil() { return 0; }
    private boolean waiting;
    private void showWaiting() {
        long hz = waitingHz();
        boolean w = hz > 0;
        if (w) {
            set(stateText, "WAITING FOR THE PASS"); color(stateText, Neo.AMBER);
            stateDot.setBackground(Neo.outline(c, Neo.AMBER, 0xFF, 6, 0));
            android.text.SpannableString f = freqSpan(hz);
            if (!android.text.TextUtils.equals(freqText.getText(), f)) freqText.setText(f);
            color(freqText, Neo.MUTED);
            set(timeText, "");
            set(signalText, "tunes at " + new java.text.SimpleDateFormat("HH:mm", java.util.Locale.US).format(new java.util.Date(waitingUntil())));
            if (signal.getVisibility() != GONE) signal.setVisibility(GONE);      // nothing to measure yet: the radio is still on your channel
        } else if (waiting) {                                 // the pass began: back to the live radio
            signal.setVisibility(VISIBLE); set(signalText, "no signal");
            waiting = false; color(freqText, Neo.TEXT); showState();
            com.macdmr.radio.ChannelStore.Channel ch = svc.current(); if (ch != null) freqText.setText(freqSpan(ch.rxFreq));
        }
        waiting = w;
    }
    private static android.text.SpannableString freqSpan(long hz) {
        android.text.SpannableString f = new android.text.SpannableString(String.format(java.util.Locale.US, "%.4f", hz / 1e6) + " MHz");
        f.setSpan(new android.text.style.RelativeSizeSpan(0.5f), f.length() - 4, f.length(), 0);
        f.setSpan(new android.text.style.ForegroundColorSpan(Neo.MUTED), f.length() - 4, f.length(), 0);
        return f;
    }
    private void showState() {
        if (waiting) return;
        int col = tx ? Neo.RED : rx ? Neo.GREEN : Neo.CYAN;
        set(stateText, tx ? "TRANSMITTING" : rx ? "RECEIVING" : "LISTENING"); color(stateText, col);
        stateDot.setBackground(Neo.outline(c, col, 0xFF, 6, 0));
    }

    @Override protected void onAttachedToWindow() { super.onAttachedToWindow(); svc.addListener(this); ui.post(tick); }
    @Override protected void onDetachedFromWindow() { super.onDetachedFromWindow(); svc.removeListener(this); ui.removeCallbacks(tick); }

    // ---- RadioService.Listener ----
    @Override public void onChannel(ChannelStore.Channel ch) {
        if (ch == null || waiting) return;
        freqText.setText(freqSpan(ch.rxFreq));
    }
    @Override public void onRx(boolean receiving) { rx = receiving; showState(); if (!receiving && !waiting) { signal.set(-999); signalText.setText("no signal"); } }
    @Override public void onTx(boolean transmitting) { tx = transmitting; showState(); }
    @Override public void onRssi(int dbm) { if (waiting) return; signal.set(dbm); signalText.setText(dbm <= -999 ? "no signal" : SMeterView.sUnits(dbm) + "  " + dbm + " dBm"); }
    @Override public void onAudioLevel(int amplitude) { }
    @Override public void onHistory(String line) { }
    @Override public void onCaller(String text) { }
    @Override public void onLog(String s) { }
    @Override public void onLink(String state) { }
    @Override public void onLocation(String text) { }
    @Override public void onSms(int from, int type, String text) { }
    @Override public void onSmsResult(boolean ok) { }
    @Override public void onModes(boolean softSq, int softSqLevel, boolean squelchOpen, boolean monitor, boolean recording, boolean scanning, boolean holding, String zoneName) { refresh(); }
    @Override public void onCaption(boolean enabled, String live, String sentence) { }

    /** A slim segmented signal bar, S0 (-121 dBm) to S9+40 (-33 dBm). */
    private static final class SignalBar extends View {
        private final Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
        private int dbm = -999;
        SignalBar(Context c) { super(c); }
        void set(int v) { if (v != dbm) { dbm = v; invalidate(); } }
        @Override protected void onDraw(Canvas cv) {
            int n = 16; float w = getWidth(), h = getHeight(), gap = w * 0.02f, sw = (w - gap * (n - 1)) / n;
            float f = dbm <= -999 ? 0 : Math.max(0, Math.min(1, (dbm + 121) / 88f));
            int lit = Math.round(f * n);
            for (int i = 0; i < n; i++) {
                p.setColor(i < lit ? (i >= 12 ? Neo.AMBER : Neo.GREEN) : Neo.TRACK);
                float x = i * (sw + gap); cv.drawRoundRect(x, 0, x + sw, h, 2, 2, p);
            }
        }
    }
}
