package androidx.core.text;

import android.text.TextUtils;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import java.util.Locale;

public final class TextUtilsCompat {
    private static final String ARAB_SCRIPT_SUBTAG = "Arab";
    private static final String HEBR_SCRIPT_SUBTAG = "Hebr";
    private static final Locale ROOT = new Locale("", "");

    @NonNull
    public static String htmlEncode(@NonNull String str) {
        return TextUtils.htmlEncode(str);
    }

    public static int getLayoutDirectionFromLocale(@Nullable Locale locale) {
        return Api17Impl.getLayoutDirectionFromLocale(locale);
    }

    private static int getLayoutDirectionFromFirstChar(@NonNull Locale locale) {
        byte directionality = Character.getDirectionality(locale.getDisplayName(locale).charAt(0));
        return (directionality == 1 || directionality == 2) ? 1 : 0;
    }

    private TextUtilsCompat() {
    }

    @RequiresApi(17)
    static class Api17Impl {
        private Api17Impl() {
        }

        @DoNotInline
        static int getLayoutDirectionFromLocale(Locale locale) {
            return TextUtils.getLayoutDirectionFromLocale(locale);
        }
    }
}
