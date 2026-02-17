package androidx.constraintlayout.solver.widgets;

import androidx.constraintlayout.solver.LinearSystem;
import androidx.constraintlayout.solver.SolverVariable;
import androidx.constraintlayout.solver.widgets.ConstraintWidget;
import java.util.HashMap;

public class Barrier extends HelperWidget {
    public static final int BOTTOM = 3;
    public static final int LEFT = 0;
    public static final int RIGHT = 1;
    public static final int TOP = 2;
    private boolean mAllowsGoneWidget = true;
    private int mBarrierType = 0;
    private int mMargin = 0;

    public boolean allowedInBarrier() {
        return true;
    }

    public int getBarrierType() {
        return this.mBarrierType;
    }

    public void setBarrierType(int i) {
        this.mBarrierType = i;
    }

    public void setAllowsGoneWidget(boolean z) {
        this.mAllowsGoneWidget = z;
    }

    public boolean allowsGoneWidget() {
        return this.mAllowsGoneWidget;
    }

    public void copy(ConstraintWidget constraintWidget, HashMap<ConstraintWidget, ConstraintWidget> hashMap) {
        super.copy(constraintWidget, hashMap);
        Barrier barrier = (Barrier) constraintWidget;
        this.mBarrierType = barrier.mBarrierType;
        this.mAllowsGoneWidget = barrier.mAllowsGoneWidget;
        this.mMargin = barrier.mMargin;
    }

    public void addToSolver(LinearSystem linearSystem) {
        ConstraintAnchor[] constraintAnchorArr;
        boolean z;
        int i;
        int i2;
        ConstraintAnchor[] constraintAnchorArr2 = this.mListAnchors;
        constraintAnchorArr2[0] = this.mLeft;
        constraintAnchorArr2[2] = this.mTop;
        constraintAnchorArr2[1] = this.mRight;
        constraintAnchorArr2[3] = this.mBottom;
        int i3 = 0;
        while (true) {
            constraintAnchorArr = this.mListAnchors;
            if (i3 >= constraintAnchorArr.length) {
                break;
            }
            ConstraintAnchor constraintAnchor = constraintAnchorArr[i3];
            constraintAnchor.mSolverVariable = linearSystem.createObjectVariable(constraintAnchor);
            i3++;
        }
        int i4 = this.mBarrierType;
        if (i4 >= 0) {
            int i5 = 4;
            if (i4 < 4) {
                ConstraintAnchor constraintAnchor2 = constraintAnchorArr[i4];
                int i6 = 0;
                while (true) {
                    if (i6 >= this.mWidgetsCount) {
                        z = false;
                        break;
                    }
                    ConstraintWidget constraintWidget = this.mWidgets[i6];
                    if ((this.mAllowsGoneWidget || constraintWidget.allowedInBarrier()) && ((((i = this.mBarrierType) == 0 || i == 1) && constraintWidget.getHorizontalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT && constraintWidget.mLeft.mTarget != null && constraintWidget.mRight.mTarget != null) || (((i2 = this.mBarrierType) == 2 || i2 == 3) && constraintWidget.getVerticalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT && constraintWidget.mTop.mTarget != null && constraintWidget.mBottom.mTarget != null))) {
                        z = true;
                    } else {
                        i6++;
                    }
                }
                z = true;
                for (int i7 = 0; i7 < this.mWidgetsCount; i7++) {
                    ConstraintWidget constraintWidget2 = this.mWidgets[i7];
                    if (this.mAllowsGoneWidget || constraintWidget2.allowedInBarrier()) {
                        SolverVariable createObjectVariable = linearSystem.createObjectVariable(constraintWidget2.mListAnchors[this.mBarrierType]);
                        ConstraintAnchor[] constraintAnchorArr3 = constraintWidget2.mListAnchors;
                        int i8 = this.mBarrierType;
                        ConstraintAnchor constraintAnchor3 = constraintAnchorArr3[i8];
                        constraintAnchor3.mSolverVariable = createObjectVariable;
                        ConstraintAnchor constraintAnchor4 = constraintAnchor3.mTarget;
                        int i9 = (constraintAnchor4 == null || constraintAnchor4.mOwner != this) ? 0 : constraintAnchor3.mMargin + 0;
                        if (i8 == 0 || i8 == 2) {
                            linearSystem.addLowerBarrier(constraintAnchor2.mSolverVariable, createObjectVariable, this.mMargin - i9, z);
                        } else {
                            linearSystem.addGreaterBarrier(constraintAnchor2.mSolverVariable, createObjectVariable, this.mMargin + i9, z);
                        }
                    }
                }
                if (!z) {
                    i5 = 5;
                }
                int i10 = this.mBarrierType;
                if (i10 == 0) {
                    linearSystem.addEquality(this.mRight.mSolverVariable, this.mLeft.mSolverVariable, 0, 7);
                    linearSystem.addEquality(this.mLeft.mSolverVariable, this.mParent.mRight.mSolverVariable, 0, i5);
                    linearSystem.addEquality(this.mLeft.mSolverVariable, this.mParent.mLeft.mSolverVariable, 0, 0);
                } else if (i10 == 1) {
                    linearSystem.addEquality(this.mLeft.mSolverVariable, this.mRight.mSolverVariable, 0, 7);
                    linearSystem.addEquality(this.mLeft.mSolverVariable, this.mParent.mLeft.mSolverVariable, 0, i5);
                    linearSystem.addEquality(this.mLeft.mSolverVariable, this.mParent.mRight.mSolverVariable, 0, 0);
                } else if (i10 == 2) {
                    linearSystem.addEquality(this.mBottom.mSolverVariable, this.mTop.mSolverVariable, 0, 7);
                    linearSystem.addEquality(this.mTop.mSolverVariable, this.mParent.mBottom.mSolverVariable, 0, i5);
                    linearSystem.addEquality(this.mTop.mSolverVariable, this.mParent.mTop.mSolverVariable, 0, 0);
                } else if (i10 == 3) {
                    linearSystem.addEquality(this.mTop.mSolverVariable, this.mBottom.mSolverVariable, 0, 7);
                    linearSystem.addEquality(this.mTop.mSolverVariable, this.mParent.mTop.mSolverVariable, 0, i5);
                    linearSystem.addEquality(this.mTop.mSolverVariable, this.mParent.mBottom.mSolverVariable, 0, 0);
                }
            }
        }
    }

    public void setMargin(int i) {
        this.mMargin = i;
    }

    public int getMargin() {
        return this.mMargin;
    }
}
