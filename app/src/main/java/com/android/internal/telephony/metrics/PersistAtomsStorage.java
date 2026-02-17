package com.android.internal.telephony.metrics;

import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.internal.telephony.protobuf.nano.MessageNano;
import com.android.internal.util.ArrayUtils;
import com.android.telephony.Rlog;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.stream.IntStream;

public class PersistAtomsStorage {
    private static final String FILENAME = "persist_atoms.pb";
    private static final int SAVE_TO_FILE_DELAY_FOR_GET_MILLIS = 500;
    private static final int SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS = 30000;
    private static final String TAG = "PersistAtomsStorage";
    private static final SecureRandom sRandom = new SecureRandom();
    @VisibleForTesting
    protected final PersistAtomsProto.PersistAtoms mAtoms;
    private final Context mContext;
    private final Handler mHandler;
    private final HandlerThread mHandlerThread;
    private final int mMaxNumCarrierIdMismatches;
    private final int mMaxNumCellularDataSwitches;
    private final int mMaxNumCellularServiceStates;
    private final int mMaxNumDataCallSessions;
    private final int mMaxNumDedicatedBearerEventStats;
    private final int mMaxNumDedicatedBearerListenerEventStats;
    private final int mMaxNumGbaEventStats;
    private final int mMaxNumImsRegistrationFeatureStats;
    private final int mMaxNumImsRegistrationServiceDescStats;
    private final int mMaxNumImsRegistrationStats;
    private final int mMaxNumImsRegistrationTerminations;
    private final int mMaxNumPresenceNotifyEventStats;
    private final int mMaxNumRcsAcsProvisioningStats;
    private final int mMaxNumRcsClientProvisioningStats;
    private final int mMaxNumSipDelegateStats;
    private final int mMaxNumSipMessageResponseStats;
    private final int mMaxNumSipTransportFeatureTagStats;
    private final int mMaxNumSipTransportSessionStats;
    private final int mMaxNumSms;
    private final int mMaxNumUceEventStats;
    private final int mMaxNumVoiceCallSessions;
    @VisibleForTesting
    protected boolean mSaveImmediately;
    private Runnable mSaveRunnable = new Runnable() {
        public void run() {
            PersistAtomsStorage.this.saveAtomsToFileNow();
        }
    };
    private final VoiceCallRatTracker mVoiceCallRatTracker;

    public PersistAtomsStorage(Context context) {
        this.mContext = context;
        if (context.getPackageManager().hasSystemFeature("android.hardware.ram.low")) {
            Rlog.i(TAG, "Low RAM device");
            this.mMaxNumVoiceCallSessions = 10;
            this.mMaxNumSms = 5;
            this.mMaxNumCarrierIdMismatches = 8;
            this.mMaxNumDataCallSessions = 5;
            this.mMaxNumCellularServiceStates = 10;
            this.mMaxNumCellularDataSwitches = 5;
            this.mMaxNumImsRegistrationStats = 5;
            this.mMaxNumImsRegistrationTerminations = 5;
            this.mMaxNumImsRegistrationFeatureStats = 15;
            this.mMaxNumRcsClientProvisioningStats = 5;
            this.mMaxNumRcsAcsProvisioningStats = 5;
            this.mMaxNumSipMessageResponseStats = 10;
            this.mMaxNumSipTransportSessionStats = 10;
            this.mMaxNumSipDelegateStats = 5;
            this.mMaxNumSipTransportFeatureTagStats = 15;
            this.mMaxNumDedicatedBearerListenerEventStats = 5;
            this.mMaxNumDedicatedBearerEventStats = 5;
            this.mMaxNumImsRegistrationServiceDescStats = 15;
            this.mMaxNumUceEventStats = 5;
            this.mMaxNumPresenceNotifyEventStats = 10;
            this.mMaxNumGbaEventStats = 5;
        } else {
            this.mMaxNumVoiceCallSessions = 50;
            this.mMaxNumSms = 25;
            this.mMaxNumCarrierIdMismatches = 40;
            this.mMaxNumDataCallSessions = 15;
            this.mMaxNumCellularServiceStates = 50;
            this.mMaxNumCellularDataSwitches = 50;
            this.mMaxNumImsRegistrationStats = 10;
            this.mMaxNumImsRegistrationTerminations = 10;
            this.mMaxNumImsRegistrationFeatureStats = 25;
            this.mMaxNumRcsClientProvisioningStats = 10;
            this.mMaxNumRcsAcsProvisioningStats = 10;
            this.mMaxNumSipMessageResponseStats = 25;
            this.mMaxNumSipTransportSessionStats = 25;
            this.mMaxNumSipDelegateStats = 10;
            this.mMaxNumSipTransportFeatureTagStats = 25;
            this.mMaxNumDedicatedBearerListenerEventStats = 10;
            this.mMaxNumDedicatedBearerEventStats = 10;
            this.mMaxNumImsRegistrationServiceDescStats = 25;
            this.mMaxNumUceEventStats = 25;
            this.mMaxNumPresenceNotifyEventStats = 50;
            this.mMaxNumGbaEventStats = 10;
        }
        PersistAtomsProto.PersistAtoms loadAtomsFromFile = loadAtomsFromFile();
        this.mAtoms = loadAtomsFromFile;
        this.mVoiceCallRatTracker = VoiceCallRatTracker.fromProto(loadAtomsFromFile.voiceCallRatUsage);
        HandlerThread handlerThread = new HandlerThread("PersistAtomsThread");
        this.mHandlerThread = handlerThread;
        handlerThread.start();
        this.mHandler = new Handler(handlerThread.getLooper());
        this.mSaveImmediately = false;
    }

    public synchronized void addVoiceCallSession(PersistAtomsProto.VoiceCallSession voiceCallSession) {
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        persistAtoms.voiceCallSession = (PersistAtomsProto.VoiceCallSession[]) insertAtRandomPlace(persistAtoms.voiceCallSession, voiceCallSession, this.mMaxNumVoiceCallSessions);
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
        String str = TAG;
        Rlog.d(str, "Add new voice call session: " + voiceCallSession.toString());
    }

    public synchronized void addVoiceCallRatUsage(VoiceCallRatTracker voiceCallRatTracker) {
        this.mVoiceCallRatTracker.mergeWith(voiceCallRatTracker);
        this.mAtoms.voiceCallRatUsage = this.mVoiceCallRatTracker.toProto();
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addIncomingSms(PersistAtomsProto.IncomingSms incomingSms) {
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        persistAtoms.incomingSms = (PersistAtomsProto.IncomingSms[]) insertAtRandomPlace(persistAtoms.incomingSms, incomingSms, this.mMaxNumSms);
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
        String str = TAG;
        Rlog.d(str, "Add new incoming SMS atom: " + incomingSms.toString());
    }

    public synchronized void addOutgoingSms(PersistAtomsProto.OutgoingSms outgoingSms) {
        int i;
        for (PersistAtomsProto.OutgoingSms outgoingSms2 : this.mAtoms.outgoingSms) {
            if (outgoingSms2.messageId == outgoingSms.messageId && (i = outgoingSms2.retryId) >= outgoingSms.retryId) {
                outgoingSms.retryId = i + 1;
            }
        }
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        persistAtoms.outgoingSms = (PersistAtomsProto.OutgoingSms[]) insertAtRandomPlace(persistAtoms.outgoingSms, outgoingSms, this.mMaxNumSms);
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
        Rlog.d(TAG, "Add new outgoing SMS atom: " + outgoingSms.toString());
    }

    public synchronized void addCellularServiceStateAndCellularDataServiceSwitch(PersistAtomsProto.CellularServiceState cellularServiceState, PersistAtomsProto.CellularDataServiceSwitch cellularDataServiceSwitch) {
        PersistAtomsProto.CellularServiceState find = find(cellularServiceState);
        if (find != null) {
            find.totalTimeMillis += cellularServiceState.totalTimeMillis;
            find.lastUsedMillis = getWallTimeMillis();
        } else {
            cellularServiceState.lastUsedMillis = getWallTimeMillis();
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.cellularServiceState = (PersistAtomsProto.CellularServiceState[]) insertAtRandomPlace(persistAtoms.cellularServiceState, cellularServiceState, this.mMaxNumCellularServiceStates);
        }
        if (cellularDataServiceSwitch != null) {
            PersistAtomsProto.CellularDataServiceSwitch find2 = find(cellularDataServiceSwitch);
            if (find2 != null) {
                find2.switchCount += cellularDataServiceSwitch.switchCount;
                find2.lastUsedMillis = getWallTimeMillis();
            } else {
                cellularDataServiceSwitch.lastUsedMillis = getWallTimeMillis();
                PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
                persistAtoms2.cellularDataServiceSwitch = (PersistAtomsProto.CellularDataServiceSwitch[]) insertAtRandomPlace(persistAtoms2.cellularDataServiceSwitch, cellularDataServiceSwitch, this.mMaxNumCellularDataSwitches);
            }
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addDataCallSession(PersistAtomsProto.DataCallSession dataCallSession) {
        int findIndex = findIndex(dataCallSession);
        if (findIndex >= 0) {
            PersistAtomsProto.DataCallSession[] dataCallSessionArr = this.mAtoms.dataCallSession;
            PersistAtomsProto.DataCallSession dataCallSession2 = dataCallSessionArr[findIndex];
            dataCallSession.ratSwitchCount += dataCallSession2.ratSwitchCount;
            dataCallSession.durationMinutes += dataCallSession2.durationMinutes;
            dataCallSessionArr[findIndex] = dataCallSession;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.dataCallSession = (PersistAtomsProto.DataCallSession[]) insertAtRandomPlace(persistAtoms.dataCallSession, dataCallSession, this.mMaxNumDataCallSessions);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized boolean addCarrierIdMismatch(PersistAtomsProto.CarrierIdMismatch carrierIdMismatch) {
        if (find(carrierIdMismatch) != null) {
            return false;
        }
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        PersistAtomsProto.CarrierIdMismatch[] carrierIdMismatchArr = persistAtoms.carrierIdMismatch;
        int length = carrierIdMismatchArr.length;
        int i = this.mMaxNumCarrierIdMismatches;
        if (length == i) {
            System.arraycopy(carrierIdMismatchArr, 1, carrierIdMismatchArr, 0, i - 1);
            this.mAtoms.carrierIdMismatch[this.mMaxNumCarrierIdMismatches - 1] = carrierIdMismatch;
        } else {
            int length2 = carrierIdMismatchArr.length + 1;
            persistAtoms.carrierIdMismatch = (PersistAtomsProto.CarrierIdMismatch[]) Arrays.copyOf(carrierIdMismatchArr, length2);
            this.mAtoms.carrierIdMismatch[length2 - 1] = carrierIdMismatch;
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
        return true;
    }

    public synchronized void addImsRegistrationStats(PersistAtomsProto.ImsRegistrationStats imsRegistrationStats) {
        PersistAtomsProto.ImsRegistrationStats find = find(imsRegistrationStats);
        if (find != null) {
            find.registeredMillis += imsRegistrationStats.registeredMillis;
            find.voiceCapableMillis += imsRegistrationStats.voiceCapableMillis;
            find.voiceAvailableMillis += imsRegistrationStats.voiceAvailableMillis;
            find.smsCapableMillis += imsRegistrationStats.smsCapableMillis;
            find.smsAvailableMillis += imsRegistrationStats.smsAvailableMillis;
            find.videoCapableMillis += imsRegistrationStats.videoCapableMillis;
            find.videoAvailableMillis += imsRegistrationStats.videoAvailableMillis;
            find.utCapableMillis += imsRegistrationStats.utCapableMillis;
            find.utAvailableMillis += imsRegistrationStats.utAvailableMillis;
            find.lastUsedMillis = getWallTimeMillis();
        } else {
            imsRegistrationStats.lastUsedMillis = getWallTimeMillis();
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.imsRegistrationStats = (PersistAtomsProto.ImsRegistrationStats[]) insertAtRandomPlace(persistAtoms.imsRegistrationStats, imsRegistrationStats, this.mMaxNumImsRegistrationStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addImsRegistrationTermination(PersistAtomsProto.ImsRegistrationTermination imsRegistrationTermination) {
        PersistAtomsProto.ImsRegistrationTermination find = find(imsRegistrationTermination);
        if (find != null) {
            find.count += imsRegistrationTermination.count;
            find.lastUsedMillis = getWallTimeMillis();
        } else {
            imsRegistrationTermination.lastUsedMillis = getWallTimeMillis();
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.imsRegistrationTermination = (PersistAtomsProto.ImsRegistrationTermination[]) insertAtRandomPlace(persistAtoms.imsRegistrationTermination, imsRegistrationTermination, this.mMaxNumImsRegistrationTerminations);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized boolean setCarrierIdTableVersion(int i) {
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (persistAtoms.carrierIdTableVersion >= i) {
            return false;
        }
        persistAtoms.carrierIdTableVersion = i;
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
        return true;
    }

    public synchronized void addNetworkRequestsV2(PersistAtomsProto.NetworkRequestsV2 networkRequestsV2) {
        PersistAtomsProto.NetworkRequestsV2 find = find(networkRequestsV2);
        if (find != null) {
            find.requestCount += networkRequestsV2.requestCount;
        } else {
            PersistAtomsProto.NetworkRequestsV2 networkRequestsV22 = new PersistAtomsProto.NetworkRequestsV2();
            networkRequestsV22.capability = networkRequestsV2.capability;
            networkRequestsV22.carrierId = networkRequestsV2.carrierId;
            networkRequestsV22.requestCount = networkRequestsV2.requestCount;
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            PersistAtomsProto.NetworkRequestsV2[] networkRequestsV2Arr = persistAtoms.networkRequestsV2;
            int length = networkRequestsV2Arr.length + 1;
            persistAtoms.networkRequestsV2 = (PersistAtomsProto.NetworkRequestsV2[]) Arrays.copyOf(networkRequestsV2Arr, length);
            this.mAtoms.networkRequestsV2[length - 1] = networkRequestsV22;
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addImsRegistrationFeatureTagStats(PersistAtomsProto.ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats) {
        PersistAtomsProto.ImsRegistrationFeatureTagStats find = find(imsRegistrationFeatureTagStats);
        if (find != null) {
            find.registeredMillis += imsRegistrationFeatureTagStats.registeredMillis;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.imsRegistrationFeatureTagStats = (PersistAtomsProto.ImsRegistrationFeatureTagStats[]) insertAtRandomPlace(persistAtoms.imsRegistrationFeatureTagStats, imsRegistrationFeatureTagStats, this.mMaxNumImsRegistrationFeatureStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addRcsClientProvisioningStats(PersistAtomsProto.RcsClientProvisioningStats rcsClientProvisioningStats) {
        PersistAtomsProto.RcsClientProvisioningStats find = find(rcsClientProvisioningStats);
        if (find != null) {
            find.count++;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.rcsClientProvisioningStats = (PersistAtomsProto.RcsClientProvisioningStats[]) insertAtRandomPlace(persistAtoms.rcsClientProvisioningStats, rcsClientProvisioningStats, this.mMaxNumRcsClientProvisioningStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addRcsAcsProvisioningStats(PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats) {
        PersistAtomsProto.RcsAcsProvisioningStats find = find(rcsAcsProvisioningStats);
        if (find != null) {
            find.count++;
            find.stateTimerMillis += rcsAcsProvisioningStats.stateTimerMillis;
        } else {
            rcsAcsProvisioningStats.count = 1;
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.rcsAcsProvisioningStats = (PersistAtomsProto.RcsAcsProvisioningStats[]) insertAtRandomPlace(persistAtoms.rcsAcsProvisioningStats, rcsAcsProvisioningStats, this.mMaxNumRcsAcsProvisioningStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addSipDelegateStats(PersistAtomsProto.SipDelegateStats sipDelegateStats) {
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        persistAtoms.sipDelegateStats = (PersistAtomsProto.SipDelegateStats[]) insertAtRandomPlace(persistAtoms.sipDelegateStats, sipDelegateStats, this.mMaxNumSipDelegateStats);
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addSipTransportFeatureTagStats(PersistAtomsProto.SipTransportFeatureTagStats sipTransportFeatureTagStats) {
        PersistAtomsProto.SipTransportFeatureTagStats find = find(sipTransportFeatureTagStats);
        if (find != null) {
            find.associatedMillis += sipTransportFeatureTagStats.associatedMillis;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.sipTransportFeatureTagStats = (PersistAtomsProto.SipTransportFeatureTagStats[]) insertAtRandomPlace(persistAtoms.sipTransportFeatureTagStats, sipTransportFeatureTagStats, this.mMaxNumSipTransportFeatureTagStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addSipMessageResponse(PersistAtomsProto.SipMessageResponse sipMessageResponse) {
        PersistAtomsProto.SipMessageResponse find = find(sipMessageResponse);
        if (find != null) {
            find.count++;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.sipMessageResponse = (PersistAtomsProto.SipMessageResponse[]) insertAtRandomPlace(persistAtoms.sipMessageResponse, sipMessageResponse, this.mMaxNumSipMessageResponseStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addCompleteSipTransportSession(PersistAtomsProto.SipTransportSession sipTransportSession) {
        PersistAtomsProto.SipTransportSession find = find(sipTransportSession);
        if (find != null) {
            find.sessionCount++;
            if (sipTransportSession.isEndedGracefully) {
                find.endedGracefullyCount++;
            }
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.sipTransportSession = (PersistAtomsProto.SipTransportSession[]) insertAtRandomPlace(persistAtoms.sipTransportSession, sipTransportSession, this.mMaxNumSipTransportSessionStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addImsDedicatedBearerListenerEvent(PersistAtomsProto.ImsDedicatedBearerListenerEvent imsDedicatedBearerListenerEvent) {
        PersistAtomsProto.ImsDedicatedBearerListenerEvent find = find(imsDedicatedBearerListenerEvent);
        if (find != null) {
            find.eventCount++;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.imsDedicatedBearerListenerEvent = (PersistAtomsProto.ImsDedicatedBearerListenerEvent[]) insertAtRandomPlace(persistAtoms.imsDedicatedBearerListenerEvent, imsDedicatedBearerListenerEvent, this.mMaxNumDedicatedBearerListenerEventStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addImsDedicatedBearerEvent(PersistAtomsProto.ImsDedicatedBearerEvent imsDedicatedBearerEvent) {
        PersistAtomsProto.ImsDedicatedBearerEvent find = find(imsDedicatedBearerEvent);
        if (find != null) {
            find.count++;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.imsDedicatedBearerEvent = (PersistAtomsProto.ImsDedicatedBearerEvent[]) insertAtRandomPlace(persistAtoms.imsDedicatedBearerEvent, imsDedicatedBearerEvent, this.mMaxNumDedicatedBearerEventStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addImsRegistrationServiceDescStats(PersistAtomsProto.ImsRegistrationServiceDescStats imsRegistrationServiceDescStats) {
        PersistAtomsProto.ImsRegistrationServiceDescStats find = find(imsRegistrationServiceDescStats);
        if (find != null) {
            find.publishedMillis += imsRegistrationServiceDescStats.publishedMillis;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.imsRegistrationServiceDescStats = (PersistAtomsProto.ImsRegistrationServiceDescStats[]) insertAtRandomPlace(persistAtoms.imsRegistrationServiceDescStats, imsRegistrationServiceDescStats, this.mMaxNumImsRegistrationServiceDescStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addUceEventStats(PersistAtomsProto.UceEventStats uceEventStats) {
        PersistAtomsProto.UceEventStats find = find(uceEventStats);
        if (find != null) {
            find.count++;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.uceEventStats = (PersistAtomsProto.UceEventStats[]) insertAtRandomPlace(persistAtoms.uceEventStats, uceEventStats, this.mMaxNumUceEventStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addPresenceNotifyEvent(PersistAtomsProto.PresenceNotifyEvent presenceNotifyEvent) {
        PersistAtomsProto.PresenceNotifyEvent find = find(presenceNotifyEvent);
        if (find != null) {
            find.rcsCapsCount += presenceNotifyEvent.rcsCapsCount;
            find.mmtelCapsCount += presenceNotifyEvent.mmtelCapsCount;
            find.noCapsCount += presenceNotifyEvent.noCapsCount;
            find.count += presenceNotifyEvent.count;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.presenceNotifyEvent = (PersistAtomsProto.PresenceNotifyEvent[]) insertAtRandomPlace(persistAtoms.presenceNotifyEvent, presenceNotifyEvent, this.mMaxNumPresenceNotifyEventStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized void addGbaEvent(PersistAtomsProto.GbaEvent gbaEvent) {
        PersistAtomsProto.GbaEvent find = find(gbaEvent);
        if (find != null) {
            find.count++;
        } else {
            PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
            persistAtoms.gbaEvent = (PersistAtomsProto.GbaEvent[]) insertAtRandomPlace(persistAtoms.gbaEvent, gbaEvent, this.mMaxNumGbaEventStats);
        }
        saveAtomsToFile(SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS);
    }

    public synchronized PersistAtomsProto.VoiceCallSession[] getVoiceCallSessions(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.voiceCallSessionPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.voiceCallSessionPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.VoiceCallSession[] voiceCallSessionArr = persistAtoms2.voiceCallSession;
        persistAtoms2.voiceCallSession = new PersistAtomsProto.VoiceCallSession[0];
        saveAtomsToFile(500);
        return voiceCallSessionArr;
    }

    public synchronized PersistAtomsProto.VoiceCallRatUsage[] getVoiceCallRatUsages(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.voiceCallRatUsagePullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.voiceCallRatUsagePullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.VoiceCallRatUsage[] voiceCallRatUsageArr = this.mAtoms.voiceCallRatUsage;
        this.mVoiceCallRatTracker.clear();
        this.mAtoms.voiceCallRatUsage = new PersistAtomsProto.VoiceCallRatUsage[0];
        saveAtomsToFile(500);
        return voiceCallRatUsageArr;
    }

    public synchronized PersistAtomsProto.IncomingSms[] getIncomingSms(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.incomingSmsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.incomingSmsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.IncomingSms[] incomingSmsArr = persistAtoms2.incomingSms;
        persistAtoms2.incomingSms = new PersistAtomsProto.IncomingSms[0];
        saveAtomsToFile(500);
        return incomingSmsArr;
    }

    public synchronized PersistAtomsProto.OutgoingSms[] getOutgoingSms(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.outgoingSmsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.outgoingSmsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.OutgoingSms[] outgoingSmsArr = persistAtoms2.outgoingSms;
        persistAtoms2.outgoingSms = new PersistAtomsProto.OutgoingSms[0];
        saveAtomsToFile(500);
        return outgoingSmsArr;
    }

    public synchronized PersistAtomsProto.DataCallSession[] getDataCallSessions(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.dataCallSessionPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.dataCallSessionPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.DataCallSession[] dataCallSessionArr = persistAtoms2.dataCallSession;
        persistAtoms2.dataCallSession = new PersistAtomsProto.DataCallSession[0];
        saveAtomsToFile(500);
        for (PersistAtomsProto.DataCallSession dataCallSession : dataCallSessionArr) {
            Arrays.sort(dataCallSession.handoverFailureCauses);
        }
        return dataCallSessionArr;
    }

    public synchronized PersistAtomsProto.CellularServiceState[] getCellularServiceStates(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.cellularServiceStatePullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.cellularServiceStatePullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.CellularServiceState[] cellularServiceStateArr = this.mAtoms.cellularServiceState;
        Arrays.stream(cellularServiceStateArr).forEach(new PersistAtomsStorage$$ExternalSyntheticLambda2());
        this.mAtoms.cellularServiceState = new PersistAtomsProto.CellularServiceState[0];
        saveAtomsToFile(500);
        return cellularServiceStateArr;
    }

    public synchronized PersistAtomsProto.CellularDataServiceSwitch[] getCellularDataServiceSwitches(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.cellularDataServiceSwitchPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.cellularDataServiceSwitchPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.CellularDataServiceSwitch[] cellularDataServiceSwitchArr = this.mAtoms.cellularDataServiceSwitch;
        Arrays.stream(cellularDataServiceSwitchArr).forEach(new PersistAtomsStorage$$ExternalSyntheticLambda1());
        this.mAtoms.cellularDataServiceSwitch = new PersistAtomsProto.CellularDataServiceSwitch[0];
        saveAtomsToFile(500);
        return cellularDataServiceSwitchArr;
    }

    public synchronized PersistAtomsProto.ImsRegistrationStats[] getImsRegistrationStats(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        long j2 = wallTimeMillis - persistAtoms.imsRegistrationStatsPullTimestampMillis;
        if (j2 <= j) {
            return null;
        }
        persistAtoms.imsRegistrationStatsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.ImsRegistrationStats[] imsRegistrationStatsArr = this.mAtoms.imsRegistrationStats;
        Arrays.stream(imsRegistrationStatsArr).forEach(new PersistAtomsStorage$$ExternalSyntheticLambda8());
        this.mAtoms.imsRegistrationStats = new PersistAtomsProto.ImsRegistrationStats[0];
        saveAtomsToFile(500);
        return normalizeData(imsRegistrationStatsArr, j2);
    }

    public synchronized PersistAtomsProto.ImsRegistrationTermination[] getImsRegistrationTerminations(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.imsRegistrationTerminationPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.imsRegistrationTerminationPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.ImsRegistrationTermination[] imsRegistrationTerminationArr = this.mAtoms.imsRegistrationTermination;
        Arrays.stream(imsRegistrationTerminationArr).forEach(new PersistAtomsStorage$$ExternalSyntheticLambda0());
        this.mAtoms.imsRegistrationTermination = new PersistAtomsProto.ImsRegistrationTermination[0];
        saveAtomsToFile(500);
        return imsRegistrationTerminationArr;
    }

    public synchronized PersistAtomsProto.NetworkRequestsV2[] getNetworkRequestsV2(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.networkRequestsV2PullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.networkRequestsV2PullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.NetworkRequestsV2[] networkRequestsV2Arr = persistAtoms2.networkRequestsV2;
        persistAtoms2.networkRequestsV2 = new PersistAtomsProto.NetworkRequestsV2[0];
        saveAtomsToFile(500);
        return networkRequestsV2Arr;
    }

    public synchronized PersistAtomsProto.ImsRegistrationFeatureTagStats[] getImsRegistrationFeatureTagStats(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.imsRegistrationFeatureTagStatsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.imsRegistrationFeatureTagStatsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStatsArr = persistAtoms2.imsRegistrationFeatureTagStats;
        persistAtoms2.imsRegistrationFeatureTagStats = new PersistAtomsProto.ImsRegistrationFeatureTagStats[0];
        saveAtomsToFile(500);
        return imsRegistrationFeatureTagStatsArr;
    }

    public synchronized PersistAtomsProto.RcsClientProvisioningStats[] getRcsClientProvisioningStats(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.rcsClientProvisioningStatsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.rcsClientProvisioningStatsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.RcsClientProvisioningStats[] rcsClientProvisioningStatsArr = persistAtoms2.rcsClientProvisioningStats;
        persistAtoms2.rcsClientProvisioningStats = new PersistAtomsProto.RcsClientProvisioningStats[0];
        saveAtomsToFile(500);
        return rcsClientProvisioningStatsArr;
    }

    public synchronized PersistAtomsProto.RcsAcsProvisioningStats[] getRcsAcsProvisioningStats(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.rcsAcsProvisioningStatsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.rcsAcsProvisioningStatsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.RcsAcsProvisioningStats[] rcsAcsProvisioningStatsArr = persistAtoms2.rcsAcsProvisioningStats;
        persistAtoms2.rcsAcsProvisioningStats = new PersistAtomsProto.RcsAcsProvisioningStats[0];
        saveAtomsToFile(500);
        return rcsAcsProvisioningStatsArr;
    }

    public synchronized PersistAtomsProto.SipDelegateStats[] getSipDelegateStats(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.sipDelegateStatsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.sipDelegateStatsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.SipDelegateStats[] sipDelegateStatsArr = persistAtoms2.sipDelegateStats;
        persistAtoms2.sipDelegateStats = new PersistAtomsProto.SipDelegateStats[0];
        saveAtomsToFile(500);
        return sipDelegateStatsArr;
    }

    public synchronized PersistAtomsProto.SipTransportFeatureTagStats[] getSipTransportFeatureTagStats(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.sipTransportFeatureTagStatsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.sipTransportFeatureTagStatsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.SipTransportFeatureTagStats[] sipTransportFeatureTagStatsArr = persistAtoms2.sipTransportFeatureTagStats;
        persistAtoms2.sipTransportFeatureTagStats = new PersistAtomsProto.SipTransportFeatureTagStats[0];
        saveAtomsToFile(500);
        return sipTransportFeatureTagStatsArr;
    }

    public synchronized PersistAtomsProto.SipMessageResponse[] getSipMessageResponse(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.sipMessageResponsePullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.sipMessageResponsePullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.SipMessageResponse[] sipMessageResponseArr = persistAtoms2.sipMessageResponse;
        persistAtoms2.sipMessageResponse = new PersistAtomsProto.SipMessageResponse[0];
        saveAtomsToFile(500);
        return sipMessageResponseArr;
    }

    public synchronized PersistAtomsProto.SipTransportSession[] getSipTransportSession(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.sipTransportSessionPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.sipTransportSessionPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.SipTransportSession[] sipTransportSessionArr = persistAtoms2.sipTransportSession;
        persistAtoms2.sipTransportSession = new PersistAtomsProto.SipTransportSession[0];
        saveAtomsToFile(500);
        return sipTransportSessionArr;
    }

    public synchronized PersistAtomsProto.ImsDedicatedBearerListenerEvent[] getImsDedicatedBearerListenerEvent(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.imsDedicatedBearerListenerEventPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.imsDedicatedBearerListenerEventPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEventArr = persistAtoms2.imsDedicatedBearerListenerEvent;
        persistAtoms2.imsDedicatedBearerListenerEvent = new PersistAtomsProto.ImsDedicatedBearerListenerEvent[0];
        saveAtomsToFile(500);
        return imsDedicatedBearerListenerEventArr;
    }

    public synchronized PersistAtomsProto.ImsDedicatedBearerEvent[] getImsDedicatedBearerEvent(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.imsDedicatedBearerEventPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.imsDedicatedBearerEventPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.ImsDedicatedBearerEvent[] imsDedicatedBearerEventArr = persistAtoms2.imsDedicatedBearerEvent;
        persistAtoms2.imsDedicatedBearerEvent = new PersistAtomsProto.ImsDedicatedBearerEvent[0];
        saveAtomsToFile(500);
        return imsDedicatedBearerEventArr;
    }

    public synchronized PersistAtomsProto.ImsRegistrationServiceDescStats[] getImsRegistrationServiceDescStats(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.imsRegistrationServiceDescStatsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.imsRegistrationServiceDescStatsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStatsArr = persistAtoms2.imsRegistrationServiceDescStats;
        persistAtoms2.imsRegistrationServiceDescStats = new PersistAtomsProto.ImsRegistrationServiceDescStats[0];
        saveAtomsToFile(500);
        return imsRegistrationServiceDescStatsArr;
    }

    public synchronized PersistAtomsProto.UceEventStats[] getUceEventStats(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.uceEventStatsPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.uceEventStatsPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.UceEventStats[] uceEventStatsArr = persistAtoms2.uceEventStats;
        persistAtoms2.uceEventStats = new PersistAtomsProto.UceEventStats[0];
        saveAtomsToFile(500);
        return uceEventStatsArr;
    }

    public synchronized PersistAtomsProto.PresenceNotifyEvent[] getPresenceNotifyEvent(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.presenceNotifyEventPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.presenceNotifyEventPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.PresenceNotifyEvent[] presenceNotifyEventArr = persistAtoms2.presenceNotifyEvent;
        persistAtoms2.presenceNotifyEvent = new PersistAtomsProto.PresenceNotifyEvent[0];
        saveAtomsToFile(500);
        return presenceNotifyEventArr;
    }

    public synchronized PersistAtomsProto.GbaEvent[] getGbaEvent(long j) {
        long wallTimeMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms = this.mAtoms;
        if (wallTimeMillis - persistAtoms.gbaEventPullTimestampMillis <= j) {
            return null;
        }
        persistAtoms.gbaEventPullTimestampMillis = getWallTimeMillis();
        PersistAtomsProto.PersistAtoms persistAtoms2 = this.mAtoms;
        PersistAtomsProto.GbaEvent[] gbaEventArr = persistAtoms2.gbaEvent;
        persistAtoms2.gbaEvent = new PersistAtomsProto.GbaEvent[0];
        saveAtomsToFile(500);
        return gbaEventArr;
    }

    public void flushAtoms() {
        if (this.mHandler.hasCallbacks(this.mSaveRunnable)) {
            this.mHandler.removeCallbacks(this.mSaveRunnable);
            saveAtomsToFileNow();
        }
    }

    private PersistAtomsProto.PersistAtoms loadAtomsFromFile() {
        try {
            PersistAtomsProto.PersistAtoms parseFrom = PersistAtomsProto.PersistAtoms.parseFrom(Files.readAllBytes(this.mContext.getFileStreamPath(FILENAME).toPath()));
            if (!Build.FINGERPRINT.equals(parseFrom.buildFingerprint)) {
                Rlog.d(TAG, "Build changed");
                return makeNewPersistAtoms();
            }
            parseFrom.voiceCallRatUsage = (PersistAtomsProto.VoiceCallRatUsage[]) sanitizeAtoms(parseFrom.voiceCallRatUsage, PersistAtomsProto.VoiceCallRatUsage.class);
            parseFrom.voiceCallSession = (PersistAtomsProto.VoiceCallSession[]) sanitizeAtoms(parseFrom.voiceCallSession, PersistAtomsProto.VoiceCallSession.class, this.mMaxNumVoiceCallSessions);
            parseFrom.incomingSms = (PersistAtomsProto.IncomingSms[]) sanitizeAtoms(parseFrom.incomingSms, PersistAtomsProto.IncomingSms.class, this.mMaxNumSms);
            parseFrom.outgoingSms = (PersistAtomsProto.OutgoingSms[]) sanitizeAtoms(parseFrom.outgoingSms, PersistAtomsProto.OutgoingSms.class, this.mMaxNumSms);
            parseFrom.carrierIdMismatch = (PersistAtomsProto.CarrierIdMismatch[]) sanitizeAtoms(parseFrom.carrierIdMismatch, PersistAtomsProto.CarrierIdMismatch.class, this.mMaxNumCarrierIdMismatches);
            parseFrom.dataCallSession = (PersistAtomsProto.DataCallSession[]) sanitizeAtoms(parseFrom.dataCallSession, PersistAtomsProto.DataCallSession.class, this.mMaxNumDataCallSessions);
            parseFrom.cellularServiceState = (PersistAtomsProto.CellularServiceState[]) sanitizeAtoms(parseFrom.cellularServiceState, PersistAtomsProto.CellularServiceState.class, this.mMaxNumCellularServiceStates);
            parseFrom.cellularDataServiceSwitch = (PersistAtomsProto.CellularDataServiceSwitch[]) sanitizeAtoms(parseFrom.cellularDataServiceSwitch, PersistAtomsProto.CellularDataServiceSwitch.class, this.mMaxNumCellularDataSwitches);
            parseFrom.imsRegistrationStats = (PersistAtomsProto.ImsRegistrationStats[]) sanitizeAtoms(parseFrom.imsRegistrationStats, PersistAtomsProto.ImsRegistrationStats.class, this.mMaxNumImsRegistrationStats);
            parseFrom.imsRegistrationTermination = (PersistAtomsProto.ImsRegistrationTermination[]) sanitizeAtoms(parseFrom.imsRegistrationTermination, PersistAtomsProto.ImsRegistrationTermination.class, this.mMaxNumImsRegistrationTerminations);
            parseFrom.networkRequestsV2 = (PersistAtomsProto.NetworkRequestsV2[]) sanitizeAtoms(parseFrom.networkRequestsV2, PersistAtomsProto.NetworkRequestsV2.class);
            parseFrom.imsRegistrationFeatureTagStats = (PersistAtomsProto.ImsRegistrationFeatureTagStats[]) sanitizeAtoms(parseFrom.imsRegistrationFeatureTagStats, PersistAtomsProto.ImsRegistrationFeatureTagStats.class, this.mMaxNumImsRegistrationFeatureStats);
            parseFrom.rcsClientProvisioningStats = (PersistAtomsProto.RcsClientProvisioningStats[]) sanitizeAtoms(parseFrom.rcsClientProvisioningStats, PersistAtomsProto.RcsClientProvisioningStats.class, this.mMaxNumRcsClientProvisioningStats);
            parseFrom.rcsAcsProvisioningStats = (PersistAtomsProto.RcsAcsProvisioningStats[]) sanitizeAtoms(parseFrom.rcsAcsProvisioningStats, PersistAtomsProto.RcsAcsProvisioningStats.class, this.mMaxNumRcsAcsProvisioningStats);
            parseFrom.sipDelegateStats = (PersistAtomsProto.SipDelegateStats[]) sanitizeAtoms(parseFrom.sipDelegateStats, PersistAtomsProto.SipDelegateStats.class, this.mMaxNumSipDelegateStats);
            parseFrom.sipTransportFeatureTagStats = (PersistAtomsProto.SipTransportFeatureTagStats[]) sanitizeAtoms(parseFrom.sipTransportFeatureTagStats, PersistAtomsProto.SipTransportFeatureTagStats.class, this.mMaxNumSipTransportFeatureTagStats);
            parseFrom.sipMessageResponse = (PersistAtomsProto.SipMessageResponse[]) sanitizeAtoms(parseFrom.sipMessageResponse, PersistAtomsProto.SipMessageResponse.class, this.mMaxNumSipMessageResponseStats);
            parseFrom.sipTransportSession = (PersistAtomsProto.SipTransportSession[]) sanitizeAtoms(parseFrom.sipTransportSession, PersistAtomsProto.SipTransportSession.class, this.mMaxNumSipTransportSessionStats);
            parseFrom.imsDedicatedBearerListenerEvent = (PersistAtomsProto.ImsDedicatedBearerListenerEvent[]) sanitizeAtoms(parseFrom.imsDedicatedBearerListenerEvent, PersistAtomsProto.ImsDedicatedBearerListenerEvent.class, this.mMaxNumDedicatedBearerListenerEventStats);
            parseFrom.imsDedicatedBearerEvent = (PersistAtomsProto.ImsDedicatedBearerEvent[]) sanitizeAtoms(parseFrom.imsDedicatedBearerEvent, PersistAtomsProto.ImsDedicatedBearerEvent.class, this.mMaxNumDedicatedBearerEventStats);
            parseFrom.imsRegistrationServiceDescStats = (PersistAtomsProto.ImsRegistrationServiceDescStats[]) sanitizeAtoms(parseFrom.imsRegistrationServiceDescStats, PersistAtomsProto.ImsRegistrationServiceDescStats.class, this.mMaxNumImsRegistrationServiceDescStats);
            parseFrom.uceEventStats = (PersistAtomsProto.UceEventStats[]) sanitizeAtoms(parseFrom.uceEventStats, PersistAtomsProto.UceEventStats.class, this.mMaxNumUceEventStats);
            parseFrom.presenceNotifyEvent = (PersistAtomsProto.PresenceNotifyEvent[]) sanitizeAtoms(parseFrom.presenceNotifyEvent, PersistAtomsProto.PresenceNotifyEvent.class, this.mMaxNumPresenceNotifyEventStats);
            parseFrom.gbaEvent = (PersistAtomsProto.GbaEvent[]) sanitizeAtoms(parseFrom.gbaEvent, PersistAtomsProto.GbaEvent.class, this.mMaxNumGbaEventStats);
            parseFrom.voiceCallRatUsagePullTimestampMillis = sanitizeTimestamp(parseFrom.voiceCallRatUsagePullTimestampMillis);
            parseFrom.voiceCallSessionPullTimestampMillis = sanitizeTimestamp(parseFrom.voiceCallSessionPullTimestampMillis);
            parseFrom.incomingSmsPullTimestampMillis = sanitizeTimestamp(parseFrom.incomingSmsPullTimestampMillis);
            parseFrom.outgoingSmsPullTimestampMillis = sanitizeTimestamp(parseFrom.outgoingSmsPullTimestampMillis);
            parseFrom.dataCallSessionPullTimestampMillis = sanitizeTimestamp(parseFrom.dataCallSessionPullTimestampMillis);
            parseFrom.cellularServiceStatePullTimestampMillis = sanitizeTimestamp(parseFrom.cellularServiceStatePullTimestampMillis);
            parseFrom.cellularDataServiceSwitchPullTimestampMillis = sanitizeTimestamp(parseFrom.cellularDataServiceSwitchPullTimestampMillis);
            parseFrom.imsRegistrationStatsPullTimestampMillis = sanitizeTimestamp(parseFrom.imsRegistrationStatsPullTimestampMillis);
            parseFrom.imsRegistrationTerminationPullTimestampMillis = sanitizeTimestamp(parseFrom.imsRegistrationTerminationPullTimestampMillis);
            parseFrom.networkRequestsV2PullTimestampMillis = sanitizeTimestamp(parseFrom.networkRequestsV2PullTimestampMillis);
            parseFrom.imsRegistrationFeatureTagStatsPullTimestampMillis = sanitizeTimestamp(parseFrom.imsRegistrationFeatureTagStatsPullTimestampMillis);
            parseFrom.rcsClientProvisioningStatsPullTimestampMillis = sanitizeTimestamp(parseFrom.rcsClientProvisioningStatsPullTimestampMillis);
            parseFrom.rcsAcsProvisioningStatsPullTimestampMillis = sanitizeTimestamp(parseFrom.rcsAcsProvisioningStatsPullTimestampMillis);
            parseFrom.sipDelegateStatsPullTimestampMillis = sanitizeTimestamp(parseFrom.sipDelegateStatsPullTimestampMillis);
            parseFrom.sipTransportFeatureTagStatsPullTimestampMillis = sanitizeTimestamp(parseFrom.sipTransportFeatureTagStatsPullTimestampMillis);
            parseFrom.sipMessageResponsePullTimestampMillis = sanitizeTimestamp(parseFrom.sipMessageResponsePullTimestampMillis);
            parseFrom.sipTransportSessionPullTimestampMillis = sanitizeTimestamp(parseFrom.sipTransportSessionPullTimestampMillis);
            parseFrom.imsDedicatedBearerListenerEventPullTimestampMillis = sanitizeTimestamp(parseFrom.imsDedicatedBearerListenerEventPullTimestampMillis);
            parseFrom.imsDedicatedBearerEventPullTimestampMillis = sanitizeTimestamp(parseFrom.imsDedicatedBearerEventPullTimestampMillis);
            parseFrom.imsRegistrationServiceDescStatsPullTimestampMillis = sanitizeTimestamp(parseFrom.imsRegistrationServiceDescStatsPullTimestampMillis);
            parseFrom.uceEventStatsPullTimestampMillis = sanitizeTimestamp(parseFrom.uceEventStatsPullTimestampMillis);
            parseFrom.presenceNotifyEventPullTimestampMillis = sanitizeTimestamp(parseFrom.presenceNotifyEventPullTimestampMillis);
            parseFrom.gbaEventPullTimestampMillis = sanitizeTimestamp(parseFrom.gbaEventPullTimestampMillis);
            return parseFrom;
        } catch (NoSuchFileException unused) {
            Rlog.d(TAG, "PersistAtoms file not found");
            return makeNewPersistAtoms();
        } catch (IOException | NullPointerException e) {
            Rlog.e(TAG, "cannot load/parse PersistAtoms", e);
            return makeNewPersistAtoms();
        }
    }

    private void saveAtomsToFile(int i) {
        if (i > 0 && !this.mSaveImmediately) {
            this.mHandler.removeCallbacks(this.mSaveRunnable);
            if (this.mHandler.postDelayed(this.mSaveRunnable, (long) i)) {
                return;
            }
        }
        saveAtomsToFileNow();
    }

    /* access modifiers changed from: private */
    public synchronized void saveAtomsToFileNow() {
        FileOutputStream openFileOutput;
        try {
            openFileOutput = this.mContext.openFileOutput(FILENAME, 0);
            openFileOutput.write(MessageNano.toByteArray(this.mAtoms));
            openFileOutput.close();
        } catch (IOException e) {
            Rlog.e(TAG, "cannot save PersistAtoms", e);
        } catch (Throwable th) {
            th.addSuppressed(th);
        }
        return;
        throw th;
    }

    private PersistAtomsProto.CellularServiceState find(PersistAtomsProto.CellularServiceState cellularServiceState) {
        for (PersistAtomsProto.CellularServiceState cellularServiceState2 : this.mAtoms.cellularServiceState) {
            if (cellularServiceState2.voiceRat == cellularServiceState.voiceRat && cellularServiceState2.dataRat == cellularServiceState.dataRat && cellularServiceState2.voiceRoamingType == cellularServiceState.voiceRoamingType && cellularServiceState2.dataRoamingType == cellularServiceState.dataRoamingType && cellularServiceState2.isEndc == cellularServiceState.isEndc && cellularServiceState2.simSlotIndex == cellularServiceState.simSlotIndex && cellularServiceState2.isMultiSim == cellularServiceState.isMultiSim && cellularServiceState2.carrierId == cellularServiceState.carrierId && cellularServiceState2.isEmergencyOnly == cellularServiceState.isEmergencyOnly) {
                return cellularServiceState2;
            }
        }
        return null;
    }

    private PersistAtomsProto.CellularDataServiceSwitch find(PersistAtomsProto.CellularDataServiceSwitch cellularDataServiceSwitch) {
        for (PersistAtomsProto.CellularDataServiceSwitch cellularDataServiceSwitch2 : this.mAtoms.cellularDataServiceSwitch) {
            if (cellularDataServiceSwitch2.ratFrom == cellularDataServiceSwitch.ratFrom && cellularDataServiceSwitch2.ratTo == cellularDataServiceSwitch.ratTo && cellularDataServiceSwitch2.simSlotIndex == cellularDataServiceSwitch.simSlotIndex && cellularDataServiceSwitch2.isMultiSim == cellularDataServiceSwitch.isMultiSim && cellularDataServiceSwitch2.carrierId == cellularDataServiceSwitch.carrierId) {
                return cellularDataServiceSwitch2;
            }
        }
        return null;
    }

    private PersistAtomsProto.CarrierIdMismatch find(PersistAtomsProto.CarrierIdMismatch carrierIdMismatch) {
        for (PersistAtomsProto.CarrierIdMismatch carrierIdMismatch2 : this.mAtoms.carrierIdMismatch) {
            if (carrierIdMismatch2.mccMnc.equals(carrierIdMismatch.mccMnc) && carrierIdMismatch2.gid1.equals(carrierIdMismatch.gid1) && carrierIdMismatch2.spn.equals(carrierIdMismatch.spn) && carrierIdMismatch2.pnn.equals(carrierIdMismatch.pnn)) {
                return carrierIdMismatch2;
            }
        }
        return null;
    }

    private PersistAtomsProto.ImsRegistrationStats find(PersistAtomsProto.ImsRegistrationStats imsRegistrationStats) {
        for (PersistAtomsProto.ImsRegistrationStats imsRegistrationStats2 : this.mAtoms.imsRegistrationStats) {
            if (imsRegistrationStats2.carrierId == imsRegistrationStats.carrierId && imsRegistrationStats2.simSlotIndex == imsRegistrationStats.simSlotIndex && imsRegistrationStats2.rat == imsRegistrationStats.rat) {
                return imsRegistrationStats2;
            }
        }
        return null;
    }

    private PersistAtomsProto.ImsRegistrationTermination find(PersistAtomsProto.ImsRegistrationTermination imsRegistrationTermination) {
        for (PersistAtomsProto.ImsRegistrationTermination imsRegistrationTermination2 : this.mAtoms.imsRegistrationTermination) {
            if (imsRegistrationTermination2.carrierId == imsRegistrationTermination.carrierId && imsRegistrationTermination2.isMultiSim == imsRegistrationTermination.isMultiSim && imsRegistrationTermination2.ratAtEnd == imsRegistrationTermination.ratAtEnd && imsRegistrationTermination2.setupFailed == imsRegistrationTermination.setupFailed && imsRegistrationTermination2.reasonCode == imsRegistrationTermination.reasonCode && imsRegistrationTermination2.extraCode == imsRegistrationTermination.extraCode && imsRegistrationTermination2.extraMessage.equals(imsRegistrationTermination.extraMessage)) {
                return imsRegistrationTermination2;
            }
        }
        return null;
    }

    private PersistAtomsProto.NetworkRequestsV2 find(PersistAtomsProto.NetworkRequestsV2 networkRequestsV2) {
        for (PersistAtomsProto.NetworkRequestsV2 networkRequestsV22 : this.mAtoms.networkRequestsV2) {
            if (networkRequestsV22.carrierId == networkRequestsV2.carrierId && networkRequestsV22.capability == networkRequestsV2.capability) {
                return networkRequestsV22;
            }
        }
        return null;
    }

    private int findIndex(PersistAtomsProto.DataCallSession dataCallSession) {
        int i = 0;
        while (true) {
            PersistAtomsProto.DataCallSession[] dataCallSessionArr = this.mAtoms.dataCallSession;
            if (i >= dataCallSessionArr.length) {
                return -1;
            }
            if (dataCallSessionArr[i].dimension == dataCallSession.dimension) {
                return i;
            }
            i++;
        }
    }

    private PersistAtomsProto.ImsDedicatedBearerListenerEvent find(PersistAtomsProto.ImsDedicatedBearerListenerEvent imsDedicatedBearerListenerEvent) {
        for (PersistAtomsProto.ImsDedicatedBearerListenerEvent imsDedicatedBearerListenerEvent2 : this.mAtoms.imsDedicatedBearerListenerEvent) {
            if (imsDedicatedBearerListenerEvent2.carrierId == imsDedicatedBearerListenerEvent.carrierId && imsDedicatedBearerListenerEvent2.slotId == imsDedicatedBearerListenerEvent.slotId && imsDedicatedBearerListenerEvent2.ratAtEnd == imsDedicatedBearerListenerEvent.ratAtEnd && imsDedicatedBearerListenerEvent2.qci == imsDedicatedBearerListenerEvent.qci && imsDedicatedBearerListenerEvent2.dedicatedBearerEstablished == imsDedicatedBearerListenerEvent.dedicatedBearerEstablished) {
                return imsDedicatedBearerListenerEvent2;
            }
        }
        return null;
    }

    private PersistAtomsProto.ImsDedicatedBearerEvent find(PersistAtomsProto.ImsDedicatedBearerEvent imsDedicatedBearerEvent) {
        for (PersistAtomsProto.ImsDedicatedBearerEvent imsDedicatedBearerEvent2 : this.mAtoms.imsDedicatedBearerEvent) {
            if (imsDedicatedBearerEvent2.carrierId == imsDedicatedBearerEvent.carrierId && imsDedicatedBearerEvent2.slotId == imsDedicatedBearerEvent.slotId && imsDedicatedBearerEvent2.ratAtEnd == imsDedicatedBearerEvent.ratAtEnd && imsDedicatedBearerEvent2.qci == imsDedicatedBearerEvent.qci && imsDedicatedBearerEvent2.bearerState == imsDedicatedBearerEvent.bearerState && imsDedicatedBearerEvent2.localConnectionInfoReceived == imsDedicatedBearerEvent.localConnectionInfoReceived && imsDedicatedBearerEvent2.remoteConnectionInfoReceived == imsDedicatedBearerEvent.remoteConnectionInfoReceived && imsDedicatedBearerEvent2.hasListeners == imsDedicatedBearerEvent.hasListeners) {
                return imsDedicatedBearerEvent2;
            }
        }
        return null;
    }

    private PersistAtomsProto.ImsRegistrationFeatureTagStats find(PersistAtomsProto.ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats) {
        for (PersistAtomsProto.ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats2 : this.mAtoms.imsRegistrationFeatureTagStats) {
            if (imsRegistrationFeatureTagStats2.carrierId == imsRegistrationFeatureTagStats.carrierId && imsRegistrationFeatureTagStats2.slotId == imsRegistrationFeatureTagStats.slotId && imsRegistrationFeatureTagStats2.featureTagName == imsRegistrationFeatureTagStats.featureTagName && imsRegistrationFeatureTagStats2.registrationTech == imsRegistrationFeatureTagStats.registrationTech) {
                return imsRegistrationFeatureTagStats2;
            }
        }
        return null;
    }

    private PersistAtomsProto.RcsClientProvisioningStats find(PersistAtomsProto.RcsClientProvisioningStats rcsClientProvisioningStats) {
        for (PersistAtomsProto.RcsClientProvisioningStats rcsClientProvisioningStats2 : this.mAtoms.rcsClientProvisioningStats) {
            if (rcsClientProvisioningStats2.carrierId == rcsClientProvisioningStats.carrierId && rcsClientProvisioningStats2.slotId == rcsClientProvisioningStats.slotId && rcsClientProvisioningStats2.event == rcsClientProvisioningStats.event) {
                return rcsClientProvisioningStats2;
            }
        }
        return null;
    }

    private PersistAtomsProto.RcsAcsProvisioningStats find(PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats) {
        for (PersistAtomsProto.RcsAcsProvisioningStats rcsAcsProvisioningStats2 : this.mAtoms.rcsAcsProvisioningStats) {
            if (rcsAcsProvisioningStats2.carrierId == rcsAcsProvisioningStats.carrierId && rcsAcsProvisioningStats2.slotId == rcsAcsProvisioningStats.slotId && rcsAcsProvisioningStats2.responseCode == rcsAcsProvisioningStats.responseCode && rcsAcsProvisioningStats2.responseType == rcsAcsProvisioningStats.responseType && rcsAcsProvisioningStats2.isSingleRegistrationEnabled == rcsAcsProvisioningStats.isSingleRegistrationEnabled) {
                return rcsAcsProvisioningStats2;
            }
        }
        return null;
    }

    private PersistAtomsProto.SipMessageResponse find(PersistAtomsProto.SipMessageResponse sipMessageResponse) {
        for (PersistAtomsProto.SipMessageResponse sipMessageResponse2 : this.mAtoms.sipMessageResponse) {
            if (sipMessageResponse2.carrierId == sipMessageResponse.carrierId && sipMessageResponse2.slotId == sipMessageResponse.slotId && sipMessageResponse2.sipMessageMethod == sipMessageResponse.sipMessageMethod && sipMessageResponse2.sipMessageResponse == sipMessageResponse.sipMessageResponse && sipMessageResponse2.sipMessageDirection == sipMessageResponse.sipMessageDirection && sipMessageResponse2.messageError == sipMessageResponse.messageError) {
                return sipMessageResponse2;
            }
        }
        return null;
    }

    private PersistAtomsProto.SipTransportSession find(PersistAtomsProto.SipTransportSession sipTransportSession) {
        for (PersistAtomsProto.SipTransportSession sipTransportSession2 : this.mAtoms.sipTransportSession) {
            if (sipTransportSession2.carrierId == sipTransportSession.carrierId && sipTransportSession2.slotId == sipTransportSession.slotId && sipTransportSession2.sessionMethod == sipTransportSession.sessionMethod && sipTransportSession2.sipMessageDirection == sipTransportSession.sipMessageDirection && sipTransportSession2.sipResponse == sipTransportSession.sipResponse) {
                return sipTransportSession2;
            }
        }
        return null;
    }

    private PersistAtomsProto.ImsRegistrationServiceDescStats find(PersistAtomsProto.ImsRegistrationServiceDescStats imsRegistrationServiceDescStats) {
        for (PersistAtomsProto.ImsRegistrationServiceDescStats imsRegistrationServiceDescStats2 : this.mAtoms.imsRegistrationServiceDescStats) {
            if (imsRegistrationServiceDescStats2.carrierId == imsRegistrationServiceDescStats.carrierId && imsRegistrationServiceDescStats2.slotId == imsRegistrationServiceDescStats.slotId && imsRegistrationServiceDescStats2.serviceIdName == imsRegistrationServiceDescStats.serviceIdName && imsRegistrationServiceDescStats2.serviceIdVersion == imsRegistrationServiceDescStats.serviceIdVersion && imsRegistrationServiceDescStats2.registrationTech == imsRegistrationServiceDescStats.registrationTech) {
                return imsRegistrationServiceDescStats2;
            }
        }
        return null;
    }

    private PersistAtomsProto.UceEventStats find(PersistAtomsProto.UceEventStats uceEventStats) {
        for (PersistAtomsProto.UceEventStats uceEventStats2 : this.mAtoms.uceEventStats) {
            if (uceEventStats2.carrierId == uceEventStats.carrierId && uceEventStats2.slotId == uceEventStats.slotId && uceEventStats2.type == uceEventStats.type && uceEventStats2.successful == uceEventStats.successful && uceEventStats2.commandCode == uceEventStats.commandCode && uceEventStats2.networkResponse == uceEventStats.networkResponse) {
                return uceEventStats2;
            }
        }
        return null;
    }

    private PersistAtomsProto.PresenceNotifyEvent find(PersistAtomsProto.PresenceNotifyEvent presenceNotifyEvent) {
        for (PersistAtomsProto.PresenceNotifyEvent presenceNotifyEvent2 : this.mAtoms.presenceNotifyEvent) {
            if (presenceNotifyEvent2.carrierId == presenceNotifyEvent.carrierId && presenceNotifyEvent2.slotId == presenceNotifyEvent.slotId && presenceNotifyEvent2.reason == presenceNotifyEvent.reason && presenceNotifyEvent2.contentBodyReceived == presenceNotifyEvent.contentBodyReceived) {
                return presenceNotifyEvent2;
            }
        }
        return null;
    }

    private PersistAtomsProto.GbaEvent find(PersistAtomsProto.GbaEvent gbaEvent) {
        for (PersistAtomsProto.GbaEvent gbaEvent2 : this.mAtoms.gbaEvent) {
            if (gbaEvent2.carrierId == gbaEvent.carrierId && gbaEvent2.slotId == gbaEvent.slotId && gbaEvent2.successful == gbaEvent.successful && gbaEvent2.failedReason == gbaEvent.failedReason) {
                return gbaEvent2;
            }
        }
        return null;
    }

    private PersistAtomsProto.SipTransportFeatureTagStats find(PersistAtomsProto.SipTransportFeatureTagStats sipTransportFeatureTagStats) {
        for (PersistAtomsProto.SipTransportFeatureTagStats sipTransportFeatureTagStats2 : this.mAtoms.sipTransportFeatureTagStats) {
            if (sipTransportFeatureTagStats2.carrierId == sipTransportFeatureTagStats.carrierId && sipTransportFeatureTagStats2.slotId == sipTransportFeatureTagStats.slotId && sipTransportFeatureTagStats2.featureTagName == sipTransportFeatureTagStats.featureTagName && sipTransportFeatureTagStats2.sipTransportDeregisteredReason == sipTransportFeatureTagStats.sipTransportDeregisteredReason && sipTransportFeatureTagStats2.sipTransportDeniedReason == sipTransportFeatureTagStats.sipTransportDeniedReason) {
                return sipTransportFeatureTagStats2;
            }
        }
        return null;
    }

    private static <T> T[] insertAtRandomPlace(T[] tArr, T t, int i) {
        int length = tArr.length + 1;
        boolean z = length > i;
        if (!z) {
            i = length;
        }
        T[] copyOf = Arrays.copyOf(tArr, i);
        if (length == 1) {
            copyOf[0] = t;
        } else if (z) {
            copyOf[findItemToEvict(tArr)] = t;
        } else {
            int nextInt = sRandom.nextInt(length);
            copyOf[length - 1] = copyOf[nextInt];
            copyOf[nextInt] = t;
        }
        return copyOf;
    }

    private static <T> int findItemToEvict(T[] tArr) {
        if (tArr instanceof PersistAtomsProto.CellularServiceState[]) {
            PersistAtomsProto.CellularServiceState[] cellularServiceStateArr = (PersistAtomsProto.CellularServiceState[]) tArr;
            return IntStream.range(0, cellularServiceStateArr.length).reduce(new PersistAtomsStorage$$ExternalSyntheticLambda3(cellularServiceStateArr)).getAsInt();
        } else if (tArr instanceof PersistAtomsProto.CellularDataServiceSwitch[]) {
            PersistAtomsProto.CellularDataServiceSwitch[] cellularDataServiceSwitchArr = (PersistAtomsProto.CellularDataServiceSwitch[]) tArr;
            return IntStream.range(0, cellularDataServiceSwitchArr.length).reduce(new PersistAtomsStorage$$ExternalSyntheticLambda4(cellularDataServiceSwitchArr)).getAsInt();
        } else if (tArr instanceof PersistAtomsProto.ImsRegistrationStats[]) {
            PersistAtomsProto.ImsRegistrationStats[] imsRegistrationStatsArr = (PersistAtomsProto.ImsRegistrationStats[]) tArr;
            return IntStream.range(0, imsRegistrationStatsArr.length).reduce(new PersistAtomsStorage$$ExternalSyntheticLambda5(imsRegistrationStatsArr)).getAsInt();
        } else if (tArr instanceof PersistAtomsProto.ImsRegistrationTermination[]) {
            PersistAtomsProto.ImsRegistrationTermination[] imsRegistrationTerminationArr = (PersistAtomsProto.ImsRegistrationTermination[]) tArr;
            return IntStream.range(0, imsRegistrationTerminationArr.length).reduce(new PersistAtomsStorage$$ExternalSyntheticLambda6(imsRegistrationTerminationArr)).getAsInt();
        } else {
            if (tArr instanceof PersistAtomsProto.VoiceCallSession[]) {
                PersistAtomsProto.VoiceCallSession[] voiceCallSessionArr = (PersistAtomsProto.VoiceCallSession[]) tArr;
                int[] array = IntStream.range(0, voiceCallSessionArr.length).filter(new PersistAtomsStorage$$ExternalSyntheticLambda7(voiceCallSessionArr)).toArray();
                if (array.length > 0) {
                    return array[sRandom.nextInt(array.length)];
                }
            }
            return sRandom.nextInt(tArr.length);
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$findItemToEvict$4(PersistAtomsProto.CellularServiceState[] cellularServiceStateArr, int i, int i2) {
        return cellularServiceStateArr[i].lastUsedMillis < cellularServiceStateArr[i2].lastUsedMillis ? i : i2;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$findItemToEvict$5(PersistAtomsProto.CellularDataServiceSwitch[] cellularDataServiceSwitchArr, int i, int i2) {
        return cellularDataServiceSwitchArr[i].lastUsedMillis < cellularDataServiceSwitchArr[i2].lastUsedMillis ? i : i2;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$findItemToEvict$6(PersistAtomsProto.ImsRegistrationStats[] imsRegistrationStatsArr, int i, int i2) {
        return imsRegistrationStatsArr[i].lastUsedMillis < imsRegistrationStatsArr[i2].lastUsedMillis ? i : i2;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$findItemToEvict$7(PersistAtomsProto.ImsRegistrationTermination[] imsRegistrationTerminationArr, int i, int i2) {
        return imsRegistrationTerminationArr[i].lastUsedMillis < imsRegistrationTerminationArr[i2].lastUsedMillis ? i : i2;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$findItemToEvict$8(PersistAtomsProto.VoiceCallSession[] voiceCallSessionArr, int i) {
        return !voiceCallSessionArr[i].isEmergency;
    }

    private <T> T[] sanitizeAtoms(T[] tArr, Class<T> cls) {
        return ArrayUtils.emptyIfNull(tArr, cls);
    }

    private <T> T[] sanitizeAtoms(T[] tArr, Class<T> cls, int i) {
        T[] sanitizeAtoms = sanitizeAtoms(tArr, cls);
        return sanitizeAtoms.length > i ? Arrays.copyOf(sanitizeAtoms, i) : sanitizeAtoms;
    }

    private long sanitizeTimestamp(long j) {
        return j <= 0 ? getWallTimeMillis() : j;
    }

    private PersistAtomsProto.ImsRegistrationStats[] normalizeData(PersistAtomsProto.ImsRegistrationStats[] imsRegistrationStatsArr, long j) {
        for (int i = 0; i < imsRegistrationStatsArr.length; i++) {
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats = imsRegistrationStatsArr[i];
            imsRegistrationStats.registeredMillis = normalizeDurationTo24H(imsRegistrationStats.registeredMillis, j);
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats2 = imsRegistrationStatsArr[i];
            imsRegistrationStats2.voiceCapableMillis = normalizeDurationTo24H(imsRegistrationStats2.voiceCapableMillis, j);
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats3 = imsRegistrationStatsArr[i];
            imsRegistrationStats3.voiceAvailableMillis = normalizeDurationTo24H(imsRegistrationStats3.voiceAvailableMillis, j);
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats4 = imsRegistrationStatsArr[i];
            imsRegistrationStats4.smsCapableMillis = normalizeDurationTo24H(imsRegistrationStats4.smsCapableMillis, j);
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats5 = imsRegistrationStatsArr[i];
            imsRegistrationStats5.smsAvailableMillis = normalizeDurationTo24H(imsRegistrationStats5.smsAvailableMillis, j);
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats6 = imsRegistrationStatsArr[i];
            imsRegistrationStats6.videoCapableMillis = normalizeDurationTo24H(imsRegistrationStats6.videoCapableMillis, j);
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats7 = imsRegistrationStatsArr[i];
            imsRegistrationStats7.videoAvailableMillis = normalizeDurationTo24H(imsRegistrationStats7.videoAvailableMillis, j);
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats8 = imsRegistrationStatsArr[i];
            imsRegistrationStats8.utCapableMillis = normalizeDurationTo24H(imsRegistrationStats8.utCapableMillis, j);
            PersistAtomsProto.ImsRegistrationStats imsRegistrationStats9 = imsRegistrationStatsArr[i];
            imsRegistrationStats9.utAvailableMillis = normalizeDurationTo24H(imsRegistrationStats9.utAvailableMillis, j);
        }
        return imsRegistrationStatsArr;
    }

    private long normalizeDurationTo24H(long j, long j2) {
        return (((j / 1000) * 86400) / (j2 < 1000 ? 1 : j2 / 1000)) * 1000;
    }

    private PersistAtomsProto.PersistAtoms makeNewPersistAtoms() {
        PersistAtomsProto.PersistAtoms persistAtoms = new PersistAtomsProto.PersistAtoms();
        long wallTimeMillis = getWallTimeMillis();
        persistAtoms.buildFingerprint = Build.FINGERPRINT;
        persistAtoms.voiceCallRatUsagePullTimestampMillis = wallTimeMillis;
        persistAtoms.voiceCallSessionPullTimestampMillis = wallTimeMillis;
        persistAtoms.incomingSmsPullTimestampMillis = wallTimeMillis;
        persistAtoms.outgoingSmsPullTimestampMillis = wallTimeMillis;
        persistAtoms.carrierIdTableVersion = -1;
        persistAtoms.dataCallSessionPullTimestampMillis = wallTimeMillis;
        persistAtoms.cellularServiceStatePullTimestampMillis = wallTimeMillis;
        persistAtoms.cellularDataServiceSwitchPullTimestampMillis = wallTimeMillis;
        persistAtoms.imsRegistrationStatsPullTimestampMillis = wallTimeMillis;
        persistAtoms.imsRegistrationTerminationPullTimestampMillis = wallTimeMillis;
        persistAtoms.networkRequestsPullTimestampMillis = wallTimeMillis;
        persistAtoms.networkRequestsV2PullTimestampMillis = wallTimeMillis;
        persistAtoms.imsRegistrationFeatureTagStatsPullTimestampMillis = wallTimeMillis;
        persistAtoms.rcsClientProvisioningStatsPullTimestampMillis = wallTimeMillis;
        persistAtoms.rcsAcsProvisioningStatsPullTimestampMillis = wallTimeMillis;
        persistAtoms.sipDelegateStatsPullTimestampMillis = wallTimeMillis;
        persistAtoms.sipTransportFeatureTagStatsPullTimestampMillis = wallTimeMillis;
        persistAtoms.sipMessageResponsePullTimestampMillis = wallTimeMillis;
        persistAtoms.sipTransportSessionPullTimestampMillis = wallTimeMillis;
        persistAtoms.imsDedicatedBearerListenerEventPullTimestampMillis = wallTimeMillis;
        persistAtoms.imsDedicatedBearerEventPullTimestampMillis = wallTimeMillis;
        persistAtoms.imsRegistrationServiceDescStatsPullTimestampMillis = wallTimeMillis;
        persistAtoms.uceEventStatsPullTimestampMillis = wallTimeMillis;
        persistAtoms.presenceNotifyEventPullTimestampMillis = wallTimeMillis;
        persistAtoms.gbaEventPullTimestampMillis = wallTimeMillis;
        Rlog.d(TAG, "created new PersistAtoms");
        return persistAtoms;
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public long getWallTimeMillis() {
        return System.currentTimeMillis();
    }
}
