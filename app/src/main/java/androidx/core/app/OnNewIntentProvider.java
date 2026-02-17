package androidx.core.app;

import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.core.util.Consumer;

public interface OnNewIntentProvider {
    void addOnNewIntentListener(@NonNull Consumer<Intent> consumer);

    void removeOnNewIntentListener(@NonNull Consumer<Intent> consumer);
}
