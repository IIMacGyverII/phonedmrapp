package com.pri.didouix.viewbehavior;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.Transformation;
import androidx.annotation.AnimRes;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import com.pri.R;
import com.pri.didouix.viewbehavior.PercentageViewBehavior;

public class AnimationViewBehavior extends PercentageViewBehavior<View> {
    private Animation mAnimation;
    private BehaviorAnimation mTransformAnimation;

    public AnimationViewBehavior(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.ViewBehavior);
        int resourceId = obtainStyledAttributes.getResourceId(R.styleable.ViewBehavior_behavior_animation, 0);
        obtainStyledAttributes.recycle();
        if (resourceId != 0) {
            this.mAnimation = AnimationUtils.loadAnimation(context, resourceId);
        }
    }

    private AnimationViewBehavior(Builder builder) {
        super(builder);
        this.mAnimation = builder.animation;
    }

    /* access modifiers changed from: package-private */
    public void prepare(CoordinatorLayout coordinatorLayout, View view, View view2) {
        super.prepare(coordinatorLayout, view, view2);
        Animation animation = this.mAnimation;
        if (animation != null) {
            animation.initialize(view.getWidth(), view.getHeight(), coordinatorLayout.getWidth(), coordinatorLayout.getHeight());
            this.mAnimation.setStartTime(0);
            this.mAnimation.setDuration(1000);
        }
    }

    /* access modifiers changed from: package-private */
    public void updateViewWithPercent(View view, float f) {
        super.updateViewWithPercent(view, f);
        if (this.mAnimation != null) {
            Transformation transformation = new Transformation();
            Animation animation = this.mAnimation;
            animation.getTransformation((long) (f * ((float) animation.getDuration())), transformation);
            if (this.mTransformAnimation == null) {
                this.mTransformAnimation = new BehaviorAnimation();
            }
            this.mTransformAnimation.setTransformation(transformation);
            view.setAnimation(this.mTransformAnimation);
        }
    }

    private static class BehaviorAnimation extends Animation {
        private Transformation mTransformation;

        BehaviorAnimation() {
            setDuration(0);
            setFillAfter(true);
        }

        /* access modifiers changed from: protected */
        public void applyTransformation(float f, Transformation transformation) {
            Transformation transformation2 = this.mTransformation;
            if (transformation2 != null) {
                transformation.compose(transformation2);
            }
            super.applyTransformation(f, transformation);
        }

        /* access modifiers changed from: package-private */
        public void setTransformation(Transformation transformation) {
            this.mTransformation = transformation;
        }
    }

    public static class Builder extends PercentageViewBehavior.Builder<Builder> {
        /* access modifiers changed from: private */
        public Animation animation;

        /* access modifiers changed from: package-private */
        public Builder getThis() {
            return this;
        }

        public Builder animation(Animation animation2) {
            this.animation = animation2;
            return this;
        }

        public Builder animationId(Context context, @AnimRes int i) {
            if (i != 0) {
                this.animation = AnimationUtils.loadAnimation(context, i);
            }
            return this;
        }

        public AnimationViewBehavior build() {
            return new AnimationViewBehavior(this);
        }
    }
}
