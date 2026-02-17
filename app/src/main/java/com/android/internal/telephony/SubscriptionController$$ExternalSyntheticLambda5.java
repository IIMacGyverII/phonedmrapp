package com.android.internal.telephony;

import android.telephony.SubscriptionInfo;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SubscriptionController$$ExternalSyntheticLambda5 implements Function {
    public final /* synthetic */ SubscriptionController f$0;
    public final /* synthetic */ String f$1;
    public final /* synthetic */ String f$2;

    public /* synthetic */ SubscriptionController$$ExternalSyntheticLambda5(SubscriptionController subscriptionController, String str, String str2) {
        this.f$0 = subscriptionController;
        this.f$1 = str;
        this.f$2 = str2;
    }

    public final Object apply(Object obj) {
        return this.f$0.lambda$getSubscriptionsInGroup$9(this.f$1, this.f$2, (SubscriptionInfo) obj);
    }
}
