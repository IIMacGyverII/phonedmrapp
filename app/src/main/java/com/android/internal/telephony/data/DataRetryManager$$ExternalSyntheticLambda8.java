package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda8 implements Predicate {
    public final /* synthetic */ DataProfile f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda8(DataProfile dataProfile, int i) {
        this.f$0 = dataProfile;
        this.f$1 = i;
    }

    public final boolean test(Object obj) {
        return DataRetryManager.lambda$isAnySetupRetryScheduled$22(this.f$0, this.f$1, (DataRetryManager.DataSetupRetryEntry) obj);
    }
}
