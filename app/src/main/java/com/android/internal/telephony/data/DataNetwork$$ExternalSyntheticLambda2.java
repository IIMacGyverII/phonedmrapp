package com.android.internal.telephony.data;

import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$$ExternalSyntheticLambda2 implements Function {
    public final /* synthetic */ DataConfigManager f$0;

    public /* synthetic */ DataNetwork$$ExternalSyntheticLambda2(DataConfigManager dataConfigManager) {
        this.f$0 = dataConfigManager;
    }

    public final Object apply(Object obj) {
        return Integer.valueOf(this.f$0.getNetworkCapabilityPriority(((Integer) obj).intValue()));
    }
}
