package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataProfileManager$$ExternalSyntheticLambda1 implements Predicate {
    public final /* synthetic */ String f$0;

    public /* synthetic */ DataProfileManager$$ExternalSyntheticLambda1(String str) {
        this.f$0 = str;
    }

    public final boolean test(Object obj) {
        return DataProfileManager.lambda$getPreferredDataProfileFromConfig$5(this.f$0, (DataProfile) obj);
    }
}
