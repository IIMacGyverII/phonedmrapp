package com.pri.anim.spring;

import android.view.animation.Interpolator;

public interface IOverScroller {
    void abortAnimation();

    boolean computeScrollOffset();

    void fling(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8);

    void fling(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10);

    float getCurrVelocity();

    int getCurrX();

    int getCurrY();

    boolean isFinished();

    boolean isScrollingInDirection(float f, float f2) {
        return false;
    }

    void notifyHorizontalEdgeReached(int i, int i2, int i3) {
    }

    void notifyVerticalEdgeReached(int i, int i2, int i3) {
    }

    void setFlingConfig(SpringConfig springConfig) {
    }

    void setFriction(float f) {
    }

    void setInterpolator(Interpolator interpolator) {
    }

    void setSpringBackConfig(SpringConfig springConfig) {
    }

    boolean springBack(int i, int i2, int i3, int i4, int i5, int i6);

    void startScroll(int i, int i2, int i3, int i4);

    void startScroll(int i, int i2, int i3, int i4, int i5);
}
