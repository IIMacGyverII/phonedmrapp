package com.android.internal.telephony;

import android.content.Context;
import com.android.internal.telephony.PhoneSubInfoController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PhoneSubInfoController$$ExternalSyntheticLambda20 implements PhoneSubInfoController.PermissionCheckHelper {
    public final boolean checkPermission(Context context, int i, String str, String str2, String str3) {
        return TelephonyPermissions.checkCallingOrSelfReadDeviceIdentifiers(context, i, str, str2, str3);
    }
}
