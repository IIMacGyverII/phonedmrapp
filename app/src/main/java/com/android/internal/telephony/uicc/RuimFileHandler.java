package com.android.internal.telephony.uicc;

import android.os.Message;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.util.DnsPacket;
import com.android.telephony.Rlog;

public class RuimFileHandler extends IccFileHandler {
    static final String LOG_TAG = "RuimFH";

    public RuimFileHandler(UiccCardApplication uiccCardApplication, String str, CommandsInterface commandsInterface) {
        super(uiccCardApplication, str, commandsInterface);
    }

    public void loadEFImgTransparent(int i, int i2, int i3, int i4, Message message) {
        Message obtainMessage = obtainMessage(10, i, 0, message);
        this.mCi.iccIOForApp(DnsPacket.DnsRecord.NAME_COMPRESSION, i, getEFPath(20256), 0, 0, 10, (String) null, (String) null, this.mAid, obtainMessage);
    }

    /* access modifiers changed from: protected */
    public String getEFPath(int i) {
        if (i == 20256 || i == 20257) {
            return "3F007F105F3C";
        }
        return (i == 28450 || i == 28456 || i == 28464 || i == 28466 || i == 28474 || i == 28476 || i == 28481 || i == 28484 || i == 28493 || i == 28506) ? "3F007F25" : getCommonIccEFPath(i);
    }

    /* access modifiers changed from: protected */
    public void logd(String str) {
        Rlog.d(LOG_TAG, "[RuimFileHandler] " + str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(LOG_TAG, "[RuimFileHandler] " + str);
    }
}
