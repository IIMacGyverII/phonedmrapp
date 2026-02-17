package com.android.internal.telephony.ims;

import android.telephony.ims.stub.ImsFeatureConfiguration;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsServiceController$$ExternalSyntheticLambda0 implements Predicate {
    public final /* synthetic */ int f$0;

    public /* synthetic */ ImsServiceController$$ExternalSyntheticLambda0(int i) {
        this.f$0 = i;
    }

    public final boolean test(Object obj) {
        return ImsServiceController.lambda$getFeaturesForSlot$5(this.f$0, (ImsFeatureConfiguration.FeatureSlotPair) obj);
    }
}
