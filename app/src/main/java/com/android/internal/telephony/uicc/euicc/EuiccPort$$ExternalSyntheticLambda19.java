package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda19 implements EuiccPort.ApduResponseHandler {
    public final /* synthetic */ EuiccPort f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda19(EuiccPort euiccPort) {
        this.f$0 = euiccPort;
    }

    public final Object handleResult(byte[] bArr) {
        return this.f$0.lambda$getSpecVersion$1(bArr);
    }
}
