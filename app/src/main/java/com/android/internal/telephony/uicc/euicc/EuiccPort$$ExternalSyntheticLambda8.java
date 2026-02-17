package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda8 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ byte[] f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda8(byte[] bArr) {
        this.f$0 = bArr;
    }

    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48941).addChildAsBytes(92, this.f$0).build().toHex());
    }
}
