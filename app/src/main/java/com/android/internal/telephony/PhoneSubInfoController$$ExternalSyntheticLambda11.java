package com.android.internal.telephony;

import android.telephony.ImsiEncryptionInfo;
import com.android.internal.telephony.PhoneSubInfoController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PhoneSubInfoController$$ExternalSyntheticLambda11 implements PhoneSubInfoController.CallPhoneMethodHelper {
    public final /* synthetic */ ImsiEncryptionInfo f$0;

    public /* synthetic */ PhoneSubInfoController$$ExternalSyntheticLambda11(ImsiEncryptionInfo imsiEncryptionInfo) {
        this.f$0 = imsiEncryptionInfo;
    }

    public final Object callMethod(Phone phone) {
        return phone.setCarrierInfoForImsiEncryption(this.f$0);
    }
}
