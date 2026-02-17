package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda39 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ EuiccPort f$0;
    public final /* synthetic */ byte[] f$1;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda39(EuiccPort euiccPort, byte[] bArr) {
        this.f$0 = euiccPort;
        this.f$1 = bArr;
    }

    public final void build(RequestBuilder requestBuilder) {
        this.f$0.lambda$loadBoundProfilePackage$36(this.f$1, requestBuilder);
    }
}
