package androidx.core.util;

import android.util.SizeF;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public final class SizeFCompat {
    private final float mHeight;
    private final float mWidth;

    public SizeFCompat(float f, float f2) {
        this.mWidth = Preconditions.checkArgumentFinite(f, "width");
        this.mHeight = Preconditions.checkArgumentFinite(f2, "height");
    }

    public float getWidth() {
        return this.mWidth;
    }

    public float getHeight() {
        return this.mHeight;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof SizeFCompat)) {
            return false;
        }
        SizeFCompat sizeFCompat = (SizeFCompat) obj;
        if (sizeFCompat.mWidth == this.mWidth && sizeFCompat.mHeight == this.mHeight) {
            return true;
        }
        return false;
    }

    public int hashCode() {
        return Float.floatToIntBits(this.mHeight) ^ Float.floatToIntBits(this.mWidth);
    }

    @NonNull
    public String toString() {
        return this.mWidth + "x" + this.mHeight;
    }

    @RequiresApi(21)
    @NonNull
    public SizeF toSizeF() {
        return Api21Impl.toSizeF(this);
    }

    @RequiresApi(21)
    @NonNull
    public static SizeFCompat toSizeFCompat(@NonNull SizeF sizeF) {
        return Api21Impl.toSizeFCompat(sizeF);
    }

    @RequiresApi(21)
    private static final class Api21Impl {
        private Api21Impl() {
        }

        @DoNotInline
        @NonNull
        static SizeFCompat toSizeFCompat(@NonNull SizeF sizeF) {
            Preconditions.checkNotNull(sizeF);
            return new SizeFCompat(sizeF.getWidth(), sizeF.getHeight());
        }

        @DoNotInline
        @NonNull
        static SizeF toSizeF(@NonNull SizeFCompat sizeFCompat) {
            Preconditions.checkNotNull(sizeFCompat);
            return new SizeF(sizeFCompat.getWidth(), sizeFCompat.getHeight());
        }
    }
}
