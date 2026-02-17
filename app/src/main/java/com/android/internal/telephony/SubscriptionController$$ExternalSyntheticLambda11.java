package com.android.internal.telephony;

import android.telephony.SubscriptionInfo;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SubscriptionController$$ExternalSyntheticLambda11 implements Predicate {
    public final /* synthetic */ SubscriptionController f$0;
    public final /* synthetic */ String f$1;

    public /* synthetic */ SubscriptionController$$ExternalSyntheticLambda11(SubscriptionController subscriptionController, String str) {
        this.f$0 = subscriptionController;
        this.f$1 = str;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$getAccessibleSubscriptionInfoList$2(this.f$1, (SubscriptionInfo) obj);
    }
}
