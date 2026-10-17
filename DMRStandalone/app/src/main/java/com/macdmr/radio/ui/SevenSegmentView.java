package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.view.View;

/**
 * Neon seven-segment channel number, drawn (no bitmaps): lit segments in cyan with a soft glow, unlit
 * segments as faint dark-teal ghosts, like a real LED display. Shows 2 digits (3 above 99).
 */
public class SevenSegmentView extends View {
    //            a  b  c  d  e  f  g
    private static final int[][] DIGITS = {
            {1, 1, 1, 1, 1, 1, 0}, {0, 1, 1, 0, 0, 0, 0}, {1, 1, 0, 1, 1, 0, 1}, {1, 1, 1, 1, 0, 0, 1}, {0, 1, 1, 0, 0, 1, 1},
            {1, 0, 1, 1, 0, 1, 1}, {1, 0, 1, 1, 1, 1, 1}, {1, 1, 1, 0, 0, 0, 0}, {1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 0, 1, 1} };
    private final Paint lit = new Paint(Paint.ANTI_ALIAS_FLAG), ghost = new Paint(Paint.ANTI_ALIAS_FLAG), glow = new Paint(Paint.ANTI_ALIAS_FLAG);
    private int value = 0;
    private int color = Theme.CYAN;

    public SevenSegmentView(Context c) {
        super(c);
        setColor(Theme.CYAN);
        ghost.setColor(0xFF0E2A33);
        setLayerType(LAYER_TYPE_SOFTWARE, null);
    }

    public void setColor(int c) {
        color = c; lit.setColor(c); glow.setColor(c & 0x60FFFFFF);
        glow.setMaskFilter(new android.graphics.BlurMaskFilter(14, android.graphics.BlurMaskFilter.Blur.NORMAL));
        invalidate();
    }

    public void setValue(int v) { value = Math.max(0, v); invalidate(); }
    public int getValue() { return value; }

    @Override protected void onMeasure(int w, int h) {
        int digits = value > 99 ? 3 : 2;
        int hh = resolveSize(Theme.dp(getContext(), 74), h);
        int ww = resolveSize(Theme.dp(getContext(), 46) * digits + Theme.dp(getContext(), 8) * (digits - 1), w);
        setMeasuredDimension(ww, hh);
    }

    @Override protected void onDraw(Canvas cv) {
        int digits = value > 99 ? 3 : 2;
        float gap = Theme.dp(getContext(), 10);
        float dw = (getWidth() - gap * (digits - 1)) / digits, dh = getHeight();
        String s = String.valueOf(value);
        while (s.length() < digits) s = "0" + s;
        for (int i = 0; i < digits; i++) drawDigit(cv, i * (dw + gap), 0, dw, dh, s.charAt(i) - '0');
    }

    private void drawDigit(Canvas cv, float x, float y, float w, float h, int d) {
        float t = w * 0.19f;                 // segment thickness
        float pad = t * 0.55f;               // inset from the digit box
        float L = w - 2 * pad;               // horizontal segment length
        float V = (h - 2 * pad - 1.5f * t) / 2; // vertical segment length
        float x0 = x + pad, y0 = y + pad;
        int[] on = DIGITS[d];
        // a top, b top-right, c bottom-right, d bottom, e bottom-left, f top-left, g middle
        seg(cv, x0 + t / 2, y0, L - t, t, true, on[0] == 1);
        seg(cv, x0 + L - t, y0 + t / 2, t, V, false, on[1] == 1);
        seg(cv, x0 + L - t, y0 + t / 2 + V + t / 2, t, V, false, on[2] == 1);
        seg(cv, x0 + t / 2, y0 + V * 2 + t / 2, L - t, t, true, on[3] == 1);
        seg(cv, x0, y0 + t / 2 + V + t / 2, t, V, false, on[4] == 1);
        seg(cv, x0, y0 + t / 2, t, V, false, on[5] == 1);
        seg(cv, x0 + t / 2, y0 + V, L - t, t, true, on[6] == 1);
    }

    /** A hexagonal LED segment (pointed ends) — horizontal or vertical. */
    private void seg(Canvas cv, float x, float y, float w, float h, boolean horizontal, boolean isOn) {
        Path p = new Path();
        float k = (horizontal ? h : w) / 2f;
        if (horizontal) {
            p.moveTo(x, y + k); p.lineTo(x + k, y); p.lineTo(x + w - k, y); p.lineTo(x + w, y + k);
            p.lineTo(x + w - k, y + h); p.lineTo(x + k, y + h); p.close();
        } else {
            p.moveTo(x + k, y); p.lineTo(x + w, y + k); p.lineTo(x + w, y + h - k); p.lineTo(x + k, y + h);
            p.lineTo(x, y + h - k); p.lineTo(x, y + k); p.close();
        }
        if (isOn) { cv.drawPath(p, glow); cv.drawPath(p, lit); } else cv.drawPath(p, ghost);
    }
}
