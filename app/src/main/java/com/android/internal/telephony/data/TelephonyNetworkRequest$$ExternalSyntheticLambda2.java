package com.android.internal.telephony.data;

import android.telephony.data.ApnSetting;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkRequest$$ExternalSyntheticLambda2 implements Predicate {
    public final /* synthetic */ ApnSetting f$0;

    public /* synthetic */ TelephonyNetworkRequest$$ExternalSyntheticLambda2(ApnSetting apnSetting) {
        this.f$0 = apnSetting;
    }

    public final boolean test(Object obj) {
        return this.f$0.canHandleType(((Integer) obj).intValue());
    }
}
