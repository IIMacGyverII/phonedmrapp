package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.PersistableBundle;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.telephony.CarrierConfigManager;
import android.telephony.data.ApnSetting;
import android.text.TextUtils;
import android.util.Pair;
import com.android.internal.telephony.dataconnection.DataThrottler;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Random;

public class RetryManager {
    public static final boolean DBG = true;
    private static final long DEFAULT_APN_RETRY_AFTER_DISCONNECT_DELAY = 10000;
    private static final String DEFAULT_DATA_RETRY_CONFIG = "max_retries=3, 5000, 5000, 5000";
    private static final long DEFAULT_INTER_APN_DELAY = 20000;
    private static final long DEFAULT_INTER_APN_DELAY_FOR_PROVISIONING = 3000;
    private static final int DEFAULT_MAX_SAME_APN_RETRY = 3;
    public static final String LOG_TAG = "RetryManager";
    public static final long NO_RETRY = Long.MAX_VALUE;
    public static final long NO_SUGGESTED_RETRY_DELAY = -1;
    private static final String OTHERS_APN_TYPE = "others";
    public static final boolean VDBG = false;
    private final int apnType;
    private long mApnRetryAfterDisconnectDelay;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private String mApnType;
    private String mConfig;
    private int mCurrentApnIndex = -1;
    private final DataThrottler mDataThrottler;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private long mFailFastInterApnDelay;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private long mInterApnDelay;
    private int mMaxRetryCount;
    private int mMaxSameApnRetry = 3;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private Phone mPhone;
    private ArrayList<RetryRec> mRetryArray = new ArrayList<>();
    private int mRetryCount = 0;
    private boolean mRetryForever = false;
    private Random mRng = new Random();
    private int mSameApnRetryCount = 0;
    private ArrayList<ApnSetting> mWaitingApns = new ArrayList<>();

    private static class RetryRec {
        long mDelayTime;
        long mRandomizationTime;

        RetryRec(long j, long j2) {
            this.mDelayTime = j;
            this.mRandomizationTime = j2;
        }
    }

    public RetryManager(Phone phone, DataThrottler dataThrottler, int i) {
        this.mPhone = phone;
        this.mDataThrottler = dataThrottler;
        this.apnType = i;
    }

    @UnsupportedAppUsage
    private boolean configure(String str) {
        if (str.startsWith("\"") && str.endsWith("\"")) {
            str = str.substring(1, str.length() - 1);
        }
        reset();
        log("configure: '" + str + "'");
        this.mConfig = str;
        if (!TextUtils.isEmpty(str)) {
            String[] split = str.split(",");
            long j = 0;
            for (int i = 0; i < split.length; i++) {
                String[] split2 = split[i].split("=", 2);
                split2[0] = split2[0].trim();
                if (split2.length > 1) {
                    split2[1] = split2[1].trim();
                    if (TextUtils.equals(split2[0], "default_randomization")) {
                        Pair<Boolean, Integer> parseNonNegativeInt = parseNonNegativeInt(split2[0], split2[1]);
                        if (!((Boolean) parseNonNegativeInt.first).booleanValue()) {
                            return false;
                        }
                        j = (long) ((Integer) parseNonNegativeInt.second).intValue();
                    } else if (!TextUtils.equals(split2[0], "max_retries")) {
                        Rlog.e(LOG_TAG, "Unrecognized configuration name value pair: " + split[i]);
                        return false;
                    } else if (TextUtils.equals("infinite", split2[1])) {
                        this.mRetryForever = true;
                    } else {
                        Pair<Boolean, Integer> parseNonNegativeInt2 = parseNonNegativeInt(split2[0], split2[1]);
                        if (!((Boolean) parseNonNegativeInt2.first).booleanValue()) {
                            return false;
                        }
                        this.mMaxRetryCount = ((Integer) parseNonNegativeInt2.second).intValue();
                    }
                } else {
                    String[] split3 = split[i].split(":", 2);
                    split3[0] = split3[0].trim();
                    RetryRec retryRec = new RetryRec(0, 0);
                    Pair<Boolean, Integer> parseNonNegativeInt3 = parseNonNegativeInt("delayTime", split3[0]);
                    if (!((Boolean) parseNonNegativeInt3.first).booleanValue()) {
                        return false;
                    }
                    retryRec.mDelayTime = (long) ((Integer) parseNonNegativeInt3.second).intValue();
                    if (split3.length > 1) {
                        String trim = split3[1].trim();
                        split3[1] = trim;
                        Pair<Boolean, Integer> parseNonNegativeInt4 = parseNonNegativeInt("randomizationTime", trim);
                        if (!((Boolean) parseNonNegativeInt4.first).booleanValue()) {
                            return false;
                        }
                        retryRec.mRandomizationTime = (long) ((Integer) parseNonNegativeInt4.second).intValue();
                    } else {
                        retryRec.mRandomizationTime = j;
                    }
                    this.mRetryArray.add(retryRec);
                }
            }
            if (this.mRetryArray.size() > this.mMaxRetryCount) {
                this.mMaxRetryCount = this.mRetryArray.size();
            }
        } else {
            log("configure: cleared");
        }
        return true;
    }

    private void configureRetry() {
        String str;
        String str2 = DEFAULT_DATA_RETRY_CONFIG;
        try {
            if (TelephonyUtils.IS_DEBUGGABLE) {
                String str3 = SystemProperties.get("test.data_retry_config");
                if (!TextUtils.isEmpty(str3)) {
                    configure(str3);
                    return;
                }
            }
            PersistableBundle configForSubId = ((CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config")).getConfigForSubId(this.mPhone.getSubId());
            this.mInterApnDelay = configForSubId.getLong("carrier_data_call_apn_delay_default_long", DEFAULT_INTER_APN_DELAY);
            this.mFailFastInterApnDelay = configForSubId.getLong("carrier_data_call_apn_delay_faster_long", DEFAULT_INTER_APN_DELAY_FOR_PROVISIONING);
            this.mApnRetryAfterDisconnectDelay = configForSubId.getLong("carrier_data_call_apn_retry_after_disconnect_long", DEFAULT_APN_RETRY_AFTER_DISCONNECT_DELAY);
            this.mMaxSameApnRetry = configForSubId.getInt("carrier_data_call_retry_network_requested_max_count_int", 3);
            String[] stringArray = configForSubId.getStringArray("carrier_data_call_retry_config_strings");
            String str4 = null;
            if (stringArray != null) {
                int length = stringArray.length;
                str = null;
                int i = 0;
                while (true) {
                    if (i >= length) {
                        break;
                    }
                    String str5 = stringArray[i];
                    if (!TextUtils.isEmpty(str5)) {
                        String[] split = str5.split(":", 2);
                        if (split.length == 2) {
                            String trim = split[0].trim();
                            if (trim.equals(ApnSetting.getApnTypeString(this.apnType))) {
                                str4 = split[1];
                                break;
                            } else if (trim.equals(OTHERS_APN_TYPE)) {
                                str = split[1];
                            }
                        } else {
                            continue;
                        }
                    }
                    i++;
                }
            } else {
                str = null;
            }
            if (str4 != null) {
                str2 = str4;
            } else if (str != null) {
                str2 = str;
            } else {
                log("Invalid APN retry configuration!. Use the default one now.");
            }
        } catch (NullPointerException unused) {
            log("Failed to read configuration! Use the hardcoded default value.");
            this.mInterApnDelay = DEFAULT_INTER_APN_DELAY;
            this.mFailFastInterApnDelay = DEFAULT_INTER_APN_DELAY_FOR_PROVISIONING;
        }
        configure(str2);
    }

    @UnsupportedAppUsage
    private long getRetryTimer() {
        int i;
        if (this.mRetryCount < this.mRetryArray.size()) {
            i = this.mRetryCount;
        } else {
            i = this.mRetryArray.size() - 1;
        }
        long nextRandomizationTime = (i < 0 || i >= this.mRetryArray.size()) ? 0 : this.mRetryArray.get(i).mDelayTime + nextRandomizationTime(i);
        log("getRetryTimer: " + nextRandomizationTime);
        return nextRandomizationTime;
    }

    private Pair<Boolean, Integer> parseNonNegativeInt(String str, String str2) {
        try {
            int parseInt = Integer.parseInt(str2);
            return new Pair<>(Boolean.valueOf(validateNonNegativeInt(str, (long) parseInt)), Integer.valueOf(parseInt));
        } catch (NumberFormatException e) {
            Rlog.e(LOG_TAG, str + " bad value: " + str2, e);
            return new Pair<>(Boolean.FALSE, 0);
        }
    }

    private boolean validateNonNegativeInt(String str, long j) {
        if (j >= 0) {
            return true;
        }
        Rlog.e(LOG_TAG, str + " bad value: is < 0");
        return false;
    }

    private long nextRandomizationTime(int i) {
        long j = this.mRetryArray.get(i).mRandomizationTime;
        if (j == 0) {
            return 0;
        }
        return (long) this.mRng.nextInt((int) j);
    }

    private long getNetworkSuggestedRetryDelay() {
        long retryTime = this.mDataThrottler.getRetryTime(this.apnType);
        return (retryTime == Long.MAX_VALUE || retryTime == -1) ? retryTime : Math.max(0, retryTime - SystemClock.elapsedRealtime());
    }

    public ApnSetting getNextApnSetting() {
        int i;
        ArrayList<ApnSetting> arrayList = this.mWaitingApns;
        if (arrayList == null || arrayList.size() == 0) {
            log("Waiting APN list is null or empty.");
            return null;
        }
        long networkSuggestedRetryDelay = getNetworkSuggestedRetryDelay();
        if (networkSuggestedRetryDelay == Long.MAX_VALUE) {
            log("Network suggested no retry.");
            return null;
        }
        int i2 = this.mCurrentApnIndex;
        if (i2 == -1 || networkSuggestedRetryDelay == -1 || (i = this.mSameApnRetryCount) >= this.mMaxSameApnRetry) {
            this.mSameApnRetryCount = 0;
            do {
                i2++;
                if (i2 == this.mWaitingApns.size()) {
                    i2 = 0;
                }
                if (!this.mWaitingApns.get(i2).getPermanentFailed()) {
                    this.mCurrentApnIndex = i2;
                    return this.mWaitingApns.get(i2);
                }
            } while (!this.mWaitingApns.stream().allMatch(new RetryManager$$ExternalSyntheticLambda0()));
            return null;
        }
        this.mSameApnRetryCount = i + 1;
        return this.mWaitingApns.get(i2);
    }

    public long getDelayForNextApn(boolean z) {
        long j;
        ArrayList<ApnSetting> arrayList = this.mWaitingApns;
        if (arrayList == null || arrayList.size() == 0) {
            log("Waiting APN list is null or empty.");
            return Long.MAX_VALUE;
        }
        long networkSuggestedRetryDelay = getNetworkSuggestedRetryDelay();
        log("Network suggested delay=" + networkSuggestedRetryDelay + "ms");
        if (networkSuggestedRetryDelay == Long.MAX_VALUE) {
            log("Network suggested not retrying.");
            return Long.MAX_VALUE;
        } else if (networkSuggestedRetryDelay == -1 || this.mSameApnRetryCount >= this.mMaxSameApnRetry) {
            int i = this.mCurrentApnIndex;
            do {
                i++;
                if (i >= this.mWaitingApns.size()) {
                    i = 0;
                }
                if (!this.mWaitingApns.get(i).getPermanentFailed()) {
                    if (i > this.mCurrentApnIndex) {
                        j = this.mInterApnDelay;
                    } else if (this.mRetryForever || this.mRetryCount + 1 <= this.mMaxRetryCount) {
                        j = getRetryTimer();
                        this.mRetryCount++;
                    } else {
                        log("Reached maximum retry count " + this.mMaxRetryCount + ".");
                        return Long.MAX_VALUE;
                    }
                    if (!z) {
                        return j;
                    }
                    long j2 = this.mFailFastInterApnDelay;
                    return j > j2 ? j2 : j;
                }
            } while (!this.mWaitingApns.stream().allMatch(new RetryManager$$ExternalSyntheticLambda0()));
            log("All APNs have permanently failed.");
            return Long.MAX_VALUE;
        } else {
            log("Network suggested retry in " + networkSuggestedRetryDelay + " ms.");
            return networkSuggestedRetryDelay;
        }
    }

    public void markApnPermanentFailed(ApnSetting apnSetting) {
        if (apnSetting != null) {
            apnSetting.setPermanentFailed(true);
        }
    }

    private void reset() {
        this.mMaxRetryCount = 0;
        this.mRetryCount = 0;
        this.mCurrentApnIndex = -1;
        this.mSameApnRetryCount = 0;
        this.mRetryArray.clear();
    }

    public void setWaitingApns(ArrayList<ApnSetting> arrayList) {
        if (arrayList == null) {
            log("No waiting APNs provided");
            return;
        }
        this.mWaitingApns = arrayList;
        configureRetry();
        Iterator<ApnSetting> it = this.mWaitingApns.iterator();
        while (it.hasNext()) {
            it.next().setPermanentFailed(false);
        }
        log("Setting " + this.mWaitingApns.size() + " waiting APNs.");
    }

    public ArrayList<ApnSetting> getWaitingApns() {
        return this.mWaitingApns;
    }

    public long getRetryAfterDisconnectDelay() {
        return this.mApnRetryAfterDisconnectDelay;
    }

    public String toString() {
        if (this.mConfig == null) {
            return "";
        }
        return "RetryManager: apnType=" + ApnSetting.getApnTypeString(this.apnType) + " mRetryCount=" + this.mRetryCount + " mMaxRetryCount=" + this.mMaxRetryCount + " mCurrentApnIndex=" + this.mCurrentApnIndex + " mSameApnRtryCount=" + this.mSameApnRetryCount + " networkSuggestedDelay=" + getNetworkSuggestedRetryDelay() + " mRetryForever=" + this.mRetryForever + " mInterApnDelay=" + this.mInterApnDelay + " mApnRetryAfterDisconnectDelay=" + this.mApnRetryAfterDisconnectDelay + " mConfig={" + this.mConfig + "}";
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void log(String str) {
        Rlog.d(LOG_TAG, "[" + ApnSetting.getApnTypeString(this.apnType) + "] " + str);
    }
}
