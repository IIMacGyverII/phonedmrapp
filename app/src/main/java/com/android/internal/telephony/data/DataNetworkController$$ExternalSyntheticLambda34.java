package com.android.internal.telephony.data;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda34 implements Predicate {
    public final /* synthetic */ DataNetworkController f$0;
    public final /* synthetic */ DataNetwork f$1;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda34(DataNetworkController dataNetworkController, DataNetwork dataNetwork) {
        this.f$0 = dataNetworkController;
        this.f$1 = dataNetwork;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$evaluateDataNetwork$11(this.f$1, (TelephonyNetworkRequest) obj);
    }
}
