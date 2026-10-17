package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.view.Gravity;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.SeekBar;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.CircuitBoardView;
import com.macdmr.radio.RadioService;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Locale;

/**
 * The intercom page, carried over from the module: channel digits with step arrows, the info block,
 * Signal / SCAN / ZONE row, Soft-SQ slider, the circuit-board panel with history + transcription,
 * the six mode satellites around the PTT key.
 */
public class IntercomView extends LinearLayout implements RadioService.Listener {
    private final Context ctx;
    private final TextView title, power, squelch, send, receive, location, signal, headline, historyText, transcriptionText, sqValue;
    private final SevenSegmentView digits;
    private final CircuitBoardView board;
    private final PttButton ptt;
    private final NeonToggle softSq, txt, vfo, rec, mon, pkt;
    private final Deque<String> history = new ArrayDeque<>();
    private RadioService svc;
    private ChannelStore.Channel channel;
    private boolean rx, tx;

    public IntercomView(Context c) {
        super(c);
        ctx = c;
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        float d = Theme.dp(c);

        // title bar
        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (20 * d), (int) (14 * d), (int) (16 * d), (int) (14 * d));
        title = Theme.label(c, "—", Theme.WHITE, 24, false);
        bar.addView(title, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        TextView menu = Theme.label(c, "☰", Theme.WHITE, 26, false); menu.setPadding((int) (8 * d), 0, 0, 0);
        bar.addView(menu);
        addView(bar);

        // digits + arrows
        LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER_VERTICAL); row.setPadding((int) (34 * d), (int) (6 * d), (int) (34 * d), 0);
        ArrowButton left = new ArrowButton(c, true), right = new ArrowButton(c, false);
        digits = new SevenSegmentView(c);
        row.addView(left);
        FrameLayout mid = new FrameLayout(c); mid.addView(digits, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.CENTER));
        row.addView(mid, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        row.addView(right);
        addView(row);
        left.setOnClickListener(v -> { if (svc != null) new Thread(() -> svc.stepChannel(-1)).start(); });
        right.setOnClickListener(v -> { if (svc != null) new Thread(() -> svc.stepChannel(1)).start(); });

        // info block: left labels, right location
        LinearLayout info = new LinearLayout(c); info.setPadding((int) (4 * d), (int) (6 * d), (int) (12 * d), (int) (10 * d));
        LinearLayout leftCol = new LinearLayout(c); leftCol.setOrientation(VERTICAL);
        power = Theme.label(c, "Power:", Theme.CYAN, 15, false); squelch = Theme.label(c, "Squelch Level:", Theme.CYAN, 15, false);
        send = Theme.label(c, "Send:", Theme.CYAN, 15, false); receive = Theme.label(c, "Receive:", Theme.CYAN, 15, false);
        for (TextView t : new TextView[] { power, squelch, send, receive }) leftCol.addView(t);
        info.addView(leftCol, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        location = Theme.label(c, "", Theme.WHITE, 15, false); location.setGravity(Gravity.END);
        info.addView(location, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        addView(info);

        // Signal / SCAN / ZONE
        LinearLayout sr = new LinearLayout(c); sr.setGravity(Gravity.CENTER_VERTICAL); sr.setPadding((int) (10 * d), 0, (int) (10 * d), (int) (8 * d));
        signal = Theme.label(c, "Signal: --", Theme.YELLOW, 18, true); signal.setGravity(Gravity.CENTER);
        signal.setBackground(Theme.rounded(c, 0x15FFFF00, 0xAAFFFF00, 2, 8)); signal.setPadding((int) (12 * d), (int) (10 * d), (int) (12 * d), (int) (10 * d));
        sr.addView(signal, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1.05f));
        TextView scan = Theme.pillButton(c, "🔍 SCAN"), zone = Theme.pillButton(c, "ZONE: ALL");
        scan.setTextSize(14); zone.setTextSize(14); zone.setMaxLines(2);
        LayoutParams lp = new LayoutParams(0, LayoutParams.MATCH_PARENT, 0.95f); lp.leftMargin = (int) (8 * d);
        sr.addView(scan, lp); sr.addView(zone, new LayoutParams(lp));
        addView(sr);

        // SQ slider
        LinearLayout sq = new LinearLayout(c); sq.setGravity(Gravity.CENTER_VERTICAL); sq.setPadding((int) (16 * d), 0, (int) (16 * d), (int) (4 * d));
        sq.addView(Theme.label(c, "SQ: ", Theme.GREY, 16, true));
        sqValue = Theme.label(c, "3", Theme.CYAN, 20, true); sq.addView(sqValue);
        SeekBar bar2 = new SeekBar(c); bar2.setMax(9); bar2.setProgress(3);
        bar2.setProgressTintList(android.content.res.ColorStateList.valueOf(Theme.CYAN)); bar2.setThumbTintList(android.content.res.ColorStateList.valueOf(Theme.CYAN));
        bar2.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override public void onProgressChanged(SeekBar s, int p, boolean u) { sqValue.setText(String.valueOf(p)); }
            @Override public void onStartTrackingTouch(SeekBar s) { } @Override public void onStopTrackingTouch(SeekBar s) { }
        });
        LayoutParams sl = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); sl.leftMargin = (int) (12 * d); sl.rightMargin = (int) (120 * d);
        sq.addView(bar2, sl);
        addView(sq);

        // circuit-board panel with history + transcription overlays
        FrameLayout panel = new FrameLayout(c);
        board = new CircuitBoardView(c);
        panel.addView(board, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        LinearLayout boxes = new LinearLayout(c); boxes.setOrientation(VERTICAL); boxes.setPadding((int) (14 * d), (int) (8 * d), (int) (14 * d), (int) (40 * d));
        LinearLayout hist = new LinearLayout(c); hist.setOrientation(VERTICAL);
        hist.setBackground(Theme.rounded(c, 0x18000000, 0x5500BFFF, 1, 8)); hist.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (10 * d));
        headline = Theme.label(c, "📻 Ready", Theme.GREEN, 20, true); hist.addView(headline);
        hist.addView(Theme.label(c, "Analog History", Theme.CYAN2, 16, true));
        historyText = Theme.label(c, "", Theme.CYAN2, 14, false); hist.addView(historyText);
        boxes.addView(hist);
        LinearLayout tr = new LinearLayout(c); tr.setOrientation(VERTICAL);
        tr.setBackground(Theme.rounded(c, 0xF0071626, 0xAA00BFFF, 1, 8)); tr.setPadding((int) (12 * d), (int) (6 * d), (int) (12 * d), (int) (8 * d));
        tr.addView(Theme.label(c, "📝 Transcription", Theme.CYAN2, 14, true));
        transcriptionText = Theme.label(c, "", Theme.WHITE, 14, false); tr.addView(transcriptionText);
        LayoutParams tl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); tl.topMargin = (int) (14 * d);
        boxes.addView(tr, tl); tr.setVisibility(GONE);
        panel.addView(boxes, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT));
        LayoutParams pl = new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f); pl.leftMargin = pl.rightMargin = (int) (10 * d);
        addView(panel, pl);

        // satellites + PTT
        FrameLayout bottom = new FrameLayout(c);
        bottom.setPadding((int) (10 * d), (int) (6 * d), (int) (10 * d), (int) (6 * d));
        ptt = new PttButton(c);
        bottom.addView(ptt, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.CENTER));
        LinearLayout lcol = new LinearLayout(c); lcol.setOrientation(VERTICAL);
        LinearLayout rcol = new LinearLayout(c); rcol.setOrientation(VERTICAL);
        softSq = new NeonToggle(c, "🎚️", "SOFT SQ", Theme.SOFTSQ); txt = new NeonToggle(c, "✍️", "TXT", Theme.TXT); vfo = new NeonToggle(c, "🎛️", "VFO", Theme.VFO);
        rec = new NeonToggle(c, "🔴", "REC", Theme.REC); mon = new NeonToggle(c, "👁️", "MON", Theme.MON); pkt = new NeonToggle(c, "📡", "PKT", Theme.PKT);
        for (NeonToggle t : new NeonToggle[] { softSq, txt, vfo }) { LayoutParams p = new LayoutParams((int) (84 * d), (int) (52 * d)); p.bottomMargin = (int) (8 * d); lcol.addView(t, p); }
        for (NeonToggle t : new NeonToggle[] { rec, mon, pkt }) { LayoutParams p = new LayoutParams((int) (84 * d), (int) (52 * d)); p.bottomMargin = (int) (8 * d); rcol.addView(t, p); }
        bottom.addView(lcol, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.START | Gravity.CENTER_VERTICAL));
        bottom.addView(rcol, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.END | Gravity.CENTER_VERTICAL));
        addView(bottom, new LayoutParams(LayoutParams.MATCH_PARENT, (int) (196 * d)));
        for (NeonToggle t : new NeonToggle[] { softSq, txt, vfo, rec, mon, pkt }) t.setOnClickListener(v -> t.toggle());

        ptt.setListener(down -> { if (svc != null) svc.ptt(down); ptt.setState(down ? PttButton.State.TX : PttButton.State.IDLE); });
    }

    public void attach(RadioService s) { svc = s; s.addListener(this); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    private void refreshHeadline() {
        if (tx) { headline.setText("🔴 Transmitting"); headline.setTextColor(Theme.RED); }
        else if (rx) { headline.setText("📻 Receiving..."); headline.setTextColor(Theme.GREEN); }
        else { headline.setText(svc != null && svc.isReady() ? "📻 Ready" : "⏳ " + (svc != null ? svc.link() : "")); headline.setTextColor(rx ? Theme.GREEN : Theme.CYAN2); }
        board.isReceiving = rx;
    }

    // RadioService.Listener
    @Override public void onChannel(ChannelStore.Channel ch) {
        channel = ch;
        title.setText(ch.name + (ch.rxFreq < 300_000_000 ? "(VHF)" : "(UHF)"));
        digits.setValue(ch.number);
        power.setText("Power:" + (ch.power == 1 ? "High power" : "Low power"));
        squelch.setText(ch.isDigital() ? "Color Code:" + ch.cc : "Squelch Level:" + ch.sq);
        send.setText("Send:" + ch.freqText(ch.txFreq)); receive.setText("Receive:" + ch.freqText(ch.rxFreq));
        location.setText(ch.location == null ? "" : ch.location);
        history.clear();
        for (String l : svc.store().recentHistory(ch.number, 3)) history.addLast(l);
        renderHistory();
    }
    @Override public void onRx(boolean receiving) { rx = receiving; refreshHeadline(); }
    @Override public void onTx(boolean transmitting) { tx = transmitting; refreshHeadline(); ptt.setState(tx ? PttButton.State.TX : PttButton.State.IDLE); }
    @Override public void onRssi(int dbm) { signal.setText(dbm == -999 ? "Signal: --" : "Signal: " + dbm + " dBm"); }
    @Override public void onAudioLevel(int amplitude) { board.audioAmplitude = amplitude; }
    @Override public void onHistory(String line) { history.addFirst(line); while (history.size() > 3) history.removeLast(); renderHistory(); }
    @Override public void onCaller(String text) { headline.setText("📻 " + text); }
    @Override public void onLog(String s) { }
    @Override public void onLink(String state) { refreshHeadline(); }

    private void renderHistory() {
        StringBuilder sb = new StringBuilder();
        for (String l : history) { if (sb.length() > 0) sb.append('\n'); sb.append(l); }
        historyText.setText(sb.toString());
    }
}
