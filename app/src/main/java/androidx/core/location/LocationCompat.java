package androidx.core.location;

import android.location.Location;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.concurrent.TimeUnit;

public final class LocationCompat {
    public static final String EXTRA_BEARING_ACCURACY = "bearingAccuracy";
    public static final String EXTRA_IS_MOCK = "mockLocation";
    public static final String EXTRA_SPEED_ACCURACY = "speedAccuracy";
    public static final String EXTRA_VERTICAL_ACCURACY = "verticalAccuracy";
    @Nullable
    private static Method sSetIsFromMockProviderMethod;

    private LocationCompat() {
    }

    public static long getElapsedRealtimeNanos(@NonNull Location location) {
        return Api17Impl.getElapsedRealtimeNanos(location);
    }

    public static long getElapsedRealtimeMillis(@NonNull Location location) {
        return TimeUnit.NANOSECONDS.toMillis(Api17Impl.getElapsedRealtimeNanos(location));
    }

    public static boolean hasVerticalAccuracy(@NonNull Location location) {
        return Api26Impl.hasVerticalAccuracy(location);
    }

    public static float getVerticalAccuracyMeters(@NonNull Location location) {
        return Api26Impl.getVerticalAccuracyMeters(location);
    }

    public static void setVerticalAccuracyMeters(@NonNull Location location, float f) {
        Api26Impl.setVerticalAccuracyMeters(location, f);
    }

    public static boolean hasSpeedAccuracy(@NonNull Location location) {
        return Api26Impl.hasSpeedAccuracy(location);
    }

    public static float getSpeedAccuracyMetersPerSecond(@NonNull Location location) {
        return Api26Impl.getSpeedAccuracyMetersPerSecond(location);
    }

    public static void setSpeedAccuracyMetersPerSecond(@NonNull Location location, float f) {
        Api26Impl.setSpeedAccuracyMetersPerSecond(location, f);
    }

    public static boolean hasBearingAccuracy(@NonNull Location location) {
        return Api26Impl.hasBearingAccuracy(location);
    }

    public static float getBearingAccuracyDegrees(@NonNull Location location) {
        return Api26Impl.getBearingAccuracyDegrees(location);
    }

    public static void setBearingAccuracyDegrees(@NonNull Location location, float f) {
        Api26Impl.setBearingAccuracyDegrees(location, f);
    }

    public static boolean isMock(@NonNull Location location) {
        return Api18Impl.isMock(location);
    }

    public static void setMock(@NonNull Location location, boolean z) {
        try {
            getSetIsFromMockProviderMethod().invoke(location, new Object[]{Boolean.valueOf(z)});
        } catch (NoSuchMethodException e) {
            NoSuchMethodError noSuchMethodError = new NoSuchMethodError();
            noSuchMethodError.initCause(e);
            throw noSuchMethodError;
        } catch (IllegalAccessException e2) {
            IllegalAccessError illegalAccessError = new IllegalAccessError();
            illegalAccessError.initCause(e2);
            throw illegalAccessError;
        } catch (InvocationTargetException e3) {
            throw new RuntimeException(e3);
        }
    }

    @RequiresApi(26)
    private static class Api26Impl {
        private Api26Impl() {
        }

        @DoNotInline
        static boolean hasVerticalAccuracy(Location location) {
            return location.hasVerticalAccuracy();
        }

        @DoNotInline
        static float getVerticalAccuracyMeters(Location location) {
            return location.getVerticalAccuracyMeters();
        }

        @DoNotInline
        static void setVerticalAccuracyMeters(Location location, float f) {
            location.setVerticalAccuracyMeters(f);
        }

        @DoNotInline
        static boolean hasSpeedAccuracy(Location location) {
            return location.hasSpeedAccuracy();
        }

        @DoNotInline
        static float getSpeedAccuracyMetersPerSecond(Location location) {
            return location.getSpeedAccuracyMetersPerSecond();
        }

        @DoNotInline
        static void setSpeedAccuracyMetersPerSecond(Location location, float f) {
            location.setSpeedAccuracyMetersPerSecond(f);
        }

        @DoNotInline
        static boolean hasBearingAccuracy(Location location) {
            return location.hasBearingAccuracy();
        }

        @DoNotInline
        static float getBearingAccuracyDegrees(Location location) {
            return location.getBearingAccuracyDegrees();
        }

        @DoNotInline
        static void setBearingAccuracyDegrees(Location location, float f) {
            location.setBearingAccuracyDegrees(f);
        }
    }

    @RequiresApi(18)
    private static class Api18Impl {
        private Api18Impl() {
        }

        @DoNotInline
        static boolean isMock(Location location) {
            return location.isFromMockProvider();
        }
    }

    @RequiresApi(17)
    private static class Api17Impl {
        private Api17Impl() {
        }

        @DoNotInline
        static long getElapsedRealtimeNanos(Location location) {
            return location.getElapsedRealtimeNanos();
        }
    }

    private static Method getSetIsFromMockProviderMethod() throws NoSuchMethodException {
        if (sSetIsFromMockProviderMethod == null) {
            Method declaredMethod = Location.class.getDeclaredMethod("setIsFromMockProvider", new Class[]{Boolean.TYPE});
            sSetIsFromMockProviderMethod = declaredMethod;
            declaredMethod.setAccessible(true);
        }
        return sSetIsFromMockProviderMethod;
    }
}
