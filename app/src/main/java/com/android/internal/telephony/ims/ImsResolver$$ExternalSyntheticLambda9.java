package com.android.internal.telephony.ims;

import android.telephony.ims.stub.ImsFeatureConfiguration;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda9 implements Predicate {
    public final /* synthetic */ ImsResolver f$0;

    public /* synthetic */ ImsResolver$$ExternalSyntheticLambda9(ImsResolver imsResolver) {
        this.f$0 = imsResolver;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$sanitizeFeatureConfig$13((ImsFeatureConfiguration.FeatureSlotPair) obj);
    }
}
