package com.android.internal.telephony.data;

import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda20 implements Function {
    public final /* synthetic */ DataRetryManager f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ long f$2;
    public final /* synthetic */ int f$3;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda20(DataRetryManager dataRetryManager, int i, long j, int i2) {
        this.f$0 = dataRetryManager;
        this.f$1 = i;
        this.f$2 = j;
        this.f$3 = i2;
    }

    public final Object apply(Object obj) {
        return this.f$0.lambda$updateThrottleStatus$11(this.f$1, this.f$2, this.f$3, (Integer) obj);
    }
}
