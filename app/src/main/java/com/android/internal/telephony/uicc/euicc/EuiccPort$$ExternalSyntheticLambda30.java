package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda30 implements EuiccPort.ApduResponseHandler {
    public final Object handleResult(byte[] bArr) {
        return EuiccPort.parseResponse(bArr).getChild(128, new int[0]).asBytes();
    }
}
