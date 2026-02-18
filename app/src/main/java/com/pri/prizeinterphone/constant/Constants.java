package com.pri.prizeinterphone.constant;

import android.content.Context;
import android.text.TextUtils;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.pri.prizeinterphone.Util.Clog;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
/* loaded from: classes4.dex */
public class Constants {
    public static final int CHANNEL_FRQC_BAND_U_LIMIT_MAX = 480000000;
    public static final int CHANNEL_FRQC_BAND_U_LIMIT_MIN = 400000000;
    public static final int CHANNEL_FRQC_BAND_V_LIMIT_MAX = 174000000;
    public static final int CHANNEL_FRQC_BAND_V_LIMIT_MIN = 136000000;
    public static LinkedHashMap<String, String> DEF_CHANNEL_AREAS = new LinkedHashMap<>();
    public static final String DEF_MODULE_VERSION = "DMR003.UV4T.V022";
    public static final String KEY_CHANNEL_AREA_AUS = "channel_area_aus";
    public static final String KEY_CHANNEL_AREA_CHINA = "channel_area_cn";
    public static final String KEY_CHANNEL_AREA_CHINA_TW = "channel_area_tw";
    public static final String KEY_CHANNEL_AREA_DEFAULT = "channel_area_default";
    public static final String KEY_CHANNEL_AREA_DEFAULT_UHF = "channel_area_default_uhf";
    public static final String KEY_CHANNEL_AREA_DEFAULT_VHF = "channel_area_default_vhf";
    public static final String KEY_CHANNEL_AREA_EU = "channel_area_eu";
    public static final String KEY_CHANNEL_AREA_IRAN = "channel_area_iran";
    public static final String KEY_CHANNEL_AREA_JAPAN = "channel_area_japan";
    public static final String KEY_CHANNEL_AREA_KOREA = "channel_area_ko";
    public static final String KEY_CHANNEL_AREA_MALAYSIA = "channel_area_malaysia";
    public static final String KEY_CHANNEL_AREA_NORWAY = "channel_area_norway";
    public static final String KEY_CHANNEL_AREA_PREFIX = "channel_area_";
    public static final String KEY_CHANNEL_AREA_RUS = "channel_area_rus";
    public static final String KEY_CHANNEL_AREA_SOUTH_AF = "channel_area_south_af";
    public static final String KEY_CHANNEL_AREA_USA = "channel_area_usa";
    public static final String KEY_DEF_AREA;
    public static final String KEY_EXTRA_AREA_CHANNEL = "extra_channel_area_";
    public static final String MODULE_FRQC_BAND_U = "U";
    public static final String MODULE_FRQC_BAND_UV = "UV";
    public static final String MODULE_FRQC_BAND_V = "V";
    private static final String TAG = "Constants";

    static {
        KEY_DEF_AREA = DmrManager.getInstance().isSupportUVFrequencyBand() ? KEY_CHANNEL_AREA_DEFAULT_UHF : KEY_CHANNEL_AREA_DEFAULT;
    }

    public static String randExtraChannelAreaName() {
        String format = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(new Date());
        return KEY_EXTRA_AREA_CHANNEL + format;
    }

    public static void initDefChannelAreas() {
        Clog.d(TAG, "initDefChannelAreas");
        DEF_CHANNEL_AREAS.clear();
        if (DmrManager.getInstance().isSupportUVFrequencyBand()) {
            DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_DEFAULT_UHF, KEY_CHANNEL_AREA_DEFAULT_UHF);
            DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_DEFAULT_VHF, KEY_CHANNEL_AREA_DEFAULT_VHF);
        } else {
            DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_DEFAULT, KEY_CHANNEL_AREA_DEFAULT);
        }
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_CHINA, KEY_CHANNEL_AREA_CHINA);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_CHINA_TW, KEY_CHANNEL_AREA_CHINA_TW);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_EU, KEY_CHANNEL_AREA_EU);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_USA, KEY_CHANNEL_AREA_USA);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_AUS, KEY_CHANNEL_AREA_AUS);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_RUS, KEY_CHANNEL_AREA_RUS);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_IRAN, KEY_CHANNEL_AREA_IRAN);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_KOREA, KEY_CHANNEL_AREA_KOREA);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_MALAYSIA, KEY_CHANNEL_AREA_MALAYSIA);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_JAPAN, KEY_CHANNEL_AREA_JAPAN);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_NORWAY, KEY_CHANNEL_AREA_NORWAY);
        DEF_CHANNEL_AREAS.put(KEY_CHANNEL_AREA_SOUTH_AF, KEY_CHANNEL_AREA_SOUTH_AF);
    }

    public static LinkedHashMap<String, String> getSavedChannelAreas(Context context) {
        Gson gson = new Gson();
        String stringData = PersonSharePrefData.getStringData(context, PersonSharePrefData.PREF_PERSON_DEVICE_AREA_LIST, "");
        if (TextUtils.isEmpty(stringData)) {
            PersonSharePrefData.putStringData(context, PersonSharePrefData.PREF_PERSON_DEVICE_AREA_LIST, gson.toJson(DEF_CHANNEL_AREAS));
            return DEF_CHANNEL_AREAS;
        }
        return (LinkedHashMap) gson.fromJson(stringData, new TypeToken<LinkedHashMap<String, String>>() { // from class: com.pri.prizeinterphone.constant.Constants.1
        }.getType());
    }

    public static boolean saveChannelAreas(Context context, LinkedHashMap<String, String> linkedHashMap) {
        if (linkedHashMap == null || linkedHashMap.isEmpty()) {
            Clog.d(TAG, "saveChannelAreas,data is null or empty");
            return false;
        }
        String json = new Gson().toJson(linkedHashMap);
        Clog.d(TAG, "saveChannelAreas,savedStr=" + json);
        PersonSharePrefData.putStringData(context, PersonSharePrefData.PREF_PERSON_DEVICE_AREA_LIST, json);
        return true;
    }

    public static String getChannelAreaName(Context context, LinkedHashMap<String, String> linkedHashMap, String str) {
        if (linkedHashMap == null || linkedHashMap.isEmpty()) {
            return "";
        }
        for (Map.Entry<String, String> entry : linkedHashMap.entrySet()) {
            if (entry.getKey().equals(str)) {
                String value = entry.getValue();
                if (!TextUtils.isEmpty(value)) {
                    if (value.startsWith(KEY_CHANNEL_AREA_PREFIX)) {
                        return context.getString(context.getResources().getIdentifier(value, "string", "com.pri.prizeinterphone"));
                    }
                    str.startsWith(KEY_EXTRA_AREA_CHANNEL);
                    return value;
                }
            }
        }
        return "";
    }

    public static String getChannelAreaName(Context context, String str) {
        return getChannelAreaName(context, getSavedChannelAreas(context), str);
    }

    public static String getChannelAreaName(Context context) {
        return getChannelAreaName(context, getSelectedChannelArea(context));
    }

    public static String getSelectedChannelArea(Context context) {
        return PersonSharePrefData.getStringData(context, "pref_person_channel_area_selected_index", KEY_DEF_AREA);
    }

    public static void saveSelectedChannelArea(Context context, String str) {
        PersonSharePrefData.putStringData(context, "pref_person_channel_area_selected_index", str);
    }
}
