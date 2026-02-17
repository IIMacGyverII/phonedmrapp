package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda11 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ byte[] f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda11(byte[] bArr, int i) {
        this.f$0 = bArr;
        this.f$1 = i;
    }

    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48961).addChildAsBytes(128, this.f$0).addChildAsInteger(129, this.f$1).build().toHex());
    }
}
