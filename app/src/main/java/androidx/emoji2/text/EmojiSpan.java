package androidx.emoji2.text;

import android.annotation.SuppressLint;
import android.graphics.Paint;
import android.text.style.ReplacementSpan;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.core.util.Preconditions;

@RequiresApi(19)
public abstract class EmojiSpan extends ReplacementSpan {
    private short mHeight = -1;
    @NonNull
    private final EmojiMetadata mMetadata;
    private float mRatio = 1.0f;
    private final Paint.FontMetricsInt mTmpFontMetrics = new Paint.FontMetricsInt();
    private short mWidth = -1;

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    EmojiSpan(@NonNull EmojiMetadata emojiMetadata) {
        Preconditions.checkNotNull(emojiMetadata, "metadata cannot be null");
        this.mMetadata = emojiMetadata;
    }

    public int getSize(@NonNull Paint paint, @SuppressLint({"UnknownNullness"}) CharSequence charSequence, int i, int i2, @Nullable Paint.FontMetricsInt fontMetricsInt) {
        paint.getFontMetricsInt(this.mTmpFontMetrics);
        Paint.FontMetricsInt fontMetricsInt2 = this.mTmpFontMetrics;
        this.mRatio = (((float) Math.abs(fontMetricsInt2.descent - fontMetricsInt2.ascent)) * 1.0f) / ((float) this.mMetadata.getHeight());
        this.mHeight = (short) ((int) (((float) this.mMetadata.getHeight()) * this.mRatio));
        short width = (short) ((int) (((float) this.mMetadata.getWidth()) * this.mRatio));
        this.mWidth = width;
        if (fontMetricsInt != null) {
            Paint.FontMetricsInt fontMetricsInt3 = this.mTmpFontMetrics;
            fontMetricsInt.ascent = fontMetricsInt3.ascent;
            fontMetricsInt.descent = fontMetricsInt3.descent;
            fontMetricsInt.top = fontMetricsInt3.top;
            fontMetricsInt.bottom = fontMetricsInt3.bottom;
        }
        return width;
    }

    @NonNull
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public final EmojiMetadata getMetadata() {
        return this.mMetadata;
    }

    /* access modifiers changed from: package-private */
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public final int getWidth() {
        return this.mWidth;
    }

    @RestrictTo({RestrictTo.Scope.TESTS})
    public final int getHeight() {
        return this.mHeight;
    }

    /* access modifiers changed from: package-private */
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public final float getRatio() {
        return this.mRatio;
    }

    @RestrictTo({RestrictTo.Scope.TESTS})
    public final int getId() {
        return getMetadata().getId();
    }
}
