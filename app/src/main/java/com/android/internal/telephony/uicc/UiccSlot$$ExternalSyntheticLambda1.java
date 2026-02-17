package com.android.internal.telephony.uicc;

import android.telephony.SubscriptionInfo;
import java.util.Map;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class UiccSlot$$ExternalSyntheticLambda1 implements Function {
    public final Object apply(Object obj) {
        return SubscriptionInfo.givePrintableIccid((String) ((Map.Entry) obj).getValue());
    }
}
