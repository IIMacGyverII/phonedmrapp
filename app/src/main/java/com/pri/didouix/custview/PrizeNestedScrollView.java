package com.pri.didouix.custview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.widget.NestedScrollView;
import com.pri.didouix.util.PrizeNestedScrollLog;
/* loaded from: classes4.dex */
public class PrizeNestedScrollView extends NestedScrollView {
    private static final String TAG = "PrizeNestedScrollView";
    private boolean mSuperMotionEvent;

    public PrizeNestedScrollView(@NonNull Context context) {
        super(context, null);
    }

    public PrizeNestedScrollView(@NonNull Context context, @Nullable AttributeSet attributeSet) {
        super(context, attributeSet, 0);
    }

    public PrizeNestedScrollView(@NonNull Context context, @Nullable AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
    }

    public void setSuperMotionEvent(boolean z) {
        this.mSuperMotionEvent = z;
    }

    @Override // androidx.core.widget.NestedScrollView, android.view.ViewGroup
    protected void measureChildWithMargins(View view, int i, int i2, int i3, int i4) {
        view.measure(i, i3);
    }

    @Override // androidx.core.widget.NestedScrollView, android.view.ViewGroup
    public boolean onInterceptTouchEvent(MotionEvent motionEvent) {
        int action = motionEvent.getAction();
        boolean onInterceptTouchEvent = super.onInterceptTouchEvent(motionEvent);
        PrizeNestedScrollLog.d(TAG, "onInterceptTouchEvent: " + onInterceptTouchEvent + " action: " + action);
        if (action == 0) {
            return false;
        }
        if (action != 2) {
            if (this.mSuperMotionEvent) {
                return onInterceptTouchEvent;
            }
            return false;
        } else if (this.mSuperMotionEvent) {
            PrizeNestedScrollLog.d(TAG, "return super onInterceptTouchEvent");
            return onInterceptTouchEvent;
        } else {
            return false;
        }
    }
}
