package com.android.internal.telephony.ims;

import android.telephony.ims.stub.ImsFeatureConfiguration;
import com.android.internal.telephony.ims.ImsResolver;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda1 implements Predicate {
    public final /* synthetic */ ImsResolver f$0;
    public final /* synthetic */ ImsResolver.ImsServiceInfo f$1;

    public /* synthetic */ ImsResolver$$ExternalSyntheticLambda1(ImsResolver imsResolver, ImsResolver.ImsServiceInfo imsServiceInfo) {
        this.f$0 = imsResolver;
        this.f$1 = imsServiceInfo;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$calculateFeaturesToCreate$9(this.f$1, (ImsFeatureConfiguration.FeatureSlotPair) obj);
    }
}
