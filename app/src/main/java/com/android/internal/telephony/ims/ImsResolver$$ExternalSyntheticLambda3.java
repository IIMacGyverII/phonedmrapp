package com.android.internal.telephony.ims;

import android.telephony.ims.stub.ImsFeatureConfiguration;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda3 implements Predicate {
    public final /* synthetic */ Integer f$0;

    public /* synthetic */ ImsResolver$$ExternalSyntheticLambda3(Integer num) {
        this.f$0 = num;
    }

    public final boolean test(Object obj) {
        return ImsResolver.lambda$handleMsimConfigChange$12(this.f$0, (ImsFeatureConfiguration.FeatureSlotPair) obj);
    }
}
