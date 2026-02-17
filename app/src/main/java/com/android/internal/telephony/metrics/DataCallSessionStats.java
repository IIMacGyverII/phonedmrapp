package com.android.internal.telephony.metrics;

import android.os.SystemClock;
import android.telephony.ServiceState;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.ServiceStateTracker;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.telephony.Rlog;
import java.util.Arrays;
import java.util.Random;

public class DataCallSessionStats {
    private static final Random RANDOM = new Random();
    private static final int SIZE_LIMIT_HANDOVER_FAILURE_CAUSES = 15;
    private static final String TAG = "DataCallSessionStats";
    private final PersistAtomsStorage mAtomsStorage = PhoneFactory.getMetricsCollector().getAtomsStorage();
    private PersistAtomsProto.DataCallSession mDataCallSession;
    private final Phone mPhone;
    private long mStartTime;

    public DataCallSessionStats(Phone phone) {
        this.mPhone = phone;
    }

    public synchronized void onSetupDataCall(int i) {
        this.mDataCallSession = getDefaultProto(i);
        this.mStartTime = getTimeMillis();
        PhoneFactory.getMetricsCollector().registerOngoingDataCallStat(this);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:23:0x0047, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onSetupDataCallResponse(android.telephony.data.DataCallResponse r4, int r5, int r6, int r7, int r8) {
        /*
            r3 = this;
            monitor-enter(r3)
            com.android.internal.telephony.nano.PersistAtomsProto$DataCallSession r0 = r3.mDataCallSession     // Catch:{ all -> 0x0048 }
            r1 = 0
            if (r0 != 0) goto L_0x000f
            java.lang.String r4 = "onSetupDataCallResponse: no DataCallSession atom has been initiated."
            java.lang.Object[] r5 = new java.lang.Object[r1]     // Catch:{ all -> 0x0048 }
            r3.loge(r4, r5)     // Catch:{ all -> 0x0048 }
            monitor-exit(r3)
            return
        L_0x000f:
            if (r5 == 0) goto L_0x0020
            r0.ratAtEnd = r5     // Catch:{ all -> 0x0048 }
            r2 = 18
            if (r5 != r2) goto L_0x0018
            goto L_0x001e
        L_0x0018:
            com.android.internal.telephony.Phone r5 = r3.mPhone     // Catch:{ all -> 0x0048 }
            int r1 = com.android.internal.telephony.metrics.ServiceStateStats.getBand((com.android.internal.telephony.Phone) r5)     // Catch:{ all -> 0x0048 }
        L_0x001e:
            r0.bandAtEnd = r1     // Catch:{ all -> 0x0048 }
        L_0x0020:
            com.android.internal.telephony.nano.PersistAtomsProto$DataCallSession r5 = r3.mDataCallSession     // Catch:{ all -> 0x0048 }
            int r0 = r5.apnTypeBitmask     // Catch:{ all -> 0x0048 }
            if (r0 != 0) goto L_0x0028
            r5.apnTypeBitmask = r6     // Catch:{ all -> 0x0048 }
        L_0x0028:
            r5.ipType = r7     // Catch:{ all -> 0x0048 }
            r5.failureCause = r8     // Catch:{ all -> 0x0048 }
            if (r4 == 0) goto L_0x0046
            long r6 = r4.getRetryDurationMillis()     // Catch:{ all -> 0x0048 }
            r0 = 2147483647(0x7fffffff, double:1.060997895E-314)
            long r6 = java.lang.Math.min(r6, r0)     // Catch:{ all -> 0x0048 }
            int r4 = (int) r6     // Catch:{ all -> 0x0048 }
            r5.suggestedRetryMillis = r4     // Catch:{ all -> 0x0048 }
            if (r8 == 0) goto L_0x0046
            com.android.internal.telephony.nano.PersistAtomsProto$DataCallSession r4 = r3.mDataCallSession     // Catch:{ all -> 0x0048 }
            r5 = 1
            r4.setupFailed = r5     // Catch:{ all -> 0x0048 }
            r3.endDataCallSession()     // Catch:{ all -> 0x0048 }
        L_0x0046:
            monitor-exit(r3)
            return
        L_0x0048:
            r4 = move-exception
            monitor-exit(r3)
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.DataCallSessionStats.onSetupDataCallResponse(android.telephony.data.DataCallResponse, int, int, int, int):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:19:0x0024, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void setDeactivateDataCallReason(int r4) {
        /*
            r3 = this;
            monitor-enter(r3)
            com.android.internal.telephony.nano.PersistAtomsProto$DataCallSession r0 = r3.mDataCallSession     // Catch:{ all -> 0x0025 }
            r1 = 0
            if (r0 != 0) goto L_0x000f
            java.lang.String r4 = "setDeactivateDataCallReason: no DataCallSession atom has been initiated."
            java.lang.Object[] r0 = new java.lang.Object[r1]     // Catch:{ all -> 0x0025 }
            r3.loge(r4, r0)     // Catch:{ all -> 0x0025 }
            monitor-exit(r3)
            return
        L_0x000f:
            r2 = 1
            if (r4 == r2) goto L_0x0021
            r2 = 2
            if (r4 == r2) goto L_0x001e
            r2 = 3
            if (r4 == r2) goto L_0x001b
            r0.deactivateReason = r1     // Catch:{ all -> 0x0025 }
            goto L_0x0023
        L_0x001b:
            r0.deactivateReason = r2     // Catch:{ all -> 0x0025 }
            goto L_0x0023
        L_0x001e:
            r0.deactivateReason = r2     // Catch:{ all -> 0x0025 }
            goto L_0x0023
        L_0x0021:
            r0.deactivateReason = r2     // Catch:{ all -> 0x0025 }
        L_0x0023:
            monitor-exit(r3)
            return
        L_0x0025:
            r4 = move-exception
            monitor-exit(r3)
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.DataCallSessionStats.setDeactivateDataCallReason(int):void");
    }

    public synchronized void onDataCallDisconnected(int i) {
        PersistAtomsProto.DataCallSession dataCallSession = this.mDataCallSession;
        if (dataCallSession == null) {
            logi("onDataCallDisconnected: no DataCallSession atom has been initiated.", new Object[0]);
            return;
        }
        dataCallSession.failureCause = i;
        dataCallSession.durationMinutes = convertMillisToMinutes(getTimeMillis() - this.mStartTime);
        endDataCallSession();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:16:0x002c, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onHandoverFailure(int r5) {
        /*
            r4 = this;
            monitor-enter(r4)
            com.android.internal.telephony.nano.PersistAtomsProto$DataCallSession r0 = r4.mDataCallSession     // Catch:{ all -> 0x002d }
            if (r0 == 0) goto L_0x002b
            int[] r0 = r0.handoverFailureCauses     // Catch:{ all -> 0x002d }
            int r1 = r0.length     // Catch:{ all -> 0x002d }
            r2 = 15
            if (r1 >= r2) goto L_0x002b
            int r1 = r0.length     // Catch:{ all -> 0x002d }
            r2 = 0
        L_0x000e:
            if (r2 >= r1) goto L_0x0019
            r3 = r0[r2]     // Catch:{ all -> 0x002d }
            if (r5 != r3) goto L_0x0016
            monitor-exit(r4)
            return
        L_0x0016:
            int r2 = r2 + 1
            goto L_0x000e
        L_0x0019:
            com.android.internal.telephony.nano.PersistAtomsProto$DataCallSession r1 = r4.mDataCallSession     // Catch:{ all -> 0x002d }
            int r2 = r0.length     // Catch:{ all -> 0x002d }
            int r2 = r2 + 1
            int[] r2 = java.util.Arrays.copyOf(r0, r2)     // Catch:{ all -> 0x002d }
            r1.handoverFailureCauses = r2     // Catch:{ all -> 0x002d }
            com.android.internal.telephony.nano.PersistAtomsProto$DataCallSession r1 = r4.mDataCallSession     // Catch:{ all -> 0x002d }
            int[] r1 = r1.handoverFailureCauses     // Catch:{ all -> 0x002d }
            int r0 = r0.length     // Catch:{ all -> 0x002d }
            r1[r0] = r5     // Catch:{ all -> 0x002d }
        L_0x002b:
            monitor-exit(r4)
            return
        L_0x002d:
            r5 = move-exception
            monitor-exit(r4)
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.DataCallSessionStats.onHandoverFailure(int):void");
    }

    public synchronized void onDrsOrRatChanged(int i) {
        int i2;
        PersistAtomsProto.DataCallSession dataCallSession = this.mDataCallSession;
        if (!(dataCallSession == null || i == 0)) {
            if (dataCallSession.ratAtEnd != i) {
                dataCallSession.ratSwitchCount++;
                dataCallSession.ratAtEnd = i;
            }
            if (i == 18) {
                i2 = 0;
            } else {
                i2 = ServiceStateStats.getBand(this.mPhone);
            }
            dataCallSession.bandAtEnd = i2;
        }
    }

    public synchronized void conclude() {
        PersistAtomsProto.DataCallSession dataCallSession = this.mDataCallSession;
        if (dataCallSession != null) {
            PersistAtomsProto.DataCallSession copyOf = copyOf(dataCallSession);
            long timeMillis = getTimeMillis();
            copyOf.durationMinutes = convertMillisToMinutes(timeMillis - this.mStartTime);
            this.mStartTime = timeMillis;
            PersistAtomsProto.DataCallSession dataCallSession2 = this.mDataCallSession;
            dataCallSession2.ratSwitchCount = 0;
            dataCallSession2.handoverFailureCauses = new int[0];
            this.mAtomsStorage.addDataCallSession(copyOf);
        }
    }

    private void endDataCallSession() {
        this.mDataCallSession.oosAtEnd = getIsOos();
        this.mDataCallSession.ongoing = false;
        PhoneFactory.getMetricsCollector().unregisterOngoingDataCallStat(this);
        this.mAtomsStorage.addDataCallSession(this.mDataCallSession);
        this.mDataCallSession = null;
    }

    private static long convertMillisToMinutes(long j) {
        return Math.round(((double) j) / 60000.0d);
    }

    private static PersistAtomsProto.DataCallSession copyOf(PersistAtomsProto.DataCallSession dataCallSession) {
        PersistAtomsProto.DataCallSession dataCallSession2 = new PersistAtomsProto.DataCallSession();
        dataCallSession2.dimension = dataCallSession.dimension;
        dataCallSession2.isMultiSim = dataCallSession.isMultiSim;
        dataCallSession2.isEsim = dataCallSession.isEsim;
        dataCallSession2.apnTypeBitmask = dataCallSession.apnTypeBitmask;
        dataCallSession2.carrierId = dataCallSession.carrierId;
        dataCallSession2.isRoaming = dataCallSession.isRoaming;
        dataCallSession2.ratAtEnd = dataCallSession.ratAtEnd;
        dataCallSession2.oosAtEnd = dataCallSession.oosAtEnd;
        dataCallSession2.ratSwitchCount = dataCallSession.ratSwitchCount;
        dataCallSession2.isOpportunistic = dataCallSession.isOpportunistic;
        dataCallSession2.ipType = dataCallSession.ipType;
        dataCallSession2.setupFailed = dataCallSession.setupFailed;
        dataCallSession2.failureCause = dataCallSession.failureCause;
        dataCallSession2.suggestedRetryMillis = dataCallSession.suggestedRetryMillis;
        dataCallSession2.deactivateReason = dataCallSession.deactivateReason;
        dataCallSession2.durationMinutes = dataCallSession.durationMinutes;
        dataCallSession2.ongoing = dataCallSession.ongoing;
        dataCallSession2.bandAtEnd = dataCallSession.bandAtEnd;
        int[] iArr = dataCallSession.handoverFailureCauses;
        dataCallSession2.handoverFailureCauses = Arrays.copyOf(iArr, iArr.length);
        return dataCallSession2;
    }

    private PersistAtomsProto.DataCallSession getDefaultProto(int i) {
        PersistAtomsProto.DataCallSession dataCallSession = new PersistAtomsProto.DataCallSession();
        dataCallSession.dimension = RANDOM.nextInt();
        dataCallSession.isMultiSim = SimSlotState.isMultiSim();
        dataCallSession.isEsim = SimSlotState.isEsim(this.mPhone.getPhoneId());
        dataCallSession.apnTypeBitmask = i;
        dataCallSession.carrierId = this.mPhone.getCarrierId();
        dataCallSession.isRoaming = getIsRoaming();
        dataCallSession.oosAtEnd = false;
        dataCallSession.ratSwitchCount = 0;
        dataCallSession.isOpportunistic = getIsOpportunistic();
        dataCallSession.ipType = 0;
        dataCallSession.setupFailed = false;
        dataCallSession.failureCause = 0;
        dataCallSession.suggestedRetryMillis = 0;
        dataCallSession.deactivateReason = 0;
        dataCallSession.durationMinutes = 0;
        dataCallSession.ongoing = true;
        dataCallSession.handoverFailureCauses = new int[0];
        return dataCallSession;
    }

    private boolean getIsRoaming() {
        ServiceStateTracker serviceStateTracker = this.mPhone.getServiceStateTracker();
        ServiceState serviceState = serviceStateTracker != null ? serviceStateTracker.getServiceState() : null;
        if (serviceState != null) {
            return serviceState.getRoaming();
        }
        return false;
    }

    private boolean getIsOpportunistic() {
        SubscriptionController instance = SubscriptionController.getInstance();
        if (instance != null) {
            return instance.isOpportunistic(this.mPhone.getSubId());
        }
        return false;
    }

    private boolean getIsOos() {
        ServiceStateTracker serviceStateTracker = this.mPhone.getServiceStateTracker();
        ServiceState serviceState = serviceStateTracker != null ? serviceStateTracker.getServiceState() : null;
        if (serviceState == null || serviceState.getDataRegistrationState() != 1) {
            return false;
        }
        return true;
    }

    private void logi(String str, Object... objArr) {
        String str2 = TAG;
        Rlog.i(str2, "[" + this.mPhone.getPhoneId() + "]" + String.format(str, objArr));
    }

    private void loge(String str, Object... objArr) {
        String str2 = TAG;
        Rlog.e(str2, "[" + this.mPhone.getPhoneId() + "]" + String.format(str, objArr));
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public long getTimeMillis() {
        return SystemClock.elapsedRealtime();
    }
}
