package com.android.internal.telephony.data;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda33 implements Predicate {
    public final /* synthetic */ TelephonyNetworkRequest f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda33(TelephonyNetworkRequest telephonyNetworkRequest) {
        this.f$0 = telephonyNetworkRequest;
    }

    public final boolean test(Object obj) {
        return ((TelephonyNetworkRequest) obj).equals(this.f$0);
    }
}
