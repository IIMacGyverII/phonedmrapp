package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class KeepaliveTracker$$ExternalSyntheticLambda0 implements Executor {
    public final /* synthetic */ KeepaliveTracker f$0;

    public /* synthetic */ KeepaliveTracker$$ExternalSyntheticLambda0(KeepaliveTracker keepaliveTracker) {
        this.f$0 = keepaliveTracker;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
