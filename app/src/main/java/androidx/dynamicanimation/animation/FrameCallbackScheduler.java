package androidx.dynamicanimation.animation;

import androidx.annotation.NonNull;

public interface FrameCallbackScheduler {
    boolean isCurrentThread();

    void postFrameCallback(@NonNull Runnable runnable);
}
