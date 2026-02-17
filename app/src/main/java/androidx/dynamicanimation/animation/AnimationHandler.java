package androidx.dynamicanimation.animation;

import android.animation.ValueAnimator;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.Choreographer;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.VisibleForTesting;
import androidx.collection.SimpleArrayMap;
import java.util.ArrayList;

@VisibleForTesting(otherwise = 3)
public class AnimationHandler {
    private static final long FRAME_DELAY_MS = 10;
    private static final ThreadLocal<AnimationHandler> sAnimatorHandler = new ThreadLocal<>();
    final ArrayList<AnimationFrameCallback> mAnimationCallbacks = new ArrayList<>();
    private final AnimationCallbackDispatcher mCallbackDispatcher = new AnimationCallbackDispatcher();
    long mCurrentFrameTime = 0;
    private final SimpleArrayMap<AnimationFrameCallback, Long> mDelayedCallbackStartTime = new SimpleArrayMap<>();
    @VisibleForTesting(otherwise = 3)
    public float mDurationScale = 1.0f;
    @VisibleForTesting(otherwise = 3)
    @Nullable
    public DurationScaleChangeListener mDurationScaleChangeListener;
    private boolean mListDirty = false;
    /* access modifiers changed from: private */
    public final Runnable mRunnable = new AnimationHandler$$ExternalSyntheticLambda0(this);
    /* access modifiers changed from: private */
    public FrameCallbackScheduler mScheduler;

    interface AnimationFrameCallback {
        boolean doAnimationFrame(long j);
    }

    @VisibleForTesting
    public interface DurationScaleChangeListener {
        boolean register();

        boolean unregister();
    }

    private class AnimationCallbackDispatcher {
        private AnimationCallbackDispatcher() {
        }

        /* access modifiers changed from: package-private */
        public void dispatchAnimationFrame() {
            AnimationHandler.this.mCurrentFrameTime = SystemClock.uptimeMillis();
            AnimationHandler animationHandler = AnimationHandler.this;
            animationHandler.doAnimationFrame(animationHandler.mCurrentFrameTime);
            if (AnimationHandler.this.mAnimationCallbacks.size() > 0) {
                AnimationHandler.this.mScheduler.postFrameCallback(AnimationHandler.this.mRunnable);
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$new$0() {
        this.mCallbackDispatcher.dispatchAnimationFrame();
    }

    static AnimationHandler getInstance() {
        ThreadLocal<AnimationHandler> threadLocal = sAnimatorHandler;
        if (threadLocal.get() == null) {
            threadLocal.set(new AnimationHandler(new FrameCallbackScheduler16()));
        }
        return threadLocal.get();
    }

    public AnimationHandler(@NonNull FrameCallbackScheduler frameCallbackScheduler) {
        this.mScheduler = frameCallbackScheduler;
    }

    /* access modifiers changed from: package-private */
    public void addAnimationFrameCallback(AnimationFrameCallback animationFrameCallback, long j) {
        if (this.mAnimationCallbacks.size() == 0) {
            this.mScheduler.postFrameCallback(this.mRunnable);
            this.mDurationScale = ValueAnimator.getDurationScale();
            if (this.mDurationScaleChangeListener == null) {
                this.mDurationScaleChangeListener = new DurationScaleChangeListener33();
            }
            this.mDurationScaleChangeListener.register();
        }
        if (!this.mAnimationCallbacks.contains(animationFrameCallback)) {
            this.mAnimationCallbacks.add(animationFrameCallback);
        }
        if (j > 0) {
            this.mDelayedCallbackStartTime.put(animationFrameCallback, Long.valueOf(SystemClock.uptimeMillis() + j));
        }
    }

    /* access modifiers changed from: package-private */
    public void removeCallback(AnimationFrameCallback animationFrameCallback) {
        this.mDelayedCallbackStartTime.remove(animationFrameCallback);
        int indexOf = this.mAnimationCallbacks.indexOf(animationFrameCallback);
        if (indexOf >= 0) {
            this.mAnimationCallbacks.set(indexOf, (Object) null);
            this.mListDirty = true;
        }
    }

    /* access modifiers changed from: package-private */
    public void doAnimationFrame(long j) {
        long uptimeMillis = SystemClock.uptimeMillis();
        for (int i = 0; i < this.mAnimationCallbacks.size(); i++) {
            AnimationFrameCallback animationFrameCallback = this.mAnimationCallbacks.get(i);
            if (animationFrameCallback != null && isCallbackDue(animationFrameCallback, uptimeMillis)) {
                animationFrameCallback.doAnimationFrame(j);
            }
        }
        cleanUpList();
    }

    /* access modifiers changed from: package-private */
    public boolean isCurrentThread() {
        return this.mScheduler.isCurrentThread();
    }

    private boolean isCallbackDue(AnimationFrameCallback animationFrameCallback, long j) {
        Long l = this.mDelayedCallbackStartTime.get(animationFrameCallback);
        if (l == null) {
            return true;
        }
        if (l.longValue() >= j) {
            return false;
        }
        this.mDelayedCallbackStartTime.remove(animationFrameCallback);
        return true;
    }

    private void cleanUpList() {
        if (this.mListDirty) {
            for (int size = this.mAnimationCallbacks.size() - 1; size >= 0; size--) {
                if (this.mAnimationCallbacks.get(size) == null) {
                    this.mAnimationCallbacks.remove(size);
                }
            }
            if (this.mAnimationCallbacks.size() == 0) {
                this.mDurationScaleChangeListener.unregister();
            }
            this.mListDirty = false;
        }
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public FrameCallbackScheduler getScheduler() {
        return this.mScheduler;
    }

    @RequiresApi(16)
    @VisibleForTesting
    static final class FrameCallbackScheduler16 implements FrameCallbackScheduler {
        private final Choreographer mChoreographer = Choreographer.getInstance();
        private final Looper mLooper = Looper.myLooper();

        FrameCallbackScheduler16() {
        }

        public void postFrameCallback(@NonNull Runnable runnable) {
            this.mChoreographer.postFrameCallback(new AnimationHandler$FrameCallbackScheduler16$$ExternalSyntheticLambda0(runnable));
        }

        public boolean isCurrentThread() {
            return Thread.currentThread() == this.mLooper.getThread();
        }
    }

    @VisibleForTesting
    static class FrameCallbackScheduler14 implements FrameCallbackScheduler {
        private final Handler mHandler = new Handler(Looper.myLooper());
        private long mLastFrameTime;

        FrameCallbackScheduler14() {
        }

        public void postFrameCallback(@NonNull Runnable runnable) {
            this.mHandler.postDelayed(new AnimationHandler$FrameCallbackScheduler14$$ExternalSyntheticLambda0(this, runnable), Math.max(AnimationHandler.FRAME_DELAY_MS - (SystemClock.uptimeMillis() - this.mLastFrameTime), 0));
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$postFrameCallback$0(Runnable runnable) {
            this.mLastFrameTime = SystemClock.uptimeMillis();
            runnable.run();
        }

        public boolean isCurrentThread() {
            return Thread.currentThread() == this.mHandler.getLooper().getThread();
        }
    }

    @VisibleForTesting(otherwise = 3)
    public float getDurationScale() {
        return this.mDurationScale;
    }

    @RequiresApi(api = 33)
    @VisibleForTesting(otherwise = 3)
    public class DurationScaleChangeListener33 implements DurationScaleChangeListener {
        ValueAnimator.DurationScaleChangeListener mListener;

        public DurationScaleChangeListener33() {
        }

        public boolean register() {
            if (this.mListener != null) {
                return true;
            }
            AnimationHandler$DurationScaleChangeListener33$$ExternalSyntheticLambda0 animationHandler$DurationScaleChangeListener33$$ExternalSyntheticLambda0 = new AnimationHandler$DurationScaleChangeListener33$$ExternalSyntheticLambda0(this);
            this.mListener = animationHandler$DurationScaleChangeListener33$$ExternalSyntheticLambda0;
            return ValueAnimator.registerDurationScaleChangeListener(animationHandler$DurationScaleChangeListener33$$ExternalSyntheticLambda0);
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$register$0(float f) {
            AnimationHandler.this.mDurationScale = f;
        }

        public boolean unregister() {
            boolean unregisterDurationScaleChangeListener = ValueAnimator.unregisterDurationScaleChangeListener(this.mListener);
            this.mListener = null;
            return unregisterDurationScaleChangeListener;
        }
    }
}
