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

    private TextView title, power, squelch, send, receive, location, signal, scanBtn, zoneBtn, sqValue;
    private final TextView headline, historyHeader, historyText, transcriptionText;
    private SeekBar sqSeek;
    private boolean sqFromUser;
    private ImageView digitOne, digitTwo;
    private TextView vfoLabel;
    // new look only
    private final boolean neo;
    private LinearLayout neoHeader, chipRow;
    private TextView bigNum, smeterText;
    private TextView[] readLabel;
    private SMeterView smeter;
    private String zoneName = "ALL";

    /** Which intercom page to build: the classic module page (default) or the new look. */
    public static boolean newLook(Context c) { return c.getSharedPreferences("radio", Context.MODE_PRIVATE).getBoolean("newIntercom", false); }
    public static void setNewLook(Context c, boolean on) { c.getSharedPreferences("radio", Context.MODE_PRIVATE).edit().putBoolean("newIntercom", on).apply(); }
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
        neo = newLook(c);
        if (neo) { setBackground(Neo.page(c)); buildNeoTop(c, d); } else {

        // ---- title bar (OEM: 24 sp title, hamburger) ----
        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (20 * d), (int) (4 * d), (int) (16 * d), (int) (4 * d));
        title = Theme.label(c, "", Theme.WHITE, 24, false);
        bar.addView(title, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        bar.addView(Theme.label(c, "☰", Theme.WHITE, 26, false));
        bar.setOnLongClickListener(v -> { offerLook(true); return true; });
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
        }

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
        if (neo) {
            headline.setTypeface(Neo.ui(c)); headline.setTextSize(17); headline.setLetterSpacing(0.04f);
            historyHeader.setVisibility(GONE);   // the headline already says what the panel shows
            historyText.setTypeface(Neo.uiSemi(c)); historyText.setTextColor(Neo.TEXT_SOFT); historyText.setTextSize(12.5f); historyText.setMaxLines(3); historyText.setEllipsize(android.text.TextUtils.TruncateAt.END);
            infoPanel.setBackground(Neo.card(c, Neo.alpha(Neo.CYAN, 0x30), 12)); infoPanel.setPadding(dp10, (int) (6 * d), dp10, (int) (6 * d));
        }
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
        LayoutParams pl = neo ? new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f) : new LayoutParams(LayoutParams.MATCH_PARENT, (int) (250 * d)); pl.leftMargin = pl.rightMargin = neo ? (int) (16 * d) : dp10; pl.topMargin = dp8;
        if (neo) { GradientDrawable nb = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM, new int[] { 0xE0081420, 0xE6060E18 }); nb.setCornerRadius(14 * d); nb.setStroke((int) d, Neo.LINE); panel.setBackground(nb); }
        addView(panel, pl);

        // ---- PTT (176 dp, centred) with the six satellites at the module's exact offsets ----
        FrameLayout bottom = new FrameLayout(c);
        ptt = new PttButton(c);
        bottom.addView(ptt, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.CENTER));
        if (neo) {
            softSq = new NeoToggle(c, "softsq", "SOFT SQ", Neo.CYAN); txt = new NeoToggle(c, "txt", "TXT", Neo.VIOLET); vfo = new NeoToggle(c, "vfo", "VFO", Neo.AMBER);
            rec = new NeoToggle(c, "rec", "REC", Neo.RED); mon = new NeoToggle(c, "mon", "MON", Neo.AMBER); pkt = new NeoToggle(c, "pkt", "PKT", Neo.GREEN);
            NeonToggle[] l = { softSq, txt, vfo }, r = { rec, mon, pkt };
            for (int i = 0; i < 3; i++) { bottom.addView(l[i], neoSat(d, Gravity.START, 4 + i * 59)); bottom.addView(r[i], neoSat(d, Gravity.END, 4 + i * 59)); }
        } else {
        softSq = new NeonToggle(c, "🎚️", "SOFT SQ", Theme.SOFTSQ); txt = new NeonToggle(c, "✍️", "TXT", Theme.TXT); vfo = new NeonToggle(c, "🎛️", "VFO", Theme.VFO);
        rec = new NeonToggle(c, "🔴", "REC", Theme.REC); mon = new NeonToggle(c, "👁️", "MON", Theme.MON); pkt = new NeonToggle(c, "📡", "PKT", Theme.PKT);
        bottom.addView(softSq, sat(d, 80, Gravity.START, 8, 4));
        bottom.addView(txt, sat(d, 70, Gravity.START, 8, 58));
        bottom.addView(vfo, sat(d, 70, Gravity.START, 8, 112));
        bottom.addView(rec, sat(d, 70, Gravity.END, 16, 4));
        bottom.addView(mon, sat(d, 70, Gravity.END, 16, 58));
        bottom.addView(pkt, sat(d, 76, Gravity.END, 16, 112));
        }
        LayoutParams btl = neo ? new LayoutParams(LayoutParams.MATCH_PARENT, (int) (182 * d)) : new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f); btl.topMargin = dp4;
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

    private static FrameLayout.LayoutParams neoSat(float d, int side, int topDp) {
        FrameLayout.LayoutParams p = new FrameLayout.LayoutParams((int) (76 * d), (int) (54 * d), side | Gravity.TOP);
        if (side == Gravity.START) p.leftMargin = (int) (12 * d); else p.rightMargin = (int) (12 * d);
        p.topMargin = (int) (topDp * d);
        return p;
    }

    /** Offer to switch looks (long-press the classic title, or the new look's menu). */
    private void offerLook(boolean toNew) {
        final Context c = getContext();
        new android.app.AlertDialog.Builder(c).setTitle(toNew ? "Try the new intercom look?" : "Back to the classic intercom?")
                .setMessage("Device → Radio settings → New intercom look switches it too.")
                .setPositiveButton(toNew ? "New look" : "Classic", (dd, w) -> { setNewLook(c, toNew); if (c instanceof com.macdmr.radio.MainActivity) ((com.macdmr.radio.MainActivity) c).rebuildIntercom(); })
                .setNegativeButton("Cancel", null).show();
    }

    private ImageView roundArrow(Context c, String icon, String desc) {
        ImageView v = new ImageView(c); v.setImageDrawable(new Neo.IconDrawable(icon, Neo.CYAN)); v.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        int p = Theme.dp(c, 13); v.setPadding(p, p, p, p);
        GradientDrawable g = new GradientDrawable(GradientDrawable.Orientation.TL_BR, new int[] { 0xFF12304A, 0xFF08121D }); g.setShape(GradientDrawable.OVAL); g.setStroke(Theme.dp(c, 1.5f), Neo.CYAN);
        v.setBackground(g); v.setElevation(Theme.dp(c, 6)); v.setOutlineAmbientShadowColor(Neo.CYAN); v.setOutlineSpotShadowColor(Neo.CYAN);
        v.setContentDescription(desc); v.setClickable(true); v.setFocusable(true);
        return v;
    }

    /** The new look's top half: header, channel strip, readout, S-meter, SCAN/ZONE, Soft SQ slider. */
    private void buildNeoTop(final Context c, final float d) {
        final int m = (int) (16 * d);
        neoHeader = Neo.header(c, "", "Zone · ALL");
        title = Neo.headerTitle(neoHeader);
        ImageView logo = new ImageView(c); logo.setImageDrawable(new Neo.IconDrawable("radio", Neo.CYAN));
        LayoutParams lg = new LayoutParams((int) (28 * d), (int) (28 * d)); lg.rightMargin = (int) (12 * d);
        neoHeader.addView(logo, 0, lg);
        ImageView menu = Neo.iconButton(c, "menu", Neo.CYAN, "Menu");
        menu.setOnClickListener(v -> new android.app.AlertDialog.Builder(c).setItems(new String[] { "Choose zone", "Last heard", "Classic intercom look" }, (dd, w) -> {
            if (w == 0) pickZone(); else if (w == 1) { if (svc != null) LastHeardDialog.show(c, svc); } else offerLook(false);
        }).show());
        Neo.addAction(neoHeader, menu);
        addView(neoHeader);

        // channel strip: arrows, big number, mode chips
        FrameLayout strip = new FrameLayout(c);
        ImageView prev = roundArrow(c, "left", "Previous channel"), next = roundArrow(c, "right", "Next channel");
        FrameLayout.LayoutParams pl = new FrameLayout.LayoutParams((int) (50 * d), (int) (50 * d), Gravity.START | Gravity.CENTER_VERTICAL); pl.leftMargin = (int) (18 * d);
        FrameLayout.LayoutParams nl = new FrameLayout.LayoutParams((int) (50 * d), (int) (50 * d), Gravity.END | Gravity.CENTER_VERTICAL); nl.rightMargin = (int) (18 * d);
        strip.addView(prev, pl); strip.addView(next, nl);
        LinearLayout mid = new LinearLayout(c); mid.setOrientation(VERTICAL); mid.setGravity(Gravity.CENTER_HORIZONTAL);
        bigNum = Neo.text(c, "--", Neo.CYAN, 50, Neo.display(c)); bigNum.setShadowLayer(18 * d, 0, 0, Neo.alpha(Neo.CYAN, 0xA0)); bigNum.setLetterSpacing(0.04f);
        mid.addView(bigNum);
        chipRow = new LinearLayout(c); chipRow.setGravity(Gravity.CENTER); chipRow.setPadding(0, (int) (4 * d), 0, 0);
        mid.addView(chipRow);
        strip.addView(mid, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.CENTER));
        LayoutParams sl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); sl.topMargin = (int) (6 * d);
        addView(strip, sl);
        prev.setOnClickListener(v -> { if (svc != null) new Thread(() -> svc.stepChannel(-1)).start(); });
        next.setOnClickListener(v -> { if (svc != null) new Thread(() -> svc.stepChannel(1)).start(); });

        // readout: four cells
        LinearLayout rcard = new LinearLayout(c); rcard.setOrientation(VERTICAL); rcard.setBackground(Neo.card(c, Neo.LINE, 14));
        rcard.setPadding((int) (14 * d), (int) (9 * d), (int) (12 * d), (int) (4 * d));
        LinearLayout ro = new LinearLayout(c); ro.setBaselineAligned(false);
        readLabel = new TextView[4]; TextView[] val = new TextView[4];
        float[] wts = { 1.15f, 1.15f, 0.85f, 1f };
        for (int i = 0; i < 4; i++) {
            LinearLayout cell = new LinearLayout(c); cell.setOrientation(VERTICAL);
            readLabel[i] = Neo.caps(c, ""); cell.addView(readLabel[i]);
            val[i] = Neo.text(c, "", Neo.TEXT, 15.5f, Neo.mono(c)); val[i].setSingleLine(true); val[i].setPadding(0, (int) (4 * d), 0, 0);
            androidx.core.widget.TextViewCompat.setAutoSizeTextTypeUniformWithConfiguration(val[i], 10, 16, 1, android.util.TypedValue.COMPLEX_UNIT_SP);
            cell.addView(val[i], new LayoutParams(LayoutParams.MATCH_PARENT, (int) (22 * d)));
            ro.addView(cell, new LayoutParams(0, LayoutParams.WRAP_CONTENT, wts[i]));
        }
        send = val[0]; receive = val[1]; squelch = val[2]; power = val[3];
        rcard.addView(ro);
        android.view.View rdiv = new android.view.View(c); rdiv.setBackgroundColor(Neo.DIVIDER); LayoutParams rdl = new LayoutParams(LayoutParams.MATCH_PARENT, 1); rdl.setMargins(0, (int) (8 * d), 0, (int) (6 * d));
        rcard.addView(rdiv, rdl);
        LayoutParams rl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); rl.setMargins(m, (int) (8 * d), m, 0);
        addView(rcard, rl);
        location = Neo.text(c, "", Neo.MUTED, 12.5f, Neo.uiSemi(c)); location.setSingleLine(true); location.setEllipsize(android.text.TextUtils.TruncateAt.END);
                location.setVisibility(GONE);

        // S-meter
        LinearLayout sm = rcard;
        LinearLayout smTop = new LinearLayout(c); smTop.setGravity(Gravity.CENTER_VERTICAL);
        smTop.addView(Neo.caps(c, "Signal"), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        smeterText = Neo.text(c, "--", Neo.TEXT, 17, Neo.mono(c)); smTop.addView(smeterText);
        sm.addView(smTop);
        smeter = new SMeterView(c); LayoutParams mlp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); mlp.topMargin = (int) (4 * d);
        sm.addView(smeter, mlp);
        signal = smeterText;
        // where the channel is (stored position): shown under the card only when there is one
        LayoutParams ll2 = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); ll2.setMargins(m + (int) (4 * d), (int) (4 * d), m, 0);
        addView(location, ll2);

        // SCAN / ZONE
        LinearLayout br = new LinearLayout(c); br.setBaselineAligned(false);
        scanBtn = Neo.button(c, "SCAN", "scan", Neo.CYAN); zoneBtn = Neo.button(c, "ZONE: ALL", "zone", Neo.CYAN);
        for (TextView t : new TextView[] { scanBtn, zoneBtn }) { t.setLetterSpacing(0.12f); t.setTextSize(15.5f); t.setMinHeight((int) (44 * d)); t.setSingleLine(true); }
        LayoutParams b1 = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); b1.rightMargin = (int) (4 * d);
        LayoutParams b2 = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); b2.leftMargin = (int) (4 * d);
        br.addView(scanBtn, b1); br.addView(zoneBtn, b2);
        LayoutParams brl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); brl.setMargins(m, (int) (6 * d), m, 0);
        addView(br, brl);
        scanBtn.setOnClickListener(v -> { if (svc != null) android.widget.Toast.makeText(c, svc.toggleScan(), android.widget.Toast.LENGTH_SHORT).show(); });
        scanBtn.setOnLongClickListener(v -> { if (svc != null) android.widget.Toast.makeText(c, svc.skipScanChannel(), android.widget.Toast.LENGTH_SHORT).show(); return true; });
        zoneBtn.setOnClickListener(v -> pickZone());

        // Soft SQ slider
        LinearLayout sq = new LinearLayout(c); sq.setGravity(Gravity.CENTER_VERTICAL);
        TextView sqLabel = Neo.caps(c, "Soft SQ"); sqLabel.setTextSize(12);
        sq.addView(sqLabel, new LayoutParams((int) (70 * d), LayoutParams.WRAP_CONTENT));
        SeekBar seek = new SeekBar(c); seek.setMax(9); seek.setProgress(5); sqSeek = seek;
        seek.setProgressTintList(android.content.res.ColorStateList.valueOf(Neo.CYAN)); seek.setProgressBackgroundTintList(android.content.res.ColorStateList.valueOf(Neo.TRACK)); seek.setThumbTintList(android.content.res.ColorStateList.valueOf(Neo.CYAN));
        seek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override public void onProgressChanged(SeekBar s2, int p, boolean u) { sqValue.setText(String.valueOf(Math.max(1, p))); }
            @Override public void onStartTrackingTouch(SeekBar s2) { sqFromUser = true; }
            @Override public void onStopTrackingTouch(SeekBar s2) { sqFromUser = false; if (svc != null) svc.setSoftSqLevel(Math.max(1, s2.getProgress())); }
        });
        sq.addView(seek, new LayoutParams(0, (int) (32 * d), 1f));
        sqValue = Neo.text(c, "5", Neo.CYAN, 20, Neo.mono(c)); sqValue.setGravity(Gravity.END);
        sq.addView(sqValue, new LayoutParams((int) (24 * d), LayoutParams.WRAP_CONTENT));
        LayoutParams sql = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); sql.setMargins(m + (int) (2 * d), (int) (2 * d), m, 0);
        addView(sq, sql);
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
        if (neo) { refreshNeoHeadline(); return; }
        if (tx) { headline.setText("🔴 Transmitting"); headline.setTextColor(Theme.RED); }
        else if (rx) { headline.setText("📻 Receiving..."); headline.setTextColor(Theme.GREEN); }
        else if (svc != null && "no root".equals(svc.link())) { headline.setText("🔒 Root needed — allow in Magisk, then Device → Bring radio up"); headline.setTextColor(Theme.AMBER); }
        else if (svc != null && "unsupported".equals(svc.link())) { headline.setText("📱 This phone is not supported yet — Device → Device report"); headline.setTextColor(Theme.AMBER); }
        else { headline.setText(svc != null && svc.isReady() ? "📻 Ready" : "⏳ " + (svc != null ? svc.link() : "")); headline.setTextColor(Theme.GREEN); }
        ptt.setState(tx ? PttButton.State.TX : rx ? PttButton.State.RX : (svc != null && svc.isReady() && svc.txInhibited() ? PttButton.State.BUSY : PttButton.State.IDLE));
        board.isReceiving = rx;
    }

    private void refreshNeoHeadline() {
        String t; int col;
        if (tx) { t = "TRANSMITTING"; col = Neo.RED; }
        else if (rx) { t = "RECEIVING"; col = Neo.GREEN; }
        else if (svc != null && "no root".equals(svc.link())) { t = "ROOT NEEDED · allow in Magisk, then Device → Take over"; col = Neo.AMBER; }
        else if (svc != null && "unsupported".equals(svc.link())) { t = "PHONE NOT SUPPORTED YET · Device → Device report"; col = Neo.AMBER; }
        else if (svc != null && svc.isReady()) { t = "READY"; col = Neo.GREEN; }
        else { t = svc != null ? svc.link().toUpperCase(java.util.Locale.US) : ""; col = Neo.AMBER; }
        headline.setText("●  " + t); headline.setTextColor(col);
        headline.setShadowLayer(Theme.dp(getContext(), 6), 0, 0, Neo.alpha(col, 0x90));
        ptt.setState(tx ? PttButton.State.TX : rx ? PttButton.State.RX : (svc != null && svc.isReady() && svc.txInhibited() ? PttButton.State.BUSY : PttButton.State.IDLE));
        board.isReceiving = rx;
    }

    /** New look: number, chips and the four readout cells for the channel. */
    private void neoChannel(ChannelStore.Channel ch, boolean isVfo) {
        Context c = getContext(); float d = Theme.dp(c);
        title.setText((isVfo ? "VFO" : ch.name).toUpperCase(java.util.Locale.US));
        bigNum.setText(isVfo ? "VFO" : String.format(java.util.Locale.US, "%02d", ch.number % 100));
        int numCol = isVfo ? Neo.AMBER : Neo.CYAN; bigNum.setTextColor(numCol); bigNum.setShadowLayer(18 * d, 0, 0, Neo.alpha(numCol, 0xA0));
        chipRow.removeAllViews();
        TextView[] chips = { Neo.chip(c, ch.isDigital() ? "DMR" : "FM", ch.isDigital() ? Neo.VIOLET : Neo.CYAN), Neo.chip(c, ch.rxFreq < 300_000_000 ? "VHF" : "UHF", Neo.CYAN), Neo.chip(c, ch.power == 1 ? "HIGH PWR" : "LOW PWR", Neo.AMBER) };
        for (int i = 0; i < chips.length; i++) { LayoutParams lp = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); if (i > 0) lp.leftMargin = (int) (6 * d); chipRow.addView(chips[i], lp); }
        readLabel[0].setText("TX"); readLabel[1].setText("RX");
        send.setText(ChannelsView.mhz(ch.txFreq)); receive.setText(ChannelsView.mhz(ch.rxFreq));
        if (ch.isDigital()) {
            readLabel[2].setText("CC · TS"); squelch.setText(ch.cc + " · " + (ch.inSlot + 1));
            readLabel[3].setText("CALL"); power.setText((ch.contactType == 1 ? "TG " : ch.contactType == 2 ? "ALL " : "ID ") + ch.txContact);
        } else {
            readLabel[2].setText("SQ"); squelch.setText(String.valueOf(ch.sq));
            readLabel[3].setText("TONE");
            String tone = ch.rxType == 1 && com.macdmr.radio.dsp.ToneTable.ctcssHz(ch.rxSubCode) > 0 ? String.format(java.util.Locale.US, "%.1f", com.macdmr.radio.dsp.ToneTable.ctcssHz(ch.rxSubCode)) : ch.rxType == 2 ? String.format(java.util.Locale.US, "D%03oN", ch.rxSubCode) : "NONE";
            power.setText(tone);
        }
    }

    // RadioService.Listener
    @Override public void onChannel(ChannelStore.Channel ch) {
        boolean isVfo = ch.id < 0;
        if (neo) {
            neoChannel(ch, isVfo); vfo.setOn(isVfo);
            historyHeader.setText(ch.isDigital() ? "DMR ACTIVITY" : "ANALOG HISTORY");
            softSq.setVisibility(ch.isDigital() ? INVISIBLE : VISIBLE);
            history.clear();
            if (svc != null) for (String l : svc.store().recentHistory(ch.number, 3)) history.addLast(l);
            renderHistory(); refreshHeadline();
            return;
        }
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
    @Override public void onRssi(int dbm) {
        if (neo) { smeter.setDbm(dbm); smeterText.setText(dbm == -999 ? "--" : SMeterView.sUnits(dbm) + "  " + dbm + " dBm"); smeterText.setTextColor(dbm == -999 ? Neo.DIM : dbm > -93 ? Neo.AMBER_LIGHT : Neo.TEXT); return; }
        signal.setText(dbm == -999 ? "Signal: --" : "Signal: " + dbm + " dBm");
    }
    @Override public void onAudioLevel(int amplitude) { board.audioAmplitude = amplitude; }
    @Override public void onHistory(String line) { if (!history.isEmpty() && history.peekLast().equals(line)) return; history.addLast(line); while (history.size() > 3) history.removeFirst(); renderHistory(); }
    @Override public void onCaller(String text) { headline.setText(neo ? "●  " + text : "📻 " + text); }
    @Override public void onLog(String s) { }
    @Override public void onLink(String state) { refreshHeadline(); }
    @Override public void onSms(int from, int type, String text) { }
    @Override public void onSmsResult(boolean ok) { }
    @Override public void onLocation(String text) { location.setText(text); if (neo) location.setVisibility(text == null || text.isEmpty() ? GONE : VISIBLE); }
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
        if (neo) {
            this.zoneName = zoneName; Neo.headerSubtitle(neoHeader).setText(("Zone · " + zoneName).toUpperCase(java.util.Locale.US));
            sqValue.setTextColor(sq ? (open ? Neo.GREEN : Neo.AMBER) : Neo.CYAN);
            Context c = getContext(); int col = scanning ? Neo.AMBER : Neo.CYAN;
            scanBtn.setText(scanning ? (holding ? "HOLD" : "SCANNING") : "SCAN"); scanBtn.setTextColor(scanning ? Neo.AMBER_LIGHT : Neo.CYAN_LIGHT);
            Neo.IconDrawable ic = new Neo.IconDrawable(scanning ? "stop" : "scan", scanBtn.getCurrentTextColor()); int sz = Theme.dp(c, 18); ic.setBounds(0, 0, sz, sz); scanBtn.setCompoundDrawables(ic, null, null, null);
            android.graphics.drawable.StateListDrawable st = new android.graphics.drawable.StateListDrawable();
            st.addState(new int[] { android.R.attr.state_pressed }, Neo.outline(c, col, 0x40, 12, 1.5f)); st.addState(new int[] { }, Neo.outline(c, col, scanning ? 0x30 : 0x18, 12, 1.5f));
            scanBtn.setBackground(st);
            return;
        }
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
