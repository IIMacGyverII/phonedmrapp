package com.android.internal.telephony;

import com.android.internal.telephony.InboundSmsHandler;
import java.util.List;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class InboundSmsHandler$$ExternalSyntheticLambda1 implements InboundSmsHandler.SmsFilter {
    public final /* synthetic */ InboundSmsHandler f$0;

    public /* synthetic */ InboundSmsHandler$$ExternalSyntheticLambda1(InboundSmsHandler inboundSmsHandler) {
        this.f$0 = inboundSmsHandler;
    }

    public final boolean filterSms(byte[][] bArr, int i, InboundSmsTracker inboundSmsTracker, InboundSmsHandler.SmsBroadcastReceiver smsBroadcastReceiver, boolean z, boolean z2, List list) {
        return this.f$0.lambda$createDefaultSmsFilters$1(bArr, i, inboundSmsTracker, smsBroadcastReceiver, z, z2, list);
    }
}
