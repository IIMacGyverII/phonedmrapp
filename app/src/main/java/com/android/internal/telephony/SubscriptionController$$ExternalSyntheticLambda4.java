package com.android.internal.telephony;

import android.os.ParcelUuid;
import android.telephony.SubscriptionInfo;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SubscriptionController$$ExternalSyntheticLambda4 implements Predicate {
    public final /* synthetic */ SubscriptionController f$0;
    public final /* synthetic */ ParcelUuid f$1;
    public final /* synthetic */ String f$2;
    public final /* synthetic */ String f$3;

    public /* synthetic */ SubscriptionController$$ExternalSyntheticLambda4(SubscriptionController subscriptionController, ParcelUuid parcelUuid, String str, String str2) {
        this.f$0 = subscriptionController;
        this.f$1 = parcelUuid;
        this.f$2 = str;
        this.f$3 = str2;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$getSubscriptionsInGroup$8(this.f$1, this.f$2, this.f$3, (SubscriptionInfo) obj);
    }
}
