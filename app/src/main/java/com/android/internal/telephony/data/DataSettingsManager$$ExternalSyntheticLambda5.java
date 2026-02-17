package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataSettingsManager$$ExternalSyntheticLambda5 implements Executor {
    public final /* synthetic */ DataSettingsManager f$0;

    public /* synthetic */ DataSettingsManager$$ExternalSyntheticLambda5(DataSettingsManager dataSettingsManager) {
        this.f$0 = dataSettingsManager;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
