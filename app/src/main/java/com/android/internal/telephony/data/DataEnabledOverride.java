package com.android.internal.telephony.data;

import android.telephony.TelephonyManager;
import android.telephony.data.ApnSetting;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.SubscriptionController;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

public class DataEnabledOverride {
    private static final OverrideRule OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL = new OverrideRule(255, 15);
    private static final OverrideRule OVERRIDE_RULE_ALWAYS_ALLOW_MMS = new OverrideRule(2, 0);
    private final Set<OverrideRule> mRules = new HashSet();

    private static class OverrideRule {
        private final int mApnType;
        private final OverrideConditions mRequiredConditions;

        OverrideRule(String str) {
            String[] split = str.trim().split("\\s*=\\s*");
            if (split.length != 2) {
                throw new IllegalArgumentException("Invalid data enabled override rule format: " + str);
            } else if (!TextUtils.isEmpty(split[0])) {
                int apnTypesBitmaskFromString = ApnSetting.getApnTypesBitmaskFromString(split[0]);
                this.mApnType = apnTypesBitmaskFromString;
                if (apnTypesBitmaskFromString != 0) {
                    this.mRequiredConditions = new OverrideConditions(split[1]);
                    return;
                }
                throw new IllegalArgumentException("Invalid APN type. Rule=" + str);
            } else {
                throw new IllegalArgumentException("APN type can't be empty");
            }
        }

        private OverrideRule(int i, int i2) {
            this.mApnType = i;
            this.mRequiredConditions = new OverrideConditions(i2);
        }

        /* access modifiers changed from: package-private */
        public boolean isSatisfiedByConditions(int i, int i2) {
            int i3 = this.mApnType;
            return (i3 == i || i3 == 255) && this.mRequiredConditions.allMet(i2);
        }

        public String toString() {
            return ApnSetting.getApnTypeString(this.mApnType) + "=" + this.mRequiredConditions;
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (obj == null || getClass() != obj.getClass()) {
                return false;
            }
            OverrideRule overrideRule = (OverrideRule) obj;
            if (this.mApnType != overrideRule.mApnType || !Objects.equals(this.mRequiredConditions, overrideRule.mRequiredConditions)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return Objects.hash(new Object[]{Integer.valueOf(this.mApnType), this.mRequiredConditions});
        }
    }

    static class OverrideConditions {
        static final int CONDITION_DEFAULT_DATA_ENABLED = 4;
        static final String CONDITION_DEFAULT_DATA_ENABLED_STRING = "DefaultDataOn";
        static final int CONDITION_DSDS_ENABLED = 8;
        static final String CONDITION_DSDS_ENABLED_STRING = "dsdsEnabled";
        static final int CONDITION_IN_VOICE_CALL = 2;
        static final int CONDITION_NON_DEFAULT = 1;
        static final String CONDITION_NON_DEFAULT_STRING = "nonDefault";
        static final int CONDITION_UNCONDITIONALLY = 0;
        static final String CONDITION_UNCONDITIONALLY_STRING = "unconditionally";
        static final String CONDITION_VOICE_CALL_STRING = "inVoiceCall";
        private static final Map<Integer, String> OVERRIDE_CONDITION_INT_MAP;
        private static final Map<String, Integer> OVERRIDE_CONDITION_STRING_MAP;
        private final int mConditions;

        @Retention(RetentionPolicy.SOURCE)
        public @interface Condition {
        }

        static {
            ArrayMap arrayMap = new ArrayMap();
            OVERRIDE_CONDITION_INT_MAP = arrayMap;
            ArrayMap arrayMap2 = new ArrayMap();
            OVERRIDE_CONDITION_STRING_MAP = arrayMap2;
            arrayMap.put(1, CONDITION_NON_DEFAULT_STRING);
            arrayMap.put(2, CONDITION_VOICE_CALL_STRING);
            arrayMap.put(4, CONDITION_DEFAULT_DATA_ENABLED_STRING);
            arrayMap.put(8, CONDITION_DSDS_ENABLED_STRING);
            arrayMap2.put(CONDITION_UNCONDITIONALLY_STRING, 0);
            arrayMap2.put(CONDITION_NON_DEFAULT_STRING, 1);
            arrayMap2.put(CONDITION_VOICE_CALL_STRING, 2);
            arrayMap2.put(CONDITION_DEFAULT_DATA_ENABLED_STRING, 4);
            arrayMap2.put(CONDITION_DSDS_ENABLED_STRING, 8);
        }

        OverrideConditions(String str) {
            this.mConditions = getBitmaskFromString(str);
        }

        OverrideConditions(int i) {
            this.mConditions = i;
        }

        private static String getStringFromBitmask(int i) {
            if (i == 0) {
                return CONDITION_UNCONDITIONALLY_STRING;
            }
            ArrayList arrayList = new ArrayList();
            for (Integer next : OVERRIDE_CONDITION_INT_MAP.keySet()) {
                if ((next.intValue() & i) == next.intValue()) {
                    arrayList.add(OVERRIDE_CONDITION_INT_MAP.get(next));
                }
            }
            return TextUtils.join("&", arrayList);
        }

        private static int getBitmaskFromString(String str) {
            if (!TextUtils.isEmpty(str)) {
                int i = 0;
                for (String str2 : str.trim().split("\\s*&\\s*")) {
                    if (!TextUtils.isEmpty(str2)) {
                        Map<String, Integer> map = OVERRIDE_CONDITION_STRING_MAP;
                        if (map.containsKey(str2)) {
                            i |= map.get(str2).intValue();
                        } else {
                            throw new IllegalArgumentException("Invalid conditions: " + str);
                        }
                    }
                }
                return i;
            }
            throw new IllegalArgumentException("Empty rule string");
        }

        /* access modifiers changed from: package-private */
        public boolean allMet(int i) {
            int i2 = this.mConditions;
            return (i & i2) == i2;
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (obj == null || getClass() != obj.getClass()) {
                return false;
            }
            if (this.mConditions == ((OverrideConditions) obj).mConditions) {
                return true;
            }
            return false;
        }

        public int hashCode() {
            return Objects.hash(new Object[]{Integer.valueOf(this.mConditions)});
        }

        public String toString() {
            return getStringFromBitmask(this.mConditions);
        }
    }

    public DataEnabledOverride(String str) {
        updateRules(str);
    }

    @VisibleForTesting
    public void updateRules(String str) {
        this.mRules.clear();
        for (String str2 : str.trim().split("\\s*,\\s*")) {
            if (!TextUtils.isEmpty(str2)) {
                this.mRules.add(new OverrideRule(str2));
            }
        }
    }

    public void setAlwaysAllowMms(boolean z) {
        if (z) {
            this.mRules.add(OVERRIDE_RULE_ALWAYS_ALLOW_MMS);
        } else {
            this.mRules.remove(OVERRIDE_RULE_ALWAYS_ALLOW_MMS);
        }
    }

    public void setDataAllowedInVoiceCall(boolean z) {
        if (z) {
            this.mRules.add(OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL);
        } else {
            this.mRules.remove(OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL);
        }
    }

    public boolean isDataAllowedInVoiceCall() {
        return this.mRules.contains(OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL);
    }

    public boolean isMmsAlwaysAllowed() {
        return this.mRules.contains(OVERRIDE_RULE_ALWAYS_ALLOW_MMS);
    }

    private boolean canSatisfyAnyRule(int i, int i2) {
        for (OverrideRule isSatisfiedByConditions : this.mRules) {
            if (isSatisfiedByConditions.isSatisfiedByConditions(i, i2)) {
                return true;
            }
        }
        return false;
    }

    private int getCurrentConditions(Phone phone) {
        int i = 0;
        if (phone == null) {
            return 0;
        }
        if (phone.getState() != PhoneConstants.State.IDLE) {
            i = 2;
        }
        int defaultDataSubId = SubscriptionController.getInstance().getDefaultDataSubId();
        if (phone.getSubId() != defaultDataSubId) {
            i |= 1;
        }
        if (defaultDataSubId != -1) {
            try {
                Phone phone2 = PhoneFactory.getPhone(SubscriptionController.getInstance().getPhoneId(defaultDataSubId));
                if (phone2 != null && phone2.isUserDataEnabled()) {
                    i |= 4;
                }
            } catch (IllegalStateException e) {
                Log.d("DataEnabledOverride", e.getMessage());
            }
        }
        return TelephonyManager.from(phone.getContext()).isMultiSimEnabled() ? i | 8 : i;
    }

    public boolean shouldOverrideDataEnabledSettings(Phone phone, int i) {
        return canSatisfyAnyRule(i, getCurrentConditions(phone));
    }

    public String getRules() {
        ArrayList arrayList = new ArrayList();
        for (OverrideRule overrideRule : this.mRules) {
            arrayList.add(overrideRule.toString());
        }
        return TextUtils.join(",", arrayList);
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        return this.mRules.equals(((DataEnabledOverride) obj).mRules);
    }

    public int hashCode() {
        return Objects.hash(new Object[]{this.mRules});
    }

    public String toString() {
        return "DataEnabledOverride: [rules=\"" + getRules() + "\"]";
    }
}
