package androidx.core.widget;

import android.view.View;
import android.widget.PopupMenu;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

public final class PopupMenuCompat {
    private PopupMenuCompat() {
    }

    @Nullable
    public static View.OnTouchListener getDragToOpenListener(@NonNull Object obj) {
        return Api19Impl.getDragToOpenListener((PopupMenu) obj);
    }

    @RequiresApi(19)
    static class Api19Impl {
        private Api19Impl() {
        }

        @DoNotInline
        static View.OnTouchListener getDragToOpenListener(PopupMenu popupMenu) {
            return popupMenu.getDragToOpenListener();
        }
    }
}
