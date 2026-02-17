package com.android.internal.telephony.ims;

import com.android.internal.telephony.ims.ImsServiceController;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsServiceController$$ExternalSyntheticLambda2 implements Predicate {
    public final /* synthetic */ int f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ ImsServiceController$$ExternalSyntheticLambda2(int i, int i2) {
        this.f$0 = i;
        this.f$1 = i2;
    }

    public final boolean test(Object obj) {
        return ImsServiceController.lambda$removeImsFeatureStatusCallback$4(this.f$0, this.f$1, (ImsServiceController.ImsFeatureStatusCallback) obj);
    }
}
