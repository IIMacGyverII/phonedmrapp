package androidx.dynamicanimation.animation;

import androidx.dynamicanimation.animation.AnimationHandler;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AnimationHandler$FrameCallbackScheduler14$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ AnimationHandler.FrameCallbackScheduler14 f$0;
    public final /* synthetic */ Runnable f$1;

    public /* synthetic */ AnimationHandler$FrameCallbackScheduler14$$ExternalSyntheticLambda0(AnimationHandler.FrameCallbackScheduler14 frameCallbackScheduler14, Runnable runnable) {
        this.f$0 = frameCallbackScheduler14;
        this.f$1 = runnable;
    }

    public final void run() {
        this.f$0.lambda$postFrameCallback$0(this.f$1);
    }
}
