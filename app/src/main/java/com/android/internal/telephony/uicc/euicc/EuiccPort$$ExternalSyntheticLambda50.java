package com.android.internal.telephony.uicc.euicc;

import android.telephony.gsm.SmsMessage;
import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda50 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ int f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda50(int i) {
        this.f$0 = i;
    }

    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48939).addChild(Asn1Node.newBuilder(SmsMessage.MAX_USER_DATA_SEPTETS).addChildAsInteger(128, this.f$0)).build().toHex());
    }
}
