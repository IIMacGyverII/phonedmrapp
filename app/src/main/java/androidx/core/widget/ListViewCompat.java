package androidx.core.widget;

import android.widget.ListView;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public final class ListViewCompat {
    public static void scrollListBy(@NonNull ListView listView, int i) {
        Api19Impl.scrollListBy(listView, i);
    }

    public static boolean canScrollList(@NonNull ListView listView, int i) {
        return Api19Impl.canScrollList(listView, i);
    }

    private ListViewCompat() {
    }

    @RequiresApi(19)
    static class Api19Impl {
        private Api19Impl() {
        }

        @DoNotInline
        static void scrollListBy(ListView listView, int i) {
            listView.scrollListBy(i);
        }

        @DoNotInline
        static boolean canScrollList(ListView listView, int i) {
            return listView.canScrollList(i);
        }
    }
}
