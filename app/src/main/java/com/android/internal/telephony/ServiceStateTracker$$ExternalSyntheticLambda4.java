package com.android.internal.telephony;

import android.telephony.NetworkRegistrationInfo;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ServiceStateTracker$$ExternalSyntheticLambda4 implements Function {
    public final Object apply(Object obj) {
        return Integer.valueOf(((NetworkRegistrationInfo) obj).getDomain() & 1);
    }
}
