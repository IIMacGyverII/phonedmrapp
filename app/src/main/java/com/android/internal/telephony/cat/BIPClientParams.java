package com.android.internal.telephony.cat;

import android.graphics.Bitmap;

public class BIPClientParams extends CommandParams {
    public boolean mHasAlphaId;
    public TextMessage mTextMsg;

    BIPClientParams(CommandDetails commandDetails, TextMessage textMessage, boolean z) {
        super(commandDetails);
        this.mTextMsg = textMessage;
        this.mHasAlphaId = z;
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
}
