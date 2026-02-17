package com.android.internal.telephony.data;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataConfigManager$$ExternalSyntheticLambda2 implements Predicate {
    public final /* synthetic */ DataConfigManager f$0;
    public final /* synthetic */ boolean f$1;

    public /* synthetic */ DataConfigManager$$ExternalSyntheticLambda2(DataConfigManager dataConfigManager, boolean z) {
        this.f$0 = dataConfigManager;
        this.f$1 = z;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$isAnyMeteredCapability$2(this.f$1, (Integer) obj);
    }
}
