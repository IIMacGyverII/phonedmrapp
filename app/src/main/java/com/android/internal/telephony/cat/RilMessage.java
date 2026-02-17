package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;

public class RilMessage {
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Object mData;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int mId;
    public ResultCode mResCode;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public RilMessage(int i, String str) {
        this.mId = i;
        this.mData = str;
    }

    public RilMessage(RilMessage rilMessage) {
        this.mId = rilMessage.mId;
        this.mData = rilMessage.mData;
        this.mResCode = rilMessage.mResCode;
    }
}
