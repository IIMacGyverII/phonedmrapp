package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataConfigManager$$ExternalSyntheticLambda10 implements Executor {
    public final /* synthetic */ DataConfigManager f$0;

    public /* synthetic */ DataConfigManager$$ExternalSyntheticLambda10(DataConfigManager dataConfigManager) {
        this.f$0 = dataConfigManager;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
