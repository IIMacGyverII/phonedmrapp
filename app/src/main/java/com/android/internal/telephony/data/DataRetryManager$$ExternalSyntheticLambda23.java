package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda23 implements Predicate {
    public final /* synthetic */ DataProfile f$0;
    public final /* synthetic */ long f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda23(DataProfile dataProfile, long j, int i) {
        this.f$0 = dataProfile;
        this.f$1 = j;
        this.f$2 = i;
    }

    public final boolean test(Object obj) {
        return DataRetryManager.lambda$isDataProfileThrottled$23(this.f$0, this.f$1, this.f$2, (DataRetryManager.DataThrottlingEntry) obj);
    }
}
