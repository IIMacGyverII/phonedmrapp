package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PhoneSwitcher$$ExternalSyntheticLambda3 implements Executor {
    public final /* synthetic */ PhoneSwitcher f$0;

    public /* synthetic */ PhoneSwitcher$$ExternalSyntheticLambda3(PhoneSwitcher phoneSwitcher) {
        this.f$0 = phoneSwitcher;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
