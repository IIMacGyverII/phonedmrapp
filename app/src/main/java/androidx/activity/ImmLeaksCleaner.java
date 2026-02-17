package androidx.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.view.inputmethod.InputMethodManager;
import androidx.annotation.MainThread;
import androidx.annotation.RequiresApi;
import androidx.lifecycle.LifecycleEventObserver;
import java.lang.reflect.Field;

@RequiresApi(19)
final class ImmLeaksCleaner implements LifecycleEventObserver {
    private static final int INIT_FAILED = 2;
    private static final int INIT_SUCCESS = 1;
    private static final int NOT_INITIALIAZED = 0;
    private static Field sHField;
    private static Field sNextServedViewField;
    private static int sReflectedFieldsInitialized;
    private static Field sServedViewField;
    private Activity mActivity;

    ImmLeaksCleaner(Activity activity) {
        this.mActivity = activity;
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(3:29|30|31) */
    /* JADX WARNING: Code restructure failed: missing block: B:31:0x0045, code lost:
        return;
     */
    /* JADX WARNING: Missing exception handler attribute for start block: B:29:0x0044 */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onStateChanged(@androidx.annotation.NonNull androidx.lifecycle.LifecycleOwner r2, @androidx.annotation.NonNull androidx.lifecycle.Lifecycle.Event r3) {
        /*
            r1 = this;
            androidx.lifecycle.Lifecycle$Event r2 = androidx.lifecycle.Lifecycle.Event.ON_DESTROY
            if (r3 == r2) goto L_0x0005
            return
        L_0x0005:
            int r2 = sReflectedFieldsInitialized
            if (r2 != 0) goto L_0x000c
            initializeReflectiveFields()
        L_0x000c:
            int r2 = sReflectedFieldsInitialized
            r3 = 1
            if (r2 != r3) goto L_0x004e
            android.app.Activity r1 = r1.mActivity
            java.lang.String r2 = "input_method"
            java.lang.Object r1 = r1.getSystemService(r2)
            android.view.inputmethod.InputMethodManager r1 = (android.view.inputmethod.InputMethodManager) r1
            java.lang.reflect.Field r2 = sHField     // Catch:{ IllegalAccessException -> 0x004e }
            java.lang.Object r2 = r2.get(r1)     // Catch:{ IllegalAccessException -> 0x004e }
            if (r2 != 0) goto L_0x0024
            return
        L_0x0024:
            monitor-enter(r2)
            java.lang.reflect.Field r3 = sServedViewField     // Catch:{ IllegalAccessException -> 0x004a, ClassCastException -> 0x0048 }
            java.lang.Object r3 = r3.get(r1)     // Catch:{ IllegalAccessException -> 0x004a, ClassCastException -> 0x0048 }
            android.view.View r3 = (android.view.View) r3     // Catch:{ IllegalAccessException -> 0x004a, ClassCastException -> 0x0048 }
            if (r3 != 0) goto L_0x0031
            monitor-exit(r2)     // Catch:{ all -> 0x0046 }
            return
        L_0x0031:
            boolean r3 = r3.isAttachedToWindow()     // Catch:{ all -> 0x0046 }
            if (r3 == 0) goto L_0x0039
            monitor-exit(r2)     // Catch:{ all -> 0x0046 }
            return
        L_0x0039:
            java.lang.reflect.Field r3 = sNextServedViewField     // Catch:{ IllegalAccessException -> 0x0044 }
            r0 = 0
            r3.set(r1, r0)     // Catch:{ IllegalAccessException -> 0x0044 }
            monitor-exit(r2)     // Catch:{ all -> 0x0046 }
            r1.isActive()
            goto L_0x004e
        L_0x0044:
            monitor-exit(r2)     // Catch:{ all -> 0x0046 }
            return
        L_0x0046:
            r1 = move-exception
            goto L_0x004c
        L_0x0048:
            monitor-exit(r2)     // Catch:{ all -> 0x0046 }
            return
        L_0x004a:
            monitor-exit(r2)     // Catch:{ all -> 0x0046 }
            return
        L_0x004c:
            monitor-exit(r2)     // Catch:{ all -> 0x0046 }
            throw r1
        L_0x004e:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.activity.ImmLeaksCleaner.onStateChanged(androidx.lifecycle.LifecycleOwner, androidx.lifecycle.Lifecycle$Event):void");
    }

    @SuppressLint({"SoonBlockedPrivateApi"})
    @MainThread
    private static void initializeReflectiveFields() {
        try {
            sReflectedFieldsInitialized = 2;
            Field declaredField = InputMethodManager.class.getDeclaredField("mServedView");
            sServedViewField = declaredField;
            declaredField.setAccessible(true);
            Field declaredField2 = InputMethodManager.class.getDeclaredField("mNextServedView");
            sNextServedViewField = declaredField2;
            declaredField2.setAccessible(true);
            Field declaredField3 = InputMethodManager.class.getDeclaredField("mH");
            sHField = declaredField3;
            declaredField3.setAccessible(true);
            sReflectedFieldsInitialized = 1;
        } catch (NoSuchFieldException unused) {
        }
    }
}
