package com.android.internal.telephony;

import android.content.Context;
import com.android.internal.telephony.PhoneSubInfoController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PhoneSubInfoController$$ExternalSyntheticLambda18 implements PhoneSubInfoController.PermissionCheckHelper {
    public final /* synthetic */ PhoneSubInfoController f$0;

    public /* synthetic */ PhoneSubInfoController$$ExternalSyntheticLambda18(PhoneSubInfoController phoneSubInfoController) {
        this.f$0 = phoneSubInfoController;
    }

    public final boolean checkPermission(Context context, int i, String str, String str2, String str3) {
        return this.f$0.lambda$callPhoneMethodForSubIdWithModifyCheck$25(context, i, str, str2, str3);
    }
}
