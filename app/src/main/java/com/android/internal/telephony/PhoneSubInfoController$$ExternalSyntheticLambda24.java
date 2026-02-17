package com.android.internal.telephony;

import com.android.internal.telephony.PhoneSubInfoController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PhoneSubInfoController$$ExternalSyntheticLambda24 implements PhoneSubInfoController.CallPhoneMethodHelper {
    public final /* synthetic */ int f$0;

    public /* synthetic */ PhoneSubInfoController$$ExternalSyntheticLambda24(int i) {
        this.f$0 = i;
    }

    public final Object callMethod(Phone phone) {
        return phone.getCarrierInfoForImsiEncryption(this.f$0, true);
    }
}
