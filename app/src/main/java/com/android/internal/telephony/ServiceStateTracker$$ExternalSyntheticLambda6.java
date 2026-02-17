package com.android.internal.telephony;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ServiceStateTracker$$ExternalSyntheticLambda6 implements Executor {
    public final /* synthetic */ ServiceStateTracker f$0;

    public /* synthetic */ ServiceStateTracker$$ExternalSyntheticLambda6(ServiceStateTracker serviceStateTracker) {
        this.f$0 = serviceStateTracker;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
