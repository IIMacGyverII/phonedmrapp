package com.pri.didouix.viewbehavior;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.View;
import androidx.annotation.IdRes;
import androidx.annotation.NonNull;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import com.pri.R;
/* loaded from: classes4.dex */
public class PercentageViewBehavior<V extends View> extends CoordinatorLayout.Behavior<V> {
    public static final int DEPEND_TYPE_HEIGHT = 0;
    public static final int DEPEND_TYPE_WIDTH = 1;
    public static final int DEPEND_TYPE_X = 2;
    public static final int DEPEND_TYPE_Y = 3;
    private static final String TAG = "PercentageViewBehavior";
    static final float UNSPECIFIED_FLOAT = Float.MAX_VALUE;
    static final int UNSPECIFIED_INT = Integer.MAX_VALUE;
    private boolean isPrepared;
    private int mDependStartHeight;
    private int mDependStartWidth;
    private int mDependStartX;
    private int mDependStartY;
    private int mDependTarget;
    private int mDependType;
    private int mDependViewId;

    /* JADX INFO: Access modifiers changed from: package-private */
    public PercentageViewBehavior(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.ViewBehavior);
        this.mDependViewId = obtainStyledAttributes.getResourceId(R.styleable.ViewBehavior_behavior_dependsOn, 0);
        this.mDependType = obtainStyledAttributes.getInt(R.styleable.ViewBehavior_behavior_dependType, 1);
        this.mDependTarget = obtainStyledAttributes.getDimensionPixelOffset(R.styleable.ViewBehavior_behavior_dependTarget, Integer.MAX_VALUE);
        obtainStyledAttributes.recycle();
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public PercentageViewBehavior(@NonNull Builder builder) {
        this.mDependViewId = builder.dependsOn;
        this.mDependType = builder.dependsType;
        this.mDependTarget = builder.targetValue;
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public void prepare(CoordinatorLayout coordinatorLayout, V v, View view) {
        this.mDependStartX = (int) view.getX();
        this.mDependStartY = (int) view.getY();
        this.mDependStartWidth = view.getWidth();
        this.mDependStartHeight = view.getHeight();
        this.isPrepared = true;
    }

    @Override // androidx.coordinatorlayout.widget.CoordinatorLayout.Behavior
    public boolean layoutDependsOn(CoordinatorLayout coordinatorLayout, V v, View view) {
        return view.getId() == this.mDependViewId;
    }

    @Override // androidx.coordinatorlayout.widget.CoordinatorLayout.Behavior
    public boolean onDependentViewChanged(CoordinatorLayout coordinatorLayout, V v, View view) {
        if (!this.isPrepared) {
            prepare(coordinatorLayout, v, view);
        }
        updateView(v, view);
        return false;
    }

    @Override // androidx.coordinatorlayout.widget.CoordinatorLayout.Behavior
    public boolean onLayoutChild(CoordinatorLayout coordinatorLayout, V v, int i) {
        boolean onLayoutChild = super.onLayoutChild(coordinatorLayout, v, i);
        if (this.isPrepared) {
            updateView(v, coordinatorLayout.getDependencies(v).get(0));
        }
        return onLayoutChild;
    }

    /* JADX WARN: Removed duplicated region for block: B:18:0x0042  */
    /* JADX WARN: Removed duplicated region for block: B:21:0x0054  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct add '--show-bad-code' argument
    */
    void updateView(V r5, android.view.View r6) {
        /*
            r4 = this;
            int r0 = r4.mDependType
            r1 = 1325400064(0x4f000000, float:2.14748365E9)
            r2 = 0
            if (r0 == 0) goto L33
            r3 = 1
            if (r0 == r3) goto L28
            r3 = 2
            if (r0 == r3) goto L1e
            r3 = 3
            if (r0 == r3) goto L14
            r3 = r1
            r6 = r2
            r0 = r6
            goto L3e
        L14:
            int r0 = r4.mDependStartY
            float r0 = (float) r0
            float r6 = r6.getY()
            int r3 = r4.mDependTarget
            goto L3d
        L1e:
            int r0 = r4.mDependStartX
            float r0 = (float) r0
            float r6 = r6.getX()
            int r3 = r4.mDependTarget
            goto L3d
        L28:
            int r0 = r4.mDependStartWidth
            float r0 = (float) r0
            int r6 = r6.getWidth()
            float r6 = (float) r6
            int r3 = r4.mDependTarget
            goto L3d
        L33:
            int r0 = r4.mDependStartHeight
            float r0 = (float) r0
            int r6 = r6.getHeight()
            float r6 = (float) r6
            int r3 = r4.mDependTarget
        L3d:
            float r3 = (float) r3
        L3e:
            int r1 = (r3 > r1 ? 1 : (r3 == r1 ? 0 : -1))
            if (r1 == 0) goto L4e
            float r6 = r6 - r0
            float r6 = java.lang.Math.abs(r6)
            float r3 = r3 - r0
            float r0 = java.lang.Math.abs(r3)
            float r2 = r6 / r0
        L4e:
            r6 = 1065353216(0x3f800000, float:1.0)
            int r0 = (r2 > r6 ? 1 : (r2 == r6 ? 0 : -1))
            if (r0 <= 0) goto L55
            r2 = r6
        L55:
            r4.updateViewWithPercent(r5, r2)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.pri.didouix.viewbehavior.PercentageViewBehavior.updateView(android.view.View, android.view.View):void");
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public void updateViewWithPercent(V v, float f) {
        if (v instanceof PercentageChildView) {
            ((PercentageChildView) v).onPercentageBehaviorChange(this, f);
        }
    }

    /* loaded from: classes4.dex */
    static abstract class Builder<T extends Builder> {
        private int dependsOn;
        private int dependsType = Integer.MAX_VALUE;
        private int targetValue = Integer.MAX_VALUE;

        abstract T getThis();

        T dependsOn(@IdRes int i, int i2) {
            this.dependsOn = i;
            this.dependsType = i2;
            return getThis();
        }

        T targetValue(int i) {
            this.targetValue = i;
            return getThis();
        }
    }
}
