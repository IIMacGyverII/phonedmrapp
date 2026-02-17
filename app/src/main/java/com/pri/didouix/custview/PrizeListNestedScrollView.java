package com.pri.didouix.custview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.widget.NestedScrollView;

public class PrizeListNestedScrollView extends NestedScrollView {
    public boolean onInterceptTouchEvent(MotionEvent motionEvent) {
        return false;
    }

    public PrizeListNestedScrollView(@NonNull Context context) {
        super(context, (AttributeSet) null);
    }

    public PrizeListNestedScrollView(@NonNull Context context, @Nullable AttributeSet attributeSet) {
        super(context, attributeSet, 0);
    }

    public PrizeListNestedScrollView(@NonNull Context context, @Nullable AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
    }

    /* access modifiers changed from: protected */
    public void measureChildWithMargins(View view, int i, int i2, int i3, int i4) {
        view.measure(i, i3);
    }
}
