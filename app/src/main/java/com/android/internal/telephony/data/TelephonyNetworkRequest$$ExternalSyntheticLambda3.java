package com.android.internal.telephony.data;

import java.util.function.IntUnaryOperator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkRequest$$ExternalSyntheticLambda3 implements IntUnaryOperator {
    public final /* synthetic */ DataConfigManager f$0;

    public /* synthetic */ TelephonyNetworkRequest$$ExternalSyntheticLambda3(DataConfigManager dataConfigManager) {
        this.f$0 = dataConfigManager;
    }

    public final int applyAsInt(int i) {
        return this.f$0.getNetworkCapabilityPriority(i);
    }
}
