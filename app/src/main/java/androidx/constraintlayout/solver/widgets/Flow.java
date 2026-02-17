package androidx.constraintlayout.solver.widgets;

import androidx.constraintlayout.solver.LinearSystem;
import androidx.constraintlayout.solver.widgets.ConstraintWidget;
import java.util.ArrayList;
import java.util.HashMap;

public class Flow extends VirtualLayout {
    public static final int HORIZONTAL_ALIGN_CENTER = 2;
    public static final int HORIZONTAL_ALIGN_END = 1;
    public static final int HORIZONTAL_ALIGN_START = 0;
    public static final int VERTICAL_ALIGN_BASELINE = 3;
    public static final int VERTICAL_ALIGN_BOTTOM = 1;
    public static final int VERTICAL_ALIGN_CENTER = 2;
    public static final int VERTICAL_ALIGN_TOP = 0;
    public static final int WRAP_ALIGNED = 2;
    public static final int WRAP_CHAIN = 1;
    public static final int WRAP_NONE = 0;
    private ConstraintWidget[] mAlignedBiggestElementsInCols = null;
    private ConstraintWidget[] mAlignedBiggestElementsInRows = null;
    private int[] mAlignedDimensions = null;
    private ArrayList<WidgetsList> mChainList = new ArrayList<>();
    /* access modifiers changed from: private */
    public ConstraintWidget[] mDisplayedWidgets;
    private int mDisplayedWidgetsCount = 0;
    /* access modifiers changed from: private */
    public float mFirstHorizontalBias = 0.5f;
    /* access modifiers changed from: private */
    public int mFirstHorizontalStyle = -1;
    /* access modifiers changed from: private */
    public float mFirstVerticalBias = 0.5f;
    /* access modifiers changed from: private */
    public int mFirstVerticalStyle = -1;
    /* access modifiers changed from: private */
    public int mHorizontalAlign = 2;
    /* access modifiers changed from: private */
    public float mHorizontalBias = 0.5f;
    /* access modifiers changed from: private */
    public int mHorizontalGap = 0;
    /* access modifiers changed from: private */
    public int mHorizontalStyle = -1;
    /* access modifiers changed from: private */
    public float mLastHorizontalBias = 0.5f;
    /* access modifiers changed from: private */
    public int mLastHorizontalStyle = -1;
    /* access modifiers changed from: private */
    public float mLastVerticalBias = 0.5f;
    /* access modifiers changed from: private */
    public int mLastVerticalStyle = -1;
    private int mMaxElementsWrap = -1;
    private int mOrientation = 0;
    /* access modifiers changed from: private */
    public int mVerticalAlign = 2;
    /* access modifiers changed from: private */
    public float mVerticalBias = 0.5f;
    /* access modifiers changed from: private */
    public int mVerticalGap = 0;
    /* access modifiers changed from: private */
    public int mVerticalStyle = -1;
    private int mWrapMode = 0;

    public void copy(ConstraintWidget constraintWidget, HashMap<ConstraintWidget, ConstraintWidget> hashMap) {
        super.copy(constraintWidget, hashMap);
        Flow flow = (Flow) constraintWidget;
        this.mHorizontalStyle = flow.mHorizontalStyle;
        this.mVerticalStyle = flow.mVerticalStyle;
        this.mFirstHorizontalStyle = flow.mFirstHorizontalStyle;
        this.mFirstVerticalStyle = flow.mFirstVerticalStyle;
        this.mLastHorizontalStyle = flow.mLastHorizontalStyle;
        this.mLastVerticalStyle = flow.mLastVerticalStyle;
        this.mHorizontalBias = flow.mHorizontalBias;
        this.mVerticalBias = flow.mVerticalBias;
        this.mFirstHorizontalBias = flow.mFirstHorizontalBias;
        this.mFirstVerticalBias = flow.mFirstVerticalBias;
        this.mLastHorizontalBias = flow.mLastHorizontalBias;
        this.mLastVerticalBias = flow.mLastVerticalBias;
        this.mHorizontalGap = flow.mHorizontalGap;
        this.mVerticalGap = flow.mVerticalGap;
        this.mHorizontalAlign = flow.mHorizontalAlign;
        this.mVerticalAlign = flow.mVerticalAlign;
        this.mWrapMode = flow.mWrapMode;
        this.mMaxElementsWrap = flow.mMaxElementsWrap;
        this.mOrientation = flow.mOrientation;
    }

    public void setOrientation(int i) {
        this.mOrientation = i;
    }

    public void setFirstHorizontalStyle(int i) {
        this.mFirstHorizontalStyle = i;
    }

    public void setFirstVerticalStyle(int i) {
        this.mFirstVerticalStyle = i;
    }

    public void setLastHorizontalStyle(int i) {
        this.mLastHorizontalStyle = i;
    }

    public void setLastVerticalStyle(int i) {
        this.mLastVerticalStyle = i;
    }

    public void setHorizontalStyle(int i) {
        this.mHorizontalStyle = i;
    }

    public void setVerticalStyle(int i) {
        this.mVerticalStyle = i;
    }

    public void setHorizontalBias(float f) {
        this.mHorizontalBias = f;
    }

    public void setVerticalBias(float f) {
        this.mVerticalBias = f;
    }

    public void setFirstHorizontalBias(float f) {
        this.mFirstHorizontalBias = f;
    }

    public void setFirstVerticalBias(float f) {
        this.mFirstVerticalBias = f;
    }

    public void setLastHorizontalBias(float f) {
        this.mLastHorizontalBias = f;
    }

    public void setLastVerticalBias(float f) {
        this.mLastVerticalBias = f;
    }

    public void setHorizontalAlign(int i) {
        this.mHorizontalAlign = i;
    }

    public void setVerticalAlign(int i) {
        this.mVerticalAlign = i;
    }

    public void setWrapMode(int i) {
        this.mWrapMode = i;
    }

    public void setHorizontalGap(int i) {
        this.mHorizontalGap = i;
    }

    public void setVerticalGap(int i) {
        this.mVerticalGap = i;
    }

    public void setMaxElementsWrap(int i) {
        this.mMaxElementsWrap = i;
    }

    /* access modifiers changed from: private */
    public final int getWidgetWidth(ConstraintWidget constraintWidget, int i) {
        if (constraintWidget == null) {
            return 0;
        }
        if (constraintWidget.getHorizontalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT) {
            int i2 = constraintWidget.mMatchConstraintDefaultWidth;
            if (i2 == 0) {
                return 0;
            }
            if (i2 == 2) {
                int i3 = (int) (constraintWidget.mMatchConstraintPercentWidth * ((float) i));
                if (i3 != constraintWidget.getWidth()) {
                    measure(constraintWidget, ConstraintWidget.DimensionBehaviour.FIXED, i3, constraintWidget.getVerticalDimensionBehaviour(), constraintWidget.getHeight());
                }
                return i3;
            }
        }
        return constraintWidget.getWidth();
    }

    /* access modifiers changed from: private */
    public final int getWidgetHeight(ConstraintWidget constraintWidget, int i) {
        if (constraintWidget == null) {
            return 0;
        }
        if (constraintWidget.getVerticalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT) {
            int i2 = constraintWidget.mMatchConstraintDefaultHeight;
            if (i2 == 0) {
                return 0;
            }
            if (i2 == 2) {
                int i3 = (int) (constraintWidget.mMatchConstraintPercentHeight * ((float) i));
                if (i3 != constraintWidget.getHeight()) {
                    measure(constraintWidget, constraintWidget.getHorizontalDimensionBehaviour(), constraintWidget.getWidth(), ConstraintWidget.DimensionBehaviour.FIXED, i3);
                }
                return i3;
            }
        }
        return constraintWidget.getHeight();
    }

    /* JADX WARNING: type inference failed for: r11v2 */
    /* JADX WARNING: type inference failed for: r11v3 */
    /* JADX WARNING: type inference failed for: r11v6 */
    /* JADX WARNING: type inference failed for: r11v7 */
    /* JADX WARNING: type inference failed for: r11v8 */
    /* JADX WARNING: Multi-variable type inference failed */
    /* JADX WARNING: Unknown variable types count: 1 */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void measure(int r19, int r20, int r21, int r22) {
        /*
            r18 = this;
            r6 = r18
            r7 = r19
            r8 = r20
            r9 = r21
            r10 = r22
            int r0 = r6.mWidgetsCount
            r11 = 0
            if (r0 <= 0) goto L_0x001c
            boolean r0 = r18.measureChildren()
            if (r0 != 0) goto L_0x001c
            r6.setMeasure(r11, r11)
            r6.needsCallbackFromSolver(r11)
            return
        L_0x001c:
            int r12 = r18.getPaddingLeft()
            int r13 = r18.getPaddingRight()
            int r14 = r18.getPaddingTop()
            int r15 = r18.getPaddingBottom()
            r0 = 2
            int[] r5 = new int[r0]
            int r1 = r8 - r12
            int r1 = r1 - r13
            int r2 = r6.mOrientation
            r4 = 1
            if (r2 != r4) goto L_0x003a
            int r1 = r10 - r14
            int r1 = r1 - r15
        L_0x003a:
            r16 = r1
            r1 = -1
            if (r2 != 0) goto L_0x004c
            int r2 = r6.mHorizontalStyle
            if (r2 != r1) goto L_0x0045
            r6.mHorizontalStyle = r11
        L_0x0045:
            int r2 = r6.mVerticalStyle
            if (r2 != r1) goto L_0x0058
            r6.mVerticalStyle = r11
            goto L_0x0058
        L_0x004c:
            int r2 = r6.mHorizontalStyle
            if (r2 != r1) goto L_0x0052
            r6.mHorizontalStyle = r11
        L_0x0052:
            int r2 = r6.mVerticalStyle
            if (r2 != r1) goto L_0x0058
            r6.mVerticalStyle = r11
        L_0x0058:
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r1 = r6.mWidgets
            r2 = r11
            r3 = r2
        L_0x005c:
            int r11 = r6.mWidgetsCount
            r0 = 8
            if (r2 >= r11) goto L_0x0072
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r11 = r6.mWidgets
            r11 = r11[r2]
            int r11 = r11.getVisibility()
            if (r11 != r0) goto L_0x006e
            int r3 = r3 + 1
        L_0x006e:
            int r2 = r2 + 1
            r0 = 2
            goto L_0x005c
        L_0x0072:
            if (r3 <= 0) goto L_0x0091
            int r11 = r11 - r3
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r1 = new androidx.constraintlayout.solver.widgets.ConstraintWidget[r11]
            r2 = 0
            r3 = 0
        L_0x0079:
            int r11 = r6.mWidgetsCount
            if (r2 >= r11) goto L_0x008f
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r11 = r6.mWidgets
            r11 = r11[r2]
            int r4 = r11.getVisibility()
            if (r4 == r0) goto L_0x008b
            r1[r3] = r11
            int r3 = r3 + 1
        L_0x008b:
            int r2 = r2 + 1
            r4 = 1
            goto L_0x0079
        L_0x008f:
            r2 = r3
            goto L_0x0092
        L_0x0091:
            r2 = r11
        L_0x0092:
            r6.mDisplayedWidgets = r1
            r6.mDisplayedWidgetsCount = r2
            int r0 = r6.mWrapMode
            if (r0 == 0) goto L_0x00bf
            r4 = 1
            if (r0 == r4) goto L_0x00b2
            r3 = 2
            if (r0 == r3) goto L_0x00a5
            r11 = r4
            r17 = r5
        L_0x00a3:
            r0 = 0
            goto L_0x00cc
        L_0x00a5:
            int r3 = r6.mOrientation
            r0 = r18
            r11 = r4
            r4 = r16
            r17 = r5
            r0.measureAligned(r1, r2, r3, r4, r5)
            goto L_0x00a3
        L_0x00b2:
            r11 = r4
            r17 = r5
            int r3 = r6.mOrientation
            r0 = r18
            r4 = r16
            r0.measureChainWrap(r1, r2, r3, r4, r5)
            goto L_0x00a3
        L_0x00bf:
            r17 = r5
            r11 = 1
            int r3 = r6.mOrientation
            r0 = r18
            r4 = r16
            r0.measureNoWrap(r1, r2, r3, r4, r5)
            goto L_0x00a3
        L_0x00cc:
            r1 = r17[r0]
            int r1 = r1 + r12
            int r1 = r1 + r13
            r2 = r17[r11]
            int r2 = r2 + r14
            int r2 = r2 + r15
            r3 = -2147483648(0xffffffff80000000, float:-0.0)
            r4 = 1073741824(0x40000000, float:2.0)
            if (r7 != r4) goto L_0x00dc
            r1 = r8
            goto L_0x00e7
        L_0x00dc:
            if (r7 != r3) goto L_0x00e3
            int r1 = java.lang.Math.min(r1, r8)
            goto L_0x00e7
        L_0x00e3:
            if (r7 != 0) goto L_0x00e6
            goto L_0x00e7
        L_0x00e6:
            r1 = r0
        L_0x00e7:
            if (r9 != r4) goto L_0x00eb
            r2 = r10
            goto L_0x00f6
        L_0x00eb:
            if (r9 != r3) goto L_0x00f2
            int r2 = java.lang.Math.min(r2, r10)
            goto L_0x00f6
        L_0x00f2:
            if (r9 != 0) goto L_0x00f5
            goto L_0x00f6
        L_0x00f5:
            r2 = r0
        L_0x00f6:
            r6.setMeasure(r1, r2)
            r6.setWidth(r1)
            r6.setHeight(r2)
            int r1 = r6.mWidgetsCount
            if (r1 <= 0) goto L_0x0104
            goto L_0x0105
        L_0x0104:
            r11 = r0
        L_0x0105:
            r6.needsCallbackFromSolver(r11)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.Flow.measure(int, int, int, int):void");
    }

    private class WidgetsList {
        /* access modifiers changed from: private */
        public ConstraintWidget biggest = null;
        int biggestDimension = 0;
        private ConstraintAnchor mBottom;
        private int mCount = 0;
        private int mHeight = 0;
        private ConstraintAnchor mLeft;
        private int mMax = 0;
        private int mNbMatchConstraintsWidgets = 0;
        private int mOrientation;
        private int mPaddingBottom = 0;
        private int mPaddingLeft = 0;
        private int mPaddingRight = 0;
        private int mPaddingTop = 0;
        private ConstraintAnchor mRight;
        private int mStartIndex = 0;
        private ConstraintAnchor mTop;
        private int mWidth = 0;

        public WidgetsList(int i, ConstraintAnchor constraintAnchor, ConstraintAnchor constraintAnchor2, ConstraintAnchor constraintAnchor3, ConstraintAnchor constraintAnchor4, int i2) {
            this.mOrientation = i;
            this.mLeft = constraintAnchor;
            this.mTop = constraintAnchor2;
            this.mRight = constraintAnchor3;
            this.mBottom = constraintAnchor4;
            this.mPaddingLeft = Flow.this.getPaddingLeft();
            this.mPaddingTop = Flow.this.getPaddingTop();
            this.mPaddingRight = Flow.this.getPaddingRight();
            this.mPaddingBottom = Flow.this.getPaddingBottom();
            this.mMax = i2;
        }

        public void setup(int i, ConstraintAnchor constraintAnchor, ConstraintAnchor constraintAnchor2, ConstraintAnchor constraintAnchor3, ConstraintAnchor constraintAnchor4, int i2, int i3, int i4, int i5, int i6) {
            this.mOrientation = i;
            this.mLeft = constraintAnchor;
            this.mTop = constraintAnchor2;
            this.mRight = constraintAnchor3;
            this.mBottom = constraintAnchor4;
            this.mPaddingLeft = i2;
            this.mPaddingTop = i3;
            this.mPaddingRight = i4;
            this.mPaddingBottom = i5;
            this.mMax = i6;
        }

        public void clear() {
            this.biggestDimension = 0;
            this.biggest = null;
            this.mWidth = 0;
            this.mHeight = 0;
            this.mStartIndex = 0;
            this.mCount = 0;
            this.mNbMatchConstraintsWidgets = 0;
        }

        public void setStartIndex(int i) {
            this.mStartIndex = i;
        }

        public int getWidth() {
            if (this.mOrientation == 0) {
                return this.mWidth - Flow.this.mHorizontalGap;
            }
            return this.mWidth;
        }

        public int getHeight() {
            if (this.mOrientation == 1) {
                return this.mHeight - Flow.this.mVerticalGap;
            }
            return this.mHeight;
        }

        public void add(ConstraintWidget constraintWidget) {
            int i = 0;
            if (this.mOrientation == 0) {
                if (constraintWidget.getHorizontalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT) {
                    this.mNbMatchConstraintsWidgets++;
                }
                int access$200 = Flow.this.getWidgetWidth(constraintWidget, this.mMax);
                int access$000 = Flow.this.mHorizontalGap;
                if (constraintWidget.getVisibility() != 8) {
                    i = access$000;
                }
                this.mWidth += access$200 + i;
                int access$300 = Flow.this.getWidgetHeight(constraintWidget, this.mMax);
                if (this.biggest == null || this.biggestDimension < access$300) {
                    this.biggest = constraintWidget;
                    this.biggestDimension = access$300;
                    this.mHeight = access$300;
                }
            } else {
                if (constraintWidget.getVerticalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT) {
                    this.mNbMatchConstraintsWidgets++;
                }
                int access$2002 = Flow.this.getWidgetWidth(constraintWidget, this.mMax);
                int access$3002 = Flow.this.getWidgetHeight(constraintWidget, this.mMax);
                int access$100 = Flow.this.mVerticalGap;
                if (constraintWidget.getVisibility() != 8) {
                    i = access$100;
                }
                this.mHeight += access$3002 + i;
                if (this.biggest == null || this.biggestDimension < access$2002) {
                    this.biggest = constraintWidget;
                    this.biggestDimension = access$2002;
                    this.mWidth = access$2002;
                }
            }
            this.mCount++;
        }

        public void createConstraints(boolean z, int i, boolean z2) {
            ConstraintWidget constraintWidget;
            char c;
            int i2 = this.mCount;
            for (int i3 = 0; i3 < i2; i3++) {
                ConstraintWidget constraintWidget2 = Flow.this.mDisplayedWidgets[this.mStartIndex + i3];
                if (constraintWidget2 != null) {
                    constraintWidget2.resetAnchors();
                }
            }
            if (i2 != 0 && this.biggest != null) {
                boolean z3 = z2 && i == 0;
                int i4 = -1;
                int i5 = -1;
                for (int i6 = 0; i6 < i2; i6++) {
                    if (Flow.this.mDisplayedWidgets[this.mStartIndex + (z ? (i2 - 1) - i6 : i6)].getVisibility() == 0) {
                        if (i4 == -1) {
                            i4 = i6;
                        }
                        i5 = i6;
                    }
                }
                ConstraintWidget constraintWidget3 = null;
                if (this.mOrientation == 0) {
                    ConstraintWidget constraintWidget4 = this.biggest;
                    constraintWidget4.setVerticalChainStyle(Flow.this.mVerticalStyle);
                    int i7 = this.mPaddingTop;
                    if (i > 0) {
                        i7 += Flow.this.mVerticalGap;
                    }
                    constraintWidget4.mTop.connect(this.mTop, i7);
                    if (z2) {
                        constraintWidget4.mBottom.connect(this.mBottom, this.mPaddingBottom);
                    }
                    if (i > 0) {
                        this.mTop.mOwner.mBottom.connect(constraintWidget4.mTop, 0);
                    }
                    if (Flow.this.mVerticalAlign == 3 && !constraintWidget4.hasBaseline()) {
                        int i8 = 0;
                        while (true) {
                            if (i8 >= i2) {
                                break;
                            }
                            constraintWidget = Flow.this.mDisplayedWidgets[this.mStartIndex + (z ? (i2 - 1) - i8 : i8)];
                            if (constraintWidget.hasBaseline()) {
                                break;
                            }
                            i8++;
                        }
                    }
                    constraintWidget = constraintWidget4;
                    int i9 = 0;
                    while (i9 < i2) {
                        int i10 = z ? (i2 - 1) - i9 : i9;
                        ConstraintWidget constraintWidget5 = Flow.this.mDisplayedWidgets[this.mStartIndex + i10];
                        if (i9 == 0) {
                            constraintWidget5.connect(constraintWidget5.mLeft, this.mLeft, this.mPaddingLeft);
                        }
                        if (i10 == 0) {
                            int access$700 = Flow.this.mHorizontalStyle;
                            float access$800 = Flow.this.mHorizontalBias;
                            if (this.mStartIndex == 0 && Flow.this.mFirstHorizontalStyle != -1) {
                                access$700 = Flow.this.mFirstHorizontalStyle;
                                access$800 = Flow.this.mFirstHorizontalBias;
                            } else if (z2 && Flow.this.mLastHorizontalStyle != -1) {
                                access$700 = Flow.this.mLastHorizontalStyle;
                                access$800 = Flow.this.mLastHorizontalBias;
                            }
                            constraintWidget5.setHorizontalChainStyle(access$700);
                            constraintWidget5.setHorizontalBiasPercent(access$800);
                        }
                        if (i9 == i2 - 1) {
                            constraintWidget5.connect(constraintWidget5.mRight, this.mRight, this.mPaddingRight);
                        }
                        if (constraintWidget3 != null) {
                            constraintWidget5.mLeft.connect(constraintWidget3.mRight, Flow.this.mHorizontalGap);
                            if (i9 == i4) {
                                constraintWidget5.mLeft.setGoneMargin(this.mPaddingLeft);
                            }
                            constraintWidget3.mRight.connect(constraintWidget5.mLeft, 0);
                            if (i9 == i5 + 1) {
                                constraintWidget3.mRight.setGoneMargin(this.mPaddingRight);
                            }
                        }
                        if (constraintWidget5 != constraintWidget4) {
                            c = 3;
                            if (Flow.this.mVerticalAlign != 3 || !constraintWidget.hasBaseline() || constraintWidget5 == constraintWidget || !constraintWidget5.hasBaseline()) {
                                int access$600 = Flow.this.mVerticalAlign;
                                if (access$600 == 0) {
                                    constraintWidget5.mTop.connect(constraintWidget4.mTop, 0);
                                } else if (access$600 == 1) {
                                    constraintWidget5.mBottom.connect(constraintWidget4.mBottom, 0);
                                } else if (z3) {
                                    constraintWidget5.mTop.connect(this.mTop, this.mPaddingTop);
                                    constraintWidget5.mBottom.connect(this.mBottom, this.mPaddingBottom);
                                } else {
                                    constraintWidget5.mTop.connect(constraintWidget4.mTop, 0);
                                    constraintWidget5.mBottom.connect(constraintWidget4.mBottom, 0);
                                }
                            } else {
                                constraintWidget5.mBaseline.connect(constraintWidget.mBaseline, 0);
                            }
                        } else {
                            c = 3;
                        }
                        i9++;
                        char c2 = c;
                        constraintWidget3 = constraintWidget5;
                    }
                    return;
                }
                ConstraintWidget constraintWidget6 = this.biggest;
                constraintWidget6.setHorizontalChainStyle(Flow.this.mHorizontalStyle);
                int i11 = this.mPaddingLeft;
                if (i > 0) {
                    i11 += Flow.this.mHorizontalGap;
                }
                if (z) {
                    constraintWidget6.mRight.connect(this.mRight, i11);
                    if (z2) {
                        constraintWidget6.mLeft.connect(this.mLeft, this.mPaddingRight);
                    }
                    if (i > 0) {
                        this.mRight.mOwner.mLeft.connect(constraintWidget6.mRight, 0);
                    }
                } else {
                    constraintWidget6.mLeft.connect(this.mLeft, i11);
                    if (z2) {
                        constraintWidget6.mRight.connect(this.mRight, this.mPaddingRight);
                    }
                    if (i > 0) {
                        this.mLeft.mOwner.mRight.connect(constraintWidget6.mLeft, 0);
                    }
                }
                int i12 = 0;
                while (i12 < i2) {
                    ConstraintWidget constraintWidget7 = Flow.this.mDisplayedWidgets[this.mStartIndex + i12];
                    if (i12 == 0) {
                        constraintWidget7.connect(constraintWidget7.mTop, this.mTop, this.mPaddingTop);
                        int access$500 = Flow.this.mVerticalStyle;
                        float access$1300 = Flow.this.mVerticalBias;
                        if (this.mStartIndex == 0 && Flow.this.mFirstVerticalStyle != -1) {
                            access$500 = Flow.this.mFirstVerticalStyle;
                            access$1300 = Flow.this.mFirstVerticalBias;
                        } else if (z2 && Flow.this.mLastVerticalStyle != -1) {
                            access$500 = Flow.this.mLastVerticalStyle;
                            access$1300 = Flow.this.mLastVerticalBias;
                        }
                        constraintWidget7.setVerticalChainStyle(access$500);
                        constraintWidget7.setVerticalBiasPercent(access$1300);
                    }
                    if (i12 == i2 - 1) {
                        constraintWidget7.connect(constraintWidget7.mBottom, this.mBottom, this.mPaddingBottom);
                    }
                    if (constraintWidget3 != null) {
                        constraintWidget7.mTop.connect(constraintWidget3.mBottom, Flow.this.mVerticalGap);
                        if (i12 == i4) {
                            constraintWidget7.mTop.setGoneMargin(this.mPaddingTop);
                        }
                        constraintWidget3.mBottom.connect(constraintWidget7.mTop, 0);
                        if (i12 == i5 + 1) {
                            constraintWidget3.mBottom.setGoneMargin(this.mPaddingBottom);
                        }
                    }
                    if (constraintWidget7 != constraintWidget6) {
                        if (z) {
                            int access$1800 = Flow.this.mHorizontalAlign;
                            if (access$1800 == 0) {
                                constraintWidget7.mRight.connect(constraintWidget6.mRight, 0);
                            } else if (access$1800 == 1) {
                                constraintWidget7.mLeft.connect(constraintWidget6.mLeft, 0);
                            } else if (access$1800 == 2) {
                                constraintWidget7.mLeft.connect(constraintWidget6.mLeft, 0);
                                constraintWidget7.mRight.connect(constraintWidget6.mRight, 0);
                            }
                        } else {
                            int access$18002 = Flow.this.mHorizontalAlign;
                            if (access$18002 == 0) {
                                constraintWidget7.mLeft.connect(constraintWidget6.mLeft, 0);
                            } else if (access$18002 == 1) {
                                constraintWidget7.mRight.connect(constraintWidget6.mRight, 0);
                            } else if (access$18002 == 2) {
                                if (z3) {
                                    constraintWidget7.mLeft.connect(this.mLeft, this.mPaddingLeft);
                                    constraintWidget7.mRight.connect(this.mRight, this.mPaddingRight);
                                } else {
                                    constraintWidget7.mLeft.connect(constraintWidget6.mLeft, 0);
                                    constraintWidget7.mRight.connect(constraintWidget6.mRight, 0);
                                }
                            }
                            i12++;
                            constraintWidget3 = constraintWidget7;
                        }
                    }
                    i12++;
                    constraintWidget3 = constraintWidget7;
                }
            }
        }

        public void measureMatchConstraints(int i) {
            int i2 = this.mNbMatchConstraintsWidgets;
            if (i2 != 0) {
                int i3 = this.mCount;
                int i4 = i / i2;
                for (int i5 = 0; i5 < i3; i5++) {
                    ConstraintWidget constraintWidget = Flow.this.mDisplayedWidgets[this.mStartIndex + i5];
                    if (this.mOrientation == 0) {
                        if (constraintWidget != null && constraintWidget.getHorizontalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT) {
                            Flow.this.measure(constraintWidget, ConstraintWidget.DimensionBehaviour.FIXED, i4, constraintWidget.getVerticalDimensionBehaviour(), constraintWidget.getHeight());
                        }
                    } else if (constraintWidget != null && constraintWidget.getVerticalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT) {
                        Flow.this.measure(constraintWidget, constraintWidget.getHorizontalDimensionBehaviour(), constraintWidget.getWidth(), ConstraintWidget.DimensionBehaviour.FIXED, i4);
                    }
                }
                recomputeDimensions();
            }
        }

        private void recomputeDimensions() {
            this.mWidth = 0;
            this.mHeight = 0;
            this.biggest = null;
            this.biggestDimension = 0;
            int i = this.mCount;
            for (int i2 = 0; i2 < i; i2++) {
                ConstraintWidget constraintWidget = Flow.this.mDisplayedWidgets[this.mStartIndex + i2];
                if (this.mOrientation == 0) {
                    int width = constraintWidget.getWidth();
                    int access$000 = Flow.this.mHorizontalGap;
                    if (constraintWidget.getVisibility() == 8) {
                        access$000 = 0;
                    }
                    this.mWidth += width + access$000;
                    int access$300 = Flow.this.getWidgetHeight(constraintWidget, this.mMax);
                    if (this.biggest == null || this.biggestDimension < access$300) {
                        this.biggest = constraintWidget;
                        this.biggestDimension = access$300;
                        this.mHeight = access$300;
                    }
                } else {
                    int access$200 = Flow.this.getWidgetWidth(constraintWidget, this.mMax);
                    int access$3002 = Flow.this.getWidgetHeight(constraintWidget, this.mMax);
                    int access$100 = Flow.this.mVerticalGap;
                    if (constraintWidget.getVisibility() == 8) {
                        access$100 = 0;
                    }
                    this.mHeight += access$3002 + access$100;
                    if (this.biggest == null || this.biggestDimension < access$200) {
                        this.biggest = constraintWidget;
                        this.biggestDimension = access$200;
                        this.mWidth = access$200;
                    }
                }
            }
        }
    }

    private void measureChainWrap(ConstraintWidget[] constraintWidgetArr, int i, int i2, int i3, int[] iArr) {
        int i4;
        ConstraintAnchor constraintAnchor;
        int i5;
        int i6;
        int i7;
        ConstraintAnchor constraintAnchor2;
        int i8;
        int i9;
        int i10 = i;
        int i11 = i3;
        if (i10 != 0) {
            this.mChainList.clear();
            WidgetsList widgetsList = new WidgetsList(i2, this.mLeft, this.mTop, this.mRight, this.mBottom, i3);
            this.mChainList.add(widgetsList);
            if (i2 == 0) {
                i4 = 0;
                int i12 = 0;
                int i13 = 0;
                while (i13 < i10) {
                    ConstraintWidget constraintWidget = constraintWidgetArr[i13];
                    int widgetWidth = getWidgetWidth(constraintWidget, i11);
                    if (constraintWidget.getHorizontalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT) {
                        i4++;
                    }
                    int i14 = i4;
                    boolean z = (this.mHorizontalGap + i12) + widgetWidth > i11 && widgetsList.biggest != null;
                    if (!z && i13 > 0 && (i9 = this.mMaxElementsWrap) > 0 && i13 % i9 == 0) {
                        z = true;
                    }
                    if (z) {
                        widgetsList = new WidgetsList(i2, this.mLeft, this.mTop, this.mRight, this.mBottom, i3);
                        widgetsList.setStartIndex(i13);
                        this.mChainList.add(widgetsList);
                    } else if (i13 > 0) {
                        i12 += this.mHorizontalGap + widgetWidth;
                        widgetsList.add(constraintWidget);
                        i13++;
                        i4 = i14;
                    }
                    i12 = widgetWidth;
                    widgetsList.add(constraintWidget);
                    i13++;
                    i4 = i14;
                }
            } else {
                int i15 = 0;
                int i16 = 0;
                int i17 = 0;
                while (i17 < i10) {
                    ConstraintWidget constraintWidget2 = constraintWidgetArr[i17];
                    int widgetHeight = getWidgetHeight(constraintWidget2, i11);
                    if (constraintWidget2.getVerticalDimensionBehaviour() == ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT) {
                        i4++;
                    }
                    int i18 = i4;
                    boolean z2 = (this.mVerticalGap + i16) + widgetHeight > i11 && widgetsList.biggest != null;
                    if (!z2 && i17 > 0 && (i8 = this.mMaxElementsWrap) > 0 && i17 % i8 == 0) {
                        z2 = true;
                    }
                    if (z2) {
                        widgetsList = new WidgetsList(i2, this.mLeft, this.mTop, this.mRight, this.mBottom, i3);
                        widgetsList.setStartIndex(i17);
                        this.mChainList.add(widgetsList);
                    } else if (i17 > 0) {
                        i16 += this.mVerticalGap + widgetHeight;
                        widgetsList.add(constraintWidget2);
                        i17++;
                        i15 = i18;
                    }
                    i16 = widgetHeight;
                    widgetsList.add(constraintWidget2);
                    i17++;
                    i15 = i18;
                }
            }
            int size = this.mChainList.size();
            ConstraintAnchor constraintAnchor3 = this.mLeft;
            ConstraintAnchor constraintAnchor4 = this.mTop;
            ConstraintAnchor constraintAnchor5 = this.mRight;
            ConstraintAnchor constraintAnchor6 = this.mBottom;
            int paddingLeft = getPaddingLeft();
            int paddingTop = getPaddingTop();
            int paddingRight = getPaddingRight();
            int paddingBottom = getPaddingBottom();
            ConstraintWidget.DimensionBehaviour horizontalDimensionBehaviour = getHorizontalDimensionBehaviour();
            ConstraintWidget.DimensionBehaviour dimensionBehaviour = ConstraintWidget.DimensionBehaviour.WRAP_CONTENT;
            boolean z3 = horizontalDimensionBehaviour == dimensionBehaviour || getVerticalDimensionBehaviour() == dimensionBehaviour;
            if (i4 > 0 && z3) {
                for (int i19 = 0; i19 < size; i19++) {
                    WidgetsList widgetsList2 = this.mChainList.get(i19);
                    if (i2 == 0) {
                        widgetsList2.measureMatchConstraints(i11 - widgetsList2.getWidth());
                    } else {
                        widgetsList2.measureMatchConstraints(i11 - widgetsList2.getHeight());
                    }
                }
            }
            int i20 = paddingTop;
            int i21 = paddingRight;
            int i22 = 0;
            int i23 = 0;
            int i24 = 0;
            int i25 = paddingLeft;
            ConstraintAnchor constraintAnchor7 = constraintAnchor4;
            ConstraintAnchor constraintAnchor8 = constraintAnchor3;
            int i26 = paddingBottom;
            while (i24 < size) {
                WidgetsList widgetsList3 = this.mChainList.get(i24);
                if (i2 == 0) {
                    if (i24 < size - 1) {
                        constraintAnchor2 = this.mChainList.get(i24 + 1).biggest.mTop;
                        i7 = 0;
                    } else {
                        constraintAnchor2 = this.mBottom;
                        i7 = getPaddingBottom();
                    }
                    ConstraintAnchor constraintAnchor9 = widgetsList3.biggest.mBottom;
                    ConstraintAnchor constraintAnchor10 = constraintAnchor8;
                    ConstraintAnchor constraintAnchor11 = constraintAnchor8;
                    int i27 = i22;
                    ConstraintAnchor constraintAnchor12 = constraintAnchor7;
                    int i28 = i23;
                    ConstraintAnchor constraintAnchor13 = constraintAnchor5;
                    ConstraintAnchor constraintAnchor14 = constraintAnchor5;
                    i5 = i24;
                    widgetsList3.setup(i2, constraintAnchor10, constraintAnchor12, constraintAnchor13, constraintAnchor2, i25, i20, i21, i7, i3);
                    int max = Math.max(i28, widgetsList3.getWidth());
                    i22 = i27 + widgetsList3.getHeight();
                    if (i5 > 0) {
                        i22 += this.mVerticalGap;
                    }
                    constraintAnchor8 = constraintAnchor11;
                    i23 = max;
                    i20 = 0;
                    constraintAnchor7 = constraintAnchor9;
                    constraintAnchor = constraintAnchor14;
                    int i29 = i7;
                    constraintAnchor6 = constraintAnchor2;
                    i26 = i29;
                } else {
                    ConstraintAnchor constraintAnchor15 = constraintAnchor8;
                    int i30 = i22;
                    int i31 = i23;
                    i5 = i24;
                    if (i5 < size - 1) {
                        constraintAnchor = this.mChainList.get(i5 + 1).biggest.mLeft;
                        i6 = 0;
                    } else {
                        constraintAnchor = this.mRight;
                        i6 = getPaddingRight();
                    }
                    ConstraintAnchor constraintAnchor16 = widgetsList3.biggest.mRight;
                    widgetsList3.setup(i2, constraintAnchor15, constraintAnchor7, constraintAnchor, constraintAnchor6, i25, i20, i6, i26, i3);
                    i23 = i31 + widgetsList3.getWidth();
                    int max2 = Math.max(i30, widgetsList3.getHeight());
                    if (i5 > 0) {
                        i23 += this.mHorizontalGap;
                    }
                    i22 = max2;
                    i25 = 0;
                    i21 = i6;
                    constraintAnchor8 = constraintAnchor16;
                }
                i24 = i5 + 1;
                int i32 = i3;
                constraintAnchor5 = constraintAnchor;
            }
            iArr[0] = i23;
            iArr[1] = i22;
        }
    }

    private void measureNoWrap(ConstraintWidget[] constraintWidgetArr, int i, int i2, int i3, int[] iArr) {
        WidgetsList widgetsList;
        int i4 = i;
        if (i4 != 0) {
            if (this.mChainList.size() == 0) {
                widgetsList = new WidgetsList(i2, this.mLeft, this.mTop, this.mRight, this.mBottom, i3);
                this.mChainList.add(widgetsList);
            } else {
                WidgetsList widgetsList2 = this.mChainList.get(0);
                widgetsList2.clear();
                widgetsList = widgetsList2;
                widgetsList.setup(i2, this.mLeft, this.mTop, this.mRight, this.mBottom, getPaddingLeft(), getPaddingTop(), getPaddingRight(), getPaddingBottom(), i3);
            }
            for (int i5 = 0; i5 < i4; i5++) {
                widgetsList.add(constraintWidgetArr[i5]);
            }
            iArr[0] = widgetsList.getWidth();
            iArr[1] = widgetsList.getHeight();
        }
    }

    /*  JADX ERROR: JadxOverflowException in pass: RegionMakerVisitor
        jadx.core.utils.exceptions.JadxOverflowException: Regions count limit reached
        	at jadx.core.utils.ErrorsCounter.addError(ErrorsCounter.java:47)
        	at jadx.core.utils.ErrorsCounter.methodError(ErrorsCounter.java:81)
        */
    /* JADX WARNING: Removed duplicated region for block: B:116:0x011d A[SYNTHETIC] */
    /* JADX WARNING: Removed duplicated region for block: B:39:0x005e  */
    private void measureAligned(androidx.constraintlayout.solver.widgets.ConstraintWidget[] r11, int r12, int r13, int r14, int[] r15) {
        /*
            r10 = this;
            r0 = 0
            if (r13 != 0) goto L_0x0026
            int r1 = r10.mMaxElementsWrap
            if (r1 > 0) goto L_0x0023
            r1 = r0
            r2 = r1
            r3 = r2
        L_0x000a:
            if (r2 >= r12) goto L_0x0023
            if (r2 <= 0) goto L_0x0011
            int r4 = r10.mHorizontalGap
            int r3 = r3 + r4
        L_0x0011:
            r4 = r11[r2]
            if (r4 != 0) goto L_0x0016
            goto L_0x0020
        L_0x0016:
            int r4 = r10.getWidgetWidth(r4, r14)
            int r3 = r3 + r4
            if (r3 <= r14) goto L_0x001e
            goto L_0x0023
        L_0x001e:
            int r1 = r1 + 1
        L_0x0020:
            int r2 = r2 + 1
            goto L_0x000a
        L_0x0023:
            r2 = r1
            r1 = r0
            goto L_0x0047
        L_0x0026:
            int r1 = r10.mMaxElementsWrap
            if (r1 > 0) goto L_0x0046
            r1 = r0
            r2 = r1
            r3 = r2
        L_0x002d:
            if (r2 >= r12) goto L_0x0046
            if (r2 <= 0) goto L_0x0034
            int r4 = r10.mVerticalGap
            int r3 = r3 + r4
        L_0x0034:
            r4 = r11[r2]
            if (r4 != 0) goto L_0x0039
            goto L_0x0043
        L_0x0039:
            int r4 = r10.getWidgetHeight(r4, r14)
            int r3 = r3 + r4
            if (r3 <= r14) goto L_0x0041
            goto L_0x0046
        L_0x0041:
            int r1 = r1 + 1
        L_0x0043:
            int r2 = r2 + 1
            goto L_0x002d
        L_0x0046:
            r2 = r0
        L_0x0047:
            int[] r3 = r10.mAlignedDimensions
            if (r3 != 0) goto L_0x0050
            r3 = 2
            int[] r3 = new int[r3]
            r10.mAlignedDimensions = r3
        L_0x0050:
            r3 = 1
            if (r1 != 0) goto L_0x0055
            if (r13 == r3) goto L_0x0059
        L_0x0055:
            if (r2 != 0) goto L_0x005b
            if (r13 != 0) goto L_0x005b
        L_0x0059:
            r4 = r3
            goto L_0x005c
        L_0x005b:
            r4 = r0
        L_0x005c:
            if (r4 != 0) goto L_0x011d
            if (r13 != 0) goto L_0x006a
            float r1 = (float) r12
            float r5 = (float) r2
            float r1 = r1 / r5
            double r5 = (double) r1
            double r5 = java.lang.Math.ceil(r5)
            int r1 = (int) r5
            goto L_0x0073
        L_0x006a:
            float r2 = (float) r12
            float r5 = (float) r1
            float r2 = r2 / r5
            double r5 = (double) r2
            double r5 = java.lang.Math.ceil(r5)
            int r2 = (int) r5
        L_0x0073:
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r5 = r10.mAlignedBiggestElementsInCols
            r6 = 0
            if (r5 == 0) goto L_0x0080
            int r7 = r5.length
            if (r7 >= r2) goto L_0x007c
            goto L_0x0080
        L_0x007c:
            java.util.Arrays.fill(r5, r6)
            goto L_0x0084
        L_0x0080:
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r5 = new androidx.constraintlayout.solver.widgets.ConstraintWidget[r2]
            r10.mAlignedBiggestElementsInCols = r5
        L_0x0084:
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r5 = r10.mAlignedBiggestElementsInRows
            if (r5 == 0) goto L_0x0090
            int r7 = r5.length
            if (r7 >= r1) goto L_0x008c
            goto L_0x0090
        L_0x008c:
            java.util.Arrays.fill(r5, r6)
            goto L_0x0094
        L_0x0090:
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r5 = new androidx.constraintlayout.solver.widgets.ConstraintWidget[r1]
            r10.mAlignedBiggestElementsInRows = r5
        L_0x0094:
            r5 = r0
        L_0x0095:
            if (r5 >= r2) goto L_0x00d9
            r6 = r0
        L_0x0098:
            if (r6 >= r1) goto L_0x00d6
            int r7 = r6 * r2
            int r7 = r7 + r5
            if (r13 != r3) goto L_0x00a2
            int r7 = r5 * r1
            int r7 = r7 + r6
        L_0x00a2:
            int r8 = r11.length
            if (r7 < r8) goto L_0x00a6
            goto L_0x00d3
        L_0x00a6:
            r7 = r11[r7]
            if (r7 != 0) goto L_0x00ab
            goto L_0x00d3
        L_0x00ab:
            int r8 = r10.getWidgetWidth(r7, r14)
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r9 = r10.mAlignedBiggestElementsInCols
            r9 = r9[r5]
            if (r9 == 0) goto L_0x00bb
            int r9 = r9.getWidth()
            if (r9 >= r8) goto L_0x00bf
        L_0x00bb:
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r8 = r10.mAlignedBiggestElementsInCols
            r8[r5] = r7
        L_0x00bf:
            int r8 = r10.getWidgetHeight(r7, r14)
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r9 = r10.mAlignedBiggestElementsInRows
            r9 = r9[r6]
            if (r9 == 0) goto L_0x00cf
            int r9 = r9.getHeight()
            if (r9 >= r8) goto L_0x00d3
        L_0x00cf:
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r8 = r10.mAlignedBiggestElementsInRows
            r8[r6] = r7
        L_0x00d3:
            int r6 = r6 + 1
            goto L_0x0098
        L_0x00d6:
            int r5 = r5 + 1
            goto L_0x0095
        L_0x00d9:
            r5 = r0
            r6 = r5
        L_0x00db:
            if (r5 >= r2) goto L_0x00f0
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r7 = r10.mAlignedBiggestElementsInCols
            r7 = r7[r5]
            if (r7 == 0) goto L_0x00ed
            if (r5 <= 0) goto L_0x00e8
            int r8 = r10.mHorizontalGap
            int r6 = r6 + r8
        L_0x00e8:
            int r7 = r10.getWidgetWidth(r7, r14)
            int r6 = r6 + r7
        L_0x00ed:
            int r5 = r5 + 1
            goto L_0x00db
        L_0x00f0:
            r5 = r0
            r7 = r5
        L_0x00f2:
            if (r5 >= r1) goto L_0x0107
            androidx.constraintlayout.solver.widgets.ConstraintWidget[] r8 = r10.mAlignedBiggestElementsInRows
            r8 = r8[r5]
            if (r8 == 0) goto L_0x0104
            if (r5 <= 0) goto L_0x00ff
            int r9 = r10.mVerticalGap
            int r7 = r7 + r9
        L_0x00ff:
            int r8 = r10.getWidgetHeight(r8, r14)
            int r7 = r7 + r8
        L_0x0104:
            int r5 = r5 + 1
            goto L_0x00f2
        L_0x0107:
            r15[r0] = r6
            r15[r3] = r7
            if (r13 != 0) goto L_0x0115
            if (r6 <= r14) goto L_0x0059
            if (r2 <= r3) goto L_0x0059
            int r2 = r2 + -1
            goto L_0x005c
        L_0x0115:
            if (r7 <= r14) goto L_0x0059
            if (r1 <= r3) goto L_0x0059
            int r1 = r1 + -1
            goto L_0x005c
        L_0x011d:
            int[] r10 = r10.mAlignedDimensions
            r10[r0] = r2
            r10[r3] = r1
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.Flow.measureAligned(androidx.constraintlayout.solver.widgets.ConstraintWidget[], int, int, int, int[]):void");
    }

    private void createAlignedConstraints(boolean z) {
        ConstraintWidget constraintWidget;
        if (this.mAlignedDimensions != null && this.mAlignedBiggestElementsInCols != null && this.mAlignedBiggestElementsInRows != null) {
            for (int i = 0; i < this.mDisplayedWidgetsCount; i++) {
                this.mDisplayedWidgets[i].resetAnchors();
            }
            int[] iArr = this.mAlignedDimensions;
            int i2 = iArr[0];
            int i3 = iArr[1];
            ConstraintWidget constraintWidget2 = null;
            for (int i4 = 0; i4 < i2; i4++) {
                ConstraintWidget constraintWidget3 = this.mAlignedBiggestElementsInCols[z ? (i2 - i4) - 1 : i4];
                if (!(constraintWidget3 == null || constraintWidget3.getVisibility() == 8)) {
                    if (i4 == 0) {
                        constraintWidget3.connect(constraintWidget3.mLeft, this.mLeft, getPaddingLeft());
                        constraintWidget3.setHorizontalChainStyle(this.mHorizontalStyle);
                        constraintWidget3.setHorizontalBiasPercent(this.mHorizontalBias);
                    }
                    if (i4 == i2 - 1) {
                        constraintWidget3.connect(constraintWidget3.mRight, this.mRight, getPaddingRight());
                    }
                    if (i4 > 0) {
                        constraintWidget3.connect(constraintWidget3.mLeft, constraintWidget2.mRight, this.mHorizontalGap);
                        constraintWidget2.connect(constraintWidget2.mRight, constraintWidget3.mLeft, 0);
                    }
                    constraintWidget2 = constraintWidget3;
                }
            }
            for (int i5 = 0; i5 < i3; i5++) {
                ConstraintWidget constraintWidget4 = this.mAlignedBiggestElementsInRows[i5];
                if (!(constraintWidget4 == null || constraintWidget4.getVisibility() == 8)) {
                    if (i5 == 0) {
                        constraintWidget4.connect(constraintWidget4.mTop, this.mTop, getPaddingTop());
                        constraintWidget4.setVerticalChainStyle(this.mVerticalStyle);
                        constraintWidget4.setVerticalBiasPercent(this.mVerticalBias);
                    }
                    if (i5 == i3 - 1) {
                        constraintWidget4.connect(constraintWidget4.mBottom, this.mBottom, getPaddingBottom());
                    }
                    if (i5 > 0) {
                        constraintWidget4.connect(constraintWidget4.mTop, constraintWidget2.mBottom, this.mVerticalGap);
                        constraintWidget2.connect(constraintWidget2.mBottom, constraintWidget4.mTop, 0);
                    }
                    constraintWidget2 = constraintWidget4;
                }
            }
            for (int i6 = 0; i6 < i2; i6++) {
                for (int i7 = 0; i7 < i3; i7++) {
                    int i8 = (i7 * i2) + i6;
                    if (this.mOrientation == 1) {
                        i8 = (i6 * i3) + i7;
                    }
                    ConstraintWidget[] constraintWidgetArr = this.mDisplayedWidgets;
                    if (!(i8 >= constraintWidgetArr.length || (constraintWidget = constraintWidgetArr[i8]) == null || constraintWidget.getVisibility() == 8)) {
                        ConstraintWidget constraintWidget5 = this.mAlignedBiggestElementsInCols[i6];
                        ConstraintWidget constraintWidget6 = this.mAlignedBiggestElementsInRows[i7];
                        if (constraintWidget != constraintWidget5) {
                            constraintWidget.connect(constraintWidget.mLeft, constraintWidget5.mLeft, 0);
                            constraintWidget.connect(constraintWidget.mRight, constraintWidget5.mRight, 0);
                        }
                        if (constraintWidget != constraintWidget6) {
                            constraintWidget.connect(constraintWidget.mTop, constraintWidget6.mTop, 0);
                            constraintWidget.connect(constraintWidget.mBottom, constraintWidget6.mBottom, 0);
                        }
                    }
                }
            }
        }
    }

    public void addToSolver(LinearSystem linearSystem) {
        super.addToSolver(linearSystem);
        boolean isRtl = getParent() != null ? ((ConstraintWidgetContainer) getParent()).isRtl() : false;
        int i = this.mWrapMode;
        if (i != 0) {
            if (i == 1) {
                int size = this.mChainList.size();
                int i2 = 0;
                while (i2 < size) {
                    this.mChainList.get(i2).createConstraints(isRtl, i2, i2 == size + -1);
                    i2++;
                }
            } else if (i == 2) {
                createAlignedConstraints(isRtl);
            }
        } else if (this.mChainList.size() > 0) {
            this.mChainList.get(0).createConstraints(isRtl, 0, true);
        }
        needsCallbackFromSolver(false);
    }
}
