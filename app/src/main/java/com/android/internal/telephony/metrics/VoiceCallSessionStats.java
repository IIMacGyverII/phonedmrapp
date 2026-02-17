package com.android.internal.telephony.metrics;

import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.SystemClock;
import android.telephony.ServiceState;
import android.telephony.ims.ImsReasonInfo;
import android.util.LongSparseArray;
import android.util.SparseArray;
import android.util.SparseIntArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.Connection;
import com.android.internal.telephony.GsmCdmaConnection;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.ServiceStateTracker;
import com.android.internal.telephony.imsphone.ImsPhoneConnection;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.internal.telephony.uicc.UiccController;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class VoiceCallSessionStats {
    private static final int CALL_DURATION_FIVE_MINUTES = 300000;
    private static final SparseIntArray CALL_DURATION_MAP = buildCallDurationMap();
    private static final int CALL_DURATION_ONE_HOUR = 3600000;
    private static final int CALL_DURATION_ONE_MINUTE = 60000;
    private static final int CALL_DURATION_TEN_MINUTES = 600000;
    private static final int CALL_DURATION_THIRTY_MINUTES = 1800000;
    private static final int CALL_SETUP_DURATION_EXTREMELY_FAST = 400;
    private static final int CALL_SETUP_DURATION_FAST = 1500;
    private static final SparseIntArray CALL_SETUP_DURATION_MAP = buildCallSetupDurationMap();
    private static final int CALL_SETUP_DURATION_NORMAL = 2500;
    private static final int CALL_SETUP_DURATION_SLOW = 4000;
    private static final int CALL_SETUP_DURATION_ULTRA_FAST = 700;
    private static final int CALL_SETUP_DURATION_ULTRA_SLOW = 10000;
    private static final int CALL_SETUP_DURATION_UNKNOWN = 0;
    private static final int CALL_SETUP_DURATION_VERY_FAST = 1000;
    private static final int CALL_SETUP_DURATION_VERY_SLOW = 6000;
    private static final int CODEC_QUALITY_COUNT = 5;
    private static final SparseIntArray CS_CODEC_MAP = buildGsmCdmaCodecMap();
    private static final SparseIntArray IMS_CODEC_MAP = buildImsCodecMap();
    private static final int MAIN_CODEC_QUALITY_THRESHOLD = 70;
    private static final String TAG = "VoiceCallSessionStats";
    private final PersistAtomsStorage mAtomsStorage = PhoneFactory.getMetricsCollector().getAtomsStorage();
    private final SparseArray<PersistAtomsProto.VoiceCallSession> mCallProtos = new SparseArray<>();
    private final SparseArray<LongSparseArray<Integer>> mCodecUsage = new SparseArray<>();
    private final Phone mPhone;
    private final int mPhoneId;
    private final VoiceCallRatTracker mRatUsage = new VoiceCallRatTracker();
    private final UiccController mUiccController = UiccController.getInstance();

    private int getCodecQuality(int i) {
        switch (i) {
            case 1:
            case 3:
            case 4:
            case 5:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
                return 1;
            case 2:
            case 6:
            case 18:
                return 2;
            case 19:
                return 3;
            case 20:
                return 4;
            default:
                return 0;
        }
    }

    public VoiceCallSessionStats(int i, Phone phone) {
        this.mPhoneId = i;
        this.mPhone = phone;
    }

    public synchronized void onRilAcceptCall(List<Connection> list) {
        for (Connection acceptCall : list) {
            acceptCall(acceptCall);
        }
    }

    public synchronized void onRilDial(Connection connection) {
        addCall(connection);
    }

    public synchronized void onRilCallListChanged(List<GsmCdmaConnection> list) {
        for (Connection next : list) {
            int connectionId = getConnectionId(next);
            if (this.mCallProtos.contains(connectionId)) {
                PersistAtomsProto.VoiceCallSession voiceCallSession = this.mCallProtos.get(connectionId);
                checkCallSetup(next, voiceCallSession);
                if (next.getDisconnectCause() != 0) {
                    voiceCallSession.bearerAtEnd = getBearer(next);
                    voiceCallSession.disconnectReasonCode = next.getDisconnectCause();
                    voiceCallSession.disconnectExtraCode = next.getPreciseDisconnectCause();
                    voiceCallSession.disconnectExtraMessage = next.getVendorDisconnectCause();
                    voiceCallSession.callDuration = classifyCallDuration(next.getDurationMillis());
                    finishCall(connectionId);
                }
            } else if (next.getDisconnectCause() == 0) {
                addCall(next);
                checkCallSetup(next, this.mCallProtos.get(connectionId));
            } else {
                logd("onRilCallListChanged: skip adding disconnected connection, connectionId=%d", Integer.valueOf(connectionId));
            }
        }
    }

    public synchronized void onImsDial(ImsPhoneConnection imsPhoneConnection) {
        addCall(imsPhoneConnection);
        if (imsPhoneConnection.hasRttTextStream()) {
            setRttStarted(imsPhoneConnection);
        }
    }

    public synchronized void onImsCallReceived(ImsPhoneConnection imsPhoneConnection) {
        addCall(imsPhoneConnection);
        if (imsPhoneConnection.hasRttTextStream()) {
            setRttStarted(imsPhoneConnection);
        }
    }

    public synchronized void onImsAcceptCall(List<Connection> list) {
        for (Connection acceptCall : list) {
            acceptCall(acceptCall);
        }
    }

    public synchronized void onImsCallTerminated(ImsPhoneConnection imsPhoneConnection, ImsReasonInfo imsReasonInfo) {
        if (imsPhoneConnection == null) {
            List<Integer> imsConnectionIds = getImsConnectionIds();
            if (imsConnectionIds.size() == 1) {
                loge("onImsCallTerminated: ending IMS call w/ conn=null", new Object[0]);
                finishImsCall(imsConnectionIds.get(0).intValue(), imsReasonInfo, 0);
            } else {
                loge("onImsCallTerminated: %d IMS calls w/ conn=null", Integer.valueOf(imsConnectionIds.size()));
            }
        } else {
            int connectionId = getConnectionId(imsPhoneConnection);
            if (this.mCallProtos.contains(connectionId)) {
                finishImsCall(connectionId, imsReasonInfo, imsPhoneConnection.getDurationMillis());
            } else {
                loge("onImsCallTerminated: untracked connection, connectionId=%d", Integer.valueOf(connectionId));
                addCall(imsPhoneConnection);
                finishImsCall(connectionId, imsReasonInfo, imsPhoneConnection.getDurationMillis());
            }
        }
    }

    public synchronized void onRttStarted(ImsPhoneConnection imsPhoneConnection) {
        setRttStarted(imsPhoneConnection);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:13:0x0060, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onAudioCodecChanged(com.android.internal.telephony.Connection r6, int r7) {
        /*
            r5 = this;
            monitor-enter(r5)
            int r6 = getConnectionId(r6)     // Catch:{ all -> 0x0061 }
            android.util.SparseArray<com.android.internal.telephony.nano.PersistAtomsProto$VoiceCallSession> r0 = r5.mCallProtos     // Catch:{ all -> 0x0061 }
            java.lang.Object r0 = r0.get(r6)     // Catch:{ all -> 0x0061 }
            com.android.internal.telephony.nano.PersistAtomsProto$VoiceCallSession r0 = (com.android.internal.telephony.nano.PersistAtomsProto.VoiceCallSession) r0     // Catch:{ all -> 0x0061 }
            if (r0 != 0) goto L_0x0020
            java.lang.String r7 = "onAudioCodecChanged: untracked connection, connectionId=%d"
            r0 = 1
            java.lang.Object[] r0 = new java.lang.Object[r0]     // Catch:{ all -> 0x0061 }
            r1 = 0
            java.lang.Integer r6 = java.lang.Integer.valueOf(r6)     // Catch:{ all -> 0x0061 }
            r0[r1] = r6     // Catch:{ all -> 0x0061 }
            loge(r7, r0)     // Catch:{ all -> 0x0061 }
            monitor-exit(r5)
            return
        L_0x0020:
            int r1 = r0.bearerAtEnd     // Catch:{ all -> 0x0061 }
            int r7 = audioQualityToCodec(r1, r7)     // Catch:{ all -> 0x0061 }
            long r1 = r0.codecBitmask     // Catch:{ all -> 0x0061 }
            r3 = 1
            long r3 = r3 << r7
            long r1 = r1 | r3
            r0.codecBitmask = r1     // Catch:{ all -> 0x0061 }
            android.util.SparseArray<android.util.LongSparseArray<java.lang.Integer>> r0 = r5.mCodecUsage     // Catch:{ all -> 0x0061 }
            boolean r0 = r0.contains(r6)     // Catch:{ all -> 0x0061 }
            if (r0 == 0) goto L_0x004a
            android.util.SparseArray<android.util.LongSparseArray<java.lang.Integer>> r0 = r5.mCodecUsage     // Catch:{ all -> 0x0061 }
            java.lang.Object r6 = r0.get(r6)     // Catch:{ all -> 0x0061 }
            android.util.LongSparseArray r6 = (android.util.LongSparseArray) r6     // Catch:{ all -> 0x0061 }
            long r0 = r5.getTimeMillis()     // Catch:{ all -> 0x0061 }
            java.lang.Integer r7 = java.lang.Integer.valueOf(r7)     // Catch:{ all -> 0x0061 }
            r6.append(r0, r7)     // Catch:{ all -> 0x0061 }
            goto L_0x005f
        L_0x004a:
            android.util.LongSparseArray r0 = new android.util.LongSparseArray     // Catch:{ all -> 0x0061 }
            r0.<init>()     // Catch:{ all -> 0x0061 }
            long r1 = r5.getTimeMillis()     // Catch:{ all -> 0x0061 }
            java.lang.Integer r7 = java.lang.Integer.valueOf(r7)     // Catch:{ all -> 0x0061 }
            r0.append(r1, r7)     // Catch:{ all -> 0x0061 }
            android.util.SparseArray<android.util.LongSparseArray<java.lang.Integer>> r7 = r5.mCodecUsage     // Catch:{ all -> 0x0061 }
            r7.put(r6, r0)     // Catch:{ all -> 0x0061 }
        L_0x005f:
            monitor-exit(r5)
            return
        L_0x0061:
            r6 = move-exception
            monitor-exit(r5)
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.VoiceCallSessionStats.onAudioCodecChanged(com.android.internal.telephony.Connection, int):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:13:0x0039, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onVideoStateChange(com.android.internal.telephony.imsphone.ImsPhoneConnection r7, int r8) {
        /*
            r6 = this;
            monitor-enter(r6)
            int r7 = getConnectionId(r7)     // Catch:{ all -> 0x003a }
            android.util.SparseArray<com.android.internal.telephony.nano.PersistAtomsProto$VoiceCallSession> r0 = r6.mCallProtos     // Catch:{ all -> 0x003a }
            java.lang.Object r0 = r0.get(r7)     // Catch:{ all -> 0x003a }
            com.android.internal.telephony.nano.PersistAtomsProto$VoiceCallSession r0 = (com.android.internal.telephony.nano.PersistAtomsProto.VoiceCallSession) r0     // Catch:{ all -> 0x003a }
            r1 = 0
            r2 = 1
            if (r0 != 0) goto L_0x0020
            java.lang.String r8 = "onVideoStateChange: untracked connection, connectionId=%d"
            java.lang.Object[] r0 = new java.lang.Object[r2]     // Catch:{ all -> 0x003a }
            java.lang.Integer r7 = java.lang.Integer.valueOf(r7)     // Catch:{ all -> 0x003a }
            r0[r1] = r7     // Catch:{ all -> 0x003a }
            loge(r8, r0)     // Catch:{ all -> 0x003a }
            monitor-exit(r6)
            return
        L_0x0020:
            java.lang.String r3 = "onVideoStateChange: video state=%d, connectionId=%d"
            r4 = 2
            java.lang.Object[] r4 = new java.lang.Object[r4]     // Catch:{ all -> 0x003a }
            java.lang.Integer r5 = java.lang.Integer.valueOf(r8)     // Catch:{ all -> 0x003a }
            r4[r1] = r5     // Catch:{ all -> 0x003a }
            java.lang.Integer r7 = java.lang.Integer.valueOf(r7)     // Catch:{ all -> 0x003a }
            r4[r2] = r7     // Catch:{ all -> 0x003a }
            logd(r3, r4)     // Catch:{ all -> 0x003a }
            if (r8 == 0) goto L_0x0038
            r0.videoEnabled = r2     // Catch:{ all -> 0x003a }
        L_0x0038:
            monitor-exit(r6)
            return
        L_0x003a:
            r7 = move-exception
            monitor-exit(r6)
            throw r7
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.VoiceCallSessionStats.onVideoStateChange(com.android.internal.telephony.imsphone.ImsPhoneConnection, int):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:13:0x0039, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onMultipartyChange(com.android.internal.telephony.imsphone.ImsPhoneConnection r7, boolean r8) {
        /*
            r6 = this;
            monitor-enter(r6)
            int r7 = getConnectionId(r7)     // Catch:{ all -> 0x003a }
            android.util.SparseArray<com.android.internal.telephony.nano.PersistAtomsProto$VoiceCallSession> r0 = r6.mCallProtos     // Catch:{ all -> 0x003a }
            java.lang.Object r0 = r0.get(r7)     // Catch:{ all -> 0x003a }
            com.android.internal.telephony.nano.PersistAtomsProto$VoiceCallSession r0 = (com.android.internal.telephony.nano.PersistAtomsProto.VoiceCallSession) r0     // Catch:{ all -> 0x003a }
            r1 = 0
            r2 = 1
            if (r0 != 0) goto L_0x0020
            java.lang.String r8 = "onMultipartyChange: untracked connection, connectionId=%d"
            java.lang.Object[] r0 = new java.lang.Object[r2]     // Catch:{ all -> 0x003a }
            java.lang.Integer r7 = java.lang.Integer.valueOf(r7)     // Catch:{ all -> 0x003a }
            r0[r1] = r7     // Catch:{ all -> 0x003a }
            loge(r8, r0)     // Catch:{ all -> 0x003a }
            monitor-exit(r6)
            return
        L_0x0020:
            java.lang.String r3 = "onMultipartyChange: isMultiparty=%b, connectionId=%d"
            r4 = 2
            java.lang.Object[] r4 = new java.lang.Object[r4]     // Catch:{ all -> 0x003a }
            java.lang.Boolean r5 = java.lang.Boolean.valueOf(r8)     // Catch:{ all -> 0x003a }
            r4[r1] = r5     // Catch:{ all -> 0x003a }
            java.lang.Integer r7 = java.lang.Integer.valueOf(r7)     // Catch:{ all -> 0x003a }
            r4[r2] = r7     // Catch:{ all -> 0x003a }
            logd(r3, r4)     // Catch:{ all -> 0x003a }
            if (r8 == 0) goto L_0x0038
            r0.isMultiparty = r2     // Catch:{ all -> 0x003a }
        L_0x0038:
            monitor-exit(r6)
            return
        L_0x003a:
            r7 = move-exception
            monitor-exit(r6)
            throw r7
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.VoiceCallSessionStats.onMultipartyChange(com.android.internal.telephony.imsphone.ImsPhoneConnection, boolean):void");
    }

    public synchronized void onCallStateChanged(Call call) {
        Iterator<Connection> it = call.getConnections().iterator();
        while (it.hasNext()) {
            Connection next = it.next();
            int connectionId = getConnectionId(next);
            PersistAtomsProto.VoiceCallSession voiceCallSession = this.mCallProtos.get(connectionId);
            if (voiceCallSession != null) {
                checkCallSetup(next, voiceCallSession);
            } else {
                loge("onCallStateChanged: untracked connection, connectionId=%d", Integer.valueOf(connectionId));
            }
        }
    }

    public synchronized void onRilSrvccStateChanged(int i) {
        List<Integer> list;
        ArrayList<Connection> arrayList = null;
        if (this.mPhone.getImsPhone() != null) {
            loge("onRilSrvccStateChanged: ImsPhone is null", new Object[0]);
        } else {
            arrayList = this.mPhone.getImsPhone().getHandoverConnection();
        }
        if (arrayList == null) {
            list = getImsConnectionIds();
            loge("onRilSrvccStateChanged: ImsPhone has no handover, we have %d", Integer.valueOf(list.size()));
        } else {
            list = (List) arrayList.stream().map(new VoiceCallSessionStats$$ExternalSyntheticLambda0()).collect(Collectors.toList());
        }
        if (i == 1) {
            for (Integer intValue : list) {
                PersistAtomsProto.VoiceCallSession voiceCallSession = this.mCallProtos.get(intValue.intValue());
                voiceCallSession.srvccCompleted = true;
                voiceCallSession.bearerAtEnd = 1;
            }
        } else if (i == 2) {
            for (Integer intValue2 : list) {
                this.mCallProtos.get(intValue2.intValue()).srvccFailureCount++;
            }
        } else if (i == 3) {
            for (Integer intValue3 : list) {
                this.mCallProtos.get(intValue3.intValue()).srvccCancellationCount++;
            }
        }
    }

    public synchronized void onServiceStateChanged(ServiceState serviceState) {
        if (hasCalls()) {
            updateRatTracker(serviceState);
        }
    }

    private void acceptCall(Connection connection) {
        int connectionId = getConnectionId(connection);
        if (this.mCallProtos.contains(connectionId)) {
            logd("acceptCall: resetting setup info, connectionId=%d", Integer.valueOf(connectionId));
            PersistAtomsProto.VoiceCallSession voiceCallSession = this.mCallProtos.get(connectionId);
            voiceCallSession.setupBeginMillis = getTimeMillis();
            voiceCallSession.setupDuration = 0;
            return;
        }
        loge("acceptCall: untracked connection, connectionId=%d", Integer.valueOf(connectionId));
    }

    private void addCall(Connection connection) {
        int connectionId = getConnectionId(connection);
        boolean z = false;
        if (this.mCallProtos.contains(connectionId)) {
            loge("addCall: already tracked connection, connectionId=%d, connectionInfo=%s", Integer.valueOf(connectionId), connection);
            return;
        }
        int bearer = getBearer(connection);
        ServiceState serviceState = getServiceState();
        int voiceRat = ServiceStateStats.getVoiceRat(this.mPhone, serviceState);
        PersistAtomsProto.VoiceCallSession voiceCallSession = new PersistAtomsProto.VoiceCallSession();
        voiceCallSession.bearerAtStart = bearer;
        voiceCallSession.bearerAtEnd = bearer;
        voiceCallSession.direction = getDirection(connection);
        voiceCallSession.setupDuration = 0;
        voiceCallSession.setupFailed = true;
        voiceCallSession.disconnectReasonCode = connection.getDisconnectCause();
        voiceCallSession.disconnectExtraCode = connection.getPreciseDisconnectCause();
        voiceCallSession.disconnectExtraMessage = connection.getVendorDisconnectCause();
        voiceCallSession.ratAtStart = voiceRat;
        voiceCallSession.ratAtConnected = 0;
        voiceCallSession.ratAtEnd = voiceRat;
        voiceCallSession.ratSwitchCount = 0;
        voiceCallSession.codecBitmask = 0;
        voiceCallSession.simSlotIndex = this.mPhoneId;
        voiceCallSession.isMultiSim = SimSlotState.isMultiSim();
        voiceCallSession.isEsim = SimSlotState.isEsim(this.mPhoneId);
        voiceCallSession.carrierId = this.mPhone.getCarrierId();
        voiceCallSession.srvccCompleted = false;
        voiceCallSession.srvccFailureCount = 0;
        voiceCallSession.srvccCancellationCount = 0;
        voiceCallSession.rttEnabled = false;
        voiceCallSession.isEmergency = connection.isEmergencyCall();
        if (serviceState != null) {
            z = serviceState.getVoiceRoaming();
        }
        voiceCallSession.isRoaming = z;
        voiceCallSession.isMultiparty = connection.isMultiparty();
        voiceCallSession.setupBeginMillis = getTimeMillis();
        int audioQualityToCodec = audioQualityToCodec(bearer, connection.getAudioCodec());
        if (audioQualityToCodec != 0) {
            voiceCallSession.codecBitmask = 1 << audioQualityToCodec;
        }
        voiceCallSession.concurrentCallCountAtStart = this.mCallProtos.size();
        this.mCallProtos.put(connectionId, voiceCallSession);
        updateRatTracker(serviceState);
    }

    private void finishCall(int i) {
        PersistAtomsProto.VoiceCallSession voiceCallSession = this.mCallProtos.get(i);
        if (voiceCallSession == null) {
            loge("finishCall: could not find call to be removed, connectionId=%d", Integer.valueOf(i));
            return;
        }
        this.mCallProtos.delete(i);
        voiceCallSession.concurrentCallCountAtEnd = this.mCallProtos.size();
        voiceCallSession.signalStrengthAtEnd = getSignalStrength(voiceCallSession.ratAtEnd);
        voiceCallSession.mainCodecQuality = finalizeMainCodecQuality(i);
        voiceCallSession.setupBeginMillis = 0;
        if (voiceCallSession.disconnectExtraMessage == null) {
            voiceCallSession.disconnectExtraMessage = "";
        }
        if (voiceCallSession.carrierId <= 0) {
            voiceCallSession.carrierId = this.mPhone.getCarrierId();
        }
        this.mAtomsStorage.addVoiceCallSession(voiceCallSession);
        if (!hasCalls()) {
            this.mRatUsage.conclude(getTimeMillis());
            this.mAtomsStorage.addVoiceCallRatUsage(this.mRatUsage);
            this.mRatUsage.clear();
        }
    }

    private void setRttStarted(ImsPhoneConnection imsPhoneConnection) {
        int connectionId = getConnectionId(imsPhoneConnection);
        PersistAtomsProto.VoiceCallSession voiceCallSession = this.mCallProtos.get(connectionId);
        if (voiceCallSession == null) {
            loge("onRttStarted: untracked connection, connectionId=%d", Integer.valueOf(connectionId));
            return;
        }
        if (!(voiceCallSession.bearerAtStart == getBearer(imsPhoneConnection) && voiceCallSession.bearerAtEnd == getBearer(imsPhoneConnection))) {
            loge("onRttStarted: connection bearer mismatch but proceeding, connectionId=%d", Integer.valueOf(connectionId));
        }
        voiceCallSession.rttEnabled = true;
    }

    private Set<Integer> getConnectionIds() {
        HashSet hashSet = new HashSet();
        for (int i = 0; i < this.mCallProtos.size(); i++) {
            hashSet.add(Integer.valueOf(this.mCallProtos.keyAt(i)));
        }
        return hashSet;
    }

    private List<Integer> getImsConnectionIds() {
        ArrayList arrayList = new ArrayList(this.mCallProtos.size());
        for (int i = 0; i < this.mCallProtos.size(); i++) {
            if (this.mCallProtos.valueAt(i).bearerAtEnd == 2) {
                arrayList.add(Integer.valueOf(this.mCallProtos.keyAt(i)));
            }
        }
        return arrayList;
    }

    private boolean hasCalls() {
        return this.mCallProtos.size() > 0;
    }

    private void checkCallSetup(Connection connection, PersistAtomsProto.VoiceCallSession voiceCallSession) {
        if (voiceCallSession.setupBeginMillis != 0 && isSetupFinished(connection.getCall())) {
            int timeMillis = (int) (getTimeMillis() - voiceCallSession.setupBeginMillis);
            voiceCallSession.setupDurationMillis = timeMillis;
            voiceCallSession.setupDuration = classifySetupDuration(timeMillis);
            voiceCallSession.setupBeginMillis = 0;
        }
        if (voiceCallSession.setupFailed && connection.getState() == Call.State.ACTIVE) {
            voiceCallSession.setupFailed = false;
            voiceCallSession.ratAtConnected = ServiceStateStats.getVoiceRat(this.mPhone, getServiceState());
            resetCodecList(connection);
        }
    }

    private void updateRatTracker(ServiceState serviceState) {
        int i;
        int voiceRat = ServiceStateStats.getVoiceRat(this.mPhone, serviceState);
        if (voiceRat == 18) {
            i = 0;
        } else {
            i = ServiceStateStats.getBand(serviceState);
        }
        this.mRatUsage.add(this.mPhone.getCarrierId(), voiceRat, getTimeMillis(), getConnectionIds());
        for (int i2 = 0; i2 < this.mCallProtos.size(); i2++) {
            PersistAtomsProto.VoiceCallSession valueAt = this.mCallProtos.valueAt(i2);
            if (valueAt.ratAtEnd != voiceRat) {
                valueAt.ratSwitchCount++;
                valueAt.ratAtEnd = voiceRat;
            }
            valueAt.bandAtEnd = i;
        }
    }

    private void finishImsCall(int i, ImsReasonInfo imsReasonInfo, long j) {
        PersistAtomsProto.VoiceCallSession voiceCallSession = this.mCallProtos.get(i);
        voiceCallSession.bearerAtEnd = 2;
        voiceCallSession.disconnectReasonCode = imsReasonInfo.mCode;
        voiceCallSession.disconnectExtraCode = imsReasonInfo.mExtraCode;
        voiceCallSession.disconnectExtraMessage = ImsStats.filterExtraMessage(imsReasonInfo.mExtraMessage);
        voiceCallSession.callDuration = classifyCallDuration(j);
        finishCall(i);
    }

    private ServiceState getServiceState() {
        ServiceStateTracker serviceStateTracker = this.mPhone.getServiceStateTracker();
        if (serviceStateTracker != null) {
            return serviceStateTracker.getServiceState();
        }
        return null;
    }

    private static int getDirection(Connection connection) {
        return connection.isIncoming() ? 2 : 1;
    }

    private static int getBearer(Connection connection) {
        int phoneType = connection.getPhoneType();
        if (phoneType == 1 || phoneType == 2) {
            return 1;
        }
        if (phoneType == 5) {
            return 2;
        }
        loge("getBearer: unknown phoneType=%d", Integer.valueOf(phoneType));
        return 0;
    }

    private int getSignalStrength(int i) {
        if (i == 18) {
            return getSignalStrengthWifi();
        }
        return getSignalStrengthCellular();
    }

    private int getSignalStrengthWifi() {
        WifiManager wifiManager = (WifiManager) this.mPhone.getContext().getSystemService("wifi");
        WifiInfo connectionInfo = wifiManager.getConnectionInfo();
        if (connectionInfo == null) {
            return 0;
        }
        int calculateSignalLevel = wifiManager.calculateSignalLevel(connectionInfo.getRssi());
        int maxSignalLevel = wifiManager.getMaxSignalLevel();
        int i = (calculateSignalLevel * 4) / maxSignalLevel;
        logd("WiFi level: " + i + " (" + calculateSignalLevel + "/" + maxSignalLevel + ")", new Object[0]);
        return i;
    }

    private int getSignalStrengthCellular() {
        return this.mPhone.getSignalStrength().getLevel();
    }

    private void resetCodecList(Connection connection) {
        int connectionId = getConnectionId(connection);
        LongSparseArray longSparseArray = this.mCodecUsage.get(connectionId);
        if (longSparseArray != null) {
            int intValue = ((Integer) longSparseArray.valueAt(longSparseArray.size() - 1)).intValue();
            LongSparseArray longSparseArray2 = new LongSparseArray();
            longSparseArray2.append(getTimeMillis(), Integer.valueOf(intValue));
            this.mCodecUsage.put(connectionId, longSparseArray2);
        }
    }

    private int finalizeMainCodecQuality(int i) {
        if (!this.mCodecUsage.contains(i)) {
            return 0;
        }
        LongSparseArray longSparseArray = this.mCodecUsage.get(i);
        this.mCodecUsage.delete(i);
        longSparseArray.put(getTimeMillis(), 0);
        long[] jArr = new long[5];
        int i2 = 0;
        int i3 = 0;
        while (i2 < longSparseArray.size() - 1) {
            int i4 = i2 + 1;
            long keyAt = longSparseArray.keyAt(i4) - longSparseArray.keyAt(i2);
            int codecQuality = getCodecQuality(((Integer) longSparseArray.valueAt(i2)).intValue());
            jArr[codecQuality] = jArr[codecQuality] + keyAt;
            i3 = (int) (((long) i3) + keyAt);
            i2 = i4;
        }
        logd("Time per codec quality = " + Arrays.toString(jArr), new Object[0]);
        long j = 0;
        long j2 = (long) ((i3 * 70) / 100);
        for (int i5 = 4; i5 >= 0; i5--) {
            j += jArr[i5];
            if (j >= j2) {
                return i5;
            }
        }
        return 0;
    }

    /* renamed from: com.android.internal.telephony.metrics.VoiceCallSessionStats$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$Call$State;

        /* JADX WARNING: Can't wrap try/catch for region: R(6:0|1|2|3|4|6) */
        /* JADX WARNING: Code restructure failed: missing block: B:7:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        static {
            /*
                com.android.internal.telephony.Call$State[] r0 = com.android.internal.telephony.Call.State.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$Call$State = r0
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.ACTIVE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.ALERTING     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.VoiceCallSessionStats.AnonymousClass1.<clinit>():void");
        }
    }

    private static boolean isSetupFinished(Call call) {
        if (call == null) {
            return false;
        }
        int i = AnonymousClass1.$SwitchMap$com$android$internal$telephony$Call$State[call.getState().ordinal()];
        return i == 1 || i == 2;
    }

    private static int audioQualityToCodec(int i, int i2) {
        if (i == 1) {
            return CS_CODEC_MAP.get(i2, 0);
        }
        if (i == 2) {
            return IMS_CODEC_MAP.get(i2, 0);
        }
        loge("audioQualityToCodec: unknown bearer %d", Integer.valueOf(i));
        return 0;
    }

    private static int classifySetupDuration(int i) {
        int i2 = 0;
        while (true) {
            SparseIntArray sparseIntArray = CALL_SETUP_DURATION_MAP;
            if (i2 >= sparseIntArray.size()) {
                return 9;
            }
            if (i < sparseIntArray.keyAt(i2)) {
                return sparseIntArray.valueAt(i2);
            }
            i2++;
        }
    }

    private static int classifyCallDuration(long j) {
        int i = 0;
        if (j == 0) {
            return 0;
        }
        while (true) {
            SparseIntArray sparseIntArray = CALL_DURATION_MAP;
            if (i >= sparseIntArray.size()) {
                return 6;
            }
            if (j < ((long) sparseIntArray.keyAt(i))) {
                return sparseIntArray.valueAt(i);
            }
            i++;
        }
    }

    /* access modifiers changed from: private */
    public static int getConnectionId(Connection connection) {
        if (connection == null) {
            return 0;
        }
        return (int) connection.getCreateTime();
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public long getTimeMillis() {
        return SystemClock.elapsedRealtime();
    }

    private static void logd(String str, Object... objArr) {
        Rlog.d(TAG, String.format(str, objArr));
    }

    private static void loge(String str, Object... objArr) {
        Rlog.e(TAG, String.format(str, objArr));
    }

    private static SparseIntArray buildGsmCdmaCodecMap() {
        SparseIntArray sparseIntArray = new SparseIntArray();
        sparseIntArray.put(1, 1);
        sparseIntArray.put(2, 2);
        sparseIntArray.put(3, 8);
        sparseIntArray.put(4, 9);
        sparseIntArray.put(5, 10);
        sparseIntArray.put(6, 4);
        sparseIntArray.put(7, 5);
        sparseIntArray.put(8, 6);
        sparseIntArray.put(9, 7);
        return sparseIntArray;
    }

    private static SparseIntArray buildImsCodecMap() {
        SparseIntArray sparseIntArray = new SparseIntArray();
        sparseIntArray.put(1, 1);
        sparseIntArray.put(2, 2);
        sparseIntArray.put(3, 3);
        sparseIntArray.put(4, 4);
        sparseIntArray.put(5, 5);
        sparseIntArray.put(6, 6);
        sparseIntArray.put(7, 7);
        sparseIntArray.put(8, 8);
        sparseIntArray.put(9, 9);
        sparseIntArray.put(10, 10);
        sparseIntArray.put(11, 11);
        sparseIntArray.put(12, 12);
        sparseIntArray.put(13, 13);
        sparseIntArray.put(14, 14);
        sparseIntArray.put(15, 15);
        sparseIntArray.put(16, 16);
        sparseIntArray.put(17, 17);
        sparseIntArray.put(18, 18);
        sparseIntArray.put(19, 19);
        sparseIntArray.put(20, 20);
        return sparseIntArray;
    }

    private static SparseIntArray buildCallSetupDurationMap() {
        SparseIntArray sparseIntArray = new SparseIntArray();
        sparseIntArray.put(0, 0);
        sparseIntArray.put(CALL_SETUP_DURATION_EXTREMELY_FAST, 1);
        sparseIntArray.put(CALL_SETUP_DURATION_ULTRA_FAST, 2);
        sparseIntArray.put(1000, 3);
        sparseIntArray.put(1500, 4);
        sparseIntArray.put(2500, 5);
        sparseIntArray.put(CALL_SETUP_DURATION_SLOW, 6);
        sparseIntArray.put(6000, 7);
        sparseIntArray.put(CALL_SETUP_DURATION_ULTRA_SLOW, 8);
        return sparseIntArray;
    }

    private static SparseIntArray buildCallDurationMap() {
        SparseIntArray sparseIntArray = new SparseIntArray();
        sparseIntArray.put(60000, 1);
        sparseIntArray.put(CALL_DURATION_FIVE_MINUTES, 2);
        sparseIntArray.put(600000, 3);
        sparseIntArray.put(CALL_DURATION_THIRTY_MINUTES, 4);
        sparseIntArray.put(CALL_DURATION_ONE_HOUR, 5);
        return sparseIntArray;
    }
}
