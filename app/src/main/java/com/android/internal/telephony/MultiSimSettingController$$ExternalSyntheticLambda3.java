package com.android.internal.telephony;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class MultiSimSettingController$$ExternalSyntheticLambda3 implements Executor {
    public final /* synthetic */ MultiSimSettingController f$0;

    public /* synthetic */ MultiSimSettingController$$ExternalSyntheticLambda3(MultiSimSettingController multiSimSettingController) {
        this.f$0 = multiSimSettingController;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
