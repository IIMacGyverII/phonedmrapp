package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.SystemProperties;
import com.android.telephony.Rlog;

public class TelephonyCapabilities {
    private static final String LOG_TAG = "TelephonyCapabilities";

    public static boolean canDistinguishDialingAndConnected(int i) {
        return i == 1;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static boolean supportsAdn(int i) {
        return i == 1;
    }

    private TelephonyCapabilities() {
    }

    public static boolean supportsEcm(Phone phone) {
        if (SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
            try {
                return ((Boolean) Class.forName("com.mediatek.internal.telephony.MtkTelephonyCapabilities").getDeclaredMethod("supportsEcm", new Class[]{Phone.class}).invoke((Object) null, new Object[]{phone})).booleanValue();
            } catch (Exception e) {
                e.printStackTrace();
                Rlog.e(LOG_TAG, "supportsEcm invoke redirect fails. Use AOSP instead.");
            }
        }
        Rlog.d(LOG_TAG, "supportsEcm: Phone type = " + phone.getPhoneType() + " Ims Phone = " + phone.getImsPhone());
        if (phone.getPhoneType() == 2 || phone.getImsPhone() != null) {
            return true;
        }
        return false;
    }

    public static boolean supportsOtasp(Phone phone) {
        return phone.getPhoneType() == 2;
    }

    public static boolean supportsVoiceMessageCount(Phone phone) {
        return phone.getVoiceMessageCount() != -1;
    }

    public static boolean supportsNetworkSelection(Phone phone) {
        return phone.getPhoneType() == 1;
    }

    public static int getDeviceIdLabel(Phone phone) {
        if (phone.getPhoneType() == 1) {
            return 17040489;
        }
        if (phone.getPhoneType() == 2) {
            return 17040789;
        }
        Rlog.w(LOG_TAG, "getDeviceIdLabel: no known label for phone " + phone.getPhoneName());
        return 0;
    }

    public static boolean supportsConferenceCallManagement(Phone phone) {
        if (phone.getPhoneType() == 1 || phone.getPhoneType() == 3) {
            return true;
        }
        return false;
    }

    public static boolean supportsHoldAndUnhold(Phone phone) {
        if (phone.getPhoneType() == 1 || phone.getPhoneType() == 3 || phone.getPhoneType() == 5) {
            return true;
        }
        return false;
    }

    public static boolean supportsAnswerAndHold(Phone phone) {
        if (phone.getPhoneType() == 1 || phone.getPhoneType() == 3) {
            return true;
        }
        return false;
    }
}
