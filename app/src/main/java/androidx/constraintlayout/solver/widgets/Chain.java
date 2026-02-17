package androidx.constraintlayout.solver.widgets;

import androidx.constraintlayout.solver.LinearSystem;

class Chain {
    private static final boolean DEBUG = false;

    Chain() {
    }

    static void applyChainConstraints(ConstraintWidgetContainer constraintWidgetContainer, LinearSystem linearSystem, int i) {
        ChainHead[] chainHeadArr;
        int i2;
        int i3;
        if (i == 0) {
            int i4 = constraintWidgetContainer.mHorizontalChainsSize;
            chainHeadArr = constraintWidgetContainer.mHorizontalChainsArray;
            i2 = i4;
            i3 = 0;
        } else {
            i3 = 2;
            i2 = constraintWidgetContainer.mVerticalChainsSize;
            chainHeadArr = constraintWidgetContainer.mVerticalChainsArray;
        }
        for (int i5 = 0; i5 < i2; i5++) {
            ChainHead chainHead = chainHeadArr[i5];
            chainHead.define();
            applyChainConstraints(constraintWidgetContainer, linearSystem, i, i3, chainHead);
        }
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r21v0, resolved type: androidx.constraintlayout.solver.widgets.ConstraintWidget} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r5v4, resolved type: androidx.constraintlayout.solver.SolverVariable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r5v5, resolved type: androidx.constraintlayout.solver.SolverVariable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r21v1, resolved type: androidx.constraintlayout.solver.widgets.ConstraintWidget} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r5v9, resolved type: androidx.constraintlayout.solver.SolverVariable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r21v2, resolved type: androidx.constraintlayout.solver.widgets.ConstraintWidget} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r5v11, resolved type: androidx.constraintlayout.solver.SolverVariable} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r21v3, resolved type: androidx.constraintlayout.solver.widgets.ConstraintWidget} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r21v4, resolved type: androidx.constraintlayout.solver.widgets.ConstraintWidget} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r5v39, resolved type: androidx.constraintlayout.solver.SolverVariable} */
    /* JADX WARNING: type inference failed for: r5v10, types: [androidx.constraintlayout.solver.SolverVariable] */
    /* JADX WARNING: Code restructure failed: missing block: B:13:0x002d, code lost:
        if (r7 == 2) goto L_0x003e;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:21:0x003c, code lost:
        if (r7 == 2) goto L_0x003e;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:23:0x0040, code lost:
        r5 = false;
     */
    /* JADX WARNING: Failed to insert additional move for type inference */
    /* JADX WARNING: Multi-variable type inference failed */
    /* JADX WARNING: Removed duplicated region for block: B:100:0x018e  */
    /* JADX WARNING: Removed duplicated region for block: B:109:0x01b7  */
    /* JADX WARNING: Removed duplicated region for block: B:110:0x01bb  */
    /* JADX WARNING: Removed duplicated region for block: B:113:0x01c5  */
    /* JADX WARNING: Removed duplicated region for block: B:131:0x024c A[ADDED_TO_REGION] */
    /* JADX WARNING: Removed duplicated region for block: B:150:0x02a5 A[ADDED_TO_REGION] */
    /* JADX WARNING: Removed duplicated region for block: B:208:0x0392  */
    /* JADX WARNING: Removed duplicated region for block: B:217:0x03a7  */
    /* JADX WARNING: Removed duplicated region for block: B:218:0x03aa  */
    /* JADX WARNING: Removed duplicated region for block: B:221:0x03b0  */
    /* JADX WARNING: Removed duplicated region for block: B:266:0x0477  */
    /* JADX WARNING: Removed duplicated region for block: B:271:0x04ac  */
    /* JADX WARNING: Removed duplicated region for block: B:276:0x04bf A[ADDED_TO_REGION] */
    /* JADX WARNING: Removed duplicated region for block: B:280:0x04d2  */
    /* JADX WARNING: Removed duplicated region for block: B:281:0x04d5  */
    /* JADX WARNING: Removed duplicated region for block: B:284:0x04db  */
    /* JADX WARNING: Removed duplicated region for block: B:285:0x04de  */
    /* JADX WARNING: Removed duplicated region for block: B:287:0x04e2  */
    /* JADX WARNING: Removed duplicated region for block: B:292:0x04f2  */
    /* JADX WARNING: Removed duplicated region for block: B:294:0x04f6 A[ADDED_TO_REGION] */
    /* JADX WARNING: Removed duplicated region for block: B:304:0x0393 A[SYNTHETIC] */
    /* JADX WARNING: Removed duplicated region for block: B:315:? A[ADDED_TO_REGION, RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    static void applyChainConstraints(androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer r38, androidx.constraintlayout.solver.LinearSystem r39, int r40, int r41, androidx.constraintlayout.solver.widgets.ChainHead r42) {
        /*
            r0 = r38
            r9 = r39
            r1 = r42
            androidx.constraintlayout.solver.widgets.ConstraintWidget r10 = r1.mFirst
            androidx.constraintlayout.solver.widgets.ConstraintWidget r11 = r1.mLast
            androidx.constraintlayout.solver.widgets.ConstraintWidget r12 = r1.mFirstVisibleWidget
            androidx.constraintlayout.solver.widgets.ConstraintWidget r13 = r1.mLastVisibleWidget
            androidx.constraintlayout.solver.widgets.ConstraintWidget r2 = r1.mHead
            float r3 = r1.mTotalWeight
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r4 = r0.mListDimensionBehaviors
            r4 = r4[r40]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r5 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.WRAP_CONTENT
            r14 = 1
            if (r4 != r5) goto L_0x001d
            r4 = r14
            goto L_0x001e
        L_0x001d:
            r4 = 0
        L_0x001e:
            r5 = 2
            if (r40 != 0) goto L_0x0030
            int r7 = r2.mHorizontalChainStyle
            if (r7 != 0) goto L_0x0027
            r8 = r14
            goto L_0x0028
        L_0x0027:
            r8 = 0
        L_0x0028:
            if (r7 != r14) goto L_0x002c
            r15 = r14
            goto L_0x002d
        L_0x002c:
            r15 = 0
        L_0x002d:
            if (r7 != r5) goto L_0x0040
            goto L_0x003e
        L_0x0030:
            int r7 = r2.mVerticalChainStyle
            if (r7 != 0) goto L_0x0036
            r8 = r14
            goto L_0x0037
        L_0x0036:
            r8 = 0
        L_0x0037:
            if (r7 != r14) goto L_0x003b
            r15 = r14
            goto L_0x003c
        L_0x003b:
            r15 = 0
        L_0x003c:
            if (r7 != r5) goto L_0x0040
        L_0x003e:
            r5 = r14
            goto L_0x0041
        L_0x0040:
            r5 = 0
        L_0x0041:
            r16 = r15
            r7 = 0
            r15 = r8
            r8 = r10
        L_0x0046:
            r21 = 0
            if (r7 != 0) goto L_0x0120
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r6 = r8.mListAnchors
            r6 = r6[r41]
            if (r5 == 0) goto L_0x0053
            r22 = 1
            goto L_0x0055
        L_0x0053:
            r22 = 4
        L_0x0055:
            int r23 = r6.getMargin()
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r14 = r8.mListDimensionBehaviors
            r14 = r14[r40]
            r25 = r3
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r3 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r14 != r3) goto L_0x006d
            int[] r14 = r8.mResolvedMatchConstraintDefault
            r14 = r14[r40]
            if (r14 != 0) goto L_0x006d
            r26 = r7
            r14 = 1
            goto L_0x0070
        L_0x006d:
            r26 = r7
            r14 = 0
        L_0x0070:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r7 = r6.mTarget
            if (r7 == 0) goto L_0x007c
            if (r8 == r10) goto L_0x007c
            int r7 = r7.getMargin()
            int r23 = r23 + r7
        L_0x007c:
            r7 = r23
            if (r5 == 0) goto L_0x0089
            if (r8 == r10) goto L_0x0089
            if (r8 == r12) goto L_0x0089
            r23 = r15
            r22 = 5
            goto L_0x008b
        L_0x0089:
            r23 = r15
        L_0x008b:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r15 = r6.mTarget
            if (r15 == 0) goto L_0x00bc
            if (r8 != r12) goto L_0x009e
            r27 = r2
            androidx.constraintlayout.solver.SolverVariable r2 = r6.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r15 = r15.mSolverVariable
            r28 = r10
            r10 = 6
            r9.addGreaterThan(r2, r15, r7, r10)
            goto L_0x00aa
        L_0x009e:
            r27 = r2
            r28 = r10
            androidx.constraintlayout.solver.SolverVariable r2 = r6.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r10 = r15.mSolverVariable
            r15 = 7
            r9.addGreaterThan(r2, r10, r7, r15)
        L_0x00aa:
            if (r14 == 0) goto L_0x00b0
            if (r5 != 0) goto L_0x00b0
            r2 = 5
            goto L_0x00b2
        L_0x00b0:
            r2 = r22
        L_0x00b2:
            androidx.constraintlayout.solver.SolverVariable r10 = r6.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r6 = r6.mTarget
            androidx.constraintlayout.solver.SolverVariable r6 = r6.mSolverVariable
            r9.addEquality(r10, r6, r7, r2)
            goto L_0x00c0
        L_0x00bc:
            r27 = r2
            r28 = r10
        L_0x00c0:
            if (r4 == 0) goto L_0x00f3
            int r2 = r8.getVisibility()
            r6 = 8
            if (r2 == r6) goto L_0x00e2
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r2 = r8.mListDimensionBehaviors
            r2 = r2[r40]
            if (r2 != r3) goto L_0x00e2
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r8.mListAnchors
            int r3 = r41 + 1
            r3 = r2[r3]
            androidx.constraintlayout.solver.SolverVariable r3 = r3.mSolverVariable
            r2 = r2[r41]
            androidx.constraintlayout.solver.SolverVariable r2 = r2.mSolverVariable
            r6 = 5
            r7 = 0
            r9.addGreaterThan(r3, r2, r7, r6)
            goto L_0x00e3
        L_0x00e2:
            r7 = 0
        L_0x00e3:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r8.mListAnchors
            r2 = r2[r41]
            androidx.constraintlayout.solver.SolverVariable r2 = r2.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r3 = r0.mListAnchors
            r3 = r3[r41]
            androidx.constraintlayout.solver.SolverVariable r3 = r3.mSolverVariable
            r6 = 7
            r9.addGreaterThan(r2, r3, r7, r6)
        L_0x00f3:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r8.mListAnchors
            int r3 = r41 + 1
            r2 = r2[r3]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r2.mTarget
            if (r2 == 0) goto L_0x010e
            androidx.constraintlayout.solver.widgets.ConstraintWidget r2 = r2.mOwner
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r3 = r2.mListAnchors
            r3 = r3[r41]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r3 = r3.mTarget
            if (r3 == 0) goto L_0x010e
            androidx.constraintlayout.solver.widgets.ConstraintWidget r3 = r3.mOwner
            if (r3 == r8) goto L_0x010c
            goto L_0x010e
        L_0x010c:
            r21 = r2
        L_0x010e:
            if (r21 == 0) goto L_0x0115
            r8 = r21
            r7 = r26
            goto L_0x0116
        L_0x0115:
            r7 = 1
        L_0x0116:
            r15 = r23
            r3 = r25
            r2 = r27
            r10 = r28
            goto L_0x0046
        L_0x0120:
            r27 = r2
            r25 = r3
            r28 = r10
            r23 = r15
            if (r13 == 0) goto L_0x018b
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r11.mListAnchors
            int r3 = r41 + 1
            r2 = r2[r3]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r2.mTarget
            if (r2 == 0) goto L_0x018b
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r13.mListAnchors
            r2 = r2[r3]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r6 = r13.mListDimensionBehaviors
            r6 = r6[r40]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r7 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r6 != r7) goto L_0x0148
            int[] r6 = r13.mResolvedMatchConstraintDefault
            r6 = r6[r40]
            if (r6 != 0) goto L_0x0148
            r6 = 1
            goto L_0x0149
        L_0x0148:
            r6 = 0
        L_0x0149:
            if (r6 == 0) goto L_0x0161
            if (r5 != 0) goto L_0x0161
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r6 = r2.mTarget
            androidx.constraintlayout.solver.widgets.ConstraintWidget r7 = r6.mOwner
            if (r7 != r0) goto L_0x0161
            androidx.constraintlayout.solver.SolverVariable r7 = r2.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r6 = r6.mSolverVariable
            int r8 = r2.getMargin()
            int r8 = -r8
            r10 = 5
            r9.addEquality(r7, r6, r8, r10)
            goto L_0x0177
        L_0x0161:
            r10 = 5
            if (r5 == 0) goto L_0x0177
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r6 = r2.mTarget
            androidx.constraintlayout.solver.widgets.ConstraintWidget r7 = r6.mOwner
            if (r7 != r0) goto L_0x0177
            androidx.constraintlayout.solver.SolverVariable r7 = r2.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r6 = r6.mSolverVariable
            int r8 = r2.getMargin()
            int r8 = -r8
            r14 = 4
            r9.addEquality(r7, r6, r8, r14)
        L_0x0177:
            androidx.constraintlayout.solver.SolverVariable r6 = r2.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r7 = r11.mListAnchors
            r3 = r7[r3]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r3 = r3.mTarget
            androidx.constraintlayout.solver.SolverVariable r3 = r3.mSolverVariable
            int r2 = r2.getMargin()
            int r2 = -r2
            r7 = 6
            r9.addLowerThan(r6, r3, r2, r7)
            goto L_0x018c
        L_0x018b:
            r10 = 5
        L_0x018c:
            if (r4 == 0) goto L_0x01a4
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r0.mListAnchors
            int r2 = r41 + 1
            r0 = r0[r2]
            androidx.constraintlayout.solver.SolverVariable r0 = r0.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r3 = r11.mListAnchors
            r2 = r3[r2]
            androidx.constraintlayout.solver.SolverVariable r3 = r2.mSolverVariable
            int r2 = r2.getMargin()
            r4 = 7
            r9.addGreaterThan(r0, r3, r2, r4)
        L_0x01a4:
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.ConstraintWidget> r0 = r1.mWeightedMatchConstraintsWidgets
            if (r0 == 0) goto L_0x024a
            int r2 = r0.size()
            r3 = 1
            if (r2 <= r3) goto L_0x024a
            boolean r3 = r1.mHasUndefinedWeights
            if (r3 == 0) goto L_0x01bb
            boolean r3 = r1.mHasComplexMatchWeights
            if (r3 != 0) goto L_0x01bb
            int r3 = r1.mWidgetsMatchCount
            float r3 = (float) r3
            goto L_0x01bd
        L_0x01bb:
            r3 = r25
        L_0x01bd:
            r4 = 0
            r30 = r4
            r6 = r21
            r7 = 0
        L_0x01c3:
            if (r7 >= r2) goto L_0x024a
            java.lang.Object r8 = r0.get(r7)
            androidx.constraintlayout.solver.widgets.ConstraintWidget r8 = (androidx.constraintlayout.solver.widgets.ConstraintWidget) r8
            float[] r14 = r8.mWeight
            r14 = r14[r40]
            int r15 = (r14 > r4 ? 1 : (r14 == r4 ? 0 : -1))
            if (r15 >= 0) goto L_0x01ef
            boolean r14 = r1.mHasComplexMatchWeights
            if (r14 == 0) goto L_0x01eb
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r8 = r8.mListAnchors
            int r14 = r41 + 1
            r14 = r8[r14]
            androidx.constraintlayout.solver.SolverVariable r14 = r14.mSolverVariable
            r8 = r8[r41]
            androidx.constraintlayout.solver.SolverVariable r8 = r8.mSolverVariable
            r10 = 0
            r15 = 4
            r9.addEquality(r14, r8, r10, r15)
            r4 = r10
            r14 = 7
            goto L_0x0205
        L_0x01eb:
            r15 = 4
            r14 = 1065353216(0x3f800000, float:1.0)
            goto L_0x01f0
        L_0x01ef:
            r15 = 4
        L_0x01f0:
            int r10 = (r14 > r4 ? 1 : (r14 == r4 ? 0 : -1))
            if (r10 != 0) goto L_0x0208
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r8 = r8.mListAnchors
            int r10 = r41 + 1
            r10 = r8[r10]
            androidx.constraintlayout.solver.SolverVariable r10 = r10.mSolverVariable
            r8 = r8[r41]
            androidx.constraintlayout.solver.SolverVariable r8 = r8.mSolverVariable
            r4 = 0
            r14 = 7
            r9.addEquality(r10, r8, r4, r14)
        L_0x0205:
            r20 = r0
            goto L_0x0242
        L_0x0208:
            r4 = 0
            r10 = 7
            if (r6 == 0) goto L_0x023d
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r6 = r6.mListAnchors
            r4 = r6[r41]
            androidx.constraintlayout.solver.SolverVariable r4 = r4.mSolverVariable
            int r20 = r41 + 1
            r6 = r6[r20]
            androidx.constraintlayout.solver.SolverVariable r6 = r6.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r10 = r8.mListAnchors
            r15 = r10[r41]
            androidx.constraintlayout.solver.SolverVariable r15 = r15.mSolverVariable
            r10 = r10[r20]
            androidx.constraintlayout.solver.SolverVariable r10 = r10.mSolverVariable
            r20 = r0
            androidx.constraintlayout.solver.ArrayRow r0 = r39.createRow()
            r29 = r0
            r31 = r3
            r32 = r14
            r33 = r4
            r34 = r6
            r35 = r15
            r36 = r10
            r29.createRowEqualMatchDimensions(r30, r31, r32, r33, r34, r35, r36)
            r9.addConstraint(r0)
            goto L_0x023f
        L_0x023d:
            r20 = r0
        L_0x023f:
            r6 = r8
            r30 = r14
        L_0x0242:
            int r7 = r7 + 1
            r0 = r20
            r4 = 0
            r10 = 5
            goto L_0x01c3
        L_0x024a:
            if (r12 == 0) goto L_0x02a1
            if (r12 == r13) goto L_0x0250
            if (r5 == 0) goto L_0x02a1
        L_0x0250:
            r10 = r28
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r10.mListAnchors
            r0 = r0[r41]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r1 = r11.mListAnchors
            int r2 = r41 + 1
            r1 = r1[r2]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r0.mTarget
            if (r0 == 0) goto L_0x0264
            androidx.constraintlayout.solver.SolverVariable r0 = r0.mSolverVariable
            r3 = r0
            goto L_0x0266
        L_0x0264:
            r3 = r21
        L_0x0266:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r1.mTarget
            if (r0 == 0) goto L_0x026e
            androidx.constraintlayout.solver.SolverVariable r0 = r0.mSolverVariable
            r5 = r0
            goto L_0x0270
        L_0x026e:
            r5 = r21
        L_0x0270:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r12.mListAnchors
            r0 = r0[r41]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r1 = r13.mListAnchors
            r1 = r1[r2]
            if (r3 == 0) goto L_0x04bd
            if (r5 == 0) goto L_0x04bd
            if (r40 != 0) goto L_0x0283
            r2 = r27
            float r2 = r2.mHorizontalBiasPercent
            goto L_0x0287
        L_0x0283:
            r2 = r27
            float r2 = r2.mVerticalBiasPercent
        L_0x0287:
            r4 = r2
            int r6 = r0.getMargin()
            int r7 = r1.getMargin()
            androidx.constraintlayout.solver.SolverVariable r2 = r0.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r8 = r1.mSolverVariable
            r10 = 5
            r0 = r39
            r1 = r2
            r2 = r3
            r3 = r6
            r6 = r8
            r8 = r10
            r0.addCentering(r1, r2, r3, r4, r5, r6, r7, r8)
            goto L_0x04bd
        L_0x02a1:
            r10 = r28
            if (r23 == 0) goto L_0x0397
            if (r12 == 0) goto L_0x0397
            int r0 = r1.mWidgetsMatchCount
            if (r0 <= 0) goto L_0x02b2
            int r1 = r1.mWidgetsCount
            if (r1 != r0) goto L_0x02b2
            r17 = 1
            goto L_0x02b4
        L_0x02b2:
            r17 = 0
        L_0x02b4:
            r14 = r12
            r15 = r14
        L_0x02b6:
            if (r14 == 0) goto L_0x04bd
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r0 = r14.mNextChainWidget
            r0 = r0[r40]
            r8 = r0
        L_0x02bd:
            if (r8 == 0) goto L_0x02cc
            int r0 = r8.getVisibility()
            r6 = 8
            if (r0 != r6) goto L_0x02ce
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r0 = r8.mNextChainWidget
            r8 = r0[r40]
            goto L_0x02bd
        L_0x02cc:
            r6 = 8
        L_0x02ce:
            if (r8 != 0) goto L_0x02db
            if (r14 != r13) goto L_0x02d3
            goto L_0x02db
        L_0x02d3:
            r20 = r8
            r18 = 5
            r19 = 7
            goto L_0x038a
        L_0x02db:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r14.mListAnchors
            r0 = r0[r41]
            androidx.constraintlayout.solver.SolverVariable r1 = r0.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r0.mTarget
            if (r2 == 0) goto L_0x02e8
            androidx.constraintlayout.solver.SolverVariable r2 = r2.mSolverVariable
            goto L_0x02ea
        L_0x02e8:
            r2 = r21
        L_0x02ea:
            if (r15 == r14) goto L_0x02f5
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r15.mListAnchors
            int r3 = r41 + 1
            r2 = r2[r3]
            androidx.constraintlayout.solver.SolverVariable r2 = r2.mSolverVariable
            goto L_0x0306
        L_0x02f5:
            if (r14 != r12) goto L_0x0306
            if (r15 != r14) goto L_0x0306
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r10.mListAnchors
            r2 = r2[r41]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r2.mTarget
            if (r2 == 0) goto L_0x0304
            androidx.constraintlayout.solver.SolverVariable r2 = r2.mSolverVariable
            goto L_0x0306
        L_0x0304:
            r2 = r21
        L_0x0306:
            int r0 = r0.getMargin()
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r3 = r14.mListAnchors
            int r4 = r41 + 1
            r3 = r3[r4]
            int r3 = r3.getMargin()
            if (r8 == 0) goto L_0x0328
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r5 = r8.mListAnchors
            r5 = r5[r41]
            androidx.constraintlayout.solver.SolverVariable r7 = r5.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r6 = r14.mListAnchors
            r6 = r6[r4]
            androidx.constraintlayout.solver.SolverVariable r6 = r6.mSolverVariable
            r37 = r7
            r7 = r6
            r6 = r37
            goto L_0x033b
        L_0x0328:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r5 = r11.mListAnchors
            r5 = r5[r4]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r5.mTarget
            if (r5 == 0) goto L_0x0333
            androidx.constraintlayout.solver.SolverVariable r6 = r5.mSolverVariable
            goto L_0x0335
        L_0x0333:
            r6 = r21
        L_0x0335:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r7 = r14.mListAnchors
            r7 = r7[r4]
            androidx.constraintlayout.solver.SolverVariable r7 = r7.mSolverVariable
        L_0x033b:
            if (r5 == 0) goto L_0x0342
            int r5 = r5.getMargin()
            int r3 = r3 + r5
        L_0x0342:
            if (r15 == 0) goto L_0x034d
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r5 = r15.mListAnchors
            r5 = r5[r4]
            int r5 = r5.getMargin()
            int r0 = r0 + r5
        L_0x034d:
            if (r1 == 0) goto L_0x02d3
            if (r2 == 0) goto L_0x02d3
            if (r6 == 0) goto L_0x02d3
            if (r7 == 0) goto L_0x02d3
            if (r14 != r12) goto L_0x035f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r12.mListAnchors
            r0 = r0[r41]
            int r0 = r0.getMargin()
        L_0x035f:
            r5 = r0
            if (r14 != r13) goto L_0x036d
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r13.mListAnchors
            r0 = r0[r4]
            int r0 = r0.getMargin()
            r20 = r0
            goto L_0x036f
        L_0x036d:
            r20 = r3
        L_0x036f:
            if (r17 == 0) goto L_0x0374
            r24 = 7
            goto L_0x0376
        L_0x0374:
            r24 = 5
        L_0x0376:
            r4 = 1056964608(0x3f000000, float:0.5)
            r0 = r39
            r3 = r5
            r5 = r6
            r18 = 5
            r19 = 7
            r6 = r7
            r7 = r20
            r20 = r8
            r8 = r24
            r0.addCentering(r1, r2, r3, r4, r5, r6, r7, r8)
        L_0x038a:
            int r0 = r14.getVisibility()
            r8 = 8
            if (r0 == r8) goto L_0x0393
            r15 = r14
        L_0x0393:
            r14 = r20
            goto L_0x02b6
        L_0x0397:
            r8 = 8
            r19 = 7
            if (r16 == 0) goto L_0x04bd
            if (r12 == 0) goto L_0x04bd
            int r0 = r1.mWidgetsMatchCount
            if (r0 <= 0) goto L_0x03aa
            int r1 = r1.mWidgetsCount
            if (r1 != r0) goto L_0x03aa
            r17 = 1
            goto L_0x03ac
        L_0x03aa:
            r17 = 0
        L_0x03ac:
            r14 = r12
            r15 = r14
        L_0x03ae:
            if (r14 == 0) goto L_0x045f
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r0 = r14.mNextChainWidget
            r0 = r0[r40]
        L_0x03b4:
            if (r0 == 0) goto L_0x03c1
            int r1 = r0.getVisibility()
            if (r1 != r8) goto L_0x03c1
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r0 = r0.mNextChainWidget
            r0 = r0[r40]
            goto L_0x03b4
        L_0x03c1:
            if (r14 == r12) goto L_0x044e
            if (r14 == r13) goto L_0x044e
            if (r0 == 0) goto L_0x044e
            if (r0 != r13) goto L_0x03cc
            r7 = r21
            goto L_0x03cd
        L_0x03cc:
            r7 = r0
        L_0x03cd:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r14.mListAnchors
            r0 = r0[r41]
            androidx.constraintlayout.solver.SolverVariable r1 = r0.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r0.mTarget
            if (r2 == 0) goto L_0x03d9
            androidx.constraintlayout.solver.SolverVariable r2 = r2.mSolverVariable
        L_0x03d9:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r15.mListAnchors
            int r3 = r41 + 1
            r2 = r2[r3]
            androidx.constraintlayout.solver.SolverVariable r2 = r2.mSolverVariable
            int r0 = r0.getMargin()
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r4 = r14.mListAnchors
            r4 = r4[r3]
            int r4 = r4.getMargin()
            if (r7 == 0) goto L_0x03ff
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r5 = r7.mListAnchors
            r5 = r5[r41]
            androidx.constraintlayout.solver.SolverVariable r6 = r5.mSolverVariable
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r8 = r5.mTarget
            if (r8 == 0) goto L_0x03fc
            androidx.constraintlayout.solver.SolverVariable r8 = r8.mSolverVariable
            goto L_0x0410
        L_0x03fc:
            r8 = r21
            goto L_0x0410
        L_0x03ff:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r5 = r13.mListAnchors
            r5 = r5[r41]
            if (r5 == 0) goto L_0x0408
            androidx.constraintlayout.solver.SolverVariable r6 = r5.mSolverVariable
            goto L_0x040a
        L_0x0408:
            r6 = r21
        L_0x040a:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r8 = r14.mListAnchors
            r8 = r8[r3]
            androidx.constraintlayout.solver.SolverVariable r8 = r8.mSolverVariable
        L_0x0410:
            if (r5 == 0) goto L_0x0417
            int r5 = r5.getMargin()
            int r4 = r4 + r5
        L_0x0417:
            r18 = r4
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r4 = r15.mListAnchors
            r3 = r4[r3]
            int r3 = r3.getMargin()
            int r3 = r3 + r0
            if (r17 == 0) goto L_0x0427
            r20 = r19
            goto L_0x0429
        L_0x0427:
            r20 = 4
        L_0x0429:
            if (r1 == 0) goto L_0x0445
            if (r2 == 0) goto L_0x0445
            if (r6 == 0) goto L_0x0445
            if (r8 == 0) goto L_0x0445
            r4 = 1056964608(0x3f000000, float:0.5)
            r0 = r39
            r5 = r6
            r6 = r8
            r22 = r7
            r7 = r18
            r18 = r15
            r15 = 8
            r8 = r20
            r0.addCentering(r1, r2, r3, r4, r5, r6, r7, r8)
            goto L_0x044b
        L_0x0445:
            r22 = r7
            r18 = r15
            r15 = 8
        L_0x044b:
            r0 = r22
            goto L_0x0451
        L_0x044e:
            r18 = r15
            r15 = r8
        L_0x0451:
            int r1 = r14.getVisibility()
            if (r1 == r15) goto L_0x0458
            goto L_0x045a
        L_0x0458:
            r14 = r18
        L_0x045a:
            r8 = r15
            r15 = r14
            r14 = r0
            goto L_0x03ae
        L_0x045f:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r12.mListAnchors
            r0 = r0[r41]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r1 = r10.mListAnchors
            r1 = r1[r41]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mTarget
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r13.mListAnchors
            int r3 = r41 + 1
            r10 = r2[r3]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r11.mListAnchors
            r2 = r2[r3]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r14 = r2.mTarget
            if (r1 == 0) goto L_0x04ac
            if (r12 == r13) goto L_0x0486
            androidx.constraintlayout.solver.SolverVariable r2 = r0.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r1 = r1.mSolverVariable
            int r0 = r0.getMargin()
            r15 = 4
            r9.addEquality(r2, r1, r0, r15)
            goto L_0x04ad
        L_0x0486:
            r15 = 4
            if (r14 == 0) goto L_0x04ad
            androidx.constraintlayout.solver.SolverVariable r2 = r0.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r3 = r1.mSolverVariable
            int r4 = r0.getMargin()
            r5 = 1056964608(0x3f000000, float:0.5)
            androidx.constraintlayout.solver.SolverVariable r6 = r10.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r7 = r14.mSolverVariable
            int r8 = r10.getMargin()
            r17 = 4
            r0 = r39
            r1 = r2
            r2 = r3
            r3 = r4
            r4 = r5
            r5 = r6
            r6 = r7
            r7 = r8
            r8 = r17
            r0.addCentering(r1, r2, r3, r4, r5, r6, r7, r8)
            goto L_0x04ad
        L_0x04ac:
            r15 = 4
        L_0x04ad:
            if (r14 == 0) goto L_0x04bd
            if (r12 == r13) goto L_0x04bd
            androidx.constraintlayout.solver.SolverVariable r0 = r10.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r1 = r14.mSolverVariable
            int r2 = r10.getMargin()
            int r2 = -r2
            r9.addEquality(r0, r1, r2, r15)
        L_0x04bd:
            if (r23 != 0) goto L_0x04c1
            if (r16 == 0) goto L_0x0516
        L_0x04c1:
            if (r12 == 0) goto L_0x0516
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r12.mListAnchors
            r1 = r0[r41]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r2 = r13.mListAnchors
            r3 = 1
            int r3 = r41 + 1
            r2 = r2[r3]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r4 = r1.mTarget
            if (r4 == 0) goto L_0x04d5
            androidx.constraintlayout.solver.SolverVariable r4 = r4.mSolverVariable
            goto L_0x04d7
        L_0x04d5:
            r4 = r21
        L_0x04d7:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r2.mTarget
            if (r5 == 0) goto L_0x04de
            androidx.constraintlayout.solver.SolverVariable r5 = r5.mSolverVariable
            goto L_0x04e0
        L_0x04de:
            r5 = r21
        L_0x04e0:
            if (r11 == r13) goto L_0x04f0
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r5 = r11.mListAnchors
            r5 = r5[r3]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r5.mTarget
            if (r5 == 0) goto L_0x04ee
            androidx.constraintlayout.solver.SolverVariable r5 = r5.mSolverVariable
            r21 = r5
        L_0x04ee:
            r5 = r21
        L_0x04f0:
            if (r12 != r13) goto L_0x04f4
            r2 = r0[r3]
        L_0x04f4:
            if (r4 == 0) goto L_0x0516
            if (r5 == 0) goto L_0x0516
            r6 = 1056964608(0x3f000000, float:0.5)
            int r7 = r1.getMargin()
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r0 = r13.mListAnchors
            r0 = r0[r3]
            int r8 = r0.getMargin()
            androidx.constraintlayout.solver.SolverVariable r1 = r1.mSolverVariable
            androidx.constraintlayout.solver.SolverVariable r10 = r2.mSolverVariable
            r11 = 5
            r0 = r39
            r2 = r4
            r3 = r7
            r4 = r6
            r6 = r10
            r7 = r8
            r8 = r11
            r0.addCentering(r1, r2, r3, r4, r5, r6, r7, r8)
        L_0x0516:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.Chain.applyChainConstraints(androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer, androidx.constraintlayout.solver.LinearSystem, int, int, androidx.constraintlayout.solver.widgets.ChainHead):void");
    }
}
