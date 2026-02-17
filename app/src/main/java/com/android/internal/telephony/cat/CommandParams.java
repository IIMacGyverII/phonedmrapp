package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.graphics.Bitmap;
import com.android.internal.telephony.cat.AppInterface;

public class CommandParams {
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CommandDetails mCmdDet;
    public boolean mLoadIconFailed = false;

    /* access modifiers changed from: package-private */
    public boolean setIcon(Bitmap bitmap) {
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CommandParams(CommandDetails commandDetails) {
        this.mCmdDet = commandDetails;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public AppInterface.CommandType getCommandType() {
        return AppInterface.CommandType.fromInt(this.mCmdDet.typeOfCommand);
    }

    public String toString() {
        return this.mCmdDet.toString();
    }
}
