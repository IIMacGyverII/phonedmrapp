package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda3 implements EuiccPort.ApduResponseHandler {
    public final Object handleResult(byte[] bArr) {
        return EuiccPort.parseResponse(bArr).getChild(129, new int[0]).asString();
    }
}
