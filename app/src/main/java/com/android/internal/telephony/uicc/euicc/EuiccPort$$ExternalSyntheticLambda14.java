package com.android.internal.telephony.uicc.euicc;

import android.telephony.gsm.SmsMessage;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda14 implements EuiccPort.ApduRequestBuilder {
    public final /* synthetic */ String f$0;
    public final /* synthetic */ boolean f$1;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda14(String str, boolean z) {
        this.f$0 = str;
        this.f$1 = z;
    }

    public final void build(RequestBuilder requestBuilder) {
        requestBuilder.addStoreData(Asn1Node.newBuilder(48945).addChild(Asn1Node.newBuilder(SmsMessage.MAX_USER_DATA_SEPTETS).addChildAsBytes(90, IccUtils.bcdToBytes(EuiccPort.padTrailingFs(this.f$0)))).addChildAsBoolean(129, this.f$1).build().toHex());
    }
}
