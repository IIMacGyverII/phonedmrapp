package androidx.core.os;

import android.annotation.SuppressLint;
import android.os.Process;
import android.os.UserHandle;
import androidx.annotation.RequiresApi;
import java.lang.reflect.Method;

public final class ProcessCompat {
    private ProcessCompat() {
    }

    public static boolean isApplicationUid(int i) {
        return Api24Impl.isApplicationUid(i);
    }

    @RequiresApi(24)
    static class Api24Impl {
        private Api24Impl() {
        }

        static boolean isApplicationUid(int i) {
            return Process.isApplicationUid(i);
        }
    }

    @RequiresApi(17)
    static class Api17Impl {
        private static Method sMethodUserHandleIsAppMethod;
        private static boolean sResolved;
        private static final Object sResolvedLock = new Object();

        private Api17Impl() {
        }

        @SuppressLint({"DiscouragedPrivateApi"})
        static boolean isApplicationUid(int i) {
            try {
                synchronized (sResolvedLock) {
                    if (!sResolved) {
                        sResolved = true;
                        sMethodUserHandleIsAppMethod = UserHandle.class.getDeclaredMethod("isApp", new Class[]{Integer.TYPE});
                    }
                }
                Method method = sMethodUserHandleIsAppMethod;
                if (method != null) {
                    Boolean bool = (Boolean) method.invoke((Object) null, new Object[]{Integer.valueOf(i)});
                    if (bool != null) {
                        return bool.booleanValue();
                    }
                    throw new NullPointerException();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return true;
        }
    }

    @RequiresApi(16)
    static class Api16Impl {
        private static Method sMethodUserIdIsAppMethod;
        private static boolean sResolved;
        private static final Object sResolvedLock = new Object();

        private Api16Impl() {
        }

        @SuppressLint({"PrivateApi"})
        static boolean isApplicationUid(int i) {
            try {
                synchronized (sResolvedLock) {
                    if (!sResolved) {
                        sResolved = true;
                        sMethodUserIdIsAppMethod = Class.forName("android.os.UserId").getDeclaredMethod("isApp", new Class[]{Integer.TYPE});
                    }
                }
                Method method = sMethodUserIdIsAppMethod;
                if (method != null) {
                    Boolean bool = (Boolean) method.invoke((Object) null, new Object[]{Integer.valueOf(i)});
                    if (bool != null) {
                        return bool.booleanValue();
                    }
                    throw new NullPointerException();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return true;
        }
    }
}
