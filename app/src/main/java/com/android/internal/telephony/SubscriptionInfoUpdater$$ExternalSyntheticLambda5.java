package com.android.internal.telephony;

import com.android.internal.telephony.SubscriptionInfoUpdater;
import java.util.List;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SubscriptionInfoUpdater$$ExternalSyntheticLambda5 implements Runnable {
    public final /* synthetic */ SubscriptionInfoUpdater f$0;
    public final /* synthetic */ List f$1;
    public final /* synthetic */ SubscriptionInfoUpdater.UpdateEmbeddedSubsCallback f$2;

    public /* synthetic */ SubscriptionInfoUpdater$$ExternalSyntheticLambda5(SubscriptionInfoUpdater subscriptionInfoUpdater, List list, SubscriptionInfoUpdater.UpdateEmbeddedSubsCallback updateEmbeddedSubsCallback) {
        this.f$0 = subscriptionInfoUpdater;
        this.f$1 = list;
        this.f$2 = updateEmbeddedSubsCallback;
    }

    public final void run() {
        this.f$0.lambda$updateEmbeddedSubscriptions$4(this.f$1, this.f$2);
    }
}
