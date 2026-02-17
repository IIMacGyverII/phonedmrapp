package com.android.internal.telephony.data;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda35 implements Predicate {
    public final /* synthetic */ DataNetwork f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda35(DataNetwork dataNetwork) {
        this.f$0 = dataNetwork;
    }

    public final boolean test(Object obj) {
        return DataNetworkController.lambda$evaluateDataNetwork$12(this.f$0, (TelephonyNetworkRequest) obj);
    }
}
