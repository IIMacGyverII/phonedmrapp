package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda24 implements EuiccPort.ApduRequestBuilder {
    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48958).addChildAsBytes(92, new byte[]{90}).build().toHex());
    }
}
