package com.google.android.material.internal;

import android.content.Context;
import android.graphics.Typeface;
import android.text.TextPaint;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import com.google.android.material.resources.TextAppearance;
import com.google.android.material.resources.TextAppearanceFontCallback;
import java.lang.ref.WeakReference;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
public class TextDrawableHelper {
    /* access modifiers changed from: private */
    @Nullable
    public WeakReference<TextDrawableDelegate> delegate = new WeakReference<>((Object) null);
    private final TextAppearanceFontCallback fontCallback = new TextAppearanceFontCallback() {
        public void onFontRetrieved(@NonNull Typeface typeface, boolean z) {
            if (!z) {
                boolean unused = TextDrawableHelper.this.textWidthDirty = true;
                TextDrawableDelegate textDrawableDelegate = (TextDrawableDelegate) TextDrawableHelper.this.delegate.get();
                if (textDrawableDelegate != null) {
                    textDrawableDelegate.onTextSizeChange();
                }
            }
        }

        public void onFontRetrievalFailed(int i) {
            boolean unused = TextDrawableHelper.this.textWidthDirty = true;
            TextDrawableDelegate textDrawableDelegate = (TextDrawableDelegate) TextDrawableHelper.this.delegate.get();
            if (textDrawableDelegate != null) {
                textDrawableDelegate.onTextSizeChange();
            }
        }
    };
    @Nullable
    private TextAppearance textAppearance;
    private final TextPaint textPaint = new TextPaint(1);
    private float textWidth;
    /* access modifiers changed from: private */
    public boolean textWidthDirty = true;

    public interface TextDrawableDelegate {
        @NonNull
        int[] getState();

        boolean onStateChange(int[] iArr);

        void onTextSizeChange();
    }

    public TextDrawableHelper(@Nullable TextDrawableDelegate textDrawableDelegate) {
        setDelegate(textDrawableDelegate);
    }

    public void setDelegate(@Nullable TextDrawableDelegate textDrawableDelegate) {
        this.delegate = new WeakReference<>(textDrawableDelegate);
    }

    @NonNull
    public TextPaint getTextPaint() {
        return this.textPaint;
    }

    public void setTextWidthDirty(boolean z) {
        this.textWidthDirty = z;
    }

    public boolean isTextWidthDirty() {
        return this.textWidthDirty;
    }

    public float getTextWidth(String str) {
        if (!this.textWidthDirty) {
            return this.textWidth;
        }
        float calculateTextWidth = calculateTextWidth(str);
        this.textWidth = calculateTextWidth;
        this.textWidthDirty = false;
        return calculateTextWidth;
    }

    private float calculateTextWidth(@Nullable CharSequence charSequence) {
        if (charSequence == null) {
            return 0.0f;
        }
        return this.textPaint.measureText(charSequence, 0, charSequence.length());
    }

    @Nullable
    public TextAppearance getTextAppearance() {
        return this.textAppearance;
    }

    public void setTextAppearance(@Nullable TextAppearance textAppearance2, Context context) {
        if (this.textAppearance != textAppearance2) {
            this.textAppearance = textAppearance2;
            if (textAppearance2 != null) {
                textAppearance2.updateMeasureState(context, this.textPaint, this.fontCallback);
                TextDrawableDelegate textDrawableDelegate = (TextDrawableDelegate) this.delegate.get();
                if (textDrawableDelegate != null) {
                    this.textPaint.drawableState = textDrawableDelegate.getState();
                }
                textAppearance2.updateDrawState(context, this.textPaint, this.fontCallback);
                this.textWidthDirty = true;
            }
            TextDrawableDelegate textDrawableDelegate2 = (TextDrawableDelegate) this.delegate.get();
            if (textDrawableDelegate2 != null) {
                textDrawableDelegate2.onTextSizeChange();
                textDrawableDelegate2.onStateChange(textDrawableDelegate2.getState());
            }
        }
    }

    public void updateTextPaintDrawState(Context context) {
        this.textAppearance.updateDrawState(context, this.textPaint, this.fontCallback);
    }
}
