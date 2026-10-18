package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.view.View;

/**
 * Segmented S-meter for the new intercom look: 24 segments from S1 (−141 dBm) to S9+40 (−53 dBm), cyan up
 * to S9, amber to +20, red above; S-unit scale underneath. S9 = −93 dBm, 6 dB per S-unit (VHF/UHF convention).
 */
public class SMeterView extends View {
    private static final int SEGS = 24;
    private static final float LOW = -141f;
    private int dbm = -999;
    private final Paint seg = new Paint(Paint.ANTI_ALIAS_FLAG), txt = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final RectF r = new RectF();

    public SMeterView(Context c) {
        super(c);
        txt.setColor(Neo.DIM); txt.setTypeface(Neo.mono(c)); txt.setTextSize(10 * c.getResources().getDisplayMetrics().scaledDensity);
        setLayerType(LAYER_TYPE_SOFTWARE, null);   // glow (shadow layer) on lit segments
    }

    public void setDbm(int v) { if (v == dbm) return; dbm = v; invalidate(); }

    /** "S7", "S9+12" or "--". */
    public static String sUnits(int dbm) {
        if (dbm == -999) return "--";
        if (dbm <= -93) return "S" + Math.max(0, Math.min(9, Math.round((dbm + 147) / 6f)));
        return "S9+" + (dbm + 93);
    }

    @Override protected void onMeasure(int w, int h) { setMeasuredDimension(MeasureSpec.getSize(w), Theme.dp(getContext(), 34)); }

    @Override protected void onDraw(Canvas c) {
        float d = Theme.dp(getContext()), w = getWidth(), gap = 3 * d, sw = (w - gap * (SEGS - 1)) / SEGS, top = 2 * d, bot = 18 * d;
        // S1..S9 over the first 16 segments (3 dB each), S9..S9+40 over the last 8 (5 dB each)
        int lit = dbm == -999 ? 0 : Math.max(0, Math.min(SEGS, Math.round(dbm <= -93 ? (dbm - LOW) / 3f : 16 + (dbm + 93) / 5f)));
        for (int i = 0; i < SEGS; i++) {
            int col = i < 16 ? Neo.CYAN : i < 20 ? Neo.AMBER : Neo.RED;
            boolean on = i < lit;
            seg.setColor(on ? col : 0xFF122234);
            seg.setShadowLayer(on ? 5 * d : 0, 0, 0, on ? Neo.alpha(col, 0xAA) : 0);
            float x = i * (sw + gap); r.set(x, top, x + sw, bot);
            c.drawRoundRect(r, 2 * d, 2 * d, seg);
        }
        seg.setShadowLayer(0, 0, 0, 0);
        String[] labels = { "S1", "S3", "S5", "S7", "S9", "+20", "+40" };
        float[] at = { 0, 4 / 24f, 8 / 24f, 12 / 24f, 16 / 24f, 20 / 24f, 1f };
        float y = bot + 13 * d;
        for (int i = 0; i < labels.length; i++) {
            float tw = txt.measureText(labels[i]), x = at[i] * w - (i == 0 ? 0 : i == labels.length - 1 ? tw : tw / 2f);
            c.drawText(labels[i], x, y, txt);
        }
    }
}
