package com.android.internal.telephony.dataconnection;

import android.telephony.data.ApnSetting;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DcTracker$$ExternalSyntheticLambda6 implements Predicate {
    public final /* synthetic */ int f$0;

    public /* synthetic */ DcTracker$$ExternalSyntheticLambda6(int i) {
        this.f$0 = i;
    }

    public final boolean test(Object obj) {
        return DcTracker.lambda$setInitialAttachApn$5(this.f$0, (ApnSetting) obj);
    }
}
