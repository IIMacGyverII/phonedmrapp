package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import com.android.telephony.Rlog;

public class CallForwardInfo {
    private static final String TAG = "CallForwardInfo";
    @UnsupportedAppUsage
    public String number;
    @UnsupportedAppUsage
    public int reason;
    @UnsupportedAppUsage
    public int serviceClass;
    @UnsupportedAppUsage
    public int status;
    @UnsupportedAppUsage
    public int timeSeconds;
    @UnsupportedAppUsage
    public int toa;

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("[CallForwardInfo: status=");
        sb.append(this.status == 0 ? " not active " : " active ");
        sb.append(", reason= ");
        sb.append(this.reason);
        sb.append(", serviceClass= ");
        sb.append(this.serviceClass);
        sb.append(", timeSec= ");
        sb.append(this.timeSeconds);
        sb.append(" seconds, number=");
        sb.append(Rlog.pii(TAG, this.number));
        sb.append("]");
        return sb.toString();
    }
}
