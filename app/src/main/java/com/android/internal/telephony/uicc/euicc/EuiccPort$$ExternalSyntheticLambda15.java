package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda15 implements EuiccPort.ApduResponseHandler {
    public final /* synthetic */ String f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda15(String str) {
        this.f$0 = str;
    }

    public final Object handleResult(byte[] bArr) {
        return EuiccPort.lambda$switchToProfile$9(this.f$0, bArr);
    }
}
