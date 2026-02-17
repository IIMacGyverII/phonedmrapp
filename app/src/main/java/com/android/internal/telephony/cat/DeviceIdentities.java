package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;

/* compiled from: CommandDetails */
class DeviceIdentities extends ValueObject {
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int destinationId;
    public int sourceId;

    DeviceIdentities() {
    }

    /* access modifiers changed from: package-private */
    public ComprehensionTlvTag getTag() {
        return ComprehensionTlvTag.DEVICE_IDENTITIES;
    }
}
