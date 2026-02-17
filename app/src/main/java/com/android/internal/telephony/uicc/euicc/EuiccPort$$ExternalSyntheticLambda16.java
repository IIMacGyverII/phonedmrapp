package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda16 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ String f$0;
    public final /* synthetic */ String f$1;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda16(String str, String str2) {
        this.f$0 = str;
        this.f$1 = str2;
    }

    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48937).addChildAsBytes(90, IccUtils.bcdToBytes(EuiccPort.padTrailingFs(this.f$0))).addChildAsString(144, this.f$1).build().toHex());
    }
}
