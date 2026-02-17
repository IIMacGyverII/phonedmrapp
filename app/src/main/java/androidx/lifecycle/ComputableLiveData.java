package androidx.lifecycle;

import androidx.annotation.MainThread;
import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;
import androidx.annotation.VisibleForTesting;
import androidx.annotation.WorkerThread;
import androidx.arch.core.executor.ArchTaskExecutor;
import java.util.concurrent.Executor;
import java.util.concurrent.atomic.AtomicBoolean;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
public abstract class ComputableLiveData<T> {
    final AtomicBoolean mComputing;
    final Executor mExecutor;
    final AtomicBoolean mInvalid;
    @VisibleForTesting
    final Runnable mInvalidationRunnable;
    final LiveData<T> mLiveData;
    @VisibleForTesting
    final Runnable mRefreshRunnable;

    /* access modifiers changed from: protected */
    @WorkerThread
    public abstract T compute();

    public ComputableLiveData() {
        this(ArchTaskExecutor.getIOThreadExecutor());
    }

    public ComputableLiveData(@NonNull Executor executor) {
        this.mInvalid = new AtomicBoolean(true);
        this.mComputing = new AtomicBoolean(false);
        this.mRefreshRunnable = new Runnable() {
            /* JADX INFO: finally extract failed */
            /* JADX WARNING: Removed duplicated region for block: B:0:0x0000 A[LOOP_START, MTH_ENTER_BLOCK] */
            @androidx.annotation.WorkerThread
            /* Code decompiled incorrectly, please refer to instructions dump. */
            public void run() {
                /*
                    r5 = this;
                L_0x0000:
                    androidx.lifecycle.ComputableLiveData r0 = androidx.lifecycle.ComputableLiveData.this
                    java.util.concurrent.atomic.AtomicBoolean r0 = r0.mComputing
                    r1 = 0
                    r2 = 1
                    boolean r0 = r0.compareAndSet(r1, r2)
                    if (r0 == 0) goto L_0x003b
                    r0 = 0
                    r3 = r1
                L_0x000e:
                    androidx.lifecycle.ComputableLiveData r4 = androidx.lifecycle.ComputableLiveData.this     // Catch:{ all -> 0x0032 }
                    java.util.concurrent.atomic.AtomicBoolean r4 = r4.mInvalid     // Catch:{ all -> 0x0032 }
                    boolean r4 = r4.compareAndSet(r2, r1)     // Catch:{ all -> 0x0032 }
                    if (r4 == 0) goto L_0x0020
                    androidx.lifecycle.ComputableLiveData r0 = androidx.lifecycle.ComputableLiveData.this     // Catch:{ all -> 0x0032 }
                    java.lang.Object r0 = r0.compute()     // Catch:{ all -> 0x0032 }
                    r3 = r2
                    goto L_0x000e
                L_0x0020:
                    if (r3 == 0) goto L_0x0029
                    androidx.lifecycle.ComputableLiveData r2 = androidx.lifecycle.ComputableLiveData.this     // Catch:{ all -> 0x0032 }
                    androidx.lifecycle.LiveData<T> r2 = r2.mLiveData     // Catch:{ all -> 0x0032 }
                    r2.postValue(r0)     // Catch:{ all -> 0x0032 }
                L_0x0029:
                    androidx.lifecycle.ComputableLiveData r0 = androidx.lifecycle.ComputableLiveData.this
                    java.util.concurrent.atomic.AtomicBoolean r0 = r0.mComputing
                    r0.set(r1)
                    r1 = r3
                    goto L_0x003b
                L_0x0032:
                    r0 = move-exception
                    androidx.lifecycle.ComputableLiveData r5 = androidx.lifecycle.ComputableLiveData.this
                    java.util.concurrent.atomic.AtomicBoolean r5 = r5.mComputing
                    r5.set(r1)
                    throw r0
                L_0x003b:
                    if (r1 == 0) goto L_0x0047
                    androidx.lifecycle.ComputableLiveData r0 = androidx.lifecycle.ComputableLiveData.this
                    java.util.concurrent.atomic.AtomicBoolean r0 = r0.mInvalid
                    boolean r0 = r0.get()
                    if (r0 != 0) goto L_0x0000
                L_0x0047:
                    return
                */
                throw new UnsupportedOperationException("Method not decompiled: androidx.lifecycle.ComputableLiveData.AnonymousClass2.run():void");
            }
        };
        this.mInvalidationRunnable = new Runnable() {
            @MainThread
            public void run() {
                boolean hasActiveObservers = ComputableLiveData.this.mLiveData.hasActiveObservers();
                if (ComputableLiveData.this.mInvalid.compareAndSet(false, true) && hasActiveObservers) {
                    ComputableLiveData computableLiveData = ComputableLiveData.this;
                    computableLiveData.mExecutor.execute(computableLiveData.mRefreshRunnable);
                }
            }
        };
        this.mExecutor = executor;
        this.mLiveData = new LiveData<T>() {
            /* access modifiers changed from: protected */
            public void onActive() {
                ComputableLiveData computableLiveData = ComputableLiveData.this;
                computableLiveData.mExecutor.execute(computableLiveData.mRefreshRunnable);
            }
        };
    }

    @NonNull
    public LiveData<T> getLiveData() {
        return this.mLiveData;
    }

    public void invalidate() {
        ArchTaskExecutor.getInstance().executeOnMainThread(this.mInvalidationRunnable);
    }
}
