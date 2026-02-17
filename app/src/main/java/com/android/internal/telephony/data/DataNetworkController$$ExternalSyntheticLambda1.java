package com.android.internal.telephony.data;

import android.net.NetworkCapabilities;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda1 implements Predicate {
    public final /* synthetic */ NetworkCapabilities f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda1(NetworkCapabilities networkCapabilities) {
        this.f$0 = networkCapabilities;
    }

    public final boolean test(Object obj) {
        return this.f$0.hasCapability(((Integer) obj).intValue());
    }
}
