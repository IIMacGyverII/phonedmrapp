package com.google.android.material.textfield;

import android.content.Context;
import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import com.google.android.material.internal.CheckableImageButton;

abstract class EndIconDelegate {
    Context context;
    @DrawableRes
    final int customEndIcon;
    CheckableImageButton endIconView;
    TextInputLayout textInputLayout;

    /* access modifiers changed from: package-private */
    public abstract void initialize();

    /* access modifiers changed from: package-private */
    public boolean isBoxBackgroundModeSupported(int i) {
        return true;
    }

    /* access modifiers changed from: package-private */
    public void onSuffixVisibilityChanged(boolean z) {
    }

    /* access modifiers changed from: package-private */
    public boolean shouldTintIconOnError() {
        return false;
    }

    EndIconDelegate(@NonNull TextInputLayout textInputLayout2, @DrawableRes int i) {
        this.textInputLayout = textInputLayout2;
        this.context = textInputLayout2.getContext();
        this.endIconView = textInputLayout2.getEndIconView();
        this.customEndIcon = i;
    }
}
