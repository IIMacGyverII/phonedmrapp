package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda1 implements Predicate {
    public final /* synthetic */ DataNetwork f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda1(DataNetwork dataNetwork) {
        this.f$0 = dataNetwork;
    }

    public final boolean test(Object obj) {
        return DataRetryManager.lambda$onCancelPendingHandoverRetry$24(this.f$0, (DataRetryManager.DataRetryEntry) obj);
    }
}
