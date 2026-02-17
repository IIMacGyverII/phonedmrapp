package com.android.internal.telephony.cat;

import android.graphics.Bitmap;

public class CallSetupParams extends CommandParams {
    public TextMessage mCallMsg;
    public TextMessage mConfirmMsg;

    public CallSetupParams(CommandDetails commandDetails, TextMessage textMessage, TextMessage textMessage2) {
        super(commandDetails);
        this.mConfirmMsg = textMessage;
        this.mCallMsg = textMessage2;
    }

    /* access modifiers changed from: package-private */
    public boolean setIcon(Bitmap bitmap) {
        if (bitmap == null) {
            return false;
        }
        TextMessage textMessage = this.mConfirmMsg;
        if (textMessage == null || textMessage.icon != null) {
            TextMessage textMessage2 = this.mCallMsg;
            if (textMessage2 == null || textMessage2.icon != null) {
                return false;
            }
            textMessage2.icon = bitmap;
            return true;
        }
        textMessage.icon = bitmap;
        return true;
    }
}
