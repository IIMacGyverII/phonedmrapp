package com.android.internal.telephony.cat;

import android.graphics.Bitmap;

public class LaunchBrowserParams extends CommandParams {
    public TextMessage mConfirmMsg;
    public LaunchBrowserMode mMode;
    public String mUrl;

    public LaunchBrowserParams(CommandDetails commandDetails, TextMessage textMessage, String str, LaunchBrowserMode launchBrowserMode) {
        super(commandDetails);
        this.mConfirmMsg = textMessage;
        this.mMode = launchBrowserMode;
        this.mUrl = str;
    }

    /* access modifiers changed from: package-private */
    public boolean setIcon(Bitmap bitmap) {
        TextMessage textMessage;
        if (bitmap == null || (textMessage = this.mConfirmMsg) == null) {
            return false;
        }
        textMessage.icon = bitmap;
        return true;
    }

    public String toString() {
        return "TextMessage=" + this.mConfirmMsg + " " + super.toString();
    }
}
