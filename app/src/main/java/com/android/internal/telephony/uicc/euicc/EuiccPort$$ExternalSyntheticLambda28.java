package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;
import com.android.internal.telephony.uicc.euicc.apdu.RequestProvider;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda28 implements RequestProvider {
    public final /* synthetic */ EuiccPort f$0;
    public final /* synthetic */ EuiccPort.ApduRequestBuilder f$1;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda28(EuiccPort euiccPort, EuiccPort.ApduRequestBuilder apduRequestBuilder) {
        this.f$0 = euiccPort;
        this.f$1 = apduRequestBuilder;
    }

    public final void buildRequest(byte[] bArr, RequestBuilder requestBuilder) {
        this.f$0.lambda$newRequestProvider$49(this.f$1, bArr, requestBuilder);
    }
}
