package androidx.constraintlayout.solver.widgets;

import androidx.constraintlayout.solver.Cache;
import androidx.constraintlayout.solver.LinearSystem;
import androidx.constraintlayout.solver.SolverVariable;
import androidx.constraintlayout.solver.widgets.ConstraintAnchor;
import androidx.constraintlayout.solver.widgets.analyzer.ChainRun;
import androidx.constraintlayout.solver.widgets.analyzer.DependencyNode;
import androidx.constraintlayout.solver.widgets.analyzer.HorizontalWidgetRun;
import androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun;
import androidx.constraintlayout.solver.widgets.analyzer.WidgetRun;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class ConstraintWidget {
    public static final int ANCHOR_BASELINE = 4;
    public static final int ANCHOR_BOTTOM = 3;
    public static final int ANCHOR_LEFT = 0;
    public static final int ANCHOR_RIGHT = 1;
    public static final int ANCHOR_TOP = 2;
    private static final boolean AUTOTAG_CENTER = false;
    public static final int CHAIN_PACKED = 2;
    public static final int CHAIN_SPREAD = 0;
    public static final int CHAIN_SPREAD_INSIDE = 1;
    public static float DEFAULT_BIAS = 0.5f;
    static final int DIMENSION_HORIZONTAL = 0;
    static final int DIMENSION_VERTICAL = 1;
    protected static final int DIRECT = 2;
    public static final int GONE = 8;
    public static final int HORIZONTAL = 0;
    public static final int INVISIBLE = 4;
    public static final int MATCH_CONSTRAINT_PERCENT = 2;
    public static final int MATCH_CONSTRAINT_RATIO = 3;
    public static final int MATCH_CONSTRAINT_RATIO_RESOLVED = 4;
    public static final int MATCH_CONSTRAINT_SPREAD = 0;
    public static final int MATCH_CONSTRAINT_WRAP = 1;
    protected static final int SOLVER = 1;
    public static final int UNKNOWN = -1;
    public static final int VERTICAL = 1;
    public static final int VISIBLE = 0;
    private static final int WRAP = -2;
    private boolean hasBaseline;
    public ChainRun horizontalChainRun;
    public HorizontalWidgetRun horizontalRun;
    private boolean inPlaceholder;
    public boolean[] isTerminalWidget;
    protected ArrayList<ConstraintAnchor> mAnchors;
    ConstraintAnchor mBaseline;
    int mBaselineDistance;
    public ConstraintAnchor mBottom;
    boolean mBottomHasCentered;
    ConstraintAnchor mCenter;
    ConstraintAnchor mCenterX;
    ConstraintAnchor mCenterY;
    private float mCircleConstraintAngle;
    private Object mCompanionWidget;
    private int mContainerItemSkip;
    private String mDebugName;
    public float mDimensionRatio;
    protected int mDimensionRatioSide;
    int mDistToBottom;
    int mDistToLeft;
    int mDistToRight;
    int mDistToTop;
    boolean mGroupsToSolver;
    int mHeight;
    float mHorizontalBiasPercent;
    boolean mHorizontalChainFixedPosition;
    int mHorizontalChainStyle;
    ConstraintWidget mHorizontalNextWidget;
    public int mHorizontalResolution;
    boolean mHorizontalWrapVisited;
    private boolean mInVirtuaLayout;
    public boolean mIsHeightWrapContent;
    public boolean mIsWidthWrapContent;
    public ConstraintAnchor mLeft;
    boolean mLeftHasCentered;
    public ConstraintAnchor[] mListAnchors;
    public DimensionBehaviour[] mListDimensionBehaviors;
    protected ConstraintWidget[] mListNextMatchConstraintsWidget;
    public int mMatchConstraintDefaultHeight;
    public int mMatchConstraintDefaultWidth;
    public int mMatchConstraintMaxHeight;
    public int mMatchConstraintMaxWidth;
    public int mMatchConstraintMinHeight;
    public int mMatchConstraintMinWidth;
    public float mMatchConstraintPercentHeight;
    public float mMatchConstraintPercentWidth;
    private int[] mMaxDimension;
    protected int mMinHeight;
    protected int mMinWidth;
    protected ConstraintWidget[] mNextChainWidget;
    protected int mOffsetX;
    protected int mOffsetY;
    boolean mOptimizerMeasurable;
    public ConstraintWidget mParent;
    int mRelX;
    int mRelY;
    float mResolvedDimensionRatio;
    int mResolvedDimensionRatioSide;
    boolean mResolvedHasRatio;
    public int[] mResolvedMatchConstraintDefault;
    public ConstraintAnchor mRight;
    boolean mRightHasCentered;
    public ConstraintAnchor mTop;
    boolean mTopHasCentered;
    private String mType;
    float mVerticalBiasPercent;
    boolean mVerticalChainFixedPosition;
    int mVerticalChainStyle;
    ConstraintWidget mVerticalNextWidget;
    public int mVerticalResolution;
    boolean mVerticalWrapVisited;
    private int mVisibility;
    public float[] mWeight;
    int mWidth;
    protected int mX;
    protected int mY;
    public boolean measured;
    public WidgetRun[] run;
    public ChainRun verticalChainRun;
    public VerticalWidgetRun verticalRun;
    public int[] wrapMeasure;

    public enum DimensionBehaviour {
        FIXED,
        WRAP_CONTENT,
        MATCH_CONSTRAINT,
        MATCH_PARENT
    }

    public WidgetRun getRun(int i) {
        if (i == 0) {
            return this.horizontalRun;
        }
        if (i == 1) {
            return this.verticalRun;
        }
        return null;
    }

    public boolean isInVirtualLayout() {
        return this.mInVirtuaLayout;
    }

    public void setInVirtualLayout(boolean z) {
        this.mInVirtuaLayout = z;
    }

    public int getMaxHeight() {
        return this.mMaxDimension[1];
    }

    public int getMaxWidth() {
        return this.mMaxDimension[0];
    }

    public void setMaxWidth(int i) {
        this.mMaxDimension[0] = i;
    }

    public void setMaxHeight(int i) {
        this.mMaxDimension[1] = i;
    }

    public boolean isSpreadWidth() {
        return this.mMatchConstraintDefaultWidth == 0 && this.mDimensionRatio == 0.0f && this.mMatchConstraintMinWidth == 0 && this.mMatchConstraintMaxWidth == 0 && this.mListDimensionBehaviors[0] == DimensionBehaviour.MATCH_CONSTRAINT;
    }

    public boolean isSpreadHeight() {
        return this.mMatchConstraintDefaultHeight == 0 && this.mDimensionRatio == 0.0f && this.mMatchConstraintMinHeight == 0 && this.mMatchConstraintMaxHeight == 0 && this.mListDimensionBehaviors[1] == DimensionBehaviour.MATCH_CONSTRAINT;
    }

    public void setHasBaseline(boolean z) {
        this.hasBaseline = z;
    }

    public boolean getHasBaseline() {
        return this.hasBaseline;
    }

    public boolean isInPlaceholder() {
        return this.inPlaceholder;
    }

    public void setInPlaceholder(boolean z) {
        this.inPlaceholder = z;
    }

    public void reset() {
        this.mLeft.reset();
        this.mTop.reset();
        this.mRight.reset();
        this.mBottom.reset();
        this.mBaseline.reset();
        this.mCenterX.reset();
        this.mCenterY.reset();
        this.mCenter.reset();
        this.mParent = null;
        this.mCircleConstraintAngle = 0.0f;
        this.mWidth = 0;
        this.mHeight = 0;
        this.mDimensionRatio = 0.0f;
        this.mDimensionRatioSide = -1;
        this.mX = 0;
        this.mY = 0;
        this.mOffsetX = 0;
        this.mOffsetY = 0;
        this.mBaselineDistance = 0;
        this.mMinWidth = 0;
        this.mMinHeight = 0;
        float f = DEFAULT_BIAS;
        this.mHorizontalBiasPercent = f;
        this.mVerticalBiasPercent = f;
        DimensionBehaviour[] dimensionBehaviourArr = this.mListDimensionBehaviors;
        DimensionBehaviour dimensionBehaviour = DimensionBehaviour.FIXED;
        dimensionBehaviourArr[0] = dimensionBehaviour;
        dimensionBehaviourArr[1] = dimensionBehaviour;
        this.mCompanionWidget = null;
        this.mContainerItemSkip = 0;
        this.mVisibility = 0;
        this.mType = null;
        this.mHorizontalWrapVisited = false;
        this.mVerticalWrapVisited = false;
        this.mHorizontalChainStyle = 0;
        this.mVerticalChainStyle = 0;
        this.mHorizontalChainFixedPosition = false;
        this.mVerticalChainFixedPosition = false;
        float[] fArr = this.mWeight;
        fArr[0] = -1.0f;
        fArr[1] = -1.0f;
        this.mHorizontalResolution = -1;
        this.mVerticalResolution = -1;
        int[] iArr = this.mMaxDimension;
        iArr[0] = Integer.MAX_VALUE;
        iArr[1] = Integer.MAX_VALUE;
        this.mMatchConstraintDefaultWidth = 0;
        this.mMatchConstraintDefaultHeight = 0;
        this.mMatchConstraintPercentWidth = 1.0f;
        this.mMatchConstraintPercentHeight = 1.0f;
        this.mMatchConstraintMaxWidth = Integer.MAX_VALUE;
        this.mMatchConstraintMaxHeight = Integer.MAX_VALUE;
        this.mMatchConstraintMinWidth = 0;
        this.mMatchConstraintMinHeight = 0;
        this.mResolvedHasRatio = false;
        this.mResolvedDimensionRatioSide = -1;
        this.mResolvedDimensionRatio = 1.0f;
        this.mOptimizerMeasurable = false;
        this.mGroupsToSolver = false;
        boolean[] zArr = this.isTerminalWidget;
        zArr[0] = true;
        zArr[1] = true;
        this.mInVirtuaLayout = false;
    }

    public ConstraintWidget() {
        this.measured = false;
        this.run = new WidgetRun[2];
        this.horizontalRun = new HorizontalWidgetRun(this);
        this.verticalRun = new VerticalWidgetRun(this);
        this.isTerminalWidget = new boolean[]{true, true};
        this.wrapMeasure = new int[]{0, 0};
        this.mResolvedHasRatio = false;
        this.mHorizontalResolution = -1;
        this.mVerticalResolution = -1;
        this.mMatchConstraintDefaultWidth = 0;
        this.mMatchConstraintDefaultHeight = 0;
        this.mResolvedMatchConstraintDefault = new int[2];
        this.mMatchConstraintMinWidth = 0;
        this.mMatchConstraintMaxWidth = 0;
        this.mMatchConstraintPercentWidth = 1.0f;
        this.mMatchConstraintMinHeight = 0;
        this.mMatchConstraintMaxHeight = 0;
        this.mMatchConstraintPercentHeight = 1.0f;
        this.mResolvedDimensionRatioSide = -1;
        this.mResolvedDimensionRatio = 1.0f;
        this.mMaxDimension = new int[]{Integer.MAX_VALUE, Integer.MAX_VALUE};
        this.mCircleConstraintAngle = 0.0f;
        this.hasBaseline = false;
        this.mInVirtuaLayout = false;
        this.mLeft = new ConstraintAnchor(this, ConstraintAnchor.Type.LEFT);
        this.mTop = new ConstraintAnchor(this, ConstraintAnchor.Type.TOP);
        this.mRight = new ConstraintAnchor(this, ConstraintAnchor.Type.RIGHT);
        this.mBottom = new ConstraintAnchor(this, ConstraintAnchor.Type.BOTTOM);
        this.mBaseline = new ConstraintAnchor(this, ConstraintAnchor.Type.BASELINE);
        this.mCenterX = new ConstraintAnchor(this, ConstraintAnchor.Type.CENTER_X);
        this.mCenterY = new ConstraintAnchor(this, ConstraintAnchor.Type.CENTER_Y);
        ConstraintAnchor constraintAnchor = new ConstraintAnchor(this, ConstraintAnchor.Type.CENTER);
        this.mCenter = constraintAnchor;
        this.mListAnchors = new ConstraintAnchor[]{this.mLeft, this.mRight, this.mTop, this.mBottom, this.mBaseline, constraintAnchor};
        this.mAnchors = new ArrayList<>();
        DimensionBehaviour dimensionBehaviour = DimensionBehaviour.FIXED;
        this.mListDimensionBehaviors = new DimensionBehaviour[]{dimensionBehaviour, dimensionBehaviour};
        this.mParent = null;
        this.mWidth = 0;
        this.mHeight = 0;
        this.mDimensionRatio = 0.0f;
        this.mDimensionRatioSide = -1;
        this.mX = 0;
        this.mY = 0;
        this.mRelX = 0;
        this.mRelY = 0;
        this.mOffsetX = 0;
        this.mOffsetY = 0;
        this.mBaselineDistance = 0;
        float f = DEFAULT_BIAS;
        this.mHorizontalBiasPercent = f;
        this.mVerticalBiasPercent = f;
        this.mContainerItemSkip = 0;
        this.mVisibility = 0;
        this.mDebugName = null;
        this.mType = null;
        this.mOptimizerMeasurable = false;
        this.mGroupsToSolver = false;
        this.mHorizontalChainStyle = 0;
        this.mVerticalChainStyle = 0;
        this.mWeight = new float[]{-1.0f, -1.0f};
        this.mListNextMatchConstraintsWidget = new ConstraintWidget[]{null, null};
        this.mNextChainWidget = new ConstraintWidget[]{null, null};
        this.mHorizontalNextWidget = null;
        this.mVerticalNextWidget = null;
        addAnchors();
    }

    public ConstraintWidget(int i, int i2, int i3, int i4) {
        this.measured = false;
        this.run = new WidgetRun[2];
        this.horizontalRun = new HorizontalWidgetRun(this);
        this.verticalRun = new VerticalWidgetRun(this);
        this.isTerminalWidget = new boolean[]{true, true};
        this.wrapMeasure = new int[]{0, 0};
        this.mResolvedHasRatio = false;
        this.mHorizontalResolution = -1;
        this.mVerticalResolution = -1;
        this.mMatchConstraintDefaultWidth = 0;
        this.mMatchConstraintDefaultHeight = 0;
        this.mResolvedMatchConstraintDefault = new int[2];
        this.mMatchConstraintMinWidth = 0;
        this.mMatchConstraintMaxWidth = 0;
        this.mMatchConstraintPercentWidth = 1.0f;
        this.mMatchConstraintMinHeight = 0;
        this.mMatchConstraintMaxHeight = 0;
        this.mMatchConstraintPercentHeight = 1.0f;
        this.mResolvedDimensionRatioSide = -1;
        this.mResolvedDimensionRatio = 1.0f;
        this.mMaxDimension = new int[]{Integer.MAX_VALUE, Integer.MAX_VALUE};
        this.mCircleConstraintAngle = 0.0f;
        this.hasBaseline = false;
        this.mInVirtuaLayout = false;
        this.mLeft = new ConstraintAnchor(this, ConstraintAnchor.Type.LEFT);
        this.mTop = new ConstraintAnchor(this, ConstraintAnchor.Type.TOP);
        this.mRight = new ConstraintAnchor(this, ConstraintAnchor.Type.RIGHT);
        this.mBottom = new ConstraintAnchor(this, ConstraintAnchor.Type.BOTTOM);
        this.mBaseline = new ConstraintAnchor(this, ConstraintAnchor.Type.BASELINE);
        this.mCenterX = new ConstraintAnchor(this, ConstraintAnchor.Type.CENTER_X);
        this.mCenterY = new ConstraintAnchor(this, ConstraintAnchor.Type.CENTER_Y);
        ConstraintAnchor constraintAnchor = new ConstraintAnchor(this, ConstraintAnchor.Type.CENTER);
        this.mCenter = constraintAnchor;
        this.mListAnchors = new ConstraintAnchor[]{this.mLeft, this.mRight, this.mTop, this.mBottom, this.mBaseline, constraintAnchor};
        this.mAnchors = new ArrayList<>();
        DimensionBehaviour dimensionBehaviour = DimensionBehaviour.FIXED;
        this.mListDimensionBehaviors = new DimensionBehaviour[]{dimensionBehaviour, dimensionBehaviour};
        this.mParent = null;
        this.mDimensionRatio = 0.0f;
        this.mDimensionRatioSide = -1;
        this.mRelX = 0;
        this.mRelY = 0;
        this.mOffsetX = 0;
        this.mOffsetY = 0;
        this.mBaselineDistance = 0;
        float f = DEFAULT_BIAS;
        this.mHorizontalBiasPercent = f;
        this.mVerticalBiasPercent = f;
        this.mContainerItemSkip = 0;
        this.mVisibility = 0;
        this.mDebugName = null;
        this.mType = null;
        this.mOptimizerMeasurable = false;
        this.mGroupsToSolver = false;
        this.mHorizontalChainStyle = 0;
        this.mVerticalChainStyle = 0;
        this.mWeight = new float[]{-1.0f, -1.0f};
        this.mListNextMatchConstraintsWidget = new ConstraintWidget[]{null, null};
        this.mNextChainWidget = new ConstraintWidget[]{null, null};
        this.mHorizontalNextWidget = null;
        this.mVerticalNextWidget = null;
        this.mX = i;
        this.mY = i2;
        this.mWidth = i3;
        this.mHeight = i4;
        addAnchors();
    }

    public ConstraintWidget(int i, int i2) {
        this(0, 0, i, i2);
    }

    public void resetSolverVariables(Cache cache) {
        this.mLeft.resetSolverVariable(cache);
        this.mTop.resetSolverVariable(cache);
        this.mRight.resetSolverVariable(cache);
        this.mBottom.resetSolverVariable(cache);
        this.mBaseline.resetSolverVariable(cache);
        this.mCenter.resetSolverVariable(cache);
        this.mCenterX.resetSolverVariable(cache);
        this.mCenterY.resetSolverVariable(cache);
    }

    private void addAnchors() {
        this.mAnchors.add(this.mLeft);
        this.mAnchors.add(this.mTop);
        this.mAnchors.add(this.mRight);
        this.mAnchors.add(this.mBottom);
        this.mAnchors.add(this.mCenterX);
        this.mAnchors.add(this.mCenterY);
        this.mAnchors.add(this.mCenter);
        this.mAnchors.add(this.mBaseline);
    }

    public boolean isRoot() {
        return this.mParent == null;
    }

    public ConstraintWidget getParent() {
        return this.mParent;
    }

    public void setParent(ConstraintWidget constraintWidget) {
        this.mParent = constraintWidget;
    }

    public void setWidthWrapContent(boolean z) {
        this.mIsWidthWrapContent = z;
    }

    public boolean isWidthWrapContent() {
        return this.mIsWidthWrapContent;
    }

    public void setHeightWrapContent(boolean z) {
        this.mIsHeightWrapContent = z;
    }

    public boolean isHeightWrapContent() {
        return this.mIsHeightWrapContent;
    }

    public void connectCircularConstraint(ConstraintWidget constraintWidget, float f, int i) {
        ConstraintAnchor.Type type = ConstraintAnchor.Type.CENTER;
        immediateConnect(type, constraintWidget, type, i, 0);
        this.mCircleConstraintAngle = f;
    }

    public String getType() {
        return this.mType;
    }

    public void setType(String str) {
        this.mType = str;
    }

    public void setVisibility(int i) {
        this.mVisibility = i;
    }

    public int getVisibility() {
        return this.mVisibility;
    }

    public String getDebugName() {
        return this.mDebugName;
    }

    public void setDebugName(String str) {
        this.mDebugName = str;
    }

    public void setDebugSolverName(LinearSystem linearSystem, String str) {
        this.mDebugName = str;
        SolverVariable createObjectVariable = linearSystem.createObjectVariable(this.mLeft);
        SolverVariable createObjectVariable2 = linearSystem.createObjectVariable(this.mTop);
        SolverVariable createObjectVariable3 = linearSystem.createObjectVariable(this.mRight);
        SolverVariable createObjectVariable4 = linearSystem.createObjectVariable(this.mBottom);
        createObjectVariable.setName(str + ".left");
        createObjectVariable2.setName(str + ".top");
        createObjectVariable3.setName(str + ".right");
        createObjectVariable4.setName(str + ".bottom");
        if (this.mBaselineDistance > 0) {
            SolverVariable createObjectVariable5 = linearSystem.createObjectVariable(this.mBaseline);
            createObjectVariable5.setName(str + ".baseline");
        }
    }

    public void createObjectVariables(LinearSystem linearSystem) {
        linearSystem.createObjectVariable(this.mLeft);
        linearSystem.createObjectVariable(this.mTop);
        linearSystem.createObjectVariable(this.mRight);
        linearSystem.createObjectVariable(this.mBottom);
        if (this.mBaselineDistance > 0) {
            linearSystem.createObjectVariable(this.mBaseline);
        }
    }

    public String toString() {
        String str;
        StringBuilder sb = new StringBuilder();
        String str2 = "";
        if (this.mType != null) {
            str = "type: " + this.mType + " ";
        } else {
            str = str2;
        }
        sb.append(str);
        if (this.mDebugName != null) {
            str2 = "id: " + this.mDebugName + " ";
        }
        sb.append(str2);
        sb.append("(");
        sb.append(this.mX);
        sb.append(", ");
        sb.append(this.mY);
        sb.append(") - (");
        sb.append(this.mWidth);
        sb.append(" x ");
        sb.append(this.mHeight);
        sb.append(")");
        return sb.toString();
    }

    public int getX() {
        ConstraintWidget constraintWidget = this.mParent;
        if (constraintWidget == null || !(constraintWidget instanceof ConstraintWidgetContainer)) {
            return this.mX;
        }
        return ((ConstraintWidgetContainer) constraintWidget).mPaddingLeft + this.mX;
    }

    public int getY() {
        ConstraintWidget constraintWidget = this.mParent;
        if (constraintWidget == null || !(constraintWidget instanceof ConstraintWidgetContainer)) {
            return this.mY;
        }
        return ((ConstraintWidgetContainer) constraintWidget).mPaddingTop + this.mY;
    }

    public int getWidth() {
        if (this.mVisibility == 8) {
            return 0;
        }
        return this.mWidth;
    }

    public int getOptimizerWrapWidth() {
        int i;
        int i2 = this.mWidth;
        if (this.mListDimensionBehaviors[0] != DimensionBehaviour.MATCH_CONSTRAINT) {
            return i2;
        }
        if (this.mMatchConstraintDefaultWidth == 1) {
            i = Math.max(this.mMatchConstraintMinWidth, i2);
        } else {
            i = this.mMatchConstraintMinWidth;
            if (i > 0) {
                this.mWidth = i;
            } else {
                i = 0;
            }
        }
        int i3 = this.mMatchConstraintMaxWidth;
        return (i3 <= 0 || i3 >= i) ? i : i3;
    }

    public int getOptimizerWrapHeight() {
        int i;
        int i2 = this.mHeight;
        if (this.mListDimensionBehaviors[1] != DimensionBehaviour.MATCH_CONSTRAINT) {
            return i2;
        }
        if (this.mMatchConstraintDefaultHeight == 1) {
            i = Math.max(this.mMatchConstraintMinHeight, i2);
        } else {
            i = this.mMatchConstraintMinHeight;
            if (i > 0) {
                this.mHeight = i;
            } else {
                i = 0;
            }
        }
        int i3 = this.mMatchConstraintMaxHeight;
        return (i3 <= 0 || i3 >= i) ? i : i3;
    }

    public int getHeight() {
        if (this.mVisibility == 8) {
            return 0;
        }
        return this.mHeight;
    }

    public int getLength(int i) {
        if (i == 0) {
            return getWidth();
        }
        if (i == 1) {
            return getHeight();
        }
        return 0;
    }

    /* access modifiers changed from: protected */
    public int getRootX() {
        return this.mX + this.mOffsetX;
    }

    /* access modifiers changed from: protected */
    public int getRootY() {
        return this.mY + this.mOffsetY;
    }

    public int getMinWidth() {
        return this.mMinWidth;
    }

    public int getMinHeight() {
        return this.mMinHeight;
    }

    public int getLeft() {
        return getX();
    }

    public int getTop() {
        return getY();
    }

    public int getRight() {
        return getX() + this.mWidth;
    }

    public int getBottom() {
        return getY() + this.mHeight;
    }

    public int getHorizontalMargin() {
        ConstraintAnchor constraintAnchor = this.mLeft;
        int i = 0;
        if (constraintAnchor != null) {
            i = 0 + constraintAnchor.mMargin;
        }
        ConstraintAnchor constraintAnchor2 = this.mRight;
        return constraintAnchor2 != null ? i + constraintAnchor2.mMargin : i;
    }

    public int getVerticalMargin() {
        int i = 0;
        if (this.mLeft != null) {
            i = 0 + this.mTop.mMargin;
        }
        return this.mRight != null ? i + this.mBottom.mMargin : i;
    }

    public float getHorizontalBiasPercent() {
        return this.mHorizontalBiasPercent;
    }

    public float getVerticalBiasPercent() {
        return this.mVerticalBiasPercent;
    }

    public float getBiasPercent(int i) {
        if (i == 0) {
            return this.mHorizontalBiasPercent;
        }
        if (i == 1) {
            return this.mVerticalBiasPercent;
        }
        return -1.0f;
    }

    public boolean hasBaseline() {
        return this.hasBaseline;
    }

    public int getBaselineDistance() {
        return this.mBaselineDistance;
    }

    public Object getCompanionWidget() {
        return this.mCompanionWidget;
    }

    public ArrayList<ConstraintAnchor> getAnchors() {
        return this.mAnchors;
    }

    public void setX(int i) {
        this.mX = i;
    }

    public void setY(int i) {
        this.mY = i;
    }

    public void setOrigin(int i, int i2) {
        this.mX = i;
        this.mY = i2;
    }

    public void setOffset(int i, int i2) {
        this.mOffsetX = i;
        this.mOffsetY = i2;
    }

    public void setGoneMargin(ConstraintAnchor.Type type, int i) {
        int i2 = AnonymousClass1.$SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type[type.ordinal()];
        if (i2 == 1) {
            this.mLeft.mGoneMargin = i;
        } else if (i2 == 2) {
            this.mTop.mGoneMargin = i;
        } else if (i2 == 3) {
            this.mRight.mGoneMargin = i;
        } else if (i2 == 4) {
            this.mBottom.mGoneMargin = i;
        }
    }

    public void setWidth(int i) {
        this.mWidth = i;
        int i2 = this.mMinWidth;
        if (i < i2) {
            this.mWidth = i2;
        }
    }

    public void setHeight(int i) {
        this.mHeight = i;
        int i2 = this.mMinHeight;
        if (i < i2) {
            this.mHeight = i2;
        }
    }

    public void setLength(int i, int i2) {
        if (i2 == 0) {
            setWidth(i);
        } else if (i2 == 1) {
            setHeight(i);
        }
    }

    public void setHorizontalMatchStyle(int i, int i2, int i3, float f) {
        this.mMatchConstraintDefaultWidth = i;
        this.mMatchConstraintMinWidth = i2;
        if (i3 == Integer.MAX_VALUE) {
            i3 = 0;
        }
        this.mMatchConstraintMaxWidth = i3;
        this.mMatchConstraintPercentWidth = f;
        if (f > 0.0f && f < 1.0f && i == 0) {
            this.mMatchConstraintDefaultWidth = 2;
        }
    }

    public void setVerticalMatchStyle(int i, int i2, int i3, float f) {
        this.mMatchConstraintDefaultHeight = i;
        this.mMatchConstraintMinHeight = i2;
        if (i3 == Integer.MAX_VALUE) {
            i3 = 0;
        }
        this.mMatchConstraintMaxHeight = i3;
        this.mMatchConstraintPercentHeight = f;
        if (f > 0.0f && f < 1.0f && i == 0) {
            this.mMatchConstraintDefaultHeight = 2;
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:39:0x0089  */
    /* JADX WARNING: Removed duplicated region for block: B:43:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void setDimensionRatio(java.lang.String r9) {
        /*
            r8 = this;
            r0 = 0
            if (r9 == 0) goto L_0x008e
            int r1 = r9.length()
            if (r1 != 0) goto L_0x000b
            goto L_0x008e
        L_0x000b:
            r1 = -1
            int r2 = r9.length()
            r3 = 44
            int r3 = r9.indexOf(r3)
            r4 = 0
            r5 = 1
            if (r3 <= 0) goto L_0x0037
            int r6 = r2 + -1
            if (r3 >= r6) goto L_0x0037
            java.lang.String r6 = r9.substring(r4, r3)
            java.lang.String r7 = "W"
            boolean r7 = r6.equalsIgnoreCase(r7)
            if (r7 == 0) goto L_0x002c
            r1 = r4
            goto L_0x0035
        L_0x002c:
            java.lang.String r4 = "H"
            boolean r4 = r6.equalsIgnoreCase(r4)
            if (r4 == 0) goto L_0x0035
            r1 = r5
        L_0x0035:
            int r4 = r3 + 1
        L_0x0037:
            r3 = 58
            int r3 = r9.indexOf(r3)
            if (r3 < 0) goto L_0x0075
            int r2 = r2 - r5
            if (r3 >= r2) goto L_0x0075
            java.lang.String r2 = r9.substring(r4, r3)
            int r3 = r3 + r5
            java.lang.String r9 = r9.substring(r3)
            int r3 = r2.length()
            if (r3 <= 0) goto L_0x0084
            int r3 = r9.length()
            if (r3 <= 0) goto L_0x0084
            float r2 = java.lang.Float.parseFloat(r2)     // Catch:{ NumberFormatException -> 0x0084 }
            float r9 = java.lang.Float.parseFloat(r9)     // Catch:{ NumberFormatException -> 0x0084 }
            int r3 = (r2 > r0 ? 1 : (r2 == r0 ? 0 : -1))
            if (r3 <= 0) goto L_0x0084
            int r3 = (r9 > r0 ? 1 : (r9 == r0 ? 0 : -1))
            if (r3 <= 0) goto L_0x0084
            if (r1 != r5) goto L_0x006f
            float r9 = r9 / r2
            float r9 = java.lang.Math.abs(r9)     // Catch:{ NumberFormatException -> 0x0084 }
            goto L_0x0085
        L_0x006f:
            float r2 = r2 / r9
            float r9 = java.lang.Math.abs(r2)     // Catch:{ NumberFormatException -> 0x0084 }
            goto L_0x0085
        L_0x0075:
            java.lang.String r9 = r9.substring(r4)
            int r2 = r9.length()
            if (r2 <= 0) goto L_0x0084
            float r9 = java.lang.Float.parseFloat(r9)     // Catch:{ NumberFormatException -> 0x0084 }
            goto L_0x0085
        L_0x0084:
            r9 = r0
        L_0x0085:
            int r0 = (r9 > r0 ? 1 : (r9 == r0 ? 0 : -1))
            if (r0 <= 0) goto L_0x008d
            r8.mDimensionRatio = r9
            r8.mDimensionRatioSide = r1
        L_0x008d:
            return
        L_0x008e:
            r8.mDimensionRatio = r0
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.ConstraintWidget.setDimensionRatio(java.lang.String):void");
    }

    public void setDimensionRatio(float f, int i) {
        this.mDimensionRatio = f;
        this.mDimensionRatioSide = i;
    }

    public float getDimensionRatio() {
        return this.mDimensionRatio;
    }

    public int getDimensionRatioSide() {
        return this.mDimensionRatioSide;
    }

    public void setHorizontalBiasPercent(float f) {
        this.mHorizontalBiasPercent = f;
    }

    public void setVerticalBiasPercent(float f) {
        this.mVerticalBiasPercent = f;
    }

    public void setMinWidth(int i) {
        if (i < 0) {
            this.mMinWidth = 0;
        } else {
            this.mMinWidth = i;
        }
    }

    public void setMinHeight(int i) {
        if (i < 0) {
            this.mMinHeight = 0;
        } else {
            this.mMinHeight = i;
        }
    }

    public void setDimension(int i, int i2) {
        this.mWidth = i;
        int i3 = this.mMinWidth;
        if (i < i3) {
            this.mWidth = i3;
        }
        this.mHeight = i2;
        int i4 = this.mMinHeight;
        if (i2 < i4) {
            this.mHeight = i4;
        }
    }

    public void setFrame(int i, int i2, int i3, int i4) {
        int i5;
        int i6;
        int i7 = i3 - i;
        int i8 = i4 - i2;
        this.mX = i;
        this.mY = i2;
        if (this.mVisibility == 8) {
            this.mWidth = 0;
            this.mHeight = 0;
            return;
        }
        DimensionBehaviour[] dimensionBehaviourArr = this.mListDimensionBehaviors;
        DimensionBehaviour dimensionBehaviour = dimensionBehaviourArr[0];
        DimensionBehaviour dimensionBehaviour2 = DimensionBehaviour.FIXED;
        if (dimensionBehaviour == dimensionBehaviour2 && i7 < (i6 = this.mWidth)) {
            i7 = i6;
        }
        if (dimensionBehaviourArr[1] == dimensionBehaviour2 && i8 < (i5 = this.mHeight)) {
            i8 = i5;
        }
        this.mWidth = i7;
        this.mHeight = i8;
        int i9 = this.mMinHeight;
        if (i8 < i9) {
            this.mHeight = i9;
        }
        int i10 = this.mMinWidth;
        if (i7 < i10) {
            this.mWidth = i10;
        }
    }

    public void setFrame(int i, int i2, int i3) {
        if (i3 == 0) {
            setHorizontalDimension(i, i2);
        } else if (i3 == 1) {
            setVerticalDimension(i, i2);
        }
    }

    public void setHorizontalDimension(int i, int i2) {
        this.mX = i;
        int i3 = i2 - i;
        this.mWidth = i3;
        int i4 = this.mMinWidth;
        if (i3 < i4) {
            this.mWidth = i4;
        }
    }

    public void setVerticalDimension(int i, int i2) {
        this.mY = i;
        int i3 = i2 - i;
        this.mHeight = i3;
        int i4 = this.mMinHeight;
        if (i3 < i4) {
            this.mHeight = i4;
        }
    }

    /* access modifiers changed from: package-private */
    public int getRelativePositioning(int i) {
        if (i == 0) {
            return this.mRelX;
        }
        if (i == 1) {
            return this.mRelY;
        }
        return 0;
    }

    /* access modifiers changed from: package-private */
    public void setRelativePositioning(int i, int i2) {
        if (i2 == 0) {
            this.mRelX = i;
        } else if (i2 == 1) {
            this.mRelY = i;
        }
    }

    public void setBaselineDistance(int i) {
        this.mBaselineDistance = i;
        this.hasBaseline = i > 0;
    }

    public void setCompanionWidget(Object obj) {
        this.mCompanionWidget = obj;
    }

    public void setContainerItemSkip(int i) {
        if (i >= 0) {
            this.mContainerItemSkip = i;
        } else {
            this.mContainerItemSkip = 0;
        }
    }

    public int getContainerItemSkip() {
        return this.mContainerItemSkip;
    }

    public void setHorizontalWeight(float f) {
        this.mWeight[0] = f;
    }

    public void setVerticalWeight(float f) {
        this.mWeight[1] = f;
    }

    public void setHorizontalChainStyle(int i) {
        this.mHorizontalChainStyle = i;
    }

    public int getHorizontalChainStyle() {
        return this.mHorizontalChainStyle;
    }

    public void setVerticalChainStyle(int i) {
        this.mVerticalChainStyle = i;
    }

    public int getVerticalChainStyle() {
        return this.mVerticalChainStyle;
    }

    public boolean allowedInBarrier() {
        return this.mVisibility != 8;
    }

    public void immediateConnect(ConstraintAnchor.Type type, ConstraintWidget constraintWidget, ConstraintAnchor.Type type2, int i, int i2) {
        getAnchor(type).connect(constraintWidget.getAnchor(type2), i, i2, true);
    }

    public void connect(ConstraintAnchor constraintAnchor, ConstraintAnchor constraintAnchor2, int i) {
        if (constraintAnchor.getOwner() == this) {
            connect(constraintAnchor.getType(), constraintAnchor2.getOwner(), constraintAnchor2.getType(), i);
        }
    }

    public void connect(ConstraintAnchor.Type type, ConstraintWidget constraintWidget, ConstraintAnchor.Type type2) {
        connect(type, constraintWidget, type2, 0);
    }

    public void connect(ConstraintAnchor.Type type, ConstraintWidget constraintWidget, ConstraintAnchor.Type type2, int i) {
        ConstraintAnchor.Type type3;
        ConstraintAnchor.Type type4;
        boolean z;
        ConstraintAnchor.Type type5 = ConstraintAnchor.Type.CENTER;
        if (type != type5) {
            ConstraintAnchor.Type type6 = ConstraintAnchor.Type.CENTER_X;
            if (type == type6 && (type2 == (type4 = ConstraintAnchor.Type.LEFT) || type2 == ConstraintAnchor.Type.RIGHT)) {
                ConstraintAnchor anchor = getAnchor(type4);
                ConstraintAnchor anchor2 = constraintWidget.getAnchor(type2);
                ConstraintAnchor anchor3 = getAnchor(ConstraintAnchor.Type.RIGHT);
                anchor.connect(anchor2, 0);
                anchor3.connect(anchor2, 0);
                getAnchor(type6).connect(anchor2, 0);
                return;
            }
            ConstraintAnchor.Type type7 = ConstraintAnchor.Type.CENTER_Y;
            if (type == type7 && (type2 == (type3 = ConstraintAnchor.Type.TOP) || type2 == ConstraintAnchor.Type.BOTTOM)) {
                ConstraintAnchor anchor4 = constraintWidget.getAnchor(type2);
                getAnchor(type3).connect(anchor4, 0);
                getAnchor(ConstraintAnchor.Type.BOTTOM).connect(anchor4, 0);
                getAnchor(type7).connect(anchor4, 0);
            } else if (type == type6 && type2 == type6) {
                ConstraintAnchor.Type type8 = ConstraintAnchor.Type.LEFT;
                getAnchor(type8).connect(constraintWidget.getAnchor(type8), 0);
                ConstraintAnchor.Type type9 = ConstraintAnchor.Type.RIGHT;
                getAnchor(type9).connect(constraintWidget.getAnchor(type9), 0);
                getAnchor(type6).connect(constraintWidget.getAnchor(type2), 0);
            } else if (type == type7 && type2 == type7) {
                ConstraintAnchor.Type type10 = ConstraintAnchor.Type.TOP;
                getAnchor(type10).connect(constraintWidget.getAnchor(type10), 0);
                ConstraintAnchor.Type type11 = ConstraintAnchor.Type.BOTTOM;
                getAnchor(type11).connect(constraintWidget.getAnchor(type11), 0);
                getAnchor(type7).connect(constraintWidget.getAnchor(type2), 0);
            } else {
                ConstraintAnchor anchor5 = getAnchor(type);
                ConstraintAnchor anchor6 = constraintWidget.getAnchor(type2);
                if (anchor5.isValidConnection(anchor6)) {
                    ConstraintAnchor.Type type12 = ConstraintAnchor.Type.BASELINE;
                    if (type == type12) {
                        ConstraintAnchor anchor7 = getAnchor(ConstraintAnchor.Type.TOP);
                        ConstraintAnchor anchor8 = getAnchor(ConstraintAnchor.Type.BOTTOM);
                        if (anchor7 != null) {
                            anchor7.reset();
                        }
                        if (anchor8 != null) {
                            anchor8.reset();
                        }
                        i = 0;
                    } else if (type == ConstraintAnchor.Type.TOP || type == ConstraintAnchor.Type.BOTTOM) {
                        ConstraintAnchor anchor9 = getAnchor(type12);
                        if (anchor9 != null) {
                            anchor9.reset();
                        }
                        ConstraintAnchor anchor10 = getAnchor(type5);
                        if (anchor10.getTarget() != anchor6) {
                            anchor10.reset();
                        }
                        ConstraintAnchor opposite = getAnchor(type).getOpposite();
                        ConstraintAnchor anchor11 = getAnchor(type7);
                        if (anchor11.isConnected()) {
                            opposite.reset();
                            anchor11.reset();
                        }
                    } else if (type == ConstraintAnchor.Type.LEFT || type == ConstraintAnchor.Type.RIGHT) {
                        ConstraintAnchor anchor12 = getAnchor(type5);
                        if (anchor12.getTarget() != anchor6) {
                            anchor12.reset();
                        }
                        ConstraintAnchor opposite2 = getAnchor(type).getOpposite();
                        ConstraintAnchor anchor13 = getAnchor(type6);
                        if (anchor13.isConnected()) {
                            opposite2.reset();
                            anchor13.reset();
                        }
                    }
                    anchor5.connect(anchor6, i);
                }
            }
        } else if (type2 == type5) {
            ConstraintAnchor.Type type13 = ConstraintAnchor.Type.LEFT;
            ConstraintAnchor anchor14 = getAnchor(type13);
            ConstraintAnchor.Type type14 = ConstraintAnchor.Type.RIGHT;
            ConstraintAnchor anchor15 = getAnchor(type14);
            ConstraintAnchor.Type type15 = ConstraintAnchor.Type.TOP;
            ConstraintAnchor anchor16 = getAnchor(type15);
            ConstraintAnchor.Type type16 = ConstraintAnchor.Type.BOTTOM;
            ConstraintAnchor anchor17 = getAnchor(type16);
            boolean z2 = true;
            if ((anchor14 == null || !anchor14.isConnected()) && (anchor15 == null || !anchor15.isConnected())) {
                connect(type13, constraintWidget, type13, 0);
                connect(type14, constraintWidget, type14, 0);
                z = true;
            } else {
                z = false;
            }
            if ((anchor16 == null || !anchor16.isConnected()) && (anchor17 == null || !anchor17.isConnected())) {
                connect(type15, constraintWidget, type15, 0);
                connect(type16, constraintWidget, type16, 0);
            } else {
                z2 = false;
            }
            if (z && z2) {
                getAnchor(type5).connect(constraintWidget.getAnchor(type5), 0);
            } else if (z) {
                ConstraintAnchor.Type type17 = ConstraintAnchor.Type.CENTER_X;
                getAnchor(type17).connect(constraintWidget.getAnchor(type17), 0);
            } else if (z2) {
                ConstraintAnchor.Type type18 = ConstraintAnchor.Type.CENTER_Y;
                getAnchor(type18).connect(constraintWidget.getAnchor(type18), 0);
            }
        } else {
            ConstraintAnchor.Type type19 = ConstraintAnchor.Type.LEFT;
            if (type2 == type19 || type2 == ConstraintAnchor.Type.RIGHT) {
                connect(type19, constraintWidget, type2, 0);
                connect(ConstraintAnchor.Type.RIGHT, constraintWidget, type2, 0);
                getAnchor(type5).connect(constraintWidget.getAnchor(type2), 0);
                return;
            }
            ConstraintAnchor.Type type20 = ConstraintAnchor.Type.TOP;
            if (type2 == type20 || type2 == ConstraintAnchor.Type.BOTTOM) {
                connect(type20, constraintWidget, type2, 0);
                connect(ConstraintAnchor.Type.BOTTOM, constraintWidget, type2, 0);
                getAnchor(type5).connect(constraintWidget.getAnchor(type2), 0);
            }
        }
    }

    public void resetAllConstraints() {
        resetAnchors();
        setVerticalBiasPercent(DEFAULT_BIAS);
        setHorizontalBiasPercent(DEFAULT_BIAS);
    }

    public void resetAnchor(ConstraintAnchor constraintAnchor) {
        if (getParent() == null || !(getParent() instanceof ConstraintWidgetContainer) || !((ConstraintWidgetContainer) getParent()).handlesInternalConstraints()) {
            ConstraintAnchor anchor = getAnchor(ConstraintAnchor.Type.LEFT);
            ConstraintAnchor anchor2 = getAnchor(ConstraintAnchor.Type.RIGHT);
            ConstraintAnchor anchor3 = getAnchor(ConstraintAnchor.Type.TOP);
            ConstraintAnchor anchor4 = getAnchor(ConstraintAnchor.Type.BOTTOM);
            ConstraintAnchor anchor5 = getAnchor(ConstraintAnchor.Type.CENTER);
            ConstraintAnchor anchor6 = getAnchor(ConstraintAnchor.Type.CENTER_X);
            ConstraintAnchor anchor7 = getAnchor(ConstraintAnchor.Type.CENTER_Y);
            if (constraintAnchor == anchor5) {
                if (anchor.isConnected() && anchor2.isConnected() && anchor.getTarget() == anchor2.getTarget()) {
                    anchor.reset();
                    anchor2.reset();
                }
                if (anchor3.isConnected() && anchor4.isConnected() && anchor3.getTarget() == anchor4.getTarget()) {
                    anchor3.reset();
                    anchor4.reset();
                }
                this.mHorizontalBiasPercent = 0.5f;
                this.mVerticalBiasPercent = 0.5f;
            } else if (constraintAnchor == anchor6) {
                if (anchor.isConnected() && anchor2.isConnected() && anchor.getTarget().getOwner() == anchor2.getTarget().getOwner()) {
                    anchor.reset();
                    anchor2.reset();
                }
                this.mHorizontalBiasPercent = 0.5f;
            } else if (constraintAnchor == anchor7) {
                if (anchor3.isConnected() && anchor4.isConnected() && anchor3.getTarget().getOwner() == anchor4.getTarget().getOwner()) {
                    anchor3.reset();
                    anchor4.reset();
                }
                this.mVerticalBiasPercent = 0.5f;
            } else if (constraintAnchor == anchor || constraintAnchor == anchor2) {
                if (anchor.isConnected() && anchor.getTarget() == anchor2.getTarget()) {
                    anchor5.reset();
                }
            } else if ((constraintAnchor == anchor3 || constraintAnchor == anchor4) && anchor3.isConnected() && anchor3.getTarget() == anchor4.getTarget()) {
                anchor5.reset();
            }
            constraintAnchor.reset();
        }
    }

    public void resetAnchors() {
        ConstraintWidget parent = getParent();
        if (parent == null || !(parent instanceof ConstraintWidgetContainer) || !((ConstraintWidgetContainer) getParent()).handlesInternalConstraints()) {
            int size = this.mAnchors.size();
            for (int i = 0; i < size; i++) {
                this.mAnchors.get(i).reset();
            }
        }
    }

    public ConstraintAnchor getAnchor(ConstraintAnchor.Type type) {
        switch (AnonymousClass1.$SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type[type.ordinal()]) {
            case 1:
                return this.mLeft;
            case 2:
                return this.mTop;
            case 3:
                return this.mRight;
            case 4:
                return this.mBottom;
            case 5:
                return this.mBaseline;
            case 6:
                return this.mCenter;
            case 7:
                return this.mCenterX;
            case 8:
                return this.mCenterY;
            case 9:
                return null;
            default:
                throw new AssertionError(type.name());
        }
    }

    public DimensionBehaviour getHorizontalDimensionBehaviour() {
        return this.mListDimensionBehaviors[0];
    }

    public DimensionBehaviour getVerticalDimensionBehaviour() {
        return this.mListDimensionBehaviors[1];
    }

    public DimensionBehaviour getDimensionBehaviour(int i) {
        if (i == 0) {
            return getHorizontalDimensionBehaviour();
        }
        if (i == 1) {
            return getVerticalDimensionBehaviour();
        }
        return null;
    }

    public void setHorizontalDimensionBehaviour(DimensionBehaviour dimensionBehaviour) {
        this.mListDimensionBehaviors[0] = dimensionBehaviour;
    }

    public void setVerticalDimensionBehaviour(DimensionBehaviour dimensionBehaviour) {
        this.mListDimensionBehaviors[1] = dimensionBehaviour;
    }

    public boolean isInHorizontalChain() {
        ConstraintAnchor constraintAnchor = this.mLeft;
        ConstraintAnchor constraintAnchor2 = constraintAnchor.mTarget;
        if (constraintAnchor2 != null && constraintAnchor2.mTarget == constraintAnchor) {
            return true;
        }
        ConstraintAnchor constraintAnchor3 = this.mRight;
        ConstraintAnchor constraintAnchor4 = constraintAnchor3.mTarget;
        return constraintAnchor4 != null && constraintAnchor4.mTarget == constraintAnchor3;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:9:0x0012, code lost:
        r1 = r1.mTop;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public androidx.constraintlayout.solver.widgets.ConstraintWidget getPreviousChainMember(int r2) {
        /*
            r1 = this;
            if (r2 != 0) goto L_0x000f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mLeft
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r1.mTarget
            if (r2 == 0) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r2.mTarget
            if (r0 != r1) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r2.mOwner
            return r1
        L_0x000f:
            r0 = 1
            if (r2 != r0) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mTop
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r1.mTarget
            if (r2 == 0) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r2.mTarget
            if (r0 != r1) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r2.mOwner
            return r1
        L_0x001f:
            r1 = 0
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.ConstraintWidget.getPreviousChainMember(int):androidx.constraintlayout.solver.widgets.ConstraintWidget");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:9:0x0012, code lost:
        r1 = r1.mBottom;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public androidx.constraintlayout.solver.widgets.ConstraintWidget getNextChainMember(int r2) {
        /*
            r1 = this;
            if (r2 != 0) goto L_0x000f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mRight
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r1.mTarget
            if (r2 == 0) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r2.mTarget
            if (r0 != r1) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r2.mOwner
            return r1
        L_0x000f:
            r0 = 1
            if (r2 != r0) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mBottom
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r1.mTarget
            if (r2 == 0) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r2.mTarget
            if (r0 != r1) goto L_0x001f
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r2.mOwner
            return r1
        L_0x001f:
            r1 = 0
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.ConstraintWidget.getNextChainMember(int):androidx.constraintlayout.solver.widgets.ConstraintWidget");
    }

    public ConstraintWidget getHorizontalChainControlWidget() {
        ConstraintAnchor constraintAnchor;
        ConstraintWidget constraintWidget;
        ConstraintAnchor constraintAnchor2;
        if (!isInHorizontalChain()) {
            return null;
        }
        ConstraintWidget constraintWidget2 = this;
        ConstraintWidget constraintWidget3 = null;
        while (constraintWidget3 == null && constraintWidget2 != null) {
            ConstraintAnchor anchor = constraintWidget2.getAnchor(ConstraintAnchor.Type.LEFT);
            if (anchor == null) {
                constraintAnchor = null;
            } else {
                constraintAnchor = anchor.getTarget();
            }
            if (constraintAnchor == null) {
                constraintWidget = null;
            } else {
                constraintWidget = constraintAnchor.getOwner();
            }
            if (constraintWidget == getParent()) {
                return constraintWidget2;
            }
            if (constraintWidget == null) {
                constraintAnchor2 = null;
            } else {
                constraintAnchor2 = constraintWidget.getAnchor(ConstraintAnchor.Type.RIGHT).getTarget();
            }
            if (constraintAnchor2 == null || constraintAnchor2.getOwner() == constraintWidget2) {
                constraintWidget2 = constraintWidget;
            } else {
                constraintWidget3 = constraintWidget2;
            }
        }
        return constraintWidget3;
    }

    public boolean isInVerticalChain() {
        ConstraintAnchor constraintAnchor = this.mTop;
        ConstraintAnchor constraintAnchor2 = constraintAnchor.mTarget;
        if (constraintAnchor2 != null && constraintAnchor2.mTarget == constraintAnchor) {
            return true;
        }
        ConstraintAnchor constraintAnchor3 = this.mBottom;
        ConstraintAnchor constraintAnchor4 = constraintAnchor3.mTarget;
        return constraintAnchor4 != null && constraintAnchor4.mTarget == constraintAnchor3;
    }

    public ConstraintWidget getVerticalChainControlWidget() {
        ConstraintAnchor constraintAnchor;
        ConstraintWidget constraintWidget;
        ConstraintAnchor constraintAnchor2;
        if (!isInVerticalChain()) {
            return null;
        }
        ConstraintWidget constraintWidget2 = this;
        ConstraintWidget constraintWidget3 = null;
        while (constraintWidget3 == null && constraintWidget2 != null) {
            ConstraintAnchor anchor = constraintWidget2.getAnchor(ConstraintAnchor.Type.TOP);
            if (anchor == null) {
                constraintAnchor = null;
            } else {
                constraintAnchor = anchor.getTarget();
            }
            if (constraintAnchor == null) {
                constraintWidget = null;
            } else {
                constraintWidget = constraintAnchor.getOwner();
            }
            if (constraintWidget == getParent()) {
                return constraintWidget2;
            }
            if (constraintWidget == null) {
                constraintAnchor2 = null;
            } else {
                constraintAnchor2 = constraintWidget.getAnchor(ConstraintAnchor.Type.BOTTOM).getTarget();
            }
            if (constraintAnchor2 == null || constraintAnchor2.getOwner() == constraintWidget2) {
                constraintWidget2 = constraintWidget;
            } else {
                constraintWidget3 = constraintWidget2;
            }
        }
        return constraintWidget3;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:4:0x000f, code lost:
        r3 = r3[r4 + 1];
        r4 = r3.mTarget;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean isChainHead(int r4) {
        /*
            r3 = this;
            int r4 = r4 * 2
            androidx.constraintlayout.solver.widgets.ConstraintAnchor[] r3 = r3.mListAnchors
            r0 = r3[r4]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r0.mTarget
            r2 = 1
            if (r1 == 0) goto L_0x001b
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mTarget
            if (r1 == r0) goto L_0x001b
            int r4 = r4 + r2
            r3 = r3[r4]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r4 = r3.mTarget
            if (r4 == 0) goto L_0x001b
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r4 = r4.mTarget
            if (r4 != r3) goto L_0x001b
            goto L_0x001c
        L_0x001b:
            r2 = 0
        L_0x001c:
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.ConstraintWidget.isChainHead(int):boolean");
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r17v1, resolved type: int} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r18v1, resolved type: int} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r9v3, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r17v2, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r18v3, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r18v4, resolved type: int} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r29v3, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r17v3, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r17v4, resolved type: int} */
    /* JADX WARNING: Code restructure failed: missing block: B:219:0x040a, code lost:
        if (r13.mVisibility == 8) goto L_0x040f;
     */
    /* JADX WARNING: Multi-variable type inference failed */
    /* JADX WARNING: Removed duplicated region for block: B:133:0x0232  */
    /* JADX WARNING: Removed duplicated region for block: B:137:0x023c  */
    /* JADX WARNING: Removed duplicated region for block: B:143:0x024c  */
    /* JADX WARNING: Removed duplicated region for block: B:144:0x024f  */
    /* JADX WARNING: Removed duplicated region for block: B:146:0x0253  */
    /* JADX WARNING: Removed duplicated region for block: B:147:0x0256  */
    /* JADX WARNING: Removed duplicated region for block: B:150:0x0268  */
    /* JADX WARNING: Removed duplicated region for block: B:172:0x034e  */
    /* JADX WARNING: Removed duplicated region for block: B:178:0x036e  */
    /* JADX WARNING: Removed duplicated region for block: B:188:0x03b0  */
    /* JADX WARNING: Removed duplicated region for block: B:191:0x03c1  */
    /* JADX WARNING: Removed duplicated region for block: B:192:0x03c3  */
    /* JADX WARNING: Removed duplicated region for block: B:194:0x03c6  */
    /* JADX WARNING: Removed duplicated region for block: B:232:0x0484  */
    /* JADX WARNING: Removed duplicated region for block: B:234:0x048a  */
    /* JADX WARNING: Removed duplicated region for block: B:238:0x04b3  */
    /* JADX WARNING: Removed duplicated region for block: B:241:0x04bd  */
    /* JADX WARNING: Removed duplicated region for block: B:248:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void addToSolver(androidx.constraintlayout.solver.LinearSystem r46) {
        /*
            r45 = this;
            r13 = r45
            r9 = r46
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r13.mLeft
            androidx.constraintlayout.solver.SolverVariable r7 = r9.createObjectVariable(r0)
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r13.mRight
            androidx.constraintlayout.solver.SolverVariable r6 = r9.createObjectVariable(r0)
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r13.mTop
            androidx.constraintlayout.solver.SolverVariable r4 = r9.createObjectVariable(r0)
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r13.mBottom
            androidx.constraintlayout.solver.SolverVariable r3 = r9.createObjectVariable(r0)
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r13.mBaseline
            androidx.constraintlayout.solver.SolverVariable r1 = r9.createObjectVariable(r0)
            androidx.constraintlayout.solver.Metrics r0 = androidx.constraintlayout.solver.LinearSystem.sMetrics
            r10 = 1
            if (r0 == 0) goto L_0x002d
            long r14 = r0.widgets
            long r14 = r14 + r10
            r0.widgets = r14
        L_0x002d:
            androidx.constraintlayout.solver.widgets.analyzer.HorizontalWidgetRun r2 = r13.horizontalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r5 = r2.start
            boolean r8 = r5.resolved
            r12 = 0
            if (r8 == 0) goto L_0x00cf
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r2 = r2.end
            boolean r2 = r2.resolved
            if (r2 == 0) goto L_0x00cf
            androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun r2 = r13.verticalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r8 = r2.start
            boolean r8 = r8.resolved
            if (r8 == 0) goto L_0x00cf
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r2 = r2.end
            boolean r2 = r2.resolved
            if (r2 == 0) goto L_0x00cf
            if (r0 == 0) goto L_0x0051
            long r14 = r0.graphSolved
            long r14 = r14 + r10
            r0.graphSolved = r14
        L_0x0051:
            int r0 = r5.value
            r9.addEquality(r7, r0)
            androidx.constraintlayout.solver.widgets.analyzer.HorizontalWidgetRun r0 = r13.horizontalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r0.end
            int r0 = r0.value
            r9.addEquality(r6, r0)
            androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun r0 = r13.verticalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r0.start
            int r0 = r0.value
            r9.addEquality(r4, r0)
            androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun r0 = r13.verticalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r0.end
            int r0 = r0.value
            r9.addEquality(r3, r0)
            androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun r0 = r13.verticalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r0.baseline
            int r0 = r0.value
            r9.addEquality(r1, r0)
            androidx.constraintlayout.solver.widgets.ConstraintWidget r0 = r13.mParent
            if (r0 == 0) goto L_0x00ce
            if (r0 == 0) goto L_0x008a
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r1 = r0.mListDimensionBehaviors
            r1 = r1[r12]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r2 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.WRAP_CONTENT
            if (r1 != r2) goto L_0x008a
            r1 = 1
            goto L_0x008b
        L_0x008a:
            r1 = r12
        L_0x008b:
            if (r0 == 0) goto L_0x0098
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r0 = r0.mListDimensionBehaviors
            r2 = 1
            r0 = r0[r2]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r2 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.WRAP_CONTENT
            if (r0 != r2) goto L_0x0098
            r0 = 1
            goto L_0x0099
        L_0x0098:
            r0 = r12
        L_0x0099:
            if (r1 == 0) goto L_0x00b3
            boolean[] r1 = r13.isTerminalWidget
            boolean r1 = r1[r12]
            if (r1 == 0) goto L_0x00b3
            boolean r1 = r45.isInHorizontalChain()
            if (r1 != 0) goto L_0x00b3
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r13.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mRight
            androidx.constraintlayout.solver.SolverVariable r1 = r9.createObjectVariable(r1)
            r2 = 7
            r9.addGreaterThan(r1, r6, r12, r2)
        L_0x00b3:
            if (r0 == 0) goto L_0x00ce
            boolean[] r0 = r13.isTerminalWidget
            r1 = 1
            boolean r0 = r0[r1]
            if (r0 == 0) goto L_0x00ce
            boolean r0 = r45.isInVerticalChain()
            if (r0 != 0) goto L_0x00ce
            androidx.constraintlayout.solver.widgets.ConstraintWidget r0 = r13.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r0.mBottom
            androidx.constraintlayout.solver.SolverVariable r0 = r9.createObjectVariable(r0)
            r1 = 7
            r9.addGreaterThan(r0, r3, r12, r1)
        L_0x00ce:
            return
        L_0x00cf:
            if (r0 == 0) goto L_0x00d6
            long r14 = r0.linearSolved
            long r14 = r14 + r10
            r0.linearSolved = r14
        L_0x00d6:
            androidx.constraintlayout.solver.widgets.ConstraintWidget r0 = r13.mParent
            r15 = 8
            if (r0 == 0) goto L_0x0168
            if (r0 == 0) goto L_0x00e8
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r2 = r0.mListDimensionBehaviors
            r2 = r2[r12]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r5 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.WRAP_CONTENT
            if (r2 != r5) goto L_0x00e8
            r2 = 1
            goto L_0x00e9
        L_0x00e8:
            r2 = r12
        L_0x00e9:
            if (r0 == 0) goto L_0x00f6
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r0 = r0.mListDimensionBehaviors
            r5 = 1
            r0 = r0[r5]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r5 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.WRAP_CONTENT
            if (r0 != r5) goto L_0x00f6
            r0 = 1
            goto L_0x00f7
        L_0x00f6:
            r0 = r12
        L_0x00f7:
            boolean r5 = r13.isChainHead(r12)
            if (r5 == 0) goto L_0x0106
            androidx.constraintlayout.solver.widgets.ConstraintWidget r5 = r13.mParent
            androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer r5 = (androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer) r5
            r5.addChain(r13, r12)
            r5 = 1
            goto L_0x010a
        L_0x0106:
            boolean r5 = r45.isInHorizontalChain()
        L_0x010a:
            r8 = 1
            boolean r10 = r13.isChainHead(r8)
            if (r10 == 0) goto L_0x011a
            androidx.constraintlayout.solver.widgets.ConstraintWidget r10 = r13.mParent
            androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer r10 = (androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer) r10
            r10.addChain(r13, r8)
            r8 = 1
            goto L_0x011e
        L_0x011a:
            boolean r8 = r45.isInVerticalChain()
        L_0x011e:
            if (r5 != 0) goto L_0x013e
            if (r2 == 0) goto L_0x013e
            int r10 = r13.mVisibility
            if (r10 == r15) goto L_0x013e
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r13.mLeft
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r10.mTarget
            if (r10 != 0) goto L_0x013e
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r13.mRight
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r10.mTarget
            if (r10 != 0) goto L_0x013e
            androidx.constraintlayout.solver.widgets.ConstraintWidget r10 = r13.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r10.mRight
            androidx.constraintlayout.solver.SolverVariable r10 = r9.createObjectVariable(r10)
            r11 = 1
            r9.addGreaterThan(r10, r6, r12, r11)
        L_0x013e:
            if (r8 != 0) goto L_0x0162
            if (r0 == 0) goto L_0x0162
            int r10 = r13.mVisibility
            if (r10 == r15) goto L_0x0162
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r13.mTop
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r10.mTarget
            if (r10 != 0) goto L_0x0162
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r13.mBottom
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r10.mTarget
            if (r10 != 0) goto L_0x0162
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r13.mBaseline
            if (r10 != 0) goto L_0x0162
            androidx.constraintlayout.solver.widgets.ConstraintWidget r10 = r13.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r10.mBottom
            androidx.constraintlayout.solver.SolverVariable r10 = r9.createObjectVariable(r10)
            r11 = 1
            r9.addGreaterThan(r10, r3, r12, r11)
        L_0x0162:
            r14 = r2
            r27 = r5
            r26 = r8
            goto L_0x016e
        L_0x0168:
            r0 = r12
            r14 = r0
            r26 = r14
            r27 = r26
        L_0x016e:
            int r2 = r13.mWidth
            int r5 = r13.mMinWidth
            if (r2 >= r5) goto L_0x0175
            goto L_0x0176
        L_0x0175:
            r5 = r2
        L_0x0176:
            int r8 = r13.mHeight
            int r10 = r13.mMinHeight
            if (r8 >= r10) goto L_0x017d
            goto L_0x017e
        L_0x017d:
            r10 = r8
        L_0x017e:
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r11 = r13.mListDimensionBehaviors
            r15 = r11[r12]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r12 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            r20 = r1
            if (r15 == r12) goto L_0x018a
            r1 = 1
            goto L_0x018b
        L_0x018a:
            r1 = 0
        L_0x018b:
            r17 = 1
            r11 = r11[r17]
            r21 = r3
            r25 = r4
            if (r11 == r12) goto L_0x0197
            r3 = 1
            goto L_0x0198
        L_0x0197:
            r3 = 0
        L_0x0198:
            int r4 = r13.mDimensionRatioSide
            r13.mResolvedDimensionRatioSide = r4
            r22 = r5
            float r5 = r13.mDimensionRatio
            r13.mResolvedDimensionRatio = r5
            r23 = r10
            int r10 = r13.mMatchConstraintDefaultWidth
            r28 = r6
            int r6 = r13.mMatchConstraintDefaultHeight
            r24 = 0
            int r24 = (r5 > r24 ? 1 : (r5 == r24 ? 0 : -1))
            r29 = 4
            r30 = r7
            if (r24 <= 0) goto L_0x021b
            int r7 = r13.mVisibility
            r9 = 8
            if (r7 == r9) goto L_0x021d
            r7 = 3
            if (r15 != r12) goto L_0x01c0
            if (r10 != 0) goto L_0x01c0
            r10 = r7
        L_0x01c0:
            if (r11 != r12) goto L_0x01c5
            if (r6 != 0) goto L_0x01c5
            r6 = r7
        L_0x01c5:
            if (r15 != r12) goto L_0x01d1
            if (r11 != r12) goto L_0x01d1
            if (r10 != r7) goto L_0x01d1
            if (r6 != r7) goto L_0x01d1
            r13.setupDimensionRatio(r14, r0, r1, r3)
            goto L_0x0211
        L_0x01d1:
            if (r15 != r12) goto L_0x01e8
            if (r10 != r7) goto L_0x01e8
            r1 = 0
            r13.mResolvedDimensionRatioSide = r1
            float r1 = (float) r8
            float r5 = r5 * r1
            int r5 = (int) r5
            r32 = r6
            if (r11 == r12) goto L_0x01e5
            r33 = r29
            r7 = 0
            r29 = r23
            goto L_0x0226
        L_0x01e5:
            r33 = r10
            goto L_0x0217
        L_0x01e8:
            if (r11 != r12) goto L_0x0211
            if (r6 != r7) goto L_0x0211
            r1 = 1
            r13.mResolvedDimensionRatioSide = r1
            r1 = -1
            if (r4 != r1) goto L_0x01f7
            r1 = 1065353216(0x3f800000, float:1.0)
            float r1 = r1 / r5
            r13.mResolvedDimensionRatio = r1
        L_0x01f7:
            float r1 = r13.mResolvedDimensionRatio
            float r2 = (float) r2
            float r1 = r1 * r2
            int r1 = (int) r1
            if (r15 == r12) goto L_0x0208
            r33 = r10
            r5 = r22
            r32 = r29
            r7 = 0
            r29 = r1
            goto L_0x0226
        L_0x0208:
            r29 = r1
            r32 = r6
            r33 = r10
            r5 = r22
            goto L_0x0219
        L_0x0211:
            r32 = r6
            r33 = r10
            r5 = r22
        L_0x0217:
            r29 = r23
        L_0x0219:
            r7 = 1
            goto L_0x0226
        L_0x021b:
            r9 = 8
        L_0x021d:
            r32 = r6
            r33 = r10
            r5 = r22
            r29 = r23
            r7 = 0
        L_0x0226:
            int[] r1 = r13.mResolvedMatchConstraintDefault
            r2 = 0
            r1[r2] = r33
            r2 = 1
            r1[r2] = r32
            r13.mResolvedHasRatio = r7
            if (r7 == 0) goto L_0x023c
            int r1 = r13.mResolvedDimensionRatioSide
            r6 = -1
            if (r1 == 0) goto L_0x0239
            if (r1 != r6) goto L_0x023d
        L_0x0239:
            r18 = 1
            goto L_0x023f
        L_0x023c:
            r6 = -1
        L_0x023d:
            r18 = 0
        L_0x023f:
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r1 = r13.mListDimensionBehaviors
            r2 = 0
            r1 = r1[r2]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r4 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.WRAP_CONTENT
            if (r1 != r4) goto L_0x024f
            boolean r1 = r13 instanceof androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer
            if (r1 == 0) goto L_0x024f
            r31 = 1
            goto L_0x0251
        L_0x024f:
            r31 = 0
        L_0x0251:
            if (r31 == 0) goto L_0x0256
            r34 = 0
            goto L_0x0258
        L_0x0256:
            r34 = r5
        L_0x0258:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r13.mCenter
            boolean r1 = r1.isConnected()
            r3 = 1
            r35 = r1 ^ 1
            int r1 = r13.mHorizontalResolution
            r15 = 2
            r36 = 0
            if (r1 == r15) goto L_0x034e
            androidx.constraintlayout.solver.widgets.analyzer.HorizontalWidgetRun r1 = r13.horizontalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r2 = r1.start
            boolean r5 = r2.resolved
            if (r5 == 0) goto L_0x02c0
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            boolean r1 = r1.resolved
            if (r1 != 0) goto L_0x0277
            goto L_0x02c0
        L_0x0277:
            int r1 = r2.value
            r17 = r9
            r12 = r30
            r9 = r46
            r9.addEquality(r12, r1)
            androidx.constraintlayout.solver.widgets.analyzer.HorizontalWidgetRun r1 = r13.horizontalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            int r1 = r1.value
            r11 = r28
            r9.addEquality(r11, r1)
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r13.mParent
            if (r1 == 0) goto L_0x02ac
            if (r14 == 0) goto L_0x02ac
            boolean[] r1 = r13.isTerminalWidget
            r2 = 0
            boolean r1 = r1[r2]
            if (r1 == 0) goto L_0x02ac
            boolean r1 = r45.isInHorizontalChain()
            if (r1 != 0) goto L_0x02ac
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r13.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mRight
            androidx.constraintlayout.solver.SolverVariable r1 = r9.createObjectVariable(r1)
            r10 = 7
            r9.addGreaterThan(r1, r11, r2, r10)
        L_0x02ac:
            r40 = r0
            r44 = r4
            r38 = r7
            r37 = r11
            r30 = r12
            r39 = r14
            r41 = r20
            r42 = r21
            r43 = r25
            goto L_0x0360
        L_0x02c0:
            r17 = r9
            r11 = r28
            r12 = r30
            r10 = 7
            r9 = r46
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r13.mParent
            if (r1 == 0) goto L_0x02d6
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mRight
            androidx.constraintlayout.solver.SolverVariable r1 = r9.createObjectVariable(r1)
            r28 = r1
            goto L_0x02d8
        L_0x02d6:
            r28 = r36
        L_0x02d8:
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r13.mParent
            if (r1 == 0) goto L_0x02e5
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mLeft
            androidx.constraintlayout.solver.SolverVariable r1 = r9.createObjectVariable(r1)
            r30 = r1
            goto L_0x02e7
        L_0x02e5:
            r30 = r36
        L_0x02e7:
            r2 = 1
            boolean[] r1 = r13.isTerminalWidget
            r16 = 0
            boolean r5 = r1[r16]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r1 = r13.mListDimensionBehaviors
            r8 = r1[r16]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r13.mLeft
            r19 = r10
            r10 = r1
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r13.mRight
            r37 = r11
            r11 = r1
            int r1 = r13.mX
            r38 = r12
            r2 = r16
            r12 = r1
            int r1 = r13.mMinWidth
            r39 = r14
            r14 = r1
            int[] r1 = r13.mMaxDimension
            r1 = r1[r2]
            r15 = r1
            float r1 = r13.mHorizontalBiasPercent
            r16 = r1
            int r1 = r13.mMatchConstraintMinWidth
            r22 = r1
            int r1 = r13.mMatchConstraintMaxWidth
            r23 = r1
            float r1 = r13.mMatchConstraintPercentWidth
            r24 = r1
            r40 = r0
            r0 = r45
            r41 = r20
            r1 = r46
            r42 = r21
            r3 = r39
            r44 = r4
            r43 = r25
            r4 = r40
            r17 = r6
            r6 = r30
            r30 = r38
            r38 = r7
            r7 = r28
            r9 = r31
            r13 = r34
            r17 = r18
            r18 = r27
            r19 = r26
            r20 = r33
            r21 = r32
            r25 = r35
            r2 = 1
            r0.applyConstraints(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25)
            goto L_0x035e
        L_0x034e:
            r40 = r0
            r44 = r4
            r38 = r7
            r39 = r14
            r41 = r20
            r42 = r21
            r43 = r25
            r37 = r28
        L_0x035e:
            r13 = r45
        L_0x0360:
            androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun r0 = r13.verticalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r0.start
            boolean r2 = r1.resolved
            if (r2 == 0) goto L_0x03b0
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r0.end
            boolean r0 = r0.resolved
            if (r0 == 0) goto L_0x03b0
            int r0 = r1.value
            r9 = r46
            r7 = r43
            r9.addEquality(r7, r0)
            androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun r0 = r13.verticalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r0.end
            int r0 = r0.value
            r6 = r42
            r9.addEquality(r6, r0)
            androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun r0 = r13.verticalRun
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r0.baseline
            int r0 = r0.value
            r1 = r41
            r9.addEquality(r1, r0)
            androidx.constraintlayout.solver.widgets.ConstraintWidget r0 = r13.mParent
            if (r0 == 0) goto L_0x03ab
            if (r26 != 0) goto L_0x03ab
            if (r40 == 0) goto L_0x03ab
            boolean[] r2 = r13.isTerminalWidget
            r4 = 1
            boolean r2 = r2[r4]
            if (r2 == 0) goto L_0x03a8
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r0.mBottom
            androidx.constraintlayout.solver.SolverVariable r0 = r9.createObjectVariable(r0)
            r2 = 7
            r3 = 0
            r9.addGreaterThan(r0, r6, r3, r2)
            goto L_0x03ae
        L_0x03a8:
            r2 = 7
            r3 = 0
            goto L_0x03ae
        L_0x03ab:
            r2 = 7
            r3 = 0
            r4 = 1
        L_0x03ae:
            r14 = r3
            goto L_0x03bc
        L_0x03b0:
            r9 = r46
            r1 = r41
            r6 = r42
            r7 = r43
            r2 = 7
            r3 = 0
            r4 = 1
            r14 = r4
        L_0x03bc:
            int r0 = r13.mVerticalResolution
            r5 = 2
            if (r0 != r5) goto L_0x03c3
            r12 = r3
            goto L_0x03c4
        L_0x03c3:
            r12 = r14
        L_0x03c4:
            if (r12 == 0) goto L_0x0484
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r0 = r13.mListDimensionBehaviors
            r0 = r0[r4]
            r5 = r44
            if (r0 != r5) goto L_0x03d5
            boolean r0 = r13 instanceof androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer
            if (r0 == 0) goto L_0x03d5
            r17 = r4
            goto L_0x03d7
        L_0x03d5:
            r17 = r3
        L_0x03d7:
            if (r17 == 0) goto L_0x03db
            r29 = r3
        L_0x03db:
            if (r38 == 0) goto L_0x03e7
            int r0 = r13.mResolvedDimensionRatioSide
            if (r0 == r4) goto L_0x03e4
            r5 = -1
            if (r0 != r5) goto L_0x03e7
        L_0x03e4:
            r18 = r4
            goto L_0x03e9
        L_0x03e7:
            r18 = r3
        L_0x03e9:
            androidx.constraintlayout.solver.widgets.ConstraintWidget r0 = r13.mParent
            if (r0 == 0) goto L_0x03f4
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r0.mBottom
            androidx.constraintlayout.solver.SolverVariable r0 = r9.createObjectVariable(r0)
            goto L_0x03f6
        L_0x03f4:
            r0 = r36
        L_0x03f6:
            androidx.constraintlayout.solver.widgets.ConstraintWidget r5 = r13.mParent
            if (r5 == 0) goto L_0x0402
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r5.mTop
            androidx.constraintlayout.solver.SolverVariable r5 = r9.createObjectVariable(r5)
            r36 = r5
        L_0x0402:
            int r5 = r13.mBaselineDistance
            if (r5 > 0) goto L_0x040d
            int r5 = r13.mVisibility
            r8 = 8
            if (r5 != r8) goto L_0x0439
            goto L_0x040f
        L_0x040d:
            r8 = 8
        L_0x040f:
            int r5 = r45.getBaselineDistance()
            r9.addEquality(r1, r7, r5, r2)
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r13.mBaseline
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r5.mTarget
            if (r5 == 0) goto L_0x0432
            androidx.constraintlayout.solver.SolverVariable r5 = r9.createObjectVariable(r5)
            r9.addEquality(r1, r5, r3, r2)
            if (r40 == 0) goto L_0x042f
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r13.mBottom
            androidx.constraintlayout.solver.SolverVariable r1 = r9.createObjectVariable(r1)
            r2 = 5
            r9.addGreaterThan(r0, r1, r3, r2)
        L_0x042f:
            r25 = r3
            goto L_0x043b
        L_0x0432:
            int r5 = r13.mVisibility
            if (r5 != r8) goto L_0x0439
            r9.addEquality(r1, r7, r3, r2)
        L_0x0439:
            r25 = r35
        L_0x043b:
            r2 = 0
            boolean[] r1 = r13.isTerminalWidget
            boolean r5 = r1[r4]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r1 = r13.mListDimensionBehaviors
            r8 = r1[r4]
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r10 = r13.mTop
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r11 = r13.mBottom
            int r12 = r13.mY
            int r14 = r13.mMinHeight
            int[] r1 = r13.mMaxDimension
            r15 = r1[r4]
            float r1 = r13.mVerticalBiasPercent
            r16 = r1
            int r1 = r13.mMatchConstraintMinHeight
            r22 = r1
            int r1 = r13.mMatchConstraintMaxHeight
            r23 = r1
            float r1 = r13.mMatchConstraintPercentHeight
            r24 = r1
            r19 = r0
            r0 = r45
            r1 = r46
            r3 = r40
            r4 = r39
            r28 = r6
            r6 = r36
            r31 = r7
            r7 = r19
            r9 = r17
            r13 = r29
            r17 = r18
            r18 = r26
            r19 = r27
            r20 = r32
            r21 = r33
            r0.applyConstraints(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25)
            goto L_0x0488
        L_0x0484:
            r28 = r6
            r31 = r7
        L_0x0488:
            if (r38 == 0) goto L_0x04b3
            r6 = 7
            r7 = r45
            int r0 = r7.mResolvedDimensionRatioSide
            r1 = 1
            if (r0 != r1) goto L_0x04a2
            float r5 = r7.mResolvedDimensionRatio
            r0 = r46
            r1 = r28
            r2 = r31
            r3 = r37
            r4 = r30
            r0.addRatio(r1, r2, r3, r4, r5, r6)
            goto L_0x04b5
        L_0x04a2:
            float r5 = r7.mResolvedDimensionRatio
            r6 = 7
            r0 = r46
            r1 = r37
            r2 = r30
            r3 = r28
            r4 = r31
            r0.addRatio(r1, r2, r3, r4, r5, r6)
            goto L_0x04b5
        L_0x04b3:
            r7 = r45
        L_0x04b5:
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r7.mCenter
            boolean r0 = r0.isConnected()
            if (r0 == 0) goto L_0x04dd
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r7.mCenter
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r0.getTarget()
            androidx.constraintlayout.solver.widgets.ConstraintWidget r0 = r0.getOwner()
            float r1 = r7.mCircleConstraintAngle
            r2 = 1119092736(0x42b40000, float:90.0)
            float r1 = r1 + r2
            double r1 = (double) r1
            double r1 = java.lang.Math.toRadians(r1)
            float r1 = (float) r1
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r2 = r7.mCenter
            int r2 = r2.getMargin()
            r3 = r46
            r3.addCenterPoint(r7, r0, r1, r2)
        L_0x04dd:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.ConstraintWidget.addToSolver(androidx.constraintlayout.solver.LinearSystem):void");
    }

    public void setupDimensionRatio(boolean z, boolean z2, boolean z3, boolean z4) {
        if (this.mResolvedDimensionRatioSide == -1) {
            if (z3 && !z4) {
                this.mResolvedDimensionRatioSide = 0;
            } else if (!z3 && z4) {
                this.mResolvedDimensionRatioSide = 1;
                if (this.mDimensionRatioSide == -1) {
                    this.mResolvedDimensionRatio = 1.0f / this.mResolvedDimensionRatio;
                }
            }
        }
        if (this.mResolvedDimensionRatioSide == 0 && (!this.mTop.isConnected() || !this.mBottom.isConnected())) {
            this.mResolvedDimensionRatioSide = 1;
        } else if (this.mResolvedDimensionRatioSide == 1 && (!this.mLeft.isConnected() || !this.mRight.isConnected())) {
            this.mResolvedDimensionRatioSide = 0;
        }
        if (this.mResolvedDimensionRatioSide == -1 && (!this.mTop.isConnected() || !this.mBottom.isConnected() || !this.mLeft.isConnected() || !this.mRight.isConnected())) {
            if (this.mTop.isConnected() && this.mBottom.isConnected()) {
                this.mResolvedDimensionRatioSide = 0;
            } else if (this.mLeft.isConnected() && this.mRight.isConnected()) {
                this.mResolvedDimensionRatio = 1.0f / this.mResolvedDimensionRatio;
                this.mResolvedDimensionRatioSide = 1;
            }
        }
        if (this.mResolvedDimensionRatioSide == -1) {
            int i = this.mMatchConstraintMinWidth;
            if (i > 0 && this.mMatchConstraintMinHeight == 0) {
                this.mResolvedDimensionRatioSide = 0;
            } else if (i == 0 && this.mMatchConstraintMinHeight > 0) {
                this.mResolvedDimensionRatio = 1.0f / this.mResolvedDimensionRatio;
                this.mResolvedDimensionRatioSide = 1;
            }
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:103:0x01c0  */
    /* JADX WARNING: Removed duplicated region for block: B:180:0x02cb  */
    /* JADX WARNING: Removed duplicated region for block: B:181:0x02ef  */
    /* JADX WARNING: Removed duplicated region for block: B:184:0x02f9  */
    /* JADX WARNING: Removed duplicated region for block: B:194:0x031b  */
    /* JADX WARNING: Removed duplicated region for block: B:196:0x031f  */
    /* JADX WARNING: Removed duplicated region for block: B:222:0x0364  */
    /* JADX WARNING: Removed duplicated region for block: B:236:0x0384  */
    /* JADX WARNING: Removed duplicated region for block: B:237:0x038a  */
    /* JADX WARNING: Removed duplicated region for block: B:240:0x0393 A[ADDED_TO_REGION] */
    /* JADX WARNING: Removed duplicated region for block: B:247:0x03ac  */
    /* JADX WARNING: Removed duplicated region for block: B:249:0x03b6 A[ADDED_TO_REGION] */
    /* JADX WARNING: Removed duplicated region for block: B:272:? A[ADDED_TO_REGION, RETURN, SYNTHETIC] */
    /* JADX WARNING: Removed duplicated region for block: B:276:? A[ADDED_TO_REGION, RETURN, SYNTHETIC] */
    /* JADX WARNING: Removed duplicated region for block: B:27:0x0087  */
    /* JADX WARNING: Removed duplicated region for block: B:28:0x008b  */
    /* JADX WARNING: Removed duplicated region for block: B:30:0x008f  */
    /* JADX WARNING: Removed duplicated region for block: B:39:0x00ab  */
    /* JADX WARNING: Removed duplicated region for block: B:50:0x00d3  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void applyConstraints(androidx.constraintlayout.solver.LinearSystem r29, boolean r30, boolean r31, boolean r32, boolean r33, androidx.constraintlayout.solver.SolverVariable r34, androidx.constraintlayout.solver.SolverVariable r35, androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour r36, boolean r37, androidx.constraintlayout.solver.widgets.ConstraintAnchor r38, androidx.constraintlayout.solver.widgets.ConstraintAnchor r39, int r40, int r41, int r42, int r43, float r44, boolean r45, boolean r46, boolean r47, int r48, int r49, int r50, int r51, float r52, boolean r53) {
        /*
            r28 = this;
            r0 = r28
            r9 = r29
            r10 = r34
            r11 = r35
            r12 = r38
            r13 = r39
            r14 = r42
            r1 = r43
            r2 = r49
            r3 = r50
            r4 = r51
            androidx.constraintlayout.solver.SolverVariable r15 = r9.createObjectVariable(r12)
            androidx.constraintlayout.solver.SolverVariable r8 = r9.createObjectVariable(r13)
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r38.getTarget()
            androidx.constraintlayout.solver.SolverVariable r7 = r9.createObjectVariable(r5)
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r39.getTarget()
            androidx.constraintlayout.solver.SolverVariable r6 = r9.createObjectVariable(r5)
            androidx.constraintlayout.solver.Metrics r5 = androidx.constraintlayout.solver.LinearSystem.getMetrics()
            if (r5 == 0) goto L_0x0040
            androidx.constraintlayout.solver.Metrics r5 = androidx.constraintlayout.solver.LinearSystem.getMetrics()
            long r11 = r5.nonresolvedWidgets
            r16 = 1
            long r11 = r11 + r16
            r5.nonresolvedWidgets = r11
        L_0x0040:
            boolean r11 = r38.isConnected()
            boolean r12 = r39.isConnected()
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r5 = r0.mCenter
            boolean r16 = r5.isConnected()
            if (r12 == 0) goto L_0x0053
            int r5 = r11 + 1
            goto L_0x0054
        L_0x0053:
            r5 = r11
        L_0x0054:
            if (r16 == 0) goto L_0x0058
            int r5 = r5 + 1
        L_0x0058:
            if (r45 == 0) goto L_0x005d
            r18 = 3
            goto L_0x005f
        L_0x005d:
            r18 = r48
        L_0x005f:
            int[] r17 = androidx.constraintlayout.solver.widgets.ConstraintWidget.AnonymousClass1.$SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintWidget$DimensionBehaviour
            int r19 = r36.ordinal()
            r2 = r17[r19]
            r13 = 1
            if (r2 == r13) goto L_0x0073
            r13 = 2
            if (r2 == r13) goto L_0x0073
            r13 = 3
            if (r2 == r13) goto L_0x0073
            r13 = 4
            if (r2 == r13) goto L_0x0078
        L_0x0073:
            r2 = r18
        L_0x0075:
            r18 = 0
            goto L_0x007f
        L_0x0078:
            r2 = r18
            if (r2 != r13) goto L_0x007d
            goto L_0x0075
        L_0x007d:
            r18 = 1
        L_0x007f:
            int r13 = r0.mVisibility
            r21 = r6
            r6 = 8
            if (r13 != r6) goto L_0x008b
            r6 = 0
            r18 = 0
            goto L_0x008d
        L_0x008b:
            r6 = r41
        L_0x008d:
            if (r53 == 0) goto L_0x00a8
            if (r11 != 0) goto L_0x009b
            if (r12 != 0) goto L_0x009b
            if (r16 != 0) goto L_0x009b
            r13 = r40
            r9.addEquality(r15, r13)
            goto L_0x00a8
        L_0x009b:
            if (r11 == 0) goto L_0x00a8
            if (r12 != 0) goto L_0x00a8
            int r13 = r38.getMargin()
            r10 = 7
            r9.addEquality(r15, r7, r13, r10)
            goto L_0x00a9
        L_0x00a8:
            r10 = 7
        L_0x00a9:
            if (r18 != 0) goto L_0x00d3
            if (r37 == 0) goto L_0x00c1
            r10 = 0
            r13 = 3
            r9.addEquality(r8, r15, r10, r13)
            r10 = 7
            if (r14 <= 0) goto L_0x00b8
            r9.addGreaterThan(r8, r15, r14, r10)
        L_0x00b8:
            r6 = 2147483647(0x7fffffff, float:NaN)
            if (r1 >= r6) goto L_0x00c4
            r9.addLowerThan(r8, r15, r1, r10)
            goto L_0x00c4
        L_0x00c1:
            r9.addEquality(r8, r15, r6, r10)
        L_0x00c4:
            r22 = r3
            r1 = r4
            r13 = r7
            r14 = r8
        L_0x00c9:
            r23 = r18
            r10 = r21
            r18 = r33
        L_0x00cf:
            r21 = r5
            goto L_0x01be
        L_0x00d3:
            r1 = 2
            if (r5 == r1) goto L_0x00f7
            if (r45 != 0) goto L_0x00f7
            r1 = 1
            if (r2 == r1) goto L_0x00dd
            if (r2 != 0) goto L_0x00f7
        L_0x00dd:
            int r1 = java.lang.Math.max(r3, r6)
            if (r4 <= 0) goto L_0x00e7
            int r1 = java.lang.Math.min(r4, r1)
        L_0x00e7:
            r6 = 7
            r9.addEquality(r8, r15, r1, r6)
            r18 = r33
            r22 = r3
            r1 = r4
            r13 = r7
            r14 = r8
            r10 = r21
            r23 = 0
            goto L_0x00cf
        L_0x00f7:
            r1 = -2
            if (r3 != r1) goto L_0x00fc
            r10 = r6
            goto L_0x00fd
        L_0x00fc:
            r10 = r3
        L_0x00fd:
            if (r4 != r1) goto L_0x0101
            r1 = r6
            goto L_0x0102
        L_0x0101:
            r1 = r4
        L_0x0102:
            if (r6 <= 0) goto L_0x0108
            r3 = 1
            if (r2 == r3) goto L_0x0108
            r6 = 0
        L_0x0108:
            if (r10 <= 0) goto L_0x0112
            r3 = 7
            r9.addGreaterThan(r8, r15, r10, r3)
            int r6 = java.lang.Math.max(r6, r10)
        L_0x0112:
            if (r1 <= 0) goto L_0x0129
            if (r31 == 0) goto L_0x011b
            r3 = 1
            if (r2 != r3) goto L_0x011b
            r3 = 0
            goto L_0x011c
        L_0x011b:
            r3 = 1
        L_0x011c:
            if (r3 == 0) goto L_0x0123
            r3 = 7
            r9.addLowerThan(r8, r15, r1, r3)
            goto L_0x0124
        L_0x0123:
            r3 = 7
        L_0x0124:
            int r6 = java.lang.Math.min(r6, r1)
            goto L_0x012a
        L_0x0129:
            r3 = 7
        L_0x012a:
            r4 = 1
            if (r2 != r4) goto L_0x0149
            if (r31 == 0) goto L_0x0133
            r9.addEquality(r8, r15, r6, r3)
            goto L_0x0144
        L_0x0133:
            if (r46 == 0) goto L_0x013d
            r4 = 5
            r9.addEquality(r8, r15, r6, r4)
            r9.addLowerThan(r8, r15, r6, r3)
            goto L_0x0144
        L_0x013d:
            r4 = 5
            r9.addEquality(r8, r15, r6, r4)
            r9.addLowerThan(r8, r15, r6, r3)
        L_0x0144:
            r13 = r7
            r14 = r8
            r22 = r10
            goto L_0x00c9
        L_0x0149:
            r13 = 2
            if (r2 != r13) goto L_0x01b0
            androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r3 = r38.getType()
            androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r4 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.TOP
            if (r3 == r4) goto L_0x0176
            androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r3 = r38.getType()
            androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r6 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.BOTTOM
            if (r3 != r6) goto L_0x015d
            goto L_0x0176
        L_0x015d:
            androidx.constraintlayout.solver.widgets.ConstraintWidget r3 = r0.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r4 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.LEFT
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r3 = r3.getAnchor(r4)
            androidx.constraintlayout.solver.SolverVariable r3 = r9.createObjectVariable(r3)
            androidx.constraintlayout.solver.widgets.ConstraintWidget r4 = r0.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r6 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.RIGHT
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r4 = r4.getAnchor(r6)
            androidx.constraintlayout.solver.SolverVariable r4 = r9.createObjectVariable(r4)
            goto L_0x018c
        L_0x0176:
            androidx.constraintlayout.solver.widgets.ConstraintWidget r3 = r0.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r3 = r3.getAnchor(r4)
            androidx.constraintlayout.solver.SolverVariable r3 = r9.createObjectVariable(r3)
            androidx.constraintlayout.solver.widgets.ConstraintWidget r4 = r0.mParent
            androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r6 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.BOTTOM
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r4 = r4.getAnchor(r6)
            androidx.constraintlayout.solver.SolverVariable r4 = r9.createObjectVariable(r4)
        L_0x018c:
            r18 = r3
            r6 = r4
            androidx.constraintlayout.solver.ArrayRow r3 = r29.createRow()
            r4 = r8
            r13 = r5
            r5 = r15
            r37 = r10
            r10 = r21
            r21 = r13
            r13 = r7
            r7 = r18
            r14 = r8
            r8 = r52
            androidx.constraintlayout.solver.ArrayRow r3 = r3.createRowDimensionRatio(r4, r5, r6, r7, r8)
            r9.addConstraint(r3)
            r18 = r33
            r22 = r37
            r23 = 0
            goto L_0x01be
        L_0x01b0:
            r13 = r7
            r14 = r8
            r37 = r10
            r10 = r21
            r21 = r5
            r22 = r37
            r23 = r18
            r18 = 1
        L_0x01be:
            if (r53 == 0) goto L_0x03ac
            if (r46 == 0) goto L_0x01cc
            r1 = r34
            r4 = r35
            r2 = r14
            r5 = r21
            r3 = 2
            goto L_0x03b4
        L_0x01cc:
            if (r11 != 0) goto L_0x01d4
            if (r12 != 0) goto L_0x01d4
            if (r16 != 0) goto L_0x01d4
            goto L_0x0390
        L_0x01d4:
            if (r11 == 0) goto L_0x01da
            if (r12 != 0) goto L_0x01da
            goto L_0x0390
        L_0x01da:
            if (r11 != 0) goto L_0x01f2
            if (r12 == 0) goto L_0x01f2
            int r0 = r39.getMargin()
            int r0 = -r0
            r1 = 7
            r9.addEquality(r14, r10, r0, r1)
            if (r31 == 0) goto L_0x0390
            r8 = r34
            r0 = 5
            r1 = 0
            r9.addGreaterThan(r15, r8, r1, r0)
            goto L_0x0390
        L_0x01f2:
            r8 = r34
            if (r11 == 0) goto L_0x0390
            if (r12 == 0) goto L_0x0390
            r11 = r38
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r3 = r11.mTarget
            androidx.constraintlayout.solver.widgets.ConstraintWidget r12 = r3.mOwner
            r7 = r39
            r3 = 2
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r4 = r7.mTarget
            androidx.constraintlayout.solver.widgets.ConstraintWidget r6 = r4.mOwner
            androidx.constraintlayout.solver.widgets.ConstraintWidget r5 = r28.getParent()
            if (r23 == 0) goto L_0x02b0
            if (r2 != 0) goto L_0x0240
            if (r1 != 0) goto L_0x0217
            if (r22 != 0) goto L_0x0217
            r28 = 7
            r1 = 7
            r3 = 0
            r4 = 1
            goto L_0x021c
        L_0x0217:
            r28 = 5
            r1 = 5
            r3 = 1
            r4 = 0
        L_0x021c:
            boolean r0 = r12 instanceof androidx.constraintlayout.solver.widgets.Barrier
            if (r0 != 0) goto L_0x0234
            boolean r0 = r6 instanceof androidx.constraintlayout.solver.widgets.Barrier
            if (r0 == 0) goto L_0x0225
            goto L_0x0234
        L_0x0225:
            r16 = r28
            r21 = r4
            r0 = 0
            r4 = 3
            r20 = 5
            r27 = r3
            r3 = r1
            r1 = r27
            goto L_0x02ba
        L_0x0234:
            r16 = r28
            r1 = r3
            r21 = r4
            r0 = 0
            r3 = 4
            r4 = 3
            r20 = 5
            goto L_0x02ba
        L_0x0240:
            r4 = 1
            if (r2 != r4) goto L_0x024b
            r0 = 1
            r1 = 1
            r3 = 4
            r4 = 3
            r16 = 7
            goto L_0x02b6
        L_0x024b:
            r4 = 3
            if (r2 != r4) goto L_0x02ad
            int r0 = r0.mResolvedDimensionRatioSide
            r4 = -1
            if (r0 != r4) goto L_0x026c
            if (r47 == 0) goto L_0x0261
            r0 = 1
            r1 = 1
            r3 = 5
            r4 = 3
            r16 = 7
            if (r31 == 0) goto L_0x025e
            goto L_0x02aa
        L_0x025e:
            r20 = 4
            goto L_0x0269
        L_0x0261:
            r0 = 1
            r1 = 1
            r3 = 5
            r4 = 3
            r16 = 7
            r20 = 7
        L_0x0269:
            r21 = 1
            goto L_0x02ba
        L_0x026c:
            if (r45 == 0) goto L_0x0287
            r0 = r49
            r4 = 3
            if (r0 == r3) goto L_0x0279
            r1 = 1
            if (r0 != r1) goto L_0x0277
            goto L_0x0279
        L_0x0277:
            r0 = 0
            goto L_0x027a
        L_0x0279:
            r0 = 1
        L_0x027a:
            if (r0 != 0) goto L_0x027f
            r0 = 7
            r1 = 5
            goto L_0x0281
        L_0x027f:
            r0 = 5
            r1 = 4
        L_0x0281:
            r16 = r0
            r3 = r1
            r0 = 1
            r1 = 1
            goto L_0x02aa
        L_0x0287:
            r4 = 3
            if (r1 <= 0) goto L_0x028e
            r0 = 1
            r1 = 1
            r3 = 5
            goto L_0x02a8
        L_0x028e:
            if (r1 != 0) goto L_0x02a5
            if (r22 != 0) goto L_0x02a5
            if (r47 != 0) goto L_0x0298
            r0 = 1
            r1 = 1
            r3 = 7
            goto L_0x02a8
        L_0x0298:
            if (r12 == r5) goto L_0x029e
            if (r6 == r5) goto L_0x029e
            r0 = 4
            goto L_0x029f
        L_0x029e:
            r0 = 5
        L_0x029f:
            r16 = r0
            r0 = 1
            r1 = 1
            r3 = 4
            goto L_0x02aa
        L_0x02a5:
            r0 = 1
            r1 = 1
            r3 = 4
        L_0x02a8:
            r16 = 5
        L_0x02aa:
            r20 = 5
            goto L_0x0269
        L_0x02ad:
            r0 = 0
            r1 = 0
            goto L_0x02b3
        L_0x02b0:
            r4 = 3
            r0 = 1
            r1 = 1
        L_0x02b3:
            r3 = 4
            r16 = 5
        L_0x02b6:
            r20 = 5
            r21 = 0
        L_0x02ba:
            if (r0 == 0) goto L_0x02c5
            if (r13 != r10) goto L_0x02c5
            if (r12 == r5) goto L_0x02c5
            r19 = 0
            r24 = 0
            goto L_0x02c9
        L_0x02c5:
            r19 = r0
            r24 = 1
        L_0x02c9:
            if (r1 == 0) goto L_0x02ef
            int r25 = r38.getMargin()
            int r26 = r39.getMargin()
            r0 = r29
            r1 = r15
            r11 = r2
            r2 = r13
            r28 = r11
            r11 = r3
            r3 = r25
            r4 = r44
            r25 = r11
            r11 = r5
            r5 = r10
            r30 = r11
            r11 = r6
            r6 = r14
            r7 = r26
            r8 = r20
            r0.addCentering(r1, r2, r3, r4, r5, r6, r7, r8)
            goto L_0x02f6
        L_0x02ef:
            r28 = r2
            r25 = r3
            r30 = r5
            r11 = r6
        L_0x02f6:
            r0 = 6
            if (r19 == 0) goto L_0x031b
            if (r31 == 0) goto L_0x0309
            if (r13 == r10) goto L_0x0309
            if (r23 != 0) goto L_0x0309
            boolean r1 = r12 instanceof androidx.constraintlayout.solver.widgets.Barrier
            if (r1 != 0) goto L_0x0307
            boolean r1 = r11 instanceof androidx.constraintlayout.solver.widgets.Barrier
            if (r1 == 0) goto L_0x0309
        L_0x0307:
            r1 = r0
            goto L_0x030b
        L_0x0309:
            r1 = r16
        L_0x030b:
            int r2 = r38.getMargin()
            r9.addGreaterThan(r15, r13, r2, r1)
            int r2 = r39.getMargin()
            int r2 = -r2
            r9.addLowerThan(r14, r10, r2, r1)
            goto L_0x031d
        L_0x031b:
            r1 = r16
        L_0x031d:
            if (r24 == 0) goto L_0x0362
            if (r21 == 0) goto L_0x034a
            if (r47 == 0) goto L_0x0325
            if (r32 == 0) goto L_0x034a
        L_0x0325:
            r2 = r30
            if (r12 == r2) goto L_0x032e
            if (r11 != r2) goto L_0x032c
            goto L_0x032e
        L_0x032c:
            r0 = r25
        L_0x032e:
            boolean r2 = r12 instanceof androidx.constraintlayout.solver.widgets.Guideline
            if (r2 != 0) goto L_0x0336
            boolean r2 = r11 instanceof androidx.constraintlayout.solver.widgets.Guideline
            if (r2 == 0) goto L_0x0337
        L_0x0336:
            r0 = 5
        L_0x0337:
            boolean r2 = r12 instanceof androidx.constraintlayout.solver.widgets.Barrier
            if (r2 != 0) goto L_0x033f
            boolean r2 = r11 instanceof androidx.constraintlayout.solver.widgets.Barrier
            if (r2 == 0) goto L_0x0340
        L_0x033f:
            r0 = 5
        L_0x0340:
            r2 = r25
            if (r47 == 0) goto L_0x0345
            r0 = 5
        L_0x0345:
            int r3 = java.lang.Math.max(r0, r2)
            goto L_0x034d
        L_0x034a:
            r2 = r25
            r3 = r2
        L_0x034d:
            if (r31 == 0) goto L_0x0353
            int r3 = java.lang.Math.min(r1, r3)
        L_0x0353:
            int r0 = r38.getMargin()
            r9.addEquality(r15, r13, r0, r3)
            int r0 = r39.getMargin()
            int r0 = -r0
            r9.addEquality(r14, r10, r0, r3)
        L_0x0362:
            if (r31 == 0) goto L_0x0374
            r1 = r34
            if (r1 != r13) goto L_0x036d
            int r0 = r38.getMargin()
            goto L_0x036e
        L_0x036d:
            r0 = 0
        L_0x036e:
            if (r13 == r1) goto L_0x0374
            r2 = 5
            r9.addGreaterThan(r15, r1, r0, r2)
        L_0x0374:
            if (r31 == 0) goto L_0x0390
            if (r23 == 0) goto L_0x0390
            r2 = r14
            if (r42 != 0) goto L_0x0391
            if (r22 != 0) goto L_0x0391
            if (r23 == 0) goto L_0x038a
            r1 = 3
            r0 = r28
            if (r0 != r1) goto L_0x038a
            r0 = 7
            r1 = 0
            r9.addGreaterThan(r2, r15, r1, r0)
            goto L_0x0391
        L_0x038a:
            r1 = 0
            r0 = 5
            r9.addGreaterThan(r2, r15, r1, r0)
            goto L_0x0391
        L_0x0390:
            r2 = r14
        L_0x0391:
            if (r31 == 0) goto L_0x03ab
            if (r18 == 0) goto L_0x03ab
            r0 = r39
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r0.mTarget
            if (r1 == 0) goto L_0x03a2
            int r13 = r39.getMargin()
            r4 = r35
            goto L_0x03a5
        L_0x03a2:
            r4 = r35
            r13 = 0
        L_0x03a5:
            if (r10 == r4) goto L_0x03ab
            r0 = 5
            r9.addGreaterThan(r4, r2, r13, r0)
        L_0x03ab:
            return
        L_0x03ac:
            r1 = r34
            r4 = r35
            r2 = r14
            r3 = 2
            r5 = r21
        L_0x03b4:
            if (r5 >= r3) goto L_0x03f6
            if (r31 == 0) goto L_0x03f6
            if (r18 == 0) goto L_0x03f6
            r3 = 7
            r5 = 0
            r9.addGreaterThan(r15, r1, r5, r3)
            if (r30 != 0) goto L_0x03ca
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r0.mBaseline
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r1 = r1.mTarget
            if (r1 != 0) goto L_0x03c8
            goto L_0x03ca
        L_0x03c8:
            r10 = 0
            goto L_0x03cb
        L_0x03ca:
            r10 = 1
        L_0x03cb:
            if (r30 != 0) goto L_0x03ee
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r0.mBaseline
            androidx.constraintlayout.solver.widgets.ConstraintAnchor r0 = r0.mTarget
            if (r0 == 0) goto L_0x03ee
            androidx.constraintlayout.solver.widgets.ConstraintWidget r0 = r0.mOwner
            float r1 = r0.mDimensionRatio
            r3 = 0
            int r1 = (r1 > r3 ? 1 : (r1 == r3 ? 0 : -1))
            if (r1 == 0) goto L_0x03ec
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r0 = r0.mListDimensionBehaviors
            r1 = 0
            r3 = r0[r1]
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r1 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r3 != r1) goto L_0x03ec
            r3 = 1
            r0 = r0[r3]
            if (r0 != r1) goto L_0x03ec
            r13 = r3
            goto L_0x03ef
        L_0x03ec:
            r13 = 0
            goto L_0x03ef
        L_0x03ee:
            r13 = r10
        L_0x03ef:
            if (r13 == 0) goto L_0x03f6
            r0 = 7
            r1 = 0
            r9.addGreaterThan(r4, r2, r1, r0)
        L_0x03f6:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.ConstraintWidget.applyConstraints(androidx.constraintlayout.solver.LinearSystem, boolean, boolean, boolean, boolean, androidx.constraintlayout.solver.SolverVariable, androidx.constraintlayout.solver.SolverVariable, androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour, boolean, androidx.constraintlayout.solver.widgets.ConstraintAnchor, androidx.constraintlayout.solver.widgets.ConstraintAnchor, int, int, int, int, float, boolean, boolean, boolean, int, int, int, int, float, boolean):void");
    }

    /* renamed from: androidx.constraintlayout.solver.widgets.ConstraintWidget$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type;
        static final /* synthetic */ int[] $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintWidget$DimensionBehaviour;

        /* JADX WARNING: Can't wrap try/catch for region: R(29:0|(2:1|2)|3|(2:5|6)|7|9|10|11|(2:13|14)|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|36) */
        /* JADX WARNING: Can't wrap try/catch for region: R(31:0|1|2|3|(2:5|6)|7|9|10|11|13|14|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|36) */
        /* JADX WARNING: Can't wrap try/catch for region: R(32:0|1|2|3|5|6|7|9|10|11|13|14|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|36) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x0044 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:21:0x004e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:23:0x0058 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:25:0x0062 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:27:0x006d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:29:0x0078 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:31:0x0083 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:33:0x008f */
        static {
            /*
                androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour[] r0 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintWidget$DimensionBehaviour = r0
                r1 = 1
                androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r2 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.FIXED     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r2 = r2.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r0[r2] = r1     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                r0 = 2
                int[] r2 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintWidget$DimensionBehaviour     // Catch:{ NoSuchFieldError -> 0x001d }
                androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r3 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.WRAP_CONTENT     // Catch:{ NoSuchFieldError -> 0x001d }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2[r3] = r0     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                r2 = 3
                int[] r3 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintWidget$DimensionBehaviour     // Catch:{ NoSuchFieldError -> 0x0028 }
                androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r4 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_PARENT     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r3[r4] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                r3 = 4
                int[] r4 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintWidget$DimensionBehaviour     // Catch:{ NoSuchFieldError -> 0x0033 }
                androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r5 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r4[r5] = r3     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type[] r4 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.values()
                int r4 = r4.length
                int[] r4 = new int[r4]
                $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type = r4
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r5 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.LEFT     // Catch:{ NoSuchFieldError -> 0x0044 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0044 }
                r4[r5] = r1     // Catch:{ NoSuchFieldError -> 0x0044 }
            L_0x0044:
                int[] r1 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type     // Catch:{ NoSuchFieldError -> 0x004e }
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r4 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.TOP     // Catch:{ NoSuchFieldError -> 0x004e }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x004e }
                r1[r4] = r0     // Catch:{ NoSuchFieldError -> 0x004e }
            L_0x004e:
                int[] r0 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type     // Catch:{ NoSuchFieldError -> 0x0058 }
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r1 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.RIGHT     // Catch:{ NoSuchFieldError -> 0x0058 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0058 }
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0058 }
            L_0x0058:
                int[] r0 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type     // Catch:{ NoSuchFieldError -> 0x0062 }
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r1 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.BOTTOM     // Catch:{ NoSuchFieldError -> 0x0062 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0062 }
                r0[r1] = r3     // Catch:{ NoSuchFieldError -> 0x0062 }
            L_0x0062:
                int[] r0 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type     // Catch:{ NoSuchFieldError -> 0x006d }
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r1 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.BASELINE     // Catch:{ NoSuchFieldError -> 0x006d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006d }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006d }
            L_0x006d:
                int[] r0 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type     // Catch:{ NoSuchFieldError -> 0x0078 }
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r1 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.CENTER     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r0 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type     // Catch:{ NoSuchFieldError -> 0x0083 }
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r1 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.CENTER_X     // Catch:{ NoSuchFieldError -> 0x0083 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0083 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0083 }
            L_0x0083:
                int[] r0 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type     // Catch:{ NoSuchFieldError -> 0x008f }
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r1 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.CENTER_Y     // Catch:{ NoSuchFieldError -> 0x008f }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x008f }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x008f }
            L_0x008f:
                int[] r0 = $SwitchMap$androidx$constraintlayout$solver$widgets$ConstraintAnchor$Type     // Catch:{ NoSuchFieldError -> 0x009b }
                androidx.constraintlayout.solver.widgets.ConstraintAnchor$Type r1 = androidx.constraintlayout.solver.widgets.ConstraintAnchor.Type.NONE     // Catch:{ NoSuchFieldError -> 0x009b }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x009b }
                r2 = 9
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x009b }
            L_0x009b:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.ConstraintWidget.AnonymousClass1.<clinit>():void");
        }
    }

    public void updateFromSolver(LinearSystem linearSystem) {
        int objectVariableValue = linearSystem.getObjectVariableValue(this.mLeft);
        int objectVariableValue2 = linearSystem.getObjectVariableValue(this.mTop);
        int objectVariableValue3 = linearSystem.getObjectVariableValue(this.mRight);
        int objectVariableValue4 = linearSystem.getObjectVariableValue(this.mBottom);
        HorizontalWidgetRun horizontalWidgetRun = this.horizontalRun;
        DependencyNode dependencyNode = horizontalWidgetRun.start;
        if (dependencyNode.resolved) {
            DependencyNode dependencyNode2 = horizontalWidgetRun.end;
            if (dependencyNode2.resolved) {
                objectVariableValue = dependencyNode.value;
                objectVariableValue3 = dependencyNode2.value;
            }
        }
        VerticalWidgetRun verticalWidgetRun = this.verticalRun;
        DependencyNode dependencyNode3 = verticalWidgetRun.start;
        if (dependencyNode3.resolved) {
            DependencyNode dependencyNode4 = verticalWidgetRun.end;
            if (dependencyNode4.resolved) {
                objectVariableValue2 = dependencyNode3.value;
                objectVariableValue4 = dependencyNode4.value;
            }
        }
        int i = objectVariableValue4 - objectVariableValue2;
        if (objectVariableValue3 - objectVariableValue < 0 || i < 0 || objectVariableValue == Integer.MIN_VALUE || objectVariableValue == Integer.MAX_VALUE || objectVariableValue2 == Integer.MIN_VALUE || objectVariableValue2 == Integer.MAX_VALUE || objectVariableValue3 == Integer.MIN_VALUE || objectVariableValue3 == Integer.MAX_VALUE || objectVariableValue4 == Integer.MIN_VALUE || objectVariableValue4 == Integer.MAX_VALUE) {
            objectVariableValue4 = 0;
            objectVariableValue = 0;
            objectVariableValue2 = 0;
            objectVariableValue3 = 0;
        }
        setFrame(objectVariableValue, objectVariableValue2, objectVariableValue3, objectVariableValue4);
    }

    public void copy(ConstraintWidget constraintWidget, HashMap<ConstraintWidget, ConstraintWidget> hashMap) {
        this.mHorizontalResolution = constraintWidget.mHorizontalResolution;
        this.mVerticalResolution = constraintWidget.mVerticalResolution;
        this.mMatchConstraintDefaultWidth = constraintWidget.mMatchConstraintDefaultWidth;
        this.mMatchConstraintDefaultHeight = constraintWidget.mMatchConstraintDefaultHeight;
        int[] iArr = this.mResolvedMatchConstraintDefault;
        int[] iArr2 = constraintWidget.mResolvedMatchConstraintDefault;
        iArr[0] = iArr2[0];
        iArr[1] = iArr2[1];
        this.mMatchConstraintMinWidth = constraintWidget.mMatchConstraintMinWidth;
        this.mMatchConstraintMaxWidth = constraintWidget.mMatchConstraintMaxWidth;
        this.mMatchConstraintMinHeight = constraintWidget.mMatchConstraintMinHeight;
        this.mMatchConstraintMaxHeight = constraintWidget.mMatchConstraintMaxHeight;
        this.mMatchConstraintPercentHeight = constraintWidget.mMatchConstraintPercentHeight;
        this.mIsWidthWrapContent = constraintWidget.mIsWidthWrapContent;
        this.mIsHeightWrapContent = constraintWidget.mIsHeightWrapContent;
        this.mResolvedDimensionRatioSide = constraintWidget.mResolvedDimensionRatioSide;
        this.mResolvedDimensionRatio = constraintWidget.mResolvedDimensionRatio;
        int[] iArr3 = constraintWidget.mMaxDimension;
        this.mMaxDimension = Arrays.copyOf(iArr3, iArr3.length);
        this.mCircleConstraintAngle = constraintWidget.mCircleConstraintAngle;
        this.hasBaseline = constraintWidget.hasBaseline;
        this.inPlaceholder = constraintWidget.inPlaceholder;
        this.mLeft.reset();
        this.mTop.reset();
        this.mRight.reset();
        this.mBottom.reset();
        this.mBaseline.reset();
        this.mCenterX.reset();
        this.mCenterY.reset();
        this.mCenter.reset();
        this.mListDimensionBehaviors = (DimensionBehaviour[]) Arrays.copyOf(this.mListDimensionBehaviors, 2);
        ConstraintWidget constraintWidget2 = null;
        this.mParent = this.mParent == null ? null : hashMap.get(constraintWidget.mParent);
        this.mWidth = constraintWidget.mWidth;
        this.mHeight = constraintWidget.mHeight;
        this.mDimensionRatio = constraintWidget.mDimensionRatio;
        this.mDimensionRatioSide = constraintWidget.mDimensionRatioSide;
        this.mX = constraintWidget.mX;
        this.mY = constraintWidget.mY;
        this.mRelX = constraintWidget.mRelX;
        this.mRelY = constraintWidget.mRelY;
        this.mOffsetX = constraintWidget.mOffsetX;
        this.mOffsetY = constraintWidget.mOffsetY;
        this.mBaselineDistance = constraintWidget.mBaselineDistance;
        this.mMinWidth = constraintWidget.mMinWidth;
        this.mMinHeight = constraintWidget.mMinHeight;
        this.mHorizontalBiasPercent = constraintWidget.mHorizontalBiasPercent;
        this.mVerticalBiasPercent = constraintWidget.mVerticalBiasPercent;
        this.mCompanionWidget = constraintWidget.mCompanionWidget;
        this.mContainerItemSkip = constraintWidget.mContainerItemSkip;
        this.mVisibility = constraintWidget.mVisibility;
        this.mDebugName = constraintWidget.mDebugName;
        this.mType = constraintWidget.mType;
        this.mDistToTop = constraintWidget.mDistToTop;
        this.mDistToLeft = constraintWidget.mDistToLeft;
        this.mDistToRight = constraintWidget.mDistToRight;
        this.mDistToBottom = constraintWidget.mDistToBottom;
        this.mLeftHasCentered = constraintWidget.mLeftHasCentered;
        this.mRightHasCentered = constraintWidget.mRightHasCentered;
        this.mTopHasCentered = constraintWidget.mTopHasCentered;
        this.mBottomHasCentered = constraintWidget.mBottomHasCentered;
        this.mHorizontalWrapVisited = constraintWidget.mHorizontalWrapVisited;
        this.mVerticalWrapVisited = constraintWidget.mVerticalWrapVisited;
        this.mOptimizerMeasurable = constraintWidget.mOptimizerMeasurable;
        this.mGroupsToSolver = constraintWidget.mGroupsToSolver;
        this.mHorizontalChainStyle = constraintWidget.mHorizontalChainStyle;
        this.mVerticalChainStyle = constraintWidget.mVerticalChainStyle;
        this.mHorizontalChainFixedPosition = constraintWidget.mHorizontalChainFixedPosition;
        this.mVerticalChainFixedPosition = constraintWidget.mVerticalChainFixedPosition;
        float[] fArr = this.mWeight;
        float[] fArr2 = constraintWidget.mWeight;
        fArr[0] = fArr2[0];
        fArr[1] = fArr2[1];
        ConstraintWidget[] constraintWidgetArr = this.mListNextMatchConstraintsWidget;
        ConstraintWidget[] constraintWidgetArr2 = constraintWidget.mListNextMatchConstraintsWidget;
        constraintWidgetArr[0] = constraintWidgetArr2[0];
        constraintWidgetArr[1] = constraintWidgetArr2[1];
        ConstraintWidget[] constraintWidgetArr3 = this.mNextChainWidget;
        ConstraintWidget[] constraintWidgetArr4 = constraintWidget.mNextChainWidget;
        constraintWidgetArr3[0] = constraintWidgetArr4[0];
        constraintWidgetArr3[1] = constraintWidgetArr4[1];
        ConstraintWidget constraintWidget3 = constraintWidget.mHorizontalNextWidget;
        this.mHorizontalNextWidget = constraintWidget3 == null ? null : hashMap.get(constraintWidget3);
        ConstraintWidget constraintWidget4 = constraintWidget.mVerticalNextWidget;
        if (constraintWidget4 != null) {
            constraintWidget2 = hashMap.get(constraintWidget4);
        }
        this.mVerticalNextWidget = constraintWidget2;
    }

    public void updateFromRuns(boolean z, boolean z2) {
        int i;
        int i2;
        boolean isResolved = z & this.horizontalRun.isResolved();
        boolean isResolved2 = z2 & this.verticalRun.isResolved();
        HorizontalWidgetRun horizontalWidgetRun = this.horizontalRun;
        int i3 = horizontalWidgetRun.start.value;
        VerticalWidgetRun verticalWidgetRun = this.verticalRun;
        int i4 = verticalWidgetRun.start.value;
        int i5 = horizontalWidgetRun.end.value;
        int i6 = verticalWidgetRun.end.value;
        int i7 = i6 - i4;
        if (i5 - i3 < 0 || i7 < 0 || i3 == Integer.MIN_VALUE || i3 == Integer.MAX_VALUE || i4 == Integer.MIN_VALUE || i4 == Integer.MAX_VALUE || i5 == Integer.MIN_VALUE || i5 == Integer.MAX_VALUE || i6 == Integer.MIN_VALUE || i6 == Integer.MAX_VALUE) {
            i5 = 0;
            i3 = 0;
            i6 = 0;
            i4 = 0;
        }
        int i8 = i5 - i3;
        int i9 = i6 - i4;
        if (isResolved) {
            this.mX = i3;
        }
        if (isResolved2) {
            this.mY = i4;
        }
        if (this.mVisibility == 8) {
            this.mWidth = 0;
            this.mHeight = 0;
            return;
        }
        if (isResolved) {
            if (this.mListDimensionBehaviors[0] == DimensionBehaviour.FIXED && i8 < (i2 = this.mWidth)) {
                i8 = i2;
            }
            this.mWidth = i8;
            int i10 = this.mMinWidth;
            if (i8 < i10) {
                this.mWidth = i10;
            }
        }
        if (isResolved2) {
            if (this.mListDimensionBehaviors[1] == DimensionBehaviour.FIXED && i9 < (i = this.mHeight)) {
                i9 = i;
            }
            this.mHeight = i9;
            int i11 = this.mMinHeight;
            if (i9 < i11) {
                this.mHeight = i11;
            }
        }
    }
}
