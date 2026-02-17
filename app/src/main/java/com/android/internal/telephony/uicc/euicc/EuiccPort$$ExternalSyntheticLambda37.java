package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda37 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ String f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda37(String str) {
        this.f$0 = str;
    }

    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48947).addChildAsBytes(90, IccUtils.bcdToBytes(EuiccPort.padTrailingFs(this.f$0))).build().toHex());
    }
}
