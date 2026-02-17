package com.android.internal.telephony.data;

import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda17 implements Function {
    public final /* synthetic */ DataRetryManager f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda17(DataRetryManager dataRetryManager, int i, int i2) {
        this.f$0 = dataRetryManager;
        this.f$1 = i;
        this.f$2 = i2;
    }

    public final Object apply(Object obj) {
        return this.f$0.lambda$onDataProfileUnthrottled$19(this.f$1, this.f$2, (Integer) obj);
    }
}
