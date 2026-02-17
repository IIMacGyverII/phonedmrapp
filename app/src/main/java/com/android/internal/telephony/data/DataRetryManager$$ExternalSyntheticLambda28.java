package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda28 implements Executor {
    public final /* synthetic */ DataRetryManager f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda28(DataRetryManager dataRetryManager) {
        this.f$0 = dataRetryManager;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
