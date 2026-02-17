package com.android.internal.telephony.uicc;

import com.android.internal.telephony.CommandsInterface;
import com.android.telephony.Rlog;

public class IsimFileHandler extends IccFileHandler implements IccConstants {
    static final String LOG_TAG = "IsimFH";

    public IsimFileHandler(UiccCardApplication uiccCardApplication, String str, CommandsInterface commandsInterface) {
        super(uiccCardApplication, str, commandsInterface);
    }

    /* access modifiers changed from: protected */
    public String getEFPath(int i) {
        if (i == 28423 || i == 28425) {
            return "3F007FFF";
        }
        switch (i) {
            case IccConstants.EF_IMPI:
            case IccConstants.EF_DOMAIN:
            case IccConstants.EF_IMPU:
                return "3F007FFF";
            default:
                return getCommonIccEFPath(i);
        }
    }

    /* access modifiers changed from: protected */
    public void logd(String str) {
        Rlog.d(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }
}
