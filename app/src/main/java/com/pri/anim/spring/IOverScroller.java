package com.pri.anim.spring;

import android.view.animation.Interpolator;
/* loaded from: classes4.dex */
public interface IOverScroller {
    void abortAnimation();

    boolean computeScrollOffset();

    void fling(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8);

    void fling(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10);

    float getCurrVelocity();

    int getCurrX();

    int getCurrY();

    boolean isFinished();

    default boolean isScrollingInDirection(float f, float f2) {
        return false;
    }

    default void notifyHorizontalEdgeReached(int i, int i2, int i3) {
    }

    default void notifyVerticalEdgeReached(int i, int i2, int i3) {
    }

    default void setFlingConfig(SpringConfig springConfig) {
    }

    default void setFriction(float f) {
    }

    default void setInterpolator(Interpolator interpolator) {
    }

    default void setSpringBackConfig(SpringConfig springConfig) {
    }

    boolean springBack(int i, int i2, int i3, int i4, int i5, int i6);

    void startScroll(int i, int i2, int i3, int i4);

    void startScroll(int i, int i2, int i3, int i4, int i5);
}
