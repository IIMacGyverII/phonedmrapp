package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda14 implements Predicate {
    public final /* synthetic */ DataProfile f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda14(DataProfile dataProfile) {
        this.f$0 = dataProfile;
    }

    public final boolean test(Object obj) {
        return ((DataRetryManager.DataThrottlingEntry) obj).dataProfile.getApnSetting().getApnName().equals(this.f$0.getApnSetting().getApnName());
    }
}
