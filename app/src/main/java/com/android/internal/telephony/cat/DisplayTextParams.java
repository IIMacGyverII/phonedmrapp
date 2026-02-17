package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.graphics.Bitmap;

public class DisplayTextParams extends CommandParams {
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public TextMessage mTextMsg;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public DisplayTextParams(CommandDetails commandDetails, TextMessage textMessage) {
        super(commandDetails);
        this.mTextMsg = textMessage;
    }

    /* access modifiers changed from: package-private */
    public boolean setIcon(Bitmap bitmap) {
        TextMessage textMessage;
        if (bitmap == null || (textMessage = this.mTextMsg) == null) {
            return false;
        }
        textMessage.icon = bitmap;
        return true;
    }

    public String toString() {
        return "TextMessage=" + this.mTextMsg + " " + super.toString();
    }
}
