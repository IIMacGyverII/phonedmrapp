package androidx.core.graphics.drawable;

import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

final class WrappedDrawableState extends Drawable.ConstantState {
    int mChangingConfigurations;
    Drawable.ConstantState mDrawableState;
    ColorStateList mTint = null;
    PorterDuff.Mode mTintMode = WrappedDrawableApi14.DEFAULT_TINT_MODE;

    WrappedDrawableState(@Nullable WrappedDrawableState wrappedDrawableState) {
        if (wrappedDrawableState != null) {
            this.mChangingConfigurations = wrappedDrawableState.mChangingConfigurations;
            this.mDrawableState = wrappedDrawableState.mDrawableState;
            this.mTint = wrappedDrawableState.mTint;
            this.mTintMode = wrappedDrawableState.mTintMode;
        }
    }

    @NonNull
    public Drawable newDrawable() {
        return newDrawable((Resources) null);
    }

    @NonNull
    public Drawable newDrawable(@Nullable Resources resources) {
        return new WrappedDrawableApi21(this, resources);
    }

    public int getChangingConfigurations() {
        int i = this.mChangingConfigurations;
        Drawable.ConstantState constantState = this.mDrawableState;
        return (constantState != null ? constantState.getChangingConfigurations() : 0) | i;
    }

    /* access modifiers changed from: package-private */
    public boolean canConstantState() {
        return this.mDrawableState != null;
    }
}
