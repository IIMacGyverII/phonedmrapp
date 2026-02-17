package com.google.android.material.transition;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.animation.PropertyValuesHolder;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public final class ScaleProvider implements VisibilityAnimatorProvider {
    private boolean growing;
    private float incomingEndScale;
    private float incomingStartScale;
    private float outgoingEndScale;
    private float outgoingStartScale;
    private boolean scaleOnDisappear;

    public ScaleProvider() {
        this(true);
    }

    public ScaleProvider(boolean z) {
        this.outgoingStartScale = 1.0f;
        this.outgoingEndScale = 1.1f;
        this.incomingStartScale = 0.8f;
        this.incomingEndScale = 1.0f;
        this.scaleOnDisappear = true;
        this.growing = z;
    }

    public boolean isGrowing() {
        return this.growing;
    }

    public void setGrowing(boolean z) {
        this.growing = z;
    }

    public boolean isScaleOnDisappear() {
        return this.scaleOnDisappear;
    }

    public void setScaleOnDisappear(boolean z) {
        this.scaleOnDisappear = z;
    }

    public float getOutgoingStartScale() {
        return this.outgoingStartScale;
    }

    public void setOutgoingStartScale(float f) {
        this.outgoingStartScale = f;
    }

    public float getOutgoingEndScale() {
        return this.outgoingEndScale;
    }

    public void setOutgoingEndScale(float f) {
        this.outgoingEndScale = f;
    }

    public float getIncomingStartScale() {
        return this.incomingStartScale;
    }

    public void setIncomingStartScale(float f) {
        this.incomingStartScale = f;
    }

    public float getIncomingEndScale() {
        return this.incomingEndScale;
    }

    public void setIncomingEndScale(float f) {
        this.incomingEndScale = f;
    }

    @Nullable
    public Animator createAppear(@NonNull ViewGroup viewGroup, @NonNull View view) {
        if (this.growing) {
            return createScaleAnimator(view, this.incomingStartScale, this.incomingEndScale);
        }
        return createScaleAnimator(view, this.outgoingEndScale, this.outgoingStartScale);
    }

    @Nullable
    public Animator createDisappear(@NonNull ViewGroup viewGroup, @NonNull View view) {
        if (!this.scaleOnDisappear) {
            return null;
        }
        if (this.growing) {
            return createScaleAnimator(view, this.outgoingStartScale, this.outgoingEndScale);
        }
        return createScaleAnimator(view, this.incomingEndScale, this.incomingStartScale);
    }

    private static Animator createScaleAnimator(final View view, float f, float f2) {
        final float scaleX = view.getScaleX();
        final float scaleY = view.getScaleY();
        ObjectAnimator ofPropertyValuesHolder = ObjectAnimator.ofPropertyValuesHolder(view, new PropertyValuesHolder[]{PropertyValuesHolder.ofFloat(View.SCALE_X, new float[]{scaleX * f, scaleX * f2}), PropertyValuesHolder.ofFloat(View.SCALE_Y, new float[]{f * scaleY, f2 * scaleY})});
        ofPropertyValuesHolder.addListener(new AnimatorListenerAdapter() {
            public void onAnimationEnd(Animator animator) {
                view.setScaleX(scaleX);
                view.setScaleY(scaleY);
            }
        });
        return ofPropertyValuesHolder;
    }
}
