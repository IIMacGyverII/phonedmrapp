package com.google.android.material.ripple;

import android.content.res.ColorStateList;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import androidx.annotation.ColorInt;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import androidx.core.graphics.drawable.TintAwareDrawable;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.ShapeAppearanceModel;
import com.google.android.material.shape.Shapeable;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
public class RippleDrawableCompat extends Drawable implements Shapeable, TintAwareDrawable {
    private RippleDrawableCompatState drawableState;

    public boolean isStateful() {
        return true;
    }

    public RippleDrawableCompat(ShapeAppearanceModel shapeAppearanceModel) {
        this(new RippleDrawableCompatState(new MaterialShapeDrawable(shapeAppearanceModel)));
    }

    private RippleDrawableCompat(RippleDrawableCompatState rippleDrawableCompatState) {
        this.drawableState = rippleDrawableCompatState;
    }

    public void setTint(@ColorInt int i) {
        this.drawableState.delegate.setTint(i);
    }

    public void setTintMode(@Nullable PorterDuff.Mode mode) {
        this.drawableState.delegate.setTintMode(mode);
    }

    public void setTintList(@Nullable ColorStateList colorStateList) {
        this.drawableState.delegate.setTintList(colorStateList);
    }

    public void setShapeAppearanceModel(@NonNull ShapeAppearanceModel shapeAppearanceModel) {
        this.drawableState.delegate.setShapeAppearanceModel(shapeAppearanceModel);
    }

    @NonNull
    public ShapeAppearanceModel getShapeAppearanceModel() {
        return this.drawableState.delegate.getShapeAppearanceModel();
    }

    /* access modifiers changed from: protected */
    public boolean onStateChange(@NonNull int[] iArr) {
        boolean onStateChange = super.onStateChange(iArr);
        if (this.drawableState.delegate.setState(iArr)) {
            onStateChange = true;
        }
        boolean shouldDrawRippleCompat = RippleUtils.shouldDrawRippleCompat(iArr);
        RippleDrawableCompatState rippleDrawableCompatState = this.drawableState;
        if (rippleDrawableCompatState.shouldDrawDelegate == shouldDrawRippleCompat) {
            return onStateChange;
        }
        rippleDrawableCompatState.shouldDrawDelegate = shouldDrawRippleCompat;
        return true;
    }

    public void draw(Canvas canvas) {
        RippleDrawableCompatState rippleDrawableCompatState = this.drawableState;
        if (rippleDrawableCompatState.shouldDrawDelegate) {
            rippleDrawableCompatState.delegate.draw(canvas);
        }
    }

    /* access modifiers changed from: protected */
    public void onBoundsChange(@NonNull Rect rect) {
        super.onBoundsChange(rect);
        this.drawableState.delegate.setBounds(rect);
    }

    @Nullable
    public Drawable.ConstantState getConstantState() {
        return this.drawableState;
    }

    @NonNull
    public RippleDrawableCompat mutate() {
        this.drawableState = new RippleDrawableCompatState(this.drawableState);
        return this;
    }

    public void setAlpha(int i) {
        this.drawableState.delegate.setAlpha(i);
    }

    public void setColorFilter(@Nullable ColorFilter colorFilter) {
        this.drawableState.delegate.setColorFilter(colorFilter);
    }

    public int getOpacity() {
        return this.drawableState.delegate.getOpacity();
    }

    static final class RippleDrawableCompatState extends Drawable.ConstantState {
        @NonNull
        MaterialShapeDrawable delegate;
        boolean shouldDrawDelegate;

        public int getChangingConfigurations() {
            return 0;
        }

        public RippleDrawableCompatState(MaterialShapeDrawable materialShapeDrawable) {
            this.delegate = materialShapeDrawable;
            this.shouldDrawDelegate = false;
        }

        public RippleDrawableCompatState(@NonNull RippleDrawableCompatState rippleDrawableCompatState) {
            this.delegate = (MaterialShapeDrawable) rippleDrawableCompatState.delegate.getConstantState().newDrawable();
            this.shouldDrawDelegate = rippleDrawableCompatState.shouldDrawDelegate;
        }

        @NonNull
        public RippleDrawableCompat newDrawable() {
            return new RippleDrawableCompat(new RippleDrawableCompatState(this));
        }
    }
}
