package com.android.internal.telephony.imsphone;

import java.util.Map;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsPhoneCallTracker$$ExternalSyntheticLambda2 implements Predicate {
    public final /* synthetic */ long f$0;

    public /* synthetic */ ImsPhoneCallTracker$$ExternalSyntheticLambda2(long j) {
        this.f$0 = j;
    }

    public final boolean test(Object obj) {
        return ImsPhoneCallTracker.lambda$maintainConnectTimeCache$2(this.f$0, (Map.Entry) obj);
    }
}
