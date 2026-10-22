package com.macdmr.radio;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PixelFormat;
import android.graphics.RectF;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.FrameLayout;

import java.util.Random;

/**
 * Animated sci-fi background of the intercom panel: circuit traces, falling cyan "drop" lines and the audio level bars.
 *
 * Two layers, so the animation never makes the intercom page redraw: a {@link SurfaceView} with its own render thread
 * draws only what moves (the panel fill, the drops and the bars), and an ordinary view above it holds what never
 * changes (traces, border, the page colour in the rounded corners), drawn once. As one normal view, 10 fps of drops
 * cost 18-29 % of a core in window redraws (measured 2026-10-18).
 */
public class CircuitBoardView extends FrameLayout {

    private static final int NUM_DROPS = 10, NUM_BARS = 18;
    private final float[] dropX = new float[NUM_DROPS], dropY = new float[NUM_DROPS], dropSpeed = new float[NUM_DROPS], dropLength = new float[NUM_DROPS];
    private final float[] barHeights = new float[NUM_BARS];
    private final Random rng = new Random(0xDEAD);
    private final Paint barPaint = new Paint(Paint.ANTI_ALIAS_FLAG), dropPaint = new Paint(Paint.ANTI_ALIAS_FLAG);

    /** Audio peak of the latest block (set from the audio thread). */
    public volatile int audioAmplitude = 0;
    /** The received audio's spectrum (left = low notes), set by the intercom; null = fall back to the level. */
    public volatile float[] spectrum;
    /** Captions visible: draw the VU bars as a thin strip so the transcription box can sit low without being drawn through. */
    public volatile boolean barsCompact = false;
    public volatile boolean isReceiving = false;
    /** Animate the drops on a quiet channel too (on by default). */
    public volatile boolean animateIdle = true;

    // panel frame
    private volatile int fill = 0xFF0B1722, border = 0x5900E5FF, outside = 0xFF0A1520;
    private volatile float radiusDp = 12, borderDp = 2;

    private final float dp;
    private final SurfaceView surface;
    private final StaticLayer overlay;
    private volatile boolean running;
    private Thread renderer;
    private volatile int w, h, bufW, bufH;
    /** The moving layer is rendered at half resolution and scaled up by the compositor: a quarter of the pixels per frame. */
    private static final float RES = 0.5f;

    @Override protected void onSizeChanged(int nw, int nh, int ow, int oh) {
        super.onSizeChanged(nw, nh, ow, oh);
        if (nw > 0 && nh > 0) surface.getHolder().setFixedSize(Math.max(1, Math.round(nw * RES)), Math.max(1, Math.round(nh * RES)));
    }

    public CircuitBoardView(Context context) {
        super(context);
        dp = context.getResources().getDisplayMetrics().density;
        barPaint.setStyle(Paint.Style.FILL);
        dropPaint.setStyle(Paint.Style.STROKE); dropPaint.setStrokeWidth(1.8f); dropPaint.setStrokeCap(Paint.Cap.ROUND);
        surface = new SurfaceView(context);
        surface.getHolder().setFormat(PixelFormat.OPAQUE);
        surface.getHolder().addCallback(new SurfaceHolder.Callback() {
            @Override public void surfaceCreated(SurfaceHolder holder) { }
            @Override public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
                stop(); bufW = width; bufH = height; w = getWidth(); h = getHeight(); if (w <= 0 || h <= 0) { w = width * 2; h = height * 2; } initDrops();
                running = true; renderer = new Thread(CircuitBoardView.this::loop, "panel-render"); renderer.start();
            }
            @Override public void surfaceDestroyed(SurfaceHolder holder) { stop(); }
        });
        overlay = new StaticLayer(context);
        addView(surface, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
        addView(overlay, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
    }

    /**
     * The panel's frame: fill colour (opaque: what the page plus the panel tint look like), border colour and width,
     * corner radius, and the page colour around the panel (shown in the rounded corners).
     */
    public void setFrame(int fill, int border, float borderDp, float radiusDp, int outside) {
        this.fill = fill | 0xFF000000; this.border = border; this.borderDp = borderDp; this.radiusDp = radiusDp; this.outside = outside | 0xFF000000;
        overlay.rebuild();
    }

    private void stop() {
        running = false;
        Thread t = renderer; renderer = null;
        if (t != null) { t.interrupt(); try { t.join(300); } catch (InterruptedException ignored) { } }
    }

    private void loop() {
        SurfaceHolder holder = surface.getHolder();
        boolean idleFrameDrawn = false;
        while (running) {
            long start = System.nanoTime();
            boolean active = isReceiving || !barsSettled(), animate = active || animateIdle;
            long frameMs = active ? 50 : 100;   // quiet channel: 10 fps for the slow drops
            tick(animate, frameMs / 50f);
            if (animate || !idleFrameDrawn) {
                Canvas c = null;
                try { c = holder.lockHardwareCanvas(); if (c != null) drawFrame(c); }   // GPU, half-resolution buffer: measured cheapest (software full-res 19 %, hardware full-res 15 %)
                catch (Throwable ignored) { }
                finally { if (c != null) try { holder.unlockCanvasAndPost(c); } catch (Throwable ignored) { } }
                idleFrameDrawn = !animate;
            }
            long sleep = frameMs - (System.nanoTime() - start) / 1_000_000;
            try { Thread.sleep(Math.max(5, sleep)); } catch (InterruptedException e) { return; }
        }
    }

    private void initDrops() {
        for (int i = 0; i < NUM_DROPS; i++) {
            dropX[i] = dropLane(); dropY[i] = rng.nextFloat() * Math.max(1, h);
            dropSpeed[i] = 1.5f + rng.nextFloat() * 3.5f; dropLength[i] = 40f + rng.nextFloat() * 80f;
        }
    }

    /** A column for a drop, away from the rounded corners and the border. */
    private float dropLane() { float m = (radiusDp + borderDp + 2) * dp; return m + rng.nextFloat() * Math.max(1, w - 2 * m); }

    private boolean barsSettled() { for (float b : barHeights) if (b > 0.004f) return false; return true; }

    /** {@code scale}: frame time relative to the original 50 ms, so the drops keep the same speed at any frame rate. */
    private void tick(boolean moveDrops, float scale) {
        if (moveDrops) for (int i = 0; i < NUM_DROPS; i++) {
            dropY[i] += dropSpeed[i] * scale;
            if (dropY[i] - dropLength[i] > h) {
                dropY[i] = -dropLength[i] * rng.nextFloat(); dropX[i] = dropLane();
                dropSpeed[i] = 1.5f + rng.nextFloat() * 3.5f; dropLength[i] = 40f + rng.nextFloat() * 80f;
            }
        }
        // VU bars: sqrt curve for low-end sensitivity; they decay to idle when nothing is received
        float norm = isReceiving ? (float) Math.sqrt(Math.min(1.0f, audioAmplitude / 3000.0f)) : 0f;
        float[] sp = spectrum;
        for (int i = 0; i < NUM_BARS; i++) {
            float target;
            if (sp != null && sp.length == NUM_BARS) target = isReceiving ? sp[i] : 0f;                 // the real spectrum: one bar per band
            else { float center = NUM_BARS / 2.0f, dist = Math.abs(i - center) / center, env = 1.0f - dist * 0.55f; target = norm * env * (0.60f + rng.nextFloat() * 0.80f); }
            barHeights[i] += (target > barHeights[i]) ? (target - barHeights[i]) * 0.55f : (target - barHeights[i]) * 0.12f;
        }
    }

    /** The moving layer: fill, drops, bars. Traces, border and corners lie on top in {@link StaticLayer}. */
    private void drawFrame(Canvas canvas) {
        canvas.drawColor(fill);
        if (w > 0 && h > 0) canvas.scale(bufW / (float) w, bufH / (float) h);   // geometry in view pixels, buffer at half size
        float lo = borderDp * dp + 1, hi = h - borderDp * dp - 1;
        for (int i = 0; i < NUM_DROPS; i++) {
            float x = dropX[i], headY = dropY[i], len = dropLength[i]; int segs = 5; float segLen = len / segs;
            for (int s = 0; s < segs; s++) {
                float y0 = headY - len + s * segLen, y1 = y0 + segLen;
                if (y1 <= lo || y0 >= hi) continue; if (y0 < lo) y0 = lo; if (y1 > hi) y1 = hi;
                dropPaint.setColor(((int) (0x10 + ((float) (s + 1) / segs) * 0x60) << 24) | 0x0000E5FF);
                canvas.drawLine(x, y0, x, y1, dropPaint);
            }
        }
        float reserveH = (barsCompact ? 10 : 36) * dp, areaTop = h - reserveH - 4 * dp;
        float barZone = (h - areaTop) * (barsCompact ? 1.0f : 1.5625f), margin = 14 * dp, barW = (w - margin * 2) / NUM_BARS, gap = barW * 0.18f;
        for (int i = 0; i < NUM_BARS; i++) {
            float bh = Math.max(3 * dp, barHeights[i] * barZone);
            float x1 = margin + i * barW + gap, x2 = x1 + barW - gap * 2;
            barPaint.setColor(((int) (0x38 + barHeights[i] * 0xC0) << 24) | 0x0000E5FF);
            canvas.drawRoundRect(x1, areaTop + barZone - bh, x2, areaTop + barZone, 2 * dp, 2 * dp, barPaint);
        }
    }

    /** What never moves: page colour in the rounded corners, circuit traces and nodes, border. Cached in a bitmap. */
    private final class StaticLayer extends View {
        private final Paint trace = new Paint(Paint.ANTI_ALIAS_FLAG), node = new Paint(Paint.ANTI_ALIAS_FLAG), edge = new Paint(Paint.ANTI_ALIAS_FLAG), corner = new Paint(Paint.ANTI_ALIAS_FLAG);
        private Bitmap cache;
        StaticLayer(Context c) {
            super(c);
            trace.setStyle(Paint.Style.STROKE); trace.setStrokeWidth(1.2f); trace.setColor(0x1800E5FF);
            node.setStyle(Paint.Style.FILL); node.setColor(0x3000E5FF);
            edge.setStyle(Paint.Style.STROKE); corner.setStyle(Paint.Style.FILL);
        }
        void rebuild() { if (cache != null) { cache.recycle(); cache = null; } invalidate(); }
        @Override protected void onSizeChanged(int nw, int nh, int ow, int oh) { rebuild(); }
        @Override protected void onDraw(Canvas canvas) {
            int vw = getWidth(), vh = getHeight(); if (vw <= 0 || vh <= 0) return;
            if (cache == null || cache.getWidth() != vw || cache.getHeight() != vh) {
                cache = Bitmap.createBitmap(vw, vh, Bitmap.Config.ARGB_8888);
                Canvas c = new Canvas(cache);
                float r = radiusDp * dp, half = borderDp * dp / 2f;
                RectF box = new RectF(half, half, vw - half, vh - half);
                // page colour outside the rounded rectangle
                Path out = new Path(); out.setFillType(Path.FillType.EVEN_ODD); out.addRect(0, 0, vw, vh, Path.Direction.CW); out.addRoundRect(box, r, r, Path.Direction.CW);
                corner.setColor(outside); c.drawPath(out, corner);
                c.save(); Path in = new Path(); in.addRoundRect(box, r, r, Path.Direction.CW); c.clipPath(in);
                float spacing = 38 * dp; int cols = (int) (vw / spacing) + 2, rows = (int) (vh / spacing) + 2;
                for (int ro = 0; ro < rows; ro++) { float y = ro * spacing, xOff = (ro % 2 == 1) ? spacing * 0.5f : 0f; for (int co = 0; co < cols - 1; co++) { if ((co * 2 + ro * 3) % 5 == 0) continue; float x1 = co * spacing + xOff; c.drawLine(x1, y, x1 + spacing, y, trace); } }
                for (int co = 0; co < cols; co++) { float x = co * spacing; for (int ro = 0; ro < rows - 1; ro++) { if ((co * 3 + ro * 2) % 7 != 0) continue; float y1 = ro * spacing; c.drawLine(x, y1, x, y1 + spacing, trace); } }
                for (int ro = 0; ro < rows; ro++) for (int co = 0; co < cols; co++) { if ((ro * 7 + co * 11) % 17 != 0) continue; float x = co * spacing, y = ro * spacing, arm = spacing * 0.35f; c.drawLine(x, y, x + arm, y, trace); c.drawLine(x + arm, y, x + arm, y + arm, trace); }
                float nodeR = 2.5f * dp;
                for (int ro = 0; ro < rows; ro++) for (int co = 0; co < cols; co++) { if ((ro + co) % 6 != 0) continue; c.drawCircle(co * spacing, ro * spacing, nodeR, node); }
                c.restore();
                if (borderDp > 0) { edge.setColor(border); edge.setStrokeWidth(borderDp * dp); c.drawRoundRect(box, r, r, edge); }
            }
            canvas.drawBitmap(cache, 0, 0, null);
        }
    }
}
