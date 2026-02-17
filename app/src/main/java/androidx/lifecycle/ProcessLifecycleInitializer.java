package androidx.lifecycle;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.startup.Initializer;
import java.util.Collections;
import java.util.List;

public final class ProcessLifecycleInitializer implements Initializer<LifecycleOwner> {
    @NonNull
    public LifecycleOwner create(@NonNull Context context) {
        LifecycleDispatcher.init(context);
        ProcessLifecycleOwner.init(context);
        return ProcessLifecycleOwner.get();
    }

    @NonNull
    public List<Class<? extends Initializer<?>>> dependencies() {
        return Collections.emptyList();
    }
}
