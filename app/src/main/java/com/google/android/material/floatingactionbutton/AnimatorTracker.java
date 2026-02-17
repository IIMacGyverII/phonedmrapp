package com.google.android.material.floatingactionbutton;

import android.animation.Animator;
import androidx.annotation.Nullable;

class AnimatorTracker {
    @Nullable
    private Animator currentAnimator;

    AnimatorTracker() {
    }

    public void onNextAnimationStart(Animator animator) {
        cancelCurrent();
        this.currentAnimator = animator;
    }

    public void cancelCurrent() {
        Animator animator = this.currentAnimator;
        if (animator != null) {
            animator.cancel();
        }
    }

    public void clear() {
        this.currentAnimator = null;
    }
}
