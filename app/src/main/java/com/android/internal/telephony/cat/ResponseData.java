package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import java.io.ByteArrayOutputStream;

public abstract class ResponseData {
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public abstract void format(ByteArrayOutputStream byteArrayOutputStream);

    public static void writeLength(ByteArrayOutputStream byteArrayOutputStream, int i) {
        if (i > 127) {
            byteArrayOutputStream.write(129);
        }
        byteArrayOutputStream.write(i);
    }
}
