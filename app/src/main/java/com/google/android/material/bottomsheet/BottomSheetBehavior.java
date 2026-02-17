package com.google.android.material.bottomsheet;

import android.animation.ValueAnimator;
import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.util.Log;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.view.ViewParent;
import androidx.annotation.FloatRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.Px;
import androidx.annotation.RestrictTo;
import androidx.annotation.StringRes;
import androidx.annotation.VisibleForTesting;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import androidx.core.graphics.Insets;
import androidx.core.math.MathUtils;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat;
import androidx.core.view.accessibility.AccessibilityViewCommand;
import androidx.customview.view.AbsSavedState;
import androidx.customview.widget.ViewDragHelper;
import com.google.android.material.R;
import com.google.android.material.internal.ViewUtils;
import com.google.android.material.resources.MaterialResources;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.ShapeAppearanceModel;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class BottomSheetBehavior<V extends View> extends CoordinatorLayout.Behavior<V> {
    private static final int CORNER_ANIMATION_DURATION = 500;
    private static final int DEF_STYLE_RES = R.style.Widget_Design_BottomSheet_Modal;
    private static final float HIDE_FRICTION = 0.1f;
    private static final float HIDE_THRESHOLD = 0.5f;
    private static final int NO_MAX_SIZE = -1;
    public static final int PEEK_HEIGHT_AUTO = -1;
    public static final int SAVE_ALL = -1;
    public static final int SAVE_FIT_TO_CONTENTS = 2;
    public static final int SAVE_HIDEABLE = 4;
    public static final int SAVE_NONE = 0;
    public static final int SAVE_PEEK_HEIGHT = 1;
    public static final int SAVE_SKIP_COLLAPSED = 8;
    private static final int SIGNIFICANT_VEL_THRESHOLD = 500;
    public static final int STATE_COLLAPSED = 4;
    public static final int STATE_DRAGGING = 1;
    public static final int STATE_EXPANDED = 3;
    public static final int STATE_HALF_EXPANDED = 6;
    public static final int STATE_HIDDEN = 5;
    public static final int STATE_SETTLING = 2;
    private static final String TAG = "BottomSheetBehavior";
    int activePointerId;
    @Nullable
    private ColorStateList backgroundTint;
    @NonNull
    private final ArrayList<BottomSheetCallback> callbacks = new ArrayList<>();
    private int childHeight;
    int collapsedOffset;
    private final ViewDragHelper.Callback dragCallback = new ViewDragHelper.Callback() {
        private long viewCapturedMillis;

        public boolean tryCaptureView(@NonNull View view, int i) {
            BottomSheetBehavior bottomSheetBehavior = BottomSheetBehavior.this;
            int i2 = bottomSheetBehavior.state;
            if (i2 == 1 || bottomSheetBehavior.touchingScrollingChild) {
                return false;
            }
            if (i2 == 3 && bottomSheetBehavior.activePointerId == i) {
                WeakReference<View> weakReference = bottomSheetBehavior.nestedScrollingChildRef;
                View view2 = weakReference != null ? (View) weakReference.get() : null;
                if (view2 != null && view2.canScrollVertically(-1)) {
                    return false;
                }
            }
            this.viewCapturedMillis = System.currentTimeMillis();
            WeakReference<V> weakReference2 = BottomSheetBehavior.this.viewRef;
            if (weakReference2 == null || weakReference2.get() != view) {
                return false;
            }
            return true;
        }

        public void onViewPositionChanged(@NonNull View view, int i, int i2, int i3, int i4) {
            BottomSheetBehavior.this.dispatchOnSlide(i2);
        }

        public void onViewDragStateChanged(int i) {
            if (i == 1 && BottomSheetBehavior.this.draggable) {
                BottomSheetBehavior.this.setStateInternal(1);
            }
        }

        private boolean releasedLow(@NonNull View view) {
            int top = view.getTop();
            BottomSheetBehavior bottomSheetBehavior = BottomSheetBehavior.this;
            return top > (bottomSheetBehavior.parentHeight + bottomSheetBehavior.getExpandedOffset()) / 2;
        }

        public void onViewReleased(@NonNull View view, float f, float f2) {
            int i;
            int i2;
            int i3 = 6;
            if (f2 >= 0.0f) {
                BottomSheetBehavior bottomSheetBehavior = BottomSheetBehavior.this;
                if (!bottomSheetBehavior.hideable || !bottomSheetBehavior.shouldHide(view, f2)) {
                    if (f2 == 0.0f || Math.abs(f) > Math.abs(f2)) {
                        int top = view.getTop();
                        if (!BottomSheetBehavior.this.fitToContents) {
                            BottomSheetBehavior bottomSheetBehavior2 = BottomSheetBehavior.this;
                            int i4 = bottomSheetBehavior2.halfExpandedOffset;
                            if (top >= i4) {
                                if (Math.abs(top - i4) >= Math.abs(top - BottomSheetBehavior.this.collapsedOffset)) {
                                    i2 = BottomSheetBehavior.this.collapsedOffset;
                                } else if (BottomSheetBehavior.this.shouldSkipHalfExpandedStateWhenDragging()) {
                                    i2 = BottomSheetBehavior.this.collapsedOffset;
                                } else {
                                    i = BottomSheetBehavior.this.halfExpandedOffset;
                                    BottomSheetBehavior bottomSheetBehavior3 = BottomSheetBehavior.this;
                                    bottomSheetBehavior3.startSettlingAnimation(view, i3, i, bottomSheetBehavior3.shouldSkipSmoothAnimation());
                                }
                                i3 = 4;
                                BottomSheetBehavior bottomSheetBehavior32 = BottomSheetBehavior.this;
                                bottomSheetBehavior32.startSettlingAnimation(view, i3, i, bottomSheetBehavior32.shouldSkipSmoothAnimation());
                            } else if (top < Math.abs(top - bottomSheetBehavior2.collapsedOffset)) {
                                i = BottomSheetBehavior.this.getExpandedOffset();
                            } else if (BottomSheetBehavior.this.shouldSkipHalfExpandedStateWhenDragging()) {
                                i2 = BottomSheetBehavior.this.collapsedOffset;
                                i3 = 4;
                                BottomSheetBehavior bottomSheetBehavior322 = BottomSheetBehavior.this;
                                bottomSheetBehavior322.startSettlingAnimation(view, i3, i, bottomSheetBehavior322.shouldSkipSmoothAnimation());
                            } else {
                                i = BottomSheetBehavior.this.halfExpandedOffset;
                                BottomSheetBehavior bottomSheetBehavior3222 = BottomSheetBehavior.this;
                                bottomSheetBehavior3222.startSettlingAnimation(view, i3, i, bottomSheetBehavior3222.shouldSkipSmoothAnimation());
                            }
                        } else if (Math.abs(top - BottomSheetBehavior.this.fitToContentsOffset) < Math.abs(top - BottomSheetBehavior.this.collapsedOffset)) {
                            i = BottomSheetBehavior.this.fitToContentsOffset;
                        } else {
                            i2 = BottomSheetBehavior.this.collapsedOffset;
                            i3 = 4;
                            BottomSheetBehavior bottomSheetBehavior32222 = BottomSheetBehavior.this;
                            bottomSheetBehavior32222.startSettlingAnimation(view, i3, i, bottomSheetBehavior32222.shouldSkipSmoothAnimation());
                        }
                    } else {
                        if (BottomSheetBehavior.this.fitToContents) {
                            i2 = BottomSheetBehavior.this.collapsedOffset;
                        } else {
                            int top2 = view.getTop();
                            if (Math.abs(top2 - BottomSheetBehavior.this.halfExpandedOffset) >= Math.abs(top2 - BottomSheetBehavior.this.collapsedOffset)) {
                                i2 = BottomSheetBehavior.this.collapsedOffset;
                            } else if (BottomSheetBehavior.this.shouldSkipHalfExpandedStateWhenDragging()) {
                                i2 = BottomSheetBehavior.this.collapsedOffset;
                            } else {
                                i = BottomSheetBehavior.this.halfExpandedOffset;
                                BottomSheetBehavior bottomSheetBehavior322222 = BottomSheetBehavior.this;
                                bottomSheetBehavior322222.startSettlingAnimation(view, i3, i, bottomSheetBehavior322222.shouldSkipSmoothAnimation());
                            }
                        }
                        i3 = 4;
                        BottomSheetBehavior bottomSheetBehavior3222222 = BottomSheetBehavior.this;
                        bottomSheetBehavior3222222.startSettlingAnimation(view, i3, i, bottomSheetBehavior3222222.shouldSkipSmoothAnimation());
                    }
                } else if ((Math.abs(f) < Math.abs(f2) && f2 > 500.0f) || releasedLow(view)) {
                    i = BottomSheetBehavior.this.parentHeight;
                    i3 = 5;
                    BottomSheetBehavior bottomSheetBehavior32222222 = BottomSheetBehavior.this;
                    bottomSheetBehavior32222222.startSettlingAnimation(view, i3, i, bottomSheetBehavior32222222.shouldSkipSmoothAnimation());
                } else if (BottomSheetBehavior.this.fitToContents) {
                    i = BottomSheetBehavior.this.fitToContentsOffset;
                } else if (Math.abs(view.getTop() - BottomSheetBehavior.this.getExpandedOffset()) < Math.abs(view.getTop() - BottomSheetBehavior.this.halfExpandedOffset)) {
                    i = BottomSheetBehavior.this.getExpandedOffset();
                } else {
                    i = BottomSheetBehavior.this.halfExpandedOffset;
                    BottomSheetBehavior bottomSheetBehavior322222222 = BottomSheetBehavior.this;
                    bottomSheetBehavior322222222.startSettlingAnimation(view, i3, i, bottomSheetBehavior322222222.shouldSkipSmoothAnimation());
                }
            } else if (BottomSheetBehavior.this.fitToContents) {
                i = BottomSheetBehavior.this.fitToContentsOffset;
            } else {
                int top3 = view.getTop();
                long currentTimeMillis = System.currentTimeMillis() - this.viewCapturedMillis;
                if (BottomSheetBehavior.this.shouldSkipHalfExpandedStateWhenDragging()) {
                    BottomSheetBehavior bottomSheetBehavior4 = BottomSheetBehavior.this;
                    if (bottomSheetBehavior4.shouldExpandOnUpwardDrag(currentTimeMillis, (((float) top3) * 100.0f) / ((float) bottomSheetBehavior4.parentHeight))) {
                        i = BottomSheetBehavior.this.expandedOffset;
                    } else {
                        i2 = BottomSheetBehavior.this.collapsedOffset;
                        i3 = 4;
                        BottomSheetBehavior bottomSheetBehavior3222222222 = BottomSheetBehavior.this;
                        bottomSheetBehavior3222222222.startSettlingAnimation(view, i3, i, bottomSheetBehavior3222222222.shouldSkipSmoothAnimation());
                    }
                } else {
                    BottomSheetBehavior bottomSheetBehavior5 = BottomSheetBehavior.this;
                    int i5 = bottomSheetBehavior5.halfExpandedOffset;
                    if (top3 > i5) {
                        i = i5;
                        BottomSheetBehavior bottomSheetBehavior32222222222 = BottomSheetBehavior.this;
                        bottomSheetBehavior32222222222.startSettlingAnimation(view, i3, i, bottomSheetBehavior32222222222.shouldSkipSmoothAnimation());
                    }
                    i = bottomSheetBehavior5.getExpandedOffset();
                }
            }
            i3 = 3;
            BottomSheetBehavior bottomSheetBehavior322222222222 = BottomSheetBehavior.this;
            bottomSheetBehavior322222222222.startSettlingAnimation(view, i3, i, bottomSheetBehavior322222222222.shouldSkipSmoothAnimation());
        }

        public int clampViewPositionVertical(@NonNull View view, int i, int i2) {
            int expandedOffset = BottomSheetBehavior.this.getExpandedOffset();
            BottomSheetBehavior bottomSheetBehavior = BottomSheetBehavior.this;
            return MathUtils.clamp(i, expandedOffset, bottomSheetBehavior.hideable ? bottomSheetBehavior.parentHeight : bottomSheetBehavior.collapsedOffset);
        }

        public int clampViewPositionHorizontal(@NonNull View view, int i, int i2) {
            return view.getLeft();
        }

        public int getViewVerticalDragRange(@NonNull View view) {
            BottomSheetBehavior bottomSheetBehavior = BottomSheetBehavior.this;
            if (bottomSheetBehavior.hideable) {
                return bottomSheetBehavior.parentHeight;
            }
            return bottomSheetBehavior.collapsedOffset;
        }
    };
    /* access modifiers changed from: private */
    public boolean draggable = true;
    float elevation = -1.0f;
    private int expandHalfwayActionId = -1;
    int expandedOffset;
    /* access modifiers changed from: private */
    public boolean fitToContents = true;
    int fitToContentsOffset;
    /* access modifiers changed from: private */
    public int gestureInsetBottom;
    private boolean gestureInsetBottomIgnored;
    int halfExpandedOffset;
    float halfExpandedRatio = 0.5f;
    boolean hideable;
    private boolean ignoreEvents;
    @Nullable
    private Map<View, Integer> importantForAccessibilityMap;
    private int initialY;
    /* access modifiers changed from: private */
    public int insetBottom;
    /* access modifiers changed from: private */
    public int insetTop;
    @Nullable
    private ValueAnimator interpolatorAnimator;
    private boolean isShapeExpanded;
    private int lastNestedScrollDy;
    int lastStableState = 4;
    /* access modifiers changed from: private */
    public boolean marginLeftSystemWindowInsets;
    /* access modifiers changed from: private */
    public boolean marginRightSystemWindowInsets;
    /* access modifiers changed from: private */
    public boolean marginTopSystemWindowInsets;
    /* access modifiers changed from: private */
    public MaterialShapeDrawable materialShapeDrawable;
    private int maxHeight = -1;
    private int maxWidth = -1;
    private float maximumVelocity;
    private boolean nestedScrolled;
    @Nullable
    WeakReference<View> nestedScrollingChildRef;
    /* access modifiers changed from: private */
    public boolean paddingBottomSystemWindowInsets;
    /* access modifiers changed from: private */
    public boolean paddingLeftSystemWindowInsets;
    /* access modifiers changed from: private */
    public boolean paddingRightSystemWindowInsets;
    private boolean paddingTopSystemWindowInsets;
    int parentHeight;
    int parentWidth;
    /* access modifiers changed from: private */
    public int peekHeight;
    private boolean peekHeightAuto;
    private int peekHeightGestureInsetBuffer;
    private int peekHeightMin;
    private int saveFlags = 0;
    private BottomSheetBehavior<V>.SettleRunnable settleRunnable = null;
    private ShapeAppearanceModel shapeAppearanceModelDefault;
    /* access modifiers changed from: private */
    public boolean skipCollapsed;
    int state = 4;
    boolean touchingScrollingChild;
    private boolean updateImportantForAccessibilityOnSiblings = false;
    @Nullable
    private VelocityTracker velocityTracker;
    @Nullable
    ViewDragHelper viewDragHelper;
    @Nullable
    WeakReference<V> viewRef;

    public static abstract class BottomSheetCallback {
        /* access modifiers changed from: package-private */
        public void onLayout(@NonNull View view) {
        }

        public abstract void onSlide(@NonNull View view, float f);

        public abstract void onStateChanged(@NonNull View view, int i);
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    @Retention(RetentionPolicy.SOURCE)
    public @interface SaveFlags {
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    @Retention(RetentionPolicy.SOURCE)
    public @interface State {
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public boolean isNestedScrollingCheckEnabled() {
        return true;
    }

    public void onNestedScroll(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, @NonNull View view, int i, int i2, int i3, int i4, int i5, @NonNull int[] iArr) {
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public boolean shouldExpandOnUpwardDrag(long j, @FloatRange(from = 0.0d, to = 100.0d) float f) {
        return false;
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public boolean shouldSkipHalfExpandedStateWhenDragging() {
        return false;
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public boolean shouldSkipSmoothAnimation() {
        return true;
    }

    public BottomSheetBehavior() {
    }

    public BottomSheetBehavior(@NonNull Context context, @Nullable AttributeSet attributeSet) {
        super(context, attributeSet);
        int i;
        this.peekHeightGestureInsetBuffer = context.getResources().getDimensionPixelSize(R.dimen.mtrl_min_touch_target_size);
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.BottomSheetBehavior_Layout);
        int i2 = R.styleable.BottomSheetBehavior_Layout_backgroundTint;
        if (obtainStyledAttributes.hasValue(i2)) {
            this.backgroundTint = MaterialResources.getColorStateList(context, obtainStyledAttributes, i2);
        }
        if (obtainStyledAttributes.hasValue(R.styleable.BottomSheetBehavior_Layout_shapeAppearance)) {
            this.shapeAppearanceModelDefault = ShapeAppearanceModel.builder(context, attributeSet, R.attr.bottomSheetStyle, DEF_STYLE_RES).build();
        }
        createMaterialShapeDrawableIfNeeded(context);
        createShapeValueAnimator();
        this.elevation = obtainStyledAttributes.getDimension(R.styleable.BottomSheetBehavior_Layout_android_elevation, -1.0f);
        int i3 = R.styleable.BottomSheetBehavior_Layout_android_maxWidth;
        if (obtainStyledAttributes.hasValue(i3)) {
            setMaxWidth(obtainStyledAttributes.getDimensionPixelSize(i3, -1));
        }
        int i4 = R.styleable.BottomSheetBehavior_Layout_android_maxHeight;
        if (obtainStyledAttributes.hasValue(i4)) {
            setMaxHeight(obtainStyledAttributes.getDimensionPixelSize(i4, -1));
        }
        int i5 = R.styleable.BottomSheetBehavior_Layout_behavior_peekHeight;
        TypedValue peekValue = obtainStyledAttributes.peekValue(i5);
        if (peekValue == null || (i = peekValue.data) != -1) {
            setPeekHeight(obtainStyledAttributes.getDimensionPixelSize(i5, -1));
        } else {
            setPeekHeight(i);
        }
        setHideable(obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_behavior_hideable, false));
        setGestureInsetBottomIgnored(obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_gestureInsetBottomIgnored, false));
        setFitToContents(obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_behavior_fitToContents, true));
        setSkipCollapsed(obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_behavior_skipCollapsed, false));
        setDraggable(obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_behavior_draggable, true));
        setSaveFlags(obtainStyledAttributes.getInt(R.styleable.BottomSheetBehavior_Layout_behavior_saveFlags, 0));
        setHalfExpandedRatio(obtainStyledAttributes.getFloat(R.styleable.BottomSheetBehavior_Layout_behavior_halfExpandedRatio, 0.5f));
        int i6 = R.styleable.BottomSheetBehavior_Layout_behavior_expandedOffset;
        TypedValue peekValue2 = obtainStyledAttributes.peekValue(i6);
        if (peekValue2 == null || peekValue2.type != 16) {
            setExpandedOffset(obtainStyledAttributes.getDimensionPixelOffset(i6, 0));
        } else {
            setExpandedOffset(peekValue2.data);
        }
        this.paddingBottomSystemWindowInsets = obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_paddingBottomSystemWindowInsets, false);
        this.paddingLeftSystemWindowInsets = obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_paddingLeftSystemWindowInsets, false);
        this.paddingRightSystemWindowInsets = obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_paddingRightSystemWindowInsets, false);
        this.paddingTopSystemWindowInsets = obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_paddingTopSystemWindowInsets, true);
        this.marginLeftSystemWindowInsets = obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_marginLeftSystemWindowInsets, false);
        this.marginRightSystemWindowInsets = obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_marginRightSystemWindowInsets, false);
        this.marginTopSystemWindowInsets = obtainStyledAttributes.getBoolean(R.styleable.BottomSheetBehavior_Layout_marginTopSystemWindowInsets, false);
        obtainStyledAttributes.recycle();
        this.maximumVelocity = (float) ViewConfiguration.get(context).getScaledMaximumFlingVelocity();
    }

    @NonNull
    public Parcelable onSaveInstanceState(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v) {
        return new SavedState(super.onSaveInstanceState(coordinatorLayout, v), (BottomSheetBehavior<?>) this);
    }

    public void onRestoreInstanceState(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, @NonNull Parcelable parcelable) {
        SavedState savedState = (SavedState) parcelable;
        super.onRestoreInstanceState(coordinatorLayout, v, savedState.getSuperState());
        restoreOptionalState(savedState);
        int i = savedState.state;
        if (i == 1 || i == 2) {
            this.state = 4;
            this.lastStableState = 4;
            return;
        }
        this.state = i;
        this.lastStableState = i;
    }

    public void onAttachedToLayoutParams(@NonNull CoordinatorLayout.LayoutParams layoutParams) {
        super.onAttachedToLayoutParams(layoutParams);
        this.viewRef = null;
        this.viewDragHelper = null;
    }

    public void onDetachedFromLayoutParams() {
        super.onDetachedFromLayoutParams();
        this.viewRef = null;
        this.viewDragHelper = null;
    }

    public boolean onMeasureChild(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, int i, int i2, int i3, int i4) {
        ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) v.getLayoutParams();
        v.measure(getChildMeasureSpec(i, coordinatorLayout.getPaddingLeft() + coordinatorLayout.getPaddingRight() + marginLayoutParams.leftMargin + marginLayoutParams.rightMargin + i2, this.maxWidth, marginLayoutParams.width), getChildMeasureSpec(i3, coordinatorLayout.getPaddingTop() + coordinatorLayout.getPaddingBottom() + marginLayoutParams.topMargin + marginLayoutParams.bottomMargin + i4, this.maxHeight, marginLayoutParams.height));
        return true;
    }

    private int getChildMeasureSpec(int i, int i2, int i3, int i4) {
        int childMeasureSpec = ViewGroup.getChildMeasureSpec(i, i2, i4);
        if (i3 == -1) {
            return childMeasureSpec;
        }
        int mode = View.MeasureSpec.getMode(childMeasureSpec);
        int size = View.MeasureSpec.getSize(childMeasureSpec);
        if (mode == 1073741824) {
            return View.MeasureSpec.makeMeasureSpec(Math.min(size, i3), 1073741824);
        }
        if (size != 0) {
            i3 = Math.min(size, i3);
        }
        return View.MeasureSpec.makeMeasureSpec(i3, Integer.MIN_VALUE);
    }

    public boolean onLayoutChild(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, int i) {
        if (ViewCompat.getFitsSystemWindows(coordinatorLayout) && !ViewCompat.getFitsSystemWindows(v)) {
            v.setFitsSystemWindows(true);
        }
        if (this.viewRef == null) {
            this.peekHeightMin = coordinatorLayout.getResources().getDimensionPixelSize(R.dimen.design_bottom_sheet_peek_height_min);
            setWindowInsetsListener(v);
            this.viewRef = new WeakReference<>(v);
            MaterialShapeDrawable materialShapeDrawable2 = this.materialShapeDrawable;
            if (materialShapeDrawable2 != null) {
                ViewCompat.setBackground(v, materialShapeDrawable2);
                MaterialShapeDrawable materialShapeDrawable3 = this.materialShapeDrawable;
                float f = this.elevation;
                if (f == -1.0f) {
                    f = ViewCompat.getElevation(v);
                }
                materialShapeDrawable3.setElevation(f);
                boolean z = this.state == 3;
                this.isShapeExpanded = z;
                this.materialShapeDrawable.setInterpolation(z ? 0.0f : 1.0f);
            } else {
                ColorStateList colorStateList = this.backgroundTint;
                if (colorStateList != null) {
                    ViewCompat.setBackgroundTintList(v, colorStateList);
                }
            }
            updateAccessibilityActions();
            if (ViewCompat.getImportantForAccessibility(v) == 0) {
                ViewCompat.setImportantForAccessibility(v, 1);
            }
        }
        if (this.viewDragHelper == null) {
            this.viewDragHelper = ViewDragHelper.create(coordinatorLayout, this.dragCallback);
        }
        int top = v.getTop();
        coordinatorLayout.onLayoutChild(v, i);
        this.parentWidth = coordinatorLayout.getWidth();
        this.parentHeight = coordinatorLayout.getHeight();
        int height = v.getHeight();
        this.childHeight = height;
        int i2 = this.parentHeight;
        int i3 = i2 - height;
        int i4 = this.insetTop;
        if (i3 < i4) {
            if (this.paddingTopSystemWindowInsets) {
                this.childHeight = i2;
            } else {
                this.childHeight = i2 - i4;
            }
        }
        this.fitToContentsOffset = Math.max(0, i2 - this.childHeight);
        calculateHalfExpandedOffset();
        calculateCollapsedOffset();
        int i5 = this.state;
        if (i5 == 3) {
            ViewCompat.offsetTopAndBottom(v, getExpandedOffset());
        } else if (i5 == 6) {
            ViewCompat.offsetTopAndBottom(v, this.halfExpandedOffset);
        } else if (this.hideable && i5 == 5) {
            ViewCompat.offsetTopAndBottom(v, this.parentHeight);
        } else if (i5 == 4) {
            ViewCompat.offsetTopAndBottom(v, this.collapsedOffset);
        } else if (i5 == 1 || i5 == 2) {
            ViewCompat.offsetTopAndBottom(v, top - v.getTop());
        }
        this.nestedScrollingChildRef = new WeakReference<>(findScrollingChild(v));
        for (int i6 = 0; i6 < this.callbacks.size(); i6++) {
            this.callbacks.get(i6).onLayout(v);
        }
        return true;
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r11v8, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v4, resolved type: android.view.View} */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean onInterceptTouchEvent(@androidx.annotation.NonNull androidx.coordinatorlayout.widget.CoordinatorLayout r10, @androidx.annotation.NonNull V r11, @androidx.annotation.NonNull android.view.MotionEvent r12) {
        /*
            r9 = this;
            boolean r0 = r11.isShown()
            r1 = 0
            r2 = 1
            if (r0 == 0) goto L_0x00d2
            boolean r0 = r9.draggable
            if (r0 != 0) goto L_0x000e
            goto L_0x00d2
        L_0x000e:
            int r0 = r12.getActionMasked()
            if (r0 != 0) goto L_0x0017
            r9.reset()
        L_0x0017:
            android.view.VelocityTracker r3 = r9.velocityTracker
            if (r3 != 0) goto L_0x0021
            android.view.VelocityTracker r3 = android.view.VelocityTracker.obtain()
            r9.velocityTracker = r3
        L_0x0021:
            android.view.VelocityTracker r3 = r9.velocityTracker
            r3.addMovement(r12)
            r3 = 0
            r4 = -1
            r5 = 2
            if (r0 == 0) goto L_0x003c
            if (r0 == r2) goto L_0x0031
            r11 = 3
            if (r0 == r11) goto L_0x0031
            goto L_0x007f
        L_0x0031:
            r9.touchingScrollingChild = r1
            r9.activePointerId = r4
            boolean r11 = r9.ignoreEvents
            if (r11 == 0) goto L_0x007f
            r9.ignoreEvents = r1
            return r1
        L_0x003c:
            float r6 = r12.getX()
            int r6 = (int) r6
            float r7 = r12.getY()
            int r7 = (int) r7
            r9.initialY = r7
            int r7 = r9.state
            if (r7 == r5) goto L_0x006e
            java.lang.ref.WeakReference<android.view.View> r7 = r9.nestedScrollingChildRef
            if (r7 == 0) goto L_0x0057
            java.lang.Object r7 = r7.get()
            android.view.View r7 = (android.view.View) r7
            goto L_0x0058
        L_0x0057:
            r7 = r3
        L_0x0058:
            if (r7 == 0) goto L_0x006e
            int r8 = r9.initialY
            boolean r7 = r10.isPointInChildBounds(r7, r6, r8)
            if (r7 == 0) goto L_0x006e
            int r7 = r12.getActionIndex()
            int r7 = r12.getPointerId(r7)
            r9.activePointerId = r7
            r9.touchingScrollingChild = r2
        L_0x006e:
            int r7 = r9.activePointerId
            if (r7 != r4) goto L_0x007c
            int r4 = r9.initialY
            boolean r11 = r10.isPointInChildBounds(r11, r6, r4)
            if (r11 != 0) goto L_0x007c
            r11 = r2
            goto L_0x007d
        L_0x007c:
            r11 = r1
        L_0x007d:
            r9.ignoreEvents = r11
        L_0x007f:
            boolean r11 = r9.ignoreEvents
            if (r11 != 0) goto L_0x008e
            androidx.customview.widget.ViewDragHelper r11 = r9.viewDragHelper
            if (r11 == 0) goto L_0x008e
            boolean r11 = r11.shouldInterceptTouchEvent(r12)
            if (r11 == 0) goto L_0x008e
            return r2
        L_0x008e:
            java.lang.ref.WeakReference<android.view.View> r11 = r9.nestedScrollingChildRef
            if (r11 == 0) goto L_0x0099
            java.lang.Object r11 = r11.get()
            r3 = r11
            android.view.View r3 = (android.view.View) r3
        L_0x0099:
            if (r0 != r5) goto L_0x00d1
            if (r3 == 0) goto L_0x00d1
            boolean r11 = r9.ignoreEvents
            if (r11 != 0) goto L_0x00d1
            int r11 = r9.state
            if (r11 == r2) goto L_0x00d1
            float r11 = r12.getX()
            int r11 = (int) r11
            float r0 = r12.getY()
            int r0 = (int) r0
            boolean r10 = r10.isPointInChildBounds(r3, r11, r0)
            if (r10 != 0) goto L_0x00d1
            androidx.customview.widget.ViewDragHelper r10 = r9.viewDragHelper
            if (r10 == 0) goto L_0x00d1
            int r10 = r9.initialY
            float r10 = (float) r10
            float r11 = r12.getY()
            float r10 = r10 - r11
            float r10 = java.lang.Math.abs(r10)
            androidx.customview.widget.ViewDragHelper r9 = r9.viewDragHelper
            int r9 = r9.getTouchSlop()
            float r9 = (float) r9
            int r9 = (r10 > r9 ? 1 : (r10 == r9 ? 0 : -1))
            if (r9 <= 0) goto L_0x00d1
            r1 = r2
        L_0x00d1:
            return r1
        L_0x00d2:
            r9.ignoreEvents = r2
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.bottomsheet.BottomSheetBehavior.onInterceptTouchEvent(androidx.coordinatorlayout.widget.CoordinatorLayout, android.view.View, android.view.MotionEvent):boolean");
    }

    public boolean onTouchEvent(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, @NonNull MotionEvent motionEvent) {
        if (!v.isShown()) {
            return false;
        }
        int actionMasked = motionEvent.getActionMasked();
        if (this.state == 1 && actionMasked == 0) {
            return true;
        }
        if (shouldHandleDraggingWithHelper()) {
            this.viewDragHelper.processTouchEvent(motionEvent);
        }
        if (actionMasked == 0) {
            reset();
        }
        if (this.velocityTracker == null) {
            this.velocityTracker = VelocityTracker.obtain();
        }
        this.velocityTracker.addMovement(motionEvent);
        if (shouldHandleDraggingWithHelper() && actionMasked == 2 && !this.ignoreEvents && Math.abs(((float) this.initialY) - motionEvent.getY()) > ((float) this.viewDragHelper.getTouchSlop())) {
            this.viewDragHelper.captureChildView(v, motionEvent.getPointerId(motionEvent.getActionIndex()));
        }
        return !this.ignoreEvents;
    }

    public boolean onStartNestedScroll(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, @NonNull View view, @NonNull View view2, int i, int i2) {
        this.lastNestedScrollDy = 0;
        this.nestedScrolled = false;
        if ((i & 2) != 0) {
            return true;
        }
        return false;
    }

    public void onNestedPreScroll(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, @NonNull View view, int i, int i2, @NonNull int[] iArr, int i3) {
        if (i3 != 1) {
            WeakReference<View> weakReference = this.nestedScrollingChildRef;
            View view2 = weakReference != null ? (View) weakReference.get() : null;
            if (!isNestedScrollingCheckEnabled() || view == view2) {
                int top = v.getTop();
                int i4 = top - i2;
                if (i2 > 0) {
                    if (i4 < getExpandedOffset()) {
                        int expandedOffset2 = top - getExpandedOffset();
                        iArr[1] = expandedOffset2;
                        ViewCompat.offsetTopAndBottom(v, -expandedOffset2);
                        setStateInternal(3);
                    } else if (this.draggable) {
                        iArr[1] = i2;
                        ViewCompat.offsetTopAndBottom(v, -i2);
                        setStateInternal(1);
                    } else {
                        return;
                    }
                } else if (i2 < 0 && !view.canScrollVertically(-1)) {
                    int i5 = this.collapsedOffset;
                    if (i4 > i5 && !this.hideable) {
                        int i6 = top - i5;
                        iArr[1] = i6;
                        ViewCompat.offsetTopAndBottom(v, -i6);
                        setStateInternal(4);
                    } else if (this.draggable) {
                        iArr[1] = i2;
                        ViewCompat.offsetTopAndBottom(v, -i2);
                        setStateInternal(1);
                    } else {
                        return;
                    }
                }
                dispatchOnSlide(v.getTop());
                this.lastNestedScrollDy = i2;
                this.nestedScrolled = true;
            }
        }
    }

    public void onStopNestedScroll(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, @NonNull View view, int i) {
        int i2;
        int i3;
        WeakReference<View> weakReference;
        int i4 = 3;
        if (v.getTop() == getExpandedOffset()) {
            setStateInternal(3);
        } else if (!isNestedScrollingCheckEnabled() || ((weakReference = this.nestedScrollingChildRef) != null && view == weakReference.get() && this.nestedScrolled)) {
            if (this.lastNestedScrollDy > 0) {
                if (this.fitToContents) {
                    i2 = this.fitToContentsOffset;
                } else {
                    int top = v.getTop();
                    int i5 = this.halfExpandedOffset;
                    if (top > i5) {
                        i4 = 6;
                        i2 = i5;
                    } else {
                        i2 = getExpandedOffset();
                    }
                }
            } else if (!this.hideable || !shouldHide(v, getYVelocity())) {
                if (this.lastNestedScrollDy == 0) {
                    int top2 = v.getTop();
                    if (!this.fitToContents) {
                        int i6 = this.halfExpandedOffset;
                        if (top2 < i6) {
                            if (top2 < Math.abs(top2 - this.collapsedOffset)) {
                                i2 = getExpandedOffset();
                            } else if (shouldSkipHalfExpandedStateWhenDragging()) {
                                i3 = this.collapsedOffset;
                            } else {
                                i2 = this.halfExpandedOffset;
                                i4 = 6;
                            }
                        } else if (Math.abs(top2 - i6) < Math.abs(top2 - this.collapsedOffset)) {
                            i2 = this.halfExpandedOffset;
                            i4 = 6;
                        } else {
                            i3 = this.collapsedOffset;
                        }
                    } else if (Math.abs(top2 - this.fitToContentsOffset) < Math.abs(top2 - this.collapsedOffset)) {
                        i2 = this.fitToContentsOffset;
                    } else {
                        i3 = this.collapsedOffset;
                    }
                } else if (this.fitToContents) {
                    i3 = this.collapsedOffset;
                } else {
                    int top3 = v.getTop();
                    if (Math.abs(top3 - this.halfExpandedOffset) < Math.abs(top3 - this.collapsedOffset)) {
                        i2 = this.halfExpandedOffset;
                        i4 = 6;
                    } else {
                        i3 = this.collapsedOffset;
                    }
                }
                i4 = 4;
            } else {
                i2 = this.parentHeight;
                i4 = 5;
            }
            startSettlingAnimation(v, i4, i2, false);
            this.nestedScrolled = false;
        }
    }

    public boolean onNestedPreFling(@NonNull CoordinatorLayout coordinatorLayout, @NonNull V v, @NonNull View view, float f, float f2) {
        WeakReference<View> weakReference;
        if (!isNestedScrollingCheckEnabled() || (weakReference = this.nestedScrollingChildRef) == null || view != weakReference.get()) {
            return false;
        }
        if (this.state != 3 || super.onNestedPreFling(coordinatorLayout, v, view, f, f2)) {
            return true;
        }
        return false;
    }

    public boolean isFitToContents() {
        return this.fitToContents;
    }

    public void setFitToContents(boolean z) {
        if (this.fitToContents != z) {
            this.fitToContents = z;
            if (this.viewRef != null) {
                calculateCollapsedOffset();
            }
            setStateInternal((!this.fitToContents || this.state != 6) ? this.state : 3);
            updateAccessibilityActions();
        }
    }

    public void setMaxWidth(@Px int i) {
        this.maxWidth = i;
    }

    @Px
    public int getMaxWidth() {
        return this.maxWidth;
    }

    public void setMaxHeight(@Px int i) {
        this.maxHeight = i;
    }

    @Px
    public int getMaxHeight() {
        return this.maxHeight;
    }

    public void setPeekHeight(int i) {
        setPeekHeight(i, false);
    }

    /* JADX WARNING: Removed duplicated region for block: B:12:0x0021  */
    /* JADX WARNING: Removed duplicated region for block: B:14:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public final void setPeekHeight(int r4, boolean r5) {
        /*
            r3 = this;
            r0 = 1
            r1 = 0
            r2 = -1
            if (r4 != r2) goto L_0x000c
            boolean r4 = r3.peekHeightAuto
            if (r4 != 0) goto L_0x0015
            r3.peekHeightAuto = r0
            goto L_0x001f
        L_0x000c:
            boolean r2 = r3.peekHeightAuto
            if (r2 != 0) goto L_0x0017
            int r2 = r3.peekHeight
            if (r2 == r4) goto L_0x0015
            goto L_0x0017
        L_0x0015:
            r0 = r1
            goto L_0x001f
        L_0x0017:
            r3.peekHeightAuto = r1
            int r4 = java.lang.Math.max(r1, r4)
            r3.peekHeight = r4
        L_0x001f:
            if (r0 == 0) goto L_0x0024
            r3.updatePeekHeight(r5)
        L_0x0024:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.bottomsheet.BottomSheetBehavior.setPeekHeight(int, boolean):void");
    }

    /* access modifiers changed from: private */
    public void updatePeekHeight(boolean z) {
        View view;
        if (this.viewRef != null) {
            calculateCollapsedOffset();
            if (this.state == 4 && (view = (View) this.viewRef.get()) != null) {
                if (z) {
                    settleToStatePendingLayout(this.state);
                } else {
                    view.requestLayout();
                }
            }
        }
    }

    public int getPeekHeight() {
        if (this.peekHeightAuto) {
            return -1;
        }
        return this.peekHeight;
    }

    public void setHalfExpandedRatio(@FloatRange(from = 0.0d, fromInclusive = false, to = 1.0d, toInclusive = false) float f) {
        if (f <= 0.0f || f >= 1.0f) {
            throw new IllegalArgumentException("ratio must be a float value between 0 and 1");
        }
        this.halfExpandedRatio = f;
        if (this.viewRef != null) {
            calculateHalfExpandedOffset();
        }
    }

    @FloatRange(from = 0.0d, to = 1.0d)
    public float getHalfExpandedRatio() {
        return this.halfExpandedRatio;
    }

    public void setExpandedOffset(int i) {
        if (i >= 0) {
            this.expandedOffset = i;
            return;
        }
        throw new IllegalArgumentException("offset must be greater than or equal to 0");
    }

    public int getExpandedOffset() {
        if (this.fitToContents) {
            return this.fitToContentsOffset;
        }
        return Math.max(this.expandedOffset, this.paddingTopSystemWindowInsets ? 0 : this.insetTop);
    }

    public void setHideable(boolean z) {
        if (this.hideable != z) {
            this.hideable = z;
            if (!z && this.state == 5) {
                setState(4);
            }
            updateAccessibilityActions();
        }
    }

    public boolean isHideable() {
        return this.hideable;
    }

    public void setSkipCollapsed(boolean z) {
        this.skipCollapsed = z;
    }

    public boolean getSkipCollapsed() {
        return this.skipCollapsed;
    }

    public void setDraggable(boolean z) {
        this.draggable = z;
    }

    public boolean isDraggable() {
        return this.draggable;
    }

    public void setSaveFlags(int i) {
        this.saveFlags = i;
    }

    public int getSaveFlags() {
        return this.saveFlags;
    }

    @Deprecated
    public void setBottomSheetCallback(BottomSheetCallback bottomSheetCallback) {
        Log.w(TAG, "BottomSheetBehavior now supports multiple callbacks. `setBottomSheetCallback()` removes all existing callbacks, including ones set internally by library authors, which may result in unintended behavior. This may change in the future. Please use `addBottomSheetCallback()` and `removeBottomSheetCallback()` instead to set your own callbacks.");
        this.callbacks.clear();
        if (bottomSheetCallback != null) {
            this.callbacks.add(bottomSheetCallback);
        }
    }

    public void addBottomSheetCallback(@NonNull BottomSheetCallback bottomSheetCallback) {
        if (!this.callbacks.contains(bottomSheetCallback)) {
            this.callbacks.add(bottomSheetCallback);
        }
    }

    public void removeBottomSheetCallback(@NonNull BottomSheetCallback bottomSheetCallback) {
        this.callbacks.remove(bottomSheetCallback);
    }

    public void setState(int i) {
        if (i != this.state) {
            if (this.viewRef != null) {
                settleToStatePendingLayout(i);
            } else if (i == 4 || i == 3 || i == 6 || (this.hideable && i == 5)) {
                this.state = i;
                this.lastStableState = i;
            }
        }
    }

    public void setGestureInsetBottomIgnored(boolean z) {
        this.gestureInsetBottomIgnored = z;
    }

    public boolean isGestureInsetBottomIgnored() {
        return this.gestureInsetBottomIgnored;
    }

    private void settleToStatePendingLayout(final int i) {
        final View view = (View) this.viewRef.get();
        if (view != null) {
            ViewParent parent = view.getParent();
            if (parent == null || !parent.isLayoutRequested() || !ViewCompat.isAttachedToWindow(view)) {
                settleToState(view, i);
            } else {
                view.post(new Runnable() {
                    public void run() {
                        BottomSheetBehavior.this.settleToState(view, i);
                    }
                });
            }
        }
    }

    public int getState() {
        return this.state;
    }

    /* access modifiers changed from: package-private */
    public void setStateInternal(int i) {
        View view;
        if (this.state != i) {
            this.state = i;
            if (i == 4 || i == 3 || i == 6 || (this.hideable && i == 5)) {
                this.lastStableState = i;
            }
            WeakReference<V> weakReference = this.viewRef;
            if (weakReference != null && (view = (View) weakReference.get()) != null) {
                if (i == 3) {
                    updateImportantForAccessibility(true);
                } else if (i == 6 || i == 5 || i == 4) {
                    updateImportantForAccessibility(false);
                }
                updateDrawableForTargetState(i);
                for (int i2 = 0; i2 < this.callbacks.size(); i2++) {
                    this.callbacks.get(i2).onStateChanged(view, i);
                }
                updateAccessibilityActions();
            }
        }
    }

    private void updateDrawableForTargetState(int i) {
        ValueAnimator valueAnimator;
        if (i != 2) {
            boolean z = i == 3;
            if (this.isShapeExpanded != z) {
                this.isShapeExpanded = z;
                if (this.materialShapeDrawable != null && (valueAnimator = this.interpolatorAnimator) != null) {
                    if (valueAnimator.isRunning()) {
                        this.interpolatorAnimator.reverse();
                        return;
                    }
                    float f = z ? 0.0f : 1.0f;
                    this.interpolatorAnimator.setFloatValues(new float[]{1.0f - f, f});
                    this.interpolatorAnimator.start();
                }
            }
        }
    }

    private int calculatePeekHeight() {
        int i;
        int i2;
        int i3;
        if (this.peekHeightAuto) {
            i = Math.min(Math.max(this.peekHeightMin, this.parentHeight - ((this.parentWidth * 9) / 16)), this.childHeight);
            i2 = this.insetBottom;
        } else if (!this.gestureInsetBottomIgnored && !this.paddingBottomSystemWindowInsets && (i3 = this.gestureInsetBottom) > 0) {
            return Math.max(this.peekHeight, i3 + this.peekHeightGestureInsetBuffer);
        } else {
            i = this.peekHeight;
            i2 = this.insetBottom;
        }
        return i + i2;
    }

    private void calculateCollapsedOffset() {
        int calculatePeekHeight = calculatePeekHeight();
        if (this.fitToContents) {
            this.collapsedOffset = Math.max(this.parentHeight - calculatePeekHeight, this.fitToContentsOffset);
        } else {
            this.collapsedOffset = this.parentHeight - calculatePeekHeight;
        }
    }

    private void calculateHalfExpandedOffset() {
        this.halfExpandedOffset = (int) (((float) this.parentHeight) * (1.0f - this.halfExpandedRatio));
    }

    private void reset() {
        this.activePointerId = -1;
        VelocityTracker velocityTracker2 = this.velocityTracker;
        if (velocityTracker2 != null) {
            velocityTracker2.recycle();
            this.velocityTracker = null;
        }
    }

    private void restoreOptionalState(@NonNull SavedState savedState) {
        int i = this.saveFlags;
        if (i != 0) {
            if (i == -1 || (i & 1) == 1) {
                this.peekHeight = savedState.peekHeight;
            }
            if (i == -1 || (i & 2) == 2) {
                this.fitToContents = savedState.fitToContents;
            }
            if (i == -1 || (i & 4) == 4) {
                this.hideable = savedState.hideable;
            }
            if (i == -1 || (i & 8) == 8) {
                this.skipCollapsed = savedState.skipCollapsed;
            }
        }
    }

    /* access modifiers changed from: package-private */
    public boolean shouldHide(@NonNull View view, float f) {
        if (this.skipCollapsed) {
            return true;
        }
        if (view.getTop() < this.collapsedOffset) {
            return false;
        }
        if (Math.abs((((float) view.getTop()) + (f * 0.1f)) - ((float) this.collapsedOffset)) / ((float) calculatePeekHeight()) > 0.5f) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    @Nullable
    public View findScrollingChild(View view) {
        if (ViewCompat.isNestedScrollingEnabled(view)) {
            return view;
        }
        if (!(view instanceof ViewGroup)) {
            return null;
        }
        ViewGroup viewGroup = (ViewGroup) view;
        int childCount = viewGroup.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View findScrollingChild = findScrollingChild(viewGroup.getChildAt(i));
            if (findScrollingChild != null) {
                return findScrollingChild;
            }
        }
        return null;
    }

    private boolean shouldHandleDraggingWithHelper() {
        return this.viewDragHelper != null && (this.draggable || this.state == 1);
    }

    private void createMaterialShapeDrawableIfNeeded(@NonNull Context context) {
        if (this.shapeAppearanceModelDefault != null) {
            MaterialShapeDrawable materialShapeDrawable2 = new MaterialShapeDrawable(this.shapeAppearanceModelDefault);
            this.materialShapeDrawable = materialShapeDrawable2;
            materialShapeDrawable2.initializeElevationOverlay(context);
            ColorStateList colorStateList = this.backgroundTint;
            if (colorStateList != null) {
                this.materialShapeDrawable.setFillColor(colorStateList);
                return;
            }
            TypedValue typedValue = new TypedValue();
            context.getTheme().resolveAttribute(16842801, typedValue, true);
            this.materialShapeDrawable.setTint(typedValue.data);
        }
    }

    /* access modifiers changed from: package-private */
    public MaterialShapeDrawable getMaterialShapeDrawable() {
        return this.materialShapeDrawable;
    }

    private void createShapeValueAnimator() {
        ValueAnimator ofFloat = ValueAnimator.ofFloat(new float[]{0.0f, 1.0f});
        this.interpolatorAnimator = ofFloat;
        ofFloat.setDuration(500);
        this.interpolatorAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            public void onAnimationUpdate(@NonNull ValueAnimator valueAnimator) {
                float floatValue = ((Float) valueAnimator.getAnimatedValue()).floatValue();
                if (BottomSheetBehavior.this.materialShapeDrawable != null) {
                    BottomSheetBehavior.this.materialShapeDrawable.setInterpolation(floatValue);
                }
            }
        });
    }

    private void setWindowInsetsListener(@NonNull View view) {
        final boolean z = !isGestureInsetBottomIgnored() && !this.peekHeightAuto;
        if (this.paddingBottomSystemWindowInsets || this.paddingLeftSystemWindowInsets || this.paddingRightSystemWindowInsets || this.marginLeftSystemWindowInsets || this.marginRightSystemWindowInsets || this.marginTopSystemWindowInsets || z) {
            ViewUtils.doOnApplyWindowInsets(view, new ViewUtils.OnApplyWindowInsetsListener() {
                public WindowInsetsCompat onApplyWindowInsets(View view, WindowInsetsCompat windowInsetsCompat, ViewUtils.RelativePadding relativePadding) {
                    boolean z;
                    int i;
                    int i2;
                    int i3;
                    Insets insets = windowInsetsCompat.getInsets(WindowInsetsCompat.Type.systemBars());
                    Insets insets2 = windowInsetsCompat.getInsets(WindowInsetsCompat.Type.mandatorySystemGestures());
                    int unused = BottomSheetBehavior.this.insetTop = insets.top;
                    boolean isLayoutRtl = ViewUtils.isLayoutRtl(view);
                    int paddingBottom = view.getPaddingBottom();
                    int paddingLeft = view.getPaddingLeft();
                    int paddingRight = view.getPaddingRight();
                    if (BottomSheetBehavior.this.paddingBottomSystemWindowInsets) {
                        int unused2 = BottomSheetBehavior.this.insetBottom = windowInsetsCompat.getSystemWindowInsetBottom();
                        paddingBottom = relativePadding.bottom + BottomSheetBehavior.this.insetBottom;
                    }
                    if (BottomSheetBehavior.this.paddingLeftSystemWindowInsets) {
                        paddingLeft = (isLayoutRtl ? relativePadding.end : relativePadding.start) + insets.left;
                    }
                    if (BottomSheetBehavior.this.paddingRightSystemWindowInsets) {
                        paddingRight = (isLayoutRtl ? relativePadding.start : relativePadding.end) + insets.right;
                    }
                    ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) view.getLayoutParams();
                    boolean z2 = true;
                    if (!BottomSheetBehavior.this.marginLeftSystemWindowInsets || marginLayoutParams.leftMargin == (i3 = insets.left)) {
                        z = false;
                    } else {
                        marginLayoutParams.leftMargin = i3;
                        z = true;
                    }
                    if (BottomSheetBehavior.this.marginRightSystemWindowInsets && marginLayoutParams.rightMargin != (i2 = insets.right)) {
                        marginLayoutParams.rightMargin = i2;
                        z = true;
                    }
                    if (!BottomSheetBehavior.this.marginTopSystemWindowInsets || marginLayoutParams.topMargin == (i = insets.top)) {
                        z2 = z;
                    } else {
                        marginLayoutParams.topMargin = i;
                    }
                    if (z2) {
                        view.setLayoutParams(marginLayoutParams);
                    }
                    view.setPadding(paddingLeft, view.getPaddingTop(), paddingRight, paddingBottom);
                    if (z) {
                        int unused3 = BottomSheetBehavior.this.gestureInsetBottom = insets2.bottom;
                    }
                    if (BottomSheetBehavior.this.paddingBottomSystemWindowInsets || z) {
                        BottomSheetBehavior.this.updatePeekHeight(false);
                    }
                    return windowInsetsCompat;
                }
            });
        }
    }

    private float getYVelocity() {
        VelocityTracker velocityTracker2 = this.velocityTracker;
        if (velocityTracker2 == null) {
            return 0.0f;
        }
        velocityTracker2.computeCurrentVelocity(1000, this.maximumVelocity);
        return this.velocityTracker.getYVelocity(this.activePointerId);
    }

    /* access modifiers changed from: package-private */
    public void settleToState(@NonNull View view, int i) {
        int i2;
        int i3;
        if (i == 4) {
            i2 = this.collapsedOffset;
        } else if (i == 6) {
            int i4 = this.halfExpandedOffset;
            if (!this.fitToContents || i4 > (i3 = this.fitToContentsOffset)) {
                i2 = i4;
            } else {
                i = 3;
                i2 = i3;
            }
        } else if (i == 3) {
            i2 = getExpandedOffset();
        } else if (!this.hideable || i != 5) {
            Log.w(TAG, "The bottom sheet may be in an invalid state. Ensure `hideable` is true when using `STATE_HIDDEN`.");
            return;
        } else {
            i2 = this.parentHeight;
        }
        startSettlingAnimation(view, i, i2, false);
    }

    /* access modifiers changed from: package-private */
    public void startSettlingAnimation(View view, int i, int i2, boolean z) {
        ViewDragHelper viewDragHelper2 = this.viewDragHelper;
        if (viewDragHelper2 != null && (!z ? viewDragHelper2.smoothSlideViewTo(view, view.getLeft(), i2) : viewDragHelper2.settleCapturedViewAt(view.getLeft(), i2))) {
            setStateInternal(2);
            updateDrawableForTargetState(i);
            if (this.settleRunnable == null) {
                this.settleRunnable = new SettleRunnable(view, i);
            }
            if (!this.settleRunnable.isPosted) {
                BottomSheetBehavior<V>.SettleRunnable settleRunnable2 = this.settleRunnable;
                settleRunnable2.targetState = i;
                ViewCompat.postOnAnimation(view, settleRunnable2);
                boolean unused = this.settleRunnable.isPosted = true;
                return;
            }
            this.settleRunnable.targetState = i;
            return;
        }
        setStateInternal(i);
    }

    /* access modifiers changed from: package-private */
    public void dispatchOnSlide(int i) {
        float f;
        float f2;
        View view = (View) this.viewRef.get();
        if (view != null && !this.callbacks.isEmpty()) {
            int i2 = this.collapsedOffset;
            if (i > i2 || i2 == getExpandedOffset()) {
                int i3 = this.collapsedOffset;
                f = (float) (i3 - i);
                f2 = (float) (this.parentHeight - i3);
            } else {
                int i4 = this.collapsedOffset;
                f = (float) (i4 - i);
                f2 = (float) (i4 - getExpandedOffset());
            }
            float f3 = f / f2;
            for (int i5 = 0; i5 < this.callbacks.size(); i5++) {
                this.callbacks.get(i5).onSlide(view, f3);
            }
        }
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public int getPeekHeightMin() {
        return this.peekHeightMin;
    }

    @VisibleForTesting
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public void disableShapeAnimations() {
        this.interpolatorAnimator = null;
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public void setHideableInternal(boolean z) {
        this.hideable = z;
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public int getLastStableState() {
        return this.lastStableState;
    }

    private class SettleRunnable implements Runnable {
        /* access modifiers changed from: private */
        public boolean isPosted;
        int targetState;
        private final WeakReference<View> viewRef;

        SettleRunnable(View view, int i) {
            this.viewRef = new WeakReference<>(view);
            this.targetState = i;
        }

        public void run() {
            ViewDragHelper viewDragHelper;
            if (this.viewRef.get() == null || (viewDragHelper = BottomSheetBehavior.this.viewDragHelper) == null || !viewDragHelper.continueSettling(true)) {
                BottomSheetBehavior.this.setStateInternal(this.targetState);
            } else {
                ViewCompat.postOnAnimation((View) this.viewRef.get(), this);
            }
            this.isPosted = false;
        }
    }

    protected static class SavedState extends AbsSavedState {
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
        boolean fitToContents;
        boolean hideable;
        int peekHeight;
        boolean skipCollapsed;
        final int state;

        public SavedState(@NonNull Parcel parcel) {
            this(parcel, (ClassLoader) null);
        }

        public SavedState(@NonNull Parcel parcel, ClassLoader classLoader) {
            super(parcel, classLoader);
            this.state = parcel.readInt();
            this.peekHeight = parcel.readInt();
            boolean z = false;
            this.fitToContents = parcel.readInt() == 1;
            this.hideable = parcel.readInt() == 1;
            this.skipCollapsed = parcel.readInt() == 1 ? true : z;
        }

        public SavedState(Parcelable parcelable, @NonNull BottomSheetBehavior<?> bottomSheetBehavior) {
            super(parcelable);
            this.state = bottomSheetBehavior.state;
            this.peekHeight = bottomSheetBehavior.peekHeight;
            this.fitToContents = bottomSheetBehavior.fitToContents;
            this.hideable = bottomSheetBehavior.hideable;
            this.skipCollapsed = bottomSheetBehavior.skipCollapsed;
        }

        @Deprecated
        public SavedState(Parcelable parcelable, int i) {
            super(parcelable);
            this.state = i;
        }

        public void writeToParcel(@NonNull Parcel parcel, int i) {
            super.writeToParcel(parcel, i);
            parcel.writeInt(this.state);
            parcel.writeInt(this.peekHeight);
            parcel.writeInt(this.fitToContents ? 1 : 0);
            parcel.writeInt(this.hideable ? 1 : 0);
            parcel.writeInt(this.skipCollapsed ? 1 : 0);
        }
    }

    @NonNull
    public static <V extends View> BottomSheetBehavior<V> from(@NonNull V v) {
        ViewGroup.LayoutParams layoutParams = v.getLayoutParams();
        if (layoutParams instanceof CoordinatorLayout.LayoutParams) {
            CoordinatorLayout.Behavior behavior = ((CoordinatorLayout.LayoutParams) layoutParams).getBehavior();
            if (behavior instanceof BottomSheetBehavior) {
                return (BottomSheetBehavior) behavior;
            }
            throw new IllegalArgumentException("The view is not associated with BottomSheetBehavior");
        }
        throw new IllegalArgumentException("The view is not a child of CoordinatorLayout");
    }

    public void setUpdateImportantForAccessibilityOnSiblings(boolean z) {
        this.updateImportantForAccessibilityOnSiblings = z;
    }

    private void updateImportantForAccessibility(boolean z) {
        Map<View, Integer> map;
        WeakReference<V> weakReference = this.viewRef;
        if (weakReference != null) {
            ViewParent parent = ((View) weakReference.get()).getParent();
            if (parent instanceof CoordinatorLayout) {
                CoordinatorLayout coordinatorLayout = (CoordinatorLayout) parent;
                int childCount = coordinatorLayout.getChildCount();
                if (z) {
                    if (this.importantForAccessibilityMap == null) {
                        this.importantForAccessibilityMap = new HashMap(childCount);
                    } else {
                        return;
                    }
                }
                for (int i = 0; i < childCount; i++) {
                    View childAt = coordinatorLayout.getChildAt(i);
                    if (childAt != this.viewRef.get()) {
                        if (z) {
                            this.importantForAccessibilityMap.put(childAt, Integer.valueOf(childAt.getImportantForAccessibility()));
                            if (this.updateImportantForAccessibilityOnSiblings) {
                                ViewCompat.setImportantForAccessibility(childAt, 4);
                            }
                        } else if (this.updateImportantForAccessibilityOnSiblings && (map = this.importantForAccessibilityMap) != null && map.containsKey(childAt)) {
                            ViewCompat.setImportantForAccessibility(childAt, this.importantForAccessibilityMap.get(childAt).intValue());
                        }
                    }
                }
                if (!z) {
                    this.importantForAccessibilityMap = null;
                } else if (this.updateImportantForAccessibilityOnSiblings) {
                    ((View) this.viewRef.get()).sendAccessibilityEvent(8);
                }
            }
        }
    }

    private void updateAccessibilityActions() {
        View view;
        WeakReference<V> weakReference = this.viewRef;
        if (weakReference != null && (view = (View) weakReference.get()) != null) {
            ViewCompat.removeAccessibilityAction(view, 524288);
            ViewCompat.removeAccessibilityAction(view, 262144);
            ViewCompat.removeAccessibilityAction(view, 1048576);
            int i = this.expandHalfwayActionId;
            if (i != -1) {
                ViewCompat.removeAccessibilityAction(view, i);
            }
            int i2 = 6;
            if (!this.fitToContents && this.state != 6) {
                this.expandHalfwayActionId = addAccessibilityActionForState(view, R.string.bottomsheet_action_expand_halfway, 6);
            }
            if (this.hideable && this.state != 5) {
                replaceAccessibilityActionForState(view, AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_DISMISS, 5);
            }
            int i3 = this.state;
            if (i3 == 3) {
                if (this.fitToContents) {
                    i2 = 4;
                }
                replaceAccessibilityActionForState(view, AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_COLLAPSE, i2);
            } else if (i3 == 4) {
                if (this.fitToContents) {
                    i2 = 3;
                }
                replaceAccessibilityActionForState(view, AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_EXPAND, i2);
            } else if (i3 == 6) {
                replaceAccessibilityActionForState(view, AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_COLLAPSE, 4);
                replaceAccessibilityActionForState(view, AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_EXPAND, 3);
            }
        }
    }

    private void replaceAccessibilityActionForState(V v, AccessibilityNodeInfoCompat.AccessibilityActionCompat accessibilityActionCompat, int i) {
        ViewCompat.replaceAccessibilityAction(v, accessibilityActionCompat, (CharSequence) null, createAccessibilityViewCommandForState(i));
    }

    private int addAccessibilityActionForState(V v, @StringRes int i, int i2) {
        return ViewCompat.addAccessibilityAction(v, v.getResources().getString(i), createAccessibilityViewCommandForState(i2));
    }

    private AccessibilityViewCommand createAccessibilityViewCommandForState(final int i) {
        return new AccessibilityViewCommand() {
            public boolean perform(@NonNull View view, @Nullable AccessibilityViewCommand.CommandArguments commandArguments) {
                BottomSheetBehavior.this.setState(i);
                return true;
            }
        };
    }
}
