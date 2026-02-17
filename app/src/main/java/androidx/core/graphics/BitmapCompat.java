package androidx.core.graphics;

import android.graphics.Bitmap;
import android.graphics.BlendMode;
import android.graphics.Canvas;
import android.graphics.ColorSpace;
import android.graphics.Paint;
import android.graphics.Rect;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.VisibleForTesting;

public final class BitmapCompat {
    @VisibleForTesting
    public static int sizeAtStep(int i, int i2, int i3, int i4) {
        return i3 == 0 ? i2 : i3 > 0 ? i * (1 << (i4 - i3)) : i2 << ((-i3) - 1);
    }

    public static boolean hasMipMap(@NonNull Bitmap bitmap) {
        return Api17Impl.hasMipMap(bitmap);
    }

    public static void setHasMipMap(@NonNull Bitmap bitmap, boolean z) {
        Api17Impl.setHasMipMap(bitmap, z);
    }

    public static int getAllocationByteCount(@NonNull Bitmap bitmap) {
        return Api19Impl.getAllocationByteCount(bitmap);
    }

    @NonNull
    public static Bitmap createScaledBitmap(@NonNull Bitmap bitmap, int i, int i2, @Nullable Rect rect, boolean z) {
        int i3;
        double d;
        double d2;
        int i4;
        int i5;
        Bitmap bitmap2;
        Bitmap bitmap3 = bitmap;
        int i6 = i;
        int i7 = i2;
        Rect rect2 = rect;
        if (i6 <= 0 || i7 <= 0) {
            throw new IllegalArgumentException("dstW and dstH must be > 0!");
        } else if (rect2 == null || (!rect.isEmpty() && rect2.left >= 0 && rect2.right <= bitmap.getWidth() && rect2.top >= 0 && rect2.bottom <= bitmap.getHeight())) {
            Bitmap copyBitmapIfHardware = Api27Impl.copyBitmapIfHardware(bitmap);
            int width = rect2 != null ? rect.width() : bitmap.getWidth();
            int height = rect2 != null ? rect.height() : bitmap.getHeight();
            float f = ((float) i6) / ((float) width);
            float f2 = ((float) i7) / ((float) height);
            int i8 = rect2 != null ? rect2.left : 0;
            int i9 = rect2 != null ? rect2.top : 0;
            if (i8 == 0 && i9 == 0 && i6 == bitmap.getWidth() && i7 == bitmap.getHeight()) {
                return (!bitmap.isMutable() || bitmap3 != copyBitmapIfHardware) ? copyBitmapIfHardware : bitmap3.copy(bitmap.getConfig(), true);
            }
            Paint paint = new Paint(1);
            paint.setFilterBitmap(true);
            Api29Impl.setPaintBlendMode(paint);
            if (width == i6 && height == i7) {
                Bitmap createBitmap = Bitmap.createBitmap(i6, i7, copyBitmapIfHardware.getConfig());
                new Canvas(createBitmap).drawBitmap(copyBitmapIfHardware, (float) (-i8), (float) (-i9), paint);
                return createBitmap;
            }
            double log = Math.log(2.0d);
            if (f > 1.0f) {
                i3 = i8;
                d = Math.ceil(Math.log((double) f) / log);
            } else {
                i3 = i8;
                d = Math.floor(Math.log((double) f) / log);
            }
            int i10 = (int) d;
            if (f2 > 1.0f) {
                d2 = Math.ceil(Math.log((double) f2) / log);
            } else {
                d2 = Math.floor(Math.log((double) f2) / log);
            }
            int i11 = (int) d2;
            Bitmap bitmap4 = null;
            if (!z || Api27Impl.isAlreadyF16AndLinear(bitmap)) {
                i5 = i3;
                i4 = 0;
            } else {
                Bitmap createBitmapWithSourceColorspace = Api27Impl.createBitmapWithSourceColorspace(i10 > 0 ? sizeAtStep(width, i6, 1, i10) : width, i11 > 0 ? sizeAtStep(height, i7, 1, i11) : height, bitmap3, true);
                new Canvas(createBitmapWithSourceColorspace).drawBitmap(copyBitmapIfHardware, (float) (-i3), (float) (-i9), paint);
                i4 = 1;
                i9 = 0;
                i5 = 0;
                Bitmap bitmap5 = createBitmapWithSourceColorspace;
                bitmap4 = copyBitmapIfHardware;
                copyBitmapIfHardware = bitmap5;
            }
            Rect rect3 = new Rect(i5, i9, width, height);
            Rect rect4 = new Rect();
            int i12 = i10;
            int i13 = i11;
            while (true) {
                if (i12 == 0 && i13 == 0) {
                    break;
                }
                if (i12 < 0) {
                    i12++;
                } else if (i12 > 0) {
                    i12--;
                }
                if (i13 < 0) {
                    i13++;
                } else if (i13 > 0) {
                    i13--;
                }
                Bitmap bitmap6 = bitmap2;
                Paint paint2 = paint;
                rect4.set(0, 0, sizeAtStep(width, i6, i12, i10), sizeAtStep(height, i7, i13, i11));
                boolean z2 = i12 == 0 && i13 == 0;
                boolean z3 = bitmap4 != null && bitmap4.getWidth() == i6 && bitmap4.getHeight() == i7;
                if (bitmap4 == null || bitmap4 == bitmap3 || ((z && !Api27Impl.isAlreadyF16AndLinear(bitmap4)) || (z2 && (!z3 || i4 != 0)))) {
                    if (!(bitmap4 == bitmap3 || bitmap4 == null)) {
                        bitmap4.recycle();
                    }
                    bitmap2 = Api27Impl.createBitmapWithSourceColorspace(sizeAtStep(width, i6, i12 > 0 ? i4 : i12, i10), sizeAtStep(height, i7, i13 > 0 ? i4 : i13, i11), bitmap3, z && !z2);
                } else {
                    bitmap2 = bitmap4;
                }
                Bitmap bitmap7 = bitmap6;
                Paint paint3 = paint2;
                new Canvas(bitmap2).drawBitmap(bitmap7, rect3, rect4, paint3);
                rect3.set(rect4);
                bitmap4 = bitmap7;
                paint = paint3;
            }
            if (!(bitmap4 == bitmap3 || bitmap4 == null)) {
                bitmap4.recycle();
            }
            return bitmap2;
        } else {
            throw new IllegalArgumentException("srcRect must be contained by srcBm!");
        }
    }

    private BitmapCompat() {
    }

    @RequiresApi(17)
    static class Api17Impl {
        private Api17Impl() {
        }

        @DoNotInline
        static boolean hasMipMap(Bitmap bitmap) {
            return bitmap.hasMipMap();
        }

        @DoNotInline
        static void setHasMipMap(Bitmap bitmap, boolean z) {
            bitmap.setHasMipMap(z);
        }
    }

    @RequiresApi(19)
    static class Api19Impl {
        private Api19Impl() {
        }

        @DoNotInline
        static int getAllocationByteCount(Bitmap bitmap) {
            return bitmap.getAllocationByteCount();
        }
    }

    @RequiresApi(27)
    static class Api27Impl {
        private Api27Impl() {
        }

        @DoNotInline
        static Bitmap createBitmapWithSourceColorspace(int i, int i2, Bitmap bitmap, boolean z) {
            Bitmap.Config config = bitmap.getConfig();
            ColorSpace colorSpace = bitmap.getColorSpace();
            ColorSpace colorSpace2 = ColorSpace.get(ColorSpace.Named.LINEAR_EXTENDED_SRGB);
            if (z && !bitmap.getColorSpace().equals(colorSpace2)) {
                config = Bitmap.Config.RGBA_F16;
                colorSpace = colorSpace2;
            } else if (bitmap.getConfig() == Bitmap.Config.HARDWARE) {
                Bitmap.Config config2 = Bitmap.Config.ARGB_8888;
                config = Api31Impl.getHardwareBitmapConfig(bitmap);
            }
            return Bitmap.createBitmap(i, i2, config, bitmap.hasAlpha(), colorSpace);
        }

        @DoNotInline
        static boolean isAlreadyF16AndLinear(Bitmap bitmap) {
            return bitmap.getConfig() == Bitmap.Config.RGBA_F16 && bitmap.getColorSpace().equals(ColorSpace.get(ColorSpace.Named.LINEAR_EXTENDED_SRGB));
        }

        @DoNotInline
        static Bitmap copyBitmapIfHardware(Bitmap bitmap) {
            if (bitmap.getConfig() != Bitmap.Config.HARDWARE) {
                return bitmap;
            }
            Bitmap.Config config = Bitmap.Config.ARGB_8888;
            return bitmap.copy(Api31Impl.getHardwareBitmapConfig(bitmap), true);
        }
    }

    @RequiresApi(29)
    static class Api29Impl {
        private Api29Impl() {
        }

        @DoNotInline
        static void setPaintBlendMode(Paint paint) {
            paint.setBlendMode(BlendMode.SRC);
        }
    }

    @RequiresApi(31)
    static class Api31Impl {
        private Api31Impl() {
        }

        @DoNotInline
        static Bitmap.Config getHardwareBitmapConfig(Bitmap bitmap) {
            if (bitmap.getHardwareBuffer().getFormat() == 22) {
                return Bitmap.Config.RGBA_F16;
            }
            return Bitmap.Config.ARGB_8888;
        }
    }
}
