package androidx.transition;

import android.annotation.SuppressLint;
import android.graphics.Matrix;
import android.widget.ImageView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import java.lang.reflect.Field;

class ImageViewUtils {
    private static Field sDrawMatrixField = null;
    private static boolean sDrawMatrixFieldFetched = false;
    private static boolean sTryHiddenAnimateTransform = true;

    static void animateTransform(@NonNull ImageView imageView, @Nullable Matrix matrix) {
        imageView.animateTransform(matrix);
    }

    @RequiresApi(21)
    @SuppressLint({"NewApi"})
    private static void hiddenAnimateTransform(@NonNull ImageView imageView, @Nullable Matrix matrix) {
        if (sTryHiddenAnimateTransform) {
            try {
                imageView.animateTransform(matrix);
            } catch (NoSuchMethodError unused) {
                sTryHiddenAnimateTransform = false;
            }
        }
    }

    @SuppressLint({"SoonBlockedPrivateApi"})
    private static void fetchDrawMatrixField() {
        if (!sDrawMatrixFieldFetched) {
            try {
                Field declaredField = ImageView.class.getDeclaredField("mDrawMatrix");
                sDrawMatrixField = declaredField;
                declaredField.setAccessible(true);
            } catch (NoSuchFieldException unused) {
            }
            sDrawMatrixFieldFetched = true;
        }
    }

    private ImageViewUtils() {
    }
}
