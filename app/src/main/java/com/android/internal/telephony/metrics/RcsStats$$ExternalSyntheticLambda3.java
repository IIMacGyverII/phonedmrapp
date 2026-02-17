package com.android.internal.telephony.metrics;

import com.android.internal.telephony.metrics.RcsStats;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RcsStats$$ExternalSyntheticLambda3 implements Predicate {
    public final /* synthetic */ String f$0;

    public /* synthetic */ RcsStats$$ExternalSyntheticLambda3(String str) {
        this.f$0 = str;
    }

    public final boolean test(Object obj) {
        return ((RcsStats.SipTransportSessionArray) obj).mCallId.equals(this.f$0);
    }
}
