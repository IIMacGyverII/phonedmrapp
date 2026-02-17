package com.android.internal.telephony;

import android.hardware.radio.V1_5.LinkAddress;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RILUtils$$ExternalSyntheticLambda2 implements Function {
    public final Object apply(Object obj) {
        return RILUtils.convertToLinkAddress(((LinkAddress) obj).address, ((LinkAddress) obj).properties, ((LinkAddress) obj).deprecationTime, ((LinkAddress) obj).expirationTime);
    }
}
