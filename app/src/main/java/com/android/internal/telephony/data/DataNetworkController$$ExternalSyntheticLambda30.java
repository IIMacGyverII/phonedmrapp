package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda30 implements Predicate {
    public final /* synthetic */ DataProfile f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda30(DataProfile dataProfile) {
        this.f$0 = dataProfile;
    }

    public final boolean test(Object obj) {
        return ((TelephonyNetworkRequest) obj).canBeSatisfiedBy(this.f$0);
    }
}
