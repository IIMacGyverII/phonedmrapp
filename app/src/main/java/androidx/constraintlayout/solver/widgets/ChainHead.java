package androidx.constraintlayout.solver.widgets;

import androidx.constraintlayout.solver.widgets.ConstraintWidget;
import java.util.ArrayList;

public class ChainHead {
    private boolean mDefined;
    protected ConstraintWidget mFirst;
    protected ConstraintWidget mFirstMatchConstraintWidget;
    protected ConstraintWidget mFirstVisibleWidget;
    protected boolean mHasComplexMatchWeights;
    protected boolean mHasDefinedWeights;
    protected boolean mHasRatio;
    protected boolean mHasUndefinedWeights;
    protected ConstraintWidget mHead;
    private boolean mIsRtl;
    protected ConstraintWidget mLast;
    protected ConstraintWidget mLastMatchConstraintWidget;
    protected ConstraintWidget mLastVisibleWidget;
    boolean mOptimizable;
    private int mOrientation;
    int mTotalMargins;
    int mTotalSize;
    protected float mTotalWeight = 0.0f;
    int mVisibleWidgets;
    protected ArrayList<ConstraintWidget> mWeightedMatchConstraintsWidgets;
    protected int mWidgetsCount;
    protected int mWidgetsMatchCount;

    public ChainHead(ConstraintWidget constraintWidget, int i, boolean z) {
        this.mFirst = constraintWidget;
        this.mOrientation = i;
        this.mIsRtl = z;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:4:0x0010, code lost:
        r2 = r2.mResolvedMatchConstraintDefault[r3];
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private static boolean isMatchConstraintEqualityCandidate(androidx.constraintlayout.solver.widgets.ConstraintWidget r2, int r3) {
        /*
            int r0 = r2.getVisibility()
            r1 = 8
            if (r0 == r1) goto L_0x001b
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r0 = r2.mListDimensionBehaviors
            r0 = r0[r3]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r1 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r0 != r1) goto L_0x001b
            int[] r2 = r2.mResolvedMatchConstraintDefault
            r2 = r2[r3]
            if (r2 == 0) goto L_0x0019
            r3 = 3
            if (r2 != r3) goto L_0x001b
        L_0x0019:
            r2 = 1
            goto L_0x001c
        L_0x001b:
            r2 = 0
        L_0x001c:
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.ChainHead.isMatchConstraintEqualityCandidate(androidx.constraintlayout.solver.widgets.ConstraintWidget, int):boolean");
    }

    private void defineChainProperties() {
        int i = this.mOrientation * 2;
        ConstraintWidget constraintWidget = this.mFirst;
        boolean z = true;
        this.mOptimizable = true;
        ConstraintWidget constraintWidget2 = constraintWidget;
        boolean z2 = false;
        while (!z2) {
            this.mWidgetsCount++;
            ConstraintWidget[] constraintWidgetArr = constraintWidget.mNextChainWidget;
            int i2 = this.mOrientation;
            ConstraintWidget constraintWidget3 = null;
            constraintWidgetArr[i2] = null;
            constraintWidget.mListNextMatchConstraintsWidget[i2] = null;
            if (constraintWidget.getVisibility() != 8) {
                this.mVisibleWidgets++;
                ConstraintWidget.DimensionBehaviour dimensionBehaviour = constraintWidget.getDimensionBehaviour(this.mOrientation);
                ConstraintWidget.DimensionBehaviour dimensionBehaviour2 = ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT;
                if (dimensionBehaviour != dimensionBehaviour2) {
                    this.mTotalSize += constraintWidget.getLength(this.mOrientation);
                }
                int margin = this.mTotalSize + constraintWidget.mListAnchors[i].getMargin();
                this.mTotalSize = margin;
                int i3 = i + 1;
                this.mTotalSize = margin + constraintWidget.mListAnchors[i3].getMargin();
                int margin2 = this.mTotalMargins + constraintWidget.mListAnchors[i].getMargin();
                this.mTotalMargins = margin2;
                this.mTotalMargins = margin2 + constraintWidget.mListAnchors[i3].getMargin();
                if (this.mFirstVisibleWidget == null) {
                    this.mFirstVisibleWidget = constraintWidget;
                }
                this.mLastVisibleWidget = constraintWidget;
                ConstraintWidget.DimensionBehaviour[] dimensionBehaviourArr = constraintWidget.mListDimensionBehaviors;
                int i4 = this.mOrientation;
                if (dimensionBehaviourArr[i4] == dimensionBehaviour2) {
                    int i5 = constraintWidget.mResolvedMatchConstraintDefault[i4];
                    if (i5 == 0 || i5 == 3 || i5 == 2) {
                        this.mWidgetsMatchCount++;
                        float f = constraintWidget.mWeight[i4];
                        if (f > 0.0f) {
                            this.mTotalWeight += f;
                        }
                        if (isMatchConstraintEqualityCandidate(constraintWidget, i4)) {
                            if (f < 0.0f) {
                                this.mHasUndefinedWeights = true;
                            } else {
                                this.mHasDefinedWeights = true;
                            }
                            if (this.mWeightedMatchConstraintsWidgets == null) {
                                this.mWeightedMatchConstraintsWidgets = new ArrayList<>();
                            }
                            this.mWeightedMatchConstraintsWidgets.add(constraintWidget);
                        }
                        if (this.mFirstMatchConstraintWidget == null) {
                            this.mFirstMatchConstraintWidget = constraintWidget;
                        }
                        ConstraintWidget constraintWidget4 = this.mLastMatchConstraintWidget;
                        if (constraintWidget4 != null) {
                            constraintWidget4.mListNextMatchConstraintsWidget[this.mOrientation] = constraintWidget;
                        }
                        this.mLastMatchConstraintWidget = constraintWidget;
                    }
                    if (this.mOrientation == 0) {
                        if (constraintWidget.mMatchConstraintDefaultWidth != 0) {
                            this.mOptimizable = false;
                        } else if (!(constraintWidget.mMatchConstraintMinWidth == 0 && constraintWidget.mMatchConstraintMaxWidth == 0)) {
                            this.mOptimizable = false;
                        }
                    } else if (constraintWidget.mMatchConstraintDefaultHeight != 0) {
                        this.mOptimizable = false;
                    } else if (!(constraintWidget.mMatchConstraintMinHeight == 0 && constraintWidget.mMatchConstraintMaxHeight == 0)) {
                        this.mOptimizable = false;
                    }
                    if (constraintWidget.mDimensionRatio != 0.0f) {
                        this.mOptimizable = false;
                        this.mHasRatio = true;
                    }
                }
            }
            if (constraintWidget2 != constraintWidget) {
                constraintWidget2.mNextChainWidget[this.mOrientation] = constraintWidget;
            }
            ConstraintAnchor constraintAnchor = constraintWidget.mListAnchors[i + 1].mTarget;
            if (constraintAnchor != null) {
                ConstraintWidget constraintWidget5 = constraintAnchor.mOwner;
                ConstraintAnchor constraintAnchor2 = constraintWidget5.mListAnchors[i].mTarget;
                if (constraintAnchor2 != null && constraintAnchor2.mOwner == constraintWidget) {
                    constraintWidget3 = constraintWidget5;
                }
            }
            if (constraintWidget3 == null) {
                constraintWidget3 = constraintWidget;
                z2 = true;
            }
            constraintWidget2 = constraintWidget;
            constraintWidget = constraintWidget3;
        }
        ConstraintWidget constraintWidget6 = this.mFirstVisibleWidget;
        if (constraintWidget6 != null) {
            this.mTotalSize -= constraintWidget6.mListAnchors[i].getMargin();
        }
        ConstraintWidget constraintWidget7 = this.mLastVisibleWidget;
        if (constraintWidget7 != null) {
            this.mTotalSize -= constraintWidget7.mListAnchors[i + 1].getMargin();
        }
        this.mLast = constraintWidget;
        if (this.mOrientation != 0 || !this.mIsRtl) {
            this.mHead = this.mFirst;
        } else {
            this.mHead = constraintWidget;
        }
        if (!this.mHasDefinedWeights || !this.mHasUndefinedWeights) {
            z = false;
        }
        this.mHasComplexMatchWeights = z;
    }

    public ConstraintWidget getFirst() {
        return this.mFirst;
    }

    public ConstraintWidget getFirstVisibleWidget() {
        return this.mFirstVisibleWidget;
    }

    public ConstraintWidget getLast() {
        return this.mLast;
    }

    public ConstraintWidget getLastVisibleWidget() {
        return this.mLastVisibleWidget;
    }

    public ConstraintWidget getHead() {
        return this.mHead;
    }

    public ConstraintWidget getFirstMatchConstraintWidget() {
        return this.mFirstMatchConstraintWidget;
    }

    public ConstraintWidget getLastMatchConstraintWidget() {
        return this.mLastMatchConstraintWidget;
    }

    public float getTotalWeight() {
        return this.mTotalWeight;
    }

    public void define() {
        if (!this.mDefined) {
            defineChainProperties();
        }
        this.mDefined = true;
    }
}
