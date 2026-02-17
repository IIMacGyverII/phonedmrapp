package com.android.internal.telephony.data;

import java.util.function.ToIntFunction;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$$ExternalSyntheticLambda8 implements ToIntFunction {
    public final /* synthetic */ DataConfigManager f$0;

    public /* synthetic */ DataNetwork$$ExternalSyntheticLambda8(DataConfigManager dataConfigManager) {
        this.f$0 = dataConfigManager;
    }

    public final int applyAsInt(Object obj) {
        return this.f$0.getNetworkCapabilityPriority(((Integer) obj).intValue());
    }
}
