package com.pri.didouix.custview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.widget.NestedScrollView;
import com.pri.didouix.util.PrizeNestedScrollLog;

public class PrizeNestedScrollView extends NestedScrollView {
    private static final String TAG = "PrizeNestedScrollView";
    private boolean mSuperMotionEvent;

    public PrizeNestedScrollView(@NonNull Context context) {
        super(context, (AttributeSet) null);
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

    /* access modifiers changed from: protected */
    public void measureChildWithMargins(View view, int i, int i2, int i3, int i4) {
        view.measure(i, i3);
    }

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
        } else if (!this.mSuperMotionEvent) {
            return false;
        } else {
            PrizeNestedScrollLog.d(TAG, "return super onInterceptTouchEvent");
            return onInterceptTouchEvent;
        }
    }
}
