package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PixelFormat;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.HashMap;
import java.util.Map;

/**
 * The second-generation look (see the design canvas): one colour per meaning, bundled fonts (Orbitron for
 * titles and the channel number, Share Tech Mono for every number, Rajdhani for text) and a line-icon set
 * drawn from 24-unit path data, so nothing on screen depends on the phone's emoji font.
 */
public final class Neo {
    private Neo() { }

    // ---- colour roles ----
    public static final int GROUND = 0xFF060B12, GROUND_TOP = 0xFF0D1B2B, BAR = 0xFF050A10, PANEL = 0xE6081018, PANEL_SOLID = 0xFF0B1622;
    public static final int LINE = 0x3819D3FF, LINE_SOFT = 0x2919D3FF, DIVIDER = 0xFF12212F, TRACK = 0xFF14263A;
    public static final int CYAN = 0xFF19D3FF, CYAN_LIGHT = 0xFF8FE9FF, GREEN = 0xFF2BEA7A, GREEN_LIGHT = 0xFF7CF5AE, AMBER = 0xFFFFB020, AMBER_LIGHT = 0xFFFFCB6B;
    public static final int VIOLET = 0xFFB08CFF, VIOLET_LIGHT = 0xFFC9B3FF, RED = 0xFFFF5468;
    public static final int TEXT = 0xFFE2EDF7, TEXT_SOFT = 0xFFCFE0EE, MUTED = 0xFF8DA2B8, DIM = 0xFF6F849A, OFF = 0xFF3E5468;

    /** Same colour with a new alpha (0..255). */
    public static int alpha(int color, int a) { return (color & 0x00FFFFFF) | (a << 24); }

    // ---- fonts (bundled, SIL Open Font License; licences in assets/fonts) ----
    private static Typeface display, mono, ui, uiSemi, uiMedium;
    public static synchronized Typeface display(Context c) {
        if (display == null) display = load(c, "fonts/orbitron.ttf", "'wght' 850", Typeface.DEFAULT_BOLD);
        return display;
    }
    public static synchronized Typeface mono(Context c) { if (mono == null) mono = load(c, "fonts/share_tech_mono.ttf", null, Typeface.MONOSPACE); return mono; }
    /** Rajdhani bold: labels, names, buttons. */
    public static synchronized Typeface ui(Context c) { if (ui == null) ui = load(c, "fonts/rajdhani_bold.ttf", null, Typeface.DEFAULT_BOLD); return ui; }
    public static synchronized Typeface uiSemi(Context c) { if (uiSemi == null) uiSemi = load(c, "fonts/rajdhani_semibold.ttf", null, Typeface.DEFAULT); return uiSemi; }
    public static synchronized Typeface uiMedium(Context c) { if (uiMedium == null) uiMedium = load(c, "fonts/rajdhani_medium.ttf", null, Typeface.DEFAULT); return uiMedium; }
    private static Typeface load(Context c, String asset, String variation, Typeface fallback) {
        try {
            Typeface.Builder b = new Typeface.Builder(c.getAssets(), asset);
            if (variation != null) b.setFontVariationSettings(variation);
            Typeface t = b.build();
            return t != null ? t : fallback;
        } catch (Throwable t) { return fallback; }
    }

    // ---- text helpers ----
    public static TextView text(Context c, String s, int color, float sp, Typeface tf) {
        TextView t = new TextView(c); t.setText(s); t.setTextColor(color); t.setTextSize(sp); t.setTypeface(tf); t.setIncludeFontPadding(false);
        return t;
    }
    /** Small tracked caps label ("SIGNAL", "RADIO SETTINGS"). */
    public static TextView caps(Context c, String s) {
        TextView t = text(c, s.toUpperCase(java.util.Locale.US), MUTED, 11.5f, ui(c)); t.setLetterSpacing(0.18f);
        return t;
    }
    public static TextView title(Context c, String s) {
        TextView t = text(c, s.toUpperCase(java.util.Locale.US), TEXT, 15, display(c)); t.setLetterSpacing(0.08f); t.setSingleLine(true); t.setEllipsize(android.text.TextUtils.TruncateAt.END);
        return t;
    }

    // ---- backgrounds ----
    public static Drawable page(Context c) {
        GradientDrawable g = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM, new int[] { GROUND_TOP, GROUND, GROUND });
        return g;
    }
    public static GradientDrawable card(Context c, int border, float radiusDp) {
        GradientDrawable g = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM, new int[] { 0xD90E1C2C, 0xE6081018 });
        g.setCornerRadius(Theme.dp(c, radiusDp)); g.setStroke(Theme.dp(c, 1), border);
        return g;
    }
    /** Opaque card for pop-ups (menus, info cards): nothing behind may show through the text. */
    public static GradientDrawable sheet(Context c, int border, float radiusDp) {
        GradientDrawable g = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM, new int[] { 0xFF102033, 0xFF0A1622 });
        g.setCornerRadius(Theme.dp(c, radiusDp)); g.setStroke(Theme.dp(c, 1), border);
        return g;
    }

    /** Tinted card: a wash of {@code accent} fading into the panel colour (Device tiles, link hero). */
    public static GradientDrawable tint(Context c, int accent, float radiusDp, float strokeDp) {
        GradientDrawable g = new GradientDrawable(GradientDrawable.Orientation.TL_BR, new int[] { alpha(accent, 0x2E), 0xEB08121A, 0xEB08121A });
        g.setCornerRadius(Theme.dp(c, radiusDp)); g.setStroke(Theme.dp(c, strokeDp), alpha(accent, 0x8C));
        return g;
    }
    public static GradientDrawable outline(Context c, int accent, int fillAlpha, float radiusDp, float strokeDp) {
        GradientDrawable g = new GradientDrawable(); g.setColor(alpha(accent, fillAlpha)); g.setCornerRadius(Theme.dp(c, radiusDp));
        g.setStroke(Theme.dp(c, strokeDp), accent);
        return g;
    }

    /** Badge chip ("DMR", "UHF", "CC15 · TS1"). */
    public static TextView chip(Context c, String s, int color) {
        TextView t = text(c, s.toUpperCase(java.util.Locale.US), color, 11, ui(c)); t.setLetterSpacing(0.12f); t.setSingleLine(true);
        GradientDrawable g = new GradientDrawable(); g.setColor(alpha(color, 0x22)); g.setCornerRadius(Theme.dp(c, 5)); g.setStroke(Theme.dp(c, 1), alpha(color, 0x77));
        t.setBackground(g); t.setPadding(Theme.dp(c, 6), Theme.dp(c, 2), Theme.dp(c, 6), Theme.dp(c, 2));
        return t;
    }

    /** Accent button: outlined, tinted, optional leading icon. */
    public static TextView button(Context c, String label, String icon, int accent) {
        TextView t = text(c, label, accent == CYAN ? CYAN_LIGHT : accent == GREEN ? GREEN_LIGHT : accent == AMBER ? AMBER_LIGHT : accent == VIOLET ? VIOLET_LIGHT : accent, 15, ui(c));
        t.setGravity(Gravity.CENTER); t.setLetterSpacing(0.04f); t.setMinHeight(Theme.dp(c, 46));
        t.setPadding(Theme.dp(c, 12), Theme.dp(c, 8), Theme.dp(c, 12), Theme.dp(c, 8));
        android.graphics.drawable.StateListDrawable s = new android.graphics.drawable.StateListDrawable();
        s.addState(new int[] { android.R.attr.state_pressed }, outline(c, accent, 0x40, 12, 1.5f));
        s.addState(new int[] { }, outline(c, accent, 0x18, 12, 1.5f));
        t.setBackground(s);
        if (icon != null) { IconDrawable d = new IconDrawable(icon, t.getCurrentTextColor()); int sz = Theme.dp(c, 18); d.setBounds(0, 0, sz, sz); t.setCompoundDrawables(d, null, null, null); t.setCompoundDrawablePadding(Theme.dp(c, 8)); }
        t.setClickable(true); t.setFocusable(true);
        return t;
    }

    /** Square icon button (header actions). */
    public static ImageView iconButton(Context c, String icon, int accent, String description) {
        ImageView v = new ImageView(c); v.setImageDrawable(new IconDrawable(icon, accent)); v.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        int p = Theme.dp(c, 11); v.setPadding(p, p, p, p);
        GradientDrawable g = new GradientDrawable(); g.setColor(alpha(accent, 0x10)); g.setCornerRadius(Theme.dp(c, 12)); g.setStroke(Theme.dp(c, 1), alpha(accent, 0x55));
        v.setBackground(g); v.setContentDescription(description); v.setClickable(true); v.setFocusable(true);
        return v;
    }

    /** Rounded icon tile (setting rows, list leading icons). */
    public static ImageView iconTile(Context c, String icon, int accent, float sizeDp) {
        ImageView v = new ImageView(c); v.setImageDrawable(new IconDrawable(icon, accent)); v.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        int p = Math.round(Theme.dp(c, sizeDp) * 0.24f); v.setPadding(p, p, p, p);
        GradientDrawable g = new GradientDrawable(); g.setColor(alpha(accent, 0x16)); g.setCornerRadius(Theme.dp(c, sizeDp * 0.3f)); g.setStroke(Theme.dp(c, 1), alpha(accent, 0x55));
        v.setBackground(g);
        return v;
    }

    /** Page header: title over a tracked subtitle, actions on the right. Returns the bar; add actions to {@link #actions(LinearLayout)}. */
    public static LinearLayout header(Context c, String title, String subtitle) {
        LinearLayout bar = new LinearLayout(c); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding(Theme.dp(c, 16), 0, Theme.dp(c, 12), 0); bar.setMinimumHeight(Theme.dp(c, 60));
        GradientDrawable bg = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM, new int[] { 0xF20A1420, 0x99060B12 });
        bar.setBackground(new android.graphics.drawable.LayerDrawable(new Drawable[] { bg, bottomLine() }));
        LinearLayout col = new LinearLayout(c); col.setOrientation(LinearLayout.VERTICAL);
        TextView t = title(c, title); t.setTag("title"); col.addView(t);
        TextView s = caps(c, subtitle == null ? "" : subtitle); s.setTag("subtitle"); s.setPadding(0, Theme.dp(c, 5), 0, 0); s.setSingleLine(true); s.setEllipsize(android.text.TextUtils.TruncateAt.END);
        col.addView(s);
        bar.addView(col, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        LinearLayout actions = new LinearLayout(c); actions.setTag("actions"); actions.setGravity(Gravity.CENTER_VERTICAL);
        bar.addView(actions);
        return bar;
    }
    public static TextView headerTitle(LinearLayout bar) { return (TextView) bar.findViewWithTag("title"); }
    public static TextView headerSubtitle(LinearLayout bar) { return (TextView) bar.findViewWithTag("subtitle"); }
    public static void addAction(LinearLayout bar, View v) {
        LinearLayout actions = (LinearLayout) bar.findViewWithTag("actions"); Context c = bar.getContext();
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(Theme.dp(c, 44), Theme.dp(c, 44)); lp.leftMargin = Theme.dp(c, 8);
        actions.addView(v, lp);
    }
    private static Drawable bottomLine() {
        return new Drawable() {
            final Paint p = new Paint(); { p.setColor(alpha(CYAN, 0x29)); }
            @Override public void draw(Canvas cv) { android.graphics.Rect b = getBounds(); cv.drawRect(b.left, b.bottom - 2, b.right, b.bottom, p); }
            @Override public void setAlpha(int a) { } @Override public void setColorFilter(ColorFilter f) { } @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
        };
    }

    // ---- icons: 24-unit line paths (stroke 1.8, round caps), the set shown on the design canvas ----
    public static final Map<String, String> ICONS = new HashMap<>();
    static {
        ICONS.put("intercom", "M9 6a3 3 0 0 1 6 0v5a3 3 0 0 1-6 0zM5.5 11a6.5 6.5 0 0 0 13 0M12 17.5V21M8.5 21h7");
        ICONS.put("channels", "M9 6h11M9 12h11M9 18h11M4 6h1M4 12h1M4 18h1");
        ICONS.put("contacts", "M12 4a4 4 0 1 0 0.01 0M4 21c1.5-4 4.5-6 8-6s6.5 2 8 6");
        ICONS.put("messages", "M4 5h16v11H9l-5 4z");
        ICONS.put("device", "M4 8h16v13H4zM8 3l8 5M7 13h3M7 16h3M15 12a2.5 2.5 0 1 0 0.01 0");
        ICONS.put("scan", "M4 12a8 8 0 0 1 14-5.3M20 12a8 8 0 0 1-14 5.3M18 3v4h-4M6 21v-4h4");
        ICONS.put("stop", "M7 7h10v10H7z");
        ICONS.put("zone", "M12 3l9 5-9 5-9-5zM3 13l9 5 9-5");
        ICONS.put("softsq", "M3 12h3l2-5 3 10 3-7 2 2h5");
        ICONS.put("txt", "M4 6h16M4 11h11M4 16h14M4 21h7");
        ICONS.put("vfo", "M12 6.5a5.5 5.5 0 1 0 0.01 0M12 6.5v4M12 2v1.5M3.5 5.5l1 1M20.5 5.5l-1 1M2 12h1.5M20.5 12H22");
        ICONS.put("rec", "M12 7a5 5 0 1 0 0.01 0");
        ICONS.put("mon", "M2 12s4-6 10-6 10 6 10 6-4 6-10 6S2 12 2 12zM12 9.5a2.5 2.5 0 1 0 0.01 0");
        ICONS.put("pkt", "M12 10v11M8 21h8M8.5 6.5a5 5 0 0 1 7 0M5.5 3.5a9 9 0 0 1 13 0");
        ICONS.put("repeaters", "M5 14a7 7 0 0 0 9.9 0L5 4.1a7 7 0 0 0 0 9.9zM10 9l3-3M14 4a6 6 0 0 1 6 6M14 7.5a2.5 2.5 0 0 1 2.5 2.5M8 18l-2 3h8l-2-3");
        ICONS.put("plus", "M12 5v14M5 12h14");
        ICONS.put("search", "M11 4.5a6.5 6.5 0 1 0 0.01 0M16 16l4.5 4.5");
        ICONS.put("star", "M12 3.5l2.6 5.3 5.9.9-4.3 4.1 1 5.8L12 16.9l-5.2 2.7 1-5.8-4.3-4.1 5.9-.9z");
        ICONS.put("menu", "M4 7h16M4 12h16M4 17h10");
        ICONS.put("left", "M15 5l-7 7 7 7");
        ICONS.put("right", "M9 5l7 7-7 7");
        ICONS.put("module", "M6 6h12v12H6zM9 2v4M15 2v4M9 18v4M15 18v4M2 9h4M2 15h4M18 9h4M18 15h4M10 12h4");
        ICONS.put("handback", "M9 14L4 9l5-5M4 9h10a6 6 0 0 1 0 12h-3");
        ICONS.put("takeover", "M15 10l5 5-5 5M20 15H10a6 6 0 0 1 0-12h3");
        ICONS.put("shield", "M12 3l8 3v6c0 4.5-3.4 8-8 9-4.6-1-8-4.5-8-9V6zM8.5 12l2.5 2.5 4.5-5");
        ICONS.put("power", "M12 3v8M6.3 7a8 8 0 1 0 11.4 0");
        ICONS.put("ptt", "M9 6a3 3 0 0 1 6 0v5a3 3 0 0 1-6 0zM5.5 11a6.5 6.5 0 0 0 13 0M12 17.5V21");
        ICONS.put("volume", "M4 9v6h4l5 4V5L8 9zM17 9a4 4 0 0 1 0 6M19.5 6.5a7.5 7.5 0 0 1 0 11");
        ICONS.put("voice", "M4 9v6h4l5 4V5L8 9zM17 9a4 4 0 0 1 0 6");
        ICONS.put("backup", "M12 4v11M7 10l5 5 5-5M5 20h14");
        ICONS.put("restore", "M12 20V9M7 14l5-5 5 5M5 4h14");
        ICONS.put("import", "M4 4h7v7H4zM13 13h7v7h-7zM14 7h4a2 2 0 0 1 2 2v2M10 17H6a2 2 0 0 1-2-2v-2");
        ICONS.put("globe", "M12 3a9 9 0 1 0 0.01 0M3 12h18M12 3c3 3.5 3 14.5 0 18M12 3c-3 3.5-3 14.5 0 18");
        ICONS.put("report", "M9 3h6l1 3h3v15H5V6h3zM9 12h6M9 16h4");
        ICONS.put("update", "M20 12a8 8 0 1 1-2.3-5.7M20 4v5h-5");
        ICONS.put("help", "M12 3a9 9 0 1 0 0.01 0M9.5 9.5a2.5 2.5 0 1 1 3.5 2.3c-.7.3-1 .9-1 1.7M12 17h.01");
        ICONS.put("diag", "M3 12h4l3-8 4 16 3-8h4");
        ICONS.put("id", "M3 6h18v12H3zM7 10h4M7 14h6M16 10a1.5 1.5 0 1 0 0.01 0");
        ICONS.put("check", "M5 12.5l4.5 4.5L19 7.5");
        ICONS.put("info", "M12 3a9 9 0 1 0 0.01 0M12 11v5.5M12 7.8h.01");
        ICONS.put("close", "M6 6l12 12M18 6L6 18");
        ICONS.put("alert", "M12 3.5L2.5 20h19zM12 10v4.5M12 17.5h.01");
        ICONS.put("bolt", "M13 3L5 13.5h6L10 21l8-10.5h-6z");
        ICONS.put("send", "M4 12l16-8-5.5 16-3.2-6.8zM11.3 13.2L20 4");
        ICONS.put("radio", "M5 9h14v12H5zM9 4l8 5M8 14h3M8 17h3M15 15a2 2 0 1 0 0.01 0");
    }

    /** A line icon from {@link #ICONS} (or raw path data), stroked in one colour, scaled to its bounds. */
    private static final Map<String, Path> PATHS = new HashMap<>();
    /** Parsed once per icon (parsing on every draw-object creation churned the heap on each page switch). Shared and never mutated. */
    private static synchronized Path path(String nameOrPath) {
        Path p = PATHS.get(nameOrPath);
        if (p == null) {
            String d = ICONS.containsKey(nameOrPath) ? ICONS.get(nameOrPath) : nameOrPath;
            try { p = androidx.core.graphics.PathParser.createPathFromPathData(d); } catch (Throwable t) { p = new Path(); }
            PATHS.put(nameOrPath, p);
        }
        return p;
    }

    public static final class IconDrawable extends Drawable {
        private final Path src; private final Path scaled = new Path(); private final Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
        private final boolean fill; private final Matrix m = new Matrix();
        public IconDrawable(String nameOrPath, int color) { this(nameOrPath, color, false); }
        public IconDrawable(String nameOrPath, int color, boolean fill) {
            src = path(nameOrPath); this.fill = fill;
            p.setColor(color); p.setStrokeCap(Paint.Cap.ROUND); p.setStrokeJoin(Paint.Join.ROUND);
        }
        public void setColor(int color) { p.setColor(color); invalidateSelf(); }
        @Override protected void onBoundsChange(android.graphics.Rect b) {
            float s = Math.min(b.width(), b.height()) / 24f;
            m.setScale(s, s); m.postTranslate(b.left + (b.width() - 24 * s) / 2f, b.top + (b.height() - 24 * s) / 2f);
            src.transform(m, scaled); p.setStrokeWidth(1.8f * s);
        }
        @Override public void draw(Canvas c) {
            if (fill) { p.setStyle(Paint.Style.FILL); p.setAlpha(Math.min(255, (p.getColor() >>> 24))); c.drawPath(scaled, p); }
            p.setStyle(Paint.Style.STROKE); c.drawPath(scaled, p);
        }
        @Override public int getIntrinsicWidth() { return 72; }
        @Override public int getIntrinsicHeight() { return 72; }
        @Override public void setAlpha(int a) { p.setAlpha(a); invalidateSelf(); }
        @Override public void setColorFilter(ColorFilter f) { p.setColorFilter(f); invalidateSelf(); }
        @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    }

    /** Neon on/off switch (track + glowing knob) replacing the stock CheckBox. */
    public static final class NeonSwitch extends View {
        public interface OnChange { void changed(boolean on); }
        private boolean on; private OnChange cb; private int accent = CYAN;
        private final Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
        public NeonSwitch(Context c) { super(c); setClickable(true); setFocusable(true); setOnClickListener(v -> { setChecked(!on); if (cb != null) cb.changed(on); }); }
        public void setAccent(int a) { accent = a; invalidate(); }
        public void setChecked(boolean v) { on = v; setContentDescription(on ? "On" : "Off"); invalidate(); }
        public boolean isChecked() { return on; }
        public void setOnChange(OnChange c) { cb = c; }
        @Override protected void onMeasure(int w, int h) { setMeasuredDimension(Theme.dp(getContext(), 52), Theme.dp(getContext(), 32)); }
        @Override protected void onDraw(Canvas c) {
            float d = Theme.dp(getContext()), w = 46 * d, h = 26 * d, x = (getWidth() - w) / 2f, y = (getHeight() - h) / 2f, r = h / 2f;
            android.graphics.RectF t = new android.graphics.RectF(x, y, x + w, y + h);
            p.setStyle(Paint.Style.FILL);
            if (on) { p.setColor(alpha(accent, 0x26)); android.graphics.RectF h2 = new android.graphics.RectF(t); h2.inset(-3 * d, -3 * d); c.drawRoundRect(h2, r + 3 * d, r + 3 * d, p); }   // halo instead of a shadow layer
            p.setColor(on ? alpha(accent, 0x33) : 0xFF0E1A26); c.drawRoundRect(t, r, r, p);
            p.setStyle(Paint.Style.STROKE); p.setStrokeWidth(1.5f * d); p.setColor(on ? accent : 0xFF2A3C50); c.drawRoundRect(t, r, r, p);
            float kr = 9.5f * d, kx = on ? x + w - 3 * d - kr : x + 3 * d + kr;
            p.setStyle(Paint.Style.FILL);
            if (on) { p.setColor(alpha(accent, 0x55)); c.drawCircle(kx, y + h / 2f, kr + 3 * d, p); }
            p.setColor(on ? accent : 0xFF4A5E72); c.drawCircle(kx, y + h / 2f, kr, p);
        }
        @Override public boolean onTouchEvent(MotionEvent e) { return super.onTouchEvent(e); }
    }

    /** A settings row: icon tile, title + subtitle, neon switch. */
    public static LinearLayout switchRow(Context c, String icon, int accent, String title, String sub, NeonSwitch sw) {
        LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER_VERTICAL); row.setMinimumHeight(Theme.dp(c, 60));
        row.setPadding(Theme.dp(c, 14), Theme.dp(c, 8), Theme.dp(c, 8), Theme.dp(c, 8));
        LinearLayout.LayoutParams il = new LinearLayout.LayoutParams(Theme.dp(c, 38), Theme.dp(c, 38)); il.rightMargin = Theme.dp(c, 12);
        row.addView(iconTile(c, icon, accent, 38), il);
        LinearLayout col = new LinearLayout(c); col.setOrientation(LinearLayout.VERTICAL);
        col.addView(text(c, title, TEXT, 16, ui(c)));
        if (sub != null) { TextView s = text(c, sub, MUTED, 13, uiMedium(c)); s.setPadding(0, Theme.dp(c, 2), 0, 0); col.addView(s); }
        row.addView(col, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        row.addView(sw);
        row.setOnClickListener(v -> sw.performClick());
        return row;
    }

    /** A tool tile: icon top-left, title and one-line subtitle at the bottom, tinted with its accent. */
    public static LinearLayout tile(Context c, String icon, int accent, String title, String sub) {
        LinearLayout t = new LinearLayout(c); t.setOrientation(LinearLayout.VERTICAL); t.setMinimumHeight(Theme.dp(c, 96));
        int p = Theme.dp(c, 12); t.setPadding(p, p, p, p);
        android.graphics.drawable.StateListDrawable s = new android.graphics.drawable.StateListDrawable();
        s.addState(new int[] { android.R.attr.state_pressed }, tint(c, accent, 16, 1.5f)); s.addState(new int[] { }, tint(c, accent, 16, 1));
        t.setBackground(s);
        ImageView ic = new ImageView(c); ic.setImageDrawable(new IconDrawable(icon, accent));
        t.addView(ic, new LinearLayout.LayoutParams(Theme.dp(c, 26), Theme.dp(c, 26)));
        View gap = new View(c); t.addView(gap, new LinearLayout.LayoutParams(1, 0, 1f));
        TextView tt = text(c, title, TEXT, 15.5f, ui(c)); tt.setPadding(0, Theme.dp(c, 8), 0, 0); t.addView(tt);
        TextView st = text(c, sub == null ? "" : sub, MUTED, 12.5f, uiSemi(c)); st.setTag("sub"); st.setPadding(0, Theme.dp(c, 2), 0, 0); st.setMaxLines(2); t.addView(st);
        t.setClickable(true); t.setFocusable(true);
        return t;
    }

    // ---- sheets: the pop-up pages (VFO, packet tools, Last heard, Nearby repeaters, recordings, captions) ----

    /** A label in the new look: old palette colours mapped to the new roles, Rajdhani text. */
    public static TextView label(Context c, String s, int color, float sp, boolean bold) {
        TextView t = text(c, s, remap(color), sp + (bold ? 0.5f : 1f), bold ? ui(c) : uiMedium(c));
        t.setLineSpacing(0, 1.08f);
        return t;
    }
    private static int remap(int col) {
        switch (col) {
            case 0xFF00E5FF: case 0xFF00BFFF: return CYAN;          // Theme.CYAN, CYAN2, SOFTSQ text
            case 0xFFFFD54F: case 0xFFFFCC80: return AMBER_LIGHT;   // Theme.AMBER, MON / VFO text
            case 0xFF69F0AE: case 0xFF00FF00: return GREEN_LIGHT;   // PKT text, Theme.GREEN
            case 0xFFFF8A80: case 0xFFF44336: return RED;           // REC text, Theme.RED
            case 0xFFE1BEE7: return VIOLET_LIGHT;                   // TXT text
            case 0xFFFFFFFF: return TEXT;
            case 0xFFBFC8D0: case 0xFFC8D2DC: case 0xFFD0D8E0: return TEXT_SOFT;
            case 0xFF8A98A6: case 0xFF9AA4AE: case 0xFF6F7F8F: return MUTED;
            default: return col;
        }
    }
    /** New-look accent for one of the old Theme accent sets. */
    public static int accentOf(int[] a) {
        if (a == Theme.PKT) return GREEN; if (a == Theme.VFO || a == Theme.MON) return AMBER; if (a == Theme.REC) return RED; if (a == Theme.TXT) return VIOLET;
        return CYAN;
    }
    public static int light(int accent) { return accent == CYAN ? CYAN_LIGHT : accent == GREEN ? GREEN_LIGHT : accent == AMBER ? AMBER_LIGHT : accent == VIOLET ? VIOLET_LIGHT : accent; }

    private static String iconFor(String title) {
        String t = title.toLowerCase(java.util.Locale.US);
        if (t.contains("packet")) return "pkt"; if (t.contains("vfo")) return "vfo"; if (t.contains("repeater")) return "repeaters";
        if (t.contains("record")) return "rec"; if (t.contains("caption") || t.contains("transcript")) return "txt"; if (t.contains("last heard")) return "intercom";
        if (t.contains("station")) return "globe"; if (t.contains("dtmf")) return "channels"; if (t.contains("weather") || t.contains("same")) return "alert";
        if (t.contains("setting")) return "device"; if (t.contains("sstv") || t.contains("picture")) return "report"; if (t.contains("log")) return "diag";
        return "radio";
    }

    /** The body of a sheet: opaque card, icon tile and title (a leading emoji in the old titles is dropped). */
    public static LinearLayout sheetBody(Context c, String title) {
        float d = Theme.dp(c);
        LinearLayout body = new LinearLayout(c); body.setOrientation(LinearLayout.VERTICAL);
        body.setBackground(sheet(c, alpha(CYAN, 0x66), 20)); body.setPadding((int) (18 * d), (int) (16 * d), (int) (18 * d), (int) (14 * d));
        String clean = title.replaceFirst("^[^\\p{L}\\p{N}]+", "").trim();
        LinearLayout head = new LinearLayout(c); head.setGravity(android.view.Gravity.CENTER_VERTICAL); head.setPadding(0, 0, 0, (int) (4 * d));
        head.addView(iconTile(c, iconFor(clean), CYAN, 40), new LinearLayout.LayoutParams((int) (40 * d), (int) (40 * d)));
        TextView t = text(c, clean, TEXT, 20, ui(c)); t.setPadding((int) (12 * d), 0, 0, 0);
        head.addView(t, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        body.addView(head);
        return body;
    }
    /** Show a sheet: scrollable, the card is the whole window (no stock dialog frame). */
    public static android.app.AlertDialog showSheet(Context c, View body) {
        android.widget.ScrollView sv = new android.widget.ScrollView(c); sv.setVerticalScrollBarEnabled(false); sv.addView(body);
        android.app.AlertDialog a = new android.app.AlertDialog.Builder(c).setView(sv).create();
        a.show();
        if (a.getWindow() != null) a.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(0));
        return a;
    }
    public static TextView sheetHint(Context c, String s) { float d = Theme.dp(c); TextView t = label(c, s, MUTED, 12.5f, false); t.setPadding(0, (int) (4 * d), 0, (int) (8 * d)); return t; }
    public static TextView sheetSection(Context c, String s) { float d = Theme.dp(c); TextView t = caps(c, s); t.setPadding(0, (int) (14 * d), 0, (int) (6 * d)); return t; }
    public static GradientDrawable rowCard(Context c) {
        GradientDrawable g = new GradientDrawable(); g.setColor(0xFF0E1A27); g.setCornerRadius(Theme.dp(c, 12)); g.setStroke(Theme.dp(c, 1), 0xFF1A2C3E);
        return g;
    }
    /** Choice pill: lit in its accent when selected, quiet otherwise. */
    public static void pillStyle(TextView t, boolean on, int accent) {
        Context c = t.getContext();
        if (on) t.setBackground(outline(c, accent, 0x33, 14, 1.5f));
        else { GradientDrawable g = new GradientDrawable(); g.setColor(PANEL_SOLID); g.setCornerRadius(Theme.dp(c, 14)); g.setStroke(Theme.dp(c, 1), 0xFF22364A); t.setBackground(g); }
        t.setTextColor(on ? light(accent) : 0xFF9FB4C8); t.setTypeface(ui(c));
    }
}
