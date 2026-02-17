package com.android.internal.telephony.metrics;

import android.os.SystemClock;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.feature.MmTelFeature;
import android.util.Patterns;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.imsphone.ImsPhone;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.telephony.Rlog;
import java.util.regex.Pattern;

public class ImsStats {
    private static final int MAX_EXTRA_MESSAGE_LENGTH = 128;
    private static final long MIN_REGISTRATION_DURATION_MILLIS = 1000;
    private static final Pattern PATTERN_HOSTNAME = Pattern.compile("([0-9a-zA-Z][0-9a-zA-Z_\\-]{0,61}[0-9a-zA-Z]\\.){2,}[a-zA-Z]{2,}");
    private static final Pattern PATTERN_IMEI = Pattern.compile("(^|[^0-9])(?:[0-9]{8}-[0-9]{6}-[0-9][0-9]?|[0-9]{2}-[0-9]{6}-[0-9]{6}-[0-9][0-9]?|[0-9]{16})($|[^0-9])");
    private static final Pattern PATTERN_IPV4 = Pattern.compile("((25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9]))");
    private static final Pattern PATTERN_IPV6 = Pattern.compile("([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,6}(:[0-9a-fA-F]{1,4}){1,6}|([0-9a-fA-F]{1,4}:){1,7}:|:(:[0-9a-fA-F]{1,4}){1,7}");
    private static final Pattern PATTERN_UNKNOWN_ID = Pattern.compile("(^|[^0-9a-fA-F])(([-\\.]?0)*[1-9a-fA-F]([-\\.]?[0-9a-fA-F]){5,}|0*[1-9a-fA-F]([0-9a-fA-F]){4,})");
    private static final Pattern PATTERN_UNSEGMENTED_IMEI_IMSI = Pattern.compile("(^|[^0-9])[0-9]{15}($|[^0-9])");
    private static final Pattern PATTERN_URI = Pattern.compile("([a-zA-Z]{2,}:)" + Patterns.EMAIL_ADDRESS.pattern());
    private static final Pattern PATTERN_UUID = Pattern.compile("[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}");
    private static final String REPLACEMENT_HOSTNAME = "<HOSTNAME_REDACTED>";
    private static final String REPLACEMENT_IMEI = "$1<IMEI_REDACTED>$2";
    private static final String REPLACEMENT_IPV4 = "<IPV4_REDACTED>";
    private static final String REPLACEMENT_IPV6 = "<IPV6_REDACTED>";
    private static final String REPLACEMENT_UNKNOWN_ID = "$1<ID_REDACTED>";
    private static final String REPLACEMENT_UNSEGMENTED_IMEI_IMSI = "$1<IMEI_IMSI_REDACTED>$2";
    private static final String REPLACEMENT_URI = "$1<REDACTED>";
    private static final String REPLACEMENT_UUID = "<UUID_REDACTED>";
    private static final String TAG = "ImsStats";
    private MmTelFeature.MmTelCapabilities mLastAvailableFeatures = new MmTelFeature.MmTelCapabilities();
    private int mLastRegistrationState = 0;
    private PersistAtomsProto.ImsRegistrationStats mLastRegistrationStats;
    private long mLastTimestamp;
    private final MmTelFeature.MmTelCapabilities mLastWlanCapableFeatures = new MmTelFeature.MmTelCapabilities();
    private final MmTelFeature.MmTelCapabilities mLastWwanCapableFeatures = new MmTelFeature.MmTelCapabilities();
    private final ImsPhone mPhone;
    private final PersistAtomsStorage mStorage;

    public ImsStats(ImsPhone imsPhone) {
        this.mPhone = imsPhone;
        this.mStorage = PhoneFactory.getMetricsCollector().getAtomsStorage();
    }

    public synchronized void conclude() {
        MmTelFeature.MmTelCapabilities mmTelCapabilities;
        long timeMillis = getTimeMillis();
        if (this.mLastRegistrationState == 2) {
            PersistAtomsProto.ImsRegistrationStats copyOf = copyOf(this.mLastRegistrationStats);
            long j = timeMillis - this.mLastTimestamp;
            if (j < 1000) {
                logw("conclude: discarding transient stats, duration=%d", Long.valueOf(j));
            } else {
                copyOf.registeredMillis = j;
                copyOf.voiceAvailableMillis = this.mLastAvailableFeatures.isCapable(1) ? j : 0;
                copyOf.videoAvailableMillis = this.mLastAvailableFeatures.isCapable(2) ? j : 0;
                copyOf.utAvailableMillis = this.mLastAvailableFeatures.isCapable(4) ? j : 0;
                copyOf.smsAvailableMillis = this.mLastAvailableFeatures.isCapable(8) ? j : 0;
                if (copyOf.rat == 18) {
                    mmTelCapabilities = this.mLastWlanCapableFeatures;
                } else {
                    mmTelCapabilities = this.mLastWwanCapableFeatures;
                }
                copyOf.voiceCapableMillis = mmTelCapabilities.isCapable(1) ? j : 0;
                copyOf.videoCapableMillis = mmTelCapabilities.isCapable(2) ? j : 0;
                copyOf.utCapableMillis = mmTelCapabilities.isCapable(4) ? j : 0;
                if (!mmTelCapabilities.isCapable(8)) {
                    j = 0;
                }
                copyOf.smsCapableMillis = j;
                this.mStorage.addImsRegistrationStats(copyOf);
            }
        }
        this.mLastTimestamp = timeMillis;
    }

    public synchronized void onImsCapabilitiesChanged(int i, MmTelFeature.MmTelCapabilities mmTelCapabilities) {
        boolean z;
        conclude();
        int convertRegistrationTechToNetworkType = convertRegistrationTechToNetworkType(i);
        PersistAtomsProto.ImsRegistrationStats imsRegistrationStats = this.mLastRegistrationStats;
        boolean z2 = false;
        if (imsRegistrationStats == null || imsRegistrationStats.rat == convertRegistrationTechToNetworkType) {
            z = false;
        } else {
            imsRegistrationStats.rat = convertRegistrationTechToNetworkType;
            z = true;
        }
        boolean isCapable = mmTelCapabilities.isCapable(1);
        if (this.mLastAvailableFeatures.isCapable(1) != isCapable) {
            z2 = true;
        }
        this.mLastAvailableFeatures = mmTelCapabilities;
        if ((z && isCapable) || z2) {
            this.mPhone.getDefaultPhone().getServiceStateTracker().getServiceStateStats().onImsVoiceRegistrationChanged();
        }
    }

    public synchronized void onSetFeatureResponse(int i, int i2, int i3) {
        MmTelFeature.MmTelCapabilities lastCapableFeaturesForTech = getLastCapableFeaturesForTech(i2);
        if (lastCapableFeaturesForTech != null) {
            conclude();
            if (i3 == 1) {
                lastCapableFeaturesForTech.addCapabilities(i);
            } else {
                lastCapableFeaturesForTech.removeCapabilities(i);
            }
        }
    }

    public synchronized void onImsRegistering(int i) {
        conclude();
        PersistAtomsProto.ImsRegistrationStats defaultImsRegistrationStats = getDefaultImsRegistrationStats();
        this.mLastRegistrationStats = defaultImsRegistrationStats;
        defaultImsRegistrationStats.rat = convertTransportTypeToNetworkType(i);
        this.mLastRegistrationState = 1;
    }

    public synchronized void onImsRegistered(int i) {
        conclude();
        if (this.mLastRegistrationStats == null) {
            this.mLastRegistrationStats = getDefaultImsRegistrationStats();
        }
        this.mLastRegistrationStats.rat = convertTransportTypeToNetworkType(i);
        this.mLastRegistrationState = 2;
    }

    public synchronized void onImsUnregistered(ImsReasonInfo imsReasonInfo) {
        conclude();
        PersistAtomsProto.ImsRegistrationTermination imsRegistrationTermination = new PersistAtomsProto.ImsRegistrationTermination();
        PersistAtomsProto.ImsRegistrationStats imsRegistrationStats = this.mLastRegistrationStats;
        if (imsRegistrationStats != null) {
            imsRegistrationTermination.carrierId = imsRegistrationStats.carrierId;
            imsRegistrationTermination.ratAtEnd = getRatAtEnd(imsRegistrationStats.rat);
        } else {
            imsRegistrationTermination.carrierId = this.mPhone.getDefaultPhone().getCarrierId();
            imsRegistrationTermination.ratAtEnd = 0;
        }
        imsRegistrationTermination.isMultiSim = SimSlotState.isMultiSim();
        imsRegistrationTermination.setupFailed = this.mLastRegistrationState != 2;
        imsRegistrationTermination.reasonCode = imsReasonInfo.getCode();
        imsRegistrationTermination.extraCode = imsReasonInfo.getExtraCode();
        imsRegistrationTermination.extraMessage = filterExtraMessage(imsReasonInfo.getExtraMessage());
        imsRegistrationTermination.count = 1;
        this.mStorage.addImsRegistrationTermination(imsRegistrationTermination);
        this.mLastRegistrationState = 0;
        this.mLastRegistrationStats = null;
        this.mLastAvailableFeatures = new MmTelFeature.MmTelCapabilities();
    }

    @VisibleForTesting
    public synchronized int getImsVoiceRadioTech() {
        if (this.mLastRegistrationStats != null) {
            if (this.mLastAvailableFeatures.isCapable(1)) {
                return this.mLastRegistrationStats.rat;
            }
        }
        return 0;
    }

    private int getRatAtEnd(int i) {
        return i == 18 ? i : getWwanPsRat();
    }

    private int convertTransportTypeToNetworkType(int i) {
        if (i != 1) {
            return i != 2 ? 0 : 18;
        }
        return getWwanPsRat();
    }

    private int getWwanPsRat() {
        return ServiceStateStats.getDataRat(this.mPhone.getServiceStateTracker().getServiceState());
    }

    private PersistAtomsProto.ImsRegistrationStats getDefaultImsRegistrationStats() {
        Phone defaultPhone = this.mPhone.getDefaultPhone();
        PersistAtomsProto.ImsRegistrationStats imsRegistrationStats = new PersistAtomsProto.ImsRegistrationStats();
        imsRegistrationStats.carrierId = defaultPhone.getCarrierId();
        imsRegistrationStats.simSlotIndex = defaultPhone.getPhoneId();
        return imsRegistrationStats;
    }

    private MmTelFeature.MmTelCapabilities getLastCapableFeaturesForTech(int i) {
        if (i == -1) {
            return null;
        }
        if (i != 1) {
            return this.mLastWwanCapableFeatures;
        }
        return this.mLastWlanCapableFeatures;
    }

    private int convertRegistrationTechToNetworkType(int i) {
        if (i == -1) {
            return 0;
        }
        if (i == 0) {
            return 13;
        }
        if (i == 1) {
            return 18;
        }
        if (i == 3) {
            return 20;
        }
        loge("convertRegistrationTechToNetworkType: unknown radio tech %d", Integer.valueOf(i));
        return getWwanPsRat();
    }

    private static PersistAtomsProto.ImsRegistrationStats copyOf(PersistAtomsProto.ImsRegistrationStats imsRegistrationStats) {
        PersistAtomsProto.ImsRegistrationStats imsRegistrationStats2 = new PersistAtomsProto.ImsRegistrationStats();
        imsRegistrationStats2.carrierId = imsRegistrationStats.carrierId;
        imsRegistrationStats2.simSlotIndex = imsRegistrationStats.simSlotIndex;
        imsRegistrationStats2.rat = imsRegistrationStats.rat;
        imsRegistrationStats2.registeredMillis = imsRegistrationStats.registeredMillis;
        imsRegistrationStats2.voiceCapableMillis = imsRegistrationStats.voiceCapableMillis;
        imsRegistrationStats2.voiceAvailableMillis = imsRegistrationStats.voiceAvailableMillis;
        imsRegistrationStats2.smsCapableMillis = imsRegistrationStats.smsCapableMillis;
        imsRegistrationStats2.smsAvailableMillis = imsRegistrationStats.smsAvailableMillis;
        imsRegistrationStats2.videoCapableMillis = imsRegistrationStats.videoCapableMillis;
        imsRegistrationStats2.videoAvailableMillis = imsRegistrationStats.videoAvailableMillis;
        imsRegistrationStats2.utCapableMillis = imsRegistrationStats.utCapableMillis;
        imsRegistrationStats2.utAvailableMillis = imsRegistrationStats.utAvailableMillis;
        return imsRegistrationStats2;
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public long getTimeMillis() {
        return SystemClock.elapsedRealtime();
    }

    public static String filterExtraMessage(String str) {
        if (str == null) {
            return "";
        }
        String replaceAll = PATTERN_UNKNOWN_ID.matcher(PATTERN_UNSEGMENTED_IMEI_IMSI.matcher(PATTERN_IMEI.matcher(PATTERN_IPV6.matcher(PATTERN_IPV4.matcher(PATTERN_HOSTNAME.matcher(PATTERN_URI.matcher(PATTERN_UUID.matcher(str).replaceAll(REPLACEMENT_UUID)).replaceAll(REPLACEMENT_URI)).replaceAll(REPLACEMENT_HOSTNAME)).replaceAll(REPLACEMENT_IPV4)).replaceAll(REPLACEMENT_IPV6)).replaceAll(REPLACEMENT_IMEI)).replaceAll(REPLACEMENT_UNSEGMENTED_IMEI_IMSI)).replaceAll(REPLACEMENT_UNKNOWN_ID);
        return replaceAll.length() > 128 ? replaceAll.substring(0, 128) : replaceAll;
    }

    private void logw(String str, Object... objArr) {
        String str2 = TAG;
        Rlog.w(str2, "[" + this.mPhone.getPhoneId() + "] " + String.format(str, objArr));
    }

    private void loge(String str, Object... objArr) {
        String str2 = TAG;
        Rlog.e(str2, "[" + this.mPhone.getPhoneId() + "] " + String.format(str, objArr));
    }
}
