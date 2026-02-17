package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda6 implements Executor {
    public final /* synthetic */ DataNetworkController f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda6(DataNetworkController dataNetworkController) {
        this.f$0 = dataNetworkController;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
