package com.android.internal.telephony.ims;

import android.telephony.ims.stub.ImsFeatureConfiguration;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsServiceController$$ExternalSyntheticLambda6 implements Predicate {
    public final /* synthetic */ int f$0;

    public /* synthetic */ ImsServiceController$$ExternalSyntheticLambda6(int i) {
        this.f$0 = i;
    }

    public final boolean test(Object obj) {
        return ImsServiceController.lambda$changeImsServiceFeatures$2(this.f$0, (ImsFeatureConfiguration.FeatureSlotPair) obj);
    }
}
