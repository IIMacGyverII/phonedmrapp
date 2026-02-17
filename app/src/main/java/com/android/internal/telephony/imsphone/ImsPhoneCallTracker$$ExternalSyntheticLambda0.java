package com.android.internal.telephony.imsphone;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsPhoneCallTracker$$ExternalSyntheticLambda0 implements Executor {
    public final /* synthetic */ ImsPhoneCallTracker f$0;

    public /* synthetic */ ImsPhoneCallTracker$$ExternalSyntheticLambda0(ImsPhoneCallTracker imsPhoneCallTracker) {
        this.f$0 = imsPhoneCallTracker;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
