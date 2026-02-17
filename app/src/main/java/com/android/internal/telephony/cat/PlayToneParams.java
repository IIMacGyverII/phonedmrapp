package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.graphics.Bitmap;

public class PlayToneParams extends CommandParams {
    ToneSettings mSettings;
    TextMessage mTextMsg;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public PlayToneParams(CommandDetails commandDetails, TextMessage textMessage, Tone tone, Duration duration, boolean z) {
        super(commandDetails);
        this.mTextMsg = textMessage;
        this.mSettings = new ToneSettings(duration, tone, z);
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
