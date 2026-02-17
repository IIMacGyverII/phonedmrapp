package androidx.core.os;

import android.os.Environment;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import java.io.File;

public final class EnvironmentCompat {
    public static final String MEDIA_UNKNOWN = "unknown";
    private static final String TAG = "EnvironmentCompat";

    @NonNull
    public static String getStorageState(@NonNull File file) {
        return Api21Impl.getExternalStorageState(file);
    }

    private EnvironmentCompat() {
    }

    @RequiresApi(21)
    static class Api21Impl {
        private Api21Impl() {
        }

        @DoNotInline
        static String getExternalStorageState(File file) {
            return Environment.getExternalStorageState(file);
        }
    }

    @RequiresApi(19)
    static class Api19Impl {
        private Api19Impl() {
        }

        @DoNotInline
        static String getStorageState(File file) {
            return Environment.getStorageState(file);
        }
    }
}
