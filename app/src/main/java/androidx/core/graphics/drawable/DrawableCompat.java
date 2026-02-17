package androidx.core.graphics.drawable;

import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.ColorFilter;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.DrawableContainer;
import android.graphics.drawable.InsetDrawable;
import android.util.AttributeSet;
import androidx.annotation.ColorInt;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import java.io.IOException;
import java.lang.reflect.Method;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

public final class DrawableCompat {
    private static final String TAG = "DrawableCompat";
    private static Method sGetLayoutDirectionMethod;
    private static boolean sGetLayoutDirectionMethodFetched;
    private static Method sSetLayoutDirectionMethod;
    private static boolean sSetLayoutDirectionMethodFetched;

    @NonNull
    public static Drawable wrap(@NonNull Drawable drawable) {
        return drawable;
    }

    @Deprecated
    public static void jumpToCurrentState(@NonNull Drawable drawable) {
        drawable.jumpToCurrentState();
    }

    public static void setAutoMirrored(@NonNull Drawable drawable, boolean z) {
        Api19Impl.setAutoMirrored(drawable, z);
    }

    public static boolean isAutoMirrored(@NonNull Drawable drawable) {
        return Api19Impl.isAutoMirrored(drawable);
    }

    public static void setHotspot(@NonNull Drawable drawable, float f, float f2) {
        Api21Impl.setHotspot(drawable, f, f2);
    }

    public static void setHotspotBounds(@NonNull Drawable drawable, int i, int i2, int i3, int i4) {
        Api21Impl.setHotspotBounds(drawable, i, i2, i3, i4);
    }

    public static void setTint(@NonNull Drawable drawable, @ColorInt int i) {
        Api21Impl.setTint(drawable, i);
    }

    public static void setTintList(@NonNull Drawable drawable, @Nullable ColorStateList colorStateList) {
        Api21Impl.setTintList(drawable, colorStateList);
    }

    public static void setTintMode(@NonNull Drawable drawable, @NonNull PorterDuff.Mode mode) {
        Api21Impl.setTintMode(drawable, mode);
    }

    public static int getAlpha(@NonNull Drawable drawable) {
        return Api19Impl.getAlpha(drawable);
    }

    public static void applyTheme(@NonNull Drawable drawable, @NonNull Resources.Theme theme) {
        Api21Impl.applyTheme(drawable, theme);
    }

    public static boolean canApplyTheme(@NonNull Drawable drawable) {
        return Api21Impl.canApplyTheme(drawable);
    }

    @Nullable
    public static ColorFilter getColorFilter(@NonNull Drawable drawable) {
        return Api21Impl.getColorFilter(drawable);
    }

    public static void clearColorFilter(@NonNull Drawable drawable) {
        drawable.clearColorFilter();
    }

    public static void inflate(@NonNull Drawable drawable, @NonNull Resources resources, @NonNull XmlPullParser xmlPullParser, @NonNull AttributeSet attributeSet, @Nullable Resources.Theme theme) throws XmlPullParserException, IOException {
        Api21Impl.inflate(drawable, resources, xmlPullParser, attributeSet, theme);
    }

    public static <T extends Drawable> T unwrap(@NonNull Drawable drawable) {
        return drawable instanceof WrappedDrawable ? ((WrappedDrawable) drawable).getWrappedDrawable() : drawable;
    }

    public static boolean setLayoutDirection(@NonNull Drawable drawable, int i) {
        return Api23Impl.setLayoutDirection(drawable, i);
    }

    public static int getLayoutDirection(@NonNull Drawable drawable) {
        return Api23Impl.getLayoutDirection(drawable);
    }

    private DrawableCompat() {
    }

    @RequiresApi(19)
    static class Api19Impl {
        private Api19Impl() {
        }

        @DoNotInline
        static void setAutoMirrored(Drawable drawable, boolean z) {
            drawable.setAutoMirrored(z);
        }

        @DoNotInline
        static boolean isAutoMirrored(Drawable drawable) {
            return drawable.isAutoMirrored();
        }

        @DoNotInline
        static int getAlpha(Drawable drawable) {
            return drawable.getAlpha();
        }

        @DoNotInline
        static Drawable getChild(DrawableContainer.DrawableContainerState drawableContainerState, int i) {
            return drawableContainerState.getChild(i);
        }

        @DoNotInline
        static Drawable getDrawable(InsetDrawable insetDrawable) {
            return insetDrawable.getDrawable();
        }
    }

    @RequiresApi(21)
    static class Api21Impl {
        private Api21Impl() {
        }

        @DoNotInline
        static void setHotspot(Drawable drawable, float f, float f2) {
            drawable.setHotspot(f, f2);
        }

        @DoNotInline
        static void setTint(Drawable drawable, int i) {
            drawable.setTint(i);
        }

        @DoNotInline
        static void setTintList(Drawable drawable, ColorStateList colorStateList) {
            drawable.setTintList(colorStateList);
        }

        @DoNotInline
        static void setTintMode(Drawable drawable, PorterDuff.Mode mode) {
            drawable.setTintMode(mode);
        }

        @DoNotInline
        static void applyTheme(Drawable drawable, Resources.Theme theme) {
            drawable.applyTheme(theme);
        }

        @DoNotInline
        static boolean canApplyTheme(Drawable drawable) {
            return drawable.canApplyTheme();
        }

        @DoNotInline
        static ColorFilter getColorFilter(Drawable drawable) {
            return drawable.getColorFilter();
        }

        @DoNotInline
        static void inflate(Drawable drawable, Resources resources, XmlPullParser xmlPullParser, AttributeSet attributeSet, Resources.Theme theme) throws XmlPullParserException, IOException {
            drawable.inflate(resources, xmlPullParser, attributeSet, theme);
        }

        @DoNotInline
        static void setHotspotBounds(Drawable drawable, int i, int i2, int i3, int i4) {
            drawable.setHotspotBounds(i, i2, i3, i4);
        }
    }

    @RequiresApi(23)
    static class Api23Impl {
        private Api23Impl() {
        }

        @DoNotInline
        static boolean setLayoutDirection(Drawable drawable, int i) {
            return drawable.setLayoutDirection(i);
        }

        @DoNotInline
        static int getLayoutDirection(Drawable drawable) {
            return drawable.getLayoutDirection();
        }
    }
}
