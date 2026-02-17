package com.android.internal.telephony.metrics;

import android.os.Build;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.TelephonyStatsLog;
import com.android.telephony.Rlog;

public class ModemRestartStats {
    private static final int MAX_BASEBAND_LEN = 100;
    private static final int MAX_REASON_LEN = 100;
    private static final String TAG = "ModemRestartStats";

    private static String nullToEmpty(String str) {
        return str != null ? str : "";
    }

    private ModemRestartStats() {
    }

    public static void onModemRestart(String str) {
        String truncateString = truncateString(str, 100);
        String truncateString2 = truncateString(Build.getRadioVersion(), 100);
        int carrierId = getCarrierId();
        String str2 = TAG;
        Rlog.d(str2, "Modem restart (carrier=" + carrierId + "): " + truncateString);
        TelephonyStatsLog.write(312, truncateString2, truncateString, carrierId);
    }

    private static String truncateString(String str, int i) {
        String nullToEmpty = nullToEmpty(str);
        return nullToEmpty.length() > i ? nullToEmpty.substring(0, i) : nullToEmpty;
    }

    private static int getCarrierId() {
        int i = -1;
        try {
            Phone[] phones = PhoneFactory.getPhones();
            int length = phones.length;
            int i2 = 0;
            int i3 = -1;
            while (i2 < length) {
                try {
                    i3 = phones[i2].getCarrierId();
                    if (i3 != -1) {
                        return i3;
                    }
                    i2++;
                } catch (IllegalStateException unused) {
                    i = i3;
                    return i;
                }
            }
            return i3;
        } catch (IllegalStateException unused2) {
            return i;
        }
    }
}
