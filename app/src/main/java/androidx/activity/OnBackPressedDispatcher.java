package androidx.activity;

import android.annotation.SuppressLint;
import androidx.annotation.MainThread;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleEventObserver;
import androidx.lifecycle.LifecycleOwner;
import java.util.ArrayDeque;
import java.util.Iterator;

public final class OnBackPressedDispatcher {
    @Nullable
    private final Runnable mFallbackOnBackPressed;
    final ArrayDeque<OnBackPressedCallback> mOnBackPressedCallbacks;

    public OnBackPressedDispatcher() {
        this((Runnable) null);
    }

    public OnBackPressedDispatcher(@Nullable Runnable runnable) {
        this.mOnBackPressedCallbacks = new ArrayDeque<>();
        this.mFallbackOnBackPressed = runnable;
    }

    @MainThread
    public void addCallback(@NonNull OnBackPressedCallback onBackPressedCallback) {
        addCancellableCallback(onBackPressedCallback);
    }

    /* access modifiers changed from: package-private */
    @MainThread
    @NonNull
    public Cancellable addCancellableCallback(@NonNull OnBackPressedCallback onBackPressedCallback) {
        this.mOnBackPressedCallbacks.add(onBackPressedCallback);
        OnBackPressedCancellable onBackPressedCancellable = new OnBackPressedCancellable(onBackPressedCallback);
        onBackPressedCallback.addCancellable(onBackPressedCancellable);
        return onBackPressedCancellable;
    }

    @SuppressLint({"LambdaLast"})
    @MainThread
    public void addCallback(@NonNull LifecycleOwner lifecycleOwner, @NonNull OnBackPressedCallback onBackPressedCallback) {
        Lifecycle lifecycle = lifecycleOwner.getLifecycle();
        if (lifecycle.getCurrentState() != Lifecycle.State.DESTROYED) {
            onBackPressedCallback.addCancellable(new LifecycleOnBackPressedCancellable(lifecycle, onBackPressedCallback));
        }
    }

    @MainThread
    public boolean hasEnabledCallbacks() {
        Iterator<OnBackPressedCallback> descendingIterator = this.mOnBackPressedCallbacks.descendingIterator();
        while (descendingIterator.hasNext()) {
            if (descendingIterator.next().isEnabled()) {
                return true;
            }
        }
        return false;
    }

    @MainThread
    public void onBackPressed() {
        Iterator<OnBackPressedCallback> descendingIterator = this.mOnBackPressedCallbacks.descendingIterator();
        while (descendingIterator.hasNext()) {
            OnBackPressedCallback next = descendingIterator.next();
            if (next.isEnabled()) {
                next.handleOnBackPressed();
                return;
            }
        }
        Runnable runnable = this.mFallbackOnBackPressed;
        if (runnable != null) {
            runnable.run();
        }
    }

    private class OnBackPressedCancellable implements Cancellable {
        private final OnBackPressedCallback mOnBackPressedCallback;

        OnBackPressedCancellable(OnBackPressedCallback onBackPressedCallback) {
            this.mOnBackPressedCallback = onBackPressedCallback;
        }

        public void cancel() {
            OnBackPressedDispatcher.this.mOnBackPressedCallbacks.remove(this.mOnBackPressedCallback);
            this.mOnBackPressedCallback.removeCancellable(this);
        }
    }

    private class LifecycleOnBackPressedCancellable implements LifecycleEventObserver, Cancellable {
        @Nullable
        private Cancellable mCurrentCancellable;
        private final Lifecycle mLifecycle;
        private final OnBackPressedCallback mOnBackPressedCallback;

        LifecycleOnBackPressedCancellable(@NonNull Lifecycle lifecycle, @NonNull OnBackPressedCallback onBackPressedCallback) {
            this.mLifecycle = lifecycle;
            this.mOnBackPressedCallback = onBackPressedCallback;
            lifecycle.addObserver(this);
        }

        public void onStateChanged(@NonNull LifecycleOwner lifecycleOwner, @NonNull Lifecycle.Event event) {
            if (event == Lifecycle.Event.ON_START) {
                this.mCurrentCancellable = OnBackPressedDispatcher.this.addCancellableCallback(this.mOnBackPressedCallback);
            } else if (event == Lifecycle.Event.ON_STOP) {
                Cancellable cancellable = this.mCurrentCancellable;
                if (cancellable != null) {
                    cancellable.cancel();
                }
            } else if (event == Lifecycle.Event.ON_DESTROY) {
                cancel();
            }
        }

        public void cancel() {
            this.mLifecycle.removeObserver(this);
            this.mOnBackPressedCallback.removeCancellable(this);
            Cancellable cancellable = this.mCurrentCancellable;
            if (cancellable != null) {
                cancellable.cancel();
                this.mCurrentCancellable = null;
            }
        }
    }
}
