package com.pri.didouix.custview;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.NestedScrollingChild3;
import androidx.core.view.NestedScrollingChildHelper;
import com.pri.didouix.util.ListViewUtil;

public class PrizeListView extends ListView implements NestedScrollingChild3 {
    private static final String TAG = "PrizeListView";
    private final NestedScrollingChildHelper mScrollingChildHelper = new NestedScrollingChildHelper(this);

    public PrizeListView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        ListViewUtil.setListViewEnhanceNestedScrolling(this, true);
        setNestedScrollingEnabled(true);
    }

    public void setNestedScrollingEnabled(boolean z) {
        this.mScrollingChildHelper.setNestedScrollingEnabled(z);
    }

    public boolean isNestedScrollingEnabled() {
        return this.mScrollingChildHelper.isNestedScrollingEnabled();
    }

    public boolean startNestedScroll(int i) {
        return this.mScrollingChildHelper.startNestedScroll(i);
    }

    public boolean startNestedScroll(int i, int i2) {
        return this.mScrollingChildHelper.startNestedScroll(i, i2);
    }

    public void stopNestedScroll() {
        this.mScrollingChildHelper.stopNestedScroll();
    }

    public void stopNestedScroll(int i) {
        this.mScrollingChildHelper.stopNestedScroll(i);
    }

    public boolean hasNestedScrollingParent() {
        return this.mScrollingChildHelper.hasNestedScrollingParent();
    }

    public boolean hasNestedScrollingParent(int i) {
        return this.mScrollingChildHelper.hasNestedScrollingParent(i);
    }

    public boolean dispatchNestedScroll(int i, int i2, int i3, int i4, int[] iArr) {
        return this.mScrollingChildHelper.dispatchNestedScroll(i, i2, i3, i4, iArr);
    }

    public void dispatchNestedScroll(int i, int i2, int i3, int i4, @Nullable int[] iArr, int i5, @NonNull int[] iArr2) {
        this.mScrollingChildHelper.dispatchNestedScroll(i, i2, i3, i4, iArr, i5, iArr2);
    }

    public boolean dispatchNestedScroll(int i, int i2, int i3, int i4, int[] iArr, int i5) {
        return this.mScrollingChildHelper.dispatchNestedScroll(i, i2, i3, i4, iArr, i5);
    }

    public boolean dispatchNestedPreScroll(int i, int i2, int[] iArr, int[] iArr2) {
        return this.mScrollingChildHelper.dispatchNestedPreScroll(i, i2, iArr, iArr2);
    }

    public boolean dispatchNestedPreScroll(int i, int i2, int[] iArr, int[] iArr2, int i3) {
        return this.mScrollingChildHelper.dispatchNestedPreScroll(i, i2, iArr, iArr2, i3);
    }

    public boolean dispatchNestedFling(float f, float f2, boolean z) {
        return this.mScrollingChildHelper.dispatchNestedFling(f, f2, z);
    }

    public boolean dispatchNestedPreFling(float f, float f2) {
        return this.mScrollingChildHelper.dispatchNestedPreFling(f, f2);
    }
}
