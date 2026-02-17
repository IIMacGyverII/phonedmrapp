package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataStallRecoveryManager$$ExternalSyntheticLambda0 implements Executor {
    public final /* synthetic */ DataStallRecoveryManager f$0;

    public /* synthetic */ DataStallRecoveryManager$$ExternalSyntheticLambda0(DataStallRecoveryManager dataStallRecoveryManager) {
        this.f$0 = dataStallRecoveryManager;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
