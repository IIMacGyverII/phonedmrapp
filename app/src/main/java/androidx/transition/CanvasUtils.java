package androidx.transition;

import android.annotation.SuppressLint;
import android.graphics.Canvas;
import androidx.annotation.NonNull;
import java.lang.reflect.Method;

class CanvasUtils {
    private static Method sInorderBarrierMethod;
    private static boolean sOrderMethodsFetched;
    private static Method sReorderBarrierMethod;

    @SuppressLint({"SoonBlockedPrivateApi"})
    static void enableZ(@NonNull Canvas canvas, boolean z) {
        if (z) {
            canvas.enableZ();
        } else {
            canvas.disableZ();
        }
    }

    private CanvasUtils() {
    }
}
