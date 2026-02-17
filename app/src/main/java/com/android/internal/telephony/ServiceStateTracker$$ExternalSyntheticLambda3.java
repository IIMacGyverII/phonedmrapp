package com.android.internal.telephony;

import android.telephony.NetworkRegistrationInfo;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ServiceStateTracker$$ExternalSyntheticLambda3 implements Function {
    public final Object apply(Object obj) {
        return Boolean.valueOf(((NetworkRegistrationInfo) obj).isRegistered());
    }
}
