package androidx.core.app;

import android.app.Dialog;
import android.view.View;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public class DialogCompat {
    private DialogCompat() {
    }

    @NonNull
    public static View requireViewById(@NonNull Dialog dialog, int i) {
        return (View) Api28Impl.requireViewById(dialog, i);
    }

    @RequiresApi(28)
    static class Api28Impl {
        private Api28Impl() {
        }

        @DoNotInline
        static <T> T requireViewById(Dialog dialog, int i) {
            return dialog.requireViewById(i);
        }
    }
}
