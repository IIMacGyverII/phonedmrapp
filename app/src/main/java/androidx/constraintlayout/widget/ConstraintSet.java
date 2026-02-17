package androidx.constraintlayout.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.content.res.XmlResourceParser;
import android.graphics.Color;
import android.util.AttributeSet;
import android.util.Log;
import android.util.SparseArray;
import android.util.SparseIntArray;
import android.util.Xml;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.constraintlayout.motion.utils.Easing;
import androidx.constraintlayout.motion.widget.Debug;
import androidx.constraintlayout.motion.widget.MotionScene;
import androidx.constraintlayout.solver.widgets.ConstraintWidget;
import androidx.constraintlayout.solver.widgets.HelperWidget;
import androidx.constraintlayout.widget.ConstraintAttribute;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.constraintlayout.widget.Constraints;
import androidx.constraintlayout.widget.R;
import com.mediatek.util.MtkPatterns;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import org.xmlpull.v1.XmlPullParserException;

public class ConstraintSet {
    private static final int ALPHA = 43;
    private static final int ANIMATE_RELATIVE_TO = 64;
    private static final int BARRIER_ALLOWS_GONE_WIDGETS = 75;
    private static final int BARRIER_DIRECTION = 72;
    private static final int BARRIER_MARGIN = 73;
    private static final int BARRIER_TYPE = 1;
    public static final int BASELINE = 5;
    private static final int BASELINE_TO_BASELINE = 1;
    public static final int BOTTOM = 4;
    private static final int BOTTOM_MARGIN = 2;
    private static final int BOTTOM_TO_BOTTOM = 3;
    private static final int BOTTOM_TO_TOP = 4;
    public static final int CHAIN_PACKED = 2;
    public static final int CHAIN_SPREAD = 0;
    public static final int CHAIN_SPREAD_INSIDE = 1;
    private static final int CHAIN_USE_RTL = 71;
    private static final int CIRCLE = 61;
    private static final int CIRCLE_ANGLE = 63;
    private static final int CIRCLE_RADIUS = 62;
    private static final int CONSTRAINED_HEIGHT = 81;
    private static final int CONSTRAINED_WIDTH = 80;
    private static final int CONSTRAINT_REFERENCED_IDS = 74;
    private static final int CONSTRAINT_TAG = 77;
    private static final boolean DEBUG = false;
    private static final int DIMENSION_RATIO = 5;
    private static final int DRAW_PATH = 66;
    private static final int EDITOR_ABSOLUTE_X = 6;
    private static final int EDITOR_ABSOLUTE_Y = 7;
    private static final int ELEVATION = 44;
    public static final int END = 7;
    private static final int END_MARGIN = 8;
    private static final int END_TO_END = 9;
    private static final int END_TO_START = 10;
    private static final String ERROR_MESSAGE = "XML parser error must be within a Constraint ";
    public static final int GONE = 8;
    private static final int GONE_BOTTOM_MARGIN = 11;
    private static final int GONE_END_MARGIN = 12;
    private static final int GONE_LEFT_MARGIN = 13;
    private static final int GONE_RIGHT_MARGIN = 14;
    private static final int GONE_START_MARGIN = 15;
    private static final int GONE_TOP_MARGIN = 16;
    private static final int GUIDE_BEGIN = 17;
    private static final int GUIDE_END = 18;
    private static final int GUIDE_PERCENT = 19;
    private static final int HEIGHT_DEFAULT = 55;
    private static final int HEIGHT_MAX = 57;
    private static final int HEIGHT_MIN = 59;
    private static final int HEIGHT_PERCENT = 70;
    public static final int HORIZONTAL = 0;
    private static final int HORIZONTAL_BIAS = 20;
    public static final int HORIZONTAL_GUIDELINE = 0;
    private static final int HORIZONTAL_STYLE = 41;
    private static final int HORIZONTAL_WEIGHT = 39;
    public static final int INVISIBLE = 4;
    private static final int LAYOUT_HEIGHT = 21;
    private static final int LAYOUT_VISIBILITY = 22;
    private static final int LAYOUT_WIDTH = 23;
    public static final int LEFT = 1;
    private static final int LEFT_MARGIN = 24;
    private static final int LEFT_TO_LEFT = 25;
    private static final int LEFT_TO_RIGHT = 26;
    public static final int MATCH_CONSTRAINT = 0;
    public static final int MATCH_CONSTRAINT_SPREAD = 0;
    public static final int MATCH_CONSTRAINT_WRAP = 1;
    private static final int MOTION_STAGGER = 79;
    private static final int ORIENTATION = 27;
    public static final int PARENT_ID = 0;
    private static final int PATH_MOTION_ARC = 76;
    private static final int PROGRESS = 68;
    public static final int RIGHT = 2;
    private static final int RIGHT_MARGIN = 28;
    private static final int RIGHT_TO_LEFT = 29;
    private static final int RIGHT_TO_RIGHT = 30;
    private static final int ROTATION = 60;
    private static final int ROTATION_X = 45;
    private static final int ROTATION_Y = 46;
    private static final int SCALE_X = 47;
    private static final int SCALE_Y = 48;
    public static final int START = 6;
    private static final int START_MARGIN = 31;
    private static final int START_TO_END = 32;
    private static final int START_TO_START = 33;
    private static final String TAG = "ConstraintSet";
    public static final int TOP = 3;
    private static final int TOP_MARGIN = 34;
    private static final int TOP_TO_BOTTOM = 35;
    private static final int TOP_TO_TOP = 36;
    private static final int TRANSFORM_PIVOT_X = 49;
    private static final int TRANSFORM_PIVOT_Y = 50;
    private static final int TRANSITION_EASING = 65;
    private static final int TRANSITION_PATH_ROTATE = 67;
    private static final int TRANSLATION_X = 51;
    private static final int TRANSLATION_Y = 52;
    private static final int TRANSLATION_Z = 53;
    public static final int UNSET = -1;
    private static final int UNUSED = 82;
    public static final int VERTICAL = 1;
    private static final int VERTICAL_BIAS = 37;
    public static final int VERTICAL_GUIDELINE = 1;
    private static final int VERTICAL_STYLE = 42;
    private static final int VERTICAL_WEIGHT = 40;
    private static final int VIEW_ID = 38;
    /* access modifiers changed from: private */
    public static final int[] VISIBILITY_FLAGS = {0, 4, 8};
    private static final int VISIBILITY_MODE = 78;
    public static final int VISIBILITY_MODE_IGNORE = 1;
    public static final int VISIBILITY_MODE_NORMAL = 0;
    public static final int VISIBLE = 0;
    private static final int WIDTH_DEFAULT = 54;
    private static final int WIDTH_MAX = 56;
    private static final int WIDTH_MIN = 58;
    private static final int WIDTH_PERCENT = 69;
    public static final int WRAP_CONTENT = -2;
    private static SparseIntArray mapToConstant;
    private HashMap<Integer, Constraint> mConstraints = new HashMap<>();
    private boolean mForceId = true;
    private HashMap<String, ConstraintAttribute> mSavedAttributes = new HashMap<>();
    private boolean mValidate;

    private String sideToString(int i) {
        switch (i) {
            case 1:
                return "left";
            case 2:
                return "right";
            case 3:
                return "top";
            case 4:
                return "bottom";
            case 5:
                return "baseline";
            case 6:
                return MtkPatterns.KEY_URLDATA_START;
            case 7:
                return MtkPatterns.KEY_URLDATA_END;
            default:
                return "undefined";
        }
    }

    static {
        SparseIntArray sparseIntArray = new SparseIntArray();
        mapToConstant = sparseIntArray;
        sparseIntArray.append(R.styleable.Constraint_layout_constraintLeft_toLeftOf, 25);
        mapToConstant.append(R.styleable.Constraint_layout_constraintLeft_toRightOf, 26);
        mapToConstant.append(R.styleable.Constraint_layout_constraintRight_toLeftOf, 29);
        mapToConstant.append(R.styleable.Constraint_layout_constraintRight_toRightOf, 30);
        mapToConstant.append(R.styleable.Constraint_layout_constraintTop_toTopOf, 36);
        mapToConstant.append(R.styleable.Constraint_layout_constraintTop_toBottomOf, 35);
        mapToConstant.append(R.styleable.Constraint_layout_constraintBottom_toTopOf, 4);
        mapToConstant.append(R.styleable.Constraint_layout_constraintBottom_toBottomOf, 3);
        mapToConstant.append(R.styleable.Constraint_layout_constraintBaseline_toBaselineOf, 1);
        mapToConstant.append(R.styleable.Constraint_layout_editor_absoluteX, 6);
        mapToConstant.append(R.styleable.Constraint_layout_editor_absoluteY, 7);
        mapToConstant.append(R.styleable.Constraint_layout_constraintGuide_begin, 17);
        mapToConstant.append(R.styleable.Constraint_layout_constraintGuide_end, 18);
        mapToConstant.append(R.styleable.Constraint_layout_constraintGuide_percent, 19);
        mapToConstant.append(R.styleable.Constraint_android_orientation, 27);
        mapToConstant.append(R.styleable.Constraint_layout_constraintStart_toEndOf, 32);
        mapToConstant.append(R.styleable.Constraint_layout_constraintStart_toStartOf, 33);
        mapToConstant.append(R.styleable.Constraint_layout_constraintEnd_toStartOf, 10);
        mapToConstant.append(R.styleable.Constraint_layout_constraintEnd_toEndOf, 9);
        mapToConstant.append(R.styleable.Constraint_layout_goneMarginLeft, 13);
        mapToConstant.append(R.styleable.Constraint_layout_goneMarginTop, 16);
        mapToConstant.append(R.styleable.Constraint_layout_goneMarginRight, 14);
        mapToConstant.append(R.styleable.Constraint_layout_goneMarginBottom, 11);
        mapToConstant.append(R.styleable.Constraint_layout_goneMarginStart, 15);
        mapToConstant.append(R.styleable.Constraint_layout_goneMarginEnd, 12);
        mapToConstant.append(R.styleable.Constraint_layout_constraintVertical_weight, 40);
        mapToConstant.append(R.styleable.Constraint_layout_constraintHorizontal_weight, 39);
        mapToConstant.append(R.styleable.Constraint_layout_constraintHorizontal_chainStyle, 41);
        mapToConstant.append(R.styleable.Constraint_layout_constraintVertical_chainStyle, 42);
        mapToConstant.append(R.styleable.Constraint_layout_constraintHorizontal_bias, 20);
        mapToConstant.append(R.styleable.Constraint_layout_constraintVertical_bias, 37);
        mapToConstant.append(R.styleable.Constraint_layout_constraintDimensionRatio, 5);
        mapToConstant.append(R.styleable.Constraint_layout_constraintLeft_creator, 82);
        mapToConstant.append(R.styleable.Constraint_layout_constraintTop_creator, 82);
        mapToConstant.append(R.styleable.Constraint_layout_constraintRight_creator, 82);
        mapToConstant.append(R.styleable.Constraint_layout_constraintBottom_creator, 82);
        mapToConstant.append(R.styleable.Constraint_layout_constraintBaseline_creator, 82);
        mapToConstant.append(R.styleable.Constraint_android_layout_marginLeft, 24);
        mapToConstant.append(R.styleable.Constraint_android_layout_marginRight, 28);
        mapToConstant.append(R.styleable.Constraint_android_layout_marginStart, 31);
        mapToConstant.append(R.styleable.Constraint_android_layout_marginEnd, 8);
        mapToConstant.append(R.styleable.Constraint_android_layout_marginTop, 34);
        mapToConstant.append(R.styleable.Constraint_android_layout_marginBottom, 2);
        mapToConstant.append(R.styleable.Constraint_android_layout_width, 23);
        mapToConstant.append(R.styleable.Constraint_android_layout_height, 21);
        mapToConstant.append(R.styleable.Constraint_android_visibility, 22);
        mapToConstant.append(R.styleable.Constraint_android_alpha, 43);
        mapToConstant.append(R.styleable.Constraint_android_elevation, 44);
        mapToConstant.append(R.styleable.Constraint_android_rotationX, 45);
        mapToConstant.append(R.styleable.Constraint_android_rotationY, 46);
        mapToConstant.append(R.styleable.Constraint_android_rotation, 60);
        mapToConstant.append(R.styleable.Constraint_android_scaleX, 47);
        mapToConstant.append(R.styleable.Constraint_android_scaleY, 48);
        mapToConstant.append(R.styleable.Constraint_android_transformPivotX, 49);
        mapToConstant.append(R.styleable.Constraint_android_transformPivotY, 50);
        mapToConstant.append(R.styleable.Constraint_android_translationX, 51);
        mapToConstant.append(R.styleable.Constraint_android_translationY, 52);
        mapToConstant.append(R.styleable.Constraint_android_translationZ, 53);
        mapToConstant.append(R.styleable.Constraint_layout_constraintWidth_default, 54);
        mapToConstant.append(R.styleable.Constraint_layout_constraintHeight_default, 55);
        mapToConstant.append(R.styleable.Constraint_layout_constraintWidth_max, 56);
        mapToConstant.append(R.styleable.Constraint_layout_constraintHeight_max, 57);
        mapToConstant.append(R.styleable.Constraint_layout_constraintWidth_min, 58);
        mapToConstant.append(R.styleable.Constraint_layout_constraintHeight_min, 59);
        mapToConstant.append(R.styleable.Constraint_layout_constraintCircle, 61);
        mapToConstant.append(R.styleable.Constraint_layout_constraintCircleRadius, 62);
        mapToConstant.append(R.styleable.Constraint_layout_constraintCircleAngle, 63);
        mapToConstant.append(R.styleable.Constraint_animate_relativeTo, 64);
        mapToConstant.append(R.styleable.Constraint_transitionEasing, 65);
        mapToConstant.append(R.styleable.Constraint_drawPath, 66);
        mapToConstant.append(R.styleable.Constraint_transitionPathRotate, 67);
        mapToConstant.append(R.styleable.Constraint_motionStagger, 79);
        mapToConstant.append(R.styleable.Constraint_android_id, 38);
        mapToConstant.append(R.styleable.Constraint_progress, 68);
        mapToConstant.append(R.styleable.Constraint_layout_constraintWidth_percent, 69);
        mapToConstant.append(R.styleable.Constraint_layout_constraintHeight_percent, 70);
        mapToConstant.append(R.styleable.Constraint_chainUseRtl, 71);
        mapToConstant.append(R.styleable.Constraint_barrierDirection, 72);
        mapToConstant.append(R.styleable.Constraint_barrierMargin, 73);
        mapToConstant.append(R.styleable.Constraint_constraint_referenced_ids, 74);
        mapToConstant.append(R.styleable.Constraint_barrierAllowsGoneWidgets, 75);
        mapToConstant.append(R.styleable.Constraint_pathMotionArc, 76);
        mapToConstant.append(R.styleable.Constraint_layout_constraintTag, 77);
        mapToConstant.append(R.styleable.Constraint_visibilityMode, 78);
        mapToConstant.append(R.styleable.Constraint_layout_constrainedWidth, 80);
        mapToConstant.append(R.styleable.Constraint_layout_constrainedHeight, 81);
    }

    public HashMap<String, ConstraintAttribute> getCustomAttributeSet() {
        return this.mSavedAttributes;
    }

    public Constraint getParameters(int i) {
        return get(i);
    }

    public void readFallback(ConstraintSet constraintSet) {
        for (Integer next : constraintSet.mConstraints.keySet()) {
            int intValue = next.intValue();
            Constraint constraint = constraintSet.mConstraints.get(next);
            if (!this.mConstraints.containsKey(Integer.valueOf(intValue))) {
                this.mConstraints.put(Integer.valueOf(intValue), new Constraint());
            }
            Constraint constraint2 = this.mConstraints.get(Integer.valueOf(intValue));
            Layout layout = constraint2.layout;
            if (!layout.mApply) {
                layout.copyFrom(constraint.layout);
            }
            PropertySet propertySet = constraint2.propertySet;
            if (!propertySet.mApply) {
                propertySet.copyFrom(constraint.propertySet);
            }
            Transform transform = constraint2.transform;
            if (!transform.mApply) {
                transform.copyFrom(constraint.transform);
            }
            Motion motion = constraint2.motion;
            if (!motion.mApply) {
                motion.copyFrom(constraint.motion);
            }
            for (String next2 : constraint.mCustomConstraints.keySet()) {
                if (!constraint2.mCustomConstraints.containsKey(next2)) {
                    constraint2.mCustomConstraints.put(next2, constraint.mCustomConstraints.get(next2));
                }
            }
        }
    }

    public void readFallback(ConstraintLayout constraintLayout) {
        int childCount = constraintLayout.getChildCount();
        int i = 0;
        while (i < childCount) {
            View childAt = constraintLayout.getChildAt(i);
            ConstraintLayout.LayoutParams layoutParams = (ConstraintLayout.LayoutParams) childAt.getLayoutParams();
            int id = childAt.getId();
            if (!this.mForceId || id != -1) {
                if (!this.mConstraints.containsKey(Integer.valueOf(id))) {
                    this.mConstraints.put(Integer.valueOf(id), new Constraint());
                }
                Constraint constraint = this.mConstraints.get(Integer.valueOf(id));
                if (!constraint.layout.mApply) {
                    constraint.fillFrom(id, layoutParams);
                    if (childAt instanceof ConstraintHelper) {
                        constraint.layout.mReferenceIds = ((ConstraintHelper) childAt).getReferencedIds();
                        if (childAt instanceof Barrier) {
                            Barrier barrier = (Barrier) childAt;
                            constraint.layout.mBarrierAllowsGoneWidgets = barrier.allowsGoneWidget();
                            constraint.layout.mBarrierDirection = barrier.getType();
                            constraint.layout.mBarrierMargin = barrier.getMargin();
                        }
                    }
                    constraint.layout.mApply = true;
                }
                PropertySet propertySet = constraint.propertySet;
                if (!propertySet.mApply) {
                    propertySet.visibility = childAt.getVisibility();
                    constraint.propertySet.alpha = childAt.getAlpha();
                    constraint.propertySet.mApply = true;
                }
                Transform transform = constraint.transform;
                if (!transform.mApply) {
                    transform.mApply = true;
                    transform.rotation = childAt.getRotation();
                    constraint.transform.rotationX = childAt.getRotationX();
                    constraint.transform.rotationY = childAt.getRotationY();
                    constraint.transform.scaleX = childAt.getScaleX();
                    constraint.transform.scaleY = childAt.getScaleY();
                    float pivotX = childAt.getPivotX();
                    float pivotY = childAt.getPivotY();
                    if (!(((double) pivotX) == 0.0d && ((double) pivotY) == 0.0d)) {
                        Transform transform2 = constraint.transform;
                        transform2.transformPivotX = pivotX;
                        transform2.transformPivotY = pivotY;
                    }
                    constraint.transform.translationX = childAt.getTranslationX();
                    constraint.transform.translationY = childAt.getTranslationY();
                    constraint.transform.translationZ = childAt.getTranslationZ();
                    Transform transform3 = constraint.transform;
                    if (transform3.applyElevation) {
                        transform3.elevation = childAt.getElevation();
                    }
                }
                i++;
            } else {
                throw new RuntimeException("All children of ConstraintLayout must have ids to use ConstraintSet");
            }
        }
    }

    public static class Layout {
        private static final int BARRIER_ALLOWS_GONE_WIDGETS = 75;
        private static final int BARRIER_DIRECTION = 72;
        private static final int BARRIER_MARGIN = 73;
        private static final int BASELINE_TO_BASELINE = 1;
        private static final int BOTTOM_MARGIN = 2;
        private static final int BOTTOM_TO_BOTTOM = 3;
        private static final int BOTTOM_TO_TOP = 4;
        private static final int CHAIN_USE_RTL = 71;
        private static final int CIRCLE = 61;
        private static final int CIRCLE_ANGLE = 63;
        private static final int CIRCLE_RADIUS = 62;
        private static final int CONSTRAINT_REFERENCED_IDS = 74;
        private static final int DIMENSION_RATIO = 5;
        private static final int EDITOR_ABSOLUTE_X = 6;
        private static final int EDITOR_ABSOLUTE_Y = 7;
        private static final int END_MARGIN = 8;
        private static final int END_TO_END = 9;
        private static final int END_TO_START = 10;
        private static final int GONE_BOTTOM_MARGIN = 11;
        private static final int GONE_END_MARGIN = 12;
        private static final int GONE_LEFT_MARGIN = 13;
        private static final int GONE_RIGHT_MARGIN = 14;
        private static final int GONE_START_MARGIN = 15;
        private static final int GONE_TOP_MARGIN = 16;
        private static final int GUIDE_BEGIN = 17;
        private static final int GUIDE_END = 18;
        private static final int GUIDE_PERCENT = 19;
        private static final int HEIGHT_PERCENT = 70;
        private static final int HORIZONTAL_BIAS = 20;
        private static final int HORIZONTAL_STYLE = 39;
        private static final int HORIZONTAL_WEIGHT = 37;
        private static final int LAYOUT_HEIGHT = 21;
        private static final int LAYOUT_WIDTH = 22;
        private static final int LEFT_MARGIN = 23;
        private static final int LEFT_TO_LEFT = 24;
        private static final int LEFT_TO_RIGHT = 25;
        private static final int ORIENTATION = 26;
        private static final int RIGHT_MARGIN = 27;
        private static final int RIGHT_TO_LEFT = 28;
        private static final int RIGHT_TO_RIGHT = 29;
        private static final int START_MARGIN = 30;
        private static final int START_TO_END = 31;
        private static final int START_TO_START = 32;
        private static final int TOP_MARGIN = 33;
        private static final int TOP_TO_BOTTOM = 34;
        private static final int TOP_TO_TOP = 35;
        public static final int UNSET = -1;
        private static final int UNUSED = 76;
        private static final int VERTICAL_BIAS = 36;
        private static final int VERTICAL_STYLE = 40;
        private static final int VERTICAL_WEIGHT = 38;
        private static final int WIDTH_PERCENT = 69;
        private static SparseIntArray mapToConstant;
        public int baselineToBaseline = -1;
        public int bottomMargin = -1;
        public int bottomToBottom = -1;
        public int bottomToTop = -1;
        public float circleAngle = 0.0f;
        public int circleConstraint = -1;
        public int circleRadius = 0;
        public boolean constrainedHeight = false;
        public boolean constrainedWidth = false;
        public String dimensionRatio = null;
        public int editorAbsoluteX = -1;
        public int editorAbsoluteY = -1;
        public int endMargin = -1;
        public int endToEnd = -1;
        public int endToStart = -1;
        public int goneBottomMargin = -1;
        public int goneEndMargin = -1;
        public int goneLeftMargin = -1;
        public int goneRightMargin = -1;
        public int goneStartMargin = -1;
        public int goneTopMargin = -1;
        public int guideBegin = -1;
        public int guideEnd = -1;
        public float guidePercent = -1.0f;
        public int heightDefault = 0;
        public int heightMax = -1;
        public int heightMin = -1;
        public float heightPercent = 1.0f;
        public float horizontalBias = 0.5f;
        public int horizontalChainStyle = 0;
        public float horizontalWeight = -1.0f;
        public int leftMargin = -1;
        public int leftToLeft = -1;
        public int leftToRight = -1;
        public boolean mApply = false;
        public boolean mBarrierAllowsGoneWidgets = true;
        public int mBarrierDirection = -1;
        public int mBarrierMargin = 0;
        public String mConstraintTag;
        public int mHeight;
        public int mHelperType = -1;
        public boolean mIsGuideline = false;
        public String mReferenceIdString;
        public int[] mReferenceIds;
        public int mWidth;
        public int orientation = -1;
        public int rightMargin = -1;
        public int rightToLeft = -1;
        public int rightToRight = -1;
        public int startMargin = -1;
        public int startToEnd = -1;
        public int startToStart = -1;
        public int topMargin = -1;
        public int topToBottom = -1;
        public int topToTop = -1;
        public float verticalBias = 0.5f;
        public int verticalChainStyle = 0;
        public float verticalWeight = -1.0f;
        public int widthDefault = 0;
        public int widthMax = -1;
        public int widthMin = -1;
        public float widthPercent = 1.0f;

        public void copyFrom(Layout layout) {
            this.mIsGuideline = layout.mIsGuideline;
            this.mWidth = layout.mWidth;
            this.mApply = layout.mApply;
            this.mHeight = layout.mHeight;
            this.guideBegin = layout.guideBegin;
            this.guideEnd = layout.guideEnd;
            this.guidePercent = layout.guidePercent;
            this.leftToLeft = layout.leftToLeft;
            this.leftToRight = layout.leftToRight;
            this.rightToLeft = layout.rightToLeft;
            this.rightToRight = layout.rightToRight;
            this.topToTop = layout.topToTop;
            this.topToBottom = layout.topToBottom;
            this.bottomToTop = layout.bottomToTop;
            this.bottomToBottom = layout.bottomToBottom;
            this.baselineToBaseline = layout.baselineToBaseline;
            this.startToEnd = layout.startToEnd;
            this.startToStart = layout.startToStart;
            this.endToStart = layout.endToStart;
            this.endToEnd = layout.endToEnd;
            this.horizontalBias = layout.horizontalBias;
            this.verticalBias = layout.verticalBias;
            this.dimensionRatio = layout.dimensionRatio;
            this.circleConstraint = layout.circleConstraint;
            this.circleRadius = layout.circleRadius;
            this.circleAngle = layout.circleAngle;
            this.editorAbsoluteX = layout.editorAbsoluteX;
            this.editorAbsoluteY = layout.editorAbsoluteY;
            this.orientation = layout.orientation;
            this.leftMargin = layout.leftMargin;
            this.rightMargin = layout.rightMargin;
            this.topMargin = layout.topMargin;
            this.bottomMargin = layout.bottomMargin;
            this.endMargin = layout.endMargin;
            this.startMargin = layout.startMargin;
            this.goneLeftMargin = layout.goneLeftMargin;
            this.goneTopMargin = layout.goneTopMargin;
            this.goneRightMargin = layout.goneRightMargin;
            this.goneBottomMargin = layout.goneBottomMargin;
            this.goneEndMargin = layout.goneEndMargin;
            this.goneStartMargin = layout.goneStartMargin;
            this.verticalWeight = layout.verticalWeight;
            this.horizontalWeight = layout.horizontalWeight;
            this.horizontalChainStyle = layout.horizontalChainStyle;
            this.verticalChainStyle = layout.verticalChainStyle;
            this.widthDefault = layout.widthDefault;
            this.heightDefault = layout.heightDefault;
            this.widthMax = layout.widthMax;
            this.heightMax = layout.heightMax;
            this.widthMin = layout.widthMin;
            this.heightMin = layout.heightMin;
            this.widthPercent = layout.widthPercent;
            this.heightPercent = layout.heightPercent;
            this.mBarrierDirection = layout.mBarrierDirection;
            this.mBarrierMargin = layout.mBarrierMargin;
            this.mHelperType = layout.mHelperType;
            this.mConstraintTag = layout.mConstraintTag;
            int[] iArr = layout.mReferenceIds;
            if (iArr != null) {
                this.mReferenceIds = Arrays.copyOf(iArr, iArr.length);
            } else {
                this.mReferenceIds = null;
            }
            this.mReferenceIdString = layout.mReferenceIdString;
            this.constrainedWidth = layout.constrainedWidth;
            this.constrainedHeight = layout.constrainedHeight;
            this.mBarrierAllowsGoneWidgets = layout.mBarrierAllowsGoneWidgets;
        }

        static {
            SparseIntArray sparseIntArray = new SparseIntArray();
            mapToConstant = sparseIntArray;
            sparseIntArray.append(R.styleable.Layout_layout_constraintLeft_toLeftOf, 24);
            mapToConstant.append(R.styleable.Layout_layout_constraintLeft_toRightOf, 25);
            mapToConstant.append(R.styleable.Layout_layout_constraintRight_toLeftOf, 28);
            mapToConstant.append(R.styleable.Layout_layout_constraintRight_toRightOf, 29);
            mapToConstant.append(R.styleable.Layout_layout_constraintTop_toTopOf, 35);
            mapToConstant.append(R.styleable.Layout_layout_constraintTop_toBottomOf, 34);
            mapToConstant.append(R.styleable.Layout_layout_constraintBottom_toTopOf, 4);
            mapToConstant.append(R.styleable.Layout_layout_constraintBottom_toBottomOf, 3);
            mapToConstant.append(R.styleable.Layout_layout_constraintBaseline_toBaselineOf, 1);
            mapToConstant.append(R.styleable.Layout_layout_editor_absoluteX, 6);
            mapToConstant.append(R.styleable.Layout_layout_editor_absoluteY, 7);
            mapToConstant.append(R.styleable.Layout_layout_constraintGuide_begin, 17);
            mapToConstant.append(R.styleable.Layout_layout_constraintGuide_end, 18);
            mapToConstant.append(R.styleable.Layout_layout_constraintGuide_percent, 19);
            mapToConstant.append(R.styleable.Layout_android_orientation, 26);
            mapToConstant.append(R.styleable.Layout_layout_constraintStart_toEndOf, 31);
            mapToConstant.append(R.styleable.Layout_layout_constraintStart_toStartOf, 32);
            mapToConstant.append(R.styleable.Layout_layout_constraintEnd_toStartOf, 10);
            mapToConstant.append(R.styleable.Layout_layout_constraintEnd_toEndOf, 9);
            mapToConstant.append(R.styleable.Layout_layout_goneMarginLeft, 13);
            mapToConstant.append(R.styleable.Layout_layout_goneMarginTop, 16);
            mapToConstant.append(R.styleable.Layout_layout_goneMarginRight, 14);
            mapToConstant.append(R.styleable.Layout_layout_goneMarginBottom, 11);
            mapToConstant.append(R.styleable.Layout_layout_goneMarginStart, 15);
            mapToConstant.append(R.styleable.Layout_layout_goneMarginEnd, 12);
            mapToConstant.append(R.styleable.Layout_layout_constraintVertical_weight, 38);
            mapToConstant.append(R.styleable.Layout_layout_constraintHorizontal_weight, 37);
            mapToConstant.append(R.styleable.Layout_layout_constraintHorizontal_chainStyle, 39);
            mapToConstant.append(R.styleable.Layout_layout_constraintVertical_chainStyle, 40);
            mapToConstant.append(R.styleable.Layout_layout_constraintHorizontal_bias, 20);
            mapToConstant.append(R.styleable.Layout_layout_constraintVertical_bias, 36);
            mapToConstant.append(R.styleable.Layout_layout_constraintDimensionRatio, 5);
            mapToConstant.append(R.styleable.Layout_layout_constraintLeft_creator, 76);
            mapToConstant.append(R.styleable.Layout_layout_constraintTop_creator, 76);
            mapToConstant.append(R.styleable.Layout_layout_constraintRight_creator, 76);
            mapToConstant.append(R.styleable.Layout_layout_constraintBottom_creator, 76);
            mapToConstant.append(R.styleable.Layout_layout_constraintBaseline_creator, 76);
            mapToConstant.append(R.styleable.Layout_android_layout_marginLeft, 23);
            mapToConstant.append(R.styleable.Layout_android_layout_marginRight, 27);
            mapToConstant.append(R.styleable.Layout_android_layout_marginStart, 30);
            mapToConstant.append(R.styleable.Layout_android_layout_marginEnd, 8);
            mapToConstant.append(R.styleable.Layout_android_layout_marginTop, 33);
            mapToConstant.append(R.styleable.Layout_android_layout_marginBottom, 2);
            mapToConstant.append(R.styleable.Layout_android_layout_width, 22);
            mapToConstant.append(R.styleable.Layout_android_layout_height, 21);
            mapToConstant.append(R.styleable.Layout_layout_constraintCircle, 61);
            mapToConstant.append(R.styleable.Layout_layout_constraintCircleRadius, 62);
            mapToConstant.append(R.styleable.Layout_layout_constraintCircleAngle, 63);
            mapToConstant.append(R.styleable.Layout_layout_constraintWidth_percent, 69);
            mapToConstant.append(R.styleable.Layout_layout_constraintHeight_percent, 70);
            mapToConstant.append(R.styleable.Layout_chainUseRtl, 71);
            mapToConstant.append(R.styleable.Layout_barrierDirection, 72);
            mapToConstant.append(R.styleable.Layout_barrierMargin, 73);
            mapToConstant.append(R.styleable.Layout_constraint_referenced_ids, 74);
            mapToConstant.append(R.styleable.Layout_barrierAllowsGoneWidgets, 75);
        }

        /* access modifiers changed from: package-private */
        public void fillFromAttributeList(Context context, AttributeSet attributeSet) {
            TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.Layout);
            this.mApply = true;
            int indexCount = obtainStyledAttributes.getIndexCount();
            for (int i = 0; i < indexCount; i++) {
                int index = obtainStyledAttributes.getIndex(i);
                int i2 = mapToConstant.get(index);
                if (i2 == 80) {
                    this.constrainedWidth = obtainStyledAttributes.getBoolean(index, this.constrainedWidth);
                } else if (i2 != 81) {
                    switch (i2) {
                        case 1:
                            this.baselineToBaseline = ConstraintSet.lookupID(obtainStyledAttributes, index, this.baselineToBaseline);
                            break;
                        case 2:
                            this.bottomMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.bottomMargin);
                            break;
                        case 3:
                            this.bottomToBottom = ConstraintSet.lookupID(obtainStyledAttributes, index, this.bottomToBottom);
                            break;
                        case 4:
                            this.bottomToTop = ConstraintSet.lookupID(obtainStyledAttributes, index, this.bottomToTop);
                            break;
                        case 5:
                            this.dimensionRatio = obtainStyledAttributes.getString(index);
                            break;
                        case 6:
                            this.editorAbsoluteX = obtainStyledAttributes.getDimensionPixelOffset(index, this.editorAbsoluteX);
                            break;
                        case 7:
                            this.editorAbsoluteY = obtainStyledAttributes.getDimensionPixelOffset(index, this.editorAbsoluteY);
                            break;
                        case 8:
                            this.endMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.endMargin);
                            break;
                        case 9:
                            this.endToEnd = ConstraintSet.lookupID(obtainStyledAttributes, index, this.endToEnd);
                            break;
                        case 10:
                            this.endToStart = ConstraintSet.lookupID(obtainStyledAttributes, index, this.endToStart);
                            break;
                        case 11:
                            this.goneBottomMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.goneBottomMargin);
                            break;
                        case 12:
                            this.goneEndMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.goneEndMargin);
                            break;
                        case 13:
                            this.goneLeftMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.goneLeftMargin);
                            break;
                        case 14:
                            this.goneRightMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.goneRightMargin);
                            break;
                        case 15:
                            this.goneStartMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.goneStartMargin);
                            break;
                        case 16:
                            this.goneTopMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.goneTopMargin);
                            break;
                        case 17:
                            this.guideBegin = obtainStyledAttributes.getDimensionPixelOffset(index, this.guideBegin);
                            break;
                        case 18:
                            this.guideEnd = obtainStyledAttributes.getDimensionPixelOffset(index, this.guideEnd);
                            break;
                        case 19:
                            this.guidePercent = obtainStyledAttributes.getFloat(index, this.guidePercent);
                            break;
                        case 20:
                            this.horizontalBias = obtainStyledAttributes.getFloat(index, this.horizontalBias);
                            break;
                        case 21:
                            this.mHeight = obtainStyledAttributes.getLayoutDimension(index, this.mHeight);
                            break;
                        case 22:
                            this.mWidth = obtainStyledAttributes.getLayoutDimension(index, this.mWidth);
                            break;
                        case 23:
                            this.leftMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.leftMargin);
                            break;
                        case 24:
                            this.leftToLeft = ConstraintSet.lookupID(obtainStyledAttributes, index, this.leftToLeft);
                            break;
                        case 25:
                            this.leftToRight = ConstraintSet.lookupID(obtainStyledAttributes, index, this.leftToRight);
                            break;
                        case 26:
                            this.orientation = obtainStyledAttributes.getInt(index, this.orientation);
                            break;
                        case 27:
                            this.rightMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.rightMargin);
                            break;
                        case 28:
                            this.rightToLeft = ConstraintSet.lookupID(obtainStyledAttributes, index, this.rightToLeft);
                            break;
                        case 29:
                            this.rightToRight = ConstraintSet.lookupID(obtainStyledAttributes, index, this.rightToRight);
                            break;
                        case 30:
                            this.startMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.startMargin);
                            break;
                        case 31:
                            this.startToEnd = ConstraintSet.lookupID(obtainStyledAttributes, index, this.startToEnd);
                            break;
                        case 32:
                            this.startToStart = ConstraintSet.lookupID(obtainStyledAttributes, index, this.startToStart);
                            break;
                        case 33:
                            this.topMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.topMargin);
                            break;
                        case 34:
                            this.topToBottom = ConstraintSet.lookupID(obtainStyledAttributes, index, this.topToBottom);
                            break;
                        case 35:
                            this.topToTop = ConstraintSet.lookupID(obtainStyledAttributes, index, this.topToTop);
                            break;
                        case 36:
                            this.verticalBias = obtainStyledAttributes.getFloat(index, this.verticalBias);
                            break;
                        case 37:
                            this.horizontalWeight = obtainStyledAttributes.getFloat(index, this.horizontalWeight);
                            break;
                        case 38:
                            this.verticalWeight = obtainStyledAttributes.getFloat(index, this.verticalWeight);
                            break;
                        case 39:
                            this.horizontalChainStyle = obtainStyledAttributes.getInt(index, this.horizontalChainStyle);
                            break;
                        case 40:
                            this.verticalChainStyle = obtainStyledAttributes.getInt(index, this.verticalChainStyle);
                            break;
                        default:
                            switch (i2) {
                                case 54:
                                    this.widthDefault = obtainStyledAttributes.getInt(index, this.widthDefault);
                                    break;
                                case 55:
                                    this.heightDefault = obtainStyledAttributes.getInt(index, this.heightDefault);
                                    break;
                                case 56:
                                    this.widthMax = obtainStyledAttributes.getDimensionPixelSize(index, this.widthMax);
                                    break;
                                case 57:
                                    this.heightMax = obtainStyledAttributes.getDimensionPixelSize(index, this.heightMax);
                                    break;
                                case 58:
                                    this.widthMin = obtainStyledAttributes.getDimensionPixelSize(index, this.widthMin);
                                    break;
                                case 59:
                                    this.heightMin = obtainStyledAttributes.getDimensionPixelSize(index, this.heightMin);
                                    break;
                                default:
                                    switch (i2) {
                                        case 61:
                                            this.circleConstraint = ConstraintSet.lookupID(obtainStyledAttributes, index, this.circleConstraint);
                                            break;
                                        case 62:
                                            this.circleRadius = obtainStyledAttributes.getDimensionPixelSize(index, this.circleRadius);
                                            break;
                                        case 63:
                                            this.circleAngle = obtainStyledAttributes.getFloat(index, this.circleAngle);
                                            break;
                                        default:
                                            switch (i2) {
                                                case 69:
                                                    this.widthPercent = obtainStyledAttributes.getFloat(index, 1.0f);
                                                    break;
                                                case 70:
                                                    this.heightPercent = obtainStyledAttributes.getFloat(index, 1.0f);
                                                    break;
                                                case 71:
                                                    Log.e(ConstraintSet.TAG, "CURRENTLY UNSUPPORTED");
                                                    break;
                                                case 72:
                                                    this.mBarrierDirection = obtainStyledAttributes.getInt(index, this.mBarrierDirection);
                                                    break;
                                                case 73:
                                                    this.mBarrierMargin = obtainStyledAttributes.getDimensionPixelSize(index, this.mBarrierMargin);
                                                    break;
                                                case 74:
                                                    this.mReferenceIdString = obtainStyledAttributes.getString(index);
                                                    break;
                                                case 75:
                                                    this.mBarrierAllowsGoneWidgets = obtainStyledAttributes.getBoolean(index, this.mBarrierAllowsGoneWidgets);
                                                    break;
                                                case 76:
                                                    Log.w(ConstraintSet.TAG, "unused attribute 0x" + Integer.toHexString(index) + "   " + mapToConstant.get(index));
                                                    break;
                                                case 77:
                                                    this.mConstraintTag = obtainStyledAttributes.getString(index);
                                                    break;
                                                default:
                                                    Log.w(ConstraintSet.TAG, "Unknown attribute 0x" + Integer.toHexString(index) + "   " + mapToConstant.get(index));
                                                    break;
                                            }
                                    }
                            }
                    }
                } else {
                    this.constrainedHeight = obtainStyledAttributes.getBoolean(index, this.constrainedHeight);
                }
            }
            obtainStyledAttributes.recycle();
        }

        /* JADX WARNING: type inference failed for: r2v8, types: [java.lang.String] */
        /* JADX WARNING: Multi-variable type inference failed */
        /* JADX WARNING: Unknown variable types count: 1 */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void dump(androidx.constraintlayout.motion.widget.MotionScene r10, java.lang.StringBuilder r11) {
            /*
                r9 = this;
                java.lang.Class r0 = r9.getClass()
                java.lang.reflect.Field[] r0 = r0.getDeclaredFields()
                java.lang.String r1 = "\n"
                r11.append(r1)
                r1 = 0
            L_0x000e:
                int r2 = r0.length
                if (r1 >= r2) goto L_0x0080
                r2 = r0[r1]
                java.lang.String r3 = r2.getName()
                int r4 = r2.getModifiers()
                boolean r4 = java.lang.reflect.Modifier.isStatic(r4)
                if (r4 == 0) goto L_0x0022
                goto L_0x007d
            L_0x0022:
                java.lang.Object r4 = r2.get(r9)     // Catch:{ IllegalAccessException -> 0x0079 }
                java.lang.Class r2 = r2.getType()     // Catch:{ IllegalAccessException -> 0x0079 }
                java.lang.Class r5 = java.lang.Integer.TYPE     // Catch:{ IllegalAccessException -> 0x0079 }
                java.lang.String r6 = "\"\n"
                java.lang.String r7 = " = \""
                java.lang.String r8 = "    "
                if (r2 != r5) goto L_0x0059
                java.lang.Integer r4 = (java.lang.Integer) r4     // Catch:{ IllegalAccessException -> 0x0079 }
                int r2 = r4.intValue()     // Catch:{ IllegalAccessException -> 0x0079 }
                r5 = -1
                if (r2 == r5) goto L_0x007d
                int r2 = r4.intValue()     // Catch:{ IllegalAccessException -> 0x0079 }
                java.lang.String r2 = r10.lookUpConstraintName(r2)     // Catch:{ IllegalAccessException -> 0x0079 }
                r11.append(r8)     // Catch:{ IllegalAccessException -> 0x0079 }
                r11.append(r3)     // Catch:{ IllegalAccessException -> 0x0079 }
                r11.append(r7)     // Catch:{ IllegalAccessException -> 0x0079 }
                if (r2 != 0) goto L_0x0051
                goto L_0x0052
            L_0x0051:
                r4 = r2
            L_0x0052:
                r11.append(r4)     // Catch:{ IllegalAccessException -> 0x0079 }
                r11.append(r6)     // Catch:{ IllegalAccessException -> 0x0079 }
                goto L_0x007d
            L_0x0059:
                java.lang.Class r5 = java.lang.Float.TYPE     // Catch:{ IllegalAccessException -> 0x0079 }
                if (r2 != r5) goto L_0x007d
                java.lang.Float r4 = (java.lang.Float) r4     // Catch:{ IllegalAccessException -> 0x0079 }
                float r2 = r4.floatValue()     // Catch:{ IllegalAccessException -> 0x0079 }
                r5 = -1082130432(0xffffffffbf800000, float:-1.0)
                int r2 = (r2 > r5 ? 1 : (r2 == r5 ? 0 : -1))
                if (r2 == 0) goto L_0x007d
                r11.append(r8)     // Catch:{ IllegalAccessException -> 0x0079 }
                r11.append(r3)     // Catch:{ IllegalAccessException -> 0x0079 }
                r11.append(r7)     // Catch:{ IllegalAccessException -> 0x0079 }
                r11.append(r4)     // Catch:{ IllegalAccessException -> 0x0079 }
                r11.append(r6)     // Catch:{ IllegalAccessException -> 0x0079 }
                goto L_0x007d
            L_0x0079:
                r2 = move-exception
                r2.printStackTrace()
            L_0x007d:
                int r1 = r1 + 1
                goto L_0x000e
            L_0x0080:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.widget.ConstraintSet.Layout.dump(androidx.constraintlayout.motion.widget.MotionScene, java.lang.StringBuilder):void");
        }
    }

    public static class Transform {
        private static final int ELEVATION = 11;
        private static final int ROTATION = 1;
        private static final int ROTATION_X = 2;
        private static final int ROTATION_Y = 3;
        private static final int SCALE_X = 4;
        private static final int SCALE_Y = 5;
        private static final int TRANSFORM_PIVOT_X = 6;
        private static final int TRANSFORM_PIVOT_Y = 7;
        private static final int TRANSLATION_X = 8;
        private static final int TRANSLATION_Y = 9;
        private static final int TRANSLATION_Z = 10;
        private static SparseIntArray mapToConstant;
        public boolean applyElevation = false;
        public float elevation = 0.0f;
        public boolean mApply = false;
        public float rotation = 0.0f;
        public float rotationX = 0.0f;
        public float rotationY = 0.0f;
        public float scaleX = 1.0f;
        public float scaleY = 1.0f;
        public float transformPivotX = Float.NaN;
        public float transformPivotY = Float.NaN;
        public float translationX = 0.0f;
        public float translationY = 0.0f;
        public float translationZ = 0.0f;

        public void copyFrom(Transform transform) {
            this.mApply = transform.mApply;
            this.rotation = transform.rotation;
            this.rotationX = transform.rotationX;
            this.rotationY = transform.rotationY;
            this.scaleX = transform.scaleX;
            this.scaleY = transform.scaleY;
            this.transformPivotX = transform.transformPivotX;
            this.transformPivotY = transform.transformPivotY;
            this.translationX = transform.translationX;
            this.translationY = transform.translationY;
            this.translationZ = transform.translationZ;
            this.applyElevation = transform.applyElevation;
            this.elevation = transform.elevation;
        }

        static {
            SparseIntArray sparseIntArray = new SparseIntArray();
            mapToConstant = sparseIntArray;
            sparseIntArray.append(R.styleable.Transform_android_rotation, 1);
            mapToConstant.append(R.styleable.Transform_android_rotationX, 2);
            mapToConstant.append(R.styleable.Transform_android_rotationY, 3);
            mapToConstant.append(R.styleable.Transform_android_scaleX, 4);
            mapToConstant.append(R.styleable.Transform_android_scaleY, 5);
            mapToConstant.append(R.styleable.Transform_android_transformPivotX, 6);
            mapToConstant.append(R.styleable.Transform_android_transformPivotY, 7);
            mapToConstant.append(R.styleable.Transform_android_translationX, 8);
            mapToConstant.append(R.styleable.Transform_android_translationY, 9);
            mapToConstant.append(R.styleable.Transform_android_translationZ, 10);
            mapToConstant.append(R.styleable.Transform_android_elevation, 11);
        }

        /* access modifiers changed from: package-private */
        public void fillFromAttributeList(Context context, AttributeSet attributeSet) {
            TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.Transform);
            this.mApply = true;
            int indexCount = obtainStyledAttributes.getIndexCount();
            for (int i = 0; i < indexCount; i++) {
                int index = obtainStyledAttributes.getIndex(i);
                switch (mapToConstant.get(index)) {
                    case 1:
                        this.rotation = obtainStyledAttributes.getFloat(index, this.rotation);
                        break;
                    case 2:
                        this.rotationX = obtainStyledAttributes.getFloat(index, this.rotationX);
                        break;
                    case 3:
                        this.rotationY = obtainStyledAttributes.getFloat(index, this.rotationY);
                        break;
                    case 4:
                        this.scaleX = obtainStyledAttributes.getFloat(index, this.scaleX);
                        break;
                    case 5:
                        this.scaleY = obtainStyledAttributes.getFloat(index, this.scaleY);
                        break;
                    case 6:
                        this.transformPivotX = obtainStyledAttributes.getFloat(index, this.transformPivotX);
                        break;
                    case 7:
                        this.transformPivotY = obtainStyledAttributes.getFloat(index, this.transformPivotY);
                        break;
                    case 8:
                        this.translationX = obtainStyledAttributes.getDimension(index, this.translationX);
                        break;
                    case 9:
                        this.translationY = obtainStyledAttributes.getDimension(index, this.translationY);
                        break;
                    case 10:
                        this.translationZ = obtainStyledAttributes.getDimension(index, this.translationZ);
                        break;
                    case 11:
                        this.applyElevation = true;
                        this.elevation = obtainStyledAttributes.getDimension(index, this.elevation);
                        break;
                }
            }
            obtainStyledAttributes.recycle();
        }
    }

    public static class PropertySet {
        public float alpha = 1.0f;
        public boolean mApply = false;
        public float mProgress = Float.NaN;
        public int mVisibilityMode = 0;
        public int visibility = 0;

        public void copyFrom(PropertySet propertySet) {
            this.mApply = propertySet.mApply;
            this.visibility = propertySet.visibility;
            this.alpha = propertySet.alpha;
            this.mProgress = propertySet.mProgress;
            this.mVisibilityMode = propertySet.mVisibilityMode;
        }

        /* access modifiers changed from: package-private */
        public void fillFromAttributeList(Context context, AttributeSet attributeSet) {
            TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.PropertySet);
            this.mApply = true;
            int indexCount = obtainStyledAttributes.getIndexCount();
            for (int i = 0; i < indexCount; i++) {
                int index = obtainStyledAttributes.getIndex(i);
                if (index == R.styleable.PropertySet_android_alpha) {
                    this.alpha = obtainStyledAttributes.getFloat(index, this.alpha);
                } else if (index == R.styleable.PropertySet_android_visibility) {
                    this.visibility = obtainStyledAttributes.getInt(index, this.visibility);
                    this.visibility = ConstraintSet.VISIBILITY_FLAGS[this.visibility];
                } else if (index == R.styleable.PropertySet_visibilityMode) {
                    this.mVisibilityMode = obtainStyledAttributes.getInt(index, this.mVisibilityMode);
                } else if (index == R.styleable.PropertySet_motionProgress) {
                    this.mProgress = obtainStyledAttributes.getFloat(index, this.mProgress);
                }
            }
            obtainStyledAttributes.recycle();
        }
    }

    public static class Motion {
        private static final int ANIMATE_RELATIVE_TO = 5;
        private static final int MOTION_DRAW_PATH = 4;
        private static final int MOTION_STAGGER = 6;
        private static final int PATH_MOTION_ARC = 2;
        private static final int TRANSITION_EASING = 3;
        private static final int TRANSITION_PATH_ROTATE = 1;
        private static SparseIntArray mapToConstant;
        public int mAnimateRelativeTo = -1;
        public boolean mApply = false;
        public int mDrawPath = 0;
        public float mMotionStagger = Float.NaN;
        public int mPathMotionArc = -1;
        public float mPathRotate = Float.NaN;
        public String mTransitionEasing = null;

        public void copyFrom(Motion motion) {
            this.mApply = motion.mApply;
            this.mAnimateRelativeTo = motion.mAnimateRelativeTo;
            this.mTransitionEasing = motion.mTransitionEasing;
            this.mPathMotionArc = motion.mPathMotionArc;
            this.mDrawPath = motion.mDrawPath;
            this.mPathRotate = motion.mPathRotate;
            this.mMotionStagger = motion.mMotionStagger;
        }

        static {
            SparseIntArray sparseIntArray = new SparseIntArray();
            mapToConstant = sparseIntArray;
            sparseIntArray.append(R.styleable.Motion_motionPathRotate, 1);
            mapToConstant.append(R.styleable.Motion_pathMotionArc, 2);
            mapToConstant.append(R.styleable.Motion_transitionEasing, 3);
            mapToConstant.append(R.styleable.Motion_drawPath, 4);
            mapToConstant.append(R.styleable.Motion_animate_relativeTo, 5);
            mapToConstant.append(R.styleable.Motion_motionStagger, 6);
        }

        /* access modifiers changed from: package-private */
        public void fillFromAttributeList(Context context, AttributeSet attributeSet) {
            TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.Motion);
            this.mApply = true;
            int indexCount = obtainStyledAttributes.getIndexCount();
            for (int i = 0; i < indexCount; i++) {
                int index = obtainStyledAttributes.getIndex(i);
                switch (mapToConstant.get(index)) {
                    case 1:
                        this.mPathRotate = obtainStyledAttributes.getFloat(index, this.mPathRotate);
                        break;
                    case 2:
                        this.mPathMotionArc = obtainStyledAttributes.getInt(index, this.mPathMotionArc);
                        break;
                    case 3:
                        if (obtainStyledAttributes.peekValue(index).type != 3) {
                            this.mTransitionEasing = Easing.NAMED_EASING[obtainStyledAttributes.getInteger(index, 0)];
                            break;
                        } else {
                            this.mTransitionEasing = obtainStyledAttributes.getString(index);
                            break;
                        }
                    case 4:
                        this.mDrawPath = obtainStyledAttributes.getInt(index, 0);
                        break;
                    case 5:
                        this.mAnimateRelativeTo = ConstraintSet.lookupID(obtainStyledAttributes, index, this.mAnimateRelativeTo);
                        break;
                    case 6:
                        this.mMotionStagger = obtainStyledAttributes.getFloat(index, this.mMotionStagger);
                        break;
                }
            }
            obtainStyledAttributes.recycle();
        }
    }

    public static class Constraint {
        public final Layout layout = new Layout();
        public HashMap<String, ConstraintAttribute> mCustomConstraints = new HashMap<>();
        int mViewId;
        public final Motion motion = new Motion();
        public final PropertySet propertySet = new PropertySet();
        public final Transform transform = new Transform();

        private ConstraintAttribute get(String str, ConstraintAttribute.AttributeType attributeType) {
            if (this.mCustomConstraints.containsKey(str)) {
                ConstraintAttribute constraintAttribute = this.mCustomConstraints.get(str);
                if (constraintAttribute.getType() == attributeType) {
                    return constraintAttribute;
                }
                throw new IllegalArgumentException("ConstraintAttribute is already a " + constraintAttribute.getType().name());
            }
            ConstraintAttribute constraintAttribute2 = new ConstraintAttribute(str, attributeType);
            this.mCustomConstraints.put(str, constraintAttribute2);
            return constraintAttribute2;
        }

        /* access modifiers changed from: private */
        public void setStringValue(String str, String str2) {
            get(str, ConstraintAttribute.AttributeType.STRING_TYPE).setStringValue(str2);
        }

        /* access modifiers changed from: private */
        public void setFloatValue(String str, float f) {
            get(str, ConstraintAttribute.AttributeType.FLOAT_TYPE).setFloatValue(f);
        }

        /* access modifiers changed from: private */
        public void setIntValue(String str, int i) {
            get(str, ConstraintAttribute.AttributeType.INT_TYPE).setIntValue(i);
        }

        /* access modifiers changed from: private */
        public void setColorValue(String str, int i) {
            get(str, ConstraintAttribute.AttributeType.COLOR_TYPE).setColorValue(i);
        }

        public Constraint clone() {
            Constraint constraint = new Constraint();
            constraint.layout.copyFrom(this.layout);
            constraint.motion.copyFrom(this.motion);
            constraint.propertySet.copyFrom(this.propertySet);
            constraint.transform.copyFrom(this.transform);
            constraint.mViewId = this.mViewId;
            return constraint;
        }

        /* access modifiers changed from: private */
        public void fillFromConstraints(ConstraintHelper constraintHelper, int i, Constraints.LayoutParams layoutParams) {
            fillFromConstraints(i, layoutParams);
            if (constraintHelper instanceof Barrier) {
                Layout layout2 = this.layout;
                layout2.mHelperType = 1;
                Barrier barrier = (Barrier) constraintHelper;
                layout2.mBarrierDirection = barrier.getType();
                this.layout.mReferenceIds = barrier.getReferencedIds();
                this.layout.mBarrierMargin = barrier.getMargin();
            }
        }

        /* access modifiers changed from: private */
        public void fillFromConstraints(int i, Constraints.LayoutParams layoutParams) {
            fillFrom(i, layoutParams);
            this.propertySet.alpha = layoutParams.alpha;
            Transform transform2 = this.transform;
            transform2.rotation = layoutParams.rotation;
            transform2.rotationX = layoutParams.rotationX;
            transform2.rotationY = layoutParams.rotationY;
            transform2.scaleX = layoutParams.scaleX;
            transform2.scaleY = layoutParams.scaleY;
            transform2.transformPivotX = layoutParams.transformPivotX;
            transform2.transformPivotY = layoutParams.transformPivotY;
            transform2.translationX = layoutParams.translationX;
            transform2.translationY = layoutParams.translationY;
            transform2.translationZ = layoutParams.translationZ;
            transform2.elevation = layoutParams.elevation;
            transform2.applyElevation = layoutParams.applyElevation;
        }

        /* access modifiers changed from: private */
        public void fillFrom(int i, ConstraintLayout.LayoutParams layoutParams) {
            this.mViewId = i;
            Layout layout2 = this.layout;
            layout2.leftToLeft = layoutParams.leftToLeft;
            layout2.leftToRight = layoutParams.leftToRight;
            layout2.rightToLeft = layoutParams.rightToLeft;
            layout2.rightToRight = layoutParams.rightToRight;
            layout2.topToTop = layoutParams.topToTop;
            layout2.topToBottom = layoutParams.topToBottom;
            layout2.bottomToTop = layoutParams.bottomToTop;
            layout2.bottomToBottom = layoutParams.bottomToBottom;
            layout2.baselineToBaseline = layoutParams.baselineToBaseline;
            layout2.startToEnd = layoutParams.startToEnd;
            layout2.startToStart = layoutParams.startToStart;
            layout2.endToStart = layoutParams.endToStart;
            layout2.endToEnd = layoutParams.endToEnd;
            layout2.horizontalBias = layoutParams.horizontalBias;
            layout2.verticalBias = layoutParams.verticalBias;
            layout2.dimensionRatio = layoutParams.dimensionRatio;
            layout2.circleConstraint = layoutParams.circleConstraint;
            layout2.circleRadius = layoutParams.circleRadius;
            layout2.circleAngle = layoutParams.circleAngle;
            layout2.editorAbsoluteX = layoutParams.editorAbsoluteX;
            layout2.editorAbsoluteY = layoutParams.editorAbsoluteY;
            layout2.orientation = layoutParams.orientation;
            layout2.guidePercent = layoutParams.guidePercent;
            layout2.guideBegin = layoutParams.guideBegin;
            layout2.guideEnd = layoutParams.guideEnd;
            layout2.mWidth = layoutParams.width;
            layout2.mHeight = layoutParams.height;
            layout2.leftMargin = layoutParams.leftMargin;
            layout2.rightMargin = layoutParams.rightMargin;
            layout2.topMargin = layoutParams.topMargin;
            layout2.bottomMargin = layoutParams.bottomMargin;
            layout2.verticalWeight = layoutParams.verticalWeight;
            layout2.horizontalWeight = layoutParams.horizontalWeight;
            layout2.verticalChainStyle = layoutParams.verticalChainStyle;
            layout2.horizontalChainStyle = layoutParams.horizontalChainStyle;
            layout2.constrainedWidth = layoutParams.constrainedWidth;
            layout2.constrainedHeight = layoutParams.constrainedHeight;
            layout2.widthDefault = layoutParams.matchConstraintDefaultWidth;
            layout2.heightDefault = layoutParams.matchConstraintDefaultHeight;
            layout2.widthMax = layoutParams.matchConstraintMaxWidth;
            layout2.heightMax = layoutParams.matchConstraintMaxHeight;
            layout2.widthMin = layoutParams.matchConstraintMinWidth;
            layout2.heightMin = layoutParams.matchConstraintMinHeight;
            layout2.widthPercent = layoutParams.matchConstraintPercentWidth;
            layout2.heightPercent = layoutParams.matchConstraintPercentHeight;
            layout2.mConstraintTag = layoutParams.constraintTag;
            layout2.goneTopMargin = layoutParams.goneTopMargin;
            layout2.goneBottomMargin = layoutParams.goneBottomMargin;
            layout2.goneLeftMargin = layoutParams.goneLeftMargin;
            layout2.goneRightMargin = layoutParams.goneRightMargin;
            layout2.goneStartMargin = layoutParams.goneStartMargin;
            layout2.goneEndMargin = layoutParams.goneEndMargin;
            layout2.endMargin = layoutParams.getMarginEnd();
            this.layout.startMargin = layoutParams.getMarginStart();
        }

        public void applyTo(ConstraintLayout.LayoutParams layoutParams) {
            Layout layout2 = this.layout;
            layoutParams.leftToLeft = layout2.leftToLeft;
            layoutParams.leftToRight = layout2.leftToRight;
            layoutParams.rightToLeft = layout2.rightToLeft;
            layoutParams.rightToRight = layout2.rightToRight;
            layoutParams.topToTop = layout2.topToTop;
            layoutParams.topToBottom = layout2.topToBottom;
            layoutParams.bottomToTop = layout2.bottomToTop;
            layoutParams.bottomToBottom = layout2.bottomToBottom;
            layoutParams.baselineToBaseline = layout2.baselineToBaseline;
            layoutParams.startToEnd = layout2.startToEnd;
            layoutParams.startToStart = layout2.startToStart;
            layoutParams.endToStart = layout2.endToStart;
            layoutParams.endToEnd = layout2.endToEnd;
            layoutParams.leftMargin = layout2.leftMargin;
            layoutParams.rightMargin = layout2.rightMargin;
            layoutParams.topMargin = layout2.topMargin;
            layoutParams.bottomMargin = layout2.bottomMargin;
            layoutParams.goneStartMargin = layout2.goneStartMargin;
            layoutParams.goneEndMargin = layout2.goneEndMargin;
            layoutParams.goneTopMargin = layout2.goneTopMargin;
            layoutParams.goneBottomMargin = layout2.goneBottomMargin;
            layoutParams.horizontalBias = layout2.horizontalBias;
            layoutParams.verticalBias = layout2.verticalBias;
            layoutParams.circleConstraint = layout2.circleConstraint;
            layoutParams.circleRadius = layout2.circleRadius;
            layoutParams.circleAngle = layout2.circleAngle;
            layoutParams.dimensionRatio = layout2.dimensionRatio;
            layoutParams.editorAbsoluteX = layout2.editorAbsoluteX;
            layoutParams.editorAbsoluteY = layout2.editorAbsoluteY;
            layoutParams.verticalWeight = layout2.verticalWeight;
            layoutParams.horizontalWeight = layout2.horizontalWeight;
            layoutParams.verticalChainStyle = layout2.verticalChainStyle;
            layoutParams.horizontalChainStyle = layout2.horizontalChainStyle;
            layoutParams.constrainedWidth = layout2.constrainedWidth;
            layoutParams.constrainedHeight = layout2.constrainedHeight;
            layoutParams.matchConstraintDefaultWidth = layout2.widthDefault;
            layoutParams.matchConstraintDefaultHeight = layout2.heightDefault;
            layoutParams.matchConstraintMaxWidth = layout2.widthMax;
            layoutParams.matchConstraintMaxHeight = layout2.heightMax;
            layoutParams.matchConstraintMinWidth = layout2.widthMin;
            layoutParams.matchConstraintMinHeight = layout2.heightMin;
            layoutParams.matchConstraintPercentWidth = layout2.widthPercent;
            layoutParams.matchConstraintPercentHeight = layout2.heightPercent;
            layoutParams.orientation = layout2.orientation;
            layoutParams.guidePercent = layout2.guidePercent;
            layoutParams.guideBegin = layout2.guideBegin;
            layoutParams.guideEnd = layout2.guideEnd;
            layoutParams.width = layout2.mWidth;
            layoutParams.height = layout2.mHeight;
            String str = layout2.mConstraintTag;
            if (str != null) {
                layoutParams.constraintTag = str;
            }
            layoutParams.setMarginStart(layout2.startMargin);
            layoutParams.setMarginEnd(this.layout.endMargin);
            layoutParams.validate();
        }
    }

    public void clone(Context context, int i) {
        clone((ConstraintLayout) LayoutInflater.from(context).inflate(i, (ViewGroup) null));
    }

    public void clone(ConstraintSet constraintSet) {
        this.mConstraints.clear();
        for (Integer next : constraintSet.mConstraints.keySet()) {
            this.mConstraints.put(next, constraintSet.mConstraints.get(next).clone());
        }
    }

    public void clone(ConstraintLayout constraintLayout) {
        int childCount = constraintLayout.getChildCount();
        this.mConstraints.clear();
        int i = 0;
        while (i < childCount) {
            View childAt = constraintLayout.getChildAt(i);
            ConstraintLayout.LayoutParams layoutParams = (ConstraintLayout.LayoutParams) childAt.getLayoutParams();
            int id = childAt.getId();
            if (!this.mForceId || id != -1) {
                if (!this.mConstraints.containsKey(Integer.valueOf(id))) {
                    this.mConstraints.put(Integer.valueOf(id), new Constraint());
                }
                Constraint constraint = this.mConstraints.get(Integer.valueOf(id));
                constraint.mCustomConstraints = ConstraintAttribute.extractAttributes(this.mSavedAttributes, childAt);
                constraint.fillFrom(id, layoutParams);
                constraint.propertySet.visibility = childAt.getVisibility();
                constraint.propertySet.alpha = childAt.getAlpha();
                constraint.transform.rotation = childAt.getRotation();
                constraint.transform.rotationX = childAt.getRotationX();
                constraint.transform.rotationY = childAt.getRotationY();
                constraint.transform.scaleX = childAt.getScaleX();
                constraint.transform.scaleY = childAt.getScaleY();
                float pivotX = childAt.getPivotX();
                float pivotY = childAt.getPivotY();
                if (!(((double) pivotX) == 0.0d && ((double) pivotY) == 0.0d)) {
                    Transform transform = constraint.transform;
                    transform.transformPivotX = pivotX;
                    transform.transformPivotY = pivotY;
                }
                constraint.transform.translationX = childAt.getTranslationX();
                constraint.transform.translationY = childAt.getTranslationY();
                constraint.transform.translationZ = childAt.getTranslationZ();
                Transform transform2 = constraint.transform;
                if (transform2.applyElevation) {
                    transform2.elevation = childAt.getElevation();
                }
                if (childAt instanceof Barrier) {
                    Barrier barrier = (Barrier) childAt;
                    constraint.layout.mBarrierAllowsGoneWidgets = barrier.allowsGoneWidget();
                    constraint.layout.mReferenceIds = barrier.getReferencedIds();
                    constraint.layout.mBarrierDirection = barrier.getType();
                    constraint.layout.mBarrierMargin = barrier.getMargin();
                }
                i++;
            } else {
                throw new RuntimeException("All children of ConstraintLayout must have ids to use ConstraintSet");
            }
        }
    }

    public void clone(Constraints constraints) {
        int childCount = constraints.getChildCount();
        this.mConstraints.clear();
        int i = 0;
        while (i < childCount) {
            View childAt = constraints.getChildAt(i);
            Constraints.LayoutParams layoutParams = (Constraints.LayoutParams) childAt.getLayoutParams();
            int id = childAt.getId();
            if (!this.mForceId || id != -1) {
                if (!this.mConstraints.containsKey(Integer.valueOf(id))) {
                    this.mConstraints.put(Integer.valueOf(id), new Constraint());
                }
                Constraint constraint = this.mConstraints.get(Integer.valueOf(id));
                if (childAt instanceof ConstraintHelper) {
                    constraint.fillFromConstraints((ConstraintHelper) childAt, id, layoutParams);
                }
                constraint.fillFromConstraints(id, layoutParams);
                i++;
            } else {
                throw new RuntimeException("All children of ConstraintLayout must have ids to use ConstraintSet");
            }
        }
    }

    public void applyTo(ConstraintLayout constraintLayout) {
        applyToInternal(constraintLayout, true);
        constraintLayout.setConstraintSet((ConstraintSet) null);
        constraintLayout.requestLayout();
    }

    public void applyToWithoutCustom(ConstraintLayout constraintLayout) {
        applyToInternal(constraintLayout, false);
        constraintLayout.setConstraintSet((ConstraintSet) null);
    }

    public void applyCustomAttributes(ConstraintLayout constraintLayout) {
        int childCount = constraintLayout.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View childAt = constraintLayout.getChildAt(i);
            int id = childAt.getId();
            if (!this.mConstraints.containsKey(Integer.valueOf(id))) {
                Log.v(TAG, "id unknown " + Debug.getName(childAt));
            } else if (this.mForceId && id == -1) {
                throw new RuntimeException("All children of ConstraintLayout must have ids to use ConstraintSet");
            } else if (this.mConstraints.containsKey(Integer.valueOf(id))) {
                ConstraintAttribute.setAttributes(childAt, this.mConstraints.get(Integer.valueOf(id)).mCustomConstraints);
            }
        }
    }

    public void applyToHelper(ConstraintHelper constraintHelper, ConstraintWidget constraintWidget, ConstraintLayout.LayoutParams layoutParams, SparseArray<ConstraintWidget> sparseArray) {
        int id = constraintHelper.getId();
        if (this.mConstraints.containsKey(Integer.valueOf(id))) {
            Constraint constraint = this.mConstraints.get(Integer.valueOf(id));
            if (constraintWidget instanceof HelperWidget) {
                constraintHelper.loadParameters(constraint, (HelperWidget) constraintWidget, layoutParams, sparseArray);
            }
        }
    }

    public void applyToLayoutParams(int i, ConstraintLayout.LayoutParams layoutParams) {
        if (this.mConstraints.containsKey(Integer.valueOf(i))) {
            this.mConstraints.get(Integer.valueOf(i)).applyTo(layoutParams);
        }
    }

    /* access modifiers changed from: package-private */
    public void applyToInternal(ConstraintLayout constraintLayout, boolean z) {
        int childCount = constraintLayout.getChildCount();
        HashSet hashSet = new HashSet(this.mConstraints.keySet());
        for (int i = 0; i < childCount; i++) {
            View childAt = constraintLayout.getChildAt(i);
            int id = childAt.getId();
            if (!this.mConstraints.containsKey(Integer.valueOf(id))) {
                Log.w(TAG, "id unknown " + Debug.getName(childAt));
            } else if (this.mForceId && id == -1) {
                throw new RuntimeException("All children of ConstraintLayout must have ids to use ConstraintSet");
            } else if (id != -1) {
                if (this.mConstraints.containsKey(Integer.valueOf(id))) {
                    hashSet.remove(Integer.valueOf(id));
                    Constraint constraint = this.mConstraints.get(Integer.valueOf(id));
                    if (childAt instanceof Barrier) {
                        constraint.layout.mHelperType = 1;
                    }
                    int i2 = constraint.layout.mHelperType;
                    if (i2 != -1 && i2 == 1) {
                        Barrier barrier = (Barrier) childAt;
                        barrier.setId(id);
                        barrier.setType(constraint.layout.mBarrierDirection);
                        barrier.setMargin(constraint.layout.mBarrierMargin);
                        barrier.setAllowsGoneWidget(constraint.layout.mBarrierAllowsGoneWidgets);
                        Layout layout = constraint.layout;
                        int[] iArr = layout.mReferenceIds;
                        if (iArr != null) {
                            barrier.setReferencedIds(iArr);
                        } else {
                            String str = layout.mReferenceIdString;
                            if (str != null) {
                                layout.mReferenceIds = convertReferenceString(barrier, str);
                                barrier.setReferencedIds(constraint.layout.mReferenceIds);
                            }
                        }
                    }
                    ConstraintLayout.LayoutParams layoutParams = (ConstraintLayout.LayoutParams) childAt.getLayoutParams();
                    layoutParams.validate();
                    constraint.applyTo(layoutParams);
                    if (z) {
                        ConstraintAttribute.setAttributes(childAt, constraint.mCustomConstraints);
                    }
                    childAt.setLayoutParams(layoutParams);
                    PropertySet propertySet = constraint.propertySet;
                    if (propertySet.mVisibilityMode == 0) {
                        childAt.setVisibility(propertySet.visibility);
                    }
                    childAt.setAlpha(constraint.propertySet.alpha);
                    childAt.setRotation(constraint.transform.rotation);
                    childAt.setRotationX(constraint.transform.rotationX);
                    childAt.setRotationY(constraint.transform.rotationY);
                    childAt.setScaleX(constraint.transform.scaleX);
                    childAt.setScaleY(constraint.transform.scaleY);
                    if (!Float.isNaN(constraint.transform.transformPivotX)) {
                        childAt.setPivotX(constraint.transform.transformPivotX);
                    }
                    if (!Float.isNaN(constraint.transform.transformPivotY)) {
                        childAt.setPivotY(constraint.transform.transformPivotY);
                    }
                    childAt.setTranslationX(constraint.transform.translationX);
                    childAt.setTranslationY(constraint.transform.translationY);
                    childAt.setTranslationZ(constraint.transform.translationZ);
                    Transform transform = constraint.transform;
                    if (transform.applyElevation) {
                        childAt.setElevation(transform.elevation);
                    }
                } else {
                    Log.v(TAG, "WARNING NO CONSTRAINTS for view " + id);
                }
            }
        }
        Iterator it = hashSet.iterator();
        while (it.hasNext()) {
            Integer num = (Integer) it.next();
            Constraint constraint2 = this.mConstraints.get(num);
            int i3 = constraint2.layout.mHelperType;
            if (i3 != -1 && i3 == 1) {
                Barrier barrier2 = new Barrier(constraintLayout.getContext());
                barrier2.setId(num.intValue());
                Layout layout2 = constraint2.layout;
                int[] iArr2 = layout2.mReferenceIds;
                if (iArr2 != null) {
                    barrier2.setReferencedIds(iArr2);
                } else {
                    String str2 = layout2.mReferenceIdString;
                    if (str2 != null) {
                        layout2.mReferenceIds = convertReferenceString(barrier2, str2);
                        barrier2.setReferencedIds(constraint2.layout.mReferenceIds);
                    }
                }
                barrier2.setType(constraint2.layout.mBarrierDirection);
                barrier2.setMargin(constraint2.layout.mBarrierMargin);
                ConstraintLayout.LayoutParams generateDefaultLayoutParams = constraintLayout.generateDefaultLayoutParams();
                barrier2.validateParams();
                constraint2.applyTo(generateDefaultLayoutParams);
                constraintLayout.addView(barrier2, generateDefaultLayoutParams);
            }
            if (constraint2.layout.mIsGuideline) {
                Guideline guideline = new Guideline(constraintLayout.getContext());
                guideline.setId(num.intValue());
                ConstraintLayout.LayoutParams generateDefaultLayoutParams2 = constraintLayout.generateDefaultLayoutParams();
                constraint2.applyTo(generateDefaultLayoutParams2);
                constraintLayout.addView(guideline, generateDefaultLayoutParams2);
            }
        }
    }

    public void center(int i, int i2, int i3, int i4, int i5, int i6, int i7, float f) {
        int i8 = i3;
        float f2 = f;
        if (i4 < 0) {
            throw new IllegalArgumentException("margin must be > 0");
        } else if (i7 < 0) {
            throw new IllegalArgumentException("margin must be > 0");
        } else if (f2 <= 0.0f || f2 > 1.0f) {
            throw new IllegalArgumentException("bias must be between 0 and 1 inclusive");
        } else if (i8 == 1 || i8 == 2) {
            int i9 = i;
            connect(i9, 1, i2, i3, i4);
            connect(i9, 2, i5, i6, i7);
            this.mConstraints.get(Integer.valueOf(i)).layout.horizontalBias = f2;
        } else if (i8 == 6 || i8 == 7) {
            int i10 = i;
            connect(i10, 6, i2, i3, i4);
            connect(i10, 7, i5, i6, i7);
            this.mConstraints.get(Integer.valueOf(i)).layout.horizontalBias = f2;
        } else {
            int i11 = i;
            connect(i11, 3, i2, i3, i4);
            connect(i11, 4, i5, i6, i7);
            this.mConstraints.get(Integer.valueOf(i)).layout.verticalBias = f2;
        }
    }

    public void centerHorizontally(int i, int i2, int i3, int i4, int i5, int i6, int i7, float f) {
        connect(i, 1, i2, i3, i4);
        connect(i, 2, i5, i6, i7);
        this.mConstraints.get(Integer.valueOf(i)).layout.horizontalBias = f;
    }

    public void centerHorizontallyRtl(int i, int i2, int i3, int i4, int i5, int i6, int i7, float f) {
        connect(i, 6, i2, i3, i4);
        connect(i, 7, i5, i6, i7);
        this.mConstraints.get(Integer.valueOf(i)).layout.horizontalBias = f;
    }

    public void centerVertically(int i, int i2, int i3, int i4, int i5, int i6, int i7, float f) {
        connect(i, 3, i2, i3, i4);
        connect(i, 4, i5, i6, i7);
        this.mConstraints.get(Integer.valueOf(i)).layout.verticalBias = f;
    }

    public void createVerticalChain(int i, int i2, int i3, int i4, int[] iArr, float[] fArr, int i5) {
        int[] iArr2 = iArr;
        float[] fArr2 = fArr;
        if (iArr2.length < 2) {
            throw new IllegalArgumentException("must have 2 or more widgets in a chain");
        } else if (fArr2 == null || fArr2.length == iArr2.length) {
            if (fArr2 != null) {
                get(iArr2[0]).layout.verticalWeight = fArr2[0];
            }
            get(iArr2[0]).layout.verticalChainStyle = i5;
            connect(iArr2[0], 3, i, i2, 0);
            for (int i6 = 1; i6 < iArr2.length; i6++) {
                int i7 = i6 - 1;
                connect(iArr2[i6], 3, iArr2[i7], 4, 0);
                connect(iArr2[i7], 4, iArr2[i6], 3, 0);
                if (fArr2 != null) {
                    get(iArr2[i6]).layout.verticalWeight = fArr2[i6];
                }
            }
            connect(iArr2[iArr2.length - 1], 4, i3, i4, 0);
        } else {
            throw new IllegalArgumentException("must have 2 or more widgets in a chain");
        }
    }

    public void createHorizontalChain(int i, int i2, int i3, int i4, int[] iArr, float[] fArr, int i5) {
        createHorizontalChain(i, i2, i3, i4, iArr, fArr, i5, 1, 2);
    }

    public void createHorizontalChainRtl(int i, int i2, int i3, int i4, int[] iArr, float[] fArr, int i5) {
        createHorizontalChain(i, i2, i3, i4, iArr, fArr, i5, 6, 7);
    }

    private void createHorizontalChain(int i, int i2, int i3, int i4, int[] iArr, float[] fArr, int i5, int i6, int i7) {
        int[] iArr2 = iArr;
        float[] fArr2 = fArr;
        if (iArr2.length < 2) {
            throw new IllegalArgumentException("must have 2 or more widgets in a chain");
        } else if (fArr2 == null || fArr2.length == iArr2.length) {
            if (fArr2 != null) {
                get(iArr2[0]).layout.horizontalWeight = fArr2[0];
            }
            get(iArr2[0]).layout.horizontalChainStyle = i5;
            connect(iArr2[0], i6, i, i2, -1);
            for (int i8 = 1; i8 < iArr2.length; i8++) {
                int i9 = i8 - 1;
                connect(iArr2[i8], i6, iArr2[i9], i7, -1);
                connect(iArr2[i9], i7, iArr2[i8], i6, -1);
                if (fArr2 != null) {
                    get(iArr2[i8]).layout.horizontalWeight = fArr2[i8];
                }
            }
            connect(iArr2[iArr2.length - 1], i7, i3, i4, -1);
        } else {
            throw new IllegalArgumentException("must have 2 or more widgets in a chain");
        }
    }

    public void connect(int i, int i2, int i3, int i4, int i5) {
        if (!this.mConstraints.containsKey(Integer.valueOf(i))) {
            this.mConstraints.put(Integer.valueOf(i), new Constraint());
        }
        Constraint constraint = this.mConstraints.get(Integer.valueOf(i));
        switch (i2) {
            case 1:
                if (i4 == 1) {
                    Layout layout = constraint.layout;
                    layout.leftToLeft = i3;
                    layout.leftToRight = -1;
                } else if (i4 == 2) {
                    Layout layout2 = constraint.layout;
                    layout2.leftToRight = i3;
                    layout2.leftToLeft = -1;
                } else {
                    throw new IllegalArgumentException("Left to " + sideToString(i4) + " undefined");
                }
                constraint.layout.leftMargin = i5;
                return;
            case 2:
                if (i4 == 1) {
                    Layout layout3 = constraint.layout;
                    layout3.rightToLeft = i3;
                    layout3.rightToRight = -1;
                } else if (i4 == 2) {
                    Layout layout4 = constraint.layout;
                    layout4.rightToRight = i3;
                    layout4.rightToLeft = -1;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
                constraint.layout.rightMargin = i5;
                return;
            case 3:
                if (i4 == 3) {
                    Layout layout5 = constraint.layout;
                    layout5.topToTop = i3;
                    layout5.topToBottom = -1;
                    layout5.baselineToBaseline = -1;
                } else if (i4 == 4) {
                    Layout layout6 = constraint.layout;
                    layout6.topToBottom = i3;
                    layout6.topToTop = -1;
                    layout6.baselineToBaseline = -1;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
                constraint.layout.topMargin = i5;
                return;
            case 4:
                if (i4 == 4) {
                    Layout layout7 = constraint.layout;
                    layout7.bottomToBottom = i3;
                    layout7.bottomToTop = -1;
                    layout7.baselineToBaseline = -1;
                } else if (i4 == 3) {
                    Layout layout8 = constraint.layout;
                    layout8.bottomToTop = i3;
                    layout8.bottomToBottom = -1;
                    layout8.baselineToBaseline = -1;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
                constraint.layout.bottomMargin = i5;
                return;
            case 5:
                if (i4 == 5) {
                    Layout layout9 = constraint.layout;
                    layout9.baselineToBaseline = i3;
                    layout9.bottomToBottom = -1;
                    layout9.bottomToTop = -1;
                    layout9.topToTop = -1;
                    layout9.topToBottom = -1;
                    return;
                }
                throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
            case 6:
                if (i4 == 6) {
                    Layout layout10 = constraint.layout;
                    layout10.startToStart = i3;
                    layout10.startToEnd = -1;
                } else if (i4 == 7) {
                    Layout layout11 = constraint.layout;
                    layout11.startToEnd = i3;
                    layout11.startToStart = -1;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
                constraint.layout.startMargin = i5;
                return;
            case 7:
                if (i4 == 7) {
                    Layout layout12 = constraint.layout;
                    layout12.endToEnd = i3;
                    layout12.endToStart = -1;
                } else if (i4 == 6) {
                    Layout layout13 = constraint.layout;
                    layout13.endToStart = i3;
                    layout13.endToEnd = -1;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
                constraint.layout.endMargin = i5;
                return;
            default:
                throw new IllegalArgumentException(sideToString(i2) + " to " + sideToString(i4) + " unknown");
        }
    }

    public void connect(int i, int i2, int i3, int i4) {
        if (!this.mConstraints.containsKey(Integer.valueOf(i))) {
            this.mConstraints.put(Integer.valueOf(i), new Constraint());
        }
        Constraint constraint = this.mConstraints.get(Integer.valueOf(i));
        switch (i2) {
            case 1:
                if (i4 == 1) {
                    Layout layout = constraint.layout;
                    layout.leftToLeft = i3;
                    layout.leftToRight = -1;
                    return;
                } else if (i4 == 2) {
                    Layout layout2 = constraint.layout;
                    layout2.leftToRight = i3;
                    layout2.leftToLeft = -1;
                    return;
                } else {
                    throw new IllegalArgumentException("left to " + sideToString(i4) + " undefined");
                }
            case 2:
                if (i4 == 1) {
                    Layout layout3 = constraint.layout;
                    layout3.rightToLeft = i3;
                    layout3.rightToRight = -1;
                    return;
                } else if (i4 == 2) {
                    Layout layout4 = constraint.layout;
                    layout4.rightToRight = i3;
                    layout4.rightToLeft = -1;
                    return;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
            case 3:
                if (i4 == 3) {
                    Layout layout5 = constraint.layout;
                    layout5.topToTop = i3;
                    layout5.topToBottom = -1;
                    layout5.baselineToBaseline = -1;
                    return;
                } else if (i4 == 4) {
                    Layout layout6 = constraint.layout;
                    layout6.topToBottom = i3;
                    layout6.topToTop = -1;
                    layout6.baselineToBaseline = -1;
                    return;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
            case 4:
                if (i4 == 4) {
                    Layout layout7 = constraint.layout;
                    layout7.bottomToBottom = i3;
                    layout7.bottomToTop = -1;
                    layout7.baselineToBaseline = -1;
                    return;
                } else if (i4 == 3) {
                    Layout layout8 = constraint.layout;
                    layout8.bottomToTop = i3;
                    layout8.bottomToBottom = -1;
                    layout8.baselineToBaseline = -1;
                    return;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
            case 5:
                if (i4 == 5) {
                    Layout layout9 = constraint.layout;
                    layout9.baselineToBaseline = i3;
                    layout9.bottomToBottom = -1;
                    layout9.bottomToTop = -1;
                    layout9.topToTop = -1;
                    layout9.topToBottom = -1;
                    return;
                }
                throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
            case 6:
                if (i4 == 6) {
                    Layout layout10 = constraint.layout;
                    layout10.startToStart = i3;
                    layout10.startToEnd = -1;
                    return;
                } else if (i4 == 7) {
                    Layout layout11 = constraint.layout;
                    layout11.startToEnd = i3;
                    layout11.startToStart = -1;
                    return;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
            case 7:
                if (i4 == 7) {
                    Layout layout12 = constraint.layout;
                    layout12.endToEnd = i3;
                    layout12.endToStart = -1;
                    return;
                } else if (i4 == 6) {
                    Layout layout13 = constraint.layout;
                    layout13.endToStart = i3;
                    layout13.endToEnd = -1;
                    return;
                } else {
                    throw new IllegalArgumentException("right to " + sideToString(i4) + " undefined");
                }
            default:
                throw new IllegalArgumentException(sideToString(i2) + " to " + sideToString(i4) + " unknown");
        }
    }

    public void centerHorizontally(int i, int i2) {
        if (i2 == 0) {
            center(i, 0, 1, 0, 0, 2, 0, 0.5f);
        } else {
            center(i, i2, 2, 0, i2, 1, 0, 0.5f);
        }
    }

    public void centerHorizontallyRtl(int i, int i2) {
        if (i2 == 0) {
            center(i, 0, 6, 0, 0, 7, 0, 0.5f);
        } else {
            center(i, i2, 7, 0, i2, 6, 0, 0.5f);
        }
    }

    public void centerVertically(int i, int i2) {
        if (i2 == 0) {
            center(i, 0, 3, 0, 0, 4, 0, 0.5f);
        } else {
            center(i, i2, 4, 0, i2, 3, 0, 0.5f);
        }
    }

    public void clear(int i) {
        this.mConstraints.remove(Integer.valueOf(i));
    }

    public void clear(int i, int i2) {
        if (this.mConstraints.containsKey(Integer.valueOf(i))) {
            Constraint constraint = this.mConstraints.get(Integer.valueOf(i));
            switch (i2) {
                case 1:
                    Layout layout = constraint.layout;
                    layout.leftToRight = -1;
                    layout.leftToLeft = -1;
                    layout.leftMargin = -1;
                    layout.goneLeftMargin = -1;
                    return;
                case 2:
                    Layout layout2 = constraint.layout;
                    layout2.rightToRight = -1;
                    layout2.rightToLeft = -1;
                    layout2.rightMargin = -1;
                    layout2.goneRightMargin = -1;
                    return;
                case 3:
                    Layout layout3 = constraint.layout;
                    layout3.topToBottom = -1;
                    layout3.topToTop = -1;
                    layout3.topMargin = -1;
                    layout3.goneTopMargin = -1;
                    return;
                case 4:
                    Layout layout4 = constraint.layout;
                    layout4.bottomToTop = -1;
                    layout4.bottomToBottom = -1;
                    layout4.bottomMargin = -1;
                    layout4.goneBottomMargin = -1;
                    return;
                case 5:
                    constraint.layout.baselineToBaseline = -1;
                    return;
                case 6:
                    Layout layout5 = constraint.layout;
                    layout5.startToEnd = -1;
                    layout5.startToStart = -1;
                    layout5.startMargin = -1;
                    layout5.goneStartMargin = -1;
                    return;
                case 7:
                    Layout layout6 = constraint.layout;
                    layout6.endToStart = -1;
                    layout6.endToEnd = -1;
                    layout6.endMargin = -1;
                    layout6.goneEndMargin = -1;
                    return;
                default:
                    throw new IllegalArgumentException("unknown constraint");
            }
        }
    }

    public void setMargin(int i, int i2, int i3) {
        Constraint constraint = get(i);
        switch (i2) {
            case 1:
                constraint.layout.leftMargin = i3;
                return;
            case 2:
                constraint.layout.rightMargin = i3;
                return;
            case 3:
                constraint.layout.topMargin = i3;
                return;
            case 4:
                constraint.layout.bottomMargin = i3;
                return;
            case 5:
                throw new IllegalArgumentException("baseline does not support margins");
            case 6:
                constraint.layout.startMargin = i3;
                return;
            case 7:
                constraint.layout.endMargin = i3;
                return;
            default:
                throw new IllegalArgumentException("unknown constraint");
        }
    }

    public void setGoneMargin(int i, int i2, int i3) {
        Constraint constraint = get(i);
        switch (i2) {
            case 1:
                constraint.layout.goneLeftMargin = i3;
                return;
            case 2:
                constraint.layout.goneRightMargin = i3;
                return;
            case 3:
                constraint.layout.goneTopMargin = i3;
                return;
            case 4:
                constraint.layout.goneBottomMargin = i3;
                return;
            case 5:
                throw new IllegalArgumentException("baseline does not support margins");
            case 6:
                constraint.layout.goneStartMargin = i3;
                return;
            case 7:
                constraint.layout.goneEndMargin = i3;
                return;
            default:
                throw new IllegalArgumentException("unknown constraint");
        }
    }

    public void setHorizontalBias(int i, float f) {
        get(i).layout.horizontalBias = f;
    }

    public void setVerticalBias(int i, float f) {
        get(i).layout.verticalBias = f;
    }

    public void setDimensionRatio(int i, String str) {
        get(i).layout.dimensionRatio = str;
    }

    public void setVisibility(int i, int i2) {
        get(i).propertySet.visibility = i2;
    }

    public void setVisibilityMode(int i, int i2) {
        get(i).propertySet.mVisibilityMode = i2;
    }

    public int getVisibilityMode(int i) {
        return get(i).propertySet.mVisibilityMode;
    }

    public int getVisibility(int i) {
        return get(i).propertySet.visibility;
    }

    public int getHeight(int i) {
        return get(i).layout.mHeight;
    }

    public int getWidth(int i) {
        return get(i).layout.mWidth;
    }

    public void setAlpha(int i, float f) {
        get(i).propertySet.alpha = f;
    }

    public boolean getApplyElevation(int i) {
        return get(i).transform.applyElevation;
    }

    public void setApplyElevation(int i, boolean z) {
        get(i).transform.applyElevation = z;
    }

    public void setElevation(int i, float f) {
        get(i).transform.elevation = f;
        get(i).transform.applyElevation = true;
    }

    public void setRotation(int i, float f) {
        get(i).transform.rotation = f;
    }

    public void setRotationX(int i, float f) {
        get(i).transform.rotationX = f;
    }

    public void setRotationY(int i, float f) {
        get(i).transform.rotationY = f;
    }

    public void setScaleX(int i, float f) {
        get(i).transform.scaleX = f;
    }

    public void setScaleY(int i, float f) {
        get(i).transform.scaleY = f;
    }

    public void setTransformPivotX(int i, float f) {
        get(i).transform.transformPivotX = f;
    }

    public void setTransformPivotY(int i, float f) {
        get(i).transform.transformPivotY = f;
    }

    public void setTransformPivot(int i, float f, float f2) {
        Transform transform = get(i).transform;
        transform.transformPivotY = f2;
        transform.transformPivotX = f;
    }

    public void setTranslationX(int i, float f) {
        get(i).transform.translationX = f;
    }

    public void setTranslationY(int i, float f) {
        get(i).transform.translationY = f;
    }

    public void setTranslation(int i, float f, float f2) {
        Transform transform = get(i).transform;
        transform.translationX = f;
        transform.translationY = f2;
    }

    public void setTranslationZ(int i, float f) {
        get(i).transform.translationZ = f;
    }

    public void setEditorAbsoluteX(int i, int i2) {
        get(i).layout.editorAbsoluteX = i2;
    }

    public void setEditorAbsoluteY(int i, int i2) {
        get(i).layout.editorAbsoluteY = i2;
    }

    public void constrainHeight(int i, int i2) {
        get(i).layout.mHeight = i2;
    }

    public void constrainWidth(int i, int i2) {
        get(i).layout.mWidth = i2;
    }

    public void constrainCircle(int i, int i2, int i3, float f) {
        Layout layout = get(i).layout;
        layout.circleConstraint = i2;
        layout.circleRadius = i3;
        layout.circleAngle = f;
    }

    public void constrainMaxHeight(int i, int i2) {
        get(i).layout.heightMax = i2;
    }

    public void constrainMaxWidth(int i, int i2) {
        get(i).layout.widthMax = i2;
    }

    public void constrainMinHeight(int i, int i2) {
        get(i).layout.heightMin = i2;
    }

    public void constrainMinWidth(int i, int i2) {
        get(i).layout.widthMin = i2;
    }

    public void constrainPercentWidth(int i, float f) {
        get(i).layout.widthPercent = f;
    }

    public void constrainPercentHeight(int i, float f) {
        get(i).layout.heightPercent = f;
    }

    public void constrainDefaultHeight(int i, int i2) {
        get(i).layout.heightDefault = i2;
    }

    public void constrainedWidth(int i, boolean z) {
        get(i).layout.constrainedWidth = z;
    }

    public void constrainedHeight(int i, boolean z) {
        get(i).layout.constrainedHeight = z;
    }

    public void constrainDefaultWidth(int i, int i2) {
        get(i).layout.widthDefault = i2;
    }

    public void setHorizontalWeight(int i, float f) {
        get(i).layout.horizontalWeight = f;
    }

    public void setVerticalWeight(int i, float f) {
        get(i).layout.verticalWeight = f;
    }

    public void setHorizontalChainStyle(int i, int i2) {
        get(i).layout.horizontalChainStyle = i2;
    }

    public void setVerticalChainStyle(int i, int i2) {
        get(i).layout.verticalChainStyle = i2;
    }

    public void addToHorizontalChain(int i, int i2, int i3) {
        connect(i, 1, i2, i2 == 0 ? 1 : 2, 0);
        connect(i, 2, i3, i3 == 0 ? 2 : 1, 0);
        if (i2 != 0) {
            connect(i2, 2, i, 1, 0);
        }
        if (i3 != 0) {
            connect(i3, 1, i, 2, 0);
        }
    }

    public void addToHorizontalChainRTL(int i, int i2, int i3) {
        connect(i, 6, i2, i2 == 0 ? 6 : 7, 0);
        connect(i, 7, i3, i3 == 0 ? 7 : 6, 0);
        if (i2 != 0) {
            connect(i2, 7, i, 6, 0);
        }
        if (i3 != 0) {
            connect(i3, 6, i, 7, 0);
        }
    }

    public void addToVerticalChain(int i, int i2, int i3) {
        connect(i, 3, i2, i2 == 0 ? 3 : 4, 0);
        connect(i, 4, i3, i3 == 0 ? 4 : 3, 0);
        if (i2 != 0) {
            connect(i2, 4, i, 3, 0);
        }
        if (i3 != 0) {
            connect(i3, 3, i, 4, 0);
        }
    }

    public void removeFromVerticalChain(int i) {
        if (this.mConstraints.containsKey(Integer.valueOf(i))) {
            Layout layout = this.mConstraints.get(Integer.valueOf(i)).layout;
            int i2 = layout.topToBottom;
            int i3 = layout.bottomToTop;
            if (!(i2 == -1 && i3 == -1)) {
                if (i2 != -1 && i3 != -1) {
                    connect(i2, 4, i3, 3, 0);
                    connect(i3, 3, i2, 4, 0);
                } else if (!(i2 == -1 && i3 == -1)) {
                    int i4 = layout.bottomToBottom;
                    if (i4 != -1) {
                        connect(i2, 4, i4, 4, 0);
                    } else {
                        int i5 = layout.topToTop;
                        if (i5 != -1) {
                            connect(i3, 3, i5, 3, 0);
                        }
                    }
                }
            }
        }
        clear(i, 3);
        clear(i, 4);
    }

    public void removeFromHorizontalChain(int i) {
        if (this.mConstraints.containsKey(Integer.valueOf(i))) {
            Layout layout = this.mConstraints.get(Integer.valueOf(i)).layout;
            int i2 = layout.leftToRight;
            int i3 = layout.rightToLeft;
            if (i2 == -1 && i3 == -1) {
                int i4 = layout.startToEnd;
                int i5 = layout.endToStart;
                if (!(i4 == -1 && i5 == -1)) {
                    if (i4 != -1 && i5 != -1) {
                        connect(i4, 7, i5, 6, 0);
                        connect(i5, 6, i2, 7, 0);
                    } else if (!(i2 == -1 && i5 == -1)) {
                        int i6 = layout.rightToRight;
                        if (i6 != -1) {
                            connect(i2, 7, i6, 7, 0);
                        } else {
                            int i7 = layout.leftToLeft;
                            if (i7 != -1) {
                                connect(i5, 6, i7, 6, 0);
                            }
                        }
                    }
                }
                clear(i, 6);
                clear(i, 7);
                return;
            }
            if (i2 != -1 && i3 != -1) {
                connect(i2, 2, i3, 1, 0);
                connect(i3, 1, i2, 2, 0);
            } else if (!(i2 == -1 && i3 == -1)) {
                int i8 = layout.rightToRight;
                if (i8 != -1) {
                    connect(i2, 2, i8, 2, 0);
                } else {
                    int i9 = layout.leftToLeft;
                    if (i9 != -1) {
                        connect(i3, 1, i9, 1, 0);
                    }
                }
            }
            clear(i, 1);
            clear(i, 2);
        }
    }

    public void create(int i, int i2) {
        Layout layout = get(i).layout;
        layout.mIsGuideline = true;
        layout.orientation = i2;
    }

    public void createBarrier(int i, int i2, int i3, int... iArr) {
        Layout layout = get(i).layout;
        layout.mHelperType = 1;
        layout.mBarrierDirection = i2;
        layout.mBarrierMargin = i3;
        layout.mIsGuideline = false;
        layout.mReferenceIds = iArr;
    }

    public void setGuidelineBegin(int i, int i2) {
        get(i).layout.guideBegin = i2;
        get(i).layout.guideEnd = -1;
        get(i).layout.guidePercent = -1.0f;
    }

    public void setGuidelineEnd(int i, int i2) {
        get(i).layout.guideEnd = i2;
        get(i).layout.guideBegin = -1;
        get(i).layout.guidePercent = -1.0f;
    }

    public void setGuidelinePercent(int i, float f) {
        get(i).layout.guidePercent = f;
        get(i).layout.guideEnd = -1;
        get(i).layout.guideBegin = -1;
    }

    public void setBarrierType(int i, int i2) {
        get(i).layout.mHelperType = i2;
    }

    public void removeAttribute(String str) {
        this.mSavedAttributes.remove(str);
    }

    public void setIntValue(int i, String str, int i2) {
        get(i).setIntValue(str, i2);
    }

    public void setColorValue(int i, String str, int i2) {
        get(i).setColorValue(str, i2);
    }

    public void setFloatValue(int i, String str, float f) {
        get(i).setFloatValue(str, f);
    }

    public void setStringValue(int i, String str, String str2) {
        get(i).setStringValue(str, str2);
    }

    private void addAttributes(ConstraintAttribute.AttributeType attributeType, String... strArr) {
        for (int i = 0; i < strArr.length; i++) {
            if (this.mSavedAttributes.containsKey(strArr[i])) {
                ConstraintAttribute constraintAttribute = this.mSavedAttributes.get(strArr[i]);
                if (constraintAttribute.getType() != attributeType) {
                    throw new IllegalArgumentException("ConstraintAttribute is already a " + constraintAttribute.getType().name());
                }
            } else {
                this.mSavedAttributes.put(strArr[i], new ConstraintAttribute(strArr[i], attributeType));
            }
        }
    }

    public void parseIntAttributes(Constraint constraint, String str) {
        String[] split = str.split(",");
        for (int i = 0; i < split.length; i++) {
            String[] split2 = split[i].split("=");
            if (split2.length != 2) {
                Log.w(TAG, " Unable to parse " + split[i]);
            } else {
                constraint.setFloatValue(split2[0], (float) Integer.decode(split2[1]).intValue());
            }
        }
    }

    public void parseColorAttributes(Constraint constraint, String str) {
        String[] split = str.split(",");
        for (int i = 0; i < split.length; i++) {
            String[] split2 = split[i].split("=");
            if (split2.length != 2) {
                Log.w(TAG, " Unable to parse " + split[i]);
            } else {
                constraint.setColorValue(split2[0], Color.parseColor(split2[1]));
            }
        }
    }

    public void parseFloatAttributes(Constraint constraint, String str) {
        String[] split = str.split(",");
        for (int i = 0; i < split.length; i++) {
            String[] split2 = split[i].split("=");
            if (split2.length != 2) {
                Log.w(TAG, " Unable to parse " + split[i]);
            } else {
                constraint.setFloatValue(split2[0], Float.parseFloat(split2[1]));
            }
        }
    }

    public void parseStringAttributes(Constraint constraint, String str) {
        String[] splitString = splitString(str);
        for (int i = 0; i < splitString.length; i++) {
            String[] split = splitString[i].split("=");
            Log.w(TAG, " Unable to parse " + splitString[i]);
            constraint.setStringValue(split[0], split[1]);
        }
    }

    private static String[] splitString(String str) {
        char[] charArray = str.toCharArray();
        ArrayList arrayList = new ArrayList();
        int i = 0;
        boolean z = false;
        for (int i2 = 0; i2 < charArray.length; i2++) {
            char c = charArray[i2];
            if (c == ',' && !z) {
                arrayList.add(new String(charArray, i, i2 - i));
                i = i2 + 1;
            } else if (c == '\"') {
                z = !z;
            }
        }
        arrayList.add(new String(charArray, i, charArray.length - i));
        return (String[]) arrayList.toArray(new String[arrayList.size()]);
    }

    public void addIntAttributes(String... strArr) {
        addAttributes(ConstraintAttribute.AttributeType.INT_TYPE, strArr);
    }

    public void addColorAttributes(String... strArr) {
        addAttributes(ConstraintAttribute.AttributeType.COLOR_TYPE, strArr);
    }

    public void addFloatAttributes(String... strArr) {
        addAttributes(ConstraintAttribute.AttributeType.FLOAT_TYPE, strArr);
    }

    public void addStringAttributes(String... strArr) {
        addAttributes(ConstraintAttribute.AttributeType.STRING_TYPE, strArr);
    }

    private Constraint get(int i) {
        if (!this.mConstraints.containsKey(Integer.valueOf(i))) {
            this.mConstraints.put(Integer.valueOf(i), new Constraint());
        }
        return this.mConstraints.get(Integer.valueOf(i));
    }

    public void load(Context context, int i) {
        XmlResourceParser xml = context.getResources().getXml(i);
        try {
            for (int eventType = xml.getEventType(); eventType != 1; eventType = xml.next()) {
                if (eventType == 0) {
                    xml.getName();
                } else if (eventType == 2) {
                    String name = xml.getName();
                    Constraint fillFromAttributeList = fillFromAttributeList(context, Xml.asAttributeSet(xml));
                    if (name.equalsIgnoreCase("Guideline")) {
                        fillFromAttributeList.layout.mIsGuideline = true;
                    }
                    this.mConstraints.put(Integer.valueOf(fillFromAttributeList.mViewId), fillFromAttributeList);
                }
            }
        } catch (XmlPullParserException e) {
            e.printStackTrace();
        } catch (IOException e2) {
            e2.printStackTrace();
        }
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* JADX WARNING: Code restructure failed: missing block: B:94:0x0179, code lost:
        continue;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void load(android.content.Context r10, org.xmlpull.v1.XmlPullParser r11) {
        /*
            r9 = this;
            int r0 = r11.getEventType()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r1 = 0
            r2 = r1
        L_0x0006:
            r3 = 1
            if (r0 == r3) goto L_0x0188
            if (r0 == 0) goto L_0x0176
            java.lang.String r4 = "Constraint"
            r5 = 3
            r6 = 2
            if (r0 == r6) goto L_0x0036
            if (r0 == r5) goto L_0x0015
            goto L_0x0179
        L_0x0015:
            java.lang.String r0 = r11.getName()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.String r3 = "ConstraintSet"
            boolean r3 = r3.equals(r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r3 == 0) goto L_0x0022
            return
        L_0x0022:
            boolean r0 = r0.equalsIgnoreCase(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0179
            java.util.HashMap<java.lang.Integer, androidx.constraintlayout.widget.ConstraintSet$Constraint> r0 = r9.mConstraints     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            int r3 = r2.mViewId     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.Integer r3 = java.lang.Integer.valueOf(r3)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r0.put(r3, r2)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r2 = r1
            goto L_0x0179
        L_0x0036:
            java.lang.String r0 = r11.getName()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r7 = -1
            int r8 = r0.hashCode()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            switch(r8) {
                case -2025855158: goto L_0x0086;
                case -1984451626: goto L_0x007c;
                case -1269513683: goto L_0x0073;
                case -1238332596: goto L_0x0069;
                case -71750448: goto L_0x005f;
                case 1331510167: goto L_0x0055;
                case 1791837707: goto L_0x004b;
                case 1803088381: goto L_0x0043;
                default: goto L_0x0042;
            }     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
        L_0x0042:
            goto L_0x0090
        L_0x0043:
            boolean r0 = r0.equals(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0090
            r5 = 0
            goto L_0x0091
        L_0x004b:
            java.lang.String r4 = "CustomAttribute"
            boolean r0 = r0.equals(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0090
            r5 = 7
            goto L_0x0091
        L_0x0055:
            java.lang.String r4 = "Barrier"
            boolean r0 = r0.equals(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0090
            r5 = r6
            goto L_0x0091
        L_0x005f:
            java.lang.String r4 = "Guideline"
            boolean r0 = r0.equals(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0090
            r5 = r3
            goto L_0x0091
        L_0x0069:
            java.lang.String r4 = "Transform"
            boolean r0 = r0.equals(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0090
            r5 = 4
            goto L_0x0091
        L_0x0073:
            java.lang.String r4 = "PropertySet"
            boolean r0 = r0.equals(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0090
            goto L_0x0091
        L_0x007c:
            java.lang.String r4 = "Motion"
            boolean r0 = r0.equals(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0090
            r5 = 6
            goto L_0x0091
        L_0x0086:
            java.lang.String r4 = "Layout"
            boolean r0 = r0.equals(r4)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            if (r0 == 0) goto L_0x0090
            r5 = 5
            goto L_0x0091
        L_0x0090:
            r5 = r7
        L_0x0091:
            java.lang.String r0 = "XML parser error must be within a Constraint "
            switch(r5) {
                case 0: goto L_0x016c;
                case 1: goto L_0x015d;
                case 2: goto L_0x0150;
                case 3: goto L_0x012b;
                case 4: goto L_0x0106;
                case 5: goto L_0x00e0;
                case 6: goto L_0x00ba;
                case 7: goto L_0x0098;
                default: goto L_0x0096;
            }
        L_0x0096:
            goto L_0x0179
        L_0x0098:
            if (r2 == 0) goto L_0x00a1
            java.util.HashMap<java.lang.String, androidx.constraintlayout.widget.ConstraintAttribute> r0 = r2.mCustomConstraints     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            androidx.constraintlayout.widget.ConstraintAttribute.parse(r10, r11, r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            goto L_0x0179
        L_0x00a1:
            java.lang.RuntimeException r9 = new java.lang.RuntimeException     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.<init>()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            int r11 = r11.getLineNumber()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.String r10 = r10.toString()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r9.<init>(r10)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            throw r9     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
        L_0x00ba:
            if (r2 == 0) goto L_0x00c7
            androidx.constraintlayout.widget.ConstraintSet$Motion r0 = r2.motion     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            android.util.AttributeSet r3 = android.util.Xml.asAttributeSet(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r0.fillFromAttributeList(r10, r3)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            goto L_0x0179
        L_0x00c7:
            java.lang.RuntimeException r9 = new java.lang.RuntimeException     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.<init>()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            int r11 = r11.getLineNumber()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.String r10 = r10.toString()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r9.<init>(r10)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            throw r9     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
        L_0x00e0:
            if (r2 == 0) goto L_0x00ed
            androidx.constraintlayout.widget.ConstraintSet$Layout r0 = r2.layout     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            android.util.AttributeSet r3 = android.util.Xml.asAttributeSet(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r0.fillFromAttributeList(r10, r3)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            goto L_0x0179
        L_0x00ed:
            java.lang.RuntimeException r9 = new java.lang.RuntimeException     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.<init>()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            int r11 = r11.getLineNumber()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.String r10 = r10.toString()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r9.<init>(r10)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            throw r9     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
        L_0x0106:
            if (r2 == 0) goto L_0x0112
            androidx.constraintlayout.widget.ConstraintSet$Transform r0 = r2.transform     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            android.util.AttributeSet r3 = android.util.Xml.asAttributeSet(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r0.fillFromAttributeList(r10, r3)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            goto L_0x0179
        L_0x0112:
            java.lang.RuntimeException r9 = new java.lang.RuntimeException     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.<init>()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            int r11 = r11.getLineNumber()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.String r10 = r10.toString()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r9.<init>(r10)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            throw r9     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
        L_0x012b:
            if (r2 == 0) goto L_0x0137
            androidx.constraintlayout.widget.ConstraintSet$PropertySet r0 = r2.propertySet     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            android.util.AttributeSet r3 = android.util.Xml.asAttributeSet(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r0.fillFromAttributeList(r10, r3)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            goto L_0x0179
        L_0x0137:
            java.lang.RuntimeException r9 = new java.lang.RuntimeException     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.<init>()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            int r11 = r11.getLineNumber()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r10.append(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            java.lang.String r10 = r10.toString()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r9.<init>(r10)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            throw r9     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
        L_0x0150:
            android.util.AttributeSet r0 = android.util.Xml.asAttributeSet(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            androidx.constraintlayout.widget.ConstraintSet$Constraint r0 = r9.fillFromAttributeList(r10, r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            androidx.constraintlayout.widget.ConstraintSet$Layout r2 = r0.layout     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r2.mHelperType = r3     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            goto L_0x0174
        L_0x015d:
            android.util.AttributeSet r0 = android.util.Xml.asAttributeSet(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            androidx.constraintlayout.widget.ConstraintSet$Constraint r0 = r9.fillFromAttributeList(r10, r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            androidx.constraintlayout.widget.ConstraintSet$Layout r2 = r0.layout     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r2.mIsGuideline = r3     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            r2.mApply = r3     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            goto L_0x0174
        L_0x016c:
            android.util.AttributeSet r0 = android.util.Xml.asAttributeSet(r11)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            androidx.constraintlayout.widget.ConstraintSet$Constraint r0 = r9.fillFromAttributeList(r10, r0)     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
        L_0x0174:
            r2 = r0
            goto L_0x0179
        L_0x0176:
            r11.getName()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
        L_0x0179:
            int r0 = r11.next()     // Catch:{ XmlPullParserException -> 0x0184, IOException -> 0x017f }
            goto L_0x0006
        L_0x017f:
            r9 = move-exception
            r9.printStackTrace()
            goto L_0x0188
        L_0x0184:
            r9 = move-exception
            r9.printStackTrace()
        L_0x0188:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.widget.ConstraintSet.load(android.content.Context, org.xmlpull.v1.XmlPullParser):void");
    }

    /* access modifiers changed from: private */
    public static int lookupID(TypedArray typedArray, int i, int i2) {
        int resourceId = typedArray.getResourceId(i, i2);
        return resourceId == -1 ? typedArray.getInt(i, -1) : resourceId;
    }

    private Constraint fillFromAttributeList(Context context, AttributeSet attributeSet) {
        Constraint constraint = new Constraint();
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.Constraint);
        populateConstraint(context, constraint, obtainStyledAttributes);
        obtainStyledAttributes.recycle();
        return constraint;
    }

    private void populateConstraint(Context context, Constraint constraint, TypedArray typedArray) {
        int indexCount = typedArray.getIndexCount();
        for (int i = 0; i < indexCount; i++) {
            int index = typedArray.getIndex(i);
            if (index != R.styleable.Constraint_android_id) {
                constraint.motion.mApply = true;
                constraint.layout.mApply = true;
                constraint.propertySet.mApply = true;
                constraint.transform.mApply = true;
            }
            switch (mapToConstant.get(index)) {
                case 1:
                    Layout layout = constraint.layout;
                    layout.baselineToBaseline = lookupID(typedArray, index, layout.baselineToBaseline);
                    break;
                case 2:
                    Layout layout2 = constraint.layout;
                    layout2.bottomMargin = typedArray.getDimensionPixelSize(index, layout2.bottomMargin);
                    break;
                case 3:
                    Layout layout3 = constraint.layout;
                    layout3.bottomToBottom = lookupID(typedArray, index, layout3.bottomToBottom);
                    break;
                case 4:
                    Layout layout4 = constraint.layout;
                    layout4.bottomToTop = lookupID(typedArray, index, layout4.bottomToTop);
                    break;
                case 5:
                    constraint.layout.dimensionRatio = typedArray.getString(index);
                    break;
                case 6:
                    Layout layout5 = constraint.layout;
                    layout5.editorAbsoluteX = typedArray.getDimensionPixelOffset(index, layout5.editorAbsoluteX);
                    break;
                case 7:
                    Layout layout6 = constraint.layout;
                    layout6.editorAbsoluteY = typedArray.getDimensionPixelOffset(index, layout6.editorAbsoluteY);
                    break;
                case 8:
                    Layout layout7 = constraint.layout;
                    layout7.endMargin = typedArray.getDimensionPixelSize(index, layout7.endMargin);
                    break;
                case 9:
                    Layout layout8 = constraint.layout;
                    layout8.endToEnd = lookupID(typedArray, index, layout8.endToEnd);
                    break;
                case 10:
                    Layout layout9 = constraint.layout;
                    layout9.endToStart = lookupID(typedArray, index, layout9.endToStart);
                    break;
                case 11:
                    Layout layout10 = constraint.layout;
                    layout10.goneBottomMargin = typedArray.getDimensionPixelSize(index, layout10.goneBottomMargin);
                    break;
                case 12:
                    Layout layout11 = constraint.layout;
                    layout11.goneEndMargin = typedArray.getDimensionPixelSize(index, layout11.goneEndMargin);
                    break;
                case 13:
                    Layout layout12 = constraint.layout;
                    layout12.goneLeftMargin = typedArray.getDimensionPixelSize(index, layout12.goneLeftMargin);
                    break;
                case 14:
                    Layout layout13 = constraint.layout;
                    layout13.goneRightMargin = typedArray.getDimensionPixelSize(index, layout13.goneRightMargin);
                    break;
                case 15:
                    Layout layout14 = constraint.layout;
                    layout14.goneStartMargin = typedArray.getDimensionPixelSize(index, layout14.goneStartMargin);
                    break;
                case 16:
                    Layout layout15 = constraint.layout;
                    layout15.goneTopMargin = typedArray.getDimensionPixelSize(index, layout15.goneTopMargin);
                    break;
                case 17:
                    Layout layout16 = constraint.layout;
                    layout16.guideBegin = typedArray.getDimensionPixelOffset(index, layout16.guideBegin);
                    break;
                case 18:
                    Layout layout17 = constraint.layout;
                    layout17.guideEnd = typedArray.getDimensionPixelOffset(index, layout17.guideEnd);
                    break;
                case 19:
                    Layout layout18 = constraint.layout;
                    layout18.guidePercent = typedArray.getFloat(index, layout18.guidePercent);
                    break;
                case 20:
                    Layout layout19 = constraint.layout;
                    layout19.horizontalBias = typedArray.getFloat(index, layout19.horizontalBias);
                    break;
                case 21:
                    Layout layout20 = constraint.layout;
                    layout20.mHeight = typedArray.getLayoutDimension(index, layout20.mHeight);
                    break;
                case 22:
                    PropertySet propertySet = constraint.propertySet;
                    propertySet.visibility = typedArray.getInt(index, propertySet.visibility);
                    PropertySet propertySet2 = constraint.propertySet;
                    propertySet2.visibility = VISIBILITY_FLAGS[propertySet2.visibility];
                    break;
                case 23:
                    Layout layout21 = constraint.layout;
                    layout21.mWidth = typedArray.getLayoutDimension(index, layout21.mWidth);
                    break;
                case 24:
                    Layout layout22 = constraint.layout;
                    layout22.leftMargin = typedArray.getDimensionPixelSize(index, layout22.leftMargin);
                    break;
                case 25:
                    Layout layout23 = constraint.layout;
                    layout23.leftToLeft = lookupID(typedArray, index, layout23.leftToLeft);
                    break;
                case 26:
                    Layout layout24 = constraint.layout;
                    layout24.leftToRight = lookupID(typedArray, index, layout24.leftToRight);
                    break;
                case 27:
                    Layout layout25 = constraint.layout;
                    layout25.orientation = typedArray.getInt(index, layout25.orientation);
                    break;
                case 28:
                    Layout layout26 = constraint.layout;
                    layout26.rightMargin = typedArray.getDimensionPixelSize(index, layout26.rightMargin);
                    break;
                case 29:
                    Layout layout27 = constraint.layout;
                    layout27.rightToLeft = lookupID(typedArray, index, layout27.rightToLeft);
                    break;
                case 30:
                    Layout layout28 = constraint.layout;
                    layout28.rightToRight = lookupID(typedArray, index, layout28.rightToRight);
                    break;
                case 31:
                    Layout layout29 = constraint.layout;
                    layout29.startMargin = typedArray.getDimensionPixelSize(index, layout29.startMargin);
                    break;
                case 32:
                    Layout layout30 = constraint.layout;
                    layout30.startToEnd = lookupID(typedArray, index, layout30.startToEnd);
                    break;
                case 33:
                    Layout layout31 = constraint.layout;
                    layout31.startToStart = lookupID(typedArray, index, layout31.startToStart);
                    break;
                case 34:
                    Layout layout32 = constraint.layout;
                    layout32.topMargin = typedArray.getDimensionPixelSize(index, layout32.topMargin);
                    break;
                case 35:
                    Layout layout33 = constraint.layout;
                    layout33.topToBottom = lookupID(typedArray, index, layout33.topToBottom);
                    break;
                case 36:
                    Layout layout34 = constraint.layout;
                    layout34.topToTop = lookupID(typedArray, index, layout34.topToTop);
                    break;
                case 37:
                    Layout layout35 = constraint.layout;
                    layout35.verticalBias = typedArray.getFloat(index, layout35.verticalBias);
                    break;
                case 38:
                    constraint.mViewId = typedArray.getResourceId(index, constraint.mViewId);
                    break;
                case 39:
                    Layout layout36 = constraint.layout;
                    layout36.horizontalWeight = typedArray.getFloat(index, layout36.horizontalWeight);
                    break;
                case 40:
                    Layout layout37 = constraint.layout;
                    layout37.verticalWeight = typedArray.getFloat(index, layout37.verticalWeight);
                    break;
                case 41:
                    Layout layout38 = constraint.layout;
                    layout38.horizontalChainStyle = typedArray.getInt(index, layout38.horizontalChainStyle);
                    break;
                case 42:
                    Layout layout39 = constraint.layout;
                    layout39.verticalChainStyle = typedArray.getInt(index, layout39.verticalChainStyle);
                    break;
                case 43:
                    PropertySet propertySet3 = constraint.propertySet;
                    propertySet3.alpha = typedArray.getFloat(index, propertySet3.alpha);
                    break;
                case 44:
                    Transform transform = constraint.transform;
                    transform.applyElevation = true;
                    transform.elevation = typedArray.getDimension(index, transform.elevation);
                    break;
                case 45:
                    Transform transform2 = constraint.transform;
                    transform2.rotationX = typedArray.getFloat(index, transform2.rotationX);
                    break;
                case 46:
                    Transform transform3 = constraint.transform;
                    transform3.rotationY = typedArray.getFloat(index, transform3.rotationY);
                    break;
                case 47:
                    Transform transform4 = constraint.transform;
                    transform4.scaleX = typedArray.getFloat(index, transform4.scaleX);
                    break;
                case 48:
                    Transform transform5 = constraint.transform;
                    transform5.scaleY = typedArray.getFloat(index, transform5.scaleY);
                    break;
                case 49:
                    Transform transform6 = constraint.transform;
                    transform6.transformPivotX = typedArray.getFloat(index, transform6.transformPivotX);
                    break;
                case 50:
                    Transform transform7 = constraint.transform;
                    transform7.transformPivotY = typedArray.getFloat(index, transform7.transformPivotY);
                    break;
                case 51:
                    Transform transform8 = constraint.transform;
                    transform8.translationX = typedArray.getDimension(index, transform8.translationX);
                    break;
                case 52:
                    Transform transform9 = constraint.transform;
                    transform9.translationY = typedArray.getDimension(index, transform9.translationY);
                    break;
                case 53:
                    Transform transform10 = constraint.transform;
                    transform10.translationZ = typedArray.getDimension(index, transform10.translationZ);
                    break;
                case 54:
                    Layout layout40 = constraint.layout;
                    layout40.widthDefault = typedArray.getInt(index, layout40.widthDefault);
                    break;
                case 55:
                    Layout layout41 = constraint.layout;
                    layout41.heightDefault = typedArray.getInt(index, layout41.heightDefault);
                    break;
                case 56:
                    Layout layout42 = constraint.layout;
                    layout42.widthMax = typedArray.getDimensionPixelSize(index, layout42.widthMax);
                    break;
                case 57:
                    Layout layout43 = constraint.layout;
                    layout43.heightMax = typedArray.getDimensionPixelSize(index, layout43.heightMax);
                    break;
                case 58:
                    Layout layout44 = constraint.layout;
                    layout44.widthMin = typedArray.getDimensionPixelSize(index, layout44.widthMin);
                    break;
                case 59:
                    Layout layout45 = constraint.layout;
                    layout45.heightMin = typedArray.getDimensionPixelSize(index, layout45.heightMin);
                    break;
                case 60:
                    Transform transform11 = constraint.transform;
                    transform11.rotation = typedArray.getFloat(index, transform11.rotation);
                    break;
                case 61:
                    Layout layout46 = constraint.layout;
                    layout46.circleConstraint = lookupID(typedArray, index, layout46.circleConstraint);
                    break;
                case 62:
                    Layout layout47 = constraint.layout;
                    layout47.circleRadius = typedArray.getDimensionPixelSize(index, layout47.circleRadius);
                    break;
                case 63:
                    Layout layout48 = constraint.layout;
                    layout48.circleAngle = typedArray.getFloat(index, layout48.circleAngle);
                    break;
                case 64:
                    Motion motion = constraint.motion;
                    motion.mAnimateRelativeTo = lookupID(typedArray, index, motion.mAnimateRelativeTo);
                    break;
                case 65:
                    if (typedArray.peekValue(index).type != 3) {
                        constraint.motion.mTransitionEasing = Easing.NAMED_EASING[typedArray.getInteger(index, 0)];
                        break;
                    } else {
                        constraint.motion.mTransitionEasing = typedArray.getString(index);
                        break;
                    }
                case 66:
                    constraint.motion.mDrawPath = typedArray.getInt(index, 0);
                    break;
                case 67:
                    Motion motion2 = constraint.motion;
                    motion2.mPathRotate = typedArray.getFloat(index, motion2.mPathRotate);
                    break;
                case 68:
                    PropertySet propertySet4 = constraint.propertySet;
                    propertySet4.mProgress = typedArray.getFloat(index, propertySet4.mProgress);
                    break;
                case 69:
                    constraint.layout.widthPercent = typedArray.getFloat(index, 1.0f);
                    break;
                case 70:
                    constraint.layout.heightPercent = typedArray.getFloat(index, 1.0f);
                    break;
                case 71:
                    Log.e(TAG, "CURRENTLY UNSUPPORTED");
                    break;
                case 72:
                    Layout layout49 = constraint.layout;
                    layout49.mBarrierDirection = typedArray.getInt(index, layout49.mBarrierDirection);
                    break;
                case 73:
                    Layout layout50 = constraint.layout;
                    layout50.mBarrierMargin = typedArray.getDimensionPixelSize(index, layout50.mBarrierMargin);
                    break;
                case 74:
                    constraint.layout.mReferenceIdString = typedArray.getString(index);
                    break;
                case 75:
                    Layout layout51 = constraint.layout;
                    layout51.mBarrierAllowsGoneWidgets = typedArray.getBoolean(index, layout51.mBarrierAllowsGoneWidgets);
                    break;
                case 76:
                    Motion motion3 = constraint.motion;
                    motion3.mPathMotionArc = typedArray.getInt(index, motion3.mPathMotionArc);
                    break;
                case 77:
                    constraint.layout.mConstraintTag = typedArray.getString(index);
                    break;
                case 78:
                    PropertySet propertySet5 = constraint.propertySet;
                    propertySet5.mVisibilityMode = typedArray.getInt(index, propertySet5.mVisibilityMode);
                    break;
                case 79:
                    Motion motion4 = constraint.motion;
                    motion4.mMotionStagger = typedArray.getFloat(index, motion4.mMotionStagger);
                    break;
                case 80:
                    Layout layout52 = constraint.layout;
                    layout52.constrainedWidth = typedArray.getBoolean(index, layout52.constrainedWidth);
                    break;
                case 81:
                    Layout layout53 = constraint.layout;
                    layout53.constrainedHeight = typedArray.getBoolean(index, layout53.constrainedHeight);
                    break;
                case 82:
                    Log.w(TAG, "unused attribute 0x" + Integer.toHexString(index) + "   " + mapToConstant.get(index));
                    break;
                default:
                    Log.w(TAG, "Unknown attribute 0x" + Integer.toHexString(index) + "   " + mapToConstant.get(index));
                    break;
            }
        }
    }

    private int[] convertReferenceString(View view, String str) {
        int i;
        Object designInformation;
        String[] split = str.split(",");
        Context context = view.getContext();
        int[] iArr = new int[split.length];
        int i2 = 0;
        int i3 = 0;
        while (i2 < split.length) {
            String trim = split[i2].trim();
            try {
                i = R.id.class.getField(trim).getInt((Object) null);
            } catch (Exception unused) {
                i = 0;
            }
            if (i == 0) {
                i = context.getResources().getIdentifier(trim, XmlTagConst.TAG_CHANNELS_ID, context.getPackageName());
            }
            if (i == 0 && view.isInEditMode() && (view.getParent() instanceof ConstraintLayout) && (designInformation = ((ConstraintLayout) view.getParent()).getDesignInformation(0, trim)) != null && (designInformation instanceof Integer)) {
                i = ((Integer) designInformation).intValue();
            }
            iArr[i3] = i;
            i2++;
            i3++;
        }
        return i3 != split.length ? Arrays.copyOf(iArr, i3) : iArr;
    }

    public Constraint getConstraint(int i) {
        if (this.mConstraints.containsKey(Integer.valueOf(i))) {
            return this.mConstraints.get(Integer.valueOf(i));
        }
        return null;
    }

    public int[] getKnownIds() {
        Integer[] numArr = (Integer[]) this.mConstraints.keySet().toArray(new Integer[0]);
        int length = numArr.length;
        int[] iArr = new int[length];
        for (int i = 0; i < length; i++) {
            iArr[i] = numArr[i].intValue();
        }
        return iArr;
    }

    public boolean isForceId() {
        return this.mForceId;
    }

    public void setForceId(boolean z) {
        this.mForceId = z;
    }

    public void setValidateOnParse(boolean z) {
        this.mValidate = z;
    }

    public void dump(MotionScene motionScene, int... iArr) {
        HashSet hashSet;
        Set<Integer> keySet = this.mConstraints.keySet();
        if (iArr.length != 0) {
            hashSet = new HashSet();
            for (int valueOf : iArr) {
                hashSet.add(Integer.valueOf(valueOf));
            }
        } else {
            hashSet = new HashSet(keySet);
        }
        System.out.println(hashSet.size() + " constraints");
        StringBuilder sb = new StringBuilder();
        for (Integer num : (Integer[]) hashSet.toArray(new Integer[0])) {
            sb.append("<Constraint id=");
            sb.append(num);
            sb.append(" \n");
            this.mConstraints.get(num).layout.dump(motionScene, sb);
            sb.append("/>\n");
        }
        System.out.println(sb.toString());
    }
}
