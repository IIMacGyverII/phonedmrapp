package com.google.android.material.textfield;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.annotation.SuppressLint;
import android.content.res.ColorStateList;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.graphics.drawable.RippleDrawable;
import android.graphics.drawable.StateListDrawable;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.MotionEvent;
import android.view.View;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityManager;
import android.widget.AutoCompleteTextView;
import android.widget.EditText;
import android.widget.Spinner;
import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.ViewCompat;
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat;
import com.google.android.material.R;
import com.google.android.material.animation.AnimationUtils;
import com.google.android.material.color.MaterialColors;
import com.google.android.material.internal.TextWatcherAdapter;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.ShapeAppearanceModel;
import com.google.android.material.textfield.TextInputLayout;

class DropdownMenuEndIconDelegate extends EndIconDelegate {
    private static final int ANIMATION_FADE_IN_DURATION = 67;
    private static final int ANIMATION_FADE_OUT_DURATION = 50;
    /* access modifiers changed from: private */
    public static final boolean IS_LOLLIPOP = true;
    /* access modifiers changed from: private */
    public final TextInputLayout.AccessibilityDelegate accessibilityDelegate = new TextInputLayout.AccessibilityDelegate(this.textInputLayout) {
        public void onInitializeAccessibilityNodeInfo(View view, @NonNull AccessibilityNodeInfoCompat accessibilityNodeInfoCompat) {
            super.onInitializeAccessibilityNodeInfo(view, accessibilityNodeInfoCompat);
            if (!DropdownMenuEndIconDelegate.isEditable(DropdownMenuEndIconDelegate.this.textInputLayout.getEditText())) {
                accessibilityNodeInfoCompat.setClassName(Spinner.class.getName());
            }
            if (accessibilityNodeInfoCompat.isShowingHintText()) {
                accessibilityNodeInfoCompat.setHintText((CharSequence) null);
            }
        }

        public void onPopulateAccessibilityEvent(View view, @NonNull AccessibilityEvent accessibilityEvent) {
            super.onPopulateAccessibilityEvent(view, accessibilityEvent);
            AutoCompleteTextView access$000 = DropdownMenuEndIconDelegate.castAutoCompleteTextViewOrThrow(DropdownMenuEndIconDelegate.this.textInputLayout.getEditText());
            if (accessibilityEvent.getEventType() == 1 && DropdownMenuEndIconDelegate.this.accessibilityManager.isEnabled() && !DropdownMenuEndIconDelegate.isEditable(DropdownMenuEndIconDelegate.this.textInputLayout.getEditText())) {
                DropdownMenuEndIconDelegate.this.showHideDropdown(access$000);
                DropdownMenuEndIconDelegate.this.updateDropdownPopupDirty();
            }
        }
    };
    /* access modifiers changed from: private */
    @Nullable
    public AccessibilityManager accessibilityManager;
    private final TextInputLayout.OnEditTextAttachedListener dropdownMenuOnEditTextAttachedListener = new TextInputLayout.OnEditTextAttachedListener() {
        public void onEditTextAttached(@NonNull TextInputLayout textInputLayout) {
            AutoCompleteTextView access$000 = DropdownMenuEndIconDelegate.castAutoCompleteTextViewOrThrow(textInputLayout.getEditText());
            DropdownMenuEndIconDelegate.this.setPopupBackground(access$000);
            DropdownMenuEndIconDelegate.this.addRippleEffect(access$000);
            DropdownMenuEndIconDelegate.this.setUpDropdownShowHideBehavior(access$000);
            access$000.setThreshold(0);
            access$000.removeTextChangedListener(DropdownMenuEndIconDelegate.this.exposedDropdownEndIconTextWatcher);
            access$000.addTextChangedListener(DropdownMenuEndIconDelegate.this.exposedDropdownEndIconTextWatcher);
            textInputLayout.setEndIconCheckable(true);
            textInputLayout.setErrorIconDrawable((Drawable) null);
            if (!DropdownMenuEndIconDelegate.isEditable(access$000) && DropdownMenuEndIconDelegate.this.accessibilityManager.isTouchExplorationEnabled()) {
                ViewCompat.setImportantForAccessibility(DropdownMenuEndIconDelegate.this.endIconView, 2);
            }
            textInputLayout.setTextInputAccessibilityDelegate(DropdownMenuEndIconDelegate.this.accessibilityDelegate);
            textInputLayout.setEndIconVisible(true);
        }
    };
    private long dropdownPopupActivatedAt = Long.MAX_VALUE;
    /* access modifiers changed from: private */
    public boolean dropdownPopupDirty = false;
    @SuppressLint({"ClickableViewAccessibility"})
    private final TextInputLayout.OnEndIconChangedListener endIconChangedListener = new TextInputLayout.OnEndIconChangedListener() {
        public void onEndIconChanged(@NonNull TextInputLayout textInputLayout, int i) {
            final AutoCompleteTextView autoCompleteTextView = (AutoCompleteTextView) textInputLayout.getEditText();
            if (autoCompleteTextView != null && i == 3) {
                autoCompleteTextView.post(new Runnable() {
                    public void run() {
                        autoCompleteTextView.removeTextChangedListener(DropdownMenuEndIconDelegate.this.exposedDropdownEndIconTextWatcher);
                    }
                });
                if (autoCompleteTextView.getOnFocusChangeListener() == DropdownMenuEndIconDelegate.this.onFocusChangeListener) {
                    autoCompleteTextView.setOnFocusChangeListener((View.OnFocusChangeListener) null);
                }
                autoCompleteTextView.setOnTouchListener((View.OnTouchListener) null);
                if (DropdownMenuEndIconDelegate.IS_LOLLIPOP) {
                    autoCompleteTextView.setOnDismissListener((AutoCompleteTextView.OnDismissListener) null);
                }
            }
        }
    };
    /* access modifiers changed from: private */
    public final TextWatcher exposedDropdownEndIconTextWatcher = new TextWatcherAdapter() {
        public void afterTextChanged(Editable editable) {
            final AutoCompleteTextView access$000 = DropdownMenuEndIconDelegate.castAutoCompleteTextViewOrThrow(DropdownMenuEndIconDelegate.this.textInputLayout.getEditText());
            if (DropdownMenuEndIconDelegate.this.accessibilityManager.isTouchExplorationEnabled() && DropdownMenuEndIconDelegate.isEditable(access$000) && !DropdownMenuEndIconDelegate.this.endIconView.hasFocus()) {
                access$000.dismissDropDown();
            }
            access$000.post(new Runnable() {
                public void run() {
                    boolean isPopupShowing = access$000.isPopupShowing();
                    DropdownMenuEndIconDelegate.this.setEndIconChecked(isPopupShowing);
                    boolean unused = DropdownMenuEndIconDelegate.this.dropdownPopupDirty = isPopupShowing;
                }
            });
        }
    };
    /* access modifiers changed from: private */
    public ValueAnimator fadeInAnim;
    private ValueAnimator fadeOutAnim;
    private StateListDrawable filledPopupBackground;
    /* access modifiers changed from: private */
    public boolean isEndIconChecked = false;
    /* access modifiers changed from: private */
    public final View.OnFocusChangeListener onFocusChangeListener = new View.OnFocusChangeListener() {
        public void onFocusChange(View view, boolean z) {
            DropdownMenuEndIconDelegate.this.textInputLayout.setEndIconActivated(z);
            if (!z) {
                DropdownMenuEndIconDelegate.this.setEndIconChecked(false);
                boolean unused = DropdownMenuEndIconDelegate.this.dropdownPopupDirty = false;
            }
        }
    };
    private MaterialShapeDrawable outlinedPopupBackground;

    /* access modifiers changed from: package-private */
    public boolean isBoxBackgroundModeSupported(int i) {
        return i != 0;
    }

    /* access modifiers changed from: package-private */
    public boolean shouldTintIconOnError() {
        return true;
    }

    DropdownMenuEndIconDelegate(@NonNull TextInputLayout textInputLayout, @DrawableRes int i) {
        super(textInputLayout, i);
    }

    /* access modifiers changed from: package-private */
    public void initialize() {
        float dimensionPixelOffset = (float) this.context.getResources().getDimensionPixelOffset(R.dimen.mtrl_shape_corner_size_small_component);
        float dimensionPixelOffset2 = (float) this.context.getResources().getDimensionPixelOffset(R.dimen.mtrl_exposed_dropdown_menu_popup_elevation);
        int dimensionPixelOffset3 = this.context.getResources().getDimensionPixelOffset(R.dimen.mtrl_exposed_dropdown_menu_popup_vertical_padding);
        MaterialShapeDrawable popUpMaterialShapeDrawable = getPopUpMaterialShapeDrawable(dimensionPixelOffset, dimensionPixelOffset, dimensionPixelOffset2, dimensionPixelOffset3);
        MaterialShapeDrawable popUpMaterialShapeDrawable2 = getPopUpMaterialShapeDrawable(0.0f, dimensionPixelOffset, dimensionPixelOffset2, dimensionPixelOffset3);
        this.outlinedPopupBackground = popUpMaterialShapeDrawable;
        StateListDrawable stateListDrawable = new StateListDrawable();
        this.filledPopupBackground = stateListDrawable;
        stateListDrawable.addState(new int[]{16842922}, popUpMaterialShapeDrawable);
        this.filledPopupBackground.addState(new int[0], popUpMaterialShapeDrawable2);
        int i = this.customEndIcon;
        if (i == 0) {
            i = IS_LOLLIPOP ? R.drawable.mtrl_dropdown_arrow : R.drawable.mtrl_ic_arrow_drop_down;
        }
        this.textInputLayout.setEndIconDrawable(i);
        TextInputLayout textInputLayout = this.textInputLayout;
        textInputLayout.setEndIconContentDescription(textInputLayout.getResources().getText(R.string.exposed_dropdown_menu_content_description));
        this.textInputLayout.setEndIconOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                DropdownMenuEndIconDelegate.this.showHideDropdown((AutoCompleteTextView) DropdownMenuEndIconDelegate.this.textInputLayout.getEditText());
            }
        });
        this.textInputLayout.addOnEditTextAttachedListener(this.dropdownMenuOnEditTextAttachedListener);
        this.textInputLayout.addOnEndIconChangedListener(this.endIconChangedListener);
        initAnimators();
        this.accessibilityManager = (AccessibilityManager) this.context.getSystemService("accessibility");
    }

    /* access modifiers changed from: private */
    public void showHideDropdown(@Nullable AutoCompleteTextView autoCompleteTextView) {
        if (autoCompleteTextView != null) {
            if (isDropdownPopupActive()) {
                this.dropdownPopupDirty = false;
            }
            if (!this.dropdownPopupDirty) {
                if (IS_LOLLIPOP) {
                    setEndIconChecked(!this.isEndIconChecked);
                } else {
                    this.isEndIconChecked = !this.isEndIconChecked;
                    this.endIconView.toggle();
                }
                if (this.isEndIconChecked) {
                    autoCompleteTextView.requestFocus();
                    autoCompleteTextView.showDropDown();
                    return;
                }
                autoCompleteTextView.dismissDropDown();
                return;
            }
            this.dropdownPopupDirty = false;
        }
    }

    /* access modifiers changed from: private */
    public void setPopupBackground(@NonNull AutoCompleteTextView autoCompleteTextView) {
        if (IS_LOLLIPOP) {
            int boxBackgroundMode = this.textInputLayout.getBoxBackgroundMode();
            if (boxBackgroundMode == 2) {
                autoCompleteTextView.setDropDownBackgroundDrawable(this.outlinedPopupBackground);
            } else if (boxBackgroundMode == 1) {
                autoCompleteTextView.setDropDownBackgroundDrawable(this.filledPopupBackground);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void updateOutlinedRippleEffect(@NonNull AutoCompleteTextView autoCompleteTextView) {
        if (!isEditable(autoCompleteTextView) && this.textInputLayout.getBoxBackgroundMode() == 2 && (autoCompleteTextView.getBackground() instanceof LayerDrawable)) {
            addRippleEffect(autoCompleteTextView);
        }
    }

    /* access modifiers changed from: private */
    public void addRippleEffect(@NonNull AutoCompleteTextView autoCompleteTextView) {
        if (!isEditable(autoCompleteTextView)) {
            int boxBackgroundMode = this.textInputLayout.getBoxBackgroundMode();
            MaterialShapeDrawable boxBackground = this.textInputLayout.getBoxBackground();
            int color = MaterialColors.getColor(autoCompleteTextView, R.attr.colorControlHighlight);
            int[][] iArr = {new int[]{16842919}, new int[0]};
            if (boxBackgroundMode == 2) {
                addRippleEffectOnOutlinedLayout(autoCompleteTextView, color, iArr, boxBackground);
            } else if (boxBackgroundMode == 1) {
                addRippleEffectOnFilledLayout(autoCompleteTextView, color, iArr, boxBackground);
            }
        }
    }

    private void addRippleEffectOnOutlinedLayout(@NonNull AutoCompleteTextView autoCompleteTextView, int i, int[][] iArr, @NonNull MaterialShapeDrawable materialShapeDrawable) {
        LayerDrawable layerDrawable;
        int color = MaterialColors.getColor(autoCompleteTextView, R.attr.colorSurface);
        MaterialShapeDrawable materialShapeDrawable2 = new MaterialShapeDrawable(materialShapeDrawable.getShapeAppearanceModel());
        int layer = MaterialColors.layer(i, color, 0.1f);
        materialShapeDrawable2.setFillColor(new ColorStateList(iArr, new int[]{layer, 0}));
        if (IS_LOLLIPOP) {
            materialShapeDrawable2.setTint(color);
            ColorStateList colorStateList = new ColorStateList(iArr, new int[]{layer, color});
            MaterialShapeDrawable materialShapeDrawable3 = new MaterialShapeDrawable(materialShapeDrawable.getShapeAppearanceModel());
            materialShapeDrawable3.setTint(-1);
            layerDrawable = new LayerDrawable(new Drawable[]{new RippleDrawable(colorStateList, materialShapeDrawable2, materialShapeDrawable3), materialShapeDrawable});
        } else {
            layerDrawable = new LayerDrawable(new Drawable[]{materialShapeDrawable2, materialShapeDrawable});
        }
        ViewCompat.setBackground(autoCompleteTextView, layerDrawable);
    }

    private void addRippleEffectOnFilledLayout(@NonNull AutoCompleteTextView autoCompleteTextView, int i, int[][] iArr, @NonNull MaterialShapeDrawable materialShapeDrawable) {
        int boxBackgroundColor = this.textInputLayout.getBoxBackgroundColor();
        int[] iArr2 = {MaterialColors.layer(i, boxBackgroundColor, 0.1f), boxBackgroundColor};
        if (IS_LOLLIPOP) {
            ViewCompat.setBackground(autoCompleteTextView, new RippleDrawable(new ColorStateList(iArr, iArr2), materialShapeDrawable, materialShapeDrawable));
            return;
        }
        MaterialShapeDrawable materialShapeDrawable2 = new MaterialShapeDrawable(materialShapeDrawable.getShapeAppearanceModel());
        materialShapeDrawable2.setFillColor(new ColorStateList(iArr, iArr2));
        LayerDrawable layerDrawable = new LayerDrawable(new Drawable[]{materialShapeDrawable, materialShapeDrawable2});
        int paddingStart = ViewCompat.getPaddingStart(autoCompleteTextView);
        int paddingTop = autoCompleteTextView.getPaddingTop();
        int paddingEnd = ViewCompat.getPaddingEnd(autoCompleteTextView);
        int paddingBottom = autoCompleteTextView.getPaddingBottom();
        ViewCompat.setBackground(autoCompleteTextView, layerDrawable);
        ViewCompat.setPaddingRelative(autoCompleteTextView, paddingStart, paddingTop, paddingEnd, paddingBottom);
    }

    /* access modifiers changed from: private */
    @SuppressLint({"ClickableViewAccessibility"})
    public void setUpDropdownShowHideBehavior(@NonNull final AutoCompleteTextView autoCompleteTextView) {
        autoCompleteTextView.setOnTouchListener(new View.OnTouchListener() {
            public boolean onTouch(@NonNull View view, @NonNull MotionEvent motionEvent) {
                if (motionEvent.getAction() == 1) {
                    if (DropdownMenuEndIconDelegate.this.isDropdownPopupActive()) {
                        boolean unused = DropdownMenuEndIconDelegate.this.dropdownPopupDirty = false;
                    }
                    DropdownMenuEndIconDelegate.this.showHideDropdown(autoCompleteTextView);
                    DropdownMenuEndIconDelegate.this.updateDropdownPopupDirty();
                }
                return false;
            }
        });
        autoCompleteTextView.setOnFocusChangeListener(this.onFocusChangeListener);
        if (IS_LOLLIPOP) {
            autoCompleteTextView.setOnDismissListener(new AutoCompleteTextView.OnDismissListener() {
                public void onDismiss() {
                    DropdownMenuEndIconDelegate.this.updateDropdownPopupDirty();
                    DropdownMenuEndIconDelegate.this.setEndIconChecked(false);
                }
            });
        }
    }

    private MaterialShapeDrawable getPopUpMaterialShapeDrawable(float f, float f2, float f3, int i) {
        ShapeAppearanceModel build = ShapeAppearanceModel.builder().setTopLeftCornerSize(f).setTopRightCornerSize(f).setBottomLeftCornerSize(f2).setBottomRightCornerSize(f2).build();
        MaterialShapeDrawable createWithElevationOverlay = MaterialShapeDrawable.createWithElevationOverlay(this.context, f3);
        createWithElevationOverlay.setShapeAppearanceModel(build);
        createWithElevationOverlay.setPadding(0, i, 0, i);
        return createWithElevationOverlay;
    }

    /* access modifiers changed from: private */
    public boolean isDropdownPopupActive() {
        long currentTimeMillis = System.currentTimeMillis() - this.dropdownPopupActivatedAt;
        return currentTimeMillis < 0 || currentTimeMillis > 300;
    }

    /* access modifiers changed from: private */
    @NonNull
    public static AutoCompleteTextView castAutoCompleteTextViewOrThrow(EditText editText) {
        if (editText instanceof AutoCompleteTextView) {
            return (AutoCompleteTextView) editText;
        }
        throw new RuntimeException("EditText needs to be an AutoCompleteTextView if an Exposed Dropdown Menu is being used.");
    }

    /* access modifiers changed from: private */
    public void updateDropdownPopupDirty() {
        this.dropdownPopupDirty = true;
        this.dropdownPopupActivatedAt = System.currentTimeMillis();
    }

    /* access modifiers changed from: private */
    public static boolean isEditable(@NonNull EditText editText) {
        return editText.getKeyListener() != null;
    }

    /* access modifiers changed from: private */
    public void setEndIconChecked(boolean z) {
        if (this.isEndIconChecked != z) {
            this.isEndIconChecked = z;
            this.fadeInAnim.cancel();
            this.fadeOutAnim.start();
        }
    }

    private void initAnimators() {
        this.fadeInAnim = getAlphaAnimator(67, 0.0f, 1.0f);
        ValueAnimator alphaAnimator = getAlphaAnimator(50, 1.0f, 0.0f);
        this.fadeOutAnim = alphaAnimator;
        alphaAnimator.addListener(new AnimatorListenerAdapter() {
            public void onAnimationEnd(Animator animator) {
                DropdownMenuEndIconDelegate dropdownMenuEndIconDelegate = DropdownMenuEndIconDelegate.this;
                dropdownMenuEndIconDelegate.endIconView.setChecked(dropdownMenuEndIconDelegate.isEndIconChecked);
                DropdownMenuEndIconDelegate.this.fadeInAnim.start();
            }
        });
    }

    private ValueAnimator getAlphaAnimator(int i, float... fArr) {
        ValueAnimator ofFloat = ValueAnimator.ofFloat(fArr);
        ofFloat.setInterpolator(AnimationUtils.LINEAR_INTERPOLATOR);
        ofFloat.setDuration((long) i);
        ofFloat.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            public void onAnimationUpdate(@NonNull ValueAnimator valueAnimator) {
                DropdownMenuEndIconDelegate.this.endIconView.setAlpha(((Float) valueAnimator.getAnimatedValue()).floatValue());
            }
        });
        return ofFloat;
    }
}
