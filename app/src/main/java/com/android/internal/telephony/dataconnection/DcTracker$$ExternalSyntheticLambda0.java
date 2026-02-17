package com.android.internal.telephony.dataconnection;

import android.telephony.data.ApnSetting;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DcTracker$$ExternalSyntheticLambda0 implements Predicate {
    public final /* synthetic */ String f$0;

    public /* synthetic */ DcTracker$$ExternalSyntheticLambda0(String str) {
        this.f$0 = str;
    }

    public final boolean test(Object obj) {
        return this.f$0.equals(((ApnSetting) obj).getApnName());
    }
}
