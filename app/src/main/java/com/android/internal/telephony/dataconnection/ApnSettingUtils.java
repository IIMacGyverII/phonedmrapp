package com.android.internal.telephony.dataconnection;

import android.os.PersistableBundle;
import android.telephony.CarrierConfigManager;
import android.telephony.data.ApnSetting;
import com.android.internal.telephony.Phone;
import com.android.telephony.Rlog;
import java.util.Arrays;
import java.util.HashSet;

public class ApnSettingUtils {
    private static final boolean DBG = false;
    static final String LOG_TAG = "ApnSetting";

    public static boolean isMeteredApnType(int i, Phone phone) {
        if (phone == null) {
            return true;
        }
        boolean dataRoaming = phone.getServiceState().getDataRoaming();
        int subId = phone.getSubId();
        String str = dataRoaming ? "carrier_metered_roaming_apn_types_strings" : "carrier_metered_apn_types_strings";
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager == null) {
            Rlog.e(LOG_TAG, "Carrier config service is not available");
            return true;
        }
        PersistableBundle configForSubId = carrierConfigManager.getConfigForSubId(subId);
        if (configForSubId == null) {
            Rlog.e(LOG_TAG, "Can't get the config. subId = " + subId);
            return true;
        }
        String[] stringArray = configForSubId.getStringArray(str);
        if (stringArray == null) {
            Rlog.e(LOG_TAG, str + " is not available. subId = " + subId);
            return true;
        }
        HashSet hashSet = new HashSet(Arrays.asList(stringArray));
        if (hashSet.contains(ApnSetting.getApnTypeString(i))) {
            return true;
        }
        if (i != 255 || hashSet.size() <= 0) {
            return false;
        }
        return true;
    }

    public static boolean isMetered(ApnSetting apnSetting, Phone phone) {
        if (phone == null || apnSetting == null) {
            return true;
        }
        for (Integer intValue : apnSetting.getApnTypes()) {
            if (isMeteredApnType(intValue.intValue(), phone)) {
                return true;
            }
        }
        return false;
    }
}
