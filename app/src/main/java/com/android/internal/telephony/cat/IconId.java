package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;

public class IconId extends ValueObject {
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int recordNumber;
    public boolean selfExplanatory;

    /* access modifiers changed from: package-private */
    public ComprehensionTlvTag getTag() {
        return ComprehensionTlvTag.ICON_ID;
    }
}
