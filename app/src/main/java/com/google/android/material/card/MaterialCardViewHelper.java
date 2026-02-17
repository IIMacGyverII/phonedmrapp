package com.google.android.material.card;

import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.InsetDrawable;
import android.graphics.drawable.LayerDrawable;
import android.graphics.drawable.RippleDrawable;
import android.graphics.drawable.StateListDrawable;
import android.util.AttributeSet;
import androidx.annotation.ColorInt;
import androidx.annotation.Dimension;
import androidx.annotation.FloatRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.annotation.StyleRes;
import androidx.core.graphics.drawable.DrawableCompat;
import androidx.core.view.GravityCompat;
import androidx.core.view.ViewCompat;
import com.google.android.material.R;
import com.google.android.material.color.MaterialColors;
import com.google.android.material.resources.MaterialResources;
import com.google.android.material.ripple.RippleUtils;
import com.google.android.material.shape.CornerTreatment;
import com.google.android.material.shape.CutCornerTreatment;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.RoundedCornerTreatment;
import com.google.android.material.shape.ShapeAppearanceModel;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
class MaterialCardViewHelper {
    private static final float CARD_VIEW_SHADOW_MULTIPLIER = 1.5f;
    private static final int CHECKED_ICON_LAYER_INDEX = 2;
    private static final Drawable CHECKED_ICON_NONE = null;
    private static final double COS_45 = Math.cos(Math.toRadians(45.0d));
    private static final int DEFAULT_STROKE_VALUE = -1;
    @NonNull
    private final MaterialShapeDrawable bgDrawable;
    private boolean checkable;
    @Nullable
    private Drawable checkedIcon;
    private int checkedIconGravity;
    @Dimension
    private int checkedIconMargin;
    @Dimension
    private int checkedIconSize;
    @Nullable
    private ColorStateList checkedIconTint;
    @Nullable
    private LayerDrawable clickableForegroundDrawable;
    @Nullable
    private MaterialShapeDrawable compatRippleDrawable;
    @Nullable
    private Drawable fgDrawable;
    @NonNull
    private final MaterialShapeDrawable foregroundContentDrawable;
    @Nullable
    private MaterialShapeDrawable foregroundShapeDrawable;
    private boolean isBackgroundOverwritten = false;
    @NonNull
    private final MaterialCardView materialCardView;
    @Nullable
    private ColorStateList rippleColor;
    @Nullable
    private Drawable rippleDrawable;
    @Nullable
    private ShapeAppearanceModel shapeAppearanceModel;
    @Nullable
    private ColorStateList strokeColor;
    @Dimension
    private int strokeWidth;
    @NonNull
    private final Rect userContentPadding = new Rect();

    public MaterialCardViewHelper(@NonNull MaterialCardView materialCardView2, AttributeSet attributeSet, int i, @StyleRes int i2) {
        this.materialCardView = materialCardView2;
        MaterialShapeDrawable materialShapeDrawable = new MaterialShapeDrawable(materialCardView2.getContext(), attributeSet, i, i2);
        this.bgDrawable = materialShapeDrawable;
        materialShapeDrawable.initializeElevationOverlay(materialCardView2.getContext());
        materialShapeDrawable.setShadowColor(-12303292);
        ShapeAppearanceModel.Builder builder = materialShapeDrawable.getShapeAppearanceModel().toBuilder();
        TypedArray obtainStyledAttributes = materialCardView2.getContext().obtainStyledAttributes(attributeSet, R.styleable.CardView, i, R.style.CardView);
        int i3 = R.styleable.CardView_cardCornerRadius;
        if (obtainStyledAttributes.hasValue(i3)) {
            builder.setAllCornerSizes(obtainStyledAttributes.getDimension(i3, 0.0f));
        }
        this.foregroundContentDrawable = new MaterialShapeDrawable();
        setShapeAppearanceModel(builder.build());
        obtainStyledAttributes.recycle();
    }

    /* access modifiers changed from: package-private */
    public void loadFromAttributes(@NonNull TypedArray typedArray) {
        ColorStateList colorStateList = MaterialResources.getColorStateList(this.materialCardView.getContext(), typedArray, R.styleable.MaterialCardView_strokeColor);
        this.strokeColor = colorStateList;
        if (colorStateList == null) {
            this.strokeColor = ColorStateList.valueOf(-1);
        }
        this.strokeWidth = typedArray.getDimensionPixelSize(R.styleable.MaterialCardView_strokeWidth, 0);
        boolean z = typedArray.getBoolean(R.styleable.MaterialCardView_android_checkable, false);
        this.checkable = z;
        this.materialCardView.setLongClickable(z);
        this.checkedIconTint = MaterialResources.getColorStateList(this.materialCardView.getContext(), typedArray, R.styleable.MaterialCardView_checkedIconTint);
        setCheckedIcon(MaterialResources.getDrawable(this.materialCardView.getContext(), typedArray, R.styleable.MaterialCardView_checkedIcon));
        setCheckedIconSize(typedArray.getDimensionPixelSize(R.styleable.MaterialCardView_checkedIconSize, 0));
        setCheckedIconMargin(typedArray.getDimensionPixelSize(R.styleable.MaterialCardView_checkedIconMargin, 0));
        this.checkedIconGravity = typedArray.getInteger(R.styleable.MaterialCardView_checkedIconGravity, 8388661);
        ColorStateList colorStateList2 = MaterialResources.getColorStateList(this.materialCardView.getContext(), typedArray, R.styleable.MaterialCardView_rippleColor);
        this.rippleColor = colorStateList2;
        if (colorStateList2 == null) {
            this.rippleColor = ColorStateList.valueOf(MaterialColors.getColor(this.materialCardView, R.attr.colorControlHighlight));
        }
        setCardForegroundColor(MaterialResources.getColorStateList(this.materialCardView.getContext(), typedArray, R.styleable.MaterialCardView_cardForegroundColor));
        updateRippleColor();
        updateElevation();
        updateStroke();
        this.materialCardView.setBackgroundInternal(insetDrawable(this.bgDrawable));
        Drawable clickableForeground = this.materialCardView.isClickable() ? getClickableForeground() : this.foregroundContentDrawable;
        this.fgDrawable = clickableForeground;
        this.materialCardView.setForeground(insetDrawable(clickableForeground));
    }

    /* access modifiers changed from: package-private */
    public boolean isBackgroundOverwritten() {
        return this.isBackgroundOverwritten;
    }

    /* access modifiers changed from: package-private */
    public void setBackgroundOverwritten(boolean z) {
        this.isBackgroundOverwritten = z;
    }

    /* access modifiers changed from: package-private */
    public void setStrokeColor(ColorStateList colorStateList) {
        if (this.strokeColor != colorStateList) {
            this.strokeColor = colorStateList;
            updateStroke();
        }
    }

    /* access modifiers changed from: package-private */
    @ColorInt
    public int getStrokeColor() {
        ColorStateList colorStateList = this.strokeColor;
        if (colorStateList == null) {
            return -1;
        }
        return colorStateList.getDefaultColor();
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public ColorStateList getStrokeColorStateList() {
        return this.strokeColor;
    }

    /* access modifiers changed from: package-private */
    public void setStrokeWidth(@Dimension int i) {
        if (i != this.strokeWidth) {
            this.strokeWidth = i;
            updateStroke();
        }
    }

    /* access modifiers changed from: package-private */
    @Dimension
    public int getStrokeWidth() {
        return this.strokeWidth;
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public MaterialShapeDrawable getBackground() {
        return this.bgDrawable;
    }

    /* access modifiers changed from: package-private */
    public void setCardBackgroundColor(ColorStateList colorStateList) {
        this.bgDrawable.setFillColor(colorStateList);
    }

    /* access modifiers changed from: package-private */
    public ColorStateList getCardBackgroundColor() {
        return this.bgDrawable.getFillColor();
    }

    /* access modifiers changed from: package-private */
    public void setCardForegroundColor(@Nullable ColorStateList colorStateList) {
        MaterialShapeDrawable materialShapeDrawable = this.foregroundContentDrawable;
        if (colorStateList == null) {
            colorStateList = ColorStateList.valueOf(0);
        }
        materialShapeDrawable.setFillColor(colorStateList);
    }

    /* access modifiers changed from: package-private */
    public ColorStateList getCardForegroundColor() {
        return this.foregroundContentDrawable.getFillColor();
    }

    /* access modifiers changed from: package-private */
    public void setUserContentPadding(int i, int i2, int i3, int i4) {
        this.userContentPadding.set(i, i2, i3, i4);
        updateContentPadding();
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public Rect getUserContentPadding() {
        return this.userContentPadding;
    }

    /* access modifiers changed from: package-private */
    public void updateClickable() {
        Drawable drawable = this.fgDrawable;
        Drawable clickableForeground = this.materialCardView.isClickable() ? getClickableForeground() : this.foregroundContentDrawable;
        this.fgDrawable = clickableForeground;
        if (drawable != clickableForeground) {
            updateInsetForeground(clickableForeground);
        }
    }

    /* access modifiers changed from: package-private */
    public void setCornerRadius(float f) {
        setShapeAppearanceModel(this.shapeAppearanceModel.withCornerSize(f));
        this.fgDrawable.invalidateSelf();
        if (shouldAddCornerPaddingOutsideCardBackground() || shouldAddCornerPaddingInsideCardBackground()) {
            updateContentPadding();
        }
        if (shouldAddCornerPaddingOutsideCardBackground()) {
            updateInsets();
        }
    }

    /* access modifiers changed from: package-private */
    public float getCornerRadius() {
        return this.bgDrawable.getTopLeftCornerResolvedSize();
    }

    /* access modifiers changed from: package-private */
    public void setProgress(@FloatRange(from = 0.0d, to = 1.0d) float f) {
        this.bgDrawable.setInterpolation(f);
        MaterialShapeDrawable materialShapeDrawable = this.foregroundContentDrawable;
        if (materialShapeDrawable != null) {
            materialShapeDrawable.setInterpolation(f);
        }
        MaterialShapeDrawable materialShapeDrawable2 = this.foregroundShapeDrawable;
        if (materialShapeDrawable2 != null) {
            materialShapeDrawable2.setInterpolation(f);
        }
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = 0.0d, to = 1.0d)
    public float getProgress() {
        return this.bgDrawable.getInterpolation();
    }

    /* access modifiers changed from: package-private */
    public void updateElevation() {
        this.bgDrawable.setElevation(this.materialCardView.getCardElevation());
    }

    /* access modifiers changed from: package-private */
    public void updateInsets() {
        if (!isBackgroundOverwritten()) {
            this.materialCardView.setBackgroundInternal(insetDrawable(this.bgDrawable));
        }
        this.materialCardView.setForeground(insetDrawable(this.fgDrawable));
    }

    /* access modifiers changed from: package-private */
    public void updateStroke() {
        this.foregroundContentDrawable.setStroke((float) this.strokeWidth, this.strokeColor);
    }

    /* access modifiers changed from: package-private */
    public void updateContentPadding() {
        int calculateActualCornerPadding = (int) ((shouldAddCornerPaddingInsideCardBackground() || shouldAddCornerPaddingOutsideCardBackground() ? calculateActualCornerPadding() : 0.0f) - getParentCardViewCalculatedCornerPadding());
        MaterialCardView materialCardView2 = this.materialCardView;
        Rect rect = this.userContentPadding;
        materialCardView2.setAncestorContentPadding(rect.left + calculateActualCornerPadding, rect.top + calculateActualCornerPadding, rect.right + calculateActualCornerPadding, rect.bottom + calculateActualCornerPadding);
    }

    /* access modifiers changed from: package-private */
    public void setCheckable(boolean z) {
        this.checkable = z;
    }

    /* access modifiers changed from: package-private */
    public boolean isCheckable() {
        return this.checkable;
    }

    /* access modifiers changed from: package-private */
    public void setRippleColor(@Nullable ColorStateList colorStateList) {
        this.rippleColor = colorStateList;
        updateRippleColor();
    }

    /* access modifiers changed from: package-private */
    public void setCheckedIconTint(@Nullable ColorStateList colorStateList) {
        this.checkedIconTint = colorStateList;
        Drawable drawable = this.checkedIcon;
        if (drawable != null) {
            DrawableCompat.setTintList(drawable, colorStateList);
        }
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public ColorStateList getCheckedIconTint() {
        return this.checkedIconTint;
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public ColorStateList getRippleColor() {
        return this.rippleColor;
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public Drawable getCheckedIcon() {
        return this.checkedIcon;
    }

    /* access modifiers changed from: package-private */
    public void setCheckedIcon(@Nullable Drawable drawable) {
        if (drawable != null) {
            Drawable mutate = DrawableCompat.wrap(drawable).mutate();
            this.checkedIcon = mutate;
            DrawableCompat.setTintList(mutate, this.checkedIconTint);
            setChecked(this.materialCardView.isChecked());
        } else {
            this.checkedIcon = CHECKED_ICON_NONE;
        }
        LayerDrawable layerDrawable = this.clickableForegroundDrawable;
        if (layerDrawable != null) {
            layerDrawable.setDrawableByLayerId(R.id.mtrl_card_checked_layer_id, this.checkedIcon);
        }
    }

    /* access modifiers changed from: package-private */
    @Dimension
    public int getCheckedIconSize() {
        return this.checkedIconSize;
    }

    /* access modifiers changed from: package-private */
    public void setCheckedIconSize(@Dimension int i) {
        this.checkedIconSize = i;
    }

    /* access modifiers changed from: package-private */
    @Dimension
    public int getCheckedIconMargin() {
        return this.checkedIconMargin;
    }

    /* access modifiers changed from: package-private */
    public void setCheckedIconMargin(@Dimension int i) {
        this.checkedIconMargin = i;
    }

    /* access modifiers changed from: package-private */
    public void recalculateCheckedIconPosition(int i, int i2) {
        int i3;
        int i4;
        int i5;
        int i6;
        int i7;
        int i8;
        int i9;
        if (this.clickableForegroundDrawable != null) {
            int i10 = 0;
            if (this.materialCardView.getUseCompatPadding()) {
                i3 = (int) Math.ceil((double) (calculateVerticalBackgroundPadding() * 2.0f));
                i10 = (int) Math.ceil((double) (calculateHorizontalBackgroundPadding() * 2.0f));
            } else {
                i3 = 0;
            }
            if (isCheckedIconEnd()) {
                i4 = ((i - this.checkedIconMargin) - this.checkedIconSize) - i10;
            } else {
                i4 = this.checkedIconMargin;
            }
            if (isCheckedIconBottom()) {
                i5 = this.checkedIconMargin;
            } else {
                i5 = ((i2 - this.checkedIconMargin) - this.checkedIconSize) - i3;
            }
            int i11 = i5;
            if (isCheckedIconEnd()) {
                i6 = this.checkedIconMargin;
            } else {
                i6 = ((i - this.checkedIconMargin) - this.checkedIconSize) - i10;
            }
            if (isCheckedIconBottom()) {
                i7 = ((i2 - this.checkedIconMargin) - this.checkedIconSize) - i3;
            } else {
                i7 = this.checkedIconMargin;
            }
            int i12 = i7;
            if (ViewCompat.getLayoutDirection(this.materialCardView) == 1) {
                i9 = i6;
                i8 = i4;
            } else {
                i8 = i6;
                i9 = i4;
            }
            this.clickableForegroundDrawable.setLayerInset(2, i9, i12, i8, i11);
        }
    }

    /* access modifiers changed from: package-private */
    @RequiresApi(api = 23)
    public void forceRippleRedraw() {
        Drawable drawable = this.rippleDrawable;
        if (drawable != null) {
            Rect bounds = drawable.getBounds();
            int i = bounds.bottom;
            this.rippleDrawable.setBounds(bounds.left, bounds.top, bounds.right, i - 1);
            this.rippleDrawable.setBounds(bounds.left, bounds.top, bounds.right, i);
        }
    }

    /* access modifiers changed from: package-private */
    public void setShapeAppearanceModel(@NonNull ShapeAppearanceModel shapeAppearanceModel2) {
        this.shapeAppearanceModel = shapeAppearanceModel2;
        this.bgDrawable.setShapeAppearanceModel(shapeAppearanceModel2);
        MaterialShapeDrawable materialShapeDrawable = this.bgDrawable;
        materialShapeDrawable.setShadowBitmapDrawingEnable(!materialShapeDrawable.isRoundRect());
        MaterialShapeDrawable materialShapeDrawable2 = this.foregroundContentDrawable;
        if (materialShapeDrawable2 != null) {
            materialShapeDrawable2.setShapeAppearanceModel(shapeAppearanceModel2);
        }
        MaterialShapeDrawable materialShapeDrawable3 = this.foregroundShapeDrawable;
        if (materialShapeDrawable3 != null) {
            materialShapeDrawable3.setShapeAppearanceModel(shapeAppearanceModel2);
        }
        MaterialShapeDrawable materialShapeDrawable4 = this.compatRippleDrawable;
        if (materialShapeDrawable4 != null) {
            materialShapeDrawable4.setShapeAppearanceModel(shapeAppearanceModel2);
        }
    }

    /* access modifiers changed from: package-private */
    public ShapeAppearanceModel getShapeAppearanceModel() {
        return this.shapeAppearanceModel;
    }

    private void updateInsetForeground(Drawable drawable) {
        if (this.materialCardView.getForeground() instanceof InsetDrawable) {
            ((InsetDrawable) this.materialCardView.getForeground()).setDrawable(drawable);
        } else {
            this.materialCardView.setForeground(insetDrawable(drawable));
        }
    }

    @NonNull
    private Drawable insetDrawable(Drawable drawable) {
        int i;
        int i2;
        if (this.materialCardView.getUseCompatPadding()) {
            int ceil = (int) Math.ceil((double) calculateVerticalBackgroundPadding());
            i2 = (int) Math.ceil((double) calculateHorizontalBackgroundPadding());
            i = ceil;
        } else {
            i2 = 0;
            i = 0;
        }
        return new InsetDrawable(drawable, i2, i, i2, i) {
            public int getMinimumHeight() {
                return -1;
            }

            public int getMinimumWidth() {
                return -1;
            }

            public boolean getPadding(Rect rect) {
                return false;
            }
        };
    }

    private float calculateVerticalBackgroundPadding() {
        return (this.materialCardView.getMaxCardElevation() * CARD_VIEW_SHADOW_MULTIPLIER) + (shouldAddCornerPaddingOutsideCardBackground() ? calculateActualCornerPadding() : 0.0f);
    }

    private float calculateHorizontalBackgroundPadding() {
        return this.materialCardView.getMaxCardElevation() + (shouldAddCornerPaddingOutsideCardBackground() ? calculateActualCornerPadding() : 0.0f);
    }

    private boolean canClipToOutline() {
        return this.bgDrawable.isRoundRect();
    }

    private float getParentCardViewCalculatedCornerPadding() {
        if (!this.materialCardView.getPreventCornerOverlap() || !this.materialCardView.getUseCompatPadding()) {
            return 0.0f;
        }
        return (float) ((1.0d - COS_45) * ((double) this.materialCardView.getCardViewRadius()));
    }

    private boolean shouldAddCornerPaddingInsideCardBackground() {
        return this.materialCardView.getPreventCornerOverlap() && !canClipToOutline();
    }

    private boolean shouldAddCornerPaddingOutsideCardBackground() {
        return this.materialCardView.getPreventCornerOverlap() && canClipToOutline() && this.materialCardView.getUseCompatPadding();
    }

    private float calculateActualCornerPadding() {
        return Math.max(Math.max(calculateCornerPaddingForCornerTreatment(this.shapeAppearanceModel.getTopLeftCorner(), this.bgDrawable.getTopLeftCornerResolvedSize()), calculateCornerPaddingForCornerTreatment(this.shapeAppearanceModel.getTopRightCorner(), this.bgDrawable.getTopRightCornerResolvedSize())), Math.max(calculateCornerPaddingForCornerTreatment(this.shapeAppearanceModel.getBottomRightCorner(), this.bgDrawable.getBottomRightCornerResolvedSize()), calculateCornerPaddingForCornerTreatment(this.shapeAppearanceModel.getBottomLeftCorner(), this.bgDrawable.getBottomLeftCornerResolvedSize())));
    }

    private float calculateCornerPaddingForCornerTreatment(CornerTreatment cornerTreatment, float f) {
        if (cornerTreatment instanceof RoundedCornerTreatment) {
            return (float) ((1.0d - COS_45) * ((double) f));
        }
        if (cornerTreatment instanceof CutCornerTreatment) {
            return f / 2.0f;
        }
        return 0.0f;
    }

    @NonNull
    private Drawable getClickableForeground() {
        if (this.rippleDrawable == null) {
            this.rippleDrawable = createForegroundRippleDrawable();
        }
        if (this.clickableForegroundDrawable == null) {
            LayerDrawable layerDrawable = new LayerDrawable(new Drawable[]{this.rippleDrawable, this.foregroundContentDrawable, this.checkedIcon});
            this.clickableForegroundDrawable = layerDrawable;
            layerDrawable.setId(2, R.id.mtrl_card_checked_layer_id);
        }
        return this.clickableForegroundDrawable;
    }

    @NonNull
    private Drawable createForegroundRippleDrawable() {
        if (!RippleUtils.USE_FRAMEWORK_RIPPLE) {
            return createCompatRippleDrawable();
        }
        this.foregroundShapeDrawable = createForegroundShapeDrawable();
        return new RippleDrawable(this.rippleColor, (Drawable) null, this.foregroundShapeDrawable);
    }

    @NonNull
    private Drawable createCompatRippleDrawable() {
        StateListDrawable stateListDrawable = new StateListDrawable();
        MaterialShapeDrawable createForegroundShapeDrawable = createForegroundShapeDrawable();
        this.compatRippleDrawable = createForegroundShapeDrawable;
        createForegroundShapeDrawable.setFillColor(this.rippleColor);
        stateListDrawable.addState(new int[]{16842919}, this.compatRippleDrawable);
        return stateListDrawable;
    }

    private void updateRippleColor() {
        Drawable drawable;
        if (!RippleUtils.USE_FRAMEWORK_RIPPLE || (drawable = this.rippleDrawable) == null) {
            MaterialShapeDrawable materialShapeDrawable = this.compatRippleDrawable;
            if (materialShapeDrawable != null) {
                materialShapeDrawable.setFillColor(this.rippleColor);
                return;
            }
            return;
        }
        ((RippleDrawable) drawable).setColor(this.rippleColor);
    }

    @NonNull
    private MaterialShapeDrawable createForegroundShapeDrawable() {
        return new MaterialShapeDrawable(this.shapeAppearanceModel);
    }

    public void setChecked(boolean z) {
        Drawable drawable = this.checkedIcon;
        if (drawable != null) {
            drawable.setAlpha(z ? 255 : 0);
        }
    }

    /* access modifiers changed from: package-private */
    public int getCheckedIconGravity() {
        return this.checkedIconGravity;
    }

    /* access modifiers changed from: package-private */
    public void setCheckedIconGravity(int i) {
        this.checkedIconGravity = i;
        recalculateCheckedIconPosition(this.materialCardView.getMeasuredWidth(), this.materialCardView.getMeasuredHeight());
    }

    private boolean isCheckedIconEnd() {
        return (this.checkedIconGravity & GravityCompat.END) == 8388613;
    }

    private boolean isCheckedIconBottom() {
        return (this.checkedIconGravity & 80) == 80;
    }
}
