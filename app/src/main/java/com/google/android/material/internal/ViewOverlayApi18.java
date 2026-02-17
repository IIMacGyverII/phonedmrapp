package com.google.android.material.internal;

import android.graphics.drawable.Drawable;
import android.view.View;
import android.view.ViewOverlay;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

@RequiresApi(18)
class ViewOverlayApi18 implements ViewOverlayImpl {
    private final ViewOverlay viewOverlay;

    ViewOverlayApi18(@NonNull View view) {
        this.viewOverlay = view.getOverlay();
    }

    public void add(@NonNull Drawable drawable) {
        this.viewOverlay.add(drawable);
    }

    public void remove(@NonNull Drawable drawable) {
        this.viewOverlay.remove(drawable);
    }
}
