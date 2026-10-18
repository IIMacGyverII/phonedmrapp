package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.CircuitBoardView;
import com.macdmr.radio.R;
import com.macdmr.radio.RadioService;

import java.util.ArrayDeque;
import java.util.Deque;

/**
 * The intercom page exactly as the module renders it on the OEM screen: OEM geometry (60 dp arrows,
 * 34×58 dp digit bitmaps, 15 sp info text, 176 dp PTT) plus the module's injected rows with their
 * original sizes, margins, colours and artwork.
 */
public class IntercomView extends LinearLayout implements RadioService.Listener {
    private static final int[] DIGITS = { R.drawable.interphone_talkback_num_0, R.drawable.interphone_talkback_num_1, R.drawable.interphone_talkback_num_2,
            R.drawable.interphone_talkback_num_3, R.drawable.interphone_talkback_num_4, R.drawable.interphone_talkback_num_5, R.drawable.interphone_talkback_num_6,
            R.drawable.interphone_talkback_num_7, R.drawable.interphone_talkback_num_8, R.drawable.interphone_talkback_num_9 };

    private final TextView title, power, squelch, send, receive, location, signal, headline, historyHeader, historyText, transcriptionText, sqValue, scanBtn, zoneBtn;
    private final SeekBar sqSeek;
    private boolean sqFromUser;
    private final ImageView digitOne, digitTwo;
    private final TextView vfoLabel;
    private final LinearLayout transcriptionBox;
    private final TextView captionLive;
    private final android.widget.ScrollView captionScroll;
    private final java.util.ArrayDeque<String> captionLines = new java.util.ArrayDeque<>();
    private final CircuitBoardView board;
    private final PttButton ptt;
    private final NeonToggle softSq, txt, vfo, rec, mon, pkt;
    private final Deque<String> history = new ArrayDeque<>();
    private RadioService svc;
    private boolean rx, tx;

    public IntercomView(Context c) {
        super(c);
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        final float d = Theme.dp(c);
        final int dp10 = (int) (10 * d), dp8 = (int) (8 * d), dp4 = (int) (4 * d);

        // ---- title bar (OEM: 24 sp title, hamburger) ----
        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (20 * d), (int) (4 * d), (int) (16 * d), (int) (4 * d));
        title = Theme.label(c, "", Theme.WHITE, 24, false);
        bar.addView(title, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        bar.addView(Theme.label(c, "☰", Theme.WHITE, 26, false));
        addView(bar);

        // ---- channel row: sub (60 dp) · two digit bitmaps (34×58 dp) · add (60 dp) ----
        FrameLayout chRow = new FrameLayout(c);
        LayoutParams chLp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); chLp.topMargin = (int) (5 * d);
        ImageView sub = new ImageView(c); sub.setImageResource(R.drawable.interphone_talkback_sub); sub.setClickable(true);
        ImageView add = new ImageView(c); add.setImageResource(R.drawable.interphone_talkback_add); add.setClickable(true);
        FrameLayout.LayoutParams subLp = new FrameLayout.LayoutParams((int) (60 * d), (int) (60 * d), Gravity.START | Gravity.CENTER_VERTICAL); subLp.leftMargin = (int) (26 * d);
        FrameLayout.LayoutParams addLp = new FrameLayout.LayoutParams((int) (60 * d), (int) (60 * d), Gravity.END | Gravity.CENTER_VERTICAL); addLp.rightMargin = (int) (26 * d);
        chRow.addView(sub, subLp); chRow.addView(add, addLp);
        LinearLayout digits = new LinearLayout(c); digits.setGravity(Gravity.CENTER);
        digitOne = new ImageView(c); digitTwo = new ImageView(c);
        LayoutParams dl = new LayoutParams((int) (34 * d), (int) (58 * d)); dl.rightMargin = (int) (6 * d);
        digits.addView(digitOne, dl); digits.addView(digitTwo, new LayoutParams((int) (34 * d), (int) (58 * d)));
        vfoLabel = Theme.label(c, "VFO", Theme.VFO[3], 30, true); vfoLabel.setVisibility(GONE); vfoLabel.setShadowLayer(14 * d, 0, 0, Theme.VFO[2]);
        digits.addView(vfoLabel);
        chRow.addView(digits, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.CENTER));
        addView(chRow, chLp);
        sub.setOnClickListener(v -> { if (svc != null) new Thread(() -> svc.stepChannel(-1)).start(); });
        add.setOnClickListener(v -> { if (svc != null) new Thread(() -> svc.stepChannel(1)).start(); });

        // ---- info block: OEM 15 sp cyan labels left, location right ----
        LinearLayout info = new LinearLayout(c); info.setPadding(0, (int) (6 * d), 0, (int) (4 * d));
        LinearLayout leftCol = new LinearLayout(c); leftCol.setOrientation(VERTICAL);
        // module: OEM's 15 dp labels are restyled to 11 sp with no padding (MainHook 1762-1774)
        power = Theme.label(c, "Power:", Theme.CYAN, 11, false); squelch = Theme.label(c, "Squelch Level:", Theme.CYAN, 11, false);
        send = Theme.label(c, "Send:", Theme.CYAN, 11, false); receive = Theme.label(c, "Receive:", Theme.CYAN, 11, false);
        for (TextView t : new TextView[] { power, squelch, send, receive }) { t.setPadding(0, (int) (1 * d), 0, (int) (1 * d)); leftCol.addView(t); }
        info.addView(leftCol, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        location = Theme.label(c, "", Theme.WHITE, 12, false); location.setGravity(Gravity.END);
        LayoutParams locLp = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); locLp.rightMargin = dp10;
        info.addView(location, locLp);
        addView(info);

        // ---- Signal (0.4) · SCAN (0.3) · ZONE (0.3) ----
        LinearLayout sr = new LinearLayout(c); sr.setGravity(Gravity.CENTER_VERTICAL);
        LayoutParams srLp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); srLp.leftMargin = srLp.rightMargin = dp10; srLp.topMargin = dp4;
        signal = Theme.label(c, "Signal: --", Theme.YELLOW, 16, true); signal.setGravity(Gravity.CENTER);
        signal.setSingleLine(true); signal.setMaxLines(1);   // "Signal: -104 dBm" must never wrap and push the page down
        androidx.core.widget.TextViewCompat.setAutoSizeTextTypeUniformWithConfiguration(signal, 10, 16, 1, android.util.TypedValue.COMPLEX_UNIT_SP);
        signal.setBackground(Theme.rounded(c, 0x15FFFF00, 0xAAFFFF00, 2, 8)); signal.setPadding(dp4, (int) (12 * d), dp4, (int) (12 * d));
        LayoutParams sl = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 0.4f); sl.rightMargin = dp4;
        sr.addView(signal, sl);
        TextView scan = pill(c, "🔍 SCAN"), zone = pill(c, "ZONE: ALL"); scanBtn = scan; zoneBtn = zone;
        LayoutParams bl = new LayoutParams(0, LayoutParams.MATCH_PARENT, 0.3f); bl.leftMargin = dp4;
        sr.addView(scan, bl); sr.addView(zone, new LayoutParams(bl));
        addView(sr, srLp);
        scan.setOnClickListener(v -> { if (svc != null) android.widget.Toast.makeText(c, svc.toggleScan(), android.widget.Toast.LENGTH_SHORT).show(); });
        scan.setOnLongClickListener(v -> { if (svc != null) android.widget.Toast.makeText(c, svc.skipScanChannel(), android.widget.Toast.LENGTH_SHORT).show(); return true; });
        zone.setOnClickListener(v -> pickZone());

        // ---- SQ slider row (module: SQ: 14 sp grey bold, value 18 sp cyan, cyan seek bar) ----
        LinearLayout sq = new LinearLayout(c); sq.setGravity(Gravity.CENTER_VERTICAL);
        LayoutParams sqLp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); sqLp.leftMargin = (int) (16 * d); sqLp.topMargin = dp4; sqLp.bottomMargin = (int) (-6 * d);
        TextView sqLabel = Theme.label(c, "SQ:", Theme.GREY, 14, true); LayoutParams ll = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); ll.rightMargin = (int) (2 * d);
        sq.addView(sqLabel, ll);
        sqValue = Theme.label(c, "3", Theme.CYAN, 18, true); sq.addView(sqValue);
        SeekBar seek = new SeekBar(c); seek.setMax(9); seek.setProgress(5); sqSeek = seek;
        android.content.res.ColorStateList cyan = android.content.res.ColorStateList.valueOf(Theme.CYAN);
        seek.setProgressTintList(cyan); seek.setProgressBackgroundTintList(cyan); seek.setThumbTintList(cyan);
        seek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override public void onProgressChanged(SeekBar s, int p, boolean u) { sqValue.setText(String.valueOf(Math.max(1, p))); }
            @Override public void onStartTrackingTouch(SeekBar s) { sqFromUser = true; }
            @Override public void onStopTrackingTouch(SeekBar s) { sqFromUser = false; if (svc != null) svc.setSoftSqLevel(Math.max(1, s.getProgress())); }
        });
        LayoutParams skl = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 0.42f); skl.leftMargin = dp10; skl.rightMargin = dp10; skl.topMargin = dp4;
        sq.addView(seek, skl);
        sq.addView(new TextView(c), new LayoutParams(0, 1, 0.58f));
        addView(sq, sqLp);

        // ---- circuit-board panel (250 dp, 10 dp side margins, 8 dp top, 2 dp 35 % cyan border, radius 12) ----
        FrameLayout panel = new FrameLayout(c);
        GradientDrawable pbg = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM, new int[] { 0x0800E5FF, 0x0400E5FF });
        pbg.setCornerRadius(12 * d); pbg.setStroke((int) (2 * d), 0x5900E5FF);
        panel.setBackground(pbg);
        board = new CircuitBoardView(c);
        panel.addView(board, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        LinearLayout infoPanel = new LinearLayout(c); infoPanel.setOrientation(VERTICAL);
        infoPanel.setBackground(Theme.rounded(c, 0x18000000, 0x5500BFFF, 1, 8));
        int ip = (int) (5 * d); infoPanel.setPadding(ip, ip, ip, ip);
        headline = Theme.label(c, "📻 Ready", Theme.GREEN, 16, true); headline.setMaxLines(1);
        LayoutParams hl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); hl.bottomMargin = (int) (2 * d);
        infoPanel.addView(headline, hl);
        historyHeader = Theme.label(c, "Analog History", Theme.CYAN2, 13, true);
        LayoutParams hh = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); hh.bottomMargin = dp4;
        infoPanel.addView(historyHeader, hh);
        historyText = Theme.label(c, "", Theme.CYAN2, 11, false); infoPanel.addView(historyText);
        infoPanel.setClickable(true); infoPanel.setOnClickListener(v -> {
            if (svc == null) return;
            final String tone = svc.pendingToneLabel();
            if (tone != null && svc.current() != null) {
                new android.app.AlertDialog.Builder(c).setTitle("CTCSS " + tone + " Hz heard")
                        .setMessage("Use it as the receive and transmit tone on " + svc.current().name + "? With the tone set, Soft SQ opens only for this tone and other stations will hear you if they need it.")
                        .setPositiveButton("Use it", (d2, w) -> android.widget.Toast.makeText(c, svc.applyPendingTone(), android.widget.Toast.LENGTH_LONG).show())
                        .setNeutralButton("Last heard", (d2, w) -> LastHeardDialog.show(c, svc))
                        .setNegativeButton("Not now", (d2, w) -> svc.dismissPendingTone()).show();
            } else LastHeardDialog.show(c, svc);
        });
        FrameLayout.LayoutParams ipl = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.TOP | Gravity.START);
        ipl.topMargin = ipl.leftMargin = ipl.rightMargin = dp8;
        panel.addView(infoPanel, ipl);
        transcriptionBox = new LinearLayout(c); transcriptionBox.setOrientation(VERTICAL);
        transcriptionBox.setBackground(Theme.rounded(c, 0xF0071626, 0xAA00BFFF, 2, 8)); transcriptionBox.setPadding(dp8, dp8, dp8, dp8);
        TextView th = Theme.label(c, "📝 Transcription", Theme.CYAN2, 10, true);
        LayoutParams thl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); thl.bottomMargin = dp4;
        transcriptionBox.addView(th, thl);
        // capped like the module (inner scroll, newest at the bottom) so the box never grows over the history
        final int capPx = (int) (96 * d);
        captionScroll = new android.widget.ScrollView(c) {
            @Override protected void onMeasure(int w, int h) { super.onMeasure(w, android.view.View.MeasureSpec.makeMeasureSpec(capPx, android.view.View.MeasureSpec.AT_MOST)); }
        };
        captionScroll.setVerticalScrollBarEnabled(false);
        LinearLayout capCol = new LinearLayout(c); capCol.setOrientation(VERTICAL);
        transcriptionText = Theme.label(c, "", Theme.WHITE, 13, false); capCol.addView(transcriptionText);
        captionLive = Theme.label(c, "", Theme.CYAN, 13, false); captionLive.setTypeface(null, android.graphics.Typeface.ITALIC); capCol.addView(captionLive);
        captionScroll.addView(capCol); transcriptionBox.addView(captionScroll);
        FrameLayout.LayoutParams tbl = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.BOTTOM);
        tbl.leftMargin = tbl.rightMargin = dp8; tbl.bottomMargin = (int) (22 * d);
        panel.addView(transcriptionBox, tbl); transcriptionBox.setVisibility(GONE);
        LayoutParams pl = new LayoutParams(LayoutParams.MATCH_PARENT, (int) (250 * d)); pl.leftMargin = pl.rightMargin = dp10; pl.topMargin = dp8;
        addView(panel, pl);

        // ---- PTT (176 dp, centred) with the six satellites at the module's exact offsets ----
        FrameLayout bottom = new FrameLayout(c);
        ptt = new PttButton(c);
        bottom.addView(ptt, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.CENTER));
        softSq = new NeonToggle(c, "🎚️", "SOFT SQ", Theme.SOFTSQ); txt = new NeonToggle(c, "✍️", "TXT", Theme.TXT); vfo = new NeonToggle(c, "🎛️", "VFO", Theme.VFO);
        rec = new NeonToggle(c, "🔴", "REC", Theme.REC); mon = new NeonToggle(c, "👁️", "MON", Theme.MON); pkt = new NeonToggle(c, "📡", "PKT", Theme.PKT);
        bottom.addView(softSq, sat(d, 80, Gravity.START, 8, 4));
        bottom.addView(txt, sat(d, 70, Gravity.START, 8, 58));
        bottom.addView(vfo, sat(d, 70, Gravity.START, 8, 112));
        bottom.addView(rec, sat(d, 70, Gravity.END, 16, 4));
        bottom.addView(mon, sat(d, 70, Gravity.END, 16, 58));
        bottom.addView(pkt, sat(d, 76, Gravity.END, 16, 112));
        LayoutParams btl = new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f); btl.topMargin = dp4;
        addView(bottom, btl);
        // Mode satellites. Those not brought over yet say so instead of pretending to toggle.
        softSq.setOnClickListener(v -> { if (svc != null) svc.setSoftSq(!softSq.isOn()); });
        rec.setOnClickListener(v -> { if (svc != null) svc.setRecord(!rec.isOn()); });
        mon.setOnClickListener(v -> { if (svc != null) svc.setMonitor(!mon.isOn()); });
        txt.setOnClickListener(v -> {
            if (svc == null) return;
            if (!svc.captionsAvailable()) { android.widget.Toast.makeText(c, "google".equals(svc.captionEngine()) ? "Long-press TXT and enter a Google Cloud API key, or switch to the on-device engine" : "Captions are not available right now", android.widget.Toast.LENGTH_LONG).show(); return; }
            svc.setCaptions(!txt.isOn());
        });
        txt.setOnLongClickListener(v -> {
            final boolean google = "google".equals(svc.captionEngine());
            new android.app.AlertDialog.Builder(c).setTitle("Live captions").setItems(new String[] { "Engine: " + (google ? "Google Cloud (switch to on-device Vosk)" : "on-device Vosk (switch to Google Cloud)"), "Recognition model (Vosk)\u2026", "Google Cloud API key\u2026", "Keyword alerts\u2026" }, (d2, w) -> {
                if (w == 0) { svc.setCaptionEngine(google ? "vosk" : "google"); android.widget.Toast.makeText(c, "Captions now use " + (google ? "the on-device Vosk recognizer" : "Google Cloud Speech"), android.widget.Toast.LENGTH_SHORT).show(); }
                else if (w == 1) pickCaptionModel();
                else if (w == 2) editGoogleKey();
                else editKeywords();
            }).show();
            return true;
        });
        vfo.setOnClickListener(v -> { if (svc != null) VfoDialog.show(c, svc); });
        vfo.setOnLongClickListener(v -> { if (svc != null && svc.vfoActive()) { svc.exitVfo(); android.widget.Toast.makeText(c, "VFO off", android.widget.Toast.LENGTH_SHORT).show(); } return true; });
        pkt.setOnClickListener(v -> { if (svc != null) PktDialog.show(c, svc); });
        ptt.setListener(down -> { if (svc != null) svc.ptt(down); });
    }

    private static FrameLayout.LayoutParams sat(float d, int wDp, int side, int sideMarginDp, int topDp) {
        FrameLayout.LayoutParams p = new FrameLayout.LayoutParams((int) (wDp * d), (int) (48 * d), side | Gravity.TOP);
        if (side == Gravity.START) p.leftMargin = (int) (sideMarginDp * d); else p.rightMargin = (int) (sideMarginDp * d);
        p.topMargin = (int) (topDp * d);
        return p;
    }

    private static TextView pill(Context c, String text) {
        TextView t = Theme.label(c, text, Theme.CYAN, 12, true); t.setGravity(Gravity.CENTER);
        t.setBackground(Theme.pill(c)); t.setClickable(true);
        int p = Theme.dp(c, 6); t.setPadding(p, p, p, p);
        return t;
    }

    public void attach(RadioService s) { svc = s; s.addListener(this); }

    private void editGoogleKey() {
        if (svc == null) return;
        final android.widget.EditText et = new android.widget.EditText(getContext()); et.setHint("Google Cloud Speech-to-Text API key"); et.setText(svc.googleKey());
        et.setInputType(android.text.InputType.TYPE_CLASS_TEXT | android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD);
        new android.app.AlertDialog.Builder(getContext()).setTitle("Google Cloud API key").setMessage("Used only when the engine is Google Cloud. The key stays in this app's private settings and is never written to logs or backups.").setView(et)
                .setPositiveButton("Save", (d2, w) -> svc.setGoogleKey(et.getText().toString())).setNegativeButton("Cancel", null).show();
    }

    private void editKeywords() {
        if (svc == null) return;
        final android.widget.EditText et = new android.widget.EditText(getContext());
        et.setHint("e.g. emergency, mayday, your name, your town"); et.setText(svc.keywords()); et.setMinLines(3);
        et.setInputType(android.text.InputType.TYPE_CLASS_TEXT | android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE | android.text.InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        new android.app.AlertDialog.Builder(getContext()).setTitle("Keyword alerts").setMessage("Words or phrases, one per line or comma-separated. When live captions hear one, the phone vibrates, posts a notification and (with voice announcements on) says it.").setView(et)
                .setPositiveButton("Save", (d2, w) -> svc.setKeywords(et.getText().toString())).setNegativeButton("Cancel", null).show();
    }

    private void pickCaptionModel() {
        if (svc == null) return;
        int cur = 1; for (int i = 0; i < com.macdmr.radio.VoskCaptions.MODELS.length; i++) if (com.macdmr.radio.VoskCaptions.MODELS[i].equals(svc.captionModel())) cur = i;
        new android.app.AlertDialog.Builder(getContext()).setTitle("Live-caption model").setSingleChoiceItems(com.macdmr.radio.VoskCaptions.MODEL_LABELS, cur, null)
                .setPositiveButton("Use", (d, w) -> {
                    int i = ((android.app.AlertDialog) d).getListView().getCheckedItemPosition();
                    if (i >= 0) { svc.setCaptionModel(com.macdmr.radio.VoskCaptions.MODELS[i]); android.widget.Toast.makeText(getContext(), "Switching model; it downloads once and is kept across app updates", android.widget.Toast.LENGTH_LONG).show(); }
                }).setNegativeButton("Cancel", null).show();
    }

    private void pickZone() {
        if (svc == null) return;
        final java.util.List<ChannelStore.Zone> zones = svc.store().zones();
        String[] names = new String[zones.size() + 1]; names[0] = "ALL channels";
        for (int i = 0; i < zones.size(); i++) names[i + 1] = zones.get(i).name + "  (" + zones.get(i).numbers.length + ")";
        new android.app.AlertDialog.Builder(getContext()).setTitle("Zone").setItems(names, (d, w) -> svc.setZone(w == 0 ? 0 : zones.get(w - 1).id)).show();
    }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    private void refreshHeadline() {
        if (tx) { headline.setText("🔴 Transmitting"); headline.setTextColor(Theme.RED); }
        else if (rx) { headline.setText("📻 Receiving..."); headline.setTextColor(Theme.GREEN); }
        else if (svc != null && "no root".equals(svc.link())) { headline.setText("🔒 Root needed — allow in Magisk, then Device → Bring radio up"); headline.setTextColor(Theme.AMBER); }
        else { headline.setText(svc != null && svc.isReady() ? "📻 Ready" : "⏳ " + (svc != null ? svc.link() : "")); headline.setTextColor(Theme.GREEN); }
        ptt.setState(tx ? PttButton.State.TX : rx ? PttButton.State.RX : (svc != null && svc.isReady() && svc.txInhibited() ? PttButton.State.BUSY : PttButton.State.IDLE));
        board.isReceiving = rx;
    }

    // RadioService.Listener
    @Override public void onChannel(ChannelStore.Channel ch) {
        boolean isVfo = ch.id < 0;
        title.setText(ch.name + (ch.rxFreq < 300_000_000 ? "(VHF)" : "(UHF)"));
        int shown = ch.number % 100;
        digitOne.setImageResource(DIGITS[shown / 10]); digitTwo.setImageResource(DIGITS[shown % 10]);
        digitOne.setVisibility(isVfo ? GONE : VISIBLE); digitTwo.setVisibility(isVfo ? GONE : VISIBLE); vfoLabel.setVisibility(isVfo ? VISIBLE : GONE);
        vfo.setOn(isVfo);
        power.setText("Power:" + (ch.power == 1 ? "High power" : "Low power"));
        squelch.setText(ch.isDigital() ? "Color Code:" + ch.cc : "Squelch Level:" + ch.sq);
        send.setText("Send:" + ch.freqText(ch.txFreq)); receive.setText("Receive:" + ch.freqText(ch.rxFreq));
        historyHeader.setText(ch.isDigital() ? "DMR Activity" : "Analog History");
        softSq.setVisibility(ch.isDigital() ? INVISIBLE : VISIBLE);
        history.clear();
        if (svc != null) for (String l : svc.store().recentHistory(ch.number, 3)) history.addLast(l);
        renderHistory();
        refreshHeadline();
    }
    @Override public void onRx(boolean receiving) { rx = receiving; refreshHeadline(); }
    @Override public void onTx(boolean transmitting) { tx = transmitting; refreshHeadline(); }
    @Override public void onRssi(int dbm) { signal.setText(dbm == -999 ? "Signal: --" : "Signal: " + dbm + " dBm"); }
    @Override public void onAudioLevel(int amplitude) { board.audioAmplitude = amplitude; }
    @Override public void onHistory(String line) { if (!history.isEmpty() && history.peekLast().equals(line)) return; history.addLast(line); while (history.size() > 3) history.removeFirst(); renderHistory(); }
    @Override public void onCaller(String text) { headline.setText("📻 " + text); }
    @Override public void onLog(String s) { }
    @Override public void onLink(String state) { refreshHeadline(); }
    @Override public void onSms(int from, int type, String text) { }
    @Override public void onSmsResult(boolean ok) { }
    @Override public void onLocation(String text) { location.setText(text); }
    @Override public void onCaption(boolean enabled, String live, String sentence) {
        txt.setOn(enabled);
        transcriptionBox.setVisibility(enabled ? VISIBLE : GONE);
        board.barsCompact = enabled;
        if (sentence != null) { captionLines.addLast(new java.text.SimpleDateFormat("[HH:mm:ss] ", java.util.Locale.US).format(new java.util.Date()) + sentence); while (captionLines.size() > 4) captionLines.removeFirst(); }
        StringBuilder sb = new StringBuilder(); for (String l : captionLines) { if (sb.length() > 0) sb.append('\n'); sb.append(l); }
        transcriptionText.setText(sb.toString()); transcriptionText.setVisibility(sb.length() == 0 ? GONE : VISIBLE);
        captionLive.setText(live == null ? "" : live); captionLive.setVisibility(live == null || live.isEmpty() ? GONE : VISIBLE);
        captionScroll.post(() -> captionScroll.fullScroll(android.view.View.FOCUS_DOWN));
    }
    @Override public void onModes(boolean sq, int level, boolean open, boolean monitor, boolean recording, boolean scanning, boolean holding, String zoneName) {
        softSq.setOn(sq); mon.setOn(monitor); rec.setOn(recording); pkt.setOn(svc != null && svc.packetActive());
        if (!sqFromUser) { sqSeek.setProgress(level); sqValue.setText(String.valueOf(level)); }
        sqValue.setTextColor(sq ? (open ? Theme.GREEN : Theme.AMBER) : Theme.CYAN);
        zoneBtn.setText("ZONE: " + zoneName.toUpperCase(java.util.Locale.US));
        scanBtn.setText(scanning ? (holding ? "\u23F9 HOLD" : "\u23F9 SCANNING") : "\uD83D\uDD0D SCAN");
        scanBtn.setTextColor(scanning ? Theme.AMBER : Theme.CYAN);
        scanBtn.setBackground(scanning ? Theme.gradient(getContext(), 0xFF4A3A0D, 0xFF80651A, Theme.AMBER, 2, 8) : Theme.pill(getContext()));
    }

    private void renderHistory() {
        StringBuilder sb = new StringBuilder();
        for (String l : history) { if (sb.length() > 0) sb.append('\n'); sb.append(l); }
        historyText.setText(sb.toString());
    }
}
