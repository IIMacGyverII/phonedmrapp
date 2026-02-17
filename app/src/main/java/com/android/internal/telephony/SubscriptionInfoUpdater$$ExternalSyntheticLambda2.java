package com.android.internal.telephony;

import com.android.internal.telephony.SubscriptionInfoUpdater;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SubscriptionInfoUpdater$$ExternalSyntheticLambda2 implements SubscriptionInfoUpdater.UpdateEmbeddedSubsCallback {
    public final /* synthetic */ SubscriptionInfoUpdater f$0;
    public final /* synthetic */ Runnable f$1;

    public /* synthetic */ SubscriptionInfoUpdater$$ExternalSyntheticLambda2(SubscriptionInfoUpdater subscriptionInfoUpdater, Runnable runnable) {
        this.f$0 = subscriptionInfoUpdater;
        this.f$1 = runnable;
    }

    public final void run(boolean z) {
        this.f$0.lambda$handleMessage$1(this.f$1, z);
    }
}
