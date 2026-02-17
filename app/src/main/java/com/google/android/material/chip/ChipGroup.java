package com.google.android.material.chip;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.accessibility.AccessibilityNodeInfo;
import androidx.annotation.BoolRes;
import androidx.annotation.DimenRes;
import androidx.annotation.Dimension;
import androidx.annotation.IdRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.ViewCompat;
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat;
import com.google.android.material.R;
import com.google.android.material.internal.CheckableGroup;
import com.google.android.material.internal.FlowLayout;
import java.util.List;

public class ChipGroup extends FlowLayout {
    private static final int DEF_STYLE_RES = R.style.Widget_MaterialComponents_ChipGroup;
    /* access modifiers changed from: private */
    public final CheckableGroup<Chip> checkableGroup;
    @Dimension
    private int chipSpacingHorizontal;
    @Dimension
    private int chipSpacingVertical;
    private final int defaultCheckedId;
    /* access modifiers changed from: private */
    @Nullable
    public OnCheckedStateChangeListener onCheckedStateChangeListener;
    @NonNull
    private final PassThroughHierarchyChangeListener passThroughListener;

    @Deprecated
    public interface OnCheckedChangeListener {
        void onCheckedChanged(@NonNull ChipGroup chipGroup, @IdRes int i);
    }

    public interface OnCheckedStateChangeListener {
        void onCheckedChanged(@NonNull ChipGroup chipGroup, @NonNull List<Integer> list);
    }

    public static class LayoutParams extends ViewGroup.MarginLayoutParams {
        public LayoutParams(Context context, AttributeSet attributeSet) {
            super(context, attributeSet);
        }

        public LayoutParams(ViewGroup.LayoutParams layoutParams) {
            super(layoutParams);
        }

        public LayoutParams(int i, int i2) {
            super(i, i2);
        }

        public LayoutParams(ViewGroup.MarginLayoutParams marginLayoutParams) {
            super(marginLayoutParams);
        }
    }

    public ChipGroup(Context context) {
        this(context, (AttributeSet) null);
    }

    public ChipGroup(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, R.attr.chipGroupStyle);
    }

    /* JADX WARNING: Illegal instructions before constructor call */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public ChipGroup(android.content.Context r9, android.util.AttributeSet r10, int r11) {
        /*
            r8 = this;
            int r4 = DEF_STYLE_RES
            android.content.Context r9 = com.google.android.material.theme.overlay.MaterialThemeOverlay.wrap(r9, r10, r11, r4)
            r8.<init>(r9, r10, r11)
            com.google.android.material.internal.CheckableGroup r9 = new com.google.android.material.internal.CheckableGroup
            r9.<init>()
            r8.checkableGroup = r9
            com.google.android.material.chip.ChipGroup$PassThroughHierarchyChangeListener r6 = new com.google.android.material.chip.ChipGroup$PassThroughHierarchyChangeListener
            r0 = 0
            r6.<init>()
            r8.passThroughListener = r6
            android.content.Context r0 = r8.getContext()
            int[] r2 = com.google.android.material.R.styleable.ChipGroup
            r7 = 0
            int[] r5 = new int[r7]
            r1 = r10
            r3 = r11
            android.content.res.TypedArray r10 = com.google.android.material.internal.ThemeEnforcement.obtainStyledAttributes(r0, r1, r2, r3, r4, r5)
            int r11 = com.google.android.material.R.styleable.ChipGroup_chipSpacing
            int r11 = r10.getDimensionPixelOffset(r11, r7)
            int r0 = com.google.android.material.R.styleable.ChipGroup_chipSpacingHorizontal
            int r0 = r10.getDimensionPixelOffset(r0, r11)
            r8.setChipSpacingHorizontal(r0)
            int r0 = com.google.android.material.R.styleable.ChipGroup_chipSpacingVertical
            int r11 = r10.getDimensionPixelOffset(r0, r11)
            r8.setChipSpacingVertical(r11)
            int r11 = com.google.android.material.R.styleable.ChipGroup_singleLine
            boolean r11 = r10.getBoolean(r11, r7)
            r8.setSingleLine((boolean) r11)
            int r11 = com.google.android.material.R.styleable.ChipGroup_singleSelection
            boolean r11 = r10.getBoolean(r11, r7)
            r8.setSingleSelection((boolean) r11)
            int r11 = com.google.android.material.R.styleable.ChipGroup_selectionRequired
            boolean r11 = r10.getBoolean(r11, r7)
            r8.setSelectionRequired(r11)
            int r11 = com.google.android.material.R.styleable.ChipGroup_checkedChip
            r0 = -1
            int r11 = r10.getResourceId(r11, r0)
            r8.defaultCheckedId = r11
            r10.recycle()
            com.google.android.material.chip.ChipGroup$1 r10 = new com.google.android.material.chip.ChipGroup$1
            r10.<init>()
            r9.setOnCheckedStateChangeListener(r10)
            super.setOnHierarchyChangeListener(r6)
            r9 = 1
            androidx.core.view.ViewCompat.setImportantForAccessibility(r8, r9)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.chip.ChipGroup.<init>(android.content.Context, android.util.AttributeSet, int):void");
    }

    public void onInitializeAccessibilityNodeInfo(@NonNull AccessibilityNodeInfo accessibilityNodeInfo) {
        super.onInitializeAccessibilityNodeInfo(accessibilityNodeInfo);
        AccessibilityNodeInfoCompat.wrap(accessibilityNodeInfo).setCollectionInfo(AccessibilityNodeInfoCompat.CollectionInfoCompat.obtain(getRowCount(), isSingleLine() ? getChipCount() : -1, false, isSingleSelection() ? 1 : 2));
    }

    @NonNull
    public ViewGroup.LayoutParams generateLayoutParams(AttributeSet attributeSet) {
        return new LayoutParams(getContext(), attributeSet);
    }

    /* access modifiers changed from: protected */
    @NonNull
    public ViewGroup.LayoutParams generateLayoutParams(ViewGroup.LayoutParams layoutParams) {
        return new LayoutParams(layoutParams);
    }

    /* access modifiers changed from: protected */
    @NonNull
    public ViewGroup.LayoutParams generateDefaultLayoutParams() {
        return new LayoutParams(-2, -2);
    }

    /* access modifiers changed from: protected */
    public boolean checkLayoutParams(ViewGroup.LayoutParams layoutParams) {
        return super.checkLayoutParams(layoutParams) && (layoutParams instanceof LayoutParams);
    }

    public void setOnHierarchyChangeListener(ViewGroup.OnHierarchyChangeListener onHierarchyChangeListener) {
        ViewGroup.OnHierarchyChangeListener unused = this.passThroughListener.onHierarchyChangeListener = onHierarchyChangeListener;
    }

    /* access modifiers changed from: protected */
    public void onFinishInflate() {
        super.onFinishInflate();
        int i = this.defaultCheckedId;
        if (i != -1) {
            this.checkableGroup.check(i);
        }
    }

    @Deprecated
    public void setDividerDrawableHorizontal(Drawable drawable) {
        throw new UnsupportedOperationException("Changing divider drawables have no effect. ChipGroup do not use divider drawables as spacing.");
    }

    @Deprecated
    public void setDividerDrawableVertical(@Nullable Drawable drawable) {
        throw new UnsupportedOperationException("Changing divider drawables have no effect. ChipGroup do not use divider drawables as spacing.");
    }

    @Deprecated
    public void setShowDividerHorizontal(int i) {
        throw new UnsupportedOperationException("Changing divider modes has no effect. ChipGroup do not use divider drawables as spacing.");
    }

    @Deprecated
    public void setShowDividerVertical(int i) {
        throw new UnsupportedOperationException("Changing divider modes has no effect. ChipGroup do not use divider drawables as spacing.");
    }

    @Deprecated
    public void setFlexWrap(int i) {
        throw new UnsupportedOperationException("Changing flex wrap not allowed. ChipGroup exposes a singleLine attribute instead.");
    }

    public void check(@IdRes int i) {
        this.checkableGroup.check(i);
    }

    @IdRes
    public int getCheckedChipId() {
        return this.checkableGroup.getSingleCheckedId();
    }

    @NonNull
    public List<Integer> getCheckedChipIds() {
        return this.checkableGroup.getCheckedIdsSortedByChildOrder(this);
    }

    public void clearCheck() {
        this.checkableGroup.clearCheck();
    }

    @Deprecated
    public void setOnCheckedChangeListener(@Nullable final OnCheckedChangeListener onCheckedChangeListener) {
        if (onCheckedChangeListener == null) {
            setOnCheckedStateChangeListener((OnCheckedStateChangeListener) null);
        } else {
            setOnCheckedStateChangeListener(new OnCheckedStateChangeListener() {
                public void onCheckedChanged(@NonNull ChipGroup chipGroup, @NonNull List<Integer> list) {
                    if (ChipGroup.this.checkableGroup.isSingleSelection()) {
                        onCheckedChangeListener.onCheckedChanged(chipGroup, ChipGroup.this.getCheckedChipId());
                    }
                }
            });
        }
    }

    public void setOnCheckedStateChangeListener(@Nullable OnCheckedStateChangeListener onCheckedStateChangeListener2) {
        this.onCheckedStateChangeListener = onCheckedStateChangeListener2;
    }

    private int getChipCount() {
        int i = 0;
        for (int i2 = 0; i2 < getChildCount(); i2++) {
            if (getChildAt(i2) instanceof Chip) {
                i++;
            }
        }
        return i;
    }

    /* access modifiers changed from: package-private */
    public int getIndexOfChip(@Nullable View view) {
        if (!(view instanceof Chip)) {
            return -1;
        }
        int i = 0;
        for (int i2 = 0; i2 < getChildCount(); i2++) {
            if (getChildAt(i2) instanceof Chip) {
                if (((Chip) getChildAt(i2)) == view) {
                    return i;
                }
                i++;
            }
        }
        return -1;
    }

    public void setChipSpacing(@Dimension int i) {
        setChipSpacingHorizontal(i);
        setChipSpacingVertical(i);
    }

    public void setChipSpacingResource(@DimenRes int i) {
        setChipSpacing(getResources().getDimensionPixelOffset(i));
    }

    @Dimension
    public int getChipSpacingHorizontal() {
        return this.chipSpacingHorizontal;
    }

    public void setChipSpacingHorizontal(@Dimension int i) {
        if (this.chipSpacingHorizontal != i) {
            this.chipSpacingHorizontal = i;
            setItemSpacing(i);
            requestLayout();
        }
    }

    public void setChipSpacingHorizontalResource(@DimenRes int i) {
        setChipSpacingHorizontal(getResources().getDimensionPixelOffset(i));
    }

    @Dimension
    public int getChipSpacingVertical() {
        return this.chipSpacingVertical;
    }

    public void setChipSpacingVertical(@Dimension int i) {
        if (this.chipSpacingVertical != i) {
            this.chipSpacingVertical = i;
            setLineSpacing(i);
            requestLayout();
        }
    }

    public void setChipSpacingVerticalResource(@DimenRes int i) {
        setChipSpacingVertical(getResources().getDimensionPixelOffset(i));
    }

    public boolean isSingleLine() {
        return super.isSingleLine();
    }

    public void setSingleLine(boolean z) {
        super.setSingleLine(z);
    }

    public void setSingleLine(@BoolRes int i) {
        setSingleLine(getResources().getBoolean(i));
    }

    public boolean isSingleSelection() {
        return this.checkableGroup.isSingleSelection();
    }

    public void setSingleSelection(boolean z) {
        this.checkableGroup.setSingleSelection(z);
    }

    public void setSingleSelection(@BoolRes int i) {
        setSingleSelection(getResources().getBoolean(i));
    }

    public void setSelectionRequired(boolean z) {
        this.checkableGroup.setSelectionRequired(z);
    }

    public boolean isSelectionRequired() {
        return this.checkableGroup.isSelectionRequired();
    }

    private class PassThroughHierarchyChangeListener implements ViewGroup.OnHierarchyChangeListener {
        /* access modifiers changed from: private */
        public ViewGroup.OnHierarchyChangeListener onHierarchyChangeListener;

        private PassThroughHierarchyChangeListener() {
        }

        public void onChildViewAdded(View view, View view2) {
            if (view == ChipGroup.this && (view2 instanceof Chip)) {
                if (view2.getId() == -1) {
                    view2.setId(ViewCompat.generateViewId());
                }
                ChipGroup.this.checkableGroup.addCheckable((Chip) view2);
            }
            ViewGroup.OnHierarchyChangeListener onHierarchyChangeListener2 = this.onHierarchyChangeListener;
            if (onHierarchyChangeListener2 != null) {
                onHierarchyChangeListener2.onChildViewAdded(view, view2);
            }
        }

        public void onChildViewRemoved(View view, View view2) {
            ChipGroup chipGroup = ChipGroup.this;
            if (view == chipGroup && (view2 instanceof Chip)) {
                chipGroup.checkableGroup.removeCheckable((Chip) view2);
            }
            ViewGroup.OnHierarchyChangeListener onHierarchyChangeListener2 = this.onHierarchyChangeListener;
            if (onHierarchyChangeListener2 != null) {
                onHierarchyChangeListener2.onChildViewRemoved(view, view2);
            }
        }
    }
}
