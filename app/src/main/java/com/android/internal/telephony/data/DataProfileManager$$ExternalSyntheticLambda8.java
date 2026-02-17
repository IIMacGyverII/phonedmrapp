package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataProfileManager$$ExternalSyntheticLambda8 implements Predicate {
    public final /* synthetic */ int f$0;

    public /* synthetic */ DataProfileManager$$ExternalSyntheticLambda8(int i) {
        this.f$0 = i;
    }

    public final boolean test(Object obj) {
        return DataProfileManager.lambda$getApnSettingForNetworkRequest$10(this.f$0, (DataProfile) obj);
    }
}
