package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.telephony.CarrierConfigManager;
import android.telephony.CellLocation;
import android.telephony.TelephonyManager;
import android.telephony.cdma.CdmaCellLocation;
import android.telephony.emergency.EmergencyNumber;
import android.telephony.gsm.GsmCellLocation;
import android.util.EventLog;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.DriverCall;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.cdma.CdmaCallWaitingNotification;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class GsmCdmaCallTracker extends CallTracker {
    protected static final boolean DBG_POLL = false;
    protected static final String LOG_TAG = "GsmCdmaCallTracker";
    protected static final int MAX_CONNECTIONS_CDMA = 8;
    public static final int MAX_CONNECTIONS_GSM = 19;
    private static final int MAX_CONNECTIONS_PER_CALL_CDMA = 1;
    private static final int MAX_CONNECTIONS_PER_CALL_GSM = 5;
    protected static final boolean REPEAT_POLLING = false;
    protected static final boolean VDBG = false;
    protected int m3WayCallFlashDelay;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GsmCdmaCall mBackgroundCall = new GsmCdmaCall(this);
    private RegistrantList mCallWaitingRegistrants = new RegistrantList();
    @VisibleForTesting
    public GsmCdmaConnection[] mConnections;
    private boolean mDesiredMute = false;
    protected ArrayList<GsmCdmaConnection> mDroppedDuringPoll = new ArrayList<>(19);
    private BroadcastReceiver mEcmExitReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals("android.intent.action.EMERGENCY_CALLBACK_MODE_CHANGED")) {
                boolean booleanExtra = intent.getBooleanExtra("android.telephony.extra.PHONE_IN_ECM_STATE", false);
                GsmCdmaCallTracker gsmCdmaCallTracker = GsmCdmaCallTracker.this;
                gsmCdmaCallTracker.log("Received ACTION_EMERGENCY_CALLBACK_MODE_CHANGED isInEcm = " + booleanExtra);
                if (!booleanExtra) {
                    ArrayList<Connection> arrayList = new ArrayList<>();
                    arrayList.addAll(GsmCdmaCallTracker.this.mRingingCall.getConnections());
                    arrayList.addAll(GsmCdmaCallTracker.this.mForegroundCall.getConnections());
                    arrayList.addAll(GsmCdmaCallTracker.this.mBackgroundCall.getConnections());
                    GsmCdmaConnection gsmCdmaConnection = GsmCdmaCallTracker.this.mPendingMO;
                    if (gsmCdmaConnection != null) {
                        arrayList.add(gsmCdmaConnection);
                    }
                    for (Connection connection : arrayList) {
                        if (connection != null) {
                            connection.onExitedEcmMode();
                        }
                    }
                }
            }
        }
    };
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GsmCdmaCall mForegroundCall = new GsmCdmaCall(this);
    protected boolean mHangupPendingMO;
    protected boolean mIsInEmergencyCall;
    protected TelephonyMetrics mMetrics = TelephonyMetrics.getInstance();
    protected int mPendingCallClirMode;
    protected boolean mPendingCallInEcm;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected GsmCdmaConnection mPendingMO;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GsmCdmaPhone mPhone;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GsmCdmaCall mRingingCall = new GsmCdmaCall(this);
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public PhoneConstants.State mState = PhoneConstants.State.IDLE;
    protected RegistrantList mVoiceCallEndedRegistrants = new RegistrantList();
    protected RegistrantList mVoiceCallStartedRegistrants = new RegistrantList();

    private boolean isEmcRetryCause(int i) {
        return i == 3001 || i == 3002;
    }

    /* access modifiers changed from: protected */
    public void onAfterNotifyHandoverStateChanged(int i) {
    }

    /* access modifiers changed from: protected */
    public void onBeforeDisconnectPendingHandOverConnection() {
    }

    /* access modifiers changed from: protected */
    public void onBeforeNotifyHandoverStateChanged() {
    }

    /* access modifiers changed from: protected */
    public void onBeforeNotifyNewRing(List list) {
    }

    /* access modifiers changed from: protected */
    public void onCallStateIdle(Phone phone) {
    }

    /* access modifiers changed from: protected */
    public void onCallStateOffhook() {
    }

    /* access modifiers changed from: protected */
    public void onCdmaMoMtCallConflict(DriverCall driverCall, GsmCdmaCallTracker gsmCdmaCallTracker, int i) {
    }

    /* access modifiers changed from: protected */
    public boolean onCheckHoConnection(Connection connection, int i) {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean onCheckIfDisablePollCallAfterReset() {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean onCheckIfIgnoreInternalClearDisconnected() {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean onCheckIfSendDisconnected() {
        return true;
    }

    /* access modifiers changed from: protected */
    public void onDoHandupPendingMoException() {
    }

    /* access modifiers changed from: protected */
    public void onDoHangupPendingMo() {
    }

    /* access modifiers changed from: protected */
    public boolean onGetCallListDone(List list) {
        return false;
    }

    /* access modifiers changed from: protected */
    public void onGsmConnectionDropped(GsmCdmaConnection gsmCdmaConnection, int i) {
    }

    /* access modifiers changed from: protected */
    public void onGsmDialBeforeHoldActiveCall() {
    }

    /* access modifiers changed from: protected */
    public void onGsmDialInvalidNumber() {
    }

    /* access modifiers changed from: protected */
    public boolean onHandleDroppedConnectionDuringPoll(Throwable th, int i) {
        return false;
    }

    /* access modifiers changed from: protected */
    public void onHandlePollCallsEnd() {
    }

    /* access modifiers changed from: protected */
    public void onHandlePollCallsStart() {
    }

    /* access modifiers changed from: protected */
    public void onHangupPendingMo() {
    }

    /* access modifiers changed from: protected */
    public void onPendingMoDroppedDuringPoll() {
    }

    /* access modifiers changed from: protected */
    public boolean onSetHasAnyCallDisconnected(Throwable th, GsmCdmaConnection gsmCdmaConnection, boolean z) {
        return z;
    }

    /* access modifiers changed from: protected */
    public boolean onSetWasDisconnected(Throwable th, boolean z) {
        return z;
    }

    public GsmCdmaCallTracker(GsmCdmaPhone gsmCdmaPhone) {
        this.mPhone = gsmCdmaPhone;
        CommandsInterface commandsInterface = gsmCdmaPhone.mCi;
        this.mCi = commandsInterface;
        commandsInterface.registerForCallStateChanged(this, 2, (Object) null);
        this.mCi.registerForOn(this, 9, (Object) null);
        this.mCi.registerForNotAvailable(this, 10, (Object) null);
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.intent.action.EMERGENCY_CALLBACK_MODE_CHANGED");
        this.mPhone.getContext().registerReceiver(this.mEcmExitReceiver, intentFilter);
        updatePhoneType(true);
    }

    public void updatePhoneType() {
        updatePhoneType(false);
    }

    /* access modifiers changed from: protected */
    public void updatePhoneType(boolean z) {
        if (!z) {
            reset();
            if (!onCheckIfDisablePollCallAfterReset()) {
                pollCallsWhenSafe();
            }
        }
        if (this.mPhone.isPhoneTypeGsm()) {
            this.mConnections = new GsmCdmaConnection[19];
            this.mCi.unregisterForCallWaitingInfo(this);
            if (this.mIsInEmergencyCall && !this.mPhone.isUsingNewDataStack()) {
                this.mPhone.getDataEnabledSettings().setInternalDataEnabled(true);
                return;
            }
            return;
        }
        this.mConnections = new GsmCdmaConnection[8];
        this.mPendingCallInEcm = false;
        this.mIsInEmergencyCall = false;
        this.mPendingCallClirMode = 0;
        this.mPhone.setEcmCanceledForEmergency(false);
        this.m3WayCallFlashDelay = 0;
        this.mCi.registerForCallWaitingInfo(this, 15, (Object) null);
    }

    /* access modifiers changed from: protected */
    public void reset() {
        Rlog.d(LOG_TAG, "reset");
        for (GsmCdmaConnection gsmCdmaConnection : this.mConnections) {
            if (gsmCdmaConnection != null) {
                if (onCheckIfSendDisconnected()) {
                    gsmCdmaConnection.onDisconnect(36);
                }
                gsmCdmaConnection.dispose();
            }
        }
        if (this.mPendingMO != null) {
            if (onCheckIfSendDisconnected()) {
                this.mPendingMO.onDisconnect(36);
            }
            this.mPendingMO.dispose();
        }
        this.mConnections = null;
        this.mPendingMO = null;
        clearDisconnected();
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        Rlog.d(LOG_TAG, "GsmCdmaCallTracker finalized");
    }

    public void registerForVoiceCallStarted(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mVoiceCallStartedRegistrants.add(registrant);
        if (this.mState != PhoneConstants.State.IDLE) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        }
    }

    public void unregisterForVoiceCallStarted(Handler handler) {
        this.mVoiceCallStartedRegistrants.remove(handler);
    }

    public void registerForVoiceCallEnded(Handler handler, int i, Object obj) {
        this.mVoiceCallEndedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForVoiceCallEnded(Handler handler) {
        this.mVoiceCallEndedRegistrants.remove(handler);
    }

    public void registerForCallWaiting(Handler handler, int i, Object obj) {
        this.mCallWaitingRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForCallWaiting(Handler handler) {
        this.mCallWaitingRegistrants.remove(handler);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void fakeHoldForegroundBeforeDial() {
        Iterator<Connection> it = this.mForegroundCall.getConnections().iterator();
        while (it.hasNext()) {
            ((GsmCdmaConnection) it.next()).fakeHoldBeforeDial();
        }
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(6:7|8|9|10|11|12) */
    /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x0042 */
    /* JADX WARNING: Removed duplicated region for block: B:29:0x00f3  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized com.android.internal.telephony.Connection dialGsm(java.lang.String r11, com.android.internal.telephony.PhoneInternalInterface.DialArgs r12) throws com.android.internal.telephony.CallStateException {
        /*
            r10 = this;
            monitor-enter(r10)
            int r1 = r12.clirMode     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.UUSInfo r7 = r12.uusInfo     // Catch:{ all -> 0x010e }
            android.os.Bundle r8 = r12.intentExtras     // Catch:{ all -> 0x010e }
            boolean r2 = r12.isEmergency     // Catch:{ all -> 0x010e }
            if (r2 == 0) goto L_0x0020
            r1 = 2
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x010e }
            r3.<init>()     // Catch:{ all -> 0x010e }
            java.lang.String r4 = "dial gsm emergency call, set clirModIe="
            r3.append(r4)     // Catch:{ all -> 0x010e }
            r3.append(r1)     // Catch:{ all -> 0x010e }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x010e }
            r10.log(r3)     // Catch:{ all -> 0x010e }
        L_0x0020:
            r9 = r1
            r10.clearDisconnected()     // Catch:{ all -> 0x010e }
            r10.checkForDialIssues(r2)     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaPhone r1 = r10.mPhone     // Catch:{ all -> 0x010e }
            java.lang.String r3 = r10.convertNumberIfNecessary(r1, r11)     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaCall r1 = r10.mForegroundCall     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.Call$State r1 = r1.getState()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.Call$State r2 = com.android.internal.telephony.Call.State.ACTIVE     // Catch:{ all -> 0x010e }
            if (r1 != r2) goto L_0x0045
            r10.onGsmDialBeforeHoldActiveCall()     // Catch:{ all -> 0x010e }
            r10.switchWaitingOrHoldingAndActive()     // Catch:{ all -> 0x010e }
            r1 = 500(0x1f4, double:2.47E-321)
            java.lang.Thread.sleep(r1)     // Catch:{ InterruptedException -> 0x0042 }
        L_0x0042:
            r10.fakeHoldForegroundBeforeDial()     // Catch:{ all -> 0x010e }
        L_0x0045:
            com.android.internal.telephony.GsmCdmaCall r1 = r10.mForegroundCall     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.Call$State r1 = r1.getState()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.Call$State r2 = com.android.internal.telephony.Call.State.IDLE     // Catch:{ all -> 0x010e }
            if (r1 != r2) goto L_0x0106
            com.android.internal.telephony.GsmCdmaPhone r2 = r10.mPhone     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaCall r5 = r10.mForegroundCall     // Catch:{ all -> 0x010e }
            r1 = r10
            r4 = r10
            r6 = r12
            com.android.internal.telephony.GsmCdmaConnection r1 = r1.onCreateGsmCdmaConnection(r2, r3, r4, r5, r6)     // Catch:{ all -> 0x010e }
            r10.mPendingMO = r1     // Catch:{ all -> 0x010e }
            if (r8 == 0) goto L_0x0085
            java.lang.String r1 = "GsmCdmaCallTracker"
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x010e }
            r2.<init>()     // Catch:{ all -> 0x010e }
            java.lang.String r3 = "dialGsm - emergency dialer: "
            r2.append(r3)     // Catch:{ all -> 0x010e }
            java.lang.String r3 = "android.telecom.extra.IS_USER_INTENT_EMERGENCY_CALL"
            boolean r3 = r8.getBoolean(r3)     // Catch:{ all -> 0x010e }
            r2.append(r3)     // Catch:{ all -> 0x010e }
            java.lang.String r2 = r2.toString()     // Catch:{ all -> 0x010e }
            com.android.telephony.Rlog.d(r1, r2)     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            java.lang.String r2 = "android.telecom.extra.IS_USER_INTENT_EMERGENCY_CALL"
            boolean r2 = r8.getBoolean(r2)     // Catch:{ all -> 0x010e }
            r1.setHasKnownUserIntentEmergency(r2)     // Catch:{ all -> 0x010e }
        L_0x0085:
            r8 = 0
            r10.mHangupPendingMO = r8     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.metrics.TelephonyMetrics r1 = r10.mMetrics     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaPhone r2 = r10.mPhone     // Catch:{ all -> 0x010e }
            int r2 = r2.getPhoneId()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r3 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            r1.writeRilDial(r2, r3, r9, r7)     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaPhone r1 = r10.mPhone     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.metrics.VoiceCallSessionStats r1 = r1.getVoiceCallSessionStats()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r2 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            r1.onRilDial(r2)     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            java.lang.String r1 = r1.getAddress()     // Catch:{ all -> 0x010e }
            if (r1 == 0) goto L_0x00e4
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            java.lang.String r1 = r1.getAddress()     // Catch:{ all -> 0x010e }
            int r1 = r1.length()     // Catch:{ all -> 0x010e }
            if (r1 == 0) goto L_0x00e4
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            java.lang.String r1 = r1.getAddress()     // Catch:{ all -> 0x010e }
            r2 = 78
            int r1 = r1.indexOf(r2)     // Catch:{ all -> 0x010e }
            if (r1 < 0) goto L_0x00c3
            goto L_0x00e4
        L_0x00c3:
            r10.setMute(r8)     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            java.lang.String r2 = r1.getAddress()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            boolean r3 = r1.isEmergencyCall()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            android.telephony.emergency.EmergencyNumber r4 = r1.getEmergencyNumberInfo()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            boolean r5 = r1.hasKnownUserIntentEmergency()     // Catch:{ all -> 0x010e }
            r1 = r10
            r6 = r9
            r1.onGsmDial(r2, r3, r4, r5, r6, r7)     // Catch:{ all -> 0x010e }
            goto L_0x00ef
        L_0x00e4:
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            r2 = 7
            r1.mCause = r2     // Catch:{ all -> 0x010e }
            r10.onGsmDialInvalidNumber()     // Catch:{ all -> 0x010e }
            r10.pollCallsWhenSafe()     // Catch:{ all -> 0x010e }
        L_0x00ef:
            boolean r1 = r10.mNumberConverted     // Catch:{ all -> 0x010e }
            if (r1 == 0) goto L_0x00fa
            com.android.internal.telephony.GsmCdmaConnection r1 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            r1.restoreDialedNumberAfterConversion(r11)     // Catch:{ all -> 0x010e }
            r10.mNumberConverted = r8     // Catch:{ all -> 0x010e }
        L_0x00fa:
            r10.updatePhoneState()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaPhone r0 = r10.mPhone     // Catch:{ all -> 0x010e }
            r0.notifyPreciseCallStateChanged()     // Catch:{ all -> 0x010e }
            com.android.internal.telephony.GsmCdmaConnection r0 = r10.mPendingMO     // Catch:{ all -> 0x010e }
            monitor-exit(r10)
            return r0
        L_0x0106:
            com.android.internal.telephony.CallStateException r0 = new com.android.internal.telephony.CallStateException     // Catch:{ all -> 0x010e }
            java.lang.String r1 = "cannot dial in current state"
            r0.<init>(r1)     // Catch:{ all -> 0x010e }
            throw r0     // Catch:{ all -> 0x010e }
        L_0x010e:
            r0 = move-exception
            monitor-exit(r10)
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaCallTracker.dialGsm(java.lang.String, com.android.internal.telephony.PhoneInternalInterface$DialArgs):com.android.internal.telephony.Connection");
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void handleEcmTimer(int i) {
        this.mPhone.handleTimerInEmergencyCallbackMode(i);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void disableDataCallInEmergencyCall(String str) {
        if (((TelephonyManager) this.mPhone.getContext().getSystemService("phone")).isEmergencyNumber(str)) {
            log("disableDataCallInEmergencyCall");
            setIsInEmergencyCall();
        }
    }

    public void setIsInEmergencyCall() {
        this.mIsInEmergencyCall = true;
        if (!this.mPhone.isUsingNewDataStack()) {
            this.mPhone.getDataEnabledSettings().setInternalDataEnabled(false);
        }
        this.mPhone.notifyEmergencyCallRegistrants(true);
        this.mPhone.sendEmergencyCallStateChange(true);
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:16:0x0077, code lost:
        if ("vi".equals(r0) == false) goto L_0x0079;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:23:0x0089, code lost:
        if ("us".equals(r0) == false) goto L_0x0079;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public com.android.internal.telephony.Connection dialCdma(java.lang.String r18, com.android.internal.telephony.PhoneInternalInterface.DialArgs r19) throws com.android.internal.telephony.CallStateException {
        /*
            r17 = this;
            r6 = r17
            r7 = r18
            r5 = r19
            int r0 = r5.clirMode
            android.os.Bundle r8 = r5.intentExtras
            boolean r9 = r5.isEmergency
            if (r9 == 0) goto L_0x0023
            r0 = 2
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "dial cdma emergency call, set clirModIe="
            r1.append(r2)
            r1.append(r0)
            java.lang.String r1 = r1.toString()
            r6.log(r1)
        L_0x0023:
            r15 = r0
            r17.clearDisconnected()
            r6.checkForDialIssues(r9)
            com.android.internal.telephony.GsmCdmaPhone r0 = r6.mPhone
            android.content.Context r0 = r0.getContext()
            java.lang.String r1 = "phone"
            java.lang.Object r0 = r0.getSystemService(r1)
            android.telephony.TelephonyManager r0 = (android.telephony.TelephonyManager) r0
            com.android.internal.telephony.GsmCdmaPhone r1 = r6.mPhone
            int r1 = r1.getPhoneId()
            java.lang.String r0 = r0.getNetworkCountryIso(r1)
            com.android.internal.telephony.GsmCdmaPhone r1 = r6.mPhone
            int r1 = r1.getPhoneId()
            java.lang.String r1 = android.telephony.TelephonyManager.getSimCountryIsoForPhone(r1)
            boolean r2 = android.text.TextUtils.isEmpty(r0)
            r10 = 1
            r14 = 0
            if (r2 != 0) goto L_0x0062
            boolean r2 = android.text.TextUtils.isEmpty(r1)
            if (r2 != 0) goto L_0x0062
            boolean r2 = r1.equals(r0)
            if (r2 != 0) goto L_0x0062
            r2 = r10
            goto L_0x0063
        L_0x0062:
            r2 = r14
        L_0x0063:
            if (r2 == 0) goto L_0x008c
            java.lang.String r3 = "us"
            boolean r4 = r3.equals(r1)
            java.lang.String r11 = "vi"
            if (r4 == 0) goto L_0x007d
            if (r2 == 0) goto L_0x007b
            boolean r0 = r11.equals(r0)
            if (r0 != 0) goto L_0x007b
        L_0x0079:
            r2 = r10
            goto L_0x008c
        L_0x007b:
            r2 = r14
            goto L_0x008c
        L_0x007d:
            boolean r1 = r11.equals(r1)
            if (r1 == 0) goto L_0x008c
            if (r2 == 0) goto L_0x007b
            boolean r0 = r3.equals(r0)
            if (r0 != 0) goto L_0x007b
            goto L_0x0079
        L_0x008c:
            if (r2 == 0) goto L_0x0096
            com.android.internal.telephony.GsmCdmaPhone r0 = r6.mPhone
            java.lang.String r0 = r6.convertNumberIfNecessary(r0, r7)
            r11 = r0
            goto L_0x0097
        L_0x0096:
            r11 = r7
        L_0x0097:
            com.android.internal.telephony.GsmCdmaPhone r0 = r6.mPhone
            boolean r12 = r0.isInEcm()
            if (r12 == 0) goto L_0x00a6
            if (r9 == 0) goto L_0x00a6
            com.android.internal.telephony.GsmCdmaPhone r0 = r6.mPhone
            r0.handleTimerInEmergencyCallbackMode(r10)
        L_0x00a6:
            com.android.internal.telephony.GsmCdmaCall r0 = r6.mForegroundCall
            com.android.internal.telephony.Call$State r0 = r0.getState()
            com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.ACTIVE
            if (r0 != r1) goto L_0x00b5
            com.android.internal.telephony.Connection r0 = r6.dialThreeWay(r11, r5)
            return r0
        L_0x00b5:
            com.android.internal.telephony.GsmCdmaPhone r1 = r6.mPhone
            com.android.internal.telephony.GsmCdmaCall r4 = r6.mForegroundCall
            r0 = r17
            r2 = r11
            r3 = r17
            r5 = r19
            com.android.internal.telephony.GsmCdmaConnection r0 = r0.onCreateGsmCdmaConnection(r1, r2, r3, r4, r5)
            r6.mPendingMO = r0
            if (r8 == 0) goto L_0x00ed
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "dialGsm - emergency dialer: "
            r0.append(r1)
            java.lang.String r1 = "android.telecom.extra.IS_USER_INTENT_EMERGENCY_CALL"
            boolean r2 = r8.getBoolean(r1)
            r0.append(r2)
            java.lang.String r0 = r0.toString()
            java.lang.String r2 = "GsmCdmaCallTracker"
            com.android.telephony.Rlog.d(r2, r0)
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            boolean r1 = r8.getBoolean(r1)
            r0.setHasKnownUserIntentEmergency(r1)
        L_0x00ed:
            r6.mHangupPendingMO = r14
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            java.lang.String r0 = r0.getAddress()
            if (r0 == 0) goto L_0x0156
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            java.lang.String r0 = r0.getAddress()
            int r0 = r0.length()
            if (r0 == 0) goto L_0x0156
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            java.lang.String r0 = r0.getAddress()
            r1 = 78
            int r0 = r0.indexOf(r1)
            if (r0 < 0) goto L_0x0112
            goto L_0x0156
        L_0x0112:
            r6.setMute(r14)
            r6.disableDataCallInEmergencyCall(r11)
            if (r12 == 0) goto L_0x0132
            if (r12 == 0) goto L_0x011f
            if (r9 == 0) goto L_0x011f
            goto L_0x0132
        L_0x011f:
            com.android.internal.telephony.GsmCdmaPhone r0 = r6.mPhone
            r0.exitEmergencyCallbackMode()
            com.android.internal.telephony.GsmCdmaPhone r0 = r6.mPhone
            r1 = 14
            r2 = 0
            r0.setOnEcbModeExitResponse(r6, r1, r2)
            r6.mPendingCallClirMode = r15
            r6.mPendingCallInEcm = r10
            r1 = r14
            goto L_0x015f
        L_0x0132:
            com.android.internal.telephony.CommandsInterface r10 = r6.mCi
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            java.lang.String r11 = r0.getAddress()
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            boolean r12 = r0.isEmergencyCall()
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            android.telephony.emergency.EmergencyNumber r13 = r0.getEmergencyNumberInfo()
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            boolean r0 = r0.hasKnownUserIntentEmergency()
            android.os.Message r16 = r17.obtainCompleteMessage()
            r1 = r14
            r14 = r0
            r10.dial(r11, r12, r13, r14, r15, r16)
            goto L_0x015f
        L_0x0156:
            r1 = r14
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            r2 = 7
            r0.mCause = r2
            r17.pollCallsWhenSafe()
        L_0x015f:
            boolean r0 = r6.mNumberConverted
            if (r0 == 0) goto L_0x016a
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            r0.restoreDialedNumberAfterConversion(r7)
            r6.mNumberConverted = r1
        L_0x016a:
            r17.updatePhoneState()
            com.android.internal.telephony.GsmCdmaPhone r0 = r6.mPhone
            r0.notifyPreciseCallStateChanged()
            com.android.internal.telephony.GsmCdmaConnection r0 = r6.mPendingMO
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaCallTracker.dialCdma(java.lang.String, com.android.internal.telephony.PhoneInternalInterface$DialArgs):com.android.internal.telephony.Connection");
    }

    /* access modifiers changed from: protected */
    public Connection dialThreeWay(String str, PhoneInternalInterface.DialArgs dialArgs) {
        Bundle bundle = dialArgs.intentExtras;
        if (this.mForegroundCall.isIdle()) {
            return null;
        }
        disableDataCallInEmergencyCall(str);
        this.mPendingMO = onCreateGsmCdmaConnection(this.mPhone, str, this, this.mForegroundCall, dialArgs);
        if (bundle != null) {
            Rlog.d(LOG_TAG, "dialThreeWay - emergency dialer " + bundle.getBoolean("android.telecom.extra.IS_USER_INTENT_EMERGENCY_CALL"));
            this.mPendingMO.setHasKnownUserIntentEmergency(bundle.getBoolean("android.telecom.extra.IS_USER_INTENT_EMERGENCY_CALL"));
        }
        PersistableBundle configForSubId = ((CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config")).getConfigForSubId(this.mPhone.getSubId());
        if (configForSubId != null) {
            this.m3WayCallFlashDelay = configForSubId.getInt("cdma_3waycall_flash_delay_int");
        } else {
            this.m3WayCallFlashDelay = 0;
        }
        if (this.m3WayCallFlashDelay > 0) {
            this.mCi.sendCDMAFeatureCode("", obtainMessage(20));
        } else {
            this.mCi.sendCDMAFeatureCode(this.mPendingMO.getAddress(), obtainMessage(16));
        }
        return this.mPendingMO;
    }

    public Connection dial(String str, PhoneInternalInterface.DialArgs dialArgs) throws CallStateException {
        if (isPhoneTypeGsm()) {
            return dialGsm(str, dialArgs);
        }
        return dialCdma(str, dialArgs);
    }

    public Connection dialGsm(String str, UUSInfo uUSInfo, Bundle bundle) throws CallStateException {
        return dialGsm(str, new PhoneInternalInterface.DialArgs.Builder().setUusInfo(uUSInfo).setClirMode(0).setIntentExtras(bundle).build());
    }

    private Connection dialGsm(String str, int i, Bundle bundle) throws CallStateException {
        return dialGsm(str, new PhoneInternalInterface.DialArgs.Builder().setClirMode(i).setIntentExtras(bundle).build());
    }

    public Connection dialGsm(String str, int i, UUSInfo uUSInfo, Bundle bundle) throws CallStateException {
        return dialGsm(str, new PhoneInternalInterface.DialArgs.Builder().setClirMode(i).setUusInfo(uUSInfo).setIntentExtras(bundle).build());
    }

    public void acceptCall() throws CallStateException {
        if (this.mRingingCall.getState() == Call.State.INCOMING) {
            Rlog.i("phone", "acceptCall: incoming...");
            setMute(false);
            this.mPhone.getVoiceCallSessionStats().onRilAcceptCall(this.mRingingCall.getConnections());
            this.mCi.acceptCall(obtainCompleteMessage());
        } else if (this.mRingingCall.getState() == Call.State.WAITING) {
            if (isPhoneTypeGsm()) {
                setMute(false);
            } else {
                GsmCdmaConnection gsmCdmaConnection = (GsmCdmaConnection) this.mRingingCall.getLatestConnection();
                gsmCdmaConnection.updateParent(this.mRingingCall, this.mForegroundCall);
                gsmCdmaConnection.onConnectedInOrOut();
                updatePhoneState();
            }
            switchWaitingOrHoldingAndActive();
        } else {
            throw new CallStateException("phone not ringing");
        }
    }

    public void rejectCall() throws CallStateException {
        if (this.mRingingCall.getState().isRinging()) {
            this.mCi.rejectCall(obtainCompleteMessage());
            return;
        }
        throw new CallStateException("phone not ringing");
    }

    /* access modifiers changed from: protected */
    public void flashAndSetGenericTrue() {
        this.mCi.sendCDMAFeatureCode("", obtainMessage(8));
        this.mPhone.notifyPreciseCallStateChanged();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void switchWaitingOrHoldingAndActive() throws CallStateException {
        if (this.mRingingCall.getState() == Call.State.INCOMING) {
            throw new CallStateException("cannot be in the incoming state");
        } else if (isPhoneTypeGsm()) {
            onSwitchWaitingOrHoldingAndActive();
        } else if (this.mForegroundCall.getConnectionsCount() > 1) {
            flashAndSetGenericTrue();
        } else {
            this.mCi.sendCDMAFeatureCode("", obtainMessage(8));
        }
    }

    public void conference() {
        if (isPhoneTypeGsm()) {
            this.mCi.conference(obtainCompleteMessage(11));
        } else {
            flashAndSetGenericTrue();
        }
    }

    public void explicitCallTransfer() {
        this.mCi.explicitCallTransfer(obtainCompleteMessage(13));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void clearDisconnected() {
        internalClearDisconnected();
        updatePhoneState();
        this.mPhone.notifyPreciseCallStateChanged();
    }

    public boolean canConference() {
        return this.mForegroundCall.getState() == Call.State.ACTIVE && this.mBackgroundCall.getState() == Call.State.HOLDING && !this.mBackgroundCall.isFull() && !this.mForegroundCall.isFull();
    }

    public void checkForDialIssues(boolean z) throws CallStateException {
        boolean booleanValue = TelephonyProperties.disable_call().orElse(Boolean.FALSE).booleanValue();
        if (this.mCi.getRadioState() != 1) {
            throw new CallStateException(2, "Modem not powered");
        } else if (booleanValue) {
            throw new CallStateException(5, "Calling disabled via ro.telephony.disable-call property");
        } else if (this.mPendingMO != null) {
            throw new CallStateException(3, "A call is already dialing.");
        } else if (this.mRingingCall.isRinging()) {
            throw new CallStateException(4, "Can't call while a call is ringing.");
        } else if (isPhoneTypeGsm() && this.mForegroundCall.getState().isAlive() && this.mBackgroundCall.getState().isAlive()) {
            throw new CallStateException(6, "There is already a foreground and background call.");
        } else if (!isPhoneTypeGsm() && this.mForegroundCall.getState().isAlive() && this.mForegroundCall.getState() != Call.State.ACTIVE && this.mBackgroundCall.getState().isAlive()) {
            throw new CallStateException(6, "There is already a foreground and background call.");
        } else if (!z && isInOtaspCall()) {
            throw new CallStateException(7, "OTASP provisioning is in process.");
        }
    }

    public boolean canTransfer() {
        if (!isPhoneTypeGsm()) {
            Rlog.e(LOG_TAG, "canTransfer: not possible in CDMA");
            return false;
        } else if ((this.mForegroundCall.getState() == Call.State.ACTIVE || this.mForegroundCall.getState() == Call.State.ALERTING || this.mForegroundCall.getState() == Call.State.DIALING) && this.mBackgroundCall.getState() == Call.State.HOLDING) {
            return true;
        } else {
            return false;
        }
    }

    /* access modifiers changed from: protected */
    public void internalClearDisconnected() {
        this.mRingingCall.clearDisconnected();
        this.mForegroundCall.clearDisconnected();
        this.mBackgroundCall.clearDisconnected();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Message obtainCompleteMessage() {
        return obtainCompleteMessage(4);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Message obtainCompleteMessage(int i) {
        this.mPendingOperations++;
        this.mLastRelevantPoll = null;
        this.mNeedsPoll = true;
        return obtainMessage(i);
    }

    /* access modifiers changed from: protected */
    public void operationComplete() {
        int i = this.mPendingOperations - 1;
        this.mPendingOperations = i;
        if (i == 0 && this.mNeedsPoll) {
            Message obtainMessage = obtainMessage(1);
            this.mLastRelevantPoll = obtainMessage;
            this.mCi.getCurrentCalls(obtainMessage);
        } else if (i < 0) {
            Rlog.e(LOG_TAG, "GsmCdmaCallTracker.pendingOperations < 0");
            this.mPendingOperations = 0;
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updatePhoneState() {
        PhoneConstants.State state = this.mState;
        if (this.mRingingCall.isRinging()) {
            this.mState = PhoneConstants.State.RINGING;
        } else if (this.mPendingMO != null || !this.mForegroundCall.isIdle() || !this.mBackgroundCall.isIdle()) {
            onCallStateOffhook();
            this.mState = PhoneConstants.State.OFFHOOK;
        } else {
            Phone imsPhone = this.mPhone.getImsPhone();
            if (this.mState == PhoneConstants.State.OFFHOOK && imsPhone != null) {
                imsPhone.callEndCleanupHandOverCallIfAny();
            }
            onCallStateIdle(imsPhone);
            this.mState = PhoneConstants.State.IDLE;
        }
        PhoneConstants.State state2 = this.mState;
        PhoneConstants.State state3 = PhoneConstants.State.IDLE;
        if (state2 == state3 && state != state2) {
            this.mVoiceCallEndedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        } else if (state == state3 && state != state2) {
            this.mVoiceCallStartedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        }
        log("update phone state, old=" + state + " new=" + this.mState);
        if (this.mState != state) {
            this.mPhone.notifyPhoneStateChanged();
            this.mMetrics.writePhoneState(this.mPhone.getPhoneId(), this.mState);
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:35:0x007c, code lost:
        r1.mHangupPendingMO = false;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:36:0x0083, code lost:
        if (isPhoneTypeGsm() != false) goto L_0x0093;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:38:0x008b, code lost:
        if (r1.mPhone.isEcmCanceledForEmergency() == false) goto L_0x0093;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:39:0x008d, code lost:
        r1.mPhone.handleTimerInEmergencyCallbackMode(0);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:41:?, code lost:
        log("poll: hangupPendingMO, hangup conn " + r9);
        onDoHangupPendingMo();
        hangup(r1.mConnections[r9]);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:45:?, code lost:
        com.android.telephony.Rlog.e(LOG_TAG, "unexpected error on hangup");
        onDoHandupPendingMoException();
     */
    /* JADX WARNING: Removed duplicated region for block: B:115:0x02b8 A[Catch:{ CallStateException -> 0x00b2 }] */
    /* JADX WARNING: Removed duplicated region for block: B:122:0x02e6 A[Catch:{ CallStateException -> 0x00b2 }] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void handlePollCalls(android.os.AsyncResult r21) {
        /*
            r20 = this;
            r1 = r20
            r0 = r21
            monitor-enter(r20)
            r20.onHandlePollCallsStart()     // Catch:{ all -> 0x04f1 }
            java.lang.Throwable r2 = r0.exception     // Catch:{ all -> 0x04f1 }
            if (r2 != 0) goto L_0x0011
            java.lang.Object r2 = r0.result     // Catch:{ all -> 0x04f1 }
            java.util.List r2 = (java.util.List) r2     // Catch:{ all -> 0x04f1 }
            goto L_0x001c
        L_0x0011:
            boolean r2 = r1.isCommandExceptionRadioNotAvailable(r2)     // Catch:{ all -> 0x04f1 }
            if (r2 == 0) goto L_0x04ec
            java.util.ArrayList r2 = new java.util.ArrayList     // Catch:{ all -> 0x04f1 }
            r2.<init>()     // Catch:{ all -> 0x04f1 }
        L_0x001c:
            boolean r3 = r1.onGetCallListDone(r2)     // Catch:{ all -> 0x04f1 }
            if (r3 == 0) goto L_0x0024
            monitor-exit(r20)
            return
        L_0x0024:
            java.util.ArrayList r3 = new java.util.ArrayList     // Catch:{ all -> 0x04f1 }
            r3.<init>()     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList<com.android.internal.telephony.Connection> r4 = r1.mHandoverConnections     // Catch:{ all -> 0x04f1 }
            int r4 = r4.size()     // Catch:{ all -> 0x04f1 }
            int r5 = r2.size()     // Catch:{ all -> 0x04f1 }
            r9 = 0
            r10 = 1
            r11 = 0
            r12 = 0
            r13 = 0
            r14 = 0
            r15 = 0
        L_0x003a:
            com.android.internal.telephony.GsmCdmaConnection[] r8 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            int r7 = r8.length     // Catch:{ all -> 0x04f1 }
            if (r9 >= r7) goto L_0x02f8
            r7 = r8[r9]     // Catch:{ all -> 0x04f1 }
            if (r11 >= r5) goto L_0x0054
            java.lang.Object r8 = r2.get(r11)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.DriverCall r8 = (com.android.internal.telephony.DriverCall) r8     // Catch:{ all -> 0x04f1 }
            int r6 = r8.index     // Catch:{ all -> 0x04f1 }
            r18 = r5
            int r5 = r9 + 1
            if (r6 != r5) goto L_0x0056
            int r11 = r11 + 1
            goto L_0x0057
        L_0x0054:
            r18 = r5
        L_0x0056:
            r8 = 0
        L_0x0057:
            if (r7 != 0) goto L_0x005b
            if (r8 == 0) goto L_0x005c
        L_0x005b:
            r10 = 0
        L_0x005c:
            if (r7 != 0) goto L_0x01de
            if (r8 == 0) goto L_0x01de
            com.android.internal.telephony.GsmCdmaConnection r5 = r1.mPendingMO     // Catch:{ all -> 0x04f1 }
            if (r5 == 0) goto L_0x00c3
            boolean r5 = r5.compareTo(r8)     // Catch:{ all -> 0x04f1 }
            if (r5 == 0) goto L_0x00c3
            com.android.internal.telephony.GsmCdmaConnection[] r5 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection r6 = r1.mPendingMO     // Catch:{ all -> 0x04f1 }
            r5[r9] = r6     // Catch:{ all -> 0x04f1 }
            r6.mIndex = r9     // Catch:{ all -> 0x04f1 }
            r6.update(r8)     // Catch:{ all -> 0x04f1 }
            r5 = 0
            r1.mPendingMO = r5     // Catch:{ all -> 0x04f1 }
            boolean r5 = r1.mHangupPendingMO     // Catch:{ all -> 0x04f1 }
            if (r5 == 0) goto L_0x00bf
            r5 = 0
            r1.mHangupPendingMO = r5     // Catch:{ all -> 0x04f1 }
            boolean r0 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r0 != 0) goto L_0x0093
            com.android.internal.telephony.GsmCdmaPhone r0 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            boolean r0 = r0.isEcmCanceledForEmergency()     // Catch:{ all -> 0x04f1 }
            if (r0 == 0) goto L_0x0093
            com.android.internal.telephony.GsmCdmaPhone r0 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            r2 = 0
            r0.handleTimerInEmergencyCallbackMode(r2)     // Catch:{ all -> 0x04f1 }
        L_0x0093:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ CallStateException -> 0x00b2 }
            r0.<init>()     // Catch:{ CallStateException -> 0x00b2 }
            java.lang.String r2 = "poll: hangupPendingMO, hangup conn "
            r0.append(r2)     // Catch:{ CallStateException -> 0x00b2 }
            r0.append(r9)     // Catch:{ CallStateException -> 0x00b2 }
            java.lang.String r0 = r0.toString()     // Catch:{ CallStateException -> 0x00b2 }
            r1.log(r0)     // Catch:{ CallStateException -> 0x00b2 }
            r20.onDoHangupPendingMo()     // Catch:{ CallStateException -> 0x00b2 }
            com.android.internal.telephony.GsmCdmaConnection[] r0 = r1.mConnections     // Catch:{ CallStateException -> 0x00b2 }
            r0 = r0[r9]     // Catch:{ CallStateException -> 0x00b2 }
            r1.hangup((com.android.internal.telephony.GsmCdmaConnection) r0)     // Catch:{ CallStateException -> 0x00b2 }
            goto L_0x00bd
        L_0x00b2:
            java.lang.String r0 = "GsmCdmaCallTracker"
            java.lang.String r2 = "unexpected error on hangup"
            com.android.telephony.Rlog.e(r0, r2)     // Catch:{ all -> 0x04f1 }
            r20.onDoHandupPendingMoException()     // Catch:{ all -> 0x04f1 }
        L_0x00bd:
            monitor-exit(r20)
            return
        L_0x00bf:
            r19 = r10
            goto L_0x02a4
        L_0x00c3:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r5.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r6 = "pendingMo="
            r5.append(r6)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection r6 = r1.mPendingMO     // Catch:{ all -> 0x04f1 }
            r5.append(r6)     // Catch:{ all -> 0x04f1 }
            java.lang.String r6 = ", dc="
            r5.append(r6)     // Catch:{ all -> 0x04f1 }
            r5.append(r8)     // Catch:{ all -> 0x04f1 }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x04f1 }
            r1.log(r5)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection[] r5 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaPhone r6 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection r6 = r1.onCreateGsmCdmaConnection((com.android.internal.telephony.GsmCdmaPhone) r6, (com.android.internal.telephony.DriverCall) r8, (com.android.internal.telephony.GsmCdmaCallTracker) r1, (int) r9)     // Catch:{ all -> 0x04f1 }
            r5[r9] = r6     // Catch:{ all -> 0x04f1 }
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r5.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r6 = "New connection is not mPendingMO. Creating new GsmCdmaConnection, objId="
            r5.append(r6)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection[] r6 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r6 = r6[r9]     // Catch:{ all -> 0x04f1 }
            int r6 = java.lang.System.identityHashCode(r6)     // Catch:{ all -> 0x04f1 }
            r5.append(r6)     // Catch:{ all -> 0x04f1 }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x04f1 }
            r1.log(r5)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Connection r5 = r1.getHoConnection(r8)     // Catch:{ all -> 0x04f1 }
            boolean r6 = r1.onCheckHoConnection(r5, r9)     // Catch:{ all -> 0x04f1 }
            if (r6 == 0) goto L_0x0112
            goto L_0x00bf
        L_0x0112:
            if (r5 == 0) goto L_0x01b6
            java.lang.String r6 = "Handover connection found."
            r1.log(r6)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection[] r6 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r6 = r6[r9]     // Catch:{ all -> 0x04f1 }
            r6.migrateFrom(r5)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r6 = r5.mPreHandoverState     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r7 = com.android.internal.telephony.Call.State.ACTIVE     // Catch:{ all -> 0x04f1 }
            if (r6 == r7) goto L_0x0138
            com.android.internal.telephony.Call$State r7 = com.android.internal.telephony.Call.State.HOLDING     // Catch:{ all -> 0x04f1 }
            if (r6 == r7) goto L_0x0138
            com.android.internal.telephony.DriverCall$State r6 = r8.state     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.DriverCall$State r7 = com.android.internal.telephony.DriverCall.State.ACTIVE     // Catch:{ all -> 0x04f1 }
            if (r6 != r7) goto L_0x0138
            com.android.internal.telephony.GsmCdmaConnection[] r6 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r6 = r6[r9]     // Catch:{ all -> 0x04f1 }
            r6.onConnectedInOrOut()     // Catch:{ all -> 0x04f1 }
            goto L_0x013f
        L_0x0138:
            com.android.internal.telephony.GsmCdmaConnection[] r6 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r6 = r6[r9]     // Catch:{ all -> 0x04f1 }
            r6.onConnectedConnectionMigrated()     // Catch:{ all -> 0x04f1 }
        L_0x013f:
            java.util.ArrayList<com.android.internal.telephony.Connection> r6 = r1.mHandoverConnections     // Catch:{ all -> 0x04f1 }
            r6.remove(r5)     // Catch:{ all -> 0x04f1 }
            boolean r6 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r6 == 0) goto L_0x01a3
            java.util.ArrayList<com.android.internal.telephony.Connection> r6 = r1.mHandoverConnections     // Catch:{ all -> 0x04f1 }
            java.util.Iterator r6 = r6.iterator()     // Catch:{ all -> 0x04f1 }
        L_0x0150:
            boolean r7 = r6.hasNext()     // Catch:{ all -> 0x04f1 }
            if (r7 == 0) goto L_0x01a3
            java.lang.Object r7 = r6.next()     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Connection r7 = (com.android.internal.telephony.Connection) r7     // Catch:{ all -> 0x04f1 }
            java.lang.String r8 = "GsmCdmaCallTracker"
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r12.<init>()     // Catch:{ all -> 0x04f1 }
            r19 = r10
            java.lang.String r10 = "HO Conn state is "
            r12.append(r10)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r10 = r7.mPreHandoverState     // Catch:{ all -> 0x04f1 }
            r12.append(r10)     // Catch:{ all -> 0x04f1 }
            java.lang.String r10 = r12.toString()     // Catch:{ all -> 0x04f1 }
            com.android.telephony.Rlog.i(r8, r10)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r8 = r7.mPreHandoverState     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection[] r10 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r10 = r10[r9]     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r10 = r10.getState()     // Catch:{ all -> 0x04f1 }
            if (r8 != r10) goto L_0x01a0
            java.lang.String r8 = "GsmCdmaCallTracker"
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r10.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r12 = "Removing HO conn "
            r10.append(r12)     // Catch:{ all -> 0x04f1 }
            r10.append(r5)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r7 = r7.mPreHandoverState     // Catch:{ all -> 0x04f1 }
            r10.append(r7)     // Catch:{ all -> 0x04f1 }
            java.lang.String r7 = r10.toString()     // Catch:{ all -> 0x04f1 }
            com.android.telephony.Rlog.i(r8, r7)     // Catch:{ all -> 0x04f1 }
            r6.remove()     // Catch:{ all -> 0x04f1 }
        L_0x01a0:
            r10 = r19
            goto L_0x0150
        L_0x01a3:
            r19 = r10
            r20.onBeforeNotifyHandoverStateChanged()     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaPhone r5 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection[] r6 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r6 = r6[r9]     // Catch:{ all -> 0x04f1 }
            r5.notifyHandoverStateChanged(r6)     // Catch:{ all -> 0x04f1 }
            r1.onAfterNotifyHandoverStateChanged(r9)     // Catch:{ all -> 0x04f1 }
            goto L_0x02a4
        L_0x01b6:
            r19 = r10
            java.lang.String r5 = "New connection is not mPendingMO nor a pending handover."
            r1.log(r5)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Connection r5 = r1.checkMtFindNewRinging(r8, r9)     // Catch:{ all -> 0x04f1 }
            if (r5 != 0) goto L_0x01db
            boolean r6 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r6 == 0) goto L_0x01d2
            com.android.internal.telephony.GsmCdmaConnection[] r6 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r6 = r6[r9]     // Catch:{ all -> 0x04f1 }
            r3.add(r6)     // Catch:{ all -> 0x04f1 }
            r13 = r5
            goto L_0x01d8
        L_0x01d2:
            com.android.internal.telephony.GsmCdmaConnection[] r6 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r6 = r6[r9]     // Catch:{ all -> 0x04f1 }
            r13 = r5
            r14 = r6
        L_0x01d8:
            r15 = 1
            goto L_0x02a4
        L_0x01db:
            r13 = r5
            goto L_0x02a4
        L_0x01de:
            r19 = r10
            if (r7 == 0) goto L_0x027c
            if (r8 != 0) goto L_0x027c
            boolean r5 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r5 == 0) goto L_0x01f4
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r5 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            r5.add(r7)     // Catch:{ all -> 0x04f1 }
            r1.onGsmConnectionDropped(r7, r9)     // Catch:{ all -> 0x04f1 }
            goto L_0x0275
        L_0x01f4:
            com.android.internal.telephony.GsmCdmaCall r5 = r1.mForegroundCall     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList r5 = r5.getConnections()     // Catch:{ all -> 0x04f1 }
            java.util.Iterator r5 = r5.iterator()     // Catch:{ all -> 0x04f1 }
        L_0x01fe:
            boolean r6 = r5.hasNext()     // Catch:{ all -> 0x04f1 }
            if (r6 == 0) goto L_0x022c
            java.lang.Object r6 = r5.next()     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Connection r6 = (com.android.internal.telephony.Connection) r6     // Catch:{ all -> 0x04f1 }
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r7.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r8 = "adding fgCall cn "
            r7.append(r8)     // Catch:{ all -> 0x04f1 }
            r7.append(r6)     // Catch:{ all -> 0x04f1 }
            java.lang.String r8 = "to droppedDuringPoll"
            r7.append(r8)     // Catch:{ all -> 0x04f1 }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x04f1 }
            r1.log(r7)     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r7 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection r6 = (com.android.internal.telephony.GsmCdmaConnection) r6     // Catch:{ all -> 0x04f1 }
            r7.add(r6)     // Catch:{ all -> 0x04f1 }
            goto L_0x01fe
        L_0x022c:
            com.android.internal.telephony.GsmCdmaCall r5 = r1.mRingingCall     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList r5 = r5.getConnections()     // Catch:{ all -> 0x04f1 }
            java.util.Iterator r5 = r5.iterator()     // Catch:{ all -> 0x04f1 }
        L_0x0236:
            boolean r6 = r5.hasNext()     // Catch:{ all -> 0x04f1 }
            if (r6 == 0) goto L_0x0264
            java.lang.Object r6 = r5.next()     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Connection r6 = (com.android.internal.telephony.Connection) r6     // Catch:{ all -> 0x04f1 }
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r7.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r8 = "adding rgCall cn "
            r7.append(r8)     // Catch:{ all -> 0x04f1 }
            r7.append(r6)     // Catch:{ all -> 0x04f1 }
            java.lang.String r8 = "to droppedDuringPoll"
            r7.append(r8)     // Catch:{ all -> 0x04f1 }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x04f1 }
            r1.log(r7)     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r7 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection r6 = (com.android.internal.telephony.GsmCdmaConnection) r6     // Catch:{ all -> 0x04f1 }
            r7.add(r6)     // Catch:{ all -> 0x04f1 }
            goto L_0x0236
        L_0x0264:
            com.android.internal.telephony.GsmCdmaPhone r5 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            boolean r5 = r5.isEcmCanceledForEmergency()     // Catch:{ all -> 0x04f1 }
            if (r5 == 0) goto L_0x0272
            com.android.internal.telephony.GsmCdmaPhone r5 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            r6 = 0
            r5.handleTimerInEmergencyCallbackMode(r6)     // Catch:{ all -> 0x04f1 }
        L_0x0272:
            r20.checkAndEnableDataCallAfterEmergencyCallDropped()     // Catch:{ all -> 0x04f1 }
        L_0x0275:
            com.android.internal.telephony.GsmCdmaConnection[] r5 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r6 = 0
            r5[r9] = r6     // Catch:{ all -> 0x04f1 }
            goto L_0x02f0
        L_0x027c:
            if (r7 == 0) goto L_0x02a6
            if (r8 == 0) goto L_0x02a6
            boolean r5 = r7.compareTo(r8)     // Catch:{ all -> 0x04f1 }
            if (r5 != 0) goto L_0x02a6
            boolean r5 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r5 == 0) goto L_0x02a6
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r5 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            r5.add(r7)     // Catch:{ all -> 0x04f1 }
            r1.onCreateGsmCdmaConnectionForMismatch(r8, r1, r9)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection[] r5 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r5 = r5[r9]     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaCall r5 = r5.getCall()     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaCall r6 = r1.mRingingCall     // Catch:{ all -> 0x04f1 }
            if (r5 != r6) goto L_0x02a4
            com.android.internal.telephony.GsmCdmaConnection[] r5 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r13 = r5[r9]     // Catch:{ all -> 0x04f1 }
        L_0x02a4:
            r12 = 1
            goto L_0x02f0
        L_0x02a6:
            if (r7 == 0) goto L_0x02f0
            if (r8 == 0) goto L_0x02f0
            boolean r5 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r5 != 0) goto L_0x02e6
            boolean r5 = r7.isIncoming()     // Catch:{ all -> 0x04f1 }
            boolean r6 = r8.isMT     // Catch:{ all -> 0x04f1 }
            if (r5 == r6) goto L_0x02e6
            r5 = 1
            if (r6 != r5) goto L_0x02cf
            r1.onCdmaMoMtCallConflict(r8, r1, r9)     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r5 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            r5.add(r7)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Connection r13 = r1.checkMtFindNewRinging(r8, r9)     // Catch:{ all -> 0x04f1 }
            if (r13 != 0) goto L_0x02cb
            r14 = r7
            r15 = 1
        L_0x02cb:
            r20.checkAndEnableDataCallAfterEmergencyCallDropped()     // Catch:{ all -> 0x04f1 }
            goto L_0x02f0
        L_0x02cf:
            java.lang.String r5 = "GsmCdmaCallTracker"
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r6.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r7 = "Error in RIL, Phantom call appeared "
            r6.append(r7)     // Catch:{ all -> 0x04f1 }
            r6.append(r8)     // Catch:{ all -> 0x04f1 }
            java.lang.String r6 = r6.toString()     // Catch:{ all -> 0x04f1 }
            com.android.telephony.Rlog.e(r5, r6)     // Catch:{ all -> 0x04f1 }
            goto L_0x02f0
        L_0x02e6:
            boolean r5 = r7.update(r8)     // Catch:{ all -> 0x04f1 }
            if (r12 != 0) goto L_0x02a4
            if (r5 == 0) goto L_0x02ef
            goto L_0x02a4
        L_0x02ef:
            r12 = 0
        L_0x02f0:
            int r9 = r9 + 1
            r5 = r18
            r10 = r19
            goto L_0x003a
        L_0x02f8:
            boolean r5 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r5 != 0) goto L_0x0303
            if (r10 == 0) goto L_0x0303
            r20.checkAndEnableDataCallAfterEmergencyCallDropped()     // Catch:{ all -> 0x04f1 }
        L_0x0303:
            com.android.internal.telephony.GsmCdmaConnection r5 = r1.mPendingMO     // Catch:{ all -> 0x04f1 }
            if (r5 == 0) goto L_0x0343
            java.lang.String r5 = "GsmCdmaCallTracker"
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r6.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r7 = "Pending MO dropped before poll fg state:"
            r6.append(r7)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaCall r7 = r1.mForegroundCall     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r7 = r7.getState()     // Catch:{ all -> 0x04f1 }
            r6.append(r7)     // Catch:{ all -> 0x04f1 }
            java.lang.String r6 = r6.toString()     // Catch:{ all -> 0x04f1 }
            com.android.telephony.Rlog.d(r5, r6)     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r5 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection r6 = r1.mPendingMO     // Catch:{ all -> 0x04f1 }
            r5.add(r6)     // Catch:{ all -> 0x04f1 }
            r5 = 0
            r1.mPendingMO = r5     // Catch:{ all -> 0x04f1 }
            r6 = 0
            r1.mHangupPendingMO = r6     // Catch:{ all -> 0x04f1 }
            r20.onPendingMoDroppedDuringPoll()     // Catch:{ all -> 0x04f1 }
            boolean r7 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r7 != 0) goto L_0x0345
            boolean r7 = r1.mPendingCallInEcm     // Catch:{ all -> 0x04f1 }
            if (r7 == 0) goto L_0x033f
            r1.mPendingCallInEcm = r6     // Catch:{ all -> 0x04f1 }
        L_0x033f:
            r20.checkAndEnableDataCallAfterEmergencyCallDropped()     // Catch:{ all -> 0x04f1 }
            goto L_0x0345
        L_0x0343:
            r5 = 0
            r6 = 0
        L_0x0345:
            r1.onBeforeNotifyNewRing(r2)     // Catch:{ all -> 0x04f1 }
            if (r13 == 0) goto L_0x034f
            com.android.internal.telephony.GsmCdmaPhone r2 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            r2.notifyNewRingingConnection(r13)     // Catch:{ all -> 0x04f1 }
        L_0x034f:
            java.util.ArrayList r2 = new java.util.ArrayList     // Catch:{ all -> 0x04f1 }
            r2.<init>()     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r7 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            int r7 = r7.size()     // Catch:{ all -> 0x04f1 }
            r8 = 1
            int r7 = r7 - r8
            r8 = r7
            r7 = r6
        L_0x035e:
            if (r8 < 0) goto L_0x03fc
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r9 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            java.lang.Object r9 = r9.get(r8)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection r9 = (com.android.internal.telephony.GsmCdmaConnection) r9     // Catch:{ all -> 0x04f1 }
            java.lang.Throwable r10 = r0.exception     // Catch:{ all -> 0x04f1 }
            boolean r10 = r1.onHandleDroppedConnectionDuringPoll(r10, r8)     // Catch:{ all -> 0x04f1 }
            if (r10 == 0) goto L_0x0371
            goto L_0x03cb
        L_0x0371:
            boolean r10 = r9.isIncoming()     // Catch:{ all -> 0x04f1 }
            r11 = 3
            if (r10 == 0) goto L_0x03c3
            long r16 = r9.getConnectTime()     // Catch:{ all -> 0x04f1 }
            r18 = 0
            int r10 = (r16 > r18 ? 1 : (r16 == r18 ? 0 : -1))
            if (r10 != 0) goto L_0x03c3
            int r10 = r9.mCause     // Catch:{ all -> 0x04f1 }
            if (r10 != r11) goto L_0x0389
            r10 = 16
            goto L_0x038a
        L_0x0389:
            r10 = 1
        L_0x038a:
            java.lang.StringBuilder r11 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r11.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r5 = "missed/rejected call, conn.cause="
            r11.append(r5)     // Catch:{ all -> 0x04f1 }
            int r5 = r9.mCause     // Catch:{ all -> 0x04f1 }
            r11.append(r5)     // Catch:{ all -> 0x04f1 }
            java.lang.String r5 = r11.toString()     // Catch:{ all -> 0x04f1 }
            r1.log(r5)     // Catch:{ all -> 0x04f1 }
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r5.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r11 = "setting cause to "
            r5.append(r11)     // Catch:{ all -> 0x04f1 }
            r5.append(r10)     // Catch:{ all -> 0x04f1 }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x04f1 }
            r1.log(r5)     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r5 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            r5.remove(r8)     // Catch:{ all -> 0x04f1 }
            boolean r5 = r9.onDisconnect(r10)     // Catch:{ all -> 0x04f1 }
            r7 = r7 | r5
            r2.add(r9)     // Catch:{ all -> 0x04f1 }
            goto L_0x03dc
        L_0x03c3:
            int r5 = r9.mCause     // Catch:{ all -> 0x04f1 }
            if (r5 == r11) goto L_0x03cd
            r10 = 7
            if (r5 != r10) goto L_0x03cb
            goto L_0x03cd
        L_0x03cb:
            r5 = r6
            goto L_0x03dd
        L_0x03cd:
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r5 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            r5.remove(r8)     // Catch:{ all -> 0x04f1 }
            int r5 = r9.mCause     // Catch:{ all -> 0x04f1 }
            boolean r5 = r9.onDisconnect(r5)     // Catch:{ all -> 0x04f1 }
            r7 = r7 | r5
            r2.add(r9)     // Catch:{ all -> 0x04f1 }
        L_0x03dc:
            r5 = 1
        L_0x03dd:
            java.lang.Throwable r10 = r0.exception     // Catch:{ all -> 0x04f1 }
            boolean r7 = r1.onSetHasAnyCallDisconnected(r10, r9, r7)     // Catch:{ all -> 0x04f1 }
            java.lang.Throwable r10 = r0.exception     // Catch:{ all -> 0x04f1 }
            boolean r5 = r1.onSetWasDisconnected(r10, r5)     // Catch:{ all -> 0x04f1 }
            boolean r10 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r10 != 0) goto L_0x03f7
            if (r5 == 0) goto L_0x03f7
            if (r15 == 0) goto L_0x03f7
            if (r9 != r14) goto L_0x03f7
            r15 = r6
            r14 = 0
        L_0x03f7:
            int r8 = r8 + -1
            r5 = 0
            goto L_0x035e
        L_0x03fc:
            int r0 = r2.size()     // Catch:{ all -> 0x04f1 }
            if (r0 <= 0) goto L_0x041a
            com.android.internal.telephony.metrics.TelephonyMetrics r0 = r1.mMetrics     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaPhone r5 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            int r5 = r5.getPhoneId()     // Catch:{ all -> 0x04f1 }
            java.lang.String r6 = r20.getNetworkCountryIso()     // Catch:{ all -> 0x04f1 }
            r0.writeRilCallList(r5, r2, r6)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaPhone r0 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.metrics.VoiceCallSessionStats r0 = r0.getVoiceCallSessionStats()     // Catch:{ all -> 0x04f1 }
            r0.onRilCallListChanged(r2)     // Catch:{ all -> 0x04f1 }
        L_0x041a:
            r20.onBeforeDisconnectPendingHandOverConnection()     // Catch:{ all -> 0x04f1 }
            java.util.ArrayList<com.android.internal.telephony.Connection> r0 = r1.mHandoverConnections     // Catch:{ all -> 0x04f1 }
            java.util.Iterator r0 = r0.iterator()     // Catch:{ all -> 0x04f1 }
        L_0x0423:
            boolean r2 = r0.hasNext()     // Catch:{ all -> 0x04f1 }
            if (r2 == 0) goto L_0x0467
            java.lang.Object r2 = r0.next()     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Connection r2 = (com.android.internal.telephony.Connection) r2     // Catch:{ all -> 0x04f1 }
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r5.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r6 = "handlePollCalls - disconnect hoConn= "
            r5.append(r6)     // Catch:{ all -> 0x04f1 }
            r5.append(r2)     // Catch:{ all -> 0x04f1 }
            java.lang.String r6 = " hoConn.State= "
            r5.append(r6)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r6 = r2.getState()     // Catch:{ all -> 0x04f1 }
            r5.append(r6)     // Catch:{ all -> 0x04f1 }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x04f1 }
            r1.log(r5)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Call$State r5 = r2.getState()     // Catch:{ all -> 0x04f1 }
            boolean r5 = r5.isRinging()     // Catch:{ all -> 0x04f1 }
            if (r5 == 0) goto L_0x045e
            r5 = 1
            r2.onDisconnect(r5)     // Catch:{ all -> 0x04f1 }
            goto L_0x0463
        L_0x045e:
            r5 = 1
            r6 = -1
            r2.onDisconnect(r6)     // Catch:{ all -> 0x04f1 }
        L_0x0463:
            r0.remove()     // Catch:{ all -> 0x04f1 }
            goto L_0x0423
        L_0x0467:
            java.util.ArrayList<com.android.internal.telephony.GsmCdmaConnection> r0 = r1.mDroppedDuringPoll     // Catch:{ all -> 0x04f1 }
            int r0 = r0.size()     // Catch:{ all -> 0x04f1 }
            if (r0 <= 0) goto L_0x0479
            com.android.internal.telephony.CommandsInterface r0 = r1.mCi     // Catch:{ all -> 0x04f1 }
            r2 = 5
            android.os.Message r2 = r1.obtainNoPollCompleteMessage(r2)     // Catch:{ all -> 0x04f1 }
            r0.getLastCallFailCause(r2)     // Catch:{ all -> 0x04f1 }
        L_0x0479:
            if (r13 != 0) goto L_0x047f
            if (r12 != 0) goto L_0x047f
            if (r7 == 0) goto L_0x0488
        L_0x047f:
            boolean r0 = r20.onCheckIfIgnoreInternalClearDisconnected()     // Catch:{ all -> 0x04f1 }
            if (r0 != 0) goto L_0x0488
            r20.internalClearDisconnected()     // Catch:{ all -> 0x04f1 }
        L_0x0488:
            r20.updatePhoneState()     // Catch:{ all -> 0x04f1 }
            if (r15 == 0) goto L_0x04c2
            boolean r0 = r20.isPhoneTypeGsm()     // Catch:{ all -> 0x04f1 }
            if (r0 == 0) goto L_0x04bd
            java.util.Iterator r0 = r3.iterator()     // Catch:{ all -> 0x04f1 }
        L_0x0497:
            boolean r2 = r0.hasNext()     // Catch:{ all -> 0x04f1 }
            if (r2 == 0) goto L_0x04c2
            java.lang.Object r2 = r0.next()     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Connection r2 = (com.android.internal.telephony.Connection) r2     // Catch:{ all -> 0x04f1 }
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x04f1 }
            r3.<init>()     // Catch:{ all -> 0x04f1 }
            java.lang.String r5 = "Notify unknown for "
            r3.append(r5)     // Catch:{ all -> 0x04f1 }
            r3.append(r2)     // Catch:{ all -> 0x04f1 }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x04f1 }
            r1.log(r3)     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaPhone r3 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            r3.notifyUnknownConnection(r2)     // Catch:{ all -> 0x04f1 }
            goto L_0x0497
        L_0x04bd:
            com.android.internal.telephony.GsmCdmaPhone r0 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            r0.notifyUnknownConnection(r14)     // Catch:{ all -> 0x04f1 }
        L_0x04c2:
            if (r12 != 0) goto L_0x04c8
            if (r13 != 0) goto L_0x04c8
            if (r7 == 0) goto L_0x04d2
        L_0x04c8:
            com.android.internal.telephony.GsmCdmaPhone r0 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            r0.notifyPreciseCallStateChanged()     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.GsmCdmaConnection[] r0 = r1.mConnections     // Catch:{ all -> 0x04f1 }
            r1.updateMetrics(r0)     // Catch:{ all -> 0x04f1 }
        L_0x04d2:
            if (r4 <= 0) goto L_0x04e7
            java.util.ArrayList<com.android.internal.telephony.Connection> r0 = r1.mHandoverConnections     // Catch:{ all -> 0x04f1 }
            int r0 = r0.size()     // Catch:{ all -> 0x04f1 }
            if (r0 != 0) goto L_0x04e7
            com.android.internal.telephony.GsmCdmaPhone r0 = r1.mPhone     // Catch:{ all -> 0x04f1 }
            com.android.internal.telephony.Phone r0 = r0.getImsPhone()     // Catch:{ all -> 0x04f1 }
            if (r0 == 0) goto L_0x04e7
            r0.callEndCleanupHandOverCallIfAny()     // Catch:{ all -> 0x04f1 }
        L_0x04e7:
            r20.onHandlePollCallsEnd()     // Catch:{ all -> 0x04f1 }
            monitor-exit(r20)
            return
        L_0x04ec:
            r20.pollCallsAfterDelay()     // Catch:{ all -> 0x04f1 }
            monitor-exit(r20)
            return
        L_0x04f1:
            r0 = move-exception
            monitor-exit(r20)
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaCallTracker.handlePollCalls(android.os.AsyncResult):void");
    }

    /* access modifiers changed from: protected */
    public void updateMetrics(GsmCdmaConnection[] gsmCdmaConnectionArr) {
        ArrayList arrayList = new ArrayList();
        for (GsmCdmaConnection gsmCdmaConnection : gsmCdmaConnectionArr) {
            if (gsmCdmaConnection != null) {
                arrayList.add(gsmCdmaConnection);
            }
        }
        this.mMetrics.writeRilCallList(this.mPhone.getPhoneId(), arrayList, getNetworkCountryIso());
        this.mPhone.getVoiceCallSessionStats().onRilCallListChanged(arrayList);
    }

    private void handleRadioNotAvailable() {
        pollCallsWhenSafe();
    }

    /* access modifiers changed from: protected */
    public void dumpState() {
        Rlog.i(LOG_TAG, "Phone State:" + this.mState);
        Rlog.i(LOG_TAG, "Ringing call: " + this.mRingingCall.toString());
        ArrayList<Connection> connections = this.mRingingCall.getConnections();
        int size = connections.size();
        for (int i = 0; i < size; i++) {
            Rlog.i(LOG_TAG, connections.get(i).toString());
        }
        Rlog.i(LOG_TAG, "Foreground call: " + this.mForegroundCall.toString());
        ArrayList<Connection> connections2 = this.mForegroundCall.getConnections();
        int size2 = connections2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            Rlog.i(LOG_TAG, connections2.get(i2).toString());
        }
        Rlog.i(LOG_TAG, "Background call: " + this.mBackgroundCall.toString());
        ArrayList<Connection> connections3 = this.mBackgroundCall.getConnections();
        int size3 = connections3.size();
        for (int i3 = 0; i3 < size3; i3++) {
            Rlog.i(LOG_TAG, connections3.get(i3).toString());
        }
    }

    public void hangup(GsmCdmaConnection gsmCdmaConnection) throws CallStateException {
        GsmCdmaCall gsmCdmaCall;
        if (gsmCdmaConnection.mOwner == this) {
            if (gsmCdmaConnection == this.mPendingMO) {
                log("hangup: set hangupPendingMO to true");
                this.mHangupPendingMO = true;
                onHangupPendingMo();
            } else if (!isPhoneTypeGsm() && gsmCdmaConnection.getCall() == (gsmCdmaCall = this.mRingingCall) && gsmCdmaCall.getState() == Call.State.WAITING) {
                gsmCdmaConnection.onLocalDisconnect();
                updatePhoneState();
                this.mPhone.notifyPreciseCallStateChanged();
                return;
            } else {
                try {
                    this.mMetrics.writeRilHangup(this.mPhone.getPhoneId(), gsmCdmaConnection, gsmCdmaConnection.getGsmCdmaIndex(), getNetworkCountryIso());
                    this.mCi.hangupConnection(gsmCdmaConnection.getGsmCdmaIndex(), obtainCompleteMessage());
                } catch (CallStateException unused) {
                    Rlog.w(LOG_TAG, "GsmCdmaCallTracker WARN: hangup() on absent connection " + gsmCdmaConnection);
                }
            }
            gsmCdmaConnection.onHangupLocal();
            return;
        }
        throw new CallStateException("GsmCdmaConnection " + gsmCdmaConnection + "does not belong to GsmCdmaCallTracker " + this);
    }

    public void separate(GsmCdmaConnection gsmCdmaConnection) throws CallStateException {
        if (gsmCdmaConnection.mOwner == this) {
            try {
                this.mCi.separateConnection(gsmCdmaConnection.getGsmCdmaIndex(), obtainCompleteMessage(12));
            } catch (CallStateException unused) {
                Rlog.w(LOG_TAG, "GsmCdmaCallTracker WARN: separate() on absent connection " + gsmCdmaConnection);
            }
        } else {
            throw new CallStateException("GsmCdmaConnection " + gsmCdmaConnection + "does not belong to GsmCdmaCallTracker " + this);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setMute(boolean z) {
        this.mDesiredMute = z;
        this.mCi.setMute(z, (Message) null);
    }

    public boolean getMute() {
        return this.mDesiredMute;
    }

    public void hangup(GsmCdmaCall gsmCdmaCall) throws CallStateException {
        if (gsmCdmaCall.getConnectionsCount() != 0) {
            GsmCdmaCall gsmCdmaCall2 = this.mRingingCall;
            if (gsmCdmaCall == gsmCdmaCall2) {
                log("(ringing) hangup waiting or background");
                logHangupEvent(gsmCdmaCall);
                onHangupRingCall(gsmCdmaCall);
            } else if (gsmCdmaCall == this.mForegroundCall) {
                if (gsmCdmaCall.isDialingOrAlerting()) {
                    log("(foregnd) hangup dialing or alerting...");
                    hangup((GsmCdmaConnection) gsmCdmaCall.getConnections().get(0));
                } else if (!isPhoneTypeGsm() || !this.mRingingCall.isRinging()) {
                    logHangupEvent(gsmCdmaCall);
                    onHangupForegroundActiveCall(gsmCdmaCall);
                } else {
                    log("hangup all conns in active/background call, without affecting ringing call");
                    onHangupGsmForegroundWithRingCall(gsmCdmaCall);
                }
            } else if (gsmCdmaCall != this.mBackgroundCall) {
                throw new RuntimeException("GsmCdmaCall " + gsmCdmaCall + "does not belong to GsmCdmaCallTracker " + this);
            } else if (gsmCdmaCall2.isRinging()) {
                log("hangup all conns in background call");
                hangupAllConnections(gsmCdmaCall);
            } else {
                onHangupBackground(gsmCdmaCall);
            }
            gsmCdmaCall.onHangupLocal();
            this.mPhone.notifyPreciseCallStateChanged();
            return;
        }
        throw new CallStateException("no connections in call");
    }

    /* access modifiers changed from: protected */
    public void logHangupEvent(GsmCdmaCall gsmCdmaCall) {
        int i;
        Iterator<Connection> it = gsmCdmaCall.getConnections().iterator();
        while (it.hasNext()) {
            GsmCdmaConnection gsmCdmaConnection = (GsmCdmaConnection) it.next();
            try {
                i = gsmCdmaConnection.getGsmCdmaIndex();
            } catch (CallStateException unused) {
                i = -1;
            }
            this.mMetrics.writeRilHangup(this.mPhone.getPhoneId(), gsmCdmaConnection, i, getNetworkCountryIso());
        }
    }

    public void hangupWaitingOrBackground() {
        log("hangupWaitingOrBackground");
        logHangupEvent(this.mBackgroundCall);
        this.mCi.hangupWaitingOrBackground(obtainCompleteMessage());
    }

    public void hangupForegroundResumeBackground() {
        log("hangupForegroundResumeBackground");
        this.mCi.hangupForegroundResumeBackground(obtainCompleteMessage());
    }

    public void hangupConnectionByIndex(GsmCdmaCall gsmCdmaCall, int i) throws CallStateException {
        Iterator<Connection> it = gsmCdmaCall.getConnections().iterator();
        while (it.hasNext()) {
            GsmCdmaConnection gsmCdmaConnection = (GsmCdmaConnection) it.next();
            if (!gsmCdmaConnection.mDisconnected && gsmCdmaConnection.getGsmCdmaIndex() == i) {
                this.mMetrics.writeRilHangup(this.mPhone.getPhoneId(), gsmCdmaConnection, gsmCdmaConnection.getGsmCdmaIndex(), getNetworkCountryIso());
                this.mCi.hangupConnection(i, obtainCompleteMessage());
                return;
            }
        }
        throw new CallStateException("no GsmCdma index found");
    }

    public void hangupAllConnections(GsmCdmaCall gsmCdmaCall) {
        try {
            Iterator<Connection> it = gsmCdmaCall.getConnections().iterator();
            while (it.hasNext()) {
                GsmCdmaConnection gsmCdmaConnection = (GsmCdmaConnection) it.next();
                if (!gsmCdmaConnection.mDisconnected) {
                    this.mMetrics.writeRilHangup(this.mPhone.getPhoneId(), gsmCdmaConnection, gsmCdmaConnection.getGsmCdmaIndex(), getNetworkCountryIso());
                    this.mCi.hangupConnection(gsmCdmaConnection.getGsmCdmaIndex(), obtainCompleteMessage());
                }
            }
        } catch (CallStateException e) {
            Rlog.e(LOG_TAG, "hangupConnectionByIndex caught " + e);
        }
    }

    public GsmCdmaConnection getConnectionByIndex(GsmCdmaCall gsmCdmaCall, int i) throws CallStateException {
        Iterator<Connection> it = gsmCdmaCall.getConnections().iterator();
        while (it.hasNext()) {
            GsmCdmaConnection gsmCdmaConnection = (GsmCdmaConnection) it.next();
            if (!gsmCdmaConnection.mDisconnected && gsmCdmaConnection.getGsmCdmaIndex() == i) {
                return gsmCdmaConnection;
            }
        }
        return null;
    }

    /* access modifiers changed from: protected */
    public void notifyCallWaitingInfo(CdmaCallWaitingNotification cdmaCallWaitingNotification) {
        RegistrantList registrantList = this.mCallWaitingRegistrants;
        if (registrantList != null) {
            registrantList.notifyRegistrants(new AsyncResult((Object) null, cdmaCallWaitingNotification, (Throwable) null));
        }
    }

    /* access modifiers changed from: protected */
    public void handleCallWaitingInfo(CdmaCallWaitingNotification cdmaCallWaitingNotification) {
        onCreateGsmCdmaConnection(this.mPhone.getContext(), cdmaCallWaitingNotification, this, this.mRingingCall);
        updatePhoneState();
        notifyCallWaitingInfo(cdmaCallWaitingNotification);
    }

    /* access modifiers changed from: protected */
    public PhoneInternalInterface.SuppService getFailedService(int i) {
        if (i == 8) {
            return PhoneInternalInterface.SuppService.SWITCH;
        }
        switch (i) {
            case 11:
                return PhoneInternalInterface.SuppService.CONFERENCE;
            case 12:
                return PhoneInternalInterface.SuppService.SEPARATE;
            case 13:
                return PhoneInternalInterface.SuppService.TRANSFER;
            default:
                return PhoneInternalInterface.SuppService.UNKNOWN;
        }
    }

    public void handleMessage(Message message) {
        Connection latestConnection;
        Connection latestConnection2;
        int i = message.what;
        String str = null;
        if (i == 1) {
            Rlog.d(LOG_TAG, "Event EVENT_POLL_CALLS_RESULT Received");
            if (message == this.mLastRelevantPoll) {
                this.mNeedsPoll = false;
                this.mLastRelevantPoll = null;
                handlePollCalls((AsyncResult) message.obj);
            }
        } else if (i == 2 || i == 3) {
            pollCallsWhenSafe();
        } else if (i == 4) {
            operationComplete();
        } else if (i == 5) {
            AsyncResult asyncResult = (AsyncResult) message.obj;
            operationComplete();
            Throwable th = asyncResult.exception;
            int i2 = 16;
            if (th == null) {
                LastCallFailCause lastCallFailCause = (LastCallFailCause) asyncResult.result;
                i2 = lastCallFailCause.causeCode;
                str = lastCallFailCause.vendorCause;
            } else if (th instanceof CommandException) {
                CommandException commandException = (CommandException) th;
                int i3 = AnonymousClass3.$SwitchMap$com$android$internal$telephony$CommandException$Error[commandException.getCommandError().ordinal()];
                if (i3 == 1 || i3 == 2 || i3 == 3 || i3 == 4) {
                    str = commandException.getCommandError().toString();
                    i2 = 65535;
                }
            } else {
                Rlog.i(LOG_TAG, "Exception during getLastCallFailCause, assuming normal disconnect");
            }
            if (i2 == 34 || i2 == 41 || i2 == 42 || i2 == 44 || i2 == 49 || i2 == 58 || i2 == 65535) {
                CellLocation asCellLocation = this.mPhone.getCurrentCellIdentity().asCellLocation();
                int i4 = -1;
                if (asCellLocation != null) {
                    if (asCellLocation instanceof GsmCellLocation) {
                        i4 = ((GsmCellLocation) asCellLocation).getCid();
                    } else if (asCellLocation instanceof CdmaCellLocation) {
                        i4 = ((CdmaCellLocation) asCellLocation).getBaseStationId();
                    }
                }
                EventLog.writeEvent(EventLogTags.CALL_DROP, new Object[]{Integer.valueOf(i2), Integer.valueOf(i4), Integer.valueOf(TelephonyManager.getDefault().getNetworkType())});
            }
            if (isEmcRetryCause(i2) && this.mPhone.useImsForEmergency()) {
                Iterator<Connection> it = this.mForegroundCall.mConnections.iterator();
                String str2 = "";
                while (it.hasNext()) {
                    GsmCdmaConnection gsmCdmaConnection = (GsmCdmaConnection) it.next();
                    String origDialString = gsmCdmaConnection.getOrigDialString();
                    gsmCdmaConnection.getCall().detach(gsmCdmaConnection);
                    this.mDroppedDuringPoll.remove(gsmCdmaConnection);
                    str2 = origDialString;
                }
                this.mPhone.notifyVolteSilentRedial(str2, i2);
                updatePhoneState();
                if (this.mDroppedDuringPoll.isEmpty()) {
                    log("LAST_CALL_FAIL_CAUSE - no Dropped normal Call");
                    return;
                }
            }
            int size = this.mDroppedDuringPoll.size();
            for (int i5 = 0; i5 < size; i5++) {
                this.mDroppedDuringPoll.get(i5).onRemoteDisconnect(i2, str);
            }
            updatePhoneState();
            this.mPhone.notifyPreciseCallStateChanged();
            this.mMetrics.writeRilCallList(this.mPhone.getPhoneId(), this.mDroppedDuringPoll, getNetworkCountryIso());
            this.mPhone.getVoiceCallSessionStats().onRilCallListChanged(this.mDroppedDuringPoll);
            this.mDroppedDuringPoll.clear();
        } else if (i != 20) {
            switch (i) {
                case 8:
                case 12:
                case 13:
                    break;
                case 9:
                    handleRadioAvailable();
                    return;
                case 10:
                    handleRadioNotAvailable();
                    return;
                case 11:
                    if (!(!isPhoneTypeGsm() || ((AsyncResult) message.obj).exception == null || (latestConnection2 = this.mForegroundCall.getLatestConnection()) == null)) {
                        latestConnection2.onConferenceMergeFailed();
                        break;
                    }
                case 14:
                    if (!isPhoneTypeGsm()) {
                        if (this.mPendingCallInEcm) {
                            this.mCi.dial(this.mPendingMO.getAddress(), this.mPendingMO.isEmergencyCall(), this.mPendingMO.getEmergencyNumberInfo(), this.mPendingMO.hasKnownUserIntentEmergency(), this.mPendingCallClirMode, obtainCompleteMessage());
                            this.mPendingCallInEcm = false;
                        }
                        this.mPhone.unsetOnEcbModeExitResponse(this);
                        return;
                    }
                    throw new RuntimeException("unexpected event " + message.what + " not handled by phone type " + this.mPhone.getPhoneType());
                case 15:
                    if (!isPhoneTypeGsm()) {
                        AsyncResult asyncResult2 = (AsyncResult) message.obj;
                        if (asyncResult2.exception == null) {
                            handleCallWaitingInfo((CdmaCallWaitingNotification) asyncResult2.result);
                            Rlog.d(LOG_TAG, "Event EVENT_CALL_WAITING_INFO_CDMA Received");
                            return;
                        }
                        return;
                    }
                    throw new RuntimeException("unexpected event " + message.what + " not handled by phone type " + this.mPhone.getPhoneType());
                case 16:
                    if (isPhoneTypeGsm()) {
                        throw new RuntimeException("unexpected event " + message.what + " not handled by phone type " + this.mPhone.getPhoneType());
                    } else if (((AsyncResult) message.obj).exception == null) {
                        this.mPendingMO.onConnectedInOrOut();
                        this.mPendingMO = null;
                        return;
                    } else {
                        return;
                    }
                default:
                    throw new RuntimeException("unexpected event " + message.what + " not handled by phone type " + this.mPhone.getPhoneType());
            }
            if (isPhoneTypeGsm()) {
                if (((AsyncResult) message.obj).exception != null) {
                    if (message.what == 8 && (latestConnection = this.mForegroundCall.getLatestConnection()) != null) {
                        if (this.mBackgroundCall.getState() != Call.State.HOLDING) {
                            latestConnection.onConnectionEvent("android.telecom.event.CALL_HOLD_FAILED", (Bundle) null);
                        } else {
                            latestConnection.onConnectionEvent("android.telecom.event.CALL_SWITCH_FAILED", (Bundle) null);
                        }
                    }
                    this.mPhone.notifySuppServiceFailed(getFailedService(message.what));
                }
                operationComplete();
            } else if (message.what != 8) {
                throw new RuntimeException("unexpected event " + message.what + " not handled by phone type " + this.mPhone.getPhoneType());
            }
        } else if (isPhoneTypeGsm()) {
            throw new RuntimeException("unexpected event " + message.what + " not handled by phone type " + this.mPhone.getPhoneType());
        } else if (((AsyncResult) message.obj).exception == null) {
            postDelayed(new Runnable() {
                public void run() {
                    GsmCdmaCallTracker gsmCdmaCallTracker = GsmCdmaCallTracker.this;
                    GsmCdmaConnection gsmCdmaConnection = gsmCdmaCallTracker.mPendingMO;
                    if (gsmCdmaConnection != null) {
                        gsmCdmaCallTracker.mCi.sendCDMAFeatureCode(gsmCdmaConnection.getAddress(), GsmCdmaCallTracker.this.obtainMessage(16));
                    }
                }
            }, (long) this.m3WayCallFlashDelay);
        } else {
            this.mPendingMO = null;
            Rlog.w(LOG_TAG, "exception happened on Blank Flash for 3-way call");
        }
    }

    /* renamed from: com.android.internal.telephony.GsmCdmaCallTracker$3  reason: invalid class name */
    static /* synthetic */ class AnonymousClass3 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$CommandException$Error;

        /* JADX WARNING: Can't wrap try/catch for region: R(8:0|1|2|3|4|5|6|(3:7|8|10)) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        static {
            /*
                com.android.internal.telephony.CommandException$Error[] r0 = com.android.internal.telephony.CommandException.Error.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$CommandException$Error = r0
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.RADIO_NOT_AVAILABLE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.NO_MEMORY     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.INTERNAL_ERR     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.NO_RESOURCES     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaCallTracker.AnonymousClass3.<clinit>():void");
        }
    }

    public void dispatchCsCallRadioTech(int i) {
        GsmCdmaConnection[] gsmCdmaConnectionArr = this.mConnections;
        if (gsmCdmaConnectionArr == null) {
            log("dispatchCsCallRadioTech: mConnections is null");
            return;
        }
        for (GsmCdmaConnection gsmCdmaConnection : gsmCdmaConnectionArr) {
            if (gsmCdmaConnection != null) {
                gsmCdmaConnection.setCallRadioTech(i);
            }
        }
    }

    /* access modifiers changed from: protected */
    public void checkAndEnableDataCallAfterEmergencyCallDropped() {
        if (this.mIsInEmergencyCall) {
            this.mIsInEmergencyCall = false;
            boolean isInEcm = this.mPhone.isInEcm();
            log("checkAndEnableDataCallAfterEmergencyCallDropped,inEcm=" + isInEcm);
            if (!isInEcm) {
                if (!this.mPhone.isUsingNewDataStack()) {
                    this.mPhone.getDataEnabledSettings().setInternalDataEnabled(true);
                }
                this.mPhone.notifyEmergencyCallRegistrants(false);
            }
            this.mPhone.sendEmergencyCallStateChange(false);
        }
    }

    /* access modifiers changed from: protected */
    public Connection checkMtFindNewRinging(DriverCall driverCall, int i) {
        if (this.mConnections[i].getCall() == this.mRingingCall) {
            GsmCdmaConnection gsmCdmaConnection = this.mConnections[i];
            log("Notify new ring " + driverCall);
            return gsmCdmaConnection;
        }
        Rlog.e(LOG_TAG, "Phantom call appeared " + driverCall);
        DriverCall.State state = driverCall.state;
        if (!(state == DriverCall.State.ALERTING || state == DriverCall.State.DIALING)) {
            this.mConnections[i].onConnectedInOrOut();
            if (driverCall.state == DriverCall.State.HOLDING) {
                this.mConnections[i].onStartedHolding();
            }
        }
        return null;
    }

    public boolean isInEmergencyCall() {
        return this.mIsInEmergencyCall;
    }

    public boolean isInOtaspCall() {
        GsmCdmaConnection gsmCdmaConnection = this.mPendingMO;
        return (gsmCdmaConnection != null && gsmCdmaConnection.isOtaspCall()) || this.mForegroundCall.getConnections().stream().filter(new GsmCdmaCallTracker$$ExternalSyntheticLambda0()).count() > 0;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isInOtaspCall$0(Connection connection) {
        return (connection instanceof GsmCdmaConnection) && ((GsmCdmaConnection) connection).isOtaspCall();
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isPhoneTypeGsm() {
        return this.mPhone.getPhoneType() == 1;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GsmCdmaPhone getPhone() {
        return this.mPhone;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        Rlog.d(LOG_TAG, "[" + this.mPhone.getPhoneId() + "] " + str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("GsmCdmaCallTracker extends:");
        super.dump(fileDescriptor, printWriter, strArr);
        printWriter.println("mConnections: length=" + this.mConnections.length);
        for (int i = 0; i < this.mConnections.length; i++) {
            printWriter.printf("  mConnections[%d]=%s\n", new Object[]{Integer.valueOf(i), this.mConnections[i]});
        }
        printWriter.println(" mVoiceCallEndedRegistrants=" + this.mVoiceCallEndedRegistrants);
        printWriter.println(" mVoiceCallStartedRegistrants=" + this.mVoiceCallStartedRegistrants);
        if (!isPhoneTypeGsm()) {
            printWriter.println(" mCallWaitingRegistrants=" + this.mCallWaitingRegistrants);
        }
        printWriter.println(" mDroppedDuringPoll: size=" + this.mDroppedDuringPoll.size());
        for (int i2 = 0; i2 < this.mDroppedDuringPoll.size(); i2++) {
            printWriter.printf("  mDroppedDuringPoll[%d]=%s\n", new Object[]{Integer.valueOf(i2), this.mDroppedDuringPoll.get(i2)});
        }
        printWriter.println(" mRingingCall=" + this.mRingingCall);
        printWriter.println(" mForegroundCall=" + this.mForegroundCall);
        printWriter.println(" mBackgroundCall=" + this.mBackgroundCall);
        printWriter.println(" mPendingMO=" + this.mPendingMO);
        printWriter.println(" mHangupPendingMO=" + this.mHangupPendingMO);
        printWriter.println(" mPhone=" + this.mPhone);
        printWriter.println(" mDesiredMute=" + this.mDesiredMute);
        printWriter.println(" mState=" + this.mState);
        if (!isPhoneTypeGsm()) {
            printWriter.println(" mPendingCallInEcm=" + this.mPendingCallInEcm);
            printWriter.println(" mIsInEmergencyCall=" + this.mIsInEmergencyCall);
            printWriter.println(" mPendingCallClirMode=" + this.mPendingCallClirMode);
        }
    }

    public PhoneConstants.State getState() {
        return this.mState;
    }

    public int getMaxConnectionsPerCall() {
        return this.mPhone.isPhoneTypeGsm() ? 5 : 1;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:4:0x000a, code lost:
        r0 = (r0 = r0.getServiceStateTracker()).getLocaleTracker();
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private java.lang.String getNetworkCountryIso() {
        /*
            r0 = this;
            com.android.internal.telephony.GsmCdmaPhone r0 = r0.mPhone
            if (r0 == 0) goto L_0x0015
            com.android.internal.telephony.ServiceStateTracker r0 = r0.getServiceStateTracker()
            if (r0 == 0) goto L_0x0015
            com.android.internal.telephony.LocaleTracker r0 = r0.getLocaleTracker()
            if (r0 == 0) goto L_0x0015
            java.lang.String r0 = r0.getCurrentCountry()
            goto L_0x0017
        L_0x0015:
            java.lang.String r0 = ""
        L_0x0017:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaCallTracker.getNetworkCountryIso():java.lang.String");
    }

    public void cleanupCalls() {
        pollCallsWhenSafe();
    }

    /* access modifiers changed from: protected */
    public GsmCdmaConnection onCreateGsmCdmaConnection(GsmCdmaPhone gsmCdmaPhone, String str, GsmCdmaCallTracker gsmCdmaCallTracker, GsmCdmaCall gsmCdmaCall, PhoneInternalInterface.DialArgs dialArgs) {
        return new GsmCdmaConnection(gsmCdmaPhone, str, gsmCdmaCallTracker, gsmCdmaCall, dialArgs);
    }

    /* access modifiers changed from: protected */
    public GsmCdmaConnection onCreateGsmCdmaConnection(Context context, CdmaCallWaitingNotification cdmaCallWaitingNotification, GsmCdmaCallTracker gsmCdmaCallTracker, GsmCdmaCall gsmCdmaCall) {
        return new GsmCdmaConnection(context, cdmaCallWaitingNotification, gsmCdmaCallTracker, gsmCdmaCall);
    }

    /* access modifiers changed from: protected */
    public GsmCdmaConnection onCreateGsmCdmaConnection(GsmCdmaPhone gsmCdmaPhone, DriverCall driverCall, GsmCdmaCallTracker gsmCdmaCallTracker, int i) {
        return new GsmCdmaConnection(gsmCdmaPhone, driverCall, gsmCdmaCallTracker, i);
    }

    /* access modifiers changed from: protected */
    public void onGsmDial(String str, boolean z, EmergencyNumber emergencyNumber, boolean z2, int i, UUSInfo uUSInfo) {
        this.mCi.dial(str, z, emergencyNumber, z2, i, uUSInfo, obtainCompleteMessage());
    }

    /* access modifiers changed from: protected */
    public void onSwitchWaitingOrHoldingAndActive() {
        this.mCi.switchWaitingOrHoldingAndActive(obtainCompleteMessage(8));
    }

    /* access modifiers changed from: protected */
    public void onHangupRingCall(GsmCdmaCall gsmCdmaCall) throws CallStateException {
        this.mCi.hangupWaitingOrBackground(obtainCompleteMessage());
    }

    /* access modifiers changed from: protected */
    public void onHangupGsmForegroundWithRingCall(GsmCdmaCall gsmCdmaCall) throws CallStateException {
        hangupAllConnections(gsmCdmaCall);
    }

    /* access modifiers changed from: protected */
    public void onHangupForegroundActiveCall(GsmCdmaCall gsmCdmaCall) throws CallStateException {
        hangupForegroundResumeBackground();
    }

    /* access modifiers changed from: protected */
    public void onHangupBackground(GsmCdmaCall gsmCdmaCall) {
        hangupWaitingOrBackground();
    }

    /* access modifiers changed from: protected */
    public void onCreateGsmCdmaConnectionForMismatch(DriverCall driverCall, GsmCdmaCallTracker gsmCdmaCallTracker, int i) {
        this.mConnections[i] = new GsmCdmaConnection(this.mPhone, driverCall, this, i);
    }
}
