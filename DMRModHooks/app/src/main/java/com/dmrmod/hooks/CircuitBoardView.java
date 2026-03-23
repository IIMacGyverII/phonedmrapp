package com.dmrmod.hooks;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import java.util.Random;

/**
 * Animated sci-fi background view for the intercom content box.
 * Draws a circuit board pattern, falling cyan "drop" lines, and audio level bars.
 */
public class CircuitBoardView extends View {

    // ── Paint objects ─────────────────────────────────────────────────────────
    private final Paint tracePaint  = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint nodePaint   = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint barPaint    = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint dropPaint   = new Paint(Paint.ANTI_ALIAS_FLAG);

    // ── Drop ("Matrix rain") state ─────────────────────────────────────────
    private static final int NUM_DROPS = 10;
    private final float[] dropX      = new float[NUM_DROPS];
    private final float[] dropY      = new float[NUM_DROPS];
    private final float[] dropSpeed  = new float[NUM_DROPS];
    private final float[] dropLength = new float[NUM_DROPS];
    private final Random  rng        = new Random(0xDEAD);  // fixed seed → stable pattern

    // ── Audio bar state ─────────────────────────────────────────────────────
    private static final int NUM_BARS = 18;
    private final float[] barHeights = new float[NUM_BARS];  // smoothed display heights [0-1]

    // ── Public amplitude feed (updated from PCM hook thread-safely) ─────────
    public volatile int audioAmplitude = 0;
    public volatile boolean isReceiving = false;

    // ── Layout resolved flag ────────────────────────────────────────────────
    private float viewW = 0, viewH = 0;
    private boolean layoutDone = false;

    // ── Animation handler ───────────────────────────────────────────────────
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final Runnable animRunnable = new Runnable() {
        @Override
        public void run() {
            if (layoutDone) {
                tickAnimation();
                invalidate();
            }
            handler.postDelayed(this, 50);  // ~20 fps
        }
    };

    // ── Constructor ──────────────────────────────────────────────────────────
    public CircuitBoardView(Context context) {
        super(context);

        // Circuit trace lines – very subtle cyan
        tracePaint.setStyle(Paint.Style.STROKE);
        tracePaint.setStrokeWidth(1.2f);
        tracePaint.setColor(0x1800E5FF);   // cyan 9% opacity

        // Junction nodes
        nodePaint.setStyle(Paint.Style.FILL);
        nodePaint.setColor(0x3000E5FF);    // cyan 19% opacity

        // Audio bars
        barPaint.setStyle(Paint.Style.FILL);
        barPaint.setAntiAlias(true);

        // Falling drops
        dropPaint.setStyle(Paint.Style.STROKE);
        dropPaint.setStrokeWidth(1.8f);
        dropPaint.setAntiAlias(true);
        dropPaint.setStrokeCap(Paint.Cap.ROUND);
    }

    // ── Life-cycle ───────────────────────────────────────────────────────────
    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        handler.post(animRunnable);
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        handler.removeCallbacks(animRunnable);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        if (w > 0 && h > 0) {
            viewW = w;
            viewH = h;
            initDrops();
            layoutDone = true;
        }
    }

    // ── Initialisation ───────────────────────────────────────────────────────
    private void initDrops() {
        for (int i = 0; i < NUM_DROPS; i++) {
            dropX[i]      = rng.nextFloat() * viewW;
            dropY[i]      = rng.nextFloat() * viewH;
            dropSpeed[i]  = 1.5f + rng.nextFloat() * 3.5f;
            dropLength[i] = 40f + rng.nextFloat() * 80f;
        }
    }

    // ── Animation tick ────────────────────────────────────────────────────────
    private void tickAnimation() {
        // Advance drops
        for (int i = 0; i < NUM_DROPS; i++) {
            dropY[i] += dropSpeed[i];
            if (dropY[i] - dropLength[i] > viewH) {
                dropY[i]      = -dropLength[i] * rng.nextFloat();
                dropX[i]      = rng.nextFloat() * viewW;
                dropSpeed[i]  = 1.5f + rng.nextFloat() * 3.5f;
                dropLength[i] = 40f  + rng.nextFloat() * 80f;
            }
        }

        // Smooth audio bars
        // Normalize with sqrt curve for better low-end sensitivity (like a real VU meter).
        // Max ~3000 covers typical voice; sqrt expands quiet signals:
        //   RMS 200 → 26%, RMS 500 → 41%, RMS 1500 → 71%, RMS 3000+ → 100%
        // Only animate when actually receiving — zero out amplitude otherwise so bars decay to idle
        float norm;
        if (isReceiving) {
            float linear = Math.min(1.0f, audioAmplitude / 3000.0f);
            norm = (float) Math.sqrt(linear);
        } else {
            norm = 0.0f;
        }
        for (int i = 0; i < NUM_BARS; i++) {
            float center = NUM_BARS / 2.0f;
            float dist   = Math.abs(i - center) / center;        // 0 at centre, 1 at edge
            float env    = 1.0f - dist * 0.55f;                  // taller in middle
            float flutter = 0.60f + rng.nextFloat() * 0.80f;     // per-bar randomness
            float target  = norm * env * flutter;

            float attack  = 0.55f;
            float decay   = 0.12f;
            barHeights[i] += (target > barHeights[i])
                ? (target - barHeights[i]) * attack
                : (target - barHeights[i]) * decay;
        }
    }

    // ── Drawing ───────────────────────────────────────────────────────────────
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (!layoutDone) return;
        float dp = getResources().getDisplayMetrics().density;
        drawCircuitBoard(canvas, dp);
        drawDrops(canvas);
        drawAudioBars(canvas, dp);
    }

    /** Static circuit board trace pattern. */
    private void drawCircuitBoard(Canvas canvas, float dp) {
        float spacing = 38 * dp;
        int cols = (int)(viewW / spacing) + 2;
        int rows = (int)(viewH / spacing) + 2;

        // Horizontal traces
        for (int r = 0; r < rows; r++) {
            float y    = r * spacing;
            float xOff = (r % 2 == 1) ? spacing * 0.5f : 0f;
            for (int c = 0; c < cols - 1; c++) {
                if ((c * 2 + r * 3) % 5 == 0) continue;  // skip some for sparseness
                float x1 = c * spacing + xOff;
                float x2 = x1 + spacing;
                canvas.drawLine(x1, y, x2, y, tracePaint);
            }
        }

        // Vertical traces
        for (int c = 0; c < cols; c++) {
            float x = c * spacing;
            for (int r = 0; r < rows - 1; r++) {
                if ((c * 3 + r * 2) % 7 != 0) continue;
                float y1 = r * spacing;
                float y2 = y1 + spacing;
                canvas.drawLine(x, y1, x, y2, tracePaint);
            }
        }

        // L-bends
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if ((r * 7 + c * 11) % 17 != 0) continue;
                float x   = c * spacing;
                float y   = r * spacing;
                float arm = spacing * 0.35f;
                canvas.drawLine(x, y, x + arm, y,        tracePaint);
                canvas.drawLine(x + arm, y, x + arm, y + arm, tracePaint);
            }
        }

        // Nodes (junction dots)
        float nodeR = 2.5f * dp;
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if ((r + c) % 6 != 0) continue;
                float x = c * spacing;
                float y = r * spacing;
                canvas.drawCircle(x, y, nodeR, nodePaint);
            }
        }
    }

    /** Falling cyan drop lines. */
    private void drawDrops(Canvas canvas) {
        for (int i = 0; i < NUM_DROPS; i++) {
            float x       = dropX[i];
            float headY   = dropY[i];
            float len     = dropLength[i];
            int   segs    = 5;
            float segLen  = len / segs;

            for (int s = 0; s < segs; s++) {
                float y0 = headY - len + s * segLen;
                float y1 = y0 + segLen;
                // Alpha: dim at tail, bright at head
                int alpha  = (int)(0x10 + ((float)(s + 1) / segs) * 0x60);
                dropPaint.setColor((alpha << 24) | 0x0000E5FF);
                canvas.drawLine(x, y0, x, y1, dropPaint);
            }
        }
    }

    /** VU-meter bars along the bottom edge of the view. */
    private void drawAudioBars(Canvas canvas, float dp) {
        float reserveH = 36 * dp;
        float areaTop  = viewH - reserveH - 4 * dp;
        float barZone  = (viewH - areaTop) * 1.5625f;  // 56.25% taller max height (25% + 25%)
        float margin   = 14 * dp;
        float totalW   = viewW - margin * 2;
        float barW     = totalW / NUM_BARS;
        float gap      = barW * 0.18f;

        for (int i = 0; i < NUM_BARS; i++) {
            float bh = barHeights[i] * barZone;
            // Draw a minimum idle bar even at silence so bars are always visible
            float minH = 3 * dp;
            if (bh < minH) bh = minH;

            float x1   = margin + i * barW + gap;
            float x2   = x1 + barW - gap * 2;
            float top  = areaTop + barZone - bh;
            float bot  = areaTop + barZone;

            // Idle (min height) bars are dim; louder bars are bright
            float frac = barHeights[i];
            int alpha  = (int)(0x38 + frac * 0xC0);  // 0x38 idle, 0xF8 peak
            barPaint.setColor((alpha << 24) | 0x0000E5FF);
            canvas.drawRoundRect(x1, top, x2, bot, 2 * dp, 2 * dp, barPaint);
        }
    }
}
