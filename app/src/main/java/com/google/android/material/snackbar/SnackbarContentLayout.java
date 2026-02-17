package com.google.android.material.snackbar;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import androidx.core.view.ViewCompat;
import com.google.android.material.R;
import com.google.android.material.color.MaterialColors;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
public class SnackbarContentLayout extends LinearLayout implements ContentViewCallback {
    private Button actionView;
    private int maxInlineActionWidth;
    private TextView messageView;

    public SnackbarContentLayout(@NonNull Context context) {
        this(context, (AttributeSet) null);
    }

    public SnackbarContentLayout(@NonNull Context context, @Nullable AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    /* access modifiers changed from: protected */
    public void onFinishInflate() {
        super.onFinishInflate();
        this.messageView = (TextView) findViewById(R.id.snackbar_text);
        this.actionView = (Button) findViewById(R.id.snackbar_action);
    }

    public TextView getMessageView() {
        return this.messageView;
    }

    public Button getActionView() {
        return this.actionView;
    }

    /* access modifiers changed from: package-private */
    public void updateActionTextColorAlphaIfNeeded(float f) {
        if (f != 1.0f) {
            this.actionView.setTextColor(MaterialColors.layer(MaterialColors.getColor(this, R.attr.colorSurface), this.actionView.getCurrentTextColor(), f));
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:13:0x0045, code lost:
        if (updateViewsWithinLayout(1, r0, r0 - r2) != false) goto L_0x0054;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:17:0x0050, code lost:
        if (updateViewsWithinLayout(0, r0, r0) != false) goto L_0x0054;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onMeasure(int r8, int r9) {
        /*
            r7 = this;
            super.onMeasure(r8, r9)
            int r0 = r7.getOrientation()
            r1 = 1
            if (r0 != r1) goto L_0x000b
            return
        L_0x000b:
            android.content.res.Resources r0 = r7.getResources()
            int r2 = com.google.android.material.R.dimen.design_snackbar_padding_vertical_2lines
            int r0 = r0.getDimensionPixelSize(r2)
            android.content.res.Resources r2 = r7.getResources()
            int r3 = com.google.android.material.R.dimen.design_snackbar_padding_vertical
            int r2 = r2.getDimensionPixelSize(r3)
            android.widget.TextView r3 = r7.messageView
            android.text.Layout r3 = r3.getLayout()
            int r3 = r3.getLineCount()
            r4 = 0
            if (r3 <= r1) goto L_0x002e
            r3 = r1
            goto L_0x002f
        L_0x002e:
            r3 = r4
        L_0x002f:
            if (r3 == 0) goto L_0x0048
            int r5 = r7.maxInlineActionWidth
            if (r5 <= 0) goto L_0x0048
            android.widget.Button r5 = r7.actionView
            int r5 = r5.getMeasuredWidth()
            int r6 = r7.maxInlineActionWidth
            if (r5 <= r6) goto L_0x0048
            int r2 = r0 - r2
            boolean r0 = r7.updateViewsWithinLayout(r1, r0, r2)
            if (r0 == 0) goto L_0x0053
            goto L_0x0054
        L_0x0048:
            if (r3 == 0) goto L_0x004b
            goto L_0x004c
        L_0x004b:
            r0 = r2
        L_0x004c:
            boolean r0 = r7.updateViewsWithinLayout(r4, r0, r0)
            if (r0 == 0) goto L_0x0053
            goto L_0x0054
        L_0x0053:
            r1 = r4
        L_0x0054:
            if (r1 == 0) goto L_0x0059
            super.onMeasure(r8, r9)
        L_0x0059:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.snackbar.SnackbarContentLayout.onMeasure(int, int):void");
    }

    private boolean updateViewsWithinLayout(int i, int i2, int i3) {
        boolean z;
        if (i != getOrientation()) {
            setOrientation(i);
            z = true;
        } else {
            z = false;
        }
        if (this.messageView.getPaddingTop() == i2 && this.messageView.getPaddingBottom() == i3) {
            return z;
        }
        updateTopBottomPadding(this.messageView, i2, i3);
        return true;
    }

    private static void updateTopBottomPadding(@NonNull View view, int i, int i2) {
        if (ViewCompat.isPaddingRelative(view)) {
            ViewCompat.setPaddingRelative(view, ViewCompat.getPaddingStart(view), i, ViewCompat.getPaddingEnd(view), i2);
        } else {
            view.setPadding(view.getPaddingLeft(), i, view.getPaddingRight(), i2);
        }
    }

    public void animateContentIn(int i, int i2) {
        this.messageView.setAlpha(0.0f);
        long j = (long) i2;
        long j2 = (long) i;
        this.messageView.animate().alpha(1.0f).setDuration(j).setStartDelay(j2).start();
        if (this.actionView.getVisibility() == 0) {
            this.actionView.setAlpha(0.0f);
            this.actionView.animate().alpha(1.0f).setDuration(j).setStartDelay(j2).start();
        }
    }

    public void animateContentOut(int i, int i2) {
        this.messageView.setAlpha(1.0f);
        long j = (long) i2;
        long j2 = (long) i;
        this.messageView.animate().alpha(0.0f).setDuration(j).setStartDelay(j2).start();
        if (this.actionView.getVisibility() == 0) {
            this.actionView.setAlpha(1.0f);
            this.actionView.animate().alpha(0.0f).setDuration(j).setStartDelay(j2).start();
        }
    }

    public void setMaxInlineActionWidth(int i) {
        this.maxInlineActionWidth = i;
    }
}
