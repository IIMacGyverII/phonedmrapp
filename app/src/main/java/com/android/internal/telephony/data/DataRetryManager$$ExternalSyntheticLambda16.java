package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda16 implements Predicate {
    public final /* synthetic */ long f$0;
    public final /* synthetic */ String f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda16(long j, String str, int i) {
        this.f$0 = j;
        this.f$1 = str;
        this.f$2 = i;
    }

    public final boolean test(Object obj) {
        return DataRetryManager.lambda$onDataProfileUnthrottled$18(this.f$0, this.f$1, this.f$2, (DataRetryManager.DataThrottlingEntry) obj);
    }
}
