package com.android.internal.telephony;

import android.content.Context;
import com.android.internal.telephony.PhoneSubInfoController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PhoneSubInfoController$$ExternalSyntheticLambda0 implements PhoneSubInfoController.PermissionCheckHelper {
    public final /* synthetic */ PhoneSubInfoController f$0;
    public final /* synthetic */ String f$1;

    public /* synthetic */ PhoneSubInfoController$$ExternalSyntheticLambda0(PhoneSubInfoController phoneSubInfoController, String str) {
        this.f$0 = phoneSubInfoController;
        this.f$1 = str;
    }

    public final boolean checkPermission(Context context, int i, String str, String str2, String str3) {
        return this.f$0.lambda$callPhoneMethodForSubIdWithPrivilegedCheck$24(this.f$1, context, i, str, str2, str3);
    }
}
