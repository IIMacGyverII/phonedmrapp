package com.android.internal.telephony.metrics;

import android.app.StatsManager;
import android.content.Context;
import android.util.StatsEvent;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.TelephonyStatsLog;
import com.android.internal.telephony.imsphone.ImsPhone;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.internal.util.ConcurrentUtils;
import com.android.telephony.Rlog;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class MetricsCollector implements StatsManager.StatsPullAtomCallback {
    private static final boolean DBG = false;
    private static final long DURATION_BUCKET_MILLIS = 300000;
    private static final long MIN_CALLS_PER_BUCKET = 5;
    private static final long MIN_COOLDOWN_MILLIS = 82800000;
    private static final StatsManager.PullAtomMetadata POLICY_PULL_DAILY = new StatsManager.PullAtomMetadata.Builder().setCoolDownMillis(MIN_COOLDOWN_MILLIS).build();
    private static final String TAG = MetricsCollector.class.getSimpleName();
    private static final Random sRandom = new Random();
    private final AirplaneModeStats mAirplaneModeStats;
    private final Set<DataCallSessionStats> mOngoingDataCallStats;
    private final StatsManager mStatsManager;
    private final PersistAtomsStorage mStorage;

    public MetricsCollector(Context context) {
        this(context, new PersistAtomsStorage(context));
    }

    @VisibleForTesting
    public MetricsCollector(Context context, PersistAtomsStorage persistAtomsStorage) {
        this.mOngoingDataCallStats = ConcurrentHashMap.newKeySet();
        this.mStorage = persistAtomsStorage;
        StatsManager statsManager = (StatsManager) context.getSystemService("stats");
        this.mStatsManager = statsManager;
        if (statsManager != null) {
            StatsManager.PullAtomMetadata pullAtomMetadata = POLICY_PULL_DAILY;
            registerAtom(10091, pullAtomMetadata);
            registerAtom(10090, pullAtomMetadata);
            registerAtom(10078, (StatsManager.PullAtomMetadata) null);
            registerAtom(10079, (StatsManager.PullAtomMetadata) null);
            registerAtom(10077, pullAtomMetadata);
            registerAtom(10076, pullAtomMetadata);
            registerAtom(10086, pullAtomMetadata);
            registerAtom(10087, pullAtomMetadata);
            registerAtom(10088, (StatsManager.PullAtomMetadata) null);
            registerAtom(10089, pullAtomMetadata);
            registerAtom(10094, pullAtomMetadata);
            registerAtom(10093, pullAtomMetadata);
            registerAtom(10153, pullAtomMetadata);
            registerAtom(10133, pullAtomMetadata);
            registerAtom(10134, pullAtomMetadata);
            registerAtom(10135, pullAtomMetadata);
            registerAtom(10136, pullAtomMetadata);
            registerAtom(10137, pullAtomMetadata);
            registerAtom(10138, pullAtomMetadata);
            registerAtom(10139, pullAtomMetadata);
            registerAtom(10154, (StatsManager.PullAtomMetadata) null);
            registerAtom(10140, pullAtomMetadata);
            registerAtom(10141, pullAtomMetadata);
            registerAtom(10142, pullAtomMetadata);
            registerAtom(10143, pullAtomMetadata);
            registerAtom(10144, pullAtomMetadata);
            registerAtom(10145, pullAtomMetadata);
            registerAtom(10146, (StatsManager.PullAtomMetadata) null);
            Rlog.d(TAG, "registered");
        } else {
            Rlog.e(TAG, "could not get StatsManager, atoms not registered");
        }
        this.mAirplaneModeStats = new AirplaneModeStats(context);
    }

    public int onPullAtom(int i, List<StatsEvent> list) {
        if (i == 10093) {
            return pullImsRegistrationTermination(list);
        }
        if (i == 10094) {
            return pullImsRegistrationStats(list);
        }
        if (i == 10153) {
            return pullTelephonyNetworkRequestsV2(list);
        }
        if (i == 10154) {
            return pullDeviceTelephonyProperties(list);
        }
        switch (i) {
            case 10076:
                return pullVoiceCallSessions(list);
            case 10077:
                return pullVoiceCallRatUsages(list);
            case 10078:
                return pullSimSlotState(list);
            case 10079:
                return pullSupportedRadioAccessFamily(list);
            default:
                switch (i) {
                    case 10086:
                        return pullIncomingSms(list);
                    case 10087:
                        return pullOutgoingSms(list);
                    case 10088:
                        return pullCarrierIdTableVersion(list);
                    case 10089:
                        return pullDataCallSession(list);
                    case 10090:
                        return pullCellularServiceState(list);
                    case 10091:
                        return pullCellularDataServiceSwitch(list);
                    default:
                        switch (i) {
                            case 10133:
                                return pullImsRegistrationFeatureTagStats(list);
                            case 10134:
                                return pullRcsClientProvisioningStats(list);
                            case 10135:
                                return pullRcsAcsProvisioningStats(list);
                            case 10136:
                                return pullSipDelegateStats(list);
                            case 10137:
                                return pullSipTransportFeatureTagStats(list);
                            case 10138:
                                return pullSipMessageResponse(list);
                            case 10139:
                                return pullSipTransportSession(list);
                            case 10140:
                                return pullImsDedicatedBearerListenerEvent(list);
                            case 10141:
                                return pullImsDedicatedBearerEvent(list);
                            case 10142:
                                return pullImsRegistrationServiceDescStats(list);
                            case 10143:
                                return pullUceEventStats(list);
                            case 10144:
                                return pullPresenceNotifyEvent(list);
                            case 10145:
                                return pullGbaEvent(list);
                            case 10146:
                                return pullPerSimStatus(list);
                            default:
                                Rlog.e(TAG, String.format("unexpected atom ID %d", new Object[]{Integer.valueOf(i)}));
                                return 1;
                        }
                }
        }
    }

    public PersistAtomsStorage getAtomsStorage() {
        return this.mStorage;
    }

    public void registerOngoingDataCallStat(DataCallSessionStats dataCallSessionStats) {
        this.mOngoingDataCallStats.add(dataCallSessionStats);
    }

    public void unregisterOngoingDataCallStat(DataCallSessionStats dataCallSessionStats) {
        this.mOngoingDataCallStats.remove(dataCallSessionStats);
    }

    private static int pullSimSlotState(List<StatsEvent> list) {
        try {
            SimSlotState currentState = SimSlotState.getCurrentState();
            list.add(TelephonyStatsLog.buildStatsEvent(10078, currentState.numActiveSlots, currentState.numActiveSims, currentState.numActiveEsims));
            return 0;
        } catch (RuntimeException unused) {
            return 1;
        }
    }

    private static int pullSupportedRadioAccessFamily(List<StatsEvent> list) {
        if (getPhonesIfAny().length == 0) {
            return 1;
        }
        long j = 0;
        for (Phone radioAccessFamily : PhoneFactory.getPhones()) {
            j |= (long) radioAccessFamily.getRadioAccessFamily();
        }
        list.add(TelephonyStatsLog.buildStatsEvent(10079, j));
        return 0;
    }

    private static int pullCarrierIdTableVersion(List<StatsEvent> list) {
        Phone[] phonesIfAny = getPhonesIfAny();
        if (phonesIfAny.length == 0) {
            return 1;
        }
        list.add(TelephonyStatsLog.buildStatsEvent(10088, phonesIfAny[0].getCarrierIdListVersion()));
        return 0;
    }

    private int pullVoiceCallRatUsages(List<StatsEvent> list) {
        PersistAtomsProto.VoiceCallRatUsage[] voiceCallRatUsages = this.mStorage.getVoiceCallRatUsages(MIN_COOLDOWN_MILLIS);
        if (voiceCallRatUsages != null) {
            Arrays.stream(voiceCallRatUsages).sorted(Comparator.comparingLong(new MetricsCollector$$ExternalSyntheticLambda21())).filter(new MetricsCollector$$ExternalSyntheticLambda22()).forEach(new MetricsCollector$$ExternalSyntheticLambda23(list));
            Rlog.d(TAG, String.format("%d out of %d VOICE_CALL_RAT_USAGE pulled", new Object[]{Integer.valueOf(list.size()), Integer.valueOf(voiceCallRatUsages.length)}));
            return 0;
        }
        Rlog.w(TAG, "VOICE_CALL_RAT_USAGE pull too frequent, skipping");
        return 1;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ long lambda$pullVoiceCallRatUsages$0(PersistAtomsProto.VoiceCallRatUsage voiceCallRatUsage) {
        return (((long) voiceCallRatUsage.carrierId) << 32) | ((long) voiceCallRatUsage.rat);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$pullVoiceCallRatUsages$1(PersistAtomsProto.VoiceCallRatUsage voiceCallRatUsage) {
        return voiceCallRatUsage.callCount >= MIN_CALLS_PER_BUCKET;
    }

    private int pullVoiceCallSessions(List<StatsEvent> list) {
        PersistAtomsProto.VoiceCallSession[] voiceCallSessions = this.mStorage.getVoiceCallSessions(MIN_COOLDOWN_MILLIS);
        if (voiceCallSessions != null) {
            Arrays.stream(voiceCallSessions).forEach(new MetricsCollector$$ExternalSyntheticLambda17(list));
            return 0;
        }
        Rlog.w(TAG, "VOICE_CALL_SESSION pull too frequent, skipping");
        return 1;
    }

    private int pullIncomingSms(List<StatsEvent> list) {
        PersistAtomsProto.IncomingSms[] incomingSms = this.mStorage.getIncomingSms(MIN_COOLDOWN_MILLIS);
        if (incomingSms != null) {
            Arrays.stream(incomingSms).forEach(new MetricsCollector$$ExternalSyntheticLambda20(list));
            return 0;
        }
        Rlog.w(TAG, "INCOMING_SMS pull too frequent, skipping");
        return 1;
    }

    private int pullOutgoingSms(List<StatsEvent> list) {
        PersistAtomsProto.OutgoingSms[] outgoingSms = this.mStorage.getOutgoingSms(MIN_COOLDOWN_MILLIS);
        if (outgoingSms != null) {
            Arrays.stream(outgoingSms).forEach(new MetricsCollector$$ExternalSyntheticLambda18(list));
            return 0;
        }
        Rlog.w(TAG, "OUTGOING_SMS pull too frequent, skipping");
        return 1;
    }

    private int pullDataCallSession(List<StatsEvent> list) {
        for (DataCallSessionStats conclude : this.mOngoingDataCallStats) {
            conclude.conclude();
        }
        PersistAtomsProto.DataCallSession[] dataCallSessions = this.mStorage.getDataCallSessions(MIN_COOLDOWN_MILLIS);
        if (dataCallSessions != null) {
            Arrays.stream(dataCallSessions).forEach(new MetricsCollector$$ExternalSyntheticLambda14(list));
            return 0;
        }
        Rlog.w(TAG, "DATA_CALL_SESSION pull too frequent, skipping");
        return 1;
    }

    private int pullCellularDataServiceSwitch(List<StatsEvent> list) {
        PersistAtomsProto.CellularDataServiceSwitch[] cellularDataServiceSwitches = this.mStorage.getCellularDataServiceSwitches(MIN_COOLDOWN_MILLIS);
        if (cellularDataServiceSwitches != null) {
            Arrays.stream(cellularDataServiceSwitches).forEach(new MetricsCollector$$ExternalSyntheticLambda7(list));
            return 0;
        }
        Rlog.w(TAG, "CELLULAR_DATA_SERVICE_SWITCH pull too frequent, skipping");
        return 1;
    }

    private int pullCellularServiceState(List<StatsEvent> list) {
        for (Phone serviceStateTracker : getPhonesIfAny()) {
            serviceStateTracker.getServiceStateTracker().getServiceStateStats().conclude();
        }
        PersistAtomsProto.CellularServiceState[] cellularServiceStates = this.mStorage.getCellularServiceStates(MIN_COOLDOWN_MILLIS);
        if (cellularServiceStates != null) {
            Arrays.stream(cellularServiceStates).forEach(new MetricsCollector$$ExternalSyntheticLambda4(list));
            return 0;
        }
        Rlog.w(TAG, "CELLULAR_SERVICE_STATE pull too frequent, skipping");
        return 1;
    }

    private int pullImsRegistrationStats(List<StatsEvent> list) {
        for (Phone imsPhone : getPhonesIfAny()) {
            ImsPhone imsPhone2 = (ImsPhone) imsPhone.getImsPhone();
            if (imsPhone2 != null) {
                imsPhone2.getImsStats().conclude();
            }
        }
        PersistAtomsProto.ImsRegistrationStats[] imsRegistrationStats = this.mStorage.getImsRegistrationStats(MIN_COOLDOWN_MILLIS);
        if (imsRegistrationStats != null) {
            Arrays.stream(imsRegistrationStats).forEach(new MetricsCollector$$ExternalSyntheticLambda16(list));
            return 0;
        }
        Rlog.w(TAG, "IMS_REGISTRATION_STATS pull too frequent, skipping");
        return 1;
    }

    private int pullImsRegistrationTermination(List<StatsEvent> list) {
        PersistAtomsProto.ImsRegistrationTermination[] imsRegistrationTerminations = this.mStorage.getImsRegistrationTerminations(MIN_COOLDOWN_MILLIS);
        if (imsRegistrationTerminations != null) {
            Arrays.stream(imsRegistrationTerminations).forEach(new MetricsCollector$$ExternalSyntheticLambda19(list));
            return 0;
        }
        Rlog.w(TAG, "IMS_REGISTRATION_TERMINATION pull too frequent, skipping");
        return 1;
    }

    private int pullTelephonyNetworkRequestsV2(List<StatsEvent> list) {
        PersistAtomsProto.NetworkRequestsV2[] networkRequestsV2 = this.mStorage.getNetworkRequestsV2(MIN_COOLDOWN_MILLIS);
        if (networkRequestsV2 != null) {
            Arrays.stream(networkRequestsV2).forEach(new MetricsCollector$$ExternalSyntheticLambda8(list));
            return 0;
        }
        Rlog.w(TAG, "TELEPHONY_NETWORK_REQUESTS_V2 pull too frequent, skipping");
        return 1;
    }

    private static int pullDeviceTelephonyProperties(List<StatsEvent> list) {
        Phone[] phonesIfAny = getPhonesIfAny();
        if (phonesIfAny.length == 0) {
            return 1;
        }
        list.add(TelephonyStatsLog.buildStatsEvent(10154, phonesIfAny[0].isUsingNewDataStack()));
        return 0;
    }

    private int pullImsRegistrationFeatureTagStats(List<StatsEvent> list) {
        RcsStats.getInstance().onFlushIncompleteImsRegistrationFeatureTagStats();
        PersistAtomsProto.ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStats = this.mStorage.getImsRegistrationFeatureTagStats(MIN_COOLDOWN_MILLIS);
        if (imsRegistrationFeatureTagStats != null) {
            Arrays.stream(imsRegistrationFeatureTagStats).forEach(new MetricsCollector$$ExternalSyntheticLambda1(list));
            return 0;
        }
        Rlog.w(TAG, "IMS_REGISTRATION_FEATURE_TAG_STATS pull too frequent, skipping");
        return 1;
    }

    private int pullRcsClientProvisioningStats(List<StatsEvent> list) {
        PersistAtomsProto.RcsClientProvisioningStats[] rcsClientProvisioningStats = this.mStorage.getRcsClientProvisioningStats(MIN_COOLDOWN_MILLIS);
        if (rcsClientProvisioningStats != null) {
            Arrays.stream(rcsClientProvisioningStats).forEach(new MetricsCollector$$ExternalSyntheticLambda6(list));
            return 0;
        }
        Rlog.w(TAG, "RCS_CLIENT_PROVISIONING_STATS pull too frequent, skipping");
        return 1;
    }

    private int pullRcsAcsProvisioningStats(List<StatsEvent> list) {
        RcsStats.getInstance().onFlushIncompleteRcsAcsProvisioningStats();
        PersistAtomsProto.RcsAcsProvisioningStats[] rcsAcsProvisioningStats = this.mStorage.getRcsAcsProvisioningStats(MIN_COOLDOWN_MILLIS);
        if (rcsAcsProvisioningStats != null) {
            Arrays.stream(rcsAcsProvisioningStats).forEach(new MetricsCollector$$ExternalSyntheticLambda13(list));
            return 0;
        }
        Rlog.w(TAG, "RCS_ACS_PROVISIONING_STATS pull too frequent, skipping");
        return 1;
    }

    private int pullSipDelegateStats(List<StatsEvent> list) {
        PersistAtomsProto.SipDelegateStats[] sipDelegateStats = this.mStorage.getSipDelegateStats(MIN_COOLDOWN_MILLIS);
        if (sipDelegateStats != null) {
            Arrays.stream(sipDelegateStats).forEach(new MetricsCollector$$ExternalSyntheticLambda5(list));
            return 0;
        }
        Rlog.w(TAG, "SIP_DELEGATE_STATS pull too frequent, skipping");
        return 1;
    }

    private int pullSipTransportFeatureTagStats(List<StatsEvent> list) {
        RcsStats.getInstance().concludeSipTransportFeatureTagsStat();
        PersistAtomsProto.SipTransportFeatureTagStats[] sipTransportFeatureTagStats = this.mStorage.getSipTransportFeatureTagStats(MIN_COOLDOWN_MILLIS);
        if (sipTransportFeatureTagStats != null) {
            Arrays.stream(sipTransportFeatureTagStats).forEach(new MetricsCollector$$ExternalSyntheticLambda0(list));
            return 0;
        }
        Rlog.w(TAG, "SIP_DELEGATE_STATS pull too frequent, skipping");
        return 1;
    }

    private int pullSipMessageResponse(List<StatsEvent> list) {
        PersistAtomsProto.SipMessageResponse[] sipMessageResponse = this.mStorage.getSipMessageResponse(MIN_COOLDOWN_MILLIS);
        if (sipMessageResponse != null) {
            Arrays.stream(sipMessageResponse).forEach(new MetricsCollector$$ExternalSyntheticLambda10(list));
            return 0;
        }
        Rlog.w(TAG, "RCS_SIP_MESSAGE_RESPONSE pull too frequent, skipping");
        return 1;
    }

    private int pullSipTransportSession(List<StatsEvent> list) {
        PersistAtomsProto.SipTransportSession[] sipTransportSession = this.mStorage.getSipTransportSession(MIN_COOLDOWN_MILLIS);
        if (sipTransportSession != null) {
            Arrays.stream(sipTransportSession).forEach(new MetricsCollector$$ExternalSyntheticLambda9(list));
            return 0;
        }
        Rlog.w(TAG, "RCS_SIP_TRANSPORT_SESSION pull too frequent, skipping");
        return 1;
    }

    private int pullImsDedicatedBearerListenerEvent(List<StatsEvent> list) {
        PersistAtomsProto.ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEvent = this.mStorage.getImsDedicatedBearerListenerEvent(MIN_COOLDOWN_MILLIS);
        if (imsDedicatedBearerListenerEvent != null) {
            Arrays.stream(imsDedicatedBearerListenerEvent).forEach(new MetricsCollector$$ExternalSyntheticLambda11(list));
            return 0;
        }
        Rlog.w(TAG, "IMS_DEDICATED_BEARER_LISTENER_EVENT pull too frequent, skipping");
        return 1;
    }

    private int pullImsDedicatedBearerEvent(List<StatsEvent> list) {
        PersistAtomsProto.ImsDedicatedBearerEvent[] imsDedicatedBearerEvent = this.mStorage.getImsDedicatedBearerEvent(MIN_COOLDOWN_MILLIS);
        if (imsDedicatedBearerEvent != null) {
            Arrays.stream(imsDedicatedBearerEvent).forEach(new MetricsCollector$$ExternalSyntheticLambda2(list));
            return 0;
        }
        Rlog.w(TAG, "IMS_DEDICATED_BEARER_EVENT pull too frequent, skipping");
        return 1;
    }

    private int pullImsRegistrationServiceDescStats(List<StatsEvent> list) {
        RcsStats.getInstance().onFlushIncompleteImsRegistrationServiceDescStats();
        PersistAtomsProto.ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStats = this.mStorage.getImsRegistrationServiceDescStats(MIN_COOLDOWN_MILLIS);
        if (imsRegistrationServiceDescStats != null) {
            Arrays.stream(imsRegistrationServiceDescStats).forEach(new MetricsCollector$$ExternalSyntheticLambda24(list));
            return 0;
        }
        Rlog.w(TAG, "IMS_REGISTRATION_SERVICE_DESC_STATS pull too frequent, skipping");
        return 1;
    }

    private int pullUceEventStats(List<StatsEvent> list) {
        PersistAtomsProto.UceEventStats[] uceEventStats = this.mStorage.getUceEventStats(MIN_COOLDOWN_MILLIS);
        if (uceEventStats != null) {
            Arrays.stream(uceEventStats).forEach(new MetricsCollector$$ExternalSyntheticLambda15(list));
            return 0;
        }
        Rlog.w(TAG, "UCE_EVENT_STATS pull too frequent, skipping");
        return 1;
    }

    private int pullPresenceNotifyEvent(List<StatsEvent> list) {
        PersistAtomsProto.PresenceNotifyEvent[] presenceNotifyEvent = this.mStorage.getPresenceNotifyEvent(MIN_COOLDOWN_MILLIS);
        if (presenceNotifyEvent != null) {
            Arrays.stream(presenceNotifyEvent).forEach(new MetricsCollector$$ExternalSyntheticLambda12(list));
            return 0;
        }
        Rlog.w(TAG, "PRESENCE_NOTIFY_EVENT pull too frequent, skipping");
        return 1;
    }

    private int pullGbaEvent(List<StatsEvent> list) {
        PersistAtomsProto.GbaEvent[] gbaEvent = this.mStorage.getGbaEvent(MIN_COOLDOWN_MILLIS);
        if (gbaEvent != null) {
            Arrays.stream(gbaEvent).forEach(new MetricsCollector$$ExternalSyntheticLambda3(list));
            return 0;
        }
        Rlog.w(TAG, "GBA_EVENT pull too frequent, skipping");
        return 1;
    }

    private int pullPerSimStatus(List<StatsEvent> list) {
        int i = 1;
        for (Phone phone : getPhonesIfAny()) {
            PerSimStatus currentState = PerSimStatus.getCurrentState(phone);
            if (currentState == null) {
                List<StatsEvent> list2 = list;
            } else {
                list.add(TelephonyStatsLog.buildStatsEvent(10146, phone.getPhoneId(), currentState.carrierId, currentState.phoneNumberSourceUicc, currentState.phoneNumberSourceCarrier, currentState.phoneNumberSourceIms, currentState.advancedCallingSettingEnabled, currentState.voWiFiSettingEnabled, currentState.voWiFiModeSetting, currentState.voWiFiRoamingModeSetting, currentState.vtSettingEnabled, currentState.dataRoamingEnabled, currentState.preferredNetworkType, currentState.disabled2g, currentState.pin1Enabled, currentState.minimumVoltageClass, currentState.userModifiedApnTypes));
                i = 0;
            }
        }
        return i;
    }

    private void registerAtom(int i, StatsManager.PullAtomMetadata pullAtomMetadata) {
        this.mStatsManager.setPullAtomCallback(i, pullAtomMetadata, ConcurrentUtils.DIRECT_EXECUTOR, this);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.CellularDataServiceSwitch cellularDataServiceSwitch) {
        return TelephonyStatsLog.buildStatsEvent(10091, cellularDataServiceSwitch.ratFrom, cellularDataServiceSwitch.ratTo, cellularDataServiceSwitch.simSlotIndex, cellularDataServiceSwitch.isMultiSim, cellularDataServiceSwitch.carrierId, cellularDataServiceSwitch.switchCount);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.CellularServiceState cellularServiceState) {
        return TelephonyStatsLog.buildStatsEvent(10090, cellularServiceState.voiceRat, cellularServiceState.dataRat, cellularServiceState.voiceRoamingType, cellularServiceState.dataRoamingType, cellularServiceState.isEndc, cellularServiceState.simSlotIndex, cellularServiceState.isMultiSim, cellularServiceState.carrierId, (int) (round(cellularServiceState.totalTimeMillis, DURATION_BUCKET_MILLIS) / 1000), cellularServiceState.isEmergencyOnly);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.VoiceCallRatUsage voiceCallRatUsage) {
        return TelephonyStatsLog.buildStatsEvent(10077, voiceCallRatUsage.carrierId, voiceCallRatUsage.rat, round(voiceCallRatUsage.totalDurationMillis, DURATION_BUCKET_MILLIS) / 1000, voiceCallRatUsage.callCount);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.VoiceCallSession voiceCallSession) {
        PersistAtomsProto.VoiceCallSession voiceCallSession2 = voiceCallSession;
        return TelephonyStatsLog.buildStatsEvent(10076, voiceCallSession2.bearerAtStart, voiceCallSession2.bearerAtEnd, voiceCallSession2.direction, voiceCallSession2.setupDuration, voiceCallSession2.setupFailed, voiceCallSession2.disconnectReasonCode, voiceCallSession2.disconnectExtraCode, voiceCallSession2.disconnectExtraMessage, voiceCallSession2.ratAtStart, voiceCallSession2.ratAtEnd, voiceCallSession2.ratSwitchCount, voiceCallSession2.codecBitmask, voiceCallSession2.concurrentCallCountAtStart, voiceCallSession2.concurrentCallCountAtEnd, voiceCallSession2.simSlotIndex, voiceCallSession2.isMultiSim, voiceCallSession2.isEsim, voiceCallSession2.carrierId, voiceCallSession2.srvccCompleted, voiceCallSession2.srvccFailureCount, voiceCallSession2.srvccCancellationCount, voiceCallSession2.rttEnabled, voiceCallSession2.isEmergency, voiceCallSession2.isRoaming, sRandom.nextInt(), voiceCallSession2.signalStrengthAtEnd, voiceCallSession2.bandAtEnd, voiceCallSession2.setupDurationMillis, voiceCallSession2.mainCodecQuality, voiceCallSession2.videoEnabled, voiceCallSession2.ratAtConnected, voiceCallSession2.isMultiparty, voiceCallSession2.callDuration);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.IncomingSms incomingSms) {
        PersistAtomsProto.IncomingSms incomingSms2 = incomingSms;
        return TelephonyStatsLog.buildStatsEvent(10086, incomingSms2.smsFormat, incomingSms2.smsTech, incomingSms2.rat, incomingSms2.smsType, incomingSms2.totalParts, incomingSms2.receivedParts, incomingSms2.blocked, incomingSms2.error, incomingSms2.isRoaming, incomingSms2.simSlotIndex, incomingSms2.isMultiSim, incomingSms2.isEsim, incomingSms2.carrierId, incomingSms2.messageId);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.OutgoingSms outgoingSms) {
        PersistAtomsProto.OutgoingSms outgoingSms2 = outgoingSms;
        return TelephonyStatsLog.buildStatsEvent(10087, outgoingSms2.smsFormat, outgoingSms2.smsTech, outgoingSms2.rat, outgoingSms2.sendResult, outgoingSms2.errorCode, outgoingSms2.isRoaming, outgoingSms2.isFromDefaultApp, outgoingSms2.simSlotIndex, outgoingSms2.isMultiSim, outgoingSms2.isEsim, outgoingSms2.carrierId, outgoingSms2.messageId, outgoingSms2.retryId, outgoingSms2.intervalMillis);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.DataCallSession dataCallSession) {
        PersistAtomsProto.DataCallSession dataCallSession2 = dataCallSession;
        int i = dataCallSession2.dimension;
        boolean z = dataCallSession2.isMultiSim;
        return TelephonyStatsLog.buildStatsEvent(10089, i, z, dataCallSession2.isEsim, 0, dataCallSession2.apnTypeBitmask, dataCallSession2.carrierId, dataCallSession2.isRoaming, dataCallSession2.ratAtEnd, dataCallSession2.oosAtEnd, dataCallSession2.ratSwitchCount, dataCallSession2.isOpportunistic, dataCallSession2.ipType, dataCallSession2.setupFailed, dataCallSession2.failureCause, dataCallSession2.suggestedRetryMillis, dataCallSession2.deactivateReason, round(dataCallSession2.durationMinutes, MIN_CALLS_PER_BUCKET), dataCallSession2.ongoing, dataCallSession2.bandAtEnd, dataCallSession2.handoverFailureCauses);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.ImsRegistrationStats imsRegistrationStats) {
        PersistAtomsProto.ImsRegistrationStats imsRegistrationStats2 = imsRegistrationStats;
        return TelephonyStatsLog.buildStatsEvent(10094, imsRegistrationStats2.carrierId, imsRegistrationStats2.simSlotIndex, imsRegistrationStats2.rat, (int) (round(imsRegistrationStats2.registeredMillis, DURATION_BUCKET_MILLIS) / 1000), (int) (round(imsRegistrationStats2.voiceCapableMillis, DURATION_BUCKET_MILLIS) / 1000), (int) (round(imsRegistrationStats2.voiceAvailableMillis, DURATION_BUCKET_MILLIS) / 1000), (int) (round(imsRegistrationStats2.smsCapableMillis, DURATION_BUCKET_MILLIS) / 1000), (int) (round(imsRegistrationStats2.smsAvailableMillis, DURATION_BUCKET_MILLIS) / 1000), (int) (round(imsRegistrationStats2.videoCapableMillis, DURATION_BUCKET_MILLIS) / 1000), (int) (round(imsRegistrationStats2.videoAvailableMillis, DURATION_BUCKET_MILLIS) / 1000), (int) (round(imsRegistrationStats2.utCapableMillis, DURATION_BUCKET_MILLIS) / 1000), (int) (round(imsRegistrationStats2.utAvailableMillis, DURATION_BUCKET_MILLIS) / 1000));
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.ImsRegistrationTermination imsRegistrationTermination) {
        return TelephonyStatsLog.buildStatsEvent(10093, imsRegistrationTermination.carrierId, imsRegistrationTermination.isMultiSim, imsRegistrationTermination.ratAtEnd, imsRegistrationTermination.setupFailed, imsRegistrationTermination.reasonCode, imsRegistrationTermination.extraCode, imsRegistrationTermination.extraMessage, imsRegistrationTermination.count);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.NetworkRequestsV2 networkRequestsV2) {
        return TelephonyStatsLog.buildStatsEvent(10153, networkRequestsV2.carrierId, networkRequestsV2.capability, networkRequestsV2.requestCount);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats) {
        return TelephonyStatsLog.buildStatsEvent(10133, imsRegistrationFeatureTagStats.carrierId, imsRegistrationFeatureTagStats.slotId, imsRegistrationFeatureTagStats.featureTagName, imsRegistrationFeatureTagStats.registrationTech, (int) (round(imsRegistrationFeatureTagStats.registeredMillis, DURATION_BUCKET_MILLIS) / 1000));
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.RcsClientProvisioningStats rcsClientProvisioningStats) {
        return TelephonyStatsLog.buildStatsEvent(10134, rcsClientProvisioningStats.carrierId, rcsClientProvisioningStats.slotId, rcsClientProvisioningStats.event, rcsClientProvisioningStats.count);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats) {
        return TelephonyStatsLog.buildStatsEvent(10135, rcsAcsProvisioningStats.carrierId, rcsAcsProvisioningStats.slotId, rcsAcsProvisioningStats.responseCode, rcsAcsProvisioningStats.responseType, rcsAcsProvisioningStats.isSingleRegistrationEnabled, rcsAcsProvisioningStats.count, (int) (round(rcsAcsProvisioningStats.stateTimerMillis, DURATION_BUCKET_MILLIS) / 1000));
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.SipDelegateStats sipDelegateStats) {
        return TelephonyStatsLog.buildStatsEvent(10136, sipDelegateStats.dimension, sipDelegateStats.carrierId, sipDelegateStats.slotId, (int) (round(sipDelegateStats.uptimeMillis, DURATION_BUCKET_MILLIS) / 1000), sipDelegateStats.destroyReason);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.SipTransportFeatureTagStats sipTransportFeatureTagStats) {
        return TelephonyStatsLog.buildStatsEvent(10137, sipTransportFeatureTagStats.carrierId, sipTransportFeatureTagStats.slotId, sipTransportFeatureTagStats.featureTagName, sipTransportFeatureTagStats.sipTransportDeniedReason, sipTransportFeatureTagStats.sipTransportDeregisteredReason, (int) (round(sipTransportFeatureTagStats.associatedMillis, DURATION_BUCKET_MILLIS) / 1000));
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.SipMessageResponse sipMessageResponse) {
        return TelephonyStatsLog.buildStatsEvent(10138, sipMessageResponse.carrierId, sipMessageResponse.slotId, sipMessageResponse.sipMessageMethod, sipMessageResponse.sipMessageResponse, sipMessageResponse.sipMessageDirection, sipMessageResponse.messageError, sipMessageResponse.count);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.SipTransportSession sipTransportSession) {
        return TelephonyStatsLog.buildStatsEvent(10139, sipTransportSession.carrierId, sipTransportSession.slotId, sipTransportSession.sessionMethod, sipTransportSession.sipMessageDirection, sipTransportSession.sipResponse, sipTransportSession.sessionCount, sipTransportSession.endedGracefullyCount);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.ImsDedicatedBearerListenerEvent imsDedicatedBearerListenerEvent) {
        return TelephonyStatsLog.buildStatsEvent(10140, imsDedicatedBearerListenerEvent.carrierId, imsDedicatedBearerListenerEvent.slotId, imsDedicatedBearerListenerEvent.ratAtEnd, imsDedicatedBearerListenerEvent.qci, imsDedicatedBearerListenerEvent.dedicatedBearerEstablished, imsDedicatedBearerListenerEvent.eventCount);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.ImsDedicatedBearerEvent imsDedicatedBearerEvent) {
        return TelephonyStatsLog.buildStatsEvent(10141, imsDedicatedBearerEvent.carrierId, imsDedicatedBearerEvent.slotId, imsDedicatedBearerEvent.ratAtEnd, imsDedicatedBearerEvent.qci, imsDedicatedBearerEvent.bearerState, imsDedicatedBearerEvent.localConnectionInfoReceived, imsDedicatedBearerEvent.remoteConnectionInfoReceived, imsDedicatedBearerEvent.hasListeners, imsDedicatedBearerEvent.count);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.ImsRegistrationServiceDescStats imsRegistrationServiceDescStats) {
        return TelephonyStatsLog.buildStatsEvent(10142, imsRegistrationServiceDescStats.carrierId, imsRegistrationServiceDescStats.slotId, imsRegistrationServiceDescStats.serviceIdName, imsRegistrationServiceDescStats.serviceIdVersion, imsRegistrationServiceDescStats.registrationTech, (int) (round(imsRegistrationServiceDescStats.publishedMillis, DURATION_BUCKET_MILLIS) / 1000));
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.UceEventStats uceEventStats) {
        return TelephonyStatsLog.buildStatsEvent(10143, uceEventStats.carrierId, uceEventStats.slotId, uceEventStats.type, uceEventStats.successful, uceEventStats.commandCode, uceEventStats.networkResponse, uceEventStats.count);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.PresenceNotifyEvent presenceNotifyEvent) {
        return TelephonyStatsLog.buildStatsEvent(10144, presenceNotifyEvent.carrierId, presenceNotifyEvent.slotId, presenceNotifyEvent.reason, presenceNotifyEvent.contentBodyReceived, presenceNotifyEvent.rcsCapsCount, presenceNotifyEvent.mmtelCapsCount, presenceNotifyEvent.noCapsCount, presenceNotifyEvent.count);
    }

    private static StatsEvent buildStatsEvent(PersistAtomsProto.GbaEvent gbaEvent) {
        return TelephonyStatsLog.buildStatsEvent(10145, gbaEvent.carrierId, gbaEvent.slotId, gbaEvent.successful, gbaEvent.failedReason, gbaEvent.count);
    }

    private static Phone[] getPhonesIfAny() {
        try {
            return PhoneFactory.getPhones();
        } catch (IllegalStateException unused) {
            return new Phone[0];
        }
    }

    private static long round(long j, long j2) {
        return j2 == 0 ? j : ((j + (j2 / 2)) / j2) * j2;
    }
}
