package com.pri.prizeinterphone.Util;

import android.app.ActivityManager;
import android.text.TextUtils;
import android.util.Log;
import com.mediatek.common.prizeoption.NvramUtils;
import com.pri.prizeinterphone.R;

public class Util {
    public static final String DMR_UPDATE_STATUS_ERROR = "3";
    public static final String DMR_UPDATE_STATUS_IDLE = "1";
    public static final String DMR_UPDATE_STATUS_UPDATING = "2";
    public static final int[] FRAGMENT_TALKBACK_NUM_RES = {R.drawable.interphone_talkback_num_0, R.drawable.interphone_talkback_num_1, R.drawable.interphone_talkback_num_2, R.drawable.interphone_talkback_num_3, R.drawable.interphone_talkback_num_4, R.drawable.interphone_talkback_num_5, R.drawable.interphone_talkback_num_6, R.drawable.interphone_talkback_num_7, R.drawable.interphone_talkback_num_8, R.drawable.interphone_talkback_num_9};
    private static final int NARAM_INDEX_FOR_DMR_UPDATE_STATUS = 324;
    private static final int NARAM_INDEX_LENGTH_FOR_DMR_UPDATE_STATUS = 1;
    private static final String TAG = "InterphoneUtil";
    public static final int TAP_VIEW_CHANNEL = 1;
    public static final int TAP_VIEW_CONTACTS = 2;
    public static final int TAP_VIEW_LOCAL = 4;
    public static final int TAP_VIEW_MESSAGE = 3;
    public static final int TAP_VIEW_TALKBACK = 0;

    public static String bytesToHex(byte[] bArr) {
        StringBuilder sb = new StringBuilder();
        int length = bArr.length;
        for (int i = 0; i < length; i++) {
            sb.append(String.format("%02X", new Object[]{Byte.valueOf(bArr[i])}));
        }
        return sb.toString();
    }

    public static String getDMRUpdateStatusFromNvram() {
        try {
            String readUserNvramInfo = NvramUtils.readUserNvramInfo(NARAM_INDEX_FOR_DMR_UPDATE_STATUS, 1);
            String trim = readUserNvramInfo.substring(convertNvChars(readUserNvramInfo).length() - 1).trim();
            Log.d(TAG, "getDMRUpdateStatusFromNvram,status=" + trim + "(" + dMRUpdateStatus2Str(trim) + ")");
            if (TextUtils.isEmpty(trim)) {
                return "1";
            }
            if ("1".equals(trim) || DMR_UPDATE_STATUS_UPDATING.equals(trim) || DMR_UPDATE_STATUS_ERROR.equals(trim)) {
                return trim;
            }
            return "1";
        } catch (Exception e) {
            Log.d(TAG, "getDMRUpdateStatusFromNvram,error", e);
            return "1";
        }
    }

    public static boolean setDMRUpdateStatusToNvram(String str) {
        if (str.length() != 1) {
            Log.d(TAG, "setDMRUpdateStatusToNvram,status.length() must be 1");
            return false;
        }
        boolean writeUserNvramInfo = NvramUtils.writeUserNvramInfo(NARAM_INDEX_FOR_DMR_UPDATE_STATUS, 1, str);
        getDMRUpdateStatusFromNvram();
        return writeUserNvramInfo;
    }

    private static String convertNvChars(String str) {
        if (TextUtils.isEmpty(str)) {
            return " ";
        }
        int length = str.length();
        for (int i = 0; i < length; i++) {
            char charAt = str.charAt(i);
            if (charAt <= 8 || ((charAt >= 11 && charAt <= 12) || (charAt >= 14 && charAt <= 31))) {
                str = str.replace(charAt, ' ');
            }
        }
        return str;
    }

    public static boolean isDmrUpdateIdle() {
        return "1".equals(getDMRUpdateStatusFromNvram());
    }

    public static boolean isDmrUpdateError() {
        return DMR_UPDATE_STATUS_ERROR.equals(getDMRUpdateStatusFromNvram());
    }

    public static boolean isDmrUpdating() {
        return DMR_UPDATE_STATUS_UPDATING.equals(getDMRUpdateStatusFromNvram());
    }

    public static String dMRUpdateStatus2Str(String str) {
        str.hashCode();
        if (!str.equals("1")) {
            return !str.equals(DMR_UPDATE_STATUS_UPDATING) ? "DMR_UPDATE_STATUS_UNKNOWN" : "DMR_UPDATE_STATUS_UPDATING";
        }
        return "DMR_UPDATE_STATUS_IDLE";
    }

    public static boolean isMonkeyRunning() {
        return ActivityManager.isUserAMonkey();
    }
}
