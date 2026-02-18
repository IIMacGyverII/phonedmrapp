package com.pri.didouix.viewbehavior;

import android.animation.ArgbEvaluator;
import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import com.pri.R;
import com.pri.didouix.viewbehavior.PercentageViewBehavior;
/* loaded from: classes4.dex */
public class SimpleViewBehavior extends PercentageViewBehavior<View> {
    private float mStartAlpha;
    private int mStartBackgroundColor;
    private int mStartHeight;
    private float mStartRotateX;
    private float mStartRotateY;
    private int mStartWidth;
    private int mStartX;
    private int mStartY;
    private float targetAlpha;
    private int targetBackgroundColor;
    private int targetHeight;
    private float targetRotateX;
    private float targetRotateY;
    private int targetWidth;
    private int targetX;
    private int targetY;

    public SimpleViewBehavior(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.ViewBehavior);
        this.targetX = obtainStyledAttributes.getDimensionPixelOffset(R.styleable.ViewBehavior_behavior_targetX, Integer.MAX_VALUE);
        this.targetY = obtainStyledAttributes.getDimensionPixelOffset(R.styleable.ViewBehavior_behavior_targetY, Integer.MAX_VALUE);
        this.targetWidth = obtainStyledAttributes.getDimensionPixelOffset(R.styleable.ViewBehavior_behavior_targetWidth, Integer.MAX_VALUE);
        this.targetHeight = obtainStyledAttributes.getDimensionPixelOffset(R.styleable.ViewBehavior_behavior_targetHeight, Integer.MAX_VALUE);
        this.targetBackgroundColor = obtainStyledAttributes.getColor(R.styleable.ViewBehavior_behavior_targetBackgroundColor, Integer.MAX_VALUE);
        this.targetAlpha = obtainStyledAttributes.getFloat(R.styleable.ViewBehavior_behavior_targetAlpha, Float.MAX_VALUE);
        this.targetRotateX = obtainStyledAttributes.getFloat(R.styleable.ViewBehavior_behavior_targetRotateX, Float.MAX_VALUE);
        this.targetRotateY = obtainStyledAttributes.getFloat(R.styleable.ViewBehavior_behavior_targetRotateY, Float.MAX_VALUE);
        obtainStyledAttributes.recycle();
    }

    private SimpleViewBehavior(@NonNull Builder builder) {
        super(builder);
        this.targetX = builder.targetX;
        this.targetY = builder.targetY;
        this.targetWidth = builder.targetWidth;
        this.targetHeight = builder.targetHeight;
        this.targetBackgroundColor = builder.targetBackgroundColor;
        this.targetAlpha = builder.targetAlpha;
        this.targetRotateX = builder.targetRotateX;
        this.targetRotateY = builder.targetRotateY;
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    @Override // com.pri.didouix.viewbehavior.PercentageViewBehavior
    public void prepare(CoordinatorLayout coordinatorLayout, View view, View view2) {
        super.prepare(coordinatorLayout, view, view2);
        this.mStartX = (int) view.getX();
        this.mStartY = (int) view.getY();
        this.mStartWidth = view.getWidth();
        this.mStartHeight = view.getHeight();
        this.mStartAlpha = view.getAlpha();
        this.mStartRotateX = view.getRotationX();
        this.mStartRotateY = view.getRotationY();
        Drawable background = view.getBackground();
        if (background instanceof ColorDrawable) {
            this.mStartBackgroundColor = ((ColorDrawable) background).getColor();
        }
        if (!coordinatorLayout.getFitsSystemWindows() || this.targetY == Integer.MAX_VALUE) {
            return;
        }
        Resources resources = coordinatorLayout.getContext().getResources();
        int identifier = resources.getIdentifier("status_bar_height", "dimen", "android");
        this.targetY += identifier > 0 ? resources.getDimensionPixelSize(identifier) : 0;
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    @Override // com.pri.didouix.viewbehavior.PercentageViewBehavior
    public void updateViewWithPercent(View view, float f) {
        super.updateViewWithPercent(view, f);
        int i = this.targetX;
        float f2 = i == Integer.MAX_VALUE ? 0.0f : (i - this.mStartX) * f;
        int i2 = this.targetY;
        float f3 = i2 != Integer.MAX_VALUE ? (i2 - this.mStartY) * f : 0.0f;
        int i3 = this.targetWidth;
        if (i3 != Integer.MAX_VALUE || this.targetHeight != Integer.MAX_VALUE) {
            int i4 = this.mStartWidth;
            float f4 = i4 + ((i3 - i4) * f);
            int i5 = this.mStartHeight;
            float f5 = i5 + ((this.targetHeight - i5) * f);
            view.setScaleX(f4 / i4);
            view.setScaleY(f5 / this.mStartHeight);
            f2 -= (this.mStartWidth - f4) / 2.0f;
            f3 -= (this.mStartHeight - f5) / 2.0f;
        }
        view.setTranslationX(f2);
        view.setTranslationY(f3);
        float f6 = this.targetAlpha;
        if (f6 != Float.MAX_VALUE) {
            float f7 = this.mStartAlpha;
            view.setAlpha(f7 + ((f6 - f7) * f));
        }
        if (this.targetBackgroundColor != Integer.MAX_VALUE && this.mStartBackgroundColor != 0) {
            view.setBackgroundColor(((Integer) new ArgbEvaluator().evaluate(f, Integer.valueOf(this.mStartBackgroundColor), Integer.valueOf(this.targetBackgroundColor))).intValue());
        }
        float f8 = this.targetRotateX;
        if (f8 != Float.MAX_VALUE) {
            float f9 = this.mStartRotateX;
            view.setRotationX(f9 + ((f8 - f9) * f));
        }
        float f10 = this.targetRotateY;
        if (f10 != Float.MAX_VALUE) {
            float f11 = this.mStartRotateY;
            view.setRotationY(f11 + ((f10 - f11) * f));
        }
        view.requestLayout();
    }

    /* loaded from: classes4.dex */
    public static class Builder extends PercentageViewBehavior.Builder<Builder> {
        private int targetX = Integer.MAX_VALUE;
        private int targetY = Integer.MAX_VALUE;
        private int targetWidth = Integer.MAX_VALUE;
        private int targetHeight = Integer.MAX_VALUE;
        private int targetBackgroundColor = Integer.MAX_VALUE;
        private float targetAlpha = Float.MAX_VALUE;
        private float targetRotateX = Float.MAX_VALUE;
        private float targetRotateY = Float.MAX_VALUE;

        /* JADX INFO: Access modifiers changed from: package-private */
        @Override // com.pri.didouix.viewbehavior.PercentageViewBehavior.Builder
        public Builder getThis() {
            return this;
        }

        public Builder targetX(int i) {
            this.targetX = i;
            return this;
        }

        public Builder targetY(int i) {
            this.targetY = i;
            return this;
        }

        public Builder targetWidth(int i) {
            this.targetWidth = i;
            return this;
        }

        public Builder targetHeight(int i) {
            this.targetHeight = i;
            return this;
        }

        public Builder targetBackgroundColor(int i) {
            this.targetBackgroundColor = i;
            return this;
        }

        public Builder targetAlpha(int i) {
            this.targetAlpha = i;
            return this;
        }

        public Builder targetRotateX(int i) {
            this.targetRotateX = i;
            return this;
        }

        public Builder targetRotateY(int i) {
            this.targetRotateY = i;
            return this;
        }

        public SimpleViewBehavior build() {
            return new SimpleViewBehavior(this);
        }
    }
}
