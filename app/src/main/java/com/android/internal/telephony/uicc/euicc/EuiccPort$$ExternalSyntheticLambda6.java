package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda6 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ EuiccPort f$0;
    public final /* synthetic */ String f$1;
    public final /* synthetic */ byte[] f$2;
    public final /* synthetic */ byte[] f$3;
    public final /* synthetic */ byte[] f$4;
    public final /* synthetic */ byte[] f$5;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda6(EuiccPort euiccPort, String str, byte[] bArr, byte[] bArr2, byte[] bArr3, byte[] bArr4) {
        this.f$0 = euiccPort;
        this.f$1 = str;
        this.f$2 = bArr;
        this.f$3 = bArr2;
        this.f$4 = bArr3;
        this.f$5 = bArr4;
    }

    public final void build(RequestBuilder requestBuilder) {
        this.f$0.lambda$authenticateServer$32(this.f$1, this.f$2, this.f$3, this.f$4, this.f$5, requestBuilder);
    }
}
