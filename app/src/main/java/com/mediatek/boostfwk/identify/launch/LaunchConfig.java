package com.mediatek.boostfwk.identify.launch;

import com.pri.prizeinterphone.Util.Util;
import java.util.HashMap;
import java.util.Map;

public class LaunchConfig {
    public static final long ACTIVITY_CONSIDERED_IDLE = 1000;
    public static final long ACTIVITY_CONSIDERED_RESUME = 2000;
    public static final int COUNT_DEFAULT = 1;
    public static Map<String, String> SPECIAL_MAP = new HashMap<String, String>() {
        {
            put("com.tencent.mm", Util.DMR_UPDATE_STATUS_ERROR);
        }
    };
}
