package com.android.internal.telephony;

import android.telephony.SubscriptionInfo;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SubscriptionController$$ExternalSyntheticLambda2 implements Predicate {
    public final /* synthetic */ int f$0;

    public /* synthetic */ SubscriptionController$$ExternalSyntheticLambda2(int i) {
        this.f$0 = i;
    }

    public final boolean test(Object obj) {
        return SubscriptionController.lambda$setSubscriptionEnabled$11(this.f$0, (SubscriptionInfo) obj);
    }
}
