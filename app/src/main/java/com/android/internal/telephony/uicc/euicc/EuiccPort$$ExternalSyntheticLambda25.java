package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda25 implements EuiccPort.ApduResponseHandler {
    public final /* synthetic */ EuiccPort f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda25(EuiccPort euiccPort) {
        this.f$0 = euiccPort;
    }

    public final Object handleResult(byte[] bArr) {
        return this.f$0.lambda$getEid$11(bArr);
    }
}
