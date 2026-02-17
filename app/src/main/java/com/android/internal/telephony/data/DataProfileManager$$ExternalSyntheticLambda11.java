package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataProfileManager$$ExternalSyntheticLambda11 implements Executor {
    public final /* synthetic */ DataProfileManager f$0;

    public /* synthetic */ DataProfileManager$$ExternalSyntheticLambda11(DataProfileManager dataProfileManager) {
        this.f$0 = dataProfileManager;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
