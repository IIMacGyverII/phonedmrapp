package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.graphics.Bitmap;

public class GetInputParams extends CommandParams {
    Input mInput;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GetInputParams(CommandDetails commandDetails, Input input) {
        super(commandDetails);
        this.mInput = input;
    }

    /* access modifiers changed from: package-private */
    public boolean setIcon(Bitmap bitmap) {
        Input input;
        if (bitmap == null || (input = this.mInput) == null) {
            return true;
        }
        input.icon = bitmap;
        return true;
    }
}
