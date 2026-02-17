package com.android.internal.telephony.dataconnection;

import android.os.PersistableBundle;
import android.telephony.CarrierConfigManager;
import android.telephony.Rlog;
import android.telephony.data.ApnSetting;
import android.util.ArrayMap;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class ApnConfigTypeRepository {
    private static final String TAG = "ApnConfigTypeRepository";
    private final Map<Integer, ApnConfigType> mConfigTypeMap = new HashMap();

    public ApnConfigTypeRepository(PersistableBundle persistableBundle) {
        setup(persistableBundle);
    }

    public Collection<ApnConfigType> getTypes() {
        return this.mConfigTypeMap.values();
    }

    public ApnConfigType getByType(int i) {
        return this.mConfigTypeMap.get(Integer.valueOf(i));
    }

    private void setup(PersistableBundle persistableBundle) {
        addApns(getCarrierApnTypeMap(CarrierConfigManager.getDefaultConfig()));
        addApns(getCarrierApnTypeMap(persistableBundle));
    }

    private void addApns(Map<Integer, Integer> map) {
        add(17, map);
        add(2, map);
        add(4, map);
        add(8, map);
        add(16, map);
        add(32, map);
        add(64, map);
        add(128, map);
        add(256, map);
        add(512, map);
        add(1024, map);
        add(2048, map);
        add(16384, map);
    }

    private Map<Integer, Integer> getCarrierApnTypeMap(PersistableBundle persistableBundle) {
        if (persistableBundle == null) {
            Rlog.w(TAG, "carrier config is null");
            return new ArrayMap();
        }
        String[] stringArray = persistableBundle.getStringArray("apn_priority_string_array");
        ArrayMap arrayMap = new ArrayMap();
        if (stringArray != null) {
            for (String str : stringArray) {
                try {
                    String[] split = str.split(":");
                    if (split.length != 2) {
                        Rlog.e(TAG, "Apn type entry must have exactly one ':'");
                    } else if (split[0].contains(",")) {
                        Rlog.e(TAG, "Invalid apn type name, entry: " + str);
                    } else {
                        int apnTypesBitmaskFromString = ApnSetting.getApnTypesBitmaskFromString(split[0]);
                        if (apnTypesBitmaskFromString > 0) {
                            arrayMap.put(Integer.valueOf(apnTypesBitmaskFromString), Integer.valueOf(Integer.parseInt(split[1])));
                        } else {
                            Rlog.e(TAG, "Invalid apn type name, entry: " + str);
                        }
                    }
                } catch (Exception e) {
                    Rlog.e(TAG, "Exception on apn type entry: " + str + "\n", e);
                }
            }
        }
        return arrayMap;
    }

    private void add(int i, Map<Integer, Integer> map) {
        if (map.containsKey(Integer.valueOf(i))) {
            this.mConfigTypeMap.put(Integer.valueOf(i), new ApnConfigType(i, map.get(Integer.valueOf(i)).intValue()));
        }
    }
}
