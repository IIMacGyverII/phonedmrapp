package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda0 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ String f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda0(String str) {
        this.f$0 = str;
    }

    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48959).addChildAsString(128, this.f$0).build().toHex());
    }
}
