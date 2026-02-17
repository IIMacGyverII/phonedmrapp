package com.android.internal.telephony;

import android.os.Message;
import android.os.PersistableBundle;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SubscriptionInfoUpdater$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ SubscriptionInfoUpdater f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ String f$2;
    public final /* synthetic */ PersistableBundle f$3;
    public final /* synthetic */ Message f$4;

    public /* synthetic */ SubscriptionInfoUpdater$$ExternalSyntheticLambda0(SubscriptionInfoUpdater subscriptionInfoUpdater, int i, String str, PersistableBundle persistableBundle, Message message) {
        this.f$0 = subscriptionInfoUpdater;
        this.f$1 = i;
        this.f$2 = str;
        this.f$3 = persistableBundle;
        this.f$4 = message;
    }

    public final void run() {
        this.f$0.lambda$updateSubscriptionByCarrierConfigAndNotifyComplete$6(this.f$1, this.f$2, this.f$3, this.f$4);
    }
}
