package com.pri.didouix.nestedheader.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.os.SystemClock;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.view.NestedScrollingChild3;
import androidx.core.view.NestedScrollingChildHelper;
import androidx.core.view.NestedScrollingParent3;
import androidx.core.view.NestedScrollingParentHelper;
import com.pri.R;
import com.pri.didouix.util.PrizeNestedScrollLog;
import java.util.ArrayList;
import java.util.List;

public class NestedScrollingLayout extends FrameLayout implements NestedScrollingParent3, NestedScrollingChild3 {
    private static final String TAG = "NestedScrollingLayout";
    private boolean isFirstsetScrollingRange;
    private boolean isHeaderOpen;
    private long mHeaderOpenTime;
    private boolean mHeaderViewVisible;
    private boolean mNestedFlingInConsumedProgress;
    private long mNestedFlingStartInConsumedTime;
    private boolean mNestedScrollAcceptedFling;
    private boolean mNestedScrollInConsumedProgress;
    private final NestedScrollingChildHelper mNestedScrollingChildHelper;
    private final NestedScrollingParentHelper mNestedScrollingParentHelper;
    private final int[] mNestedScrollingV2ConsumedCompat;
    private List<OnNestedChangedListener> mOnNestedChangedListeners;
    private final int[] mParentOffsetInWindow;
    private final int[] mParentScrollConsumed;
    protected View mScrollableView;
    private int mScrollableViewId;
    private int mScrollingFrom;
    private int mScrollingProgress;
    private int mScrollingTo;
    private boolean mTriggerViewVisible;

    public interface OnNestedChangedListener {
        void onStartNestedScroll(int i);

        void onStopNestedScroll(int i);

        void onStopNestedScrollAccepted(int i);
    }

    public void onScrollingProgressUpdated(int i) {
    }

    public NestedScrollingLayout(Context context) {
        this(context, (AttributeSet) null);
    }

    public NestedScrollingLayout(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public NestedScrollingLayout(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.mNestedScrollingV2ConsumedCompat = new int[2];
        this.mParentOffsetInWindow = new int[2];
        this.mParentScrollConsumed = new int[2];
        this.isFirstsetScrollingRange = true;
        this.mHeaderOpenTime = 0;
        this.mNestedFlingStartInConsumedTime = 0;
        this.isHeaderOpen = false;
        this.mHeaderViewVisible = false;
        this.mTriggerViewVisible = false;
        this.mOnNestedChangedListeners = new ArrayList();
        this.mNestedScrollingParentHelper = new NestedScrollingParentHelper(this);
        this.mNestedScrollingChildHelper = com.pri.didouix.core.view.NestedScrollingChildHelper.obtain(this);
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.NestedScrollingLayout);
        this.mScrollableViewId = obtainStyledAttributes.getResourceId(R.styleable.NestedScrollingLayout_scrollableView, 16908298);
        obtainStyledAttributes.recycle();
        setNestedScrollingEnabled(true);
    }

    @RequiresApi(api = 21)
    public void onFinishInflate() {
        super.onFinishInflate();
        View findViewById = findViewById(this.mScrollableViewId);
        this.mScrollableView = findViewById;
        if (findViewById != null) {
            findViewById.setNestedScrollingEnabled(true);
            return;
        }
        throw new IllegalArgumentException("The scrollableView attribute is required and must refer to a valid child.");
    }

    public void onLayout(boolean z, int i, int i2, int i3, int i4) {
        super.onLayout(z, i, i2, i3, i4);
        dispatchScrollingProgressUpdated();
    }

    public void setScrollingRange(int i, int i2, boolean z, boolean z2, boolean z3, boolean z4, boolean z5) {
        if (i > i2) {
            Log.w(TAG, "wrong scrolling range: [%d, %d], making from=to");
            i = i2;
        }
        this.mScrollingFrom = i;
        this.mScrollingTo = i2;
        this.mHeaderViewVisible = z;
        this.mTriggerViewVisible = z2;
        if (this.mScrollingProgress < i) {
            this.mScrollingProgress = i;
        }
        if (this.mScrollingProgress > i2) {
            this.mScrollingProgress = i2;
        }
        if (((z3 && this.isFirstsetScrollingRange) || z4 || z5) && z) {
            this.mScrollingProgress = 0;
            this.isFirstsetScrollingRange = false;
        } else if ((z3 && this.isFirstsetScrollingRange) || z4) {
            this.mScrollingProgress = i;
            this.isFirstsetScrollingRange = false;
        }
        dispatchScrollingProgressUpdated();
    }

    public void updateScrollingProgress(int i) {
        this.mScrollingProgress = i;
    }

    public void updateHeaderOpen(boolean z) {
        if (!this.isHeaderOpen && z) {
            this.mHeaderOpenTime = SystemClock.elapsedRealtime();
        }
        this.isHeaderOpen = z;
    }

    public int getScrollingProgress() {
        return this.mScrollingProgress;
    }

    private void dispatchScrollingProgressUpdated() {
        onScrollingProgressUpdated(this.mScrollingProgress);
    }

    public void setNestedScrollingEnabled(boolean z) {
        this.mNestedScrollingChildHelper.setNestedScrollingEnabled(z);
    }

    public boolean isNestedScrollingEnabled() {
        return this.mNestedScrollingChildHelper.isNestedScrollingEnabled();
    }

    public boolean startNestedScroll(int i) {
        return this.mNestedScrollingChildHelper.startNestedScroll(i);
    }

    public boolean startNestedScroll(int i, int i2) {
        return this.mNestedScrollingChildHelper.startNestedScroll(i, i2);
    }

    public boolean dispatchNestedPreScroll(int i, int i2, @Nullable int[] iArr, @Nullable int[] iArr2, int i3) {
        return this.mNestedScrollingChildHelper.dispatchNestedPreScroll(i, i2, iArr, iArr2, i3);
    }

    public boolean dispatchNestedScroll(int i, int i2, int i3, int i4, int[] iArr, int i5) {
        return this.mNestedScrollingChildHelper.dispatchNestedScroll(i, i2, i3, i4, iArr, i5);
    }

    public void dispatchNestedScroll(int i, int i2, int i3, int i4, @Nullable int[] iArr, int i5, @NonNull int[] iArr2) {
        PrizeNestedScrollLog.d(TAG, "dispatchNestedScroll start ... type: " + i5);
        this.mNestedScrollingChildHelper.dispatchNestedScroll(i, i2, i3, i4, iArr, i5, iArr2);
    }

    public void stopNestedScroll(int i) {
        this.mNestedScrollingChildHelper.stopNestedScroll(i);
    }

    public boolean hasNestedScrollingParent(int i) {
        return this.mNestedScrollingChildHelper.hasNestedScrollingParent(i);
    }

    public void stopNestedScroll() {
        PrizeNestedScrollLog.d(TAG, "stopNestedScroll start0 ... ");
        this.mNestedScrollingChildHelper.stopNestedScroll();
    }

    public boolean onStartNestedScroll(View view, View view2, int i, int i2) {
        PrizeNestedScrollLog.d(TAG, "onStartNestedScroll start0 ... ");
        sendStartNestedScroll(i2);
        return this.mNestedScrollingChildHelper.startNestedScroll(i, i2) || onStartNestedScroll(view, view, i);
    }

    public boolean onStartNestedScroll(View view, View view2, int i) {
        PrizeNestedScrollLog.d(TAG, "onStartNestedScroll start1 ... ");
        boolean z = (i & 2) != 0;
        if (this.mNestedScrollingChildHelper.startNestedScroll(i)) {
            return true;
        }
        return isEnabled() && z;
    }

    public void onNestedScrollAccepted(@NonNull View view, @NonNull View view2, int i, int i2) {
        PrizeNestedScrollLog.d(TAG, "onNestedScrollAccepted start0 ... type: " + i2);
        onNestedScrollAccepted(view, view2, i);
        if (i2 != 0) {
            this.mNestedScrollAcceptedFling = true;
        } else {
            this.mNestedScrollAcceptedFling = false;
        }
    }

    public void onNestedScrollAccepted(View view, View view2, int i) {
        PrizeNestedScrollLog.d(TAG, "onNestedScrollAccepted start1 ... ");
        this.mNestedScrollingParentHelper.onNestedScrollAccepted(view, view2, i);
        startNestedScroll(i & 2);
    }

    public void onNestedPreScroll(@NonNull View view, int i, int i2, @NonNull int[] iArr, int i3) {
        PrizeNestedScrollLog.d(TAG, "onNestedPreScroll start1 ... type: " + i3);
        if (i3 != 0) {
            if (!this.mNestedFlingInConsumedProgress) {
                this.mNestedFlingStartInConsumedTime = SystemClock.elapsedRealtime();
            }
            this.mNestedFlingInConsumedProgress = true;
        } else {
            this.mNestedScrollInConsumedProgress = true;
        }
        int[] iArr2 = this.mParentScrollConsumed;
        if (i2 > 0) {
            int max = Math.max(this.mScrollingFrom, Math.min(this.mScrollingTo, this.mScrollingProgress - i2));
            int i4 = this.mScrollingProgress - max;
            this.mScrollingProgress = max;
            dispatchScrollingProgressUpdated();
            iArr[0] = iArr[0] + 0;
            iArr[1] = iArr[1] + i4;
        }
        if (dispatchNestedPreScroll(i - iArr[0], i2 - iArr[1], iArr2, (int[]) null, i3)) {
            iArr[0] = iArr[0] + iArr2[0];
            iArr[1] = iArr[1] + iArr2[1];
        }
    }

    public void onNestedPreScroll(View view, int i, int i2, int[] iArr) {
        PrizeNestedScrollLog.d(TAG, "onNestedPreScroll start0 ... TYPE_TOUCH ");
        onNestedPreScroll(view, i, i2, iArr, 0);
    }

    public void onNestedScroll(View view, int i, int i2, int i3, int i4) {
        PrizeNestedScrollLog.d(TAG, "onNestedScroll start0 ... TYPE_TOUCH ");
        onNestedScroll(view, i, i2, i3, i4, 0);
    }

    public void onNestedScroll(@NonNull View view, int i, int i2, int i3, int i4, int i5) {
        PrizeNestedScrollLog.d(TAG, "onNestedScroll start1 ... type: " + i5);
        onNestedScroll(view, i, i2, i3, i4, 0, this.mNestedScrollingV2ConsumedCompat);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:34:0x0076, code lost:
        if ((r10 > r12 ? 1 : r10 == r12 ? (char) 0 : 65535) <= 0) goto L_0x0089;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onNestedScroll(@androidx.annotation.NonNull android.view.View r15, int r16, int r17, int r18, int r19, int r20, @androidx.annotation.NonNull int[] r21) {
        /*
            r14 = this;
            r8 = r14
            r9 = r20
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "onNestedScroll start2 ... type: "
            r0.append(r1)
            r0.append(r9)
            java.lang.String r0 = r0.toString()
            java.lang.String r1 = "NestedScrollingLayout"
            com.pri.didouix.util.PrizeNestedScrollLog.d((java.lang.String) r1, (java.lang.String) r0)
            int[] r5 = r8.mParentOffsetInWindow
            r0 = r14
            r1 = r16
            r2 = r17
            r3 = r18
            r4 = r19
            r6 = r20
            r7 = r21
            r0.dispatchNestedScroll(r1, r2, r3, r4, r5, r6, r7)
            r0 = 1
            r1 = r21[r0]
            int r1 = r19 - r1
            if (r19 >= 0) goto L_0x00a5
            if (r1 == 0) goto L_0x00a5
            int r2 = r8.mScrollingProgress
            int r1 = r2 - r1
            r3 = 0
            if (r9 != 0) goto L_0x003d
            r4 = r0
            goto L_0x003e
        L_0x003d:
            r4 = r3
        L_0x003e:
            int r5 = r8.mScrollingFrom
            if (r1 <= r5) goto L_0x0044
            r6 = r0
            goto L_0x0045
        L_0x0044:
            r6 = r3
        L_0x0045:
            if (r4 != 0) goto L_0x0089
            boolean r4 = r8.mTriggerViewVisible
            if (r4 == 0) goto L_0x0089
            if (r4 == 0) goto L_0x0055
            boolean r7 = r8.mHeaderViewVisible
            if (r7 != 0) goto L_0x0055
            if (r9 != r0) goto L_0x0055
            if (r6 == 0) goto L_0x0089
        L_0x0055:
            if (r4 == 0) goto L_0x0079
            if (r9 != r0) goto L_0x0079
            boolean r7 = r8.mHeaderViewVisible
            if (r7 == 0) goto L_0x0079
            boolean r7 = r8.isHeaderOpen
            if (r7 != 0) goto L_0x0063
            if (r1 < 0) goto L_0x0089
        L_0x0063:
            if (r7 == 0) goto L_0x0079
            long r10 = r8.mHeaderOpenTime
            long r12 = r8.mNestedFlingStartInConsumedTime
            int r7 = (r10 > r12 ? 1 : (r10 == r12 ? 0 : -1))
            if (r7 <= 0) goto L_0x006f
            r7 = r0
            goto L_0x0076
        L_0x006f:
            int r7 = (r10 > r12 ? 1 : (r10 == r12 ? 0 : -1))
            if (r7 != 0) goto L_0x0075
            r7 = r3
            goto L_0x0076
        L_0x0075:
            r7 = -1
        L_0x0076:
            if (r7 > 0) goto L_0x0079
            goto L_0x0089
        L_0x0079:
            if (r4 == 0) goto L_0x0087
            boolean r4 = r8.mHeaderViewVisible
            if (r4 != 0) goto L_0x0087
            if (r9 != r0) goto L_0x0087
            if (r6 == 0) goto L_0x0087
            if (r2 != r5) goto L_0x0087
            r2 = r5
            goto L_0x008b
        L_0x0087:
            r2 = r3
            goto L_0x008b
        L_0x0089:
            int r2 = r8.mScrollingTo
        L_0x008b:
            int r1 = java.lang.Math.min(r2, r1)
            int r1 = java.lang.Math.max(r5, r1)
            int r2 = r8.mScrollingProgress
            int r2 = r2 - r1
            r8.mScrollingProgress = r1
            r14.dispatchScrollingProgressUpdated()
            r1 = r21[r3]
            int r1 = r1 + r3
            r21[r3] = r1
            r1 = r21[r0]
            int r1 = r1 + r2
            r21[r0] = r1
        L_0x00a5:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.pri.didouix.nestedheader.widget.NestedScrollingLayout.onNestedScroll(android.view.View, int, int, int, int, int, int[]):void");
    }

    public void onStopNestedScroll(@NonNull View view, int i) {
        PrizeNestedScrollLog.d(TAG, "onStopNestedScroll start ... type: " + i);
        this.mNestedScrollingParentHelper.onStopNestedScroll(view, i);
        sendStopNestedScroll(i);
        stopNestedScroll(i);
        if (this.mNestedScrollInConsumedProgress) {
            this.mNestedScrollInConsumedProgress = false;
            if (!this.mNestedFlingInConsumedProgress && !this.mNestedScrollAcceptedFling) {
                sendStopNestedScrollAccepted(i);
            }
        } else if (this.mNestedFlingInConsumedProgress) {
            this.mNestedFlingInConsumedProgress = false;
            sendStopNestedScrollAccepted(i);
        }
    }

    public void addOnScrollListener(OnNestedChangedListener onNestedChangedListener) {
        this.mOnNestedChangedListeners.add(onNestedChangedListener);
    }

    public void removeOnScrollListener(OnNestedChangedListener onNestedChangedListener) {
        this.mOnNestedChangedListeners.remove(onNestedChangedListener);
    }

    private void sendStartNestedScroll(int i) {
        for (OnNestedChangedListener onStartNestedScroll : this.mOnNestedChangedListeners) {
            onStartNestedScroll.onStartNestedScroll(i);
        }
    }

    private void sendStopNestedScrollAccepted(int i) {
        for (OnNestedChangedListener onStopNestedScrollAccepted : this.mOnNestedChangedListeners) {
            onStopNestedScrollAccepted.onStopNestedScrollAccepted(i);
        }
    }

    private void sendStopNestedScroll(int i) {
        for (OnNestedChangedListener onStopNestedScroll : this.mOnNestedChangedListeners) {
            onStopNestedScroll.onStopNestedScroll(i);
        }
    }
}
