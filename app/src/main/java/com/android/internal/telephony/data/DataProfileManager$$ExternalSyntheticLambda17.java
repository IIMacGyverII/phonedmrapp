package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataProfileManager$$ExternalSyntheticLambda17 implements Predicate {
    public final /* synthetic */ DataProfileManager f$0;
    public final /* synthetic */ DataProfile f$1;

    public /* synthetic */ DataProfileManager$$ExternalSyntheticLambda17(DataProfileManager dataProfileManager, DataProfile dataProfile) {
        this.f$0 = dataProfileManager;
        this.f$1 = dataProfile;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$isDataProfileCompatible$14(this.f$1, (DataProfile) obj);
    }
}
