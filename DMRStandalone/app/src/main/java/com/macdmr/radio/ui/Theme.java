package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.view.Gravity;
import android.widget.TextView;

/** The intercom look carried over from DMRModHooks: deep navy, neon cyan, one accent per mode. */
public final class Theme {
    public static final int BG = 0xFF0A1520, TITLE_BG = 0xFF060D14, NAV_BG = 0xFF071019;
    public static final int CYAN = 0xFF00E5FF, CYAN2 = 0xFF00BFFF, CYAN_DIM = 0xFF1A5560, WHITE = 0xFFFFFFFF, GREY = 0xFF888888;
    public static final int GREEN = 0xFF00FF00, YELLOW = 0xFFFFFF00, AMBER = 0xFFFFD54F, RED = 0xFFF44336;
    public static final int NAVY_A = 0xFF0D1F4A, NAVY_B = 0xFF1A3680;

    /** Accent sets for the six satellite buttons (on fill, off fill, border, text). */
    public static final int[] SOFTSQ = { 0xFF0D3D47, 0xFF0A2A30, 0xFF00BCD4, 0xFF00E5FF };
    public static final int[] TXT    = { 0xFF2A0A4A, 0xFF17062A, 0xFF9C27B0, 0xFFE1BEE7 };
    public static final int[] VFO    = { 0xFF3A2000, 0xFF201000, 0xFFFF9800, 0xFFFFCC80 };
    public static final int[] REC    = { 0xFF500000, 0xFF2A0000, 0xFFF44336, 0xFFFF8A80 };
    public static final int[] MON    = { 0xFF362500, 0xFF1A1000, 0xFFFF8F00, 0xFFFFD54F };
    public static final int[] PKT    = { 0xFF004400, 0xFF002200, 0xFF00E676, 0xFF69F0AE };

    public static float dp(Context c) { return c.getResources().getDisplayMetrics().density; }
    public static int dp(Context c, float v) { return Math.round(v * dp(c)); }

    public static GradientDrawable rounded(Context c, int fill, int stroke, float strokeDp, float radiusDp) {
        GradientDrawable g = new GradientDrawable();
        g.setColor(fill); g.setCornerRadius(radiusDp * dp(c));
        if (strokeDp > 0) g.setStroke(dp(c, strokeDp), stroke);
        return g;
    }

    public static GradientDrawable gradient(Context c, int a, int b, int stroke, float strokeDp, float radiusDp) {
        GradientDrawable g = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM, new int[] { a, b });
        g.setCornerRadius(radiusDp * dp(c));
        if (strokeDp > 0) g.setStroke(dp(c, strokeDp), stroke);
        return g;
    }

    /** Navy gradient pill with a cyan border — SCAN / ZONE style. */
    public static StateListDrawable pill(Context c) {
        StateListDrawable s = new StateListDrawable();
        s.addState(new int[] { android.R.attr.state_pressed }, gradient(c, NAVY_B, NAVY_A, CYAN, 2, 8));
        s.addState(new int[] {}, gradient(c, NAVY_A, NAVY_B, CYAN, 2, 8));
        return s;
    }

    public static TextView label(Context c, String text, int color, float sp, boolean bold) {
        TextView t = new TextView(c);
        t.setText(text); t.setTextColor(color); t.setTextSize(sp);
        if (bold) t.setTypeface(Typeface.DEFAULT_BOLD);
        return t;
    }

    public static TextView pillButton(Context c, String text) {
        TextView t = label(c, text, CYAN, 15, true);
        t.setGravity(Gravity.CENTER); t.setBackground(pill(c));
        t.setPadding(dp(c, 14), dp(c, 12), dp(c, 14), dp(c, 12));
        t.setClickable(true); t.setFocusable(true);
        return t;
    }
}
