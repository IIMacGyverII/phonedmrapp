package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RadialGradient;
import android.graphics.RectF;
import android.graphics.Shader;
import android.view.MotionEvent;
import android.view.View;

/**
 * The big round push-to-talk key, drawn: dark bezel, glossy green dome (red while transmitting,
 * amber while the channel is busy), white microphone glyph. Press-and-hold semantics via {@link Listener}.
 */
public class PttButton extends View {
    public interface Listener { void onPtt(boolean down); }
    public enum State { IDLE, TX, BUSY }

    private final Paint bezel = new Paint(Paint.ANTI_ALIAS_FLAG), dome = new Paint(Paint.ANTI_ALIAS_FLAG), gloss = new Paint(Paint.ANTI_ALIAS_FLAG),
            glyph = new Paint(Paint.ANTI_ALIAS_FLAG), ring = new Paint(Paint.ANTI_ALIAS_FLAG);
    private boolean down;
    private State state = State.IDLE;
    private Listener listener;

    public PttButton(Context c) {
        super(c);
        bezel.setColor(0xFF1C2228); glyph.setColor(Theme.WHITE); ring.setStyle(Paint.Style.STROKE); ring.setStrokeWidth(Theme.dp(c, 3));
        setClickable(true);
    }

    public void setListener(Listener l) { listener = l; }
    public void setState(State s) { state = s; invalidate(); }

    @Override protected void onMeasure(int w, int h) { int s = Theme.dp(getContext(), 176); setMeasuredDimension(resolveSize(s, w), resolveSize(s, h)); }

    @Override public boolean onTouchEvent(MotionEvent e) {
        switch (e.getAction()) {
            case MotionEvent.ACTION_DOWN: if (!down) { down = true; invalidate(); if (listener != null) listener.onPtt(true); } return true;
            case MotionEvent.ACTION_UP: case MotionEvent.ACTION_CANCEL: if (down) { down = false; invalidate(); if (listener != null) listener.onPtt(false); } return true;
        }
        return super.onTouchEvent(e);
    }

    @Override protected void onDraw(Canvas cv) {
        float cx = getWidth() / 2f, cy = getHeight() / 2f, R = Math.min(cx, cy);
        int base, hi;
        switch (state) { case TX: base = 0xFFB71C1C; hi = 0xFFFF5252; break; case BUSY: base = 0xFF8D5A00; hi = 0xFFFFC107; break; default: base = 0xFF0E7A1E; hi = 0xFF4CFF6A; }
        if (down && state == State.IDLE) { base = 0xFF0A5A16; hi = 0xFF3BE05A; }
        cv.drawCircle(cx, cy, R, bezel);
        float r = R * 0.86f;
        dome.setShader(new RadialGradient(cx - r * 0.3f, cy - r * 0.35f, r * 1.4f, new int[] { hi, base, 0xFF04300A }, new float[] { 0f, 0.55f, 1f }, Shader.TileMode.CLAMP));
        cv.drawCircle(cx, cy, r, dome);
        gloss.setShader(new RadialGradient(cx, cy - r * 0.55f, r * 0.9f, 0x66FFFFFF, 0x00FFFFFF, Shader.TileMode.CLAMP));
        cv.drawOval(new RectF(cx - r * 0.75f, cy - r * 0.95f, cx + r * 0.75f, cy - r * 0.05f), gloss);
        ring.setColor(down ? 0xFFB9FFC6 : 0x5533FF66); cv.drawCircle(cx, cy, r, ring);
        // microphone glyph
        float mw = r * 0.34f, mh = r * 0.62f, top = cy - mh * 0.75f;
        cv.drawRoundRect(new RectF(cx - mw / 2, top, cx + mw / 2, top + mh), mw / 2, mw / 2, glyph);
        Paint arc = new Paint(Paint.ANTI_ALIAS_FLAG); arc.setStyle(Paint.Style.STROKE); arc.setStrokeWidth(r * 0.08f); arc.setColor(Theme.WHITE); arc.setStrokeCap(Paint.Cap.ROUND);
        cv.drawArc(new RectF(cx - mw * 0.95f, top + mh * 0.25f, cx + mw * 0.95f, top + mh * 1.15f), 20, 140, false, arc);
        cv.drawLine(cx, top + mh * 1.15f, cx, top + mh * 1.42f, arc);
        cv.drawLine(cx - mw * 0.6f, top + mh * 1.42f, cx + mw * 0.6f, top + mh * 1.42f, arc);
    }
}
