package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda32 implements EuiccPort.ApduResponseHandler {
    public final /* synthetic */ String f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda32(String str) {
        this.f$0 = str;
    }

    public final Object handleResult(byte[] bArr) {
        return EuiccPort.lambda$disableProfile$7(this.f$0, bArr);
    }
}
