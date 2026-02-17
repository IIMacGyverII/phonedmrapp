package com.google.android.material.textfield;

import android.animation.ValueAnimator;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.Configuration;
import android.graphics.Canvas;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.util.Log;
import android.util.SparseArray;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStructure;
import android.widget.AutoCompleteTextView;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.annotation.ColorInt;
import androidx.annotation.ColorRes;
import androidx.annotation.DimenRes;
import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.Px;
import androidx.annotation.RestrictTo;
import androidx.annotation.StringRes;
import androidx.annotation.StyleRes;
import androidx.annotation.VisibleForTesting;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.appcompat.widget.AppCompatDrawableManager;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.appcompat.widget.DrawableUtils;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.drawable.DrawableCompat;
import androidx.core.text.BidiFormatter;
import androidx.core.view.AccessibilityDelegateCompat;
import androidx.core.view.MarginLayoutParamsCompat;
import androidx.core.view.ViewCompat;
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat;
import androidx.core.widget.TextViewCompat;
import androidx.customview.view.AbsSavedState;
import androidx.transition.Fade;
import androidx.transition.TransitionManager;
import com.google.android.material.R;
import com.google.android.material.animation.AnimationUtils;
import com.google.android.material.color.MaterialColors;
import com.google.android.material.internal.CheckableImageButton;
import com.google.android.material.internal.CollapsingTextHelper;
import com.google.android.material.internal.DescendantOffsetUtils;
import com.google.android.material.internal.ViewUtils;
import com.google.android.material.resources.MaterialResources;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.ShapeAppearanceModel;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedHashSet;

public class TextInputLayout extends LinearLayout {
    public static final int BOX_BACKGROUND_FILLED = 1;
    public static final int BOX_BACKGROUND_NONE = 0;
    public static final int BOX_BACKGROUND_OUTLINE = 2;
    private static final int DEF_STYLE_RES = R.style.Widget_Design_TextInputLayout;
    public static final int END_ICON_CLEAR_TEXT = 2;
    public static final int END_ICON_CUSTOM = -1;
    public static final int END_ICON_DROPDOWN_MENU = 3;
    public static final int END_ICON_NONE = 0;
    public static final int END_ICON_PASSWORD_TOGGLE = 1;
    private static final int INVALID_MAX_LENGTH = -1;
    private static final int LABEL_SCALE_ANIMATION_DURATION = 167;
    private static final String LOG_TAG = "TextInputLayout";
    private static final int NO_WIDTH = -1;
    private static final long PLACEHOLDER_FADE_DURATION = 87;
    private static final long PLACEHOLDER_START_DELAY = 67;
    private ValueAnimator animator;
    private boolean areCornerRadiiRtl;
    @Nullable
    private MaterialShapeDrawable boxBackground;
    @ColorInt
    private int boxBackgroundColor;
    private int boxBackgroundMode;
    private int boxCollapsedPaddingTopPx;
    private final int boxLabelCutoutPaddingPx;
    @ColorInt
    private int boxStrokeColor;
    private int boxStrokeWidthDefaultPx;
    private int boxStrokeWidthFocusedPx;
    private int boxStrokeWidthPx;
    @Nullable
    private MaterialShapeDrawable boxUnderlineDefault;
    @Nullable
    private MaterialShapeDrawable boxUnderlineFocused;
    final CollapsingTextHelper collapsingTextHelper;
    boolean counterEnabled;
    private int counterMaxLength;
    private int counterOverflowTextAppearance;
    @Nullable
    private ColorStateList counterOverflowTextColor;
    private boolean counterOverflowed;
    private int counterTextAppearance;
    @Nullable
    private ColorStateList counterTextColor;
    @Nullable
    private TextView counterView;
    @ColorInt
    private int defaultFilledBackgroundColor;
    private ColorStateList defaultHintTextColor;
    @ColorInt
    private int defaultStrokeColor;
    @ColorInt
    private int disabledColor;
    @ColorInt
    private int disabledFilledBackgroundColor;
    EditText editText;
    private final LinkedHashSet<OnEditTextAttachedListener> editTextAttachedListeners;
    @Nullable
    private Drawable endDummyDrawable;
    private int endDummyDrawableWidth;
    private final LinkedHashSet<OnEndIconChangedListener> endIconChangedListeners;
    private final SparseArray<EndIconDelegate> endIconDelegates;
    @NonNull
    private final FrameLayout endIconFrame;
    private int endIconMode;
    private View.OnLongClickListener endIconOnLongClickListener;
    private ColorStateList endIconTintList;
    private PorterDuff.Mode endIconTintMode;
    /* access modifiers changed from: private */
    @NonNull
    public final CheckableImageButton endIconView;
    @NonNull
    private final LinearLayout endLayout;
    private View.OnLongClickListener errorIconOnLongClickListener;
    private ColorStateList errorIconTintList;
    private PorterDuff.Mode errorIconTintMode;
    @NonNull
    private final CheckableImageButton errorIconView;
    private boolean expandedHintEnabled;
    @ColorInt
    private int focusedFilledBackgroundColor;
    @ColorInt
    private int focusedStrokeColor;
    private ColorStateList focusedTextColor;
    private CharSequence hint;
    private boolean hintAnimationEnabled;
    private boolean hintEnabled;
    private boolean hintExpanded;
    @ColorInt
    private int hoveredFilledBackgroundColor;
    @ColorInt
    private int hoveredStrokeColor;
    private boolean inDrawableStateChanged;
    /* access modifiers changed from: private */
    public final IndicatorViewController indicatorViewController;
    @NonNull
    private final FrameLayout inputFrame;
    private boolean isProvidingHint;
    private int maxEms;
    private int maxWidth;
    private int minEms;
    private int minWidth;
    private Drawable originalEditTextEndDrawable;
    private CharSequence originalHint;
    /* access modifiers changed from: private */
    public boolean placeholderEnabled;
    @Nullable
    private Fade placeholderFadeIn;
    @Nullable
    private Fade placeholderFadeOut;
    private CharSequence placeholderText;
    private int placeholderTextAppearance;
    @Nullable
    private ColorStateList placeholderTextColor;
    private TextView placeholderTextView;
    @Nullable
    private CharSequence prefixText;
    @NonNull
    private final TextView prefixTextView;
    /* access modifiers changed from: private */
    public boolean restoringSavedState;
    @NonNull
    private ShapeAppearanceModel shapeAppearanceModel;
    @Nullable
    private Drawable startDummyDrawable;
    private int startDummyDrawableWidth;
    private View.OnLongClickListener startIconOnLongClickListener;
    private ColorStateList startIconTintList;
    private PorterDuff.Mode startIconTintMode;
    /* access modifiers changed from: private */
    @NonNull
    public final CheckableImageButton startIconView;
    @NonNull
    private final LinearLayout startLayout;
    private ColorStateList strokeErrorColor;
    @Nullable
    private CharSequence suffixText;
    @NonNull
    private final TextView suffixTextView;
    private final Rect tmpBoundsRect;
    private final Rect tmpRect;
    private final RectF tmpRectF;
    private Typeface typeface;

    @Retention(RetentionPolicy.SOURCE)
    public @interface BoxBackgroundMode {
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    @Retention(RetentionPolicy.SOURCE)
    public @interface EndIconMode {
    }

    public interface OnEditTextAttachedListener {
        void onEditTextAttached(@NonNull TextInputLayout textInputLayout);
    }

    public interface OnEndIconChangedListener {
        void onEndIconChanged(@NonNull TextInputLayout textInputLayout, int i);
    }

    public TextInputLayout(@NonNull Context context) {
        this(context, (AttributeSet) null);
    }

    public TextInputLayout(@NonNull Context context, @Nullable AttributeSet attributeSet) {
        this(context, attributeSet, R.attr.textInputStyle);
    }

    /* JADX WARNING: Illegal instructions before constructor call */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public TextInputLayout(@androidx.annotation.NonNull android.content.Context r33, @androidx.annotation.Nullable android.util.AttributeSet r34, int r35) {
        /*
            r32 = this;
            r0 = r32
            r7 = r34
            r8 = r35
            int r9 = DEF_STYLE_RES
            r1 = r33
            android.content.Context r1 = com.google.android.material.theme.overlay.MaterialThemeOverlay.wrap(r1, r7, r8, r9)
            r0.<init>(r1, r7, r8)
            r10 = -1
            r0.minEms = r10
            r0.maxEms = r10
            r0.minWidth = r10
            r0.maxWidth = r10
            com.google.android.material.textfield.IndicatorViewController r1 = new com.google.android.material.textfield.IndicatorViewController
            r1.<init>(r0)
            r0.indicatorViewController = r1
            android.graphics.Rect r1 = new android.graphics.Rect
            r1.<init>()
            r0.tmpRect = r1
            android.graphics.Rect r1 = new android.graphics.Rect
            r1.<init>()
            r0.tmpBoundsRect = r1
            android.graphics.RectF r1 = new android.graphics.RectF
            r1.<init>()
            r0.tmpRectF = r1
            java.util.LinkedHashSet r1 = new java.util.LinkedHashSet
            r1.<init>()
            r0.editTextAttachedListeners = r1
            r11 = 0
            r0.endIconMode = r11
            android.util.SparseArray r12 = new android.util.SparseArray
            r12.<init>()
            r0.endIconDelegates = r12
            java.util.LinkedHashSet r1 = new java.util.LinkedHashSet
            r1.<init>()
            r0.endIconChangedListeners = r1
            com.google.android.material.internal.CollapsingTextHelper r1 = new com.google.android.material.internal.CollapsingTextHelper
            r1.<init>(r0)
            r0.collapsingTextHelper = r1
            android.content.Context r13 = r32.getContext()
            r14 = 1
            r0.setOrientation(r14)
            r0.setWillNotDraw(r11)
            r0.setAddStatesFromChildren(r14)
            android.widget.FrameLayout r15 = new android.widget.FrameLayout
            r15.<init>(r13)
            r0.inputFrame = r15
            android.widget.FrameLayout r6 = new android.widget.FrameLayout
            r6.<init>(r13)
            r0.endIconFrame = r6
            android.widget.LinearLayout r5 = new android.widget.LinearLayout
            r5.<init>(r13)
            r0.startLayout = r5
            android.widget.LinearLayout r4 = new android.widget.LinearLayout
            r4.<init>(r13)
            r0.endLayout = r4
            androidx.appcompat.widget.AppCompatTextView r3 = new androidx.appcompat.widget.AppCompatTextView
            r3.<init>(r13)
            r0.prefixTextView = r3
            androidx.appcompat.widget.AppCompatTextView r2 = new androidx.appcompat.widget.AppCompatTextView
            r2.<init>(r13)
            r0.suffixTextView = r2
            r10 = 8
            r5.setVisibility(r10)
            r4.setVisibility(r10)
            r6.setVisibility(r10)
            r3.setVisibility(r10)
            r2.setVisibility(r10)
            android.view.LayoutInflater r10 = android.view.LayoutInflater.from(r13)
            int r14 = com.google.android.material.R.layout.design_text_input_start_icon
            android.view.View r14 = r10.inflate(r14, r5, r11)
            com.google.android.material.internal.CheckableImageButton r14 = (com.google.android.material.internal.CheckableImageButton) r14
            r0.startIconView = r14
            r17 = r2
            int r2 = com.google.android.material.R.layout.design_text_input_end_icon
            android.view.View r18 = r10.inflate(r2, r4, r11)
            r19 = r12
            r12 = r18
            com.google.android.material.internal.CheckableImageButton r12 = (com.google.android.material.internal.CheckableImageButton) r12
            r0.errorIconView = r12
            android.view.View r2 = r10.inflate(r2, r6, r11)
            r10 = r2
            com.google.android.material.internal.CheckableImageButton r10 = (com.google.android.material.internal.CheckableImageButton) r10
            r0.endIconView = r10
            r2 = 1
            r15.setAddStatesFromChildren(r2)
            r5.setOrientation(r11)
            android.widget.FrameLayout$LayoutParams r2 = new android.widget.FrameLayout$LayoutParams
            r11 = -2
            r20 = r3
            r3 = 8388611(0x800003, float:1.1754948E-38)
            r21 = r15
            r15 = -1
            r2.<init>(r11, r15, r3)
            r5.setLayoutParams(r2)
            r2 = 0
            r4.setOrientation(r2)
            android.widget.FrameLayout$LayoutParams r2 = new android.widget.FrameLayout$LayoutParams
            r3 = 8388613(0x800005, float:1.175495E-38)
            r2.<init>(r11, r15, r3)
            r4.setLayoutParams(r2)
            android.widget.FrameLayout$LayoutParams r2 = new android.widget.FrameLayout$LayoutParams
            r2.<init>(r11, r15)
            r6.setLayoutParams(r2)
            android.animation.TimeInterpolator r2 = com.google.android.material.animation.AnimationUtils.LINEAR_INTERPOLATOR
            r1.setTextSizeInterpolator(r2)
            r1.setPositionInterpolator(r2)
            r2 = 8388659(0x800033, float:1.1755015E-38)
            r1.setCollapsedTextGravity(r2)
            int[] r3 = com.google.android.material.R.styleable.TextInputLayout
            r1 = 5
            int[] r15 = new int[r1]
            int r2 = com.google.android.material.R.styleable.TextInputLayout_counterTextAppearance
            r1 = 0
            r15[r1] = r2
            int r1 = com.google.android.material.R.styleable.TextInputLayout_counterOverflowTextAppearance
            r16 = 1
            r15[r16] = r1
            int r11 = com.google.android.material.R.styleable.TextInputLayout_errorTextAppearance
            r22 = r10
            r10 = 2
            r15[r10] = r11
            int r10 = com.google.android.material.R.styleable.TextInputLayout_helperTextTextAppearance
            r23 = r14
            r14 = 3
            r15[r14] = r10
            int r14 = com.google.android.material.R.styleable.TextInputLayout_hintTextAppearance
            r24 = 4
            r15[r24] = r14
            r25 = r1
            r1 = r13
            r27 = r2
            r26 = r17
            r2 = r34
            r28 = r20
            r29 = r4
            r4 = r35
            r30 = r5
            r5 = r9
            r31 = r6
            r6 = r15
            androidx.appcompat.widget.TintTypedArray r1 = com.google.android.material.internal.ThemeEnforcement.obtainTintedStyledAttributes(r1, r2, r3, r4, r5, r6)
            int r2 = com.google.android.material.R.styleable.TextInputLayout_hintEnabled
            r3 = 1
            boolean r2 = r1.getBoolean(r2, r3)
            r0.hintEnabled = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_android_hint
            java.lang.CharSequence r2 = r1.getText(r2)
            r0.setHint((java.lang.CharSequence) r2)
            int r2 = com.google.android.material.R.styleable.TextInputLayout_hintAnimationEnabled
            boolean r2 = r1.getBoolean(r2, r3)
            r0.hintAnimationEnabled = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_expandedHintEnabled
            boolean r2 = r1.getBoolean(r2, r3)
            r0.expandedHintEnabled = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_android_minEms
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x0172
            r3 = -1
            int r2 = r1.getInt(r2, r3)
            r0.setMinEms(r2)
            goto L_0x0182
        L_0x0172:
            r3 = -1
            int r2 = com.google.android.material.R.styleable.TextInputLayout_android_minWidth
            boolean r4 = r1.hasValue(r2)
            if (r4 == 0) goto L_0x0182
            int r2 = r1.getDimensionPixelSize(r2, r3)
            r0.setMinWidth(r2)
        L_0x0182:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_android_maxEms
            boolean r4 = r1.hasValue(r2)
            if (r4 == 0) goto L_0x0192
            int r2 = r1.getInt(r2, r3)
            r0.setMaxEms(r2)
            goto L_0x01a1
        L_0x0192:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_android_maxWidth
            boolean r4 = r1.hasValue(r2)
            if (r4 == 0) goto L_0x01a1
            int r2 = r1.getDimensionPixelSize(r2, r3)
            r0.setMaxWidth(r2)
        L_0x01a1:
            com.google.android.material.shape.ShapeAppearanceModel$Builder r2 = com.google.android.material.shape.ShapeAppearanceModel.builder((android.content.Context) r13, (android.util.AttributeSet) r7, (int) r8, (int) r9)
            com.google.android.material.shape.ShapeAppearanceModel r2 = r2.build()
            r0.shapeAppearanceModel = r2
            android.content.res.Resources r2 = r13.getResources()
            int r3 = com.google.android.material.R.dimen.mtrl_textinput_box_label_cutout_padding
            int r2 = r2.getDimensionPixelOffset(r3)
            r0.boxLabelCutoutPaddingPx = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_boxCollapsedPaddingTop
            r3 = 0
            int r2 = r1.getDimensionPixelOffset(r2, r3)
            r0.boxCollapsedPaddingTopPx = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_boxStrokeWidth
            android.content.res.Resources r3 = r13.getResources()
            int r4 = com.google.android.material.R.dimen.mtrl_textinput_box_stroke_width_default
            int r3 = r3.getDimensionPixelSize(r4)
            int r2 = r1.getDimensionPixelSize(r2, r3)
            r0.boxStrokeWidthDefaultPx = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_boxStrokeWidthFocused
            android.content.res.Resources r3 = r13.getResources()
            int r4 = com.google.android.material.R.dimen.mtrl_textinput_box_stroke_width_focused
            int r3 = r3.getDimensionPixelSize(r4)
            int r2 = r1.getDimensionPixelSize(r2, r3)
            r0.boxStrokeWidthFocusedPx = r2
            int r2 = r0.boxStrokeWidthDefaultPx
            r0.boxStrokeWidthPx = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_boxCornerRadiusTopStart
            r3 = -1082130432(0xffffffffbf800000, float:-1.0)
            float r2 = r1.getDimension(r2, r3)
            int r4 = com.google.android.material.R.styleable.TextInputLayout_boxCornerRadiusTopEnd
            float r4 = r1.getDimension(r4, r3)
            int r5 = com.google.android.material.R.styleable.TextInputLayout_boxCornerRadiusBottomEnd
            float r5 = r1.getDimension(r5, r3)
            int r6 = com.google.android.material.R.styleable.TextInputLayout_boxCornerRadiusBottomStart
            float r3 = r1.getDimension(r6, r3)
            com.google.android.material.shape.ShapeAppearanceModel r6 = r0.shapeAppearanceModel
            com.google.android.material.shape.ShapeAppearanceModel$Builder r6 = r6.toBuilder()
            r7 = 0
            int r8 = (r2 > r7 ? 1 : (r2 == r7 ? 0 : -1))
            if (r8 < 0) goto L_0x0210
            r6.setTopLeftCornerSize((float) r2)
        L_0x0210:
            int r2 = (r4 > r7 ? 1 : (r4 == r7 ? 0 : -1))
            if (r2 < 0) goto L_0x0217
            r6.setTopRightCornerSize((float) r4)
        L_0x0217:
            int r2 = (r5 > r7 ? 1 : (r5 == r7 ? 0 : -1))
            if (r2 < 0) goto L_0x021e
            r6.setBottomRightCornerSize((float) r5)
        L_0x021e:
            int r2 = (r3 > r7 ? 1 : (r3 == r7 ? 0 : -1))
            if (r2 < 0) goto L_0x0225
            r6.setBottomLeftCornerSize((float) r3)
        L_0x0225:
            com.google.android.material.shape.ShapeAppearanceModel r2 = r6.build()
            r0.shapeAppearanceModel = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_boxBackgroundColor
            android.content.res.ColorStateList r2 = com.google.android.material.resources.MaterialResources.getColorStateList((android.content.Context) r13, (androidx.appcompat.widget.TintTypedArray) r1, (int) r2)
            if (r2 == 0) goto L_0x028e
            int r3 = r2.getDefaultColor()
            r0.defaultFilledBackgroundColor = r3
            r0.boxBackgroundColor = r3
            boolean r3 = r2.isStateful()
            r4 = -16842910(0xfffffffffefeff62, float:-1.6947497E38)
            if (r3 == 0) goto L_0x0269
            r3 = 1
            int[] r5 = new int[r3]
            r3 = 0
            r5[r3] = r4
            r3 = -1
            int r4 = r2.getColorForState(r5, r3)
            r0.disabledFilledBackgroundColor = r4
            r4 = 2
            int[] r5 = new int[r4]
            r5 = {16842908, 16842910} // fill-array
            int r5 = r2.getColorForState(r5, r3)
            r0.focusedFilledBackgroundColor = r5
            int[] r5 = new int[r4]
            r5 = {16843623, 16842910} // fill-array
            int r2 = r2.getColorForState(r5, r3)
            r0.hoveredFilledBackgroundColor = r2
            goto L_0x0299
        L_0x0269:
            r3 = -1
            int r2 = r0.defaultFilledBackgroundColor
            r0.focusedFilledBackgroundColor = r2
            int r2 = com.google.android.material.R.color.mtrl_filled_background_color
            android.content.res.ColorStateList r2 = androidx.appcompat.content.res.AppCompatResources.getColorStateList(r13, r2)
            r5 = 1
            int[] r6 = new int[r5]
            r7 = 0
            r6[r7] = r4
            int r4 = r2.getColorForState(r6, r3)
            r0.disabledFilledBackgroundColor = r4
            int[] r4 = new int[r5]
            r5 = 16843623(0x1010367, float:2.3696E-38)
            r4[r7] = r5
            int r2 = r2.getColorForState(r4, r3)
            r0.hoveredFilledBackgroundColor = r2
            goto L_0x0299
        L_0x028e:
            r7 = 0
            r0.boxBackgroundColor = r7
            r0.defaultFilledBackgroundColor = r7
            r0.disabledFilledBackgroundColor = r7
            r0.focusedFilledBackgroundColor = r7
            r0.hoveredFilledBackgroundColor = r7
        L_0x0299:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_android_textColorHint
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x02a9
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.focusedTextColor = r2
            r0.defaultHintTextColor = r2
        L_0x02a9:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_boxStrokeColor
            android.content.res.ColorStateList r3 = com.google.android.material.resources.MaterialResources.getColorStateList((android.content.Context) r13, (androidx.appcompat.widget.TintTypedArray) r1, (int) r2)
            r4 = 0
            int r2 = r1.getColor(r2, r4)
            r0.focusedStrokeColor = r2
            int r2 = com.google.android.material.R.color.mtrl_textinput_default_box_stroke_color
            int r2 = androidx.core.content.ContextCompat.getColor(r13, r2)
            r0.defaultStrokeColor = r2
            int r2 = com.google.android.material.R.color.mtrl_textinput_disabled_color
            int r2 = androidx.core.content.ContextCompat.getColor(r13, r2)
            r0.disabledColor = r2
            int r2 = com.google.android.material.R.color.mtrl_textinput_hovered_box_stroke_color
            int r2 = androidx.core.content.ContextCompat.getColor(r13, r2)
            r0.hoveredStrokeColor = r2
            if (r3 == 0) goto L_0x02d3
            r0.setBoxStrokeColorStateList(r3)
        L_0x02d3:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_boxStrokeErrorColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x02e2
            android.content.res.ColorStateList r2 = com.google.android.material.resources.MaterialResources.getColorStateList((android.content.Context) r13, (androidx.appcompat.widget.TintTypedArray) r1, (int) r2)
            r0.setBoxStrokeErrorColor(r2)
        L_0x02e2:
            r2 = -1
            int r3 = r1.getResourceId(r14, r2)
            if (r3 == r2) goto L_0x02f2
            r2 = 0
            int r3 = r1.getResourceId(r14, r2)
            r0.setHintTextAppearance(r3)
            goto L_0x02f3
        L_0x02f2:
            r2 = 0
        L_0x02f3:
            int r3 = r1.getResourceId(r11, r2)
            int r4 = com.google.android.material.R.styleable.TextInputLayout_errorContentDescription
            java.lang.CharSequence r4 = r1.getText(r4)
            int r5 = com.google.android.material.R.styleable.TextInputLayout_errorEnabled
            boolean r5 = r1.getBoolean(r5, r2)
            int r6 = com.google.android.material.R.id.text_input_error_icon
            r12.setId(r6)
            boolean r6 = com.google.android.material.resources.MaterialResources.isFontScaleAtLeast1_3(r13)
            if (r6 == 0) goto L_0x0317
            android.view.ViewGroup$LayoutParams r6 = r12.getLayoutParams()
            android.view.ViewGroup$MarginLayoutParams r6 = (android.view.ViewGroup.MarginLayoutParams) r6
            androidx.core.view.MarginLayoutParamsCompat.setMarginStart(r6, r2)
        L_0x0317:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_errorIconTint
            boolean r6 = r1.hasValue(r2)
            if (r6 == 0) goto L_0x0325
            android.content.res.ColorStateList r2 = com.google.android.material.resources.MaterialResources.getColorStateList((android.content.Context) r13, (androidx.appcompat.widget.TintTypedArray) r1, (int) r2)
            r0.errorIconTintList = r2
        L_0x0325:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_errorIconTintMode
            boolean r6 = r1.hasValue(r2)
            r7 = 0
            if (r6 == 0) goto L_0x0339
            r6 = -1
            int r2 = r1.getInt(r2, r6)
            android.graphics.PorterDuff$Mode r2 = com.google.android.material.internal.ViewUtils.parseTintMode(r2, r7)
            r0.errorIconTintMode = r2
        L_0x0339:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_errorIconDrawable
            boolean r6 = r1.hasValue(r2)
            if (r6 == 0) goto L_0x0348
            android.graphics.drawable.Drawable r2 = r1.getDrawable(r2)
            r0.setErrorIconDrawable((android.graphics.drawable.Drawable) r2)
        L_0x0348:
            android.content.res.Resources r2 = r32.getResources()
            int r6 = com.google.android.material.R.string.error_icon_content_description
            java.lang.CharSequence r2 = r2.getText(r6)
            r12.setContentDescription(r2)
            r2 = 2
            androidx.core.view.ViewCompat.setImportantForAccessibility(r12, r2)
            r2 = 0
            r12.setClickable(r2)
            r12.setPressable(r2)
            r12.setFocusable(r2)
            int r6 = r1.getResourceId(r10, r2)
            int r8 = com.google.android.material.R.styleable.TextInputLayout_helperTextEnabled
            boolean r8 = r1.getBoolean(r8, r2)
            int r9 = com.google.android.material.R.styleable.TextInputLayout_helperText
            java.lang.CharSequence r9 = r1.getText(r9)
            int r10 = com.google.android.material.R.styleable.TextInputLayout_placeholderTextAppearance
            int r10 = r1.getResourceId(r10, r2)
            int r11 = com.google.android.material.R.styleable.TextInputLayout_placeholderText
            java.lang.CharSequence r11 = r1.getText(r11)
            int r14 = com.google.android.material.R.styleable.TextInputLayout_prefixTextAppearance
            int r14 = r1.getResourceId(r14, r2)
            int r15 = com.google.android.material.R.styleable.TextInputLayout_prefixText
            java.lang.CharSequence r15 = r1.getText(r15)
            int r7 = com.google.android.material.R.styleable.TextInputLayout_suffixTextAppearance
            int r7 = r1.getResourceId(r7, r2)
            int r2 = com.google.android.material.R.styleable.TextInputLayout_suffixText
            java.lang.CharSequence r2 = r1.getText(r2)
            r35 = r2
            int r2 = com.google.android.material.R.styleable.TextInputLayout_counterEnabled
            r17 = r15
            r15 = 0
            boolean r2 = r1.getBoolean(r2, r15)
            int r15 = com.google.android.material.R.styleable.TextInputLayout_counterMaxLength
            r20 = r9
            r9 = -1
            int r15 = r1.getInt(r15, r9)
            r0.setCounterMaxLength(r15)
            r9 = r27
            r15 = 0
            int r9 = r1.getResourceId(r9, r15)
            r0.counterTextAppearance = r9
            r9 = r25
            int r9 = r1.getResourceId(r9, r15)
            r0.counterOverflowTextAppearance = r9
            boolean r9 = com.google.android.material.resources.MaterialResources.isFontScaleAtLeast1_3(r13)
            if (r9 == 0) goto L_0x03ce
            android.view.ViewGroup$LayoutParams r9 = r23.getLayoutParams()
            android.view.ViewGroup$MarginLayoutParams r9 = (android.view.ViewGroup.MarginLayoutParams) r9
            androidx.core.view.MarginLayoutParamsCompat.setMarginEnd(r9, r15)
        L_0x03ce:
            r9 = 0
            r0.setStartIconOnClickListener(r9)
            r0.setStartIconOnLongClickListener(r9)
            int r9 = com.google.android.material.R.styleable.TextInputLayout_startIconTint
            boolean r15 = r1.hasValue(r9)
            if (r15 == 0) goto L_0x03e3
            android.content.res.ColorStateList r9 = com.google.android.material.resources.MaterialResources.getColorStateList((android.content.Context) r13, (androidx.appcompat.widget.TintTypedArray) r1, (int) r9)
            r0.startIconTintList = r9
        L_0x03e3:
            int r9 = com.google.android.material.R.styleable.TextInputLayout_startIconTintMode
            boolean r15 = r1.hasValue(r9)
            if (r15 == 0) goto L_0x03f7
            r15 = -1
            int r9 = r1.getInt(r9, r15)
            r15 = 0
            android.graphics.PorterDuff$Mode r9 = com.google.android.material.internal.ViewUtils.parseTintMode(r9, r15)
            r0.startIconTintMode = r9
        L_0x03f7:
            int r9 = com.google.android.material.R.styleable.TextInputLayout_startIconDrawable
            boolean r15 = r1.hasValue(r9)
            if (r15 == 0) goto L_0x041f
            android.graphics.drawable.Drawable r9 = r1.getDrawable(r9)
            r0.setStartIconDrawable((android.graphics.drawable.Drawable) r9)
            int r9 = com.google.android.material.R.styleable.TextInputLayout_startIconContentDescription
            boolean r15 = r1.hasValue(r9)
            if (r15 == 0) goto L_0x0415
            java.lang.CharSequence r9 = r1.getText(r9)
            r0.setStartIconContentDescription((java.lang.CharSequence) r9)
        L_0x0415:
            int r9 = com.google.android.material.R.styleable.TextInputLayout_startIconCheckable
            r15 = 1
            boolean r9 = r1.getBoolean(r9, r15)
            r0.setStartIconCheckable(r9)
        L_0x041f:
            int r9 = com.google.android.material.R.styleable.TextInputLayout_boxBackgroundMode
            r15 = 0
            int r9 = r1.getInt(r9, r15)
            r0.setBoxBackgroundMode(r9)
            boolean r9 = com.google.android.material.resources.MaterialResources.isFontScaleAtLeast1_3(r13)
            if (r9 == 0) goto L_0x0438
            android.view.ViewGroup$LayoutParams r9 = r22.getLayoutParams()
            android.view.ViewGroup$MarginLayoutParams r9 = (android.view.ViewGroup.MarginLayoutParams) r9
            androidx.core.view.MarginLayoutParamsCompat.setMarginStart(r9, r15)
        L_0x0438:
            int r9 = com.google.android.material.R.styleable.TextInputLayout_endIconDrawable
            int r9 = r1.getResourceId(r9, r15)
            com.google.android.material.textfield.CustomEndIconDelegate r15 = new com.google.android.material.textfield.CustomEndIconDelegate
            r15.<init>(r0, r9)
            r24 = r2
            r2 = r19
            r19 = r5
            r5 = -1
            r2.append(r5, r15)
            com.google.android.material.textfield.NoEndIconDelegate r5 = new com.google.android.material.textfield.NoEndIconDelegate
            r5.<init>(r0)
            r15 = 0
            r2.append(r15, r5)
            com.google.android.material.textfield.PasswordToggleEndIconDelegate r5 = new com.google.android.material.textfield.PasswordToggleEndIconDelegate
            if (r9 != 0) goto L_0x0463
            r25 = r8
            int r8 = com.google.android.material.R.styleable.TextInputLayout_passwordToggleDrawable
            int r8 = r1.getResourceId(r8, r15)
            goto L_0x0466
        L_0x0463:
            r25 = r8
            r8 = r9
        L_0x0466:
            r5.<init>(r0, r8)
            r8 = 1
            r2.append(r8, r5)
            com.google.android.material.textfield.ClearTextEndIconDelegate r5 = new com.google.android.material.textfield.ClearTextEndIconDelegate
            r5.<init>(r0, r9)
            r8 = 2
            r2.append(r8, r5)
            com.google.android.material.textfield.DropdownMenuEndIconDelegate r5 = new com.google.android.material.textfield.DropdownMenuEndIconDelegate
            r5.<init>(r0, r9)
            r8 = 3
            r2.append(r8, r5)
            int r2 = com.google.android.material.R.styleable.TextInputLayout_passwordToggleEnabled
            boolean r5 = r1.hasValue(r2)
            if (r5 != 0) goto L_0x04a9
            int r5 = com.google.android.material.R.styleable.TextInputLayout_endIconTint
            boolean r8 = r1.hasValue(r5)
            if (r8 == 0) goto L_0x0495
            android.content.res.ColorStateList r5 = com.google.android.material.resources.MaterialResources.getColorStateList((android.content.Context) r13, (androidx.appcompat.widget.TintTypedArray) r1, (int) r5)
            r0.endIconTintList = r5
        L_0x0495:
            int r5 = com.google.android.material.R.styleable.TextInputLayout_endIconTintMode
            boolean r8 = r1.hasValue(r5)
            if (r8 == 0) goto L_0x04a9
            r8 = -1
            int r5 = r1.getInt(r5, r8)
            r8 = 0
            android.graphics.PorterDuff$Mode r5 = com.google.android.material.internal.ViewUtils.parseTintMode(r5, r8)
            r0.endIconTintMode = r5
        L_0x04a9:
            int r5 = com.google.android.material.R.styleable.TextInputLayout_endIconMode
            boolean r8 = r1.hasValue(r5)
            if (r8 == 0) goto L_0x04d3
            r8 = 0
            int r2 = r1.getInt(r5, r8)
            r0.setEndIconMode(r2)
            int r2 = com.google.android.material.R.styleable.TextInputLayout_endIconContentDescription
            boolean r5 = r1.hasValue(r2)
            if (r5 == 0) goto L_0x04c8
            java.lang.CharSequence r2 = r1.getText(r2)
            r0.setEndIconContentDescription((java.lang.CharSequence) r2)
        L_0x04c8:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_endIconCheckable
            r5 = 1
            boolean r2 = r1.getBoolean(r2, r5)
            r0.setEndIconCheckable(r2)
            goto L_0x050c
        L_0x04d3:
            boolean r5 = r1.hasValue(r2)
            if (r5 == 0) goto L_0x050c
            int r5 = com.google.android.material.R.styleable.TextInputLayout_passwordToggleTint
            boolean r8 = r1.hasValue(r5)
            if (r8 == 0) goto L_0x04e7
            android.content.res.ColorStateList r5 = com.google.android.material.resources.MaterialResources.getColorStateList((android.content.Context) r13, (androidx.appcompat.widget.TintTypedArray) r1, (int) r5)
            r0.endIconTintList = r5
        L_0x04e7:
            int r5 = com.google.android.material.R.styleable.TextInputLayout_passwordToggleTintMode
            boolean r8 = r1.hasValue(r5)
            if (r8 == 0) goto L_0x04fb
            r8 = -1
            int r5 = r1.getInt(r5, r8)
            r8 = 0
            android.graphics.PorterDuff$Mode r5 = com.google.android.material.internal.ViewUtils.parseTintMode(r5, r8)
            r0.endIconTintMode = r5
        L_0x04fb:
            r5 = 0
            boolean r2 = r1.getBoolean(r2, r5)
            r0.setEndIconMode(r2)
            int r2 = com.google.android.material.R.styleable.TextInputLayout_passwordToggleContentDescription
            java.lang.CharSequence r2 = r1.getText(r2)
            r0.setEndIconContentDescription((java.lang.CharSequence) r2)
        L_0x050c:
            int r2 = com.google.android.material.R.id.textinput_prefix_text
            r5 = r28
            r5.setId(r2)
            android.widget.FrameLayout$LayoutParams r2 = new android.widget.FrameLayout$LayoutParams
            r8 = -2
            r2.<init>(r8, r8)
            r5.setLayoutParams(r2)
            r2 = 1
            androidx.core.view.ViewCompat.setAccessibilityLiveRegion(r5, r2)
            int r9 = com.google.android.material.R.id.textinput_suffix_text
            r13 = r26
            r13.setId(r9)
            android.widget.FrameLayout$LayoutParams r9 = new android.widget.FrameLayout$LayoutParams
            r15 = 80
            r9.<init>(r8, r8, r15)
            r13.setLayoutParams(r9)
            androidx.core.view.ViewCompat.setAccessibilityLiveRegion(r13, r2)
            r0.setErrorContentDescription(r4)
            int r2 = r0.counterOverflowTextAppearance
            r0.setCounterOverflowTextAppearance(r2)
            r0.setHelperTextTextAppearance(r6)
            r0.setErrorTextAppearance(r3)
            int r2 = r0.counterTextAppearance
            r0.setCounterTextAppearance(r2)
            r0.setPlaceholderText(r11)
            r0.setPlaceholderTextAppearance(r10)
            r0.setPrefixTextAppearance(r14)
            r0.setSuffixTextAppearance(r7)
            int r2 = com.google.android.material.R.styleable.TextInputLayout_errorTextColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x0562
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.setErrorTextColor(r2)
        L_0x0562:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_helperTextTextColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x0571
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.setHelperTextColor(r2)
        L_0x0571:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_hintTextColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x0580
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.setHintTextColor(r2)
        L_0x0580:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_counterTextColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x058f
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.setCounterTextColor(r2)
        L_0x058f:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_counterOverflowTextColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x059e
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.setCounterOverflowTextColor(r2)
        L_0x059e:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_placeholderTextColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x05ad
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.setPlaceholderTextColor(r2)
        L_0x05ad:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_prefixTextColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x05bc
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.setPrefixTextColor(r2)
        L_0x05bc:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_suffixTextColor
            boolean r3 = r1.hasValue(r2)
            if (r3 == 0) goto L_0x05cb
            android.content.res.ColorStateList r2 = r1.getColorStateList(r2)
            r0.setSuffixTextColor(r2)
        L_0x05cb:
            int r2 = com.google.android.material.R.styleable.TextInputLayout_android_enabled
            r3 = 1
            boolean r2 = r1.getBoolean(r2, r3)
            r0.setEnabled(r2)
            r1.recycle()
            r1 = 2
            androidx.core.view.ViewCompat.setImportantForAccessibility(r0, r1)
            androidx.core.view.ViewCompat.setImportantForAutofill(r0, r3)
            r14 = r23
            r1 = r30
            r1.addView(r14)
            r1.addView(r5)
            r3 = r22
            r2 = r31
            r2.addView(r3)
            r3 = r29
            r3.addView(r13)
            r3.addView(r12)
            r3.addView(r2)
            r2 = r21
            r2.addView(r1)
            r2.addView(r3)
            r0.addView(r2)
            r1 = r25
            r0.setHelperTextEnabled(r1)
            r1 = r19
            r0.setErrorEnabled(r1)
            r1 = r24
            r0.setCounterEnabled(r1)
            r1 = r20
            r0.setHelperText(r1)
            r1 = r17
            r0.setPrefixText(r1)
            r1 = r35
            r0.setSuffixText(r1)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.textfield.TextInputLayout.<init>(android.content.Context, android.util.AttributeSet, int):void");
    }

    public void addView(@NonNull View view, int i, @NonNull ViewGroup.LayoutParams layoutParams) {
        if (view instanceof EditText) {
            FrameLayout.LayoutParams layoutParams2 = new FrameLayout.LayoutParams(layoutParams);
            layoutParams2.gravity = (layoutParams2.gravity & -113) | 16;
            this.inputFrame.addView(view, layoutParams2);
            this.inputFrame.setLayoutParams(layoutParams);
            updateInputLayoutMargins();
            setEditText((EditText) view);
            return;
        }
        super.addView(view, i, layoutParams);
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public MaterialShapeDrawable getBoxBackground() {
        int i = this.boxBackgroundMode;
        if (i == 1 || i == 2) {
            return this.boxBackground;
        }
        throw new IllegalStateException();
    }

    public void setBoxBackgroundMode(int i) {
        if (i != this.boxBackgroundMode) {
            this.boxBackgroundMode = i;
            if (this.editText != null) {
                onApplyBoxBackgroundMode();
            }
        }
    }

    public int getBoxBackgroundMode() {
        return this.boxBackgroundMode;
    }

    private void onApplyBoxBackgroundMode() {
        assignBoxBackgroundByMode();
        setEditTextBoxBackground();
        updateTextInputBoxState();
        updateBoxCollapsedPaddingTop();
        adjustFilledEditTextPaddingForLargeFont();
        if (this.boxBackgroundMode != 0) {
            updateInputLayoutMargins();
        }
    }

    private void assignBoxBackgroundByMode() {
        int i = this.boxBackgroundMode;
        if (i == 0) {
            this.boxBackground = null;
            this.boxUnderlineDefault = null;
            this.boxUnderlineFocused = null;
        } else if (i == 1) {
            this.boxBackground = new MaterialShapeDrawable(this.shapeAppearanceModel);
            this.boxUnderlineDefault = new MaterialShapeDrawable();
            this.boxUnderlineFocused = new MaterialShapeDrawable();
        } else if (i == 2) {
            if (!this.hintEnabled || (this.boxBackground instanceof CutoutDrawable)) {
                this.boxBackground = new MaterialShapeDrawable(this.shapeAppearanceModel);
            } else {
                this.boxBackground = new CutoutDrawable(this.shapeAppearanceModel);
            }
            this.boxUnderlineDefault = null;
            this.boxUnderlineFocused = null;
        } else {
            throw new IllegalArgumentException(this.boxBackgroundMode + " is illegal; only @BoxBackgroundMode constants are supported.");
        }
    }

    private void setEditTextBoxBackground() {
        if (shouldUseEditTextBackgroundForBoxBackground()) {
            ViewCompat.setBackground(this.editText, this.boxBackground);
        }
    }

    private boolean shouldUseEditTextBackgroundForBoxBackground() {
        EditText editText2 = this.editText;
        return (editText2 == null || this.boxBackground == null || editText2.getBackground() != null || this.boxBackgroundMode == 0) ? false : true;
    }

    private void updateBoxCollapsedPaddingTop() {
        if (this.boxBackgroundMode != 1) {
            return;
        }
        if (MaterialResources.isFontScaleAtLeast2_0(getContext())) {
            this.boxCollapsedPaddingTopPx = getResources().getDimensionPixelSize(R.dimen.material_font_2_0_box_collapsed_padding_top);
        } else if (MaterialResources.isFontScaleAtLeast1_3(getContext())) {
            this.boxCollapsedPaddingTopPx = getResources().getDimensionPixelSize(R.dimen.material_font_1_3_box_collapsed_padding_top);
        }
    }

    private void adjustFilledEditTextPaddingForLargeFont() {
        if (this.editText != null && this.boxBackgroundMode == 1) {
            if (MaterialResources.isFontScaleAtLeast2_0(getContext())) {
                EditText editText2 = this.editText;
                ViewCompat.setPaddingRelative(editText2, ViewCompat.getPaddingStart(editText2), getResources().getDimensionPixelSize(R.dimen.material_filled_edittext_font_2_0_padding_top), ViewCompat.getPaddingEnd(this.editText), getResources().getDimensionPixelSize(R.dimen.material_filled_edittext_font_2_0_padding_bottom));
            } else if (MaterialResources.isFontScaleAtLeast1_3(getContext())) {
                EditText editText3 = this.editText;
                ViewCompat.setPaddingRelative(editText3, ViewCompat.getPaddingStart(editText3), getResources().getDimensionPixelSize(R.dimen.material_filled_edittext_font_1_3_padding_top), ViewCompat.getPaddingEnd(this.editText), getResources().getDimensionPixelSize(R.dimen.material_filled_edittext_font_1_3_padding_bottom));
            }
        }
    }

    public void setBoxCollapsedPaddingTop(int i) {
        this.boxCollapsedPaddingTopPx = i;
    }

    public int getBoxCollapsedPaddingTop() {
        return this.boxCollapsedPaddingTopPx;
    }

    public void setBoxStrokeWidthResource(@DimenRes int i) {
        setBoxStrokeWidth(getResources().getDimensionPixelSize(i));
    }

    public void setBoxStrokeWidth(int i) {
        this.boxStrokeWidthDefaultPx = i;
        updateTextInputBoxState();
    }

    public int getBoxStrokeWidth() {
        return this.boxStrokeWidthDefaultPx;
    }

    public void setBoxStrokeWidthFocusedResource(@DimenRes int i) {
        setBoxStrokeWidthFocused(getResources().getDimensionPixelSize(i));
    }

    public void setBoxStrokeWidthFocused(int i) {
        this.boxStrokeWidthFocusedPx = i;
        updateTextInputBoxState();
    }

    public int getBoxStrokeWidthFocused() {
        return this.boxStrokeWidthFocusedPx;
    }

    public void setBoxStrokeColor(@ColorInt int i) {
        if (this.focusedStrokeColor != i) {
            this.focusedStrokeColor = i;
            updateTextInputBoxState();
        }
    }

    public int getBoxStrokeColor() {
        return this.focusedStrokeColor;
    }

    public void setBoxStrokeColorStateList(@NonNull ColorStateList colorStateList) {
        if (colorStateList.isStateful()) {
            this.defaultStrokeColor = colorStateList.getDefaultColor();
            this.disabledColor = colorStateList.getColorForState(new int[]{-16842910}, -1);
            this.hoveredStrokeColor = colorStateList.getColorForState(new int[]{16843623, 16842910}, -1);
            this.focusedStrokeColor = colorStateList.getColorForState(new int[]{16842908, 16842910}, -1);
        } else if (this.focusedStrokeColor != colorStateList.getDefaultColor()) {
            this.focusedStrokeColor = colorStateList.getDefaultColor();
        }
        updateTextInputBoxState();
    }

    public void setBoxStrokeErrorColor(@Nullable ColorStateList colorStateList) {
        if (this.strokeErrorColor != colorStateList) {
            this.strokeErrorColor = colorStateList;
            updateTextInputBoxState();
        }
    }

    @Nullable
    public ColorStateList getBoxStrokeErrorColor() {
        return this.strokeErrorColor;
    }

    public void setBoxBackgroundColorResource(@ColorRes int i) {
        setBoxBackgroundColor(ContextCompat.getColor(getContext(), i));
    }

    public void setBoxBackgroundColor(@ColorInt int i) {
        if (this.boxBackgroundColor != i) {
            this.boxBackgroundColor = i;
            this.defaultFilledBackgroundColor = i;
            this.focusedFilledBackgroundColor = i;
            this.hoveredFilledBackgroundColor = i;
            applyBoxAttributes();
        }
    }

    public void setBoxBackgroundColorStateList(@NonNull ColorStateList colorStateList) {
        int defaultColor = colorStateList.getDefaultColor();
        this.defaultFilledBackgroundColor = defaultColor;
        this.boxBackgroundColor = defaultColor;
        this.disabledFilledBackgroundColor = colorStateList.getColorForState(new int[]{-16842910}, -1);
        this.focusedFilledBackgroundColor = colorStateList.getColorForState(new int[]{16842908, 16842910}, -1);
        this.hoveredFilledBackgroundColor = colorStateList.getColorForState(new int[]{16843623, 16842910}, -1);
        applyBoxAttributes();
    }

    public int getBoxBackgroundColor() {
        return this.boxBackgroundColor;
    }

    public void setBoxCornerRadiiResources(@DimenRes int i, @DimenRes int i2, @DimenRes int i3, @DimenRes int i4) {
        setBoxCornerRadii(getContext().getResources().getDimension(i), getContext().getResources().getDimension(i2), getContext().getResources().getDimension(i4), getContext().getResources().getDimension(i3));
    }

    public void setBoxCornerRadii(float f, float f2, float f3, float f4) {
        boolean isLayoutRtl = ViewUtils.isLayoutRtl(this);
        this.areCornerRadiiRtl = isLayoutRtl;
        float f5 = isLayoutRtl ? f2 : f;
        if (!isLayoutRtl) {
            f = f2;
        }
        float f6 = isLayoutRtl ? f4 : f3;
        if (!isLayoutRtl) {
            f3 = f4;
        }
        MaterialShapeDrawable materialShapeDrawable = this.boxBackground;
        if (materialShapeDrawable == null || materialShapeDrawable.getTopLeftCornerResolvedSize() != f5 || this.boxBackground.getTopRightCornerResolvedSize() != f || this.boxBackground.getBottomLeftCornerResolvedSize() != f6 || this.boxBackground.getBottomRightCornerResolvedSize() != f3) {
            this.shapeAppearanceModel = this.shapeAppearanceModel.toBuilder().setTopLeftCornerSize(f5).setTopRightCornerSize(f).setBottomLeftCornerSize(f6).setBottomRightCornerSize(f3).build();
            applyBoxAttributes();
        }
    }

    public float getBoxCornerRadiusTopStart() {
        if (ViewUtils.isLayoutRtl(this)) {
            return this.shapeAppearanceModel.getTopRightCornerSize().getCornerSize(this.tmpRectF);
        }
        return this.shapeAppearanceModel.getTopLeftCornerSize().getCornerSize(this.tmpRectF);
    }

    public float getBoxCornerRadiusTopEnd() {
        if (ViewUtils.isLayoutRtl(this)) {
            return this.shapeAppearanceModel.getTopLeftCornerSize().getCornerSize(this.tmpRectF);
        }
        return this.shapeAppearanceModel.getTopRightCornerSize().getCornerSize(this.tmpRectF);
    }

    public float getBoxCornerRadiusBottomEnd() {
        if (ViewUtils.isLayoutRtl(this)) {
            return this.shapeAppearanceModel.getBottomLeftCornerSize().getCornerSize(this.tmpRectF);
        }
        return this.shapeAppearanceModel.getBottomRightCornerSize().getCornerSize(this.tmpRectF);
    }

    public float getBoxCornerRadiusBottomStart() {
        if (ViewUtils.isLayoutRtl(this)) {
            return this.shapeAppearanceModel.getBottomRightCornerSize().getCornerSize(this.tmpRectF);
        }
        return this.shapeAppearanceModel.getBottomLeftCornerSize().getCornerSize(this.tmpRectF);
    }

    public void setTypeface(@Nullable Typeface typeface2) {
        if (typeface2 != this.typeface) {
            this.typeface = typeface2;
            this.collapsingTextHelper.setTypefaces(typeface2);
            this.indicatorViewController.setTypefaces(typeface2);
            TextView textView = this.counterView;
            if (textView != null) {
                textView.setTypeface(typeface2);
            }
        }
    }

    @Nullable
    public Typeface getTypeface() {
        return this.typeface;
    }

    @TargetApi(26)
    public void dispatchProvideAutofillStructure(@NonNull ViewStructure viewStructure, int i) {
        EditText editText2 = this.editText;
        if (editText2 == null) {
            super.dispatchProvideAutofillStructure(viewStructure, i);
            return;
        }
        if (this.originalHint != null) {
            boolean z = this.isProvidingHint;
            this.isProvidingHint = false;
            CharSequence hint2 = editText2.getHint();
            this.editText.setHint(this.originalHint);
            try {
                super.dispatchProvideAutofillStructure(viewStructure, i);
            } finally {
                this.editText.setHint(hint2);
                this.isProvidingHint = z;
            }
        } else {
            viewStructure.setAutofillId(getAutofillId());
            onProvideAutofillStructure(viewStructure, i);
            onProvideAutofillVirtualStructure(viewStructure, i);
            viewStructure.setChildCount(this.inputFrame.getChildCount());
            for (int i2 = 0; i2 < this.inputFrame.getChildCount(); i2++) {
                View childAt = this.inputFrame.getChildAt(i2);
                ViewStructure newChild = viewStructure.newChild(i2);
                childAt.dispatchProvideAutofillStructure(newChild, i);
                if (childAt == this.editText) {
                    newChild.setHint(getHint());
                }
            }
        }
    }

    private void setEditText(EditText editText2) {
        if (this.editText == null) {
            if (this.endIconMode != 3 && !(editText2 instanceof TextInputEditText)) {
                Log.i(LOG_TAG, "EditText added is not a TextInputEditText. Please switch to using that class instead.");
            }
            this.editText = editText2;
            int i = this.minEms;
            if (i != -1) {
                setMinEms(i);
            } else {
                setMinWidth(this.minWidth);
            }
            int i2 = this.maxEms;
            if (i2 != -1) {
                setMaxEms(i2);
            } else {
                setMaxWidth(this.maxWidth);
            }
            onApplyBoxBackgroundMode();
            setTextInputAccessibilityDelegate(new AccessibilityDelegate(this));
            this.collapsingTextHelper.setTypefaces(this.editText.getTypeface());
            this.collapsingTextHelper.setExpandedTextSize(this.editText.getTextSize());
            this.collapsingTextHelper.setExpandedLetterSpacing(this.editText.getLetterSpacing());
            int gravity = this.editText.getGravity();
            this.collapsingTextHelper.setCollapsedTextGravity((gravity & -113) | 48);
            this.collapsingTextHelper.setExpandedTextGravity(gravity);
            this.editText.addTextChangedListener(new TextWatcher() {
                public void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
                }

                public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
                }

                public void afterTextChanged(@NonNull Editable editable) {
                    TextInputLayout textInputLayout = TextInputLayout.this;
                    textInputLayout.updateLabelState(!textInputLayout.restoringSavedState);
                    TextInputLayout textInputLayout2 = TextInputLayout.this;
                    if (textInputLayout2.counterEnabled) {
                        textInputLayout2.updateCounter(editable.length());
                    }
                    if (TextInputLayout.this.placeholderEnabled) {
                        TextInputLayout.this.updatePlaceholderText(editable.length());
                    }
                }
            });
            if (this.defaultHintTextColor == null) {
                this.defaultHintTextColor = this.editText.getHintTextColors();
            }
            if (this.hintEnabled) {
                if (TextUtils.isEmpty(this.hint)) {
                    CharSequence hint2 = this.editText.getHint();
                    this.originalHint = hint2;
                    setHint(hint2);
                    this.editText.setHint((CharSequence) null);
                }
                this.isProvidingHint = true;
            }
            if (this.counterView != null) {
                updateCounter(this.editText.getText().length());
            }
            updateEditTextBackground();
            this.indicatorViewController.adjustIndicatorPadding();
            this.startLayout.bringToFront();
            this.endLayout.bringToFront();
            this.endIconFrame.bringToFront();
            this.errorIconView.bringToFront();
            dispatchOnEditTextAttached();
            updatePrefixTextViewPadding();
            updateSuffixTextViewPadding();
            if (!isEnabled()) {
                editText2.setEnabled(false);
            }
            updateLabelState(false, true);
            return;
        }
        throw new IllegalArgumentException("We already have an EditText, can only have one");
    }

    private void updateInputLayoutMargins() {
        if (this.boxBackgroundMode != 1) {
            LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) this.inputFrame.getLayoutParams();
            int calculateLabelMarginTop = calculateLabelMarginTop();
            if (calculateLabelMarginTop != layoutParams.topMargin) {
                layoutParams.topMargin = calculateLabelMarginTop;
                this.inputFrame.requestLayout();
            }
        }
    }

    public int getBaseline() {
        EditText editText2 = this.editText;
        if (editText2 != null) {
            return editText2.getBaseline() + getPaddingTop() + calculateLabelMarginTop();
        }
        return super.getBaseline();
    }

    /* access modifiers changed from: package-private */
    public void updateLabelState(boolean z) {
        updateLabelState(z, false);
    }

    private void updateLabelState(boolean z, boolean z2) {
        ColorStateList colorStateList;
        TextView textView;
        int i;
        boolean isEnabled = isEnabled();
        EditText editText2 = this.editText;
        boolean z3 = editText2 != null && !TextUtils.isEmpty(editText2.getText());
        EditText editText3 = this.editText;
        boolean z4 = editText3 != null && editText3.hasFocus();
        boolean errorShouldBeShown = this.indicatorViewController.errorShouldBeShown();
        ColorStateList colorStateList2 = this.defaultHintTextColor;
        if (colorStateList2 != null) {
            this.collapsingTextHelper.setCollapsedTextColor(colorStateList2);
            this.collapsingTextHelper.setExpandedTextColor(this.defaultHintTextColor);
        }
        if (!isEnabled) {
            ColorStateList colorStateList3 = this.defaultHintTextColor;
            if (colorStateList3 != null) {
                i = colorStateList3.getColorForState(new int[]{-16842910}, this.disabledColor);
            } else {
                i = this.disabledColor;
            }
            this.collapsingTextHelper.setCollapsedTextColor(ColorStateList.valueOf(i));
            this.collapsingTextHelper.setExpandedTextColor(ColorStateList.valueOf(i));
        } else if (errorShouldBeShown) {
            this.collapsingTextHelper.setCollapsedTextColor(this.indicatorViewController.getErrorViewTextColors());
        } else if (this.counterOverflowed && (textView = this.counterView) != null) {
            this.collapsingTextHelper.setCollapsedTextColor(textView.getTextColors());
        } else if (z4 && (colorStateList = this.focusedTextColor) != null) {
            this.collapsingTextHelper.setCollapsedTextColor(colorStateList);
        }
        if (z3 || !this.expandedHintEnabled || (isEnabled() && z4)) {
            if (z2 || this.hintExpanded) {
                collapseHint(z);
            }
        } else if (z2 || !this.hintExpanded) {
            expandHint(z);
        }
    }

    @Nullable
    public EditText getEditText() {
        return this.editText;
    }

    public void setMinEms(int i) {
        this.minEms = i;
        EditText editText2 = this.editText;
        if (editText2 != null && i != -1) {
            editText2.setMinEms(i);
        }
    }

    public int getMinEms() {
        return this.minEms;
    }

    public void setMaxEms(int i) {
        this.maxEms = i;
        EditText editText2 = this.editText;
        if (editText2 != null && i != -1) {
            editText2.setMaxEms(i);
        }
    }

    public int getMaxEms() {
        return this.maxEms;
    }

    public void setMinWidth(@Px int i) {
        this.minWidth = i;
        EditText editText2 = this.editText;
        if (editText2 != null && i != -1) {
            editText2.setMinWidth(i);
        }
    }

    public void setMinWidthResource(@DimenRes int i) {
        setMinWidth(getContext().getResources().getDimensionPixelSize(i));
    }

    @Px
    public int getMinWidth() {
        return this.minWidth;
    }

    public void setMaxWidth(@Px int i) {
        this.maxWidth = i;
        EditText editText2 = this.editText;
        if (editText2 != null && i != -1) {
            editText2.setMaxWidth(i);
        }
    }

    public void setMaxWidthResource(@DimenRes int i) {
        setMaxWidth(getContext().getResources().getDimensionPixelSize(i));
    }

    @Px
    public int getMaxWidth() {
        return this.maxWidth;
    }

    public void setHint(@Nullable CharSequence charSequence) {
        if (this.hintEnabled) {
            setHintInternal(charSequence);
            sendAccessibilityEvent(2048);
        }
    }

    public void setHint(@StringRes int i) {
        setHint(i != 0 ? getResources().getText(i) : null);
    }

    private void setHintInternal(CharSequence charSequence) {
        if (!TextUtils.equals(charSequence, this.hint)) {
            this.hint = charSequence;
            this.collapsingTextHelper.setText(charSequence);
            if (!this.hintExpanded) {
                openCutout();
            }
        }
    }

    @Nullable
    public CharSequence getHint() {
        if (this.hintEnabled) {
            return this.hint;
        }
        return null;
    }

    public void setHintEnabled(boolean z) {
        if (z != this.hintEnabled) {
            this.hintEnabled = z;
            if (!z) {
                this.isProvidingHint = false;
                if (!TextUtils.isEmpty(this.hint) && TextUtils.isEmpty(this.editText.getHint())) {
                    this.editText.setHint(this.hint);
                }
                setHintInternal((CharSequence) null);
            } else {
                CharSequence hint2 = this.editText.getHint();
                if (!TextUtils.isEmpty(hint2)) {
                    if (TextUtils.isEmpty(this.hint)) {
                        setHint(hint2);
                    }
                    this.editText.setHint((CharSequence) null);
                }
                this.isProvidingHint = true;
            }
            if (this.editText != null) {
                updateInputLayoutMargins();
            }
        }
    }

    public boolean isHintEnabled() {
        return this.hintEnabled;
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public boolean isProvidingHint() {
        return this.isProvidingHint;
    }

    public void setHintTextAppearance(@StyleRes int i) {
        this.collapsingTextHelper.setCollapsedTextAppearance(i);
        this.focusedTextColor = this.collapsingTextHelper.getCollapsedTextColor();
        if (this.editText != null) {
            updateLabelState(false);
            updateInputLayoutMargins();
        }
    }

    public void setHintTextColor(@Nullable ColorStateList colorStateList) {
        if (this.focusedTextColor != colorStateList) {
            if (this.defaultHintTextColor == null) {
                this.collapsingTextHelper.setCollapsedTextColor(colorStateList);
            }
            this.focusedTextColor = colorStateList;
            if (this.editText != null) {
                updateLabelState(false);
            }
        }
    }

    @Nullable
    public ColorStateList getHintTextColor() {
        return this.focusedTextColor;
    }

    public void setDefaultHintTextColor(@Nullable ColorStateList colorStateList) {
        this.defaultHintTextColor = colorStateList;
        this.focusedTextColor = colorStateList;
        if (this.editText != null) {
            updateLabelState(false);
        }
    }

    @Nullable
    public ColorStateList getDefaultHintTextColor() {
        return this.defaultHintTextColor;
    }

    public void setErrorEnabled(boolean z) {
        this.indicatorViewController.setErrorEnabled(z);
    }

    public void setErrorTextAppearance(@StyleRes int i) {
        this.indicatorViewController.setErrorTextAppearance(i);
    }

    public void setErrorTextColor(@Nullable ColorStateList colorStateList) {
        this.indicatorViewController.setErrorViewTextColor(colorStateList);
    }

    @ColorInt
    public int getErrorCurrentTextColors() {
        return this.indicatorViewController.getErrorViewCurrentTextColor();
    }

    public void setHelperTextTextAppearance(@StyleRes int i) {
        this.indicatorViewController.setHelperTextAppearance(i);
    }

    public void setHelperTextColor(@Nullable ColorStateList colorStateList) {
        this.indicatorViewController.setHelperTextViewTextColor(colorStateList);
    }

    public boolean isErrorEnabled() {
        return this.indicatorViewController.isErrorEnabled();
    }

    public void setHelperTextEnabled(boolean z) {
        this.indicatorViewController.setHelperTextEnabled(z);
    }

    public void setHelperText(@Nullable CharSequence charSequence) {
        if (!TextUtils.isEmpty(charSequence)) {
            if (!isHelperTextEnabled()) {
                setHelperTextEnabled(true);
            }
            this.indicatorViewController.showHelper(charSequence);
        } else if (isHelperTextEnabled()) {
            setHelperTextEnabled(false);
        }
    }

    public boolean isHelperTextEnabled() {
        return this.indicatorViewController.isHelperTextEnabled();
    }

    @ColorInt
    public int getHelperTextCurrentTextColor() {
        return this.indicatorViewController.getHelperTextViewCurrentTextColor();
    }

    public void setErrorContentDescription(@Nullable CharSequence charSequence) {
        this.indicatorViewController.setErrorContentDescription(charSequence);
    }

    @Nullable
    public CharSequence getErrorContentDescription() {
        return this.indicatorViewController.getErrorContentDescription();
    }

    public void setError(@Nullable CharSequence charSequence) {
        if (!this.indicatorViewController.isErrorEnabled()) {
            if (!TextUtils.isEmpty(charSequence)) {
                setErrorEnabled(true);
            } else {
                return;
            }
        }
        if (!TextUtils.isEmpty(charSequence)) {
            this.indicatorViewController.showError(charSequence);
        } else {
            this.indicatorViewController.hideError();
        }
    }

    public void setErrorIconDrawable(@DrawableRes int i) {
        setErrorIconDrawable(i != 0 ? AppCompatResources.getDrawable(getContext(), i) : null);
        refreshErrorIconDrawableState();
    }

    public void setErrorIconDrawable(@Nullable Drawable drawable) {
        this.errorIconView.setImageDrawable(drawable);
        updateErrorIconVisibility();
        applyIconTint(this.errorIconView, this.errorIconTintList, this.errorIconTintMode);
    }

    @Nullable
    public Drawable getErrorIconDrawable() {
        return this.errorIconView.getDrawable();
    }

    public void setErrorIconTintList(@Nullable ColorStateList colorStateList) {
        if (this.errorIconTintList != colorStateList) {
            this.errorIconTintList = colorStateList;
            applyIconTint(this.errorIconView, colorStateList, this.errorIconTintMode);
        }
    }

    public void setErrorIconTintMode(@Nullable PorterDuff.Mode mode) {
        if (this.errorIconTintMode != mode) {
            this.errorIconTintMode = mode;
            applyIconTint(this.errorIconView, this.errorIconTintList, mode);
        }
    }

    public void setCounterEnabled(boolean z) {
        if (this.counterEnabled != z) {
            if (z) {
                AppCompatTextView appCompatTextView = new AppCompatTextView(getContext());
                this.counterView = appCompatTextView;
                appCompatTextView.setId(R.id.textinput_counter);
                Typeface typeface2 = this.typeface;
                if (typeface2 != null) {
                    this.counterView.setTypeface(typeface2);
                }
                this.counterView.setMaxLines(1);
                this.indicatorViewController.addIndicator(this.counterView, 2);
                MarginLayoutParamsCompat.setMarginStart((ViewGroup.MarginLayoutParams) this.counterView.getLayoutParams(), getResources().getDimensionPixelOffset(R.dimen.mtrl_textinput_counter_margin_start));
                updateCounterTextAppearanceAndColor();
                updateCounter();
            } else {
                this.indicatorViewController.removeIndicator(this.counterView, 2);
                this.counterView = null;
            }
            this.counterEnabled = z;
        }
    }

    public void setCounterTextAppearance(int i) {
        if (this.counterTextAppearance != i) {
            this.counterTextAppearance = i;
            updateCounterTextAppearanceAndColor();
        }
    }

    public void setCounterTextColor(@Nullable ColorStateList colorStateList) {
        if (this.counterTextColor != colorStateList) {
            this.counterTextColor = colorStateList;
            updateCounterTextAppearanceAndColor();
        }
    }

    @Nullable
    public ColorStateList getCounterTextColor() {
        return this.counterTextColor;
    }

    public void setCounterOverflowTextAppearance(int i) {
        if (this.counterOverflowTextAppearance != i) {
            this.counterOverflowTextAppearance = i;
            updateCounterTextAppearanceAndColor();
        }
    }

    public void setCounterOverflowTextColor(@Nullable ColorStateList colorStateList) {
        if (this.counterOverflowTextColor != colorStateList) {
            this.counterOverflowTextColor = colorStateList;
            updateCounterTextAppearanceAndColor();
        }
    }

    @Nullable
    public ColorStateList getCounterOverflowTextColor() {
        return this.counterTextColor;
    }

    public boolean isCounterEnabled() {
        return this.counterEnabled;
    }

    public void setCounterMaxLength(int i) {
        if (this.counterMaxLength != i) {
            if (i > 0) {
                this.counterMaxLength = i;
            } else {
                this.counterMaxLength = -1;
            }
            if (this.counterEnabled) {
                updateCounter();
            }
        }
    }

    private void updateCounter() {
        if (this.counterView != null) {
            EditText editText2 = this.editText;
            updateCounter(editText2 == null ? 0 : editText2.getText().length());
        }
    }

    /* access modifiers changed from: package-private */
    public void updateCounter(int i) {
        boolean z = this.counterOverflowed;
        int i2 = this.counterMaxLength;
        if (i2 == -1) {
            this.counterView.setText(String.valueOf(i));
            this.counterView.setContentDescription((CharSequence) null);
            this.counterOverflowed = false;
        } else {
            this.counterOverflowed = i > i2;
            updateCounterContentDescription(getContext(), this.counterView, i, this.counterMaxLength, this.counterOverflowed);
            if (z != this.counterOverflowed) {
                updateCounterTextAppearanceAndColor();
            }
            this.counterView.setText(BidiFormatter.getInstance().unicodeWrap(getContext().getString(R.string.character_counter_pattern, new Object[]{Integer.valueOf(i), Integer.valueOf(this.counterMaxLength)})));
        }
        if (this.editText != null && z != this.counterOverflowed) {
            updateLabelState(false);
            updateTextInputBoxState();
            updateEditTextBackground();
        }
    }

    private static void updateCounterContentDescription(@NonNull Context context, @NonNull TextView textView, int i, int i2, boolean z) {
        int i3;
        if (z) {
            i3 = R.string.character_counter_overflowed_content_description;
        } else {
            i3 = R.string.character_counter_content_description;
        }
        textView.setContentDescription(context.getString(i3, new Object[]{Integer.valueOf(i), Integer.valueOf(i2)}));
    }

    public void setPlaceholderText(@Nullable CharSequence charSequence) {
        if (this.placeholderTextView == null) {
            AppCompatTextView appCompatTextView = new AppCompatTextView(getContext());
            this.placeholderTextView = appCompatTextView;
            appCompatTextView.setId(R.id.textinput_placeholder);
            ViewCompat.setImportantForAccessibility(this.placeholderTextView, 2);
            Fade createPlaceholderFadeTransition = createPlaceholderFadeTransition();
            this.placeholderFadeIn = createPlaceholderFadeTransition;
            createPlaceholderFadeTransition.setStartDelay(PLACEHOLDER_START_DELAY);
            this.placeholderFadeOut = createPlaceholderFadeTransition();
            setPlaceholderTextAppearance(this.placeholderTextAppearance);
            setPlaceholderTextColor(this.placeholderTextColor);
        }
        if (TextUtils.isEmpty(charSequence)) {
            setPlaceholderTextEnabled(false);
        } else {
            if (!this.placeholderEnabled) {
                setPlaceholderTextEnabled(true);
            }
            this.placeholderText = charSequence;
        }
        updatePlaceholderText();
    }

    @Nullable
    public CharSequence getPlaceholderText() {
        if (this.placeholderEnabled) {
            return this.placeholderText;
        }
        return null;
    }

    private void setPlaceholderTextEnabled(boolean z) {
        if (this.placeholderEnabled != z) {
            if (z) {
                addPlaceholderTextView();
            } else {
                removePlaceholderTextView();
                this.placeholderTextView = null;
            }
            this.placeholderEnabled = z;
        }
    }

    private Fade createPlaceholderFadeTransition() {
        Fade fade = new Fade();
        fade.setDuration(PLACEHOLDER_FADE_DURATION);
        fade.setInterpolator(AnimationUtils.LINEAR_INTERPOLATOR);
        return fade;
    }

    private void updatePlaceholderText() {
        EditText editText2 = this.editText;
        updatePlaceholderText(editText2 == null ? 0 : editText2.getText().length());
    }

    /* access modifiers changed from: private */
    public void updatePlaceholderText(int i) {
        if (i != 0 || this.hintExpanded) {
            hidePlaceholderText();
        } else {
            showPlaceholderText();
        }
    }

    private void showPlaceholderText() {
        if (this.placeholderTextView != null && this.placeholderEnabled && !TextUtils.isEmpty(this.placeholderText)) {
            this.placeholderTextView.setText(this.placeholderText);
            TransitionManager.beginDelayedTransition(this.inputFrame, this.placeholderFadeIn);
            this.placeholderTextView.setVisibility(0);
            this.placeholderTextView.bringToFront();
            announceForAccessibility(this.placeholderText);
        }
    }

    private void hidePlaceholderText() {
        TextView textView = this.placeholderTextView;
        if (textView != null && this.placeholderEnabled) {
            textView.setText((CharSequence) null);
            TransitionManager.beginDelayedTransition(this.inputFrame, this.placeholderFadeOut);
            this.placeholderTextView.setVisibility(4);
        }
    }

    private void addPlaceholderTextView() {
        TextView textView = this.placeholderTextView;
        if (textView != null) {
            this.inputFrame.addView(textView);
            this.placeholderTextView.setVisibility(0);
        }
    }

    private void removePlaceholderTextView() {
        TextView textView = this.placeholderTextView;
        if (textView != null) {
            textView.setVisibility(8);
        }
    }

    public void setPlaceholderTextColor(@Nullable ColorStateList colorStateList) {
        if (this.placeholderTextColor != colorStateList) {
            this.placeholderTextColor = colorStateList;
            TextView textView = this.placeholderTextView;
            if (textView != null && colorStateList != null) {
                textView.setTextColor(colorStateList);
            }
        }
    }

    @Nullable
    public ColorStateList getPlaceholderTextColor() {
        return this.placeholderTextColor;
    }

    public void setPlaceholderTextAppearance(@StyleRes int i) {
        this.placeholderTextAppearance = i;
        TextView textView = this.placeholderTextView;
        if (textView != null) {
            TextViewCompat.setTextAppearance(textView, i);
        }
    }

    @StyleRes
    public int getPlaceholderTextAppearance() {
        return this.placeholderTextAppearance;
    }

    public void setPrefixText(@Nullable CharSequence charSequence) {
        this.prefixText = TextUtils.isEmpty(charSequence) ? null : charSequence;
        this.prefixTextView.setText(charSequence);
        updatePrefixTextVisibility();
    }

    @Nullable
    public CharSequence getPrefixText() {
        return this.prefixText;
    }

    @NonNull
    public TextView getPrefixTextView() {
        return this.prefixTextView;
    }

    private void updatePrefixTextVisibility() {
        int i = (this.prefixText == null || isHintExpanded()) ? 8 : 0;
        updateStartLayoutVisibility();
        this.prefixTextView.setVisibility(i);
        updateDummyDrawables();
    }

    public void setPrefixTextColor(@NonNull ColorStateList colorStateList) {
        this.prefixTextView.setTextColor(colorStateList);
    }

    @Nullable
    public ColorStateList getPrefixTextColor() {
        return this.prefixTextView.getTextColors();
    }

    public void setPrefixTextAppearance(@StyleRes int i) {
        TextViewCompat.setTextAppearance(this.prefixTextView, i);
    }

    private void updatePrefixTextViewPadding() {
        if (this.editText != null) {
            ViewCompat.setPaddingRelative(this.prefixTextView, isStartIconVisible() ? 0 : ViewCompat.getPaddingStart(this.editText), this.editText.getCompoundPaddingTop(), getContext().getResources().getDimensionPixelSize(R.dimen.material_input_text_to_prefix_suffix_padding), this.editText.getCompoundPaddingBottom());
        }
    }

    public void setSuffixText(@Nullable CharSequence charSequence) {
        this.suffixText = TextUtils.isEmpty(charSequence) ? null : charSequence;
        this.suffixTextView.setText(charSequence);
        updateSuffixTextVisibility();
    }

    @Nullable
    public CharSequence getSuffixText() {
        return this.suffixText;
    }

    @NonNull
    public TextView getSuffixTextView() {
        return this.suffixTextView;
    }

    private void updateSuffixTextVisibility() {
        int visibility = this.suffixTextView.getVisibility();
        boolean z = false;
        int i = (this.suffixText == null || isHintExpanded()) ? 8 : 0;
        if (visibility != i) {
            EndIconDelegate endIconDelegate = getEndIconDelegate();
            if (i == 0) {
                z = true;
            }
            endIconDelegate.onSuffixVisibilityChanged(z);
        }
        updateEndLayoutVisibility();
        this.suffixTextView.setVisibility(i);
        updateDummyDrawables();
    }

    public void setSuffixTextColor(@NonNull ColorStateList colorStateList) {
        this.suffixTextView.setTextColor(colorStateList);
    }

    @Nullable
    public ColorStateList getSuffixTextColor() {
        return this.suffixTextView.getTextColors();
    }

    public void setSuffixTextAppearance(@StyleRes int i) {
        TextViewCompat.setTextAppearance(this.suffixTextView, i);
    }

    private void updateSuffixTextViewPadding() {
        if (this.editText != null) {
            ViewCompat.setPaddingRelative(this.suffixTextView, getContext().getResources().getDimensionPixelSize(R.dimen.material_input_text_to_prefix_suffix_padding), this.editText.getPaddingTop(), (isEndIconVisible() || isErrorIconVisible()) ? 0 : ViewCompat.getPaddingEnd(this.editText), this.editText.getPaddingBottom());
        }
    }

    public void setEnabled(boolean z) {
        recursiveSetEnabled(this, z);
        super.setEnabled(z);
    }

    private static void recursiveSetEnabled(@NonNull ViewGroup viewGroup, boolean z) {
        int childCount = viewGroup.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View childAt = viewGroup.getChildAt(i);
            childAt.setEnabled(z);
            if (childAt instanceof ViewGroup) {
                recursiveSetEnabled((ViewGroup) childAt, z);
            }
        }
    }

    public int getCounterMaxLength() {
        return this.counterMaxLength;
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public CharSequence getCounterOverflowDescription() {
        TextView textView;
        if (!this.counterEnabled || !this.counterOverflowed || (textView = this.counterView) == null) {
            return null;
        }
        return textView.getContentDescription();
    }

    private void updateCounterTextAppearanceAndColor() {
        ColorStateList colorStateList;
        ColorStateList colorStateList2;
        TextView textView = this.counterView;
        if (textView != null) {
            setTextAppearanceCompatWithErrorFallback(textView, this.counterOverflowed ? this.counterOverflowTextAppearance : this.counterTextAppearance);
            if (!this.counterOverflowed && (colorStateList2 = this.counterTextColor) != null) {
                this.counterView.setTextColor(colorStateList2);
            }
            if (this.counterOverflowed && (colorStateList = this.counterOverflowTextColor) != null) {
                this.counterView.setTextColor(colorStateList);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void setTextAppearanceCompatWithErrorFallback(@NonNull TextView textView, @StyleRes int i) {
        boolean z = true;
        try {
            TextViewCompat.setTextAppearance(textView, i);
            if (textView.getTextColors().getDefaultColor() != -65281) {
                z = false;
            }
        } catch (Exception unused) {
        }
        if (z) {
            TextViewCompat.setTextAppearance(textView, R.style.TextAppearance_AppCompat_Caption);
            textView.setTextColor(ContextCompat.getColor(getContext(), R.color.design_error));
        }
    }

    private int calculateLabelMarginTop() {
        float collapsedTextHeight;
        if (!this.hintEnabled) {
            return 0;
        }
        int i = this.boxBackgroundMode;
        if (i == 0) {
            collapsedTextHeight = this.collapsingTextHelper.getCollapsedTextHeight();
        } else if (i != 2) {
            return 0;
        } else {
            collapsedTextHeight = this.collapsingTextHelper.getCollapsedTextHeight() / 2.0f;
        }
        return (int) collapsedTextHeight;
    }

    @NonNull
    private Rect calculateCollapsedTextBounds(@NonNull Rect rect) {
        if (this.editText != null) {
            Rect rect2 = this.tmpBoundsRect;
            boolean isLayoutRtl = ViewUtils.isLayoutRtl(this);
            rect2.bottom = rect.bottom;
            int i = this.boxBackgroundMode;
            if (i == 1) {
                rect2.left = getLabelLeftBoundAlightWithPrefix(rect.left, isLayoutRtl);
                rect2.top = rect.top + this.boxCollapsedPaddingTopPx;
                rect2.right = getLabelRightBoundAlignedWithSuffix(rect.right, isLayoutRtl);
                return rect2;
            } else if (i != 2) {
                rect2.left = getLabelLeftBoundAlightWithPrefix(rect.left, isLayoutRtl);
                rect2.top = getPaddingTop();
                rect2.right = getLabelRightBoundAlignedWithSuffix(rect.right, isLayoutRtl);
                return rect2;
            } else {
                rect2.left = rect.left + this.editText.getPaddingLeft();
                rect2.top = rect.top - calculateLabelMarginTop();
                rect2.right = rect.right - this.editText.getPaddingRight();
                return rect2;
            }
        } else {
            throw new IllegalStateException();
        }
    }

    private int getLabelLeftBoundAlightWithPrefix(int i, boolean z) {
        int compoundPaddingLeft = i + this.editText.getCompoundPaddingLeft();
        return (this.prefixText == null || z) ? compoundPaddingLeft : (compoundPaddingLeft - this.prefixTextView.getMeasuredWidth()) + this.prefixTextView.getPaddingLeft();
    }

    private int getLabelRightBoundAlignedWithSuffix(int i, boolean z) {
        int compoundPaddingRight = i - this.editText.getCompoundPaddingRight();
        return (this.prefixText == null || !z) ? compoundPaddingRight : compoundPaddingRight + (this.prefixTextView.getMeasuredWidth() - this.prefixTextView.getPaddingRight());
    }

    @NonNull
    private Rect calculateExpandedTextBounds(@NonNull Rect rect) {
        if (this.editText != null) {
            Rect rect2 = this.tmpBoundsRect;
            float expandedTextHeight = this.collapsingTextHelper.getExpandedTextHeight();
            rect2.left = rect.left + this.editText.getCompoundPaddingLeft();
            rect2.top = calculateExpandedLabelTop(rect, expandedTextHeight);
            rect2.right = rect.right - this.editText.getCompoundPaddingRight();
            rect2.bottom = calculateExpandedLabelBottom(rect, rect2, expandedTextHeight);
            return rect2;
        }
        throw new IllegalStateException();
    }

    private int calculateExpandedLabelTop(@NonNull Rect rect, float f) {
        if (isSingleLineFilledTextField()) {
            return (int) (((float) rect.centerY()) - (f / 2.0f));
        }
        return rect.top + this.editText.getCompoundPaddingTop();
    }

    private int calculateExpandedLabelBottom(@NonNull Rect rect, @NonNull Rect rect2, float f) {
        if (isSingleLineFilledTextField()) {
            return (int) (((float) rect2.top) + f);
        }
        return rect.bottom - this.editText.getCompoundPaddingBottom();
    }

    private boolean isSingleLineFilledTextField() {
        if (this.boxBackgroundMode != 1 || this.editText.getMinLines() > 1) {
            return false;
        }
        return true;
    }

    private int calculateBoxBackgroundColor() {
        return this.boxBackgroundMode == 1 ? MaterialColors.layer(MaterialColors.getColor((View) this, R.attr.colorSurface, 0), this.boxBackgroundColor) : this.boxBackgroundColor;
    }

    private void applyBoxAttributes() {
        MaterialShapeDrawable materialShapeDrawable = this.boxBackground;
        if (materialShapeDrawable != null) {
            ShapeAppearanceModel shapeAppearanceModel2 = materialShapeDrawable.getShapeAppearanceModel();
            ShapeAppearanceModel shapeAppearanceModel3 = this.shapeAppearanceModel;
            if (shapeAppearanceModel2 != shapeAppearanceModel3) {
                this.boxBackground.setShapeAppearanceModel(shapeAppearanceModel3);
                updateDropdownMenuBackground();
            }
            if (canDrawOutlineStroke()) {
                this.boxBackground.setStroke((float) this.boxStrokeWidthPx, this.boxStrokeColor);
            }
            int calculateBoxBackgroundColor = calculateBoxBackgroundColor();
            this.boxBackgroundColor = calculateBoxBackgroundColor;
            this.boxBackground.setFillColor(ColorStateList.valueOf(calculateBoxBackgroundColor));
            if (this.endIconMode == 3) {
                this.editText.getBackground().invalidateSelf();
            }
            applyBoxUnderlineAttributes();
            invalidate();
        }
    }

    private void applyBoxUnderlineAttributes() {
        ColorStateList colorStateList;
        if (this.boxUnderlineDefault != null && this.boxUnderlineFocused != null) {
            if (canDrawStroke()) {
                MaterialShapeDrawable materialShapeDrawable = this.boxUnderlineDefault;
                if (this.editText.isFocused()) {
                    colorStateList = ColorStateList.valueOf(this.defaultStrokeColor);
                } else {
                    colorStateList = ColorStateList.valueOf(this.boxStrokeColor);
                }
                materialShapeDrawable.setFillColor(colorStateList);
                this.boxUnderlineFocused.setFillColor(ColorStateList.valueOf(this.boxStrokeColor));
            }
            invalidate();
        }
    }

    private boolean canDrawOutlineStroke() {
        return this.boxBackgroundMode == 2 && canDrawStroke();
    }

    private boolean canDrawStroke() {
        return this.boxStrokeWidthPx > -1 && this.boxStrokeColor != 0;
    }

    private void updateDropdownMenuBackground() {
        if (this.endIconMode == 3 && this.boxBackgroundMode == 2) {
            ((DropdownMenuEndIconDelegate) this.endIconDelegates.get(3)).updateOutlinedRippleEffect((AutoCompleteTextView) this.editText);
        }
    }

    /* access modifiers changed from: package-private */
    public void updateEditTextBackground() {
        Drawable background;
        TextView textView;
        EditText editText2 = this.editText;
        if (editText2 != null && this.boxBackgroundMode == 0 && (background = editText2.getBackground()) != null) {
            if (DrawableUtils.canSafelyMutateDrawable(background)) {
                background = background.mutate();
            }
            if (this.indicatorViewController.errorShouldBeShown()) {
                background.setColorFilter(AppCompatDrawableManager.getPorterDuffColorFilter(this.indicatorViewController.getErrorViewCurrentTextColor(), PorterDuff.Mode.SRC_IN));
            } else if (!this.counterOverflowed || (textView = this.counterView) == null) {
                DrawableCompat.clearColorFilter(background);
                this.editText.refreshDrawableState();
            } else {
                background.setColorFilter(AppCompatDrawableManager.getPorterDuffColorFilter(textView.getCurrentTextColor(), PorterDuff.Mode.SRC_IN));
            }
        }
    }

    static class SavedState extends AbsSavedState {
        public static final Parcelable.Creator<SavedState> CREATOR = new Parcelable.ClassLoaderCreator<SavedState>() {
            @NonNull
            public SavedState createFromParcel(@NonNull Parcel parcel, ClassLoader classLoader) {
                return new SavedState(parcel, classLoader);
            }

            @Nullable
            public SavedState createFromParcel(@NonNull Parcel parcel) {
                return new SavedState(parcel, (ClassLoader) null);
            }

            @NonNull
            public SavedState[] newArray(int i) {
                return new SavedState[i];
            }
        };
        @Nullable
        CharSequence error;
        @Nullable
        CharSequence helperText;
        @Nullable
        CharSequence hintText;
        boolean isEndIconChecked;
        @Nullable
        CharSequence placeholderText;

        SavedState(Parcelable parcelable) {
            super(parcelable);
        }

        SavedState(@NonNull Parcel parcel, ClassLoader classLoader) {
            super(parcel, classLoader);
            this.error = (CharSequence) TextUtils.CHAR_SEQUENCE_CREATOR.createFromParcel(parcel);
            this.isEndIconChecked = parcel.readInt() != 1 ? false : true;
            this.hintText = (CharSequence) TextUtils.CHAR_SEQUENCE_CREATOR.createFromParcel(parcel);
            this.helperText = (CharSequence) TextUtils.CHAR_SEQUENCE_CREATOR.createFromParcel(parcel);
            this.placeholderText = (CharSequence) TextUtils.CHAR_SEQUENCE_CREATOR.createFromParcel(parcel);
        }

        public void writeToParcel(@NonNull Parcel parcel, int i) {
            super.writeToParcel(parcel, i);
            TextUtils.writeToParcel(this.error, parcel, i);
            parcel.writeInt(this.isEndIconChecked ? 1 : 0);
            TextUtils.writeToParcel(this.hintText, parcel, i);
            TextUtils.writeToParcel(this.helperText, parcel, i);
            TextUtils.writeToParcel(this.placeholderText, parcel, i);
        }

        @NonNull
        public String toString() {
            return "TextInputLayout.SavedState{" + Integer.toHexString(System.identityHashCode(this)) + " error=" + this.error + " hint=" + this.hintText + " helperText=" + this.helperText + " placeholderText=" + this.placeholderText + "}";
        }
    }

    @Nullable
    public Parcelable onSaveInstanceState() {
        SavedState savedState = new SavedState(super.onSaveInstanceState());
        if (this.indicatorViewController.errorShouldBeShown()) {
            savedState.error = getError();
        }
        savedState.isEndIconChecked = hasEndIcon() && this.endIconView.isChecked();
        savedState.hintText = getHint();
        savedState.helperText = getHelperText();
        savedState.placeholderText = getPlaceholderText();
        return savedState;
    }

    /* access modifiers changed from: protected */
    public void onRestoreInstanceState(@Nullable Parcelable parcelable) {
        if (!(parcelable instanceof SavedState)) {
            super.onRestoreInstanceState(parcelable);
            return;
        }
        SavedState savedState = (SavedState) parcelable;
        super.onRestoreInstanceState(savedState.getSuperState());
        setError(savedState.error);
        if (savedState.isEndIconChecked) {
            this.endIconView.post(new Runnable() {
                public void run() {
                    TextInputLayout.this.endIconView.performClick();
                    TextInputLayout.this.endIconView.jumpDrawablesToCurrentState();
                }
            });
        }
        setHint(savedState.hintText);
        setHelperText(savedState.helperText);
        setPlaceholderText(savedState.placeholderText);
        requestLayout();
    }

    /* access modifiers changed from: protected */
    public void dispatchRestoreInstanceState(@NonNull SparseArray<Parcelable> sparseArray) {
        this.restoringSavedState = true;
        super.dispatchRestoreInstanceState(sparseArray);
        this.restoringSavedState = false;
    }

    @Nullable
    public CharSequence getError() {
        if (this.indicatorViewController.isErrorEnabled()) {
            return this.indicatorViewController.getErrorText();
        }
        return null;
    }

    @Nullable
    public CharSequence getHelperText() {
        if (this.indicatorViewController.isHelperTextEnabled()) {
            return this.indicatorViewController.getHelperText();
        }
        return null;
    }

    public boolean isHintAnimationEnabled() {
        return this.hintAnimationEnabled;
    }

    public void setHintAnimationEnabled(boolean z) {
        this.hintAnimationEnabled = z;
    }

    public boolean isExpandedHintEnabled() {
        return this.expandedHintEnabled;
    }

    public void setExpandedHintEnabled(boolean z) {
        if (this.expandedHintEnabled != z) {
            this.expandedHintEnabled = z;
            updateLabelState(false);
        }
    }

    public void onRtlPropertiesChanged(int i) {
        super.onRtlPropertiesChanged(i);
        boolean z = false;
        boolean z2 = i == 1;
        boolean z3 = this.areCornerRadiiRtl;
        if (z2 != z3) {
            if (z2 && !z3) {
                z = true;
            }
            float cornerSize = this.shapeAppearanceModel.getTopLeftCornerSize().getCornerSize(this.tmpRectF);
            float cornerSize2 = this.shapeAppearanceModel.getTopRightCornerSize().getCornerSize(this.tmpRectF);
            float cornerSize3 = this.shapeAppearanceModel.getBottomLeftCornerSize().getCornerSize(this.tmpRectF);
            float cornerSize4 = this.shapeAppearanceModel.getBottomRightCornerSize().getCornerSize(this.tmpRectF);
            float f = z ? cornerSize : cornerSize2;
            if (z) {
                cornerSize = cornerSize2;
            }
            float f2 = z ? cornerSize3 : cornerSize4;
            if (z) {
                cornerSize3 = cornerSize4;
            }
            setBoxCornerRadii(f, cornerSize, f2, cornerSize3);
        }
    }

    /* access modifiers changed from: protected */
    public void onMeasure(int i, int i2) {
        super.onMeasure(i, i2);
        boolean updateEditTextHeightBasedOnIcon = updateEditTextHeightBasedOnIcon();
        boolean updateDummyDrawables = updateDummyDrawables();
        if (updateEditTextHeightBasedOnIcon || updateDummyDrawables) {
            this.editText.post(new Runnable() {
                public void run() {
                    TextInputLayout.this.editText.requestLayout();
                }
            });
        }
        updatePlaceholderMeasurementsBasedOnEditText();
        updatePrefixTextViewPadding();
        updateSuffixTextViewPadding();
    }

    private boolean updateEditTextHeightBasedOnIcon() {
        int max;
        if (this.editText == null || this.editText.getMeasuredHeight() >= (max = Math.max(this.endLayout.getMeasuredHeight(), this.startLayout.getMeasuredHeight()))) {
            return false;
        }
        this.editText.setMinimumHeight(max);
        return true;
    }

    private void updatePlaceholderMeasurementsBasedOnEditText() {
        EditText editText2;
        if (this.placeholderTextView != null && (editText2 = this.editText) != null) {
            this.placeholderTextView.setGravity(editText2.getGravity());
            this.placeholderTextView.setPadding(this.editText.getCompoundPaddingLeft(), this.editText.getCompoundPaddingTop(), this.editText.getCompoundPaddingRight(), this.editText.getCompoundPaddingBottom());
        }
    }

    public void setStartIconDrawable(@DrawableRes int i) {
        setStartIconDrawable(i != 0 ? AppCompatResources.getDrawable(getContext(), i) : null);
    }

    public void setStartIconDrawable(@Nullable Drawable drawable) {
        this.startIconView.setImageDrawable(drawable);
        if (drawable != null) {
            applyIconTint(this.startIconView, this.startIconTintList, this.startIconTintMode);
            setStartIconVisible(true);
            refreshStartIconDrawableState();
            return;
        }
        setStartIconVisible(false);
        setStartIconOnClickListener((View.OnClickListener) null);
        setStartIconOnLongClickListener((View.OnLongClickListener) null);
        setStartIconContentDescription((CharSequence) null);
    }

    @Nullable
    public Drawable getStartIconDrawable() {
        return this.startIconView.getDrawable();
    }

    public void setStartIconOnClickListener(@Nullable View.OnClickListener onClickListener) {
        setIconOnClickListener(this.startIconView, onClickListener, this.startIconOnLongClickListener);
    }

    public void setStartIconOnLongClickListener(@Nullable View.OnLongClickListener onLongClickListener) {
        this.startIconOnLongClickListener = onLongClickListener;
        setIconOnLongClickListener(this.startIconView, onLongClickListener);
    }

    public void setStartIconVisible(boolean z) {
        if (isStartIconVisible() != z) {
            this.startIconView.setVisibility(z ? 0 : 8);
            updateStartLayoutVisibility();
            updatePrefixTextViewPadding();
            updateDummyDrawables();
        }
    }

    public boolean isStartIconVisible() {
        return this.startIconView.getVisibility() == 0;
    }

    public void refreshStartIconDrawableState() {
        refreshIconDrawableState(this.startIconView, this.startIconTintList);
    }

    public void setStartIconCheckable(boolean z) {
        this.startIconView.setCheckable(z);
    }

    public boolean isStartIconCheckable() {
        return this.startIconView.isCheckable();
    }

    public void setStartIconContentDescription(@StringRes int i) {
        setStartIconContentDescription(i != 0 ? getResources().getText(i) : null);
    }

    public void setStartIconContentDescription(@Nullable CharSequence charSequence) {
        if (getStartIconContentDescription() != charSequence) {
            this.startIconView.setContentDescription(charSequence);
        }
    }

    @Nullable
    public CharSequence getStartIconContentDescription() {
        return this.startIconView.getContentDescription();
    }

    public void setStartIconTintList(@Nullable ColorStateList colorStateList) {
        if (this.startIconTintList != colorStateList) {
            this.startIconTintList = colorStateList;
            applyIconTint(this.startIconView, colorStateList, this.startIconTintMode);
        }
    }

    public void setStartIconTintMode(@Nullable PorterDuff.Mode mode) {
        if (this.startIconTintMode != mode) {
            this.startIconTintMode = mode;
            applyIconTint(this.startIconView, this.startIconTintList, mode);
        }
    }

    public void setEndIconMode(int i) {
        int i2 = this.endIconMode;
        if (i2 != i) {
            this.endIconMode = i;
            dispatchOnEndIconChanged(i2);
            setEndIconVisible(i != 0);
            if (getEndIconDelegate().isBoxBackgroundModeSupported(this.boxBackgroundMode)) {
                getEndIconDelegate().initialize();
                applyIconTint(this.endIconView, this.endIconTintList, this.endIconTintMode);
                return;
            }
            throw new IllegalStateException("The current box background mode " + this.boxBackgroundMode + " is not supported by the end icon mode " + i);
        }
    }

    public int getEndIconMode() {
        return this.endIconMode;
    }

    public void setEndIconOnClickListener(@Nullable View.OnClickListener onClickListener) {
        setIconOnClickListener(this.endIconView, onClickListener, this.endIconOnLongClickListener);
    }

    public void setErrorIconOnClickListener(@Nullable View.OnClickListener onClickListener) {
        setIconOnClickListener(this.errorIconView, onClickListener, this.errorIconOnLongClickListener);
    }

    public void setEndIconOnLongClickListener(@Nullable View.OnLongClickListener onLongClickListener) {
        this.endIconOnLongClickListener = onLongClickListener;
        setIconOnLongClickListener(this.endIconView, onLongClickListener);
    }

    public void setErrorIconOnLongClickListener(@Nullable View.OnLongClickListener onLongClickListener) {
        this.errorIconOnLongClickListener = onLongClickListener;
        setIconOnLongClickListener(this.errorIconView, onLongClickListener);
    }

    public void refreshErrorIconDrawableState() {
        refreshIconDrawableState(this.errorIconView, this.errorIconTintList);
    }

    public void setEndIconVisible(boolean z) {
        if (isEndIconVisible() != z) {
            this.endIconView.setVisibility(z ? 0 : 8);
            updateEndLayoutVisibility();
            updateSuffixTextViewPadding();
            updateDummyDrawables();
        }
    }

    public boolean isEndIconVisible() {
        return this.endIconFrame.getVisibility() == 0 && this.endIconView.getVisibility() == 0;
    }

    public void setEndIconActivated(boolean z) {
        this.endIconView.setActivated(z);
    }

    public void refreshEndIconDrawableState() {
        refreshIconDrawableState(this.endIconView, this.endIconTintList);
    }

    public void setEndIconCheckable(boolean z) {
        this.endIconView.setCheckable(z);
    }

    public boolean isEndIconCheckable() {
        return this.endIconView.isCheckable();
    }

    public void setEndIconDrawable(@DrawableRes int i) {
        setEndIconDrawable(i != 0 ? AppCompatResources.getDrawable(getContext(), i) : null);
    }

    public void setEndIconDrawable(@Nullable Drawable drawable) {
        this.endIconView.setImageDrawable(drawable);
        if (drawable != null) {
            applyIconTint(this.endIconView, this.endIconTintList, this.endIconTintMode);
            refreshEndIconDrawableState();
        }
    }

    @Nullable
    public Drawable getEndIconDrawable() {
        return this.endIconView.getDrawable();
    }

    public void setEndIconContentDescription(@StringRes int i) {
        setEndIconContentDescription(i != 0 ? getResources().getText(i) : null);
    }

    public void setEndIconContentDescription(@Nullable CharSequence charSequence) {
        if (getEndIconContentDescription() != charSequence) {
            this.endIconView.setContentDescription(charSequence);
        }
    }

    @Nullable
    public CharSequence getEndIconContentDescription() {
        return this.endIconView.getContentDescription();
    }

    public void setEndIconTintList(@Nullable ColorStateList colorStateList) {
        if (this.endIconTintList != colorStateList) {
            this.endIconTintList = colorStateList;
            applyIconTint(this.endIconView, colorStateList, this.endIconTintMode);
        }
    }

    public void setEndIconTintMode(@Nullable PorterDuff.Mode mode) {
        if (this.endIconTintMode != mode) {
            this.endIconTintMode = mode;
            applyIconTint(this.endIconView, this.endIconTintList, mode);
        }
    }

    public void addOnEndIconChangedListener(@NonNull OnEndIconChangedListener onEndIconChangedListener) {
        this.endIconChangedListeners.add(onEndIconChangedListener);
    }

    public void removeOnEndIconChangedListener(@NonNull OnEndIconChangedListener onEndIconChangedListener) {
        this.endIconChangedListeners.remove(onEndIconChangedListener);
    }

    public void clearOnEndIconChangedListeners() {
        this.endIconChangedListeners.clear();
    }

    public void addOnEditTextAttachedListener(@NonNull OnEditTextAttachedListener onEditTextAttachedListener) {
        this.editTextAttachedListeners.add(onEditTextAttachedListener);
        if (this.editText != null) {
            onEditTextAttachedListener.onEditTextAttached(this);
        }
    }

    public void removeOnEditTextAttachedListener(@NonNull OnEditTextAttachedListener onEditTextAttachedListener) {
        this.editTextAttachedListeners.remove(onEditTextAttachedListener);
    }

    public void clearOnEditTextAttachedListeners() {
        this.editTextAttachedListeners.clear();
    }

    @Deprecated
    public void setPasswordVisibilityToggleDrawable(@DrawableRes int i) {
        setPasswordVisibilityToggleDrawable(i != 0 ? AppCompatResources.getDrawable(getContext(), i) : null);
    }

    @Deprecated
    public void setPasswordVisibilityToggleDrawable(@Nullable Drawable drawable) {
        this.endIconView.setImageDrawable(drawable);
    }

    @Deprecated
    public void setPasswordVisibilityToggleContentDescription(@StringRes int i) {
        setPasswordVisibilityToggleContentDescription(i != 0 ? getResources().getText(i) : null);
    }

    @Deprecated
    public void setPasswordVisibilityToggleContentDescription(@Nullable CharSequence charSequence) {
        this.endIconView.setContentDescription(charSequence);
    }

    @Deprecated
    @Nullable
    public Drawable getPasswordVisibilityToggleDrawable() {
        return this.endIconView.getDrawable();
    }

    @Deprecated
    @Nullable
    public CharSequence getPasswordVisibilityToggleContentDescription() {
        return this.endIconView.getContentDescription();
    }

    @Deprecated
    public boolean isPasswordVisibilityToggleEnabled() {
        return this.endIconMode == 1;
    }

    @Deprecated
    public void setPasswordVisibilityToggleEnabled(boolean z) {
        if (z && this.endIconMode != 1) {
            setEndIconMode(1);
        } else if (!z) {
            setEndIconMode(0);
        }
    }

    @Deprecated
    public void setPasswordVisibilityToggleTintList(@Nullable ColorStateList colorStateList) {
        this.endIconTintList = colorStateList;
        applyIconTint(this.endIconView, colorStateList, this.endIconTintMode);
    }

    @Deprecated
    public void setPasswordVisibilityToggleTintMode(@Nullable PorterDuff.Mode mode) {
        this.endIconTintMode = mode;
        applyIconTint(this.endIconView, this.endIconTintList, mode);
    }

    @Deprecated
    public void passwordVisibilityToggleRequested(boolean z) {
        if (this.endIconMode == 1) {
            this.endIconView.performClick();
            if (z) {
                this.endIconView.jumpDrawablesToCurrentState();
            }
        }
    }

    public void setTextInputAccessibilityDelegate(@Nullable AccessibilityDelegate accessibilityDelegate) {
        EditText editText2 = this.editText;
        if (editText2 != null) {
            ViewCompat.setAccessibilityDelegate(editText2, accessibilityDelegate);
        }
    }

    private void updateEndLayoutVisibility() {
        int i = 8;
        this.endIconFrame.setVisibility((this.endIconView.getVisibility() != 0 || isErrorIconVisible()) ? 8 : 0);
        boolean z = isEndIconVisible() || isErrorIconVisible() || !((this.suffixText == null || isHintExpanded()) ? true : false);
        LinearLayout linearLayout = this.endLayout;
        if (z) {
            i = 0;
        }
        linearLayout.setVisibility(i);
    }

    private void updateStartLayoutVisibility() {
        int i = 8;
        boolean z = this.startIconView.getVisibility() == 0 || !((this.prefixText == null || isHintExpanded()) ? true : false);
        LinearLayout linearLayout = this.startLayout;
        if (z) {
            i = 0;
        }
        linearLayout.setVisibility(i);
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public CheckableImageButton getEndIconView() {
        return this.endIconView;
    }

    private EndIconDelegate getEndIconDelegate() {
        EndIconDelegate endIconDelegate = this.endIconDelegates.get(this.endIconMode);
        return endIconDelegate != null ? endIconDelegate : this.endIconDelegates.get(0);
    }

    private void dispatchOnEditTextAttached() {
        Iterator it = this.editTextAttachedListeners.iterator();
        while (it.hasNext()) {
            ((OnEditTextAttachedListener) it.next()).onEditTextAttached(this);
        }
    }

    private boolean hasEndIcon() {
        return this.endIconMode != 0;
    }

    private void dispatchOnEndIconChanged(int i) {
        Iterator it = this.endIconChangedListeners.iterator();
        while (it.hasNext()) {
            ((OnEndIconChangedListener) it.next()).onEndIconChanged(this, i);
        }
    }

    private void tintEndIconOnError(boolean z) {
        if (!z || getEndIconDrawable() == null) {
            applyIconTint(this.endIconView, this.endIconTintList, this.endIconTintMode);
            return;
        }
        Drawable mutate = DrawableCompat.wrap(getEndIconDrawable()).mutate();
        DrawableCompat.setTint(mutate, this.indicatorViewController.getErrorViewCurrentTextColor());
        this.endIconView.setImageDrawable(mutate);
    }

    /* JADX WARNING: Removed duplicated region for block: B:20:0x0069  */
    /* JADX WARNING: Removed duplicated region for block: B:34:0x00d1  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean updateDummyDrawables() {
        /*
            r10 = this;
            android.widget.EditText r0 = r10.editText
            r1 = 0
            if (r0 != 0) goto L_0x0006
            return r1
        L_0x0006:
            boolean r0 = r10.shouldUpdateStartDummyDrawable()
            r2 = 0
            r3 = 2
            r4 = 3
            r5 = 1
            if (r0 == 0) goto L_0x0049
            android.widget.LinearLayout r0 = r10.startLayout
            int r0 = r0.getMeasuredWidth()
            android.widget.EditText r6 = r10.editText
            int r6 = r6.getPaddingLeft()
            int r0 = r0 - r6
            android.graphics.drawable.Drawable r6 = r10.startDummyDrawable
            if (r6 == 0) goto L_0x0025
            int r6 = r10.startDummyDrawableWidth
            if (r6 == r0) goto L_0x0031
        L_0x0025:
            android.graphics.drawable.ColorDrawable r6 = new android.graphics.drawable.ColorDrawable
            r6.<init>()
            r10.startDummyDrawable = r6
            r10.startDummyDrawableWidth = r0
            r6.setBounds(r1, r1, r0, r5)
        L_0x0031:
            android.widget.EditText r0 = r10.editText
            android.graphics.drawable.Drawable[] r0 = androidx.core.widget.TextViewCompat.getCompoundDrawablesRelative(r0)
            r6 = r0[r1]
            android.graphics.drawable.Drawable r7 = r10.startDummyDrawable
            if (r6 == r7) goto L_0x0062
            android.widget.EditText r6 = r10.editText
            r8 = r0[r5]
            r9 = r0[r3]
            r0 = r0[r4]
            androidx.core.widget.TextViewCompat.setCompoundDrawablesRelative(r6, r7, r8, r9, r0)
            goto L_0x0060
        L_0x0049:
            android.graphics.drawable.Drawable r0 = r10.startDummyDrawable
            if (r0 == 0) goto L_0x0062
            android.widget.EditText r0 = r10.editText
            android.graphics.drawable.Drawable[] r0 = androidx.core.widget.TextViewCompat.getCompoundDrawablesRelative(r0)
            android.widget.EditText r6 = r10.editText
            r7 = r0[r5]
            r8 = r0[r3]
            r0 = r0[r4]
            androidx.core.widget.TextViewCompat.setCompoundDrawablesRelative(r6, r2, r7, r8, r0)
            r10.startDummyDrawable = r2
        L_0x0060:
            r0 = r5
            goto L_0x0063
        L_0x0062:
            r0 = r1
        L_0x0063:
            boolean r6 = r10.shouldUpdateEndDummyDrawable()
            if (r6 == 0) goto L_0x00d1
            android.widget.TextView r2 = r10.suffixTextView
            int r2 = r2.getMeasuredWidth()
            android.widget.EditText r6 = r10.editText
            int r6 = r6.getPaddingRight()
            int r2 = r2 - r6
            com.google.android.material.internal.CheckableImageButton r6 = r10.getEndIconToUpdateDummyDrawable()
            if (r6 == 0) goto L_0x008c
            int r7 = r6.getMeasuredWidth()
            int r2 = r2 + r7
            android.view.ViewGroup$LayoutParams r6 = r6.getLayoutParams()
            android.view.ViewGroup$MarginLayoutParams r6 = (android.view.ViewGroup.MarginLayoutParams) r6
            int r6 = androidx.core.view.MarginLayoutParamsCompat.getMarginStart(r6)
            int r2 = r2 + r6
        L_0x008c:
            android.widget.EditText r6 = r10.editText
            android.graphics.drawable.Drawable[] r6 = androidx.core.widget.TextViewCompat.getCompoundDrawablesRelative(r6)
            android.graphics.drawable.Drawable r7 = r10.endDummyDrawable
            if (r7 == 0) goto L_0x00ad
            int r8 = r10.endDummyDrawableWidth
            if (r8 == r2) goto L_0x00ad
            r10.endDummyDrawableWidth = r2
            r7.setBounds(r1, r1, r2, r5)
            android.widget.EditText r0 = r10.editText
            r1 = r6[r1]
            r2 = r6[r5]
            android.graphics.drawable.Drawable r10 = r10.endDummyDrawable
            r3 = r6[r4]
            androidx.core.widget.TextViewCompat.setCompoundDrawablesRelative(r0, r1, r2, r10, r3)
            goto L_0x00f2
        L_0x00ad:
            if (r7 != 0) goto L_0x00bb
            android.graphics.drawable.ColorDrawable r7 = new android.graphics.drawable.ColorDrawable
            r7.<init>()
            r10.endDummyDrawable = r7
            r10.endDummyDrawableWidth = r2
            r7.setBounds(r1, r1, r2, r5)
        L_0x00bb:
            r2 = r6[r3]
            android.graphics.drawable.Drawable r3 = r10.endDummyDrawable
            if (r2 == r3) goto L_0x00cf
            r10.originalEditTextEndDrawable = r2
            android.widget.EditText r10 = r10.editText
            r0 = r6[r1]
            r1 = r6[r5]
            r2 = r6[r4]
            androidx.core.widget.TextViewCompat.setCompoundDrawablesRelative(r10, r0, r1, r3, r2)
            goto L_0x00f2
        L_0x00cf:
            r5 = r0
            goto L_0x00f2
        L_0x00d1:
            android.graphics.drawable.Drawable r6 = r10.endDummyDrawable
            if (r6 == 0) goto L_0x00f3
            android.widget.EditText r6 = r10.editText
            android.graphics.drawable.Drawable[] r6 = androidx.core.widget.TextViewCompat.getCompoundDrawablesRelative(r6)
            r3 = r6[r3]
            android.graphics.drawable.Drawable r7 = r10.endDummyDrawable
            if (r3 != r7) goto L_0x00ef
            android.widget.EditText r0 = r10.editText
            r1 = r6[r1]
            r3 = r6[r5]
            android.graphics.drawable.Drawable r7 = r10.originalEditTextEndDrawable
            r4 = r6[r4]
            androidx.core.widget.TextViewCompat.setCompoundDrawablesRelative(r0, r1, r3, r7, r4)
            goto L_0x00f0
        L_0x00ef:
            r5 = r0
        L_0x00f0:
            r10.endDummyDrawable = r2
        L_0x00f2:
            r0 = r5
        L_0x00f3:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.textfield.TextInputLayout.updateDummyDrawables():boolean");
    }

    private boolean shouldUpdateStartDummyDrawable() {
        return !(getStartIconDrawable() == null && this.prefixText == null) && this.startLayout.getMeasuredWidth() > 0;
    }

    private boolean shouldUpdateEndDummyDrawable() {
        return (this.errorIconView.getVisibility() == 0 || ((hasEndIcon() && isEndIconVisible()) || this.suffixText != null)) && this.endLayout.getMeasuredWidth() > 0;
    }

    @Nullable
    private CheckableImageButton getEndIconToUpdateDummyDrawable() {
        if (this.errorIconView.getVisibility() == 0) {
            return this.errorIconView;
        }
        if (!hasEndIcon() || !isEndIconVisible()) {
            return null;
        }
        return this.endIconView;
    }

    private void applyIconTint(@NonNull CheckableImageButton checkableImageButton, ColorStateList colorStateList, PorterDuff.Mode mode) {
        Drawable drawable = checkableImageButton.getDrawable();
        if (drawable != null) {
            drawable = DrawableCompat.wrap(drawable).mutate();
            if (colorStateList == null || !colorStateList.isStateful()) {
                DrawableCompat.setTintList(drawable, colorStateList);
            } else {
                DrawableCompat.setTintList(drawable, ColorStateList.valueOf(colorStateList.getColorForState(mergeIconState(checkableImageButton), colorStateList.getDefaultColor())));
            }
            if (mode != null) {
                DrawableCompat.setTintMode(drawable, mode);
            }
        }
        if (checkableImageButton.getDrawable() != drawable) {
            checkableImageButton.setImageDrawable(drawable);
        }
    }

    private static void setIconOnClickListener(@NonNull CheckableImageButton checkableImageButton, @Nullable View.OnClickListener onClickListener, @Nullable View.OnLongClickListener onLongClickListener) {
        checkableImageButton.setOnClickListener(onClickListener);
        setIconClickable(checkableImageButton, onLongClickListener);
    }

    private static void setIconOnLongClickListener(@NonNull CheckableImageButton checkableImageButton, @Nullable View.OnLongClickListener onLongClickListener) {
        checkableImageButton.setOnLongClickListener(onLongClickListener);
        setIconClickable(checkableImageButton, onLongClickListener);
    }

    private static void setIconClickable(@NonNull CheckableImageButton checkableImageButton, @Nullable View.OnLongClickListener onLongClickListener) {
        boolean hasOnClickListeners = ViewCompat.hasOnClickListeners(checkableImageButton);
        boolean z = false;
        int i = 1;
        boolean z2 = onLongClickListener != null;
        if (hasOnClickListeners || z2) {
            z = true;
        }
        checkableImageButton.setFocusable(z);
        checkableImageButton.setClickable(hasOnClickListeners);
        checkableImageButton.setPressable(hasOnClickListeners);
        checkableImageButton.setLongClickable(z2);
        if (!z) {
            i = 2;
        }
        ViewCompat.setImportantForAccessibility(checkableImageButton, i);
    }

    /* access modifiers changed from: protected */
    public void onLayout(boolean z, int i, int i2, int i3, int i4) {
        super.onLayout(z, i, i2, i3, i4);
        EditText editText2 = this.editText;
        if (editText2 != null) {
            Rect rect = this.tmpRect;
            DescendantOffsetUtils.getDescendantRect(this, editText2, rect);
            updateBoxUnderlineBounds(rect);
            if (this.hintEnabled) {
                this.collapsingTextHelper.setExpandedTextSize(this.editText.getTextSize());
                int gravity = this.editText.getGravity();
                this.collapsingTextHelper.setCollapsedTextGravity((gravity & -113) | 48);
                this.collapsingTextHelper.setExpandedTextGravity(gravity);
                this.collapsingTextHelper.setCollapsedBounds(calculateCollapsedTextBounds(rect));
                this.collapsingTextHelper.setExpandedBounds(calculateExpandedTextBounds(rect));
                this.collapsingTextHelper.recalculate();
                if (cutoutEnabled() && !this.hintExpanded) {
                    openCutout();
                }
            }
        }
    }

    private void updateBoxUnderlineBounds(@NonNull Rect rect) {
        MaterialShapeDrawable materialShapeDrawable = this.boxUnderlineDefault;
        if (materialShapeDrawable != null) {
            int i = rect.bottom;
            materialShapeDrawable.setBounds(rect.left, i - this.boxStrokeWidthDefaultPx, rect.right, i);
        }
        MaterialShapeDrawable materialShapeDrawable2 = this.boxUnderlineFocused;
        if (materialShapeDrawable2 != null) {
            int i2 = rect.bottom;
            materialShapeDrawable2.setBounds(rect.left, i2 - this.boxStrokeWidthFocusedPx, rect.right, i2);
        }
    }

    public void draw(@NonNull Canvas canvas) {
        super.draw(canvas);
        drawHint(canvas);
        drawBoxUnderline(canvas);
    }

    /* access modifiers changed from: protected */
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        this.collapsingTextHelper.maybeUpdateFontWeightAdjustment(configuration);
    }

    private void drawHint(@NonNull Canvas canvas) {
        if (this.hintEnabled) {
            this.collapsingTextHelper.draw(canvas);
        }
    }

    private void drawBoxUnderline(Canvas canvas) {
        MaterialShapeDrawable materialShapeDrawable;
        if (this.boxUnderlineFocused != null && (materialShapeDrawable = this.boxUnderlineDefault) != null) {
            materialShapeDrawable.draw(canvas);
            if (this.editText.isFocused()) {
                Rect bounds = this.boxUnderlineFocused.getBounds();
                Rect bounds2 = this.boxUnderlineDefault.getBounds();
                float expansionFraction = this.collapsingTextHelper.getExpansionFraction();
                int centerX = bounds2.centerX();
                bounds.left = AnimationUtils.lerp(centerX, bounds2.left, expansionFraction);
                bounds.right = AnimationUtils.lerp(centerX, bounds2.right, expansionFraction);
                this.boxUnderlineFocused.draw(canvas);
            }
        }
    }

    private void collapseHint(boolean z) {
        ValueAnimator valueAnimator = this.animator;
        if (valueAnimator != null && valueAnimator.isRunning()) {
            this.animator.cancel();
        }
        if (!z || !this.hintAnimationEnabled) {
            this.collapsingTextHelper.setExpansionFraction(1.0f);
        } else {
            animateToExpansionFraction(1.0f);
        }
        this.hintExpanded = false;
        if (cutoutEnabled()) {
            openCutout();
        }
        updatePlaceholderText();
        updatePrefixTextVisibility();
        updateSuffixTextVisibility();
    }

    private boolean cutoutEnabled() {
        return this.hintEnabled && !TextUtils.isEmpty(this.hint) && (this.boxBackground instanceof CutoutDrawable);
    }

    private void openCutout() {
        if (cutoutEnabled()) {
            RectF rectF = this.tmpRectF;
            this.collapsingTextHelper.getCollapsedTextActualBounds(rectF, this.editText.getWidth(), this.editText.getGravity());
            applyCutoutPadding(rectF);
            rectF.offset((float) (-getPaddingLeft()), (((float) (-getPaddingTop())) - (rectF.height() / 2.0f)) + ((float) this.boxStrokeWidthPx));
            ((CutoutDrawable) this.boxBackground).setCutout(rectF);
        }
    }

    private void recalculateCutout() {
        if (cutoutEnabled() && !this.hintExpanded) {
            closeCutout();
            openCutout();
        }
    }

    private void closeCutout() {
        if (cutoutEnabled()) {
            ((CutoutDrawable) this.boxBackground).removeCutout();
        }
    }

    private void applyCutoutPadding(@NonNull RectF rectF) {
        float f = rectF.left;
        int i = this.boxLabelCutoutPaddingPx;
        rectF.left = f - ((float) i);
        rectF.right += (float) i;
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public boolean cutoutIsOpen() {
        return cutoutEnabled() && ((CutoutDrawable) this.boxBackground).hasCutout();
    }

    /* access modifiers changed from: protected */
    public void drawableStateChanged() {
        if (!this.inDrawableStateChanged) {
            boolean z = true;
            this.inDrawableStateChanged = true;
            super.drawableStateChanged();
            int[] drawableState = getDrawableState();
            CollapsingTextHelper collapsingTextHelper2 = this.collapsingTextHelper;
            boolean state = collapsingTextHelper2 != null ? collapsingTextHelper2.setState(drawableState) | false : false;
            if (this.editText != null) {
                if (!ViewCompat.isLaidOut(this) || !isEnabled()) {
                    z = false;
                }
                updateLabelState(z);
            }
            updateEditTextBackground();
            updateTextInputBoxState();
            if (state) {
                invalidate();
            }
            this.inDrawableStateChanged = false;
        }
    }

    /* access modifiers changed from: package-private */
    /* JADX WARNING: Code restructure failed: missing block: B:6:0x0012, code lost:
        r0 = r5.editText;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void updateTextInputBoxState() {
        /*
            r5 = this;
            com.google.android.material.shape.MaterialShapeDrawable r0 = r5.boxBackground
            if (r0 == 0) goto L_0x00e2
            int r0 = r5.boxBackgroundMode
            if (r0 != 0) goto L_0x000a
            goto L_0x00e2
        L_0x000a:
            boolean r0 = r5.isFocused()
            r1 = 0
            r2 = 1
            if (r0 != 0) goto L_0x001f
            android.widget.EditText r0 = r5.editText
            if (r0 == 0) goto L_0x001d
            boolean r0 = r0.hasFocus()
            if (r0 == 0) goto L_0x001d
            goto L_0x001f
        L_0x001d:
            r0 = r1
            goto L_0x0020
        L_0x001f:
            r0 = r2
        L_0x0020:
            boolean r3 = r5.isHovered()
            if (r3 != 0) goto L_0x0030
            android.widget.EditText r3 = r5.editText
            if (r3 == 0) goto L_0x0031
            boolean r3 = r3.isHovered()
            if (r3 == 0) goto L_0x0031
        L_0x0030:
            r1 = r2
        L_0x0031:
            boolean r3 = r5.isEnabled()
            if (r3 != 0) goto L_0x003c
            int r3 = r5.disabledColor
            r5.boxStrokeColor = r3
            goto L_0x007e
        L_0x003c:
            com.google.android.material.textfield.IndicatorViewController r3 = r5.indicatorViewController
            boolean r3 = r3.errorShouldBeShown()
            if (r3 == 0) goto L_0x0055
            android.content.res.ColorStateList r3 = r5.strokeErrorColor
            if (r3 == 0) goto L_0x004c
            r5.updateStrokeErrorColor(r0, r1)
            goto L_0x007e
        L_0x004c:
            com.google.android.material.textfield.IndicatorViewController r3 = r5.indicatorViewController
            int r3 = r3.getErrorViewCurrentTextColor()
            r5.boxStrokeColor = r3
            goto L_0x007e
        L_0x0055:
            boolean r3 = r5.counterOverflowed
            if (r3 == 0) goto L_0x006c
            android.widget.TextView r3 = r5.counterView
            if (r3 == 0) goto L_0x006c
            android.content.res.ColorStateList r4 = r5.strokeErrorColor
            if (r4 == 0) goto L_0x0065
            r5.updateStrokeErrorColor(r0, r1)
            goto L_0x007e
        L_0x0065:
            int r3 = r3.getCurrentTextColor()
            r5.boxStrokeColor = r3
            goto L_0x007e
        L_0x006c:
            if (r0 == 0) goto L_0x0073
            int r3 = r5.focusedStrokeColor
            r5.boxStrokeColor = r3
            goto L_0x007e
        L_0x0073:
            if (r1 == 0) goto L_0x007a
            int r3 = r5.hoveredStrokeColor
            r5.boxStrokeColor = r3
            goto L_0x007e
        L_0x007a:
            int r3 = r5.defaultStrokeColor
            r5.boxStrokeColor = r3
        L_0x007e:
            r5.updateErrorIconVisibility()
            r5.refreshErrorIconDrawableState()
            r5.refreshStartIconDrawableState()
            r5.refreshEndIconDrawableState()
            com.google.android.material.textfield.EndIconDelegate r3 = r5.getEndIconDelegate()
            boolean r3 = r3.shouldTintIconOnError()
            if (r3 == 0) goto L_0x009d
            com.google.android.material.textfield.IndicatorViewController r3 = r5.indicatorViewController
            boolean r3 = r3.errorShouldBeShown()
            r5.tintEndIconOnError(r3)
        L_0x009d:
            int r3 = r5.boxBackgroundMode
            r4 = 2
            if (r3 != r4) goto L_0x00bc
            int r3 = r5.boxStrokeWidthPx
            if (r0 == 0) goto L_0x00b1
            boolean r4 = r5.isEnabled()
            if (r4 == 0) goto L_0x00b1
            int r4 = r5.boxStrokeWidthFocusedPx
            r5.boxStrokeWidthPx = r4
            goto L_0x00b5
        L_0x00b1:
            int r4 = r5.boxStrokeWidthDefaultPx
            r5.boxStrokeWidthPx = r4
        L_0x00b5:
            int r4 = r5.boxStrokeWidthPx
            if (r4 == r3) goto L_0x00bc
            r5.recalculateCutout()
        L_0x00bc:
            int r3 = r5.boxBackgroundMode
            if (r3 != r2) goto L_0x00df
            boolean r2 = r5.isEnabled()
            if (r2 != 0) goto L_0x00cb
            int r0 = r5.disabledFilledBackgroundColor
            r5.boxBackgroundColor = r0
            goto L_0x00df
        L_0x00cb:
            if (r1 == 0) goto L_0x00d4
            if (r0 != 0) goto L_0x00d4
            int r0 = r5.hoveredFilledBackgroundColor
            r5.boxBackgroundColor = r0
            goto L_0x00df
        L_0x00d4:
            if (r0 == 0) goto L_0x00db
            int r0 = r5.focusedFilledBackgroundColor
            r5.boxBackgroundColor = r0
            goto L_0x00df
        L_0x00db:
            int r0 = r5.defaultFilledBackgroundColor
            r5.boxBackgroundColor = r0
        L_0x00df:
            r5.applyBoxAttributes()
        L_0x00e2:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.textfield.TextInputLayout.updateTextInputBoxState():void");
    }

    private void updateStrokeErrorColor(boolean z, boolean z2) {
        int defaultColor = this.strokeErrorColor.getDefaultColor();
        int colorForState = this.strokeErrorColor.getColorForState(new int[]{16843623, 16842910}, defaultColor);
        int colorForState2 = this.strokeErrorColor.getColorForState(new int[]{16843518, 16842910}, defaultColor);
        if (z) {
            this.boxStrokeColor = colorForState2;
        } else if (z2) {
            this.boxStrokeColor = colorForState;
        } else {
            this.boxStrokeColor = defaultColor;
        }
    }

    private void updateErrorIconVisibility() {
        int i = 0;
        boolean z = getErrorIconDrawable() != null && this.indicatorViewController.isErrorEnabled() && this.indicatorViewController.errorShouldBeShown();
        CheckableImageButton checkableImageButton = this.errorIconView;
        if (!z) {
            i = 8;
        }
        checkableImageButton.setVisibility(i);
        updateEndLayoutVisibility();
        updateSuffixTextViewPadding();
        if (!hasEndIcon()) {
            updateDummyDrawables();
        }
    }

    private boolean isErrorIconVisible() {
        return this.errorIconView.getVisibility() == 0;
    }

    private void refreshIconDrawableState(CheckableImageButton checkableImageButton, ColorStateList colorStateList) {
        Drawable drawable = checkableImageButton.getDrawable();
        if (checkableImageButton.getDrawable() != null && colorStateList != null && colorStateList.isStateful()) {
            int colorForState = colorStateList.getColorForState(mergeIconState(checkableImageButton), colorStateList.getDefaultColor());
            Drawable mutate = DrawableCompat.wrap(drawable).mutate();
            DrawableCompat.setTintList(mutate, ColorStateList.valueOf(colorForState));
            checkableImageButton.setImageDrawable(mutate);
        }
    }

    private int[] mergeIconState(CheckableImageButton checkableImageButton) {
        int[] drawableState = getDrawableState();
        int[] drawableState2 = checkableImageButton.getDrawableState();
        int length = drawableState.length;
        int[] copyOf = Arrays.copyOf(drawableState, drawableState.length + drawableState2.length);
        System.arraycopy(drawableState2, 0, copyOf, length, drawableState2.length);
        return copyOf;
    }

    private void expandHint(boolean z) {
        ValueAnimator valueAnimator = this.animator;
        if (valueAnimator != null && valueAnimator.isRunning()) {
            this.animator.cancel();
        }
        if (!z || !this.hintAnimationEnabled) {
            this.collapsingTextHelper.setExpansionFraction(0.0f);
        } else {
            animateToExpansionFraction(0.0f);
        }
        if (cutoutEnabled() && ((CutoutDrawable) this.boxBackground).hasCutout()) {
            closeCutout();
        }
        this.hintExpanded = true;
        hidePlaceholderText();
        updatePrefixTextVisibility();
        updateSuffixTextVisibility();
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public void animateToExpansionFraction(float f) {
        if (this.collapsingTextHelper.getExpansionFraction() != f) {
            if (this.animator == null) {
                ValueAnimator valueAnimator = new ValueAnimator();
                this.animator = valueAnimator;
                valueAnimator.setInterpolator(AnimationUtils.FAST_OUT_SLOW_IN_INTERPOLATOR);
                this.animator.setDuration(167);
                this.animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                    public void onAnimationUpdate(@NonNull ValueAnimator valueAnimator) {
                        TextInputLayout.this.collapsingTextHelper.setExpansionFraction(((Float) valueAnimator.getAnimatedValue()).floatValue());
                    }
                });
            }
            this.animator.setFloatValues(new float[]{this.collapsingTextHelper.getExpansionFraction(), f});
            this.animator.start();
        }
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public final boolean isHintExpanded() {
        return this.hintExpanded;
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public final boolean isHelperTextDisplayed() {
        return this.indicatorViewController.helperTextIsDisplayed();
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public final int getHintCurrentCollapsedTextColor() {
        return this.collapsingTextHelper.getCurrentCollapsedTextColor();
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public final float getHintCollapsedTextHeight() {
        return this.collapsingTextHelper.getCollapsedTextHeight();
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public final int getErrorTextCurrentColor() {
        return this.indicatorViewController.getErrorViewCurrentTextColor();
    }

    public static class AccessibilityDelegate extends AccessibilityDelegateCompat {
        private final TextInputLayout layout;

        public AccessibilityDelegate(@NonNull TextInputLayout textInputLayout) {
            this.layout = textInputLayout;
        }

        public void onInitializeAccessibilityNodeInfo(@NonNull View view, @NonNull AccessibilityNodeInfoCompat accessibilityNodeInfoCompat) {
            super.onInitializeAccessibilityNodeInfo(view, accessibilityNodeInfoCompat);
            EditText editText = this.layout.getEditText();
            Editable text = editText != null ? editText.getText() : null;
            CharSequence hint = this.layout.getHint();
            CharSequence error = this.layout.getError();
            CharSequence placeholderText = this.layout.getPlaceholderText();
            int counterMaxLength = this.layout.getCounterMaxLength();
            CharSequence counterOverflowDescription = this.layout.getCounterOverflowDescription();
            boolean z = !TextUtils.isEmpty(text);
            boolean z2 = !TextUtils.isEmpty(hint);
            boolean z3 = !this.layout.isHintExpanded();
            boolean z4 = !TextUtils.isEmpty(error);
            boolean z5 = false;
            boolean z6 = z4 || !TextUtils.isEmpty(counterOverflowDescription);
            if (this.layout.getPrefixTextView().getVisibility() == 0) {
                z5 = true;
            }
            String charSequence = z2 ? hint.toString() : "";
            if (z5) {
                accessibilityNodeInfoCompat.setLabelFor(this.layout.getPrefixTextView());
                accessibilityNodeInfoCompat.setTraversalAfter(this.layout.getPrefixTextView());
            } else {
                accessibilityNodeInfoCompat.setTraversalAfter(this.layout.startIconView);
            }
            if (z) {
                accessibilityNodeInfoCompat.setText(text);
            } else if (!TextUtils.isEmpty(charSequence)) {
                accessibilityNodeInfoCompat.setText(charSequence);
                if (z3 && placeholderText != null) {
                    accessibilityNodeInfoCompat.setText(charSequence + ", " + placeholderText);
                }
            } else if (placeholderText != null) {
                accessibilityNodeInfoCompat.setText(placeholderText);
            }
            if (!TextUtils.isEmpty(charSequence)) {
                accessibilityNodeInfoCompat.setHintText(charSequence);
                accessibilityNodeInfoCompat.setShowingHintText(!z);
            }
            if (text == null || text.length() != counterMaxLength) {
                counterMaxLength = -1;
            }
            accessibilityNodeInfoCompat.setMaxTextLength(counterMaxLength);
            if (z6) {
                if (!z4) {
                    error = counterOverflowDescription;
                }
                accessibilityNodeInfoCompat.setError(error);
            }
            View helperTextView = this.layout.indicatorViewController.getHelperTextView();
            if (helperTextView != null) {
                accessibilityNodeInfoCompat.setLabelFor(helperTextView);
            }
        }
    }
}
