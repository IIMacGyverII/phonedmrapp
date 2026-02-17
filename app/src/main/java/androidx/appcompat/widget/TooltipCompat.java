package androidx.appcompat.widget;

import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class TooltipCompat {
    public static void setTooltipText(@NonNull View view, @Nullable CharSequence charSequence) {
        view.setTooltipText(charSequence);
    }

    private TooltipCompat() {
    }
}
