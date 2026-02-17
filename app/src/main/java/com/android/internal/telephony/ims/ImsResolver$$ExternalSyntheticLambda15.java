package com.android.internal.telephony.ims;

import android.telephony.ims.stub.ImsFeatureConfiguration;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda15 implements Predicate {
    public final /* synthetic */ int f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ ImsResolver$$ExternalSyntheticLambda15(int i, int i2) {
        this.f$0 = i;
        this.f$1 = i2;
    }

    public final boolean test(Object obj) {
        return ImsResolver.lambda$doesCachedImsServiceExist$2(this.f$0, this.f$1, (ImsFeatureConfiguration.FeatureSlotPair) obj);
    }
}
