package androidx.core.os;

import android.annotation.SuppressLint;
import android.os.Build;
import androidx.annotation.ChecksSdkIntAtLeast;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresOptIn;
import androidx.annotation.RestrictTo;
import java.util.Locale;

public class BuildCompat {

    @RequiresOptIn
    public @interface PrereleaseSdkCheck {
    }

    @Deprecated
    @ChecksSdkIntAtLeast(api = 24)
    public static boolean isAtLeastN() {
        return true;
    }

    @Deprecated
    @ChecksSdkIntAtLeast(api = 25)
    public static boolean isAtLeastNMR1() {
        return true;
    }

    @Deprecated
    @ChecksSdkIntAtLeast(api = 26)
    public static boolean isAtLeastO() {
        return true;
    }

    @Deprecated
    @ChecksSdkIntAtLeast(api = 27)
    public static boolean isAtLeastOMR1() {
        return true;
    }

    @Deprecated
    @ChecksSdkIntAtLeast(api = 28)
    public static boolean isAtLeastP() {
        return true;
    }

    @Deprecated
    @ChecksSdkIntAtLeast(api = 29)
    public static boolean isAtLeastQ() {
        return true;
    }

    @Deprecated
    @ChecksSdkIntAtLeast(api = 30)
    public static boolean isAtLeastR() {
        return true;
    }

    @SuppressLint({"RestrictedApi"})
    @Deprecated
    @ChecksSdkIntAtLeast(api = 31, codename = "S")
    public static boolean isAtLeastS() {
        return true;
    }

    @Deprecated
    @ChecksSdkIntAtLeast(api = 32, codename = "Sv2")
    @PrereleaseSdkCheck
    public static boolean isAtLeastSv2() {
        return true;
    }

    @ChecksSdkIntAtLeast(api = 33, codename = "Tiramisu")
    @PrereleaseSdkCheck
    public static boolean isAtLeastT() {
        return true;
    }

    private BuildCompat() {
    }

    @RestrictTo({RestrictTo.Scope.TESTS})
    protected static boolean isAtLeastPreReleaseCodename(@NonNull String str, @NonNull String str2) {
        if ("REL".equals(str2)) {
            return false;
        }
        Locale locale = Locale.ROOT;
        if (str2.toUpperCase(locale).compareTo(str.toUpperCase(locale)) >= 0) {
            return true;
        }
        return false;
    }

    @ChecksSdkIntAtLeast(codename = "UpsideDownCake")
    @PrereleaseSdkCheck
    public static boolean isAtLeastU() {
        return isAtLeastPreReleaseCodename("UpsideDownCake", Build.VERSION.CODENAME);
    }
}
