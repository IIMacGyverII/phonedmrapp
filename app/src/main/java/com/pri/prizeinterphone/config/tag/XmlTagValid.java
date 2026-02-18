package com.pri.prizeinterphone.config.tag;

import android.text.TextUtils;
import android.util.Log;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.config.data.InValidException;
import com.pri.prizeinterphone.config.data.InsertChannel;
/* loaded from: classes4.dex */
public class XmlTagValid {
    private static final String TAG = "XmlTagValid";

    public static void checkInvalid(String str, String str2) throws InValidException, NumberFormatException {
        str.hashCode();
        char c = 65535;
        switch (str.hashCode()) {
            case -1085803359:
                if (str.equals(XmlTagConst.TAG_SLOT_MODE)) {
                    c = 0;
                    break;
                }
                break;
            case -658786823:
                if (str.equals(XmlTagConst.TAG_ENCRYPT_SWITCH)) {
                    c = 1;
                    break;
                }
                break;
            case 3355:
                if (str.equals(XmlTagConst.TAG_CHANNELS_ID)) {
                    c = 2;
                    break;
                }
                break;
            case 3016245:
                if (str.equals(XmlTagConst.TAG_BAND)) {
                    c = 3;
                    break;
                }
                break;
            case 3373707:
                if (str.equals(XmlTagConst.TAG_CHANNEL_NAME)) {
                    c = 4;
                    break;
                }
                break;
            case 106858757:
                if (str.equals(XmlTagConst.TAG_POWER)) {
                    c = 5;
                    break;
                }
                break;
            case 275108541:
                if (str.equals(XmlTagConst.TAG_CHANNEL_TYPE)) {
                    c = 6;
                    break;
                }
                break;
            case 290020696:
                if (str.equals(XmlTagConst.TAG_SEND_SUB_AUDIO_TYPE)) {
                    c = 7;
                    break;
                }
                break;
            case 1080445622:
                if (str.equals(XmlTagConst.TAG_RECV_SUB_AUDIO_TYPE)) {
                    c = '\b';
                    break;
                }
                break;
            case 1082328840:
                if (str.equals(XmlTagConst.TAG_RECFREQ)) {
                    c = '\t';
                    break;
                }
                break;
            case 1247994368:
                if (str.equals(XmlTagConst.TAG_SENDFREQ)) {
                    c = '\n';
                    break;
                }
                break;
            case 1374823361:
                if (str.equals(XmlTagConst.TAG_SQUELCH_LEVEL)) {
                    c = 11;
                    break;
                }
                break;
            case 1981379536:
                if (str.equals(XmlTagConst.TAG_COLOR_CODE)) {
                    c = '\f';
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
                int parseInt = Integer.parseInt(str2);
                Integer.parseInt(str2);
                if (parseInt == 0 || parseInt == 1 || parseInt == 2) {
                    return;
                }
                throw new InValidException(str.toLowerCase() + " invalid=" + parseInt + "(num != 0 && num != 1 && num != 2)");
            case 1:
                int parseInt2 = Integer.parseInt(str2);
                Integer.parseInt(str2);
                if (parseInt2 == 1 || parseInt2 == 255) {
                    return;
                }
                throw new InValidException(str.toLowerCase() + " invalid=" + parseInt2 + "(num != 1 && num != 255)");
            case 2:
                Integer.parseInt(str2);
                return;
            case 3:
            case 5:
            case 6:
                int parseInt3 = Integer.parseInt(str2);
                Integer.parseInt(str2);
                if (parseInt3 == 0 || parseInt3 == 1) {
                    return;
                }
                throw new InValidException(str.toLowerCase() + " invalid=" + parseInt3 + "(num != 0 && num != 1)");
            case 4:
                if (TextUtils.isEmpty(str2)) {
                    throw new InValidException(str.toLowerCase() + " invalid=null(name is null)");
                }
                return;
            case 7:
                int parseInt4 = Integer.parseInt(str2);
                if (parseInt4 < 0 || parseInt4 > 3) {
                    throw new InValidException(str.toLowerCase() + " invalid=" + parseInt4 + "(num < 0 || num > 3) ");
                }
                return;
            case '\b':
                int parseInt5 = Integer.parseInt(str2);
                if (parseInt5 < 0 || parseInt5 > 3) {
                    throw new InValidException(str.toLowerCase() + " invalid=" + parseInt5 + "(num < 0 || num > 3) ");
                }
                return;
            case '\t':
            case '\n':
                long parseLong = Long.parseLong(str2);
                if (parseLong < 400000000 || parseLong > 480000000) {
                    throw new InValidException(str.toLowerCase() + " invalid=" + parseLong + "(num < 400000000 || num > 480000000)");
                }
                return;
            case 11:
                int parseInt6 = Integer.parseInt(str2);
                Integer.parseInt(str2);
                if (parseInt6 < 0 || parseInt6 > 10) {
                    throw new InValidException(str.toLowerCase() + " invalid=" + parseInt6 + "(num < 0 || num > 10)");
                }
                return;
            case '\f':
                int parseInt7 = Integer.parseInt(str2);
                Integer.parseInt(str2);
                if (parseInt7 < 0 || parseInt7 > 3) {
                    throw new InValidException(str.toLowerCase() + " invalid=" + parseInt7 + "(num < 0 || num > 3)");
                }
                return;
            default:
                return;
        }
    }

    public static void checkAnalogTypeInvalid(String str, String str2, String str3) throws InValidException, NumberFormatException {
        Log.d(TAG, "checkAnalogTypeInvalid: type " + str);
        Log.d(TAG, "checkAnalogTypeInvalid: str " + str3);
        str.hashCode();
        char c = 65535;
        switch (str.hashCode()) {
            case 49:
                if (str.equals("1")) {
                    c = 0;
                    break;
                }
                break;
            case 50:
                if (str.equals(Util.DMR_UPDATE_STATUS_UPDATING)) {
                    c = 1;
                    break;
                }
                break;
            case 51:
                if (str.equals(Util.DMR_UPDATE_STATUS_ERROR)) {
                    c = 2;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
                int parseInt = Integer.parseInt(str3);
                if (parseInt < 0 || parseInt > 50) {
                    throw new InValidException(str2.toLowerCase() + " invalid=" + parseInt + "(num < 1 || num > 16776415) ");
                }
                Log.d(TAG, "+++ rxSubCode1 +++: " + parseInt);
                return;
            case 1:
            case 2:
                int parseInt2 = Integer.parseInt(str3);
                if (parseInt2 < 0 || parseInt2 > 82) {
                    throw new InValidException(str2.toLowerCase() + " invalid=" + parseInt2 + "(num < 1 || num > 16776415) ");
                }
                Log.d(TAG, "+++ rxSubCode3 +++: " + parseInt2);
                return;
            default:
                return;
        }
    }

    public static void checkDigitalTypeInvalid(String str, String str2, String str3) throws InValidException, NumberFormatException {
        Log.d(TAG, "checkTypeInvalid: type " + str);
        Log.d(TAG, "checkTypeInvalid: str " + str3);
        str.hashCode();
        if (str.equals("1")) {
            int parseInt = Integer.parseInt(str3);
            if (parseInt < 1 || parseInt > 16776415) {
                throw new InValidException(str2.toLowerCase() + " invalid=" + parseInt + "(num < 1 || num > 16776415) ");
            }
            Log.d(TAG, "+++ checkTypeInvalid +++: " + parseInt);
        }
    }

    public static boolean checkMustNotEmpty(InsertChannel insertChannel) {
        return TextUtils.isEmpty(insertChannel.getName()) || TextUtils.isEmpty(insertChannel.getSendfreq()) || TextUtils.isEmpty(insertChannel.getRecfreq()) || TextUtils.isEmpty(insertChannel.getChanneltype());
    }
}
