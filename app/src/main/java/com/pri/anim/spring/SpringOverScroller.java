package com.pri.anim.spring;

import android.content.Context;
import android.util.Log;
import android.view.animation.Interpolator;
/* loaded from: classes4.dex */
public class SpringOverScroller implements SpringListener, IOverScroller {
    private static final boolean DBG = true;
    private static final String TAG = "SpringOverScroller";
    private SpringConfig mFlingSpringCfg;
    private SpringConfig mSpringBackSpringCfg;
    private final SpringSystem mSpringSystem;
    private final Spring mSpringX;
    private final Spring mSpringY;
    public static final SpringConfig COASTING_CONFIG = SpringConfig.fromOrigamiTensionAndFriction(0.0d, 0.5d);
    public static final SpringConfig RUBBERBANDING_CONFIG = SpringConfig.fromOrigamiTensionAndFriction(2259.0d, 312.0d);

    @Override // com.pri.anim.spring.SpringListener
    public void onSpringActivate(Spring spring) {
    }

    @Override // com.pri.anim.spring.SpringListener
    public void onSpringAtRest(Spring spring) {
    }

    @Override // com.pri.anim.spring.SpringListener
    public void onSpringEndStateChange(Spring spring) {
    }

    @Override // com.pri.anim.spring.SpringListener
    public void onSpringUpdate(Spring spring) {
    }

    public SpringOverScroller(Context context) {
        this(context, null);
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

    @Override // com.pri.anim.spring.IOverScroller
    public void setFlingConfig(SpringConfig springConfig) {
        this.mFlingSpringCfg = springConfig;
    }

    @Override // com.pri.anim.spring.IOverScroller
    public void setSpringBackConfig(SpringConfig springConfig) {
        this.mSpringBackSpringCfg = springConfig;
    }

    @Override // com.pri.anim.spring.IOverScroller
    public final boolean isFinished() {
        return this.mSpringX.isAtRest() && this.mSpringY.isAtRest();
    }

    @Override // com.pri.anim.spring.IOverScroller
    public final int getCurrX() {
        return (int) Math.round(this.mSpringX.getCurrentValue());
    }

    @Override // com.pri.anim.spring.IOverScroller
    public final int getCurrY() {
        return (int) Math.round(this.mSpringY.getCurrentValue());
    }

    @Override // com.pri.anim.spring.IOverScroller
    public float getCurrVelocity() {
        double velocity = this.mSpringX.getVelocity();
        double velocity2 = this.mSpringY.getVelocity();
        return (int) Math.sqrt((velocity * velocity) + (velocity2 * velocity2));
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

    @Override // com.pri.anim.spring.IOverScroller
    public boolean computeScrollOffset() {
        return (this.mSpringX.isAtRest() && this.mSpringY.isAtRest()) ? false : true;
    }

    @Override // com.pri.anim.spring.IOverScroller
    public void startScroll(int i, int i2, int i3, int i4) {
        startScroll(i, i2, i3, i4, 0);
    }

    @Override // com.pri.anim.spring.IOverScroller
    public void startScroll(int i, int i2, int i3, int i4, int i5) {
        this.mSpringX.setCurrentValue(i).setEndValue(i3);
        this.mSpringY.setCurrentValue(i2).setEndValue(i4);
    }

    @Override // com.pri.anim.spring.IOverScroller
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
                this.mSpringX.setEndValue(i4);
            } else if (i < i3) {
                this.mSpringX.setEndValue(i3);
            }
            this.mSpringX.setSpringConfig(springConfig);
            return true;
        } else if (i2 > i6 || i2 < i5) {
            if (i2 > i6) {
                this.mSpringY.setEndValue(i6);
            } else if (i2 < i5) {
                this.mSpringY.setEndValue(i5);
            }
            this.mSpringY.setSpringConfig(springConfig);
            return true;
        } else {
            this.mSpringX.setEndValue(d);
            this.mSpringY.setEndValue(d2);
            return true;
        }
    }

    @Override // com.pri.anim.spring.IOverScroller
    public void fling(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
        fling(i, i2, i3, i4, i5, i6, i7, i8, 0, 0);
    }

    @Override // com.pri.anim.spring.IOverScroller
    public void fling(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10) {
        SpringConfig springConfig = this.mFlingSpringCfg;
        if (springConfig == null) {
            springConfig = COASTING_CONFIG;
        }
        Log.w(TAG, "fling: startY=" + i2 + ", velY=" + i4 + ", minY=" + i7 + ", maxY=" + i8 + ", overY=" + i10 + ", tension=" + springConfig.tension + ", friction=" + springConfig.friction);
        this.mSpringX.setSpringConfig(springConfig).setCurrentValue((double) i).setVelocity((double) i3);
        this.mSpringY.setSpringConfig(springConfig).setCurrentValue((double) i2).setVelocity((double) i4);
    }

    @Override // com.pri.anim.spring.IOverScroller
    public void abortAnimation() {
        this.mSpringX.setAtRest();
        this.mSpringY.setAtRest();
    }
}
