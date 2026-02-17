package androidx.core.content;

import androidx.annotation.NonNull;
import androidx.core.util.Consumer;

public interface OnTrimMemoryProvider {
    void addOnTrimMemoryListener(@NonNull Consumer<Integer> consumer);

    void removeOnTrimMemoryListener(@NonNull Consumer<Integer> consumer);
}
