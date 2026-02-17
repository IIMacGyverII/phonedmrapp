package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda44 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ byte[] f$0;
    public final /* synthetic */ byte[] f$1;
    public final /* synthetic */ byte[] f$2;
    public final /* synthetic */ byte[] f$3;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda44(byte[] bArr, byte[] bArr2, byte[] bArr3, byte[] bArr4) {
        this.f$0 = bArr;
        this.f$1 = bArr2;
        this.f$2 = bArr3;
        this.f$3 = bArr4;
    }

    public final void build(RequestBuilder requestBuilder) {
        EuiccPort.lambda$prepareDownload$34(this.f$0, this.f$1, this.f$2, this.f$3, requestBuilder);
    }
}
