package androidx.core.view.inputmethod;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.view.inputmethod.EditorInfo;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.VisibleForTesting;
import androidx.core.util.Preconditions;

@SuppressLint({"PrivateConstructorForUtilityClass"})
public final class EditorInfoCompat {
    private static final String CONTENT_MIME_TYPES_INTEROP_KEY = "android.support.v13.view.inputmethod.EditorInfoCompat.CONTENT_MIME_TYPES";
    private static final String CONTENT_MIME_TYPES_KEY = "androidx.core.view.inputmethod.EditorInfoCompat.CONTENT_MIME_TYPES";
    private static final String CONTENT_SELECTION_END_KEY = "androidx.core.view.inputmethod.EditorInfoCompat.CONTENT_SELECTION_END";
    private static final String CONTENT_SELECTION_HEAD_KEY = "androidx.core.view.inputmethod.EditorInfoCompat.CONTENT_SELECTION_HEAD";
    private static final String CONTENT_SURROUNDING_TEXT_KEY = "androidx.core.view.inputmethod.EditorInfoCompat.CONTENT_SURROUNDING_TEXT";
    private static final String[] EMPTY_STRING_ARRAY = new String[0];
    public static final int IME_FLAG_FORCE_ASCII = Integer.MIN_VALUE;
    public static final int IME_FLAG_NO_PERSONALIZED_LEARNING = 16777216;
    @VisibleForTesting
    static final int MAX_INITIAL_SELECTION_LENGTH = 1024;
    @VisibleForTesting
    static final int MEMORY_EFFICIENT_TEXT_LENGTH = 2048;

    static int getProtocol(EditorInfo editorInfo) {
        return 1;
    }

    private static boolean isPasswordInputType(int i) {
        int i2 = i & 4095;
        return i2 == 129 || i2 == 225 || i2 == 18;
    }

    public static void setContentMimeTypes(@NonNull EditorInfo editorInfo, @Nullable String[] strArr) {
        editorInfo.contentMimeTypes = strArr;
    }

    @NonNull
    public static String[] getContentMimeTypes(@NonNull EditorInfo editorInfo) {
        String[] strArr = editorInfo.contentMimeTypes;
        return strArr != null ? strArr : EMPTY_STRING_ARRAY;
    }

    public static void setInitialSurroundingText(@NonNull EditorInfo editorInfo, @NonNull CharSequence charSequence) {
        Api30Impl.setInitialSurroundingSubText(editorInfo, charSequence, 0);
    }

    public static void setInitialSurroundingSubText(@NonNull EditorInfo editorInfo, @NonNull CharSequence charSequence, int i) {
        Preconditions.checkNotNull(charSequence);
        Api30Impl.setInitialSurroundingSubText(editorInfo, charSequence, i);
    }

    private static void trimLongSurroundingText(EditorInfo editorInfo, CharSequence charSequence, int i, int i2) {
        CharSequence charSequence2;
        int i3 = i2 - i;
        int i4 = i3 > 1024 ? 0 : i3;
        int i5 = 2048 - i4;
        int min = Math.min(charSequence.length() - i2, i5 - Math.min(i, (int) (((double) i5) * 0.8d)));
        int min2 = Math.min(i, i5 - min);
        int i6 = i - min2;
        if (isCutOnSurrogate(charSequence, i6, 0)) {
            i6++;
            min2--;
        }
        if (isCutOnSurrogate(charSequence, (i2 + min) - 1, 1)) {
            min--;
        }
        int i7 = min2 + i4 + min;
        if (i4 != i3) {
            charSequence2 = TextUtils.concat(new CharSequence[]{charSequence.subSequence(i6, i6 + min2), charSequence.subSequence(i2, min + i2)});
        } else {
            charSequence2 = charSequence.subSequence(i6, i7 + i6);
        }
        int i8 = min2 + 0;
        setSurroundingText(editorInfo, charSequence2, i8, i4 + i8);
    }

    @Nullable
    public static CharSequence getInitialTextBeforeCursor(@NonNull EditorInfo editorInfo, int i, int i2) {
        return Api30Impl.getInitialTextBeforeCursor(editorInfo, i, i2);
    }

    @Nullable
    public static CharSequence getInitialSelectedText(@NonNull EditorInfo editorInfo, int i) {
        return Api30Impl.getInitialSelectedText(editorInfo, i);
    }

    @Nullable
    public static CharSequence getInitialTextAfterCursor(@NonNull EditorInfo editorInfo, int i, int i2) {
        return Api30Impl.getInitialTextAfterCursor(editorInfo, i, i2);
    }

    private static boolean isCutOnSurrogate(CharSequence charSequence, int i, int i2) {
        if (i2 == 0) {
            return Character.isLowSurrogate(charSequence.charAt(i));
        }
        if (i2 != 1) {
            return false;
        }
        return Character.isHighSurrogate(charSequence.charAt(i));
    }

    private static void setSurroundingText(EditorInfo editorInfo, CharSequence charSequence, int i, int i2) {
        if (editorInfo.extras == null) {
            editorInfo.extras = new Bundle();
        }
        editorInfo.extras.putCharSequence(CONTENT_SURROUNDING_TEXT_KEY, charSequence != null ? new SpannableStringBuilder(charSequence) : null);
        editorInfo.extras.putInt(CONTENT_SELECTION_HEAD_KEY, i);
        editorInfo.extras.putInt(CONTENT_SELECTION_END_KEY, i2);
    }

    @RequiresApi(30)
    private static class Api30Impl {
        private Api30Impl() {
        }

        static void setInitialSurroundingSubText(@NonNull EditorInfo editorInfo, CharSequence charSequence, int i) {
            editorInfo.setInitialSurroundingSubText(charSequence, i);
        }

        static CharSequence getInitialTextBeforeCursor(@NonNull EditorInfo editorInfo, int i, int i2) {
            return editorInfo.getInitialTextBeforeCursor(i, i2);
        }

        static CharSequence getInitialSelectedText(@NonNull EditorInfo editorInfo, int i) {
            return editorInfo.getInitialSelectedText(i);
        }

        static CharSequence getInitialTextAfterCursor(@NonNull EditorInfo editorInfo, int i, int i2) {
            return editorInfo.getInitialTextAfterCursor(i, i2);
        }
    }
}
