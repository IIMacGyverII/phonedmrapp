package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataProfileManager$$ExternalSyntheticLambda4 implements Predicate {
    public final /* synthetic */ TelephonyNetworkRequest f$0;

    public /* synthetic */ DataProfileManager$$ExternalSyntheticLambda4(TelephonyNetworkRequest telephonyNetworkRequest) {
        this.f$0 = telephonyNetworkRequest;
    }

    public final boolean test(Object obj) {
        return this.f$0.canBeSatisfiedBy((DataProfile) obj);
    }
}
