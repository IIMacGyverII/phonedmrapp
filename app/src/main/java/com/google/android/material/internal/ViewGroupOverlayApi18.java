package com.google.android.material.internal;

import android.graphics.drawable.Drawable;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroupOverlay;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

@RequiresApi(18)
class ViewGroupOverlayApi18 implements ViewGroupOverlayImpl {
    private final ViewGroupOverlay viewGroupOverlay;

    ViewGroupOverlayApi18(@NonNull ViewGroup viewGroup) {
        this.viewGroupOverlay = viewGroup.getOverlay();
    }

    public void add(@NonNull Drawable drawable) {
        this.viewGroupOverlay.add(drawable);
    }

    public void remove(@NonNull Drawable drawable) {
        this.viewGroupOverlay.remove(drawable);
    }

    public void add(@NonNull View view) {
        this.viewGroupOverlay.add(view);
    }

    public void remove(@NonNull View view) {
        this.viewGroupOverlay.remove(view);
    }
}
