package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda12 implements Predicate {
    public final /* synthetic */ long f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda12(long j) {
        this.f$0 = j;
    }

    public final boolean test(Object obj) {
        return DataRetryManager.lambda$onDataProfileUnthrottled$14(this.f$0, (DataRetryManager.DataThrottlingEntry) obj);
    }
}
