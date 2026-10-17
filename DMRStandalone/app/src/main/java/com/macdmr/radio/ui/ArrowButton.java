package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.view.MotionEvent;
import android.view.View;

/** Round channel step button: cyan ring with a filled triangle, brightens while pressed. */
public class ArrowButton extends View {
    private final boolean left;
    private final Paint ring = new Paint(Paint.ANTI_ALIAS_FLAG), tri = new Paint(Paint.ANTI_ALIAS_FLAG), fill = new Paint(Paint.ANTI_ALIAS_FLAG);
    private boolean pressed;

    public ArrowButton(Context c, boolean left) {
        super(c);
        this.left = left;
        ring.setStyle(Paint.Style.STROKE); ring.setStrokeWidth(Theme.dp(c, 2.5f)); ring.setColor(Theme.CYAN_DIM);
        tri.setColor(0xFF1E8FA6); fill.setColor(0xFF0B1E2A);
        setClickable(true);
    }

    @Override protected void onMeasure(int w, int h) { int s = Theme.dp(getContext(), 62); setMeasuredDimension(resolveSize(s, w), resolveSize(s, h)); }

    @Override public boolean onTouchEvent(MotionEvent e) {
        if (e.getAction() == MotionEvent.ACTION_DOWN) { pressed = true; invalidate(); }
        else if (e.getAction() == MotionEvent.ACTION_UP || e.getAction() == MotionEvent.ACTION_CANCEL) { pressed = false; invalidate(); }
        return super.onTouchEvent(e);
    }

    @Override protected void onDraw(Canvas cv) {
        float cx = getWidth() / 2f, cy = getHeight() / 2f, r = Math.min(cx, cy) - ring.getStrokeWidth();
        ring.setColor(pressed ? Theme.CYAN : Theme.CYAN_DIM); tri.setColor(pressed ? Theme.CYAN : 0xFF1E8FA6);
        cv.drawCircle(cx, cy, r, fill); cv.drawCircle(cx, cy, r, ring);
        float s = r * 0.52f; Path p = new Path();
        if (left) { p.moveTo(cx - s * 0.7f, cy); p.lineTo(cx + s * 0.55f, cy - s * 0.85f); p.lineTo(cx + s * 0.55f, cy + s * 0.85f); }
        else { p.moveTo(cx + s * 0.7f, cy); p.lineTo(cx - s * 0.55f, cy - s * 0.85f); p.lineTo(cx - s * 0.55f, cy + s * 0.85f); }
        p.close(); cv.drawPath(p, tri);
    }
}
