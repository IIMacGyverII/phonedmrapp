package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class QosCallbackTracker$$ExternalSyntheticLambda3 implements Executor {
    public final /* synthetic */ QosCallbackTracker f$0;

    public /* synthetic */ QosCallbackTracker$$ExternalSyntheticLambda3(QosCallbackTracker qosCallbackTracker) {
        this.f$0 = qosCallbackTracker;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
