package com.macdmr.radio.ui;

import android.animation.ValueAnimator;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PathMeasure;
import android.graphics.RectF;
import android.graphics.Shader;
import android.view.MotionEvent;
import android.view.View;

/**
 * The launch screen, drawn in code (no bitmaps): the SignalDeck wordmark, an angular radio panel that traces itself
 * in, a wave packet travelling from TX to RX with the meters following it, a scanning dot row and the version.
 * Laid out on a 784-unit-wide design grid and scaled to the screen. Tap to skip; calls {@code done} once faded out.
 */
public final class SplashView extends View {
    private static final long SHOW_MS = 2600, FADE_MS = 380;
    private static final int BG = 0xFF17191C, FRAME = 0xFF4B4F55, FRAME_IN = 0xFF34383D, GREY = 0xFFA9AEB4, DOT = 0xFF4F5359;
    private static final int CYAN = Neo.CYAN;

    private final Runnable done;
    private final String version;
    private final Paint word = new Paint(Paint.ANTI_ALIAS_FLAG), sub = new Paint(Paint.ANTI_ALIAS_FLAG), small = new Paint(Paint.ANTI_ALIAS_FLAG),
            line = new Paint(Paint.ANTI_ALIAS_FLAG), fill = new Paint(Paint.ANTI_ALIAS_FLAG), wave = new Paint(Paint.ANTI_ALIAS_FLAG), glint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Path outer = new Path(), inner = new Path(), tab = new Path(), seg = new Path(), wavePath = new Path(), echoPath = new Path();
    private final PathMeasure pm = new PathMeasure();
    private final boolean animate;
    private long start = -1;
    private boolean finishing;
    private float s, ox, oy;           // design-grid scale and offset

    public SplashView(Context c, String version, Runnable done) {
        super(c);
        this.version = version; this.done = done;
        animate = ValueAnimator.areAnimatorsEnabled();
        word.setTypeface(Neo.display(c)); word.setTextAlign(Paint.Align.LEFT);
        sub.setTypeface(Neo.uiMedium(c)); sub.setColor(GREY); sub.setTextAlign(Paint.Align.CENTER); sub.setLetterSpacing(0.08f);
        small.setTypeface(Neo.uiSemi(c)); small.setColor(GREY);
        line.setStyle(Paint.Style.STROKE); line.setStrokeJoin(Paint.Join.MITER);
        wave.setStyle(Paint.Style.STROKE); wave.setStrokeCap(Paint.Cap.ROUND); wave.setStrokeJoin(Paint.Join.ROUND); wave.setColor(CYAN);
        setLayerType(LAYER_TYPE_HARDWARE, null);
        setContentDescription("SignalDeck " + version);
        setOnClickListener(v -> finish());
    }

    @Override protected void onSizeChanged(int w, int h, int ow, int oh) {
        s = Math.min(w / 784f, h / 1168f * 1.25f);
        ox = (w - 784 * s) / 2; oy = h * 0.5f - 700 * s;      // the panel's middle sits a little below the centre
        outer.reset(); chamfer(outer, 97, 632, 687, 816, 22);
        inner.reset();                                           // inset frame that steps up around the bottom tab
        float l = 109, t = 644, r = 675, b = 804, k = 16;
        inner.moveTo(x(l + k), y(t)); inner.lineTo(x(r - k), y(t)); inner.lineTo(x(r), y(t + k)); inner.lineTo(x(r), y(b - k)); inner.lineTo(x(r - k), y(b));
        inner.lineTo(x(538), y(b)); inner.lineTo(x(522), y(760)); inner.lineTo(x(262), y(760)); inner.lineTo(x(246), y(b));
        inner.lineTo(x(l + k), y(b)); inner.lineTo(x(l), y(b - k)); inner.lineTo(x(l), y(t + k)); inner.close();
        tab.reset(); chamfer(tab, 268, 768, 516, 806, 9);
        float target = 572 * s; word.setTextSize(100 * s);
        float wd = word.measureText("SignalDeck"); word.setTextSize(100 * s * target / wd);
        sub.setTextSize(29 * s); small.setTextSize(19 * s);
        glint.setShader(null);
    }

    private float x(float v) { return ox + v * s; }
    private float y(float v) { return oy + v * s; }
    private void chamfer(Path p, float l, float t, float r, float b, float k) {
        p.moveTo(x(l + k), y(t)); p.lineTo(x(r - k), y(t)); p.lineTo(x(r), y(t + k)); p.lineTo(x(r), y(b - k));
        p.lineTo(x(r - k), y(b)); p.lineTo(x(l + k), y(b)); p.lineTo(x(l), y(b - k)); p.lineTo(x(l), y(t + k)); p.close();
    }
    private static float clamp(float v) { return v < 0 ? 0 : v > 1 ? 1 : v; }
    private static float ease(float v) { v = clamp(v); return 1 - (1 - v) * (1 - v) * (1 - v); }
    private static float span(long t, long from, long len) { return ease((t - from) / (float) len); }

    @Override public boolean onTouchEvent(MotionEvent e) { if (e.getAction() == MotionEvent.ACTION_UP) performClick(); return true; }

    private void finish() {
        if (finishing) return; finishing = true;
        animate().alpha(0f).setDuration(FADE_MS).withEndAction(() -> { if (done != null) done.run(); }).start();
    }

    @Override protected void onDraw(Canvas cv) {
        long now = System.currentTimeMillis();
        if (start < 0) start = now;
        long t = animate ? now - start : 10_000;                 // animations off: the finished frame
        if (!finishing && now - start >= (animate ? SHOW_MS : 1200)) finish();
        cv.drawColor(BG);

        // wordmark: "Signal" rises in, "Deck" follows; a light glint crosses once
        float base = y(497);
        float wSig = word.measureText("Signal"), wAll = word.measureText("SignalDeck"), left = x(392) - wAll / 2;
        float a1 = span(t, 120, 520), a2 = span(t, 260, 520);
        word.setColor(CYAN); word.setAlpha((int) (255 * a1)); word.setShadowLayer(14 * s * a1, 0, 0, Neo.alpha(CYAN, (int) (0x70 * a1)));
        cv.drawText("Signal", left, base + (1 - a1) * 26 * s, word);
        word.setShadowLayer(0, 0, 0, 0); word.setColor(0xFFFFFFFF); word.setAlpha((int) (255 * a2));
        cv.drawText("Deck", left + wSig, base + (1 - a2) * 26 * s, word);
        float g = (t - 950) / 650f;
        if (g > 0 && g < 1) {
            float gx = left - 120 * s + g * (wAll + 240 * s);
            glint.setShader(new LinearGradient(gx - 60 * s, 0, gx + 60 * s, 0, new int[] { 0x00FFFFFF, 0x99FFFFFF, 0x00FFFFFF }, null, Shader.TileMode.CLAMP));
            glint.setTypeface(word.getTypeface()); glint.setTextSize(word.getTextSize());
            cv.drawText("SignalDeck", left, base, glint);
        }
        sub.setAlpha((int) (255 * span(t, 520, 500)));
        cv.drawText("Advanced Radio Control", x(392), y(560), sub);

        // panel: frames trace themselves in
        float p1 = span(t, 300, 700), p2 = span(t, 450, 700), p3 = span(t, 650, 450);
        line.setStrokeWidth(2.2f * s); line.setColor(FRAME); traced(cv, outer, p1);
        line.setStrokeWidth(1.5f * s); line.setColor(FRAME_IN); traced(cv, inner, p2);
        line.setStrokeWidth(1.8f * s); line.setColor(FRAME); traced(cv, tab, p3);

        // the wave packet runs TX -> RX; meters follow it
        float on = span(t, 700, 500);
        float cyc = animate ? ((now - start) % 2200) / 2200f : 0.5f;
        float cx = 210 + cyc * 364;                                // packet centre, design units
        float tx = clamp(1 - (cx - 210) / 180f), rx = clamp((cx - 394) / 180f);
        float phase = animate ? (now - start) / 1000f * 9f : 0;
        drawWave(cv, cx, phase, on);
        drawMeter(cv, 124, true, on * (0.35f + 0.65f * tx), animate ? now : 0);
        drawMeter(cv, 598, false, on * (0.25f + 0.75f * rx), animate ? now + 333 : 0);
        small.setAlpha((int) (255 * on)); small.setTextAlign(Paint.Align.LEFT); cv.drawText("TX", x(143), y(734), small);
        small.setTextAlign(Paint.Align.RIGHT); cv.drawText("RX", x(647), y(734), small);
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(CYAN); fill.setAlpha((int) (255 * on * (0.35f + 0.65f * tx))); cv.drawCircle(x(130), y(727), 5 * s, fill);
        fill.setColor(rx > 0.2f ? CYAN : DOT); fill.setAlpha((int) (255 * on * (rx > 0.2f ? 0.35f + 0.65f * rx : 1))); cv.drawCircle(x(609), y(727), 5 * s, fill);

        // scanning dots in the bottom tab
        float d = span(t, 800, 300);
        float scan = animate ? ((now - start) / 160f) % 12 : 3;
        int lit = (int) (scan < 7 ? scan : 12 - scan);             // bounces 0..6..0
        for (int i = 0; i < 7; i++) {
            fill.setColor(i == lit ? CYAN : DOT); fill.setAlpha((int) (255 * d));
            if (i == lit) fill.setShadowLayer(8 * s, 0, 0, Neo.alpha(CYAN, 0x90)); else fill.clearShadowLayer();
            cv.drawCircle(x(305 + i * 29), y(787), (i == lit ? 6 : 5.5f) * s, fill);
        }
        fill.clearShadowLayer();

        // version near the bottom
        small.setTextAlign(Paint.Align.CENTER); small.setColor(0xFFC3C8CE); small.setAlpha((int) (255 * span(t, 900, 500)));
        float vs = small.getTextSize(); small.setTextSize(22 * s);
        small.setLetterSpacing(0.14f); cv.drawText(version, getWidth() / 2f, getHeight() * 0.80f, small);   // above the bottom 15 %, where system toasts appear
        small.setTextSize(vs);
        small.setLetterSpacing(0); small.setColor(GREY);

        if (!finishing || getAlpha() > 0) postInvalidateOnAnimation();
    }

    private void traced(Canvas cv, Path p, float f) {
        if (f <= 0) return;
        if (f >= 1) { cv.drawPath(p, line); return; }
        pm.setPath(p, true); seg.reset(); pm.getSegment(0, pm.getLength() * f, seg, true); cv.drawPath(seg, line);
    }

    private void drawWave(Canvas cv, float cx, float phase, float on) {
        if (on <= 0) return;
        wavePath.reset(); echoPath.reset();
        float sigma = 62, amp = 36 * on, mid = 703;
        for (float u = 172; u <= 612; u += 2) {
            float d = (u - cx) / sigma, env = (float) Math.exp(-d * d);
            float yv = (float) (mid - amp * env * Math.sin((u - cx) / 5.1f - phase));
            float ye = (float) (mid - amp * 0.45f * env * Math.sin((u - cx) / 5.1f - phase + 1.9f));
            if (u == 172) { wavePath.moveTo(x(u), y(yv)); echoPath.moveTo(x(u), y(ye)); } else { wavePath.lineTo(x(u), y(yv)); echoPath.lineTo(x(u), y(ye)); }
        }
        Shader fade = new LinearGradient(x(172), 0, x(612), 0, new int[] { 0x00FFFFFF & CYAN, CYAN, CYAN, 0x00FFFFFF & CYAN }, new float[] { 0, 0.12f, 0.88f, 1 }, Shader.TileMode.CLAMP);
        wave.setShader(fade);
        wave.setStrokeWidth(1.4f * s); wave.setAlpha((int) (110 * on)); wave.clearShadowLayer(); cv.drawPath(echoPath, wave);
        wave.setStrokeWidth(2.6f * s); wave.setAlpha((int) (255 * on)); wave.setShadowLayer(9 * s, 0, 0, Neo.alpha(CYAN, 0x80)); cv.drawPath(wavePath, wave);
        wave.clearShadowLayer(); wave.setShader(null);
    }

    /** Ten ticks; {@code level} lights the first ones in cyan, with a little live flicker. */
    private void drawMeter(Canvas cv, float x0, boolean tx, float level, long now) {
        float flick = now == 0 ? 0 : (float) Math.sin(now / 90.0 + (tx ? 0 : 2)) * 0.08f;
        int n = Math.round(10 * clamp(level + flick));
        fill.setStyle(Paint.Style.FILL);
        RectF r = new RectF();
        for (int i = 0; i < 10; i++) {
            fill.setColor(i < n ? CYAN : DOT); fill.setAlpha(level <= 0 ? 0 : 255);
            float u = x0 + i * 6.3f; r.set(x(u), y(742), x(u + 2.6f), y(751)); cv.drawRect(r, fill);
        }
    }
}
