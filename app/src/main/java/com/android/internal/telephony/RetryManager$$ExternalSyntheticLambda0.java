package com.android.internal.telephony;

import android.telephony.data.ApnSetting;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RetryManager$$ExternalSyntheticLambda0 implements Predicate {
    public final boolean test(Object obj) {
        return ((ApnSetting) obj).getPermanentFailed();
    }
}
