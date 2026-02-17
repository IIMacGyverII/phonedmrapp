package com.pri.anim.spring;

import android.content.Context;
import android.util.Log;
import android.view.animation.Interpolator;

public class SpringOverScroller implements SpringListener, IOverScroller {
    public static final SpringConfig COASTING_CONFIG = SpringConfig.fromOrigamiTensionAndFriction(0.0d, 0.5d);
    private static final boolean DBG = true;
    public static final SpringConfig RUBBERBANDING_CONFIG = SpringConfig.fromOrigamiTensionAndFriction(2259.0d, 312.0d);
    private static final String TAG = "SpringOverScroller";
    private SpringConfig mFlingSpringCfg;
    private SpringConfig mSpringBackSpringCfg;
    private final SpringSystem mSpringSystem;
    private final Spring mSpringX;
    private final Spring mSpringY;

    public void onSpringActivate(Spring spring) {
    }

    public void onSpringAtRest(Spring spring) {
    }

    public void onSpringEndStateChange(Spring spring) {
    }

    public void onSpringUpdate(Spring spring) {
    }

    public SpringOverScroller(Context context) {
        this(context, (Interpolator) null);
    }

    public SpringOverScroller(Context context, Interpolator interpolator) {
        this(context, interpolator, true);
    }

    public SpringOverScroller(Context context, Interpolator interpolator, float f, float f2) {
        this(context, interpolator, true);
    }

    public SpringOverScroller(Context context, Interpolator interpolator, float f, float f2, boolean z) {
        this(context, interpolator, z);
    }

    public SpringOverScroller(Context context, Interpolator interpolator, boolean z) {
        SpringSystem create = SpringSystem.create();
        this.mSpringSystem = create;
        this.mSpringX = create.createSpring().addListener(this);
        this.mSpringY = create.createSpring().addListener(this);
    }

    public void setFlingConfig(SpringConfig springConfig) {
        this.mFlingSpringCfg = springConfig;
    }

    public void setSpringBackConfig(SpringConfig springConfig) {
        this.mSpringBackSpringCfg = springConfig;
    }

    public final boolean isFinished() {
        return this.mSpringX.isAtRest() && this.mSpringY.isAtRest();
    }

    public final int getCurrX() {
        return (int) Math.round(this.mSpringX.getCurrentValue());
    }

    public final int getCurrY() {
        return (int) Math.round(this.mSpringY.getCurrentValue());
    }

    public float getCurrVelocity() {
        double velocity = this.mSpringX.getVelocity();
        double velocity2 = this.mSpringY.getVelocity();
        return (float) ((int) Math.sqrt((velocity * velocity) + (velocity2 * velocity2)));
    }

    public final int getStartX() {
        return (int) Math.round(this.mSpringX.getStartValue());
    }

    public final int getStartY() {
        return (int) Math.round(this.mSpringY.getStartValue());
    }

    public final int getFinalX() {
        return (int) Math.round(this.mSpringX.getEndValue());
    }

    public final int getFinalY() {
        return (int) Math.round(this.mSpringY.getEndValue());
    }

    public boolean computeScrollOffset() {
        return !this.mSpringX.isAtRest() || !this.mSpringY.isAtRest();
    }

    public void startScroll(int i, int i2, int i3, int i4) {
        startScroll(i, i2, i3, i4, 0);
    }

    public void startScroll(int i, int i2, int i3, int i4, int i5) {
        this.mSpringX.setCurrentValue((double) i).setEndValue((double) i3);
        this.mSpringY.setCurrentValue((double) i2).setEndValue((double) i4);
    }

    public boolean springBack(int i, int i2, int i3, int i4, int i5, int i6) {
        SpringConfig springConfig = this.mSpringBackSpringCfg;
        if (springConfig == null) {
            springConfig = RUBBERBANDING_CONFIG;
        }
        Log.w(TAG, "springBack: startY=" + i2 + ", minY=" + i5 + ", maxY=" + i6 + ", tension=" + springConfig.tension + ", friction=" + springConfig.friction);
        double d = (double) i;
        this.mSpringX.setCurrentValue(d, false);
        double d2 = (double) i2;
        this.mSpringY.setCurrentValue(d2, false);
        if (i > i4 || i < i3) {
            if (i > i4) {
                this.mSpringX.setEndValue((double) i4);
            } else if (i < i3) {
                this.mSpringX.setEndValue((double) i3);
            }
            this.mSpringX.setSpringConfig(springConfig);
            return true;
        } else if (i2 > i6 || i2 < i5) {
            if (i2 > i6) {
                this.mSpringY.setEndValue((double) i6);
            } else if (i2 < i5) {
                this.mSpringY.setEndValue((double) i5);
            }
            this.mSpringY.setSpringConfig(springConfig);
            return true;
        } else {
            this.mSpringX.setEndValue(d);
            this.mSpringY.setEndValue(d2);
            return true;
        }
    }

    public void fling(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
        fling(i, i2, i3, i4, i5, i6, i7, i8, 0, 0);
    }

    public void fling(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10) {
        SpringConfig springConfig = this.mFlingSpringCfg;
        if (springConfig == null) {
            springConfig = COASTING_CONFIG;
        }
        Log.w(TAG, "fling: startY=" + i2 + ", velY=" + i4 + ", minY=" + i7 + ", maxY=" + i8 + ", overY=" + i10 + ", tension=" + springConfig.tension + ", friction=" + springConfig.friction);
        this.mSpringX.setSpringConfig(springConfig).setCurrentValue((double) i).setVelocity((double) i3);
        this.mSpringY.setSpringConfig(springConfig).setCurrentValue((double) i2).setVelocity((double) i4);
    }

    public void abortAnimation() {
        this.mSpringX.setAtRest();
        this.mSpringY.setAtRest();
    }
}
