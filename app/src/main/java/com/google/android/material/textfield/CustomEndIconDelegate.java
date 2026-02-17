package com.google.android.material.textfield;

import android.view.View;
import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;

class CustomEndIconDelegate extends EndIconDelegate {
    CustomEndIconDelegate(@NonNull TextInputLayout textInputLayout, @DrawableRes int i) {
        super(textInputLayout, i);
    }

    /* access modifiers changed from: package-private */
    public void initialize() {
        this.textInputLayout.setEndIconDrawable(this.customEndIcon);
        this.textInputLayout.setEndIconOnClickListener((View.OnClickListener) null);
        this.textInputLayout.setEndIconOnLongClickListener((View.OnLongClickListener) null);
    }
}
