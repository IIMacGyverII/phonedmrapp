package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;
import com.pri.prizeinterphone.InterPhoneService;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda33 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ int f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda33(int i) {
        this.f$0 = i;
    }

    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48948).addChildAsBits(InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT, this.f$0).build().toHex());
    }
}
