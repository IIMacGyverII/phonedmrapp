package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.PowerManager;
import android.os.SystemClock;
import android.telephony.CarrierConfigManager;
import android.telephony.PhoneNumberUtils;
import android.text.TextUtils;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.Connection;
import com.android.internal.telephony.DriverCall;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.cdma.CdmaCallWaitingNotification;
import com.android.internal.telephony.emergency.EmergencyNumberTracker;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.telephony.Rlog;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.util.ArrayList;
import java.util.Collections;

public class GsmCdmaConnection extends Connection {
    private static final boolean DBG = true;
    static final int EVENT_DTMF_DELAY_DONE = 5;
    static final int EVENT_DTMF_DONE = 1;
    protected static final int EVENT_NEXT_POST_DIAL = 3;
    static final int EVENT_PAUSE_DONE = 2;
    static final int EVENT_WAKE_LOCK_TIMEOUT = 4;
    protected static final String LOG_TAG = "GsmCdmaConnection";
    public static final String OTASP_NUMBER = "*22899";
    static final int PAUSE_DELAY_MILLIS_CDMA = 2000;
    static final int PAUSE_DELAY_MILLIS_GSM = 3000;
    private static final boolean VDBG = false;
    static final int WAKE_LOCK_TIMEOUT_MILLIS = 60000;
    long mDisconnectTime;
    public boolean mDisconnected;
    /* access modifiers changed from: private */
    public int mDtmfToneDelay = 0;
    protected Handler mHandler;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int mIndex;
    protected TelephonyMetrics mMetrics = TelephonyMetrics.getInstance();
    public Connection mOrigConnection;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GsmCdmaCallTracker mOwner;
    protected GsmCdmaCall mParent;
    private PowerManager.WakeLock mPartialWakeLock;
    int mPreciseCause = 0;
    UUSInfo mUusInfo;
    String mVendorCause;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static boolean isPause(char c) {
        return c == ',';
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static boolean isWait(char c) {
        return c == ';';
    }

    private static boolean isWild(char c) {
        return c == 'N';
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private String maskDialString(String str) {
        return "<MASKED>";
    }

    /* access modifiers changed from: protected */
    public int getAudioQualityFromDC(int i) {
        return (i == 2 || i == 9) ? 2 : 1;
    }

    /* access modifiers changed from: protected */
    public void onUpdateDone() {
    }

    class MyHandler extends Handler {
        MyHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            int i = message.what;
            if (i != 1) {
                if (!(i == 2 || i == 3)) {
                    if (i == 4) {
                        GsmCdmaConnection.this.releaseWakeLock();
                        return;
                    } else if (i != 5) {
                        return;
                    }
                }
                GsmCdmaConnection.this.processNextPostDialChar();
                return;
            }
            Handler handler = GsmCdmaConnection.this.mHandler;
            handler.sendMessageDelayed(handler.obtainMessage(5), (long) GsmCdmaConnection.this.mDtmfToneDelay);
        }
    }

    public GsmCdmaConnection(GsmCdmaPhone gsmCdmaPhone, DriverCall driverCall, GsmCdmaCallTracker gsmCdmaCallTracker, int i) {
        super(gsmCdmaPhone.getPhoneType());
        createWakeLock(gsmCdmaPhone.getContext());
        acquireWakeLock();
        this.mOwner = gsmCdmaCallTracker;
        this.mHandler = new MyHandler(this.mOwner.getLooper());
        this.mAddress = driverCall.number;
        setEmergencyCallInfo(this.mOwner);
        ArrayList<String> arrayList = null;
        String str = TextUtils.isEmpty(driverCall.forwardedNumber) ? null : driverCall.forwardedNumber;
        Rlog.i(LOG_TAG, "create, forwardedNumber=" + Rlog.pii(LOG_TAG, str));
        this.mForwardedNumber = str != null ? new ArrayList<>(Collections.singletonList(driverCall.forwardedNumber)) : arrayList;
        this.mIsIncoming = driverCall.isMT;
        this.mCreateTime = System.currentTimeMillis();
        this.mCnapName = driverCall.name;
        this.mCnapNamePresentation = driverCall.namePresentation;
        this.mNumberPresentation = driverCall.numberPresentation;
        this.mUusInfo = driverCall.uusInfo;
        this.mIndex = i;
        GsmCdmaCall parentFromDCState = parentFromDCState(driverCall.state);
        this.mParent = parentFromDCState;
        parentFromDCState.attach(this, driverCall);
        fetchDtmfToneDelay(gsmCdmaPhone);
        setAudioQuality(getAudioQualityFromDC(driverCall.audioQuality));
        setCallRadioTech(this.mOwner.getPhone().getCsCallRadioTech());
    }

    public GsmCdmaConnection(GsmCdmaPhone gsmCdmaPhone, String str, GsmCdmaCallTracker gsmCdmaCallTracker, GsmCdmaCall gsmCdmaCall, PhoneInternalInterface.DialArgs dialArgs) {
        super(gsmCdmaPhone.getPhoneType());
        createWakeLock(gsmCdmaPhone.getContext());
        acquireWakeLock();
        this.mOwner = gsmCdmaCallTracker;
        this.mHandler = new MyHandler(this.mOwner.getLooper());
        this.mDialString = str;
        if (!isPhoneTypeGsm()) {
            Rlog.d(LOG_TAG, "[GsmCdmaConn] GsmCdmaConnection: dialString=" + maskDialString(str));
            str = formatDialString(str);
            Rlog.d(LOG_TAG, "[GsmCdmaConn] GsmCdmaConnection:formated dialString=" + maskDialString(str));
        }
        this.mAddress = PhoneNumberUtils.extractNetworkPortionAlt(str);
        if (dialArgs.isEmergency) {
            setEmergencyCallInfo(this.mOwner);
            if (getEmergencyNumberInfo() == null) {
                setNonDetectableEmergencyCallInfo(dialArgs.eccCategory);
            }
        }
        this.mPostDialString = PhoneNumberUtils.extractPostDialPortion(str);
        this.mIndex = -1;
        this.mIsIncoming = false;
        this.mCnapName = null;
        this.mCnapNamePresentation = 1;
        this.mNumberPresentation = 1;
        this.mCreateTime = System.currentTimeMillis();
        if (gsmCdmaCall != null) {
            this.mParent = gsmCdmaCall;
            if (isPhoneTypeGsm()) {
                gsmCdmaCall.attachFake(this, Call.State.DIALING);
            } else {
                Call.State state = gsmCdmaCall.mState;
                Call.State state2 = Call.State.ACTIVE;
                if (state == state2) {
                    gsmCdmaCall.attachFake(this, state2);
                } else {
                    gsmCdmaCall.attachFake(this, Call.State.DIALING);
                }
            }
        }
        fetchDtmfToneDelay(gsmCdmaPhone);
        setCallRadioTech(this.mOwner.getPhone().getCsCallRadioTech());
    }

    public GsmCdmaConnection(Context context, CdmaCallWaitingNotification cdmaCallWaitingNotification, GsmCdmaCallTracker gsmCdmaCallTracker, GsmCdmaCall gsmCdmaCall) {
        super(gsmCdmaCall.getPhone().getPhoneType());
        createWakeLock(context);
        acquireWakeLock();
        this.mOwner = gsmCdmaCallTracker;
        this.mHandler = new MyHandler(this.mOwner.getLooper());
        this.mAddress = cdmaCallWaitingNotification.number;
        this.mNumberPresentation = cdmaCallWaitingNotification.numberPresentation;
        this.mCnapName = cdmaCallWaitingNotification.name;
        this.mCnapNamePresentation = cdmaCallWaitingNotification.namePresentation;
        this.mIndex = -1;
        this.mIsIncoming = true;
        this.mCreateTime = System.currentTimeMillis();
        this.mConnectTime = 0;
        this.mParent = gsmCdmaCall;
        gsmCdmaCall.attachFake(this, Call.State.WAITING);
        setCallRadioTech(this.mOwner.getPhone().getCsCallRadioTech());
    }

    public void dispose() {
        clearPostDialListeners();
        GsmCdmaCall gsmCdmaCall = this.mParent;
        if (gsmCdmaCall != null) {
            gsmCdmaCall.detach(this);
        }
        releaseAllWakeLocks();
    }

    static boolean equalsHandlesNulls(Object obj, Object obj2) {
        if (obj == null) {
            return obj2 == null;
        }
        return obj.equals(obj2);
    }

    static boolean equalsBaseDialString(String str, String str2) {
        if (str == null) {
            if (str2 == null) {
                return true;
            }
        } else if (str2 != null && str.startsWith(str2)) {
            return true;
        }
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static String formatDialString(String str) {
        if (str == null) {
            return null;
        }
        int length = str.length();
        StringBuilder sb = new StringBuilder();
        int i = 0;
        while (i < length) {
            char charAt = str.charAt(i);
            if (isPause(charAt) || isWait(charAt)) {
                int i2 = length - 1;
                if (i < i2) {
                    int findNextPCharOrNonPOrNonWCharIndex = findNextPCharOrNonPOrNonWCharIndex(str, i);
                    if (findNextPCharOrNonPOrNonWCharIndex < length) {
                        sb.append(findPOrWCharToAppend(str, i, findNextPCharOrNonPOrNonWCharIndex));
                        if (findNextPCharOrNonPOrNonWCharIndex > i + 1) {
                            i = findNextPCharOrNonPOrNonWCharIndex - 1;
                        }
                    } else if (findNextPCharOrNonPOrNonWCharIndex == length) {
                        i = i2;
                    }
                }
            } else {
                sb.append(charAt);
            }
            i++;
        }
        return PhoneNumberUtils.cdmaCheckAndProcessPlusCode(sb.toString());
    }

    public boolean compareTo(DriverCall driverCall) {
        if (!this.mIsIncoming && !driverCall.isMT) {
            return true;
        }
        if (isPhoneTypeGsm() && this.mOrigConnection != null) {
            return true;
        }
        String stringFromStringAndTOA = PhoneNumberUtils.stringFromStringAndTOA(driverCall.number, driverCall.TOA);
        if (this.mIsIncoming != driverCall.isMT || !equalsHandlesNulls(this.mAddress, stringFromStringAndTOA)) {
            return false;
        }
        return true;
    }

    public String getOrigDialString() {
        return this.mDialString;
    }

    public GsmCdmaCall getCall() {
        return this.mParent;
    }

    public long getDisconnectTime() {
        return this.mDisconnectTime;
    }

    public long getHoldDurationMillis() {
        if (getState() != Call.State.HOLDING) {
            return 0;
        }
        return SystemClock.elapsedRealtime() - this.mHoldingStartTime;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Call.State getState() {
        if (this.mDisconnected) {
            return Call.State.DISCONNECTED;
        }
        return super.getState();
    }

    public void hangup() throws CallStateException {
        if (!this.mDisconnected) {
            this.mOwner.hangup(this);
            return;
        }
        throw new CallStateException("disconnected");
    }

    public void deflect(String str) throws CallStateException {
        throw new CallStateException("deflect is not supported for CS");
    }

    public void transfer(String str, boolean z) throws CallStateException {
        throw new CallStateException("Transfer is not supported for CS");
    }

    public void consultativeTransfer(Connection connection) throws CallStateException {
        throw new CallStateException("Transfer is not supported for CS");
    }

    public void separate() throws CallStateException {
        if (!this.mDisconnected) {
            this.mOwner.separate(this);
            return;
        }
        throw new CallStateException("disconnected");
    }

    public void proceedAfterWaitChar() {
        if (this.mPostDialState != Connection.PostDialState.WAIT) {
            Rlog.w(LOG_TAG, "GsmCdmaConnection.proceedAfterWaitChar(): Expected getPostDialState() to be WAIT but was " + this.mPostDialState);
            return;
        }
        setPostDialState(Connection.PostDialState.STARTED);
        processNextPostDialChar();
    }

    public void proceedAfterWildChar(String str) {
        if (this.mPostDialState != Connection.PostDialState.WILD) {
            Rlog.w(LOG_TAG, "GsmCdmaConnection.proceedAfterWaitChar(): Expected getPostDialState() to be WILD but was " + this.mPostDialState);
            return;
        }
        setPostDialState(Connection.PostDialState.STARTED);
        this.mPostDialString = str + this.mPostDialString.substring(this.mNextPostDialChar);
        this.mNextPostDialChar = 0;
        log("proceedAfterWildChar: new postDialString is " + this.mPostDialString);
        processNextPostDialChar();
    }

    public void cancelPostDial() {
        setPostDialState(Connection.PostDialState.CANCELLED);
    }

    public void onHangupLocal() {
        this.mCause = 3;
        this.mPreciseCause = 0;
        this.mVendorCause = null;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int disconnectCauseFromCode(int i) {
        IccCardApplicationStatus.AppState appState;
        if (i == 1) {
            return 25;
        }
        if (i == 8) {
            return 20;
        }
        if (i == 17) {
            return 4;
        }
        if (i == 19) {
            return 13;
        }
        if (i == 31) {
            return 65;
        }
        if (i == 34 || i == 44 || i == 49 || i == 58) {
            return 5;
        }
        if (i == 68) {
            return 15;
        }
        if (i == 41 || i == 42) {
            return 5;
        }
        if (i == 240) {
            return 20;
        }
        if (i == 241) {
            return 21;
        }
        if (i == 325) {
            return 63;
        }
        if (i == 326) {
            return 64;
        }
        switch (i) {
            case CallFailCause.IMEI_NOT_ACCEPTED:
                return 58;
            case CallFailCause.DIAL_MODIFIED_TO_USSD:
                return 46;
            case CallFailCause.DIAL_MODIFIED_TO_SS:
                return 47;
            case CallFailCause.DIAL_MODIFIED_TO_DIAL:
                return 48;
            case CallFailCause.RADIO_OFF:
                return 17;
            default:
                switch (i) {
                    case 1000:
                        return 26;
                    case 1001:
                        return 27;
                    case 1002:
                        return 28;
                    case 1003:
                        return 29;
                    case 1004:
                        return 30;
                    case 1005:
                        return 31;
                    case 1006:
                        return 32;
                    case 1007:
                        return 33;
                    case 1008:
                        return 34;
                    case 1009:
                        return 35;
                    default:
                        GsmCdmaPhone phone = this.mOwner.getPhone();
                        int state = phone.getServiceState().getState();
                        UiccCardApplication uiccCardApplication = phone.getUiccCardApplication();
                        if (uiccCardApplication != null) {
                            appState = uiccCardApplication.getState();
                        } else {
                            appState = IccCardApplicationStatus.AppState.APPSTATE_UNKNOWN;
                        }
                        if (state == 3) {
                            return 17;
                        }
                        if (!isEmergencyCall()) {
                            if (state == 1 || state == 2) {
                                return 18;
                            }
                            if (appState != IccCardApplicationStatus.AppState.APPSTATE_READY && (isPhoneTypeGsm() || phone.mCdmaSubscriptionSource == 0)) {
                                return 19;
                            }
                        }
                        if (isPhoneTypeGsm() && (i == 65535 || i == 260)) {
                            if (phone.mSST.mRestrictedState.isCsRestricted()) {
                                return 22;
                            }
                            if (phone.mSST.mRestrictedState.isCsEmergencyRestricted()) {
                                return 24;
                            }
                            if (phone.mSST.mRestrictedState.isCsNormalRestricted()) {
                                return 23;
                            }
                        }
                        if (i == 16) {
                            return 2;
                        }
                        return 36;
                }
        }
    }

    /* access modifiers changed from: package-private */
    public void onRemoteDisconnect(int i, String str) {
        this.mPreciseCause = i;
        this.mVendorCause = str;
        onDisconnect(disconnectCauseFromCode(i));
    }

    public boolean onDisconnect(int i) {
        this.mCause = i;
        boolean z = false;
        if (!this.mDisconnected) {
            doDisconnect();
            Rlog.d(LOG_TAG, "onDisconnect: cause=" + i);
            this.mOwner.getPhone().notifyDisconnect(this);
            notifyDisconnect(i);
            GsmCdmaCall gsmCdmaCall = this.mParent;
            if (gsmCdmaCall != null) {
                z = gsmCdmaCall.connectionDisconnected(this);
            }
            this.mOrigConnection = null;
        }
        clearPostDialListeners();
        releaseWakeLock();
        return z;
    }

    public void onLocalDisconnect() {
        if (!this.mDisconnected) {
            doDisconnect();
            GsmCdmaCall gsmCdmaCall = this.mParent;
            if (gsmCdmaCall != null) {
                gsmCdmaCall.detach(this);
            }
        }
        releaseWakeLock();
    }

    /* JADX WARNING: Removed duplicated region for block: B:21:0x007d  */
    /* JADX WARNING: Removed duplicated region for block: B:28:0x00a5  */
    /* JADX WARNING: Removed duplicated region for block: B:31:0x00d0  */
    /* JADX WARNING: Removed duplicated region for block: B:32:0x00d2  */
    /* JADX WARNING: Removed duplicated region for block: B:35:0x00f2  */
    /* JADX WARNING: Removed duplicated region for block: B:38:0x0105  */
    /* JADX WARNING: Removed duplicated region for block: B:41:0x0116  */
    /* JADX WARNING: Removed duplicated region for block: B:44:0x0123  */
    /* JADX WARNING: Removed duplicated region for block: B:50:0x0154  */
    /* JADX WARNING: Removed duplicated region for block: B:54:0x0160  */
    /* JADX WARNING: Removed duplicated region for block: B:60:0x0183  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean update(com.android.internal.telephony.DriverCall r13) {
        /*
            r12 = this;
            boolean r0 = r12.isConnectingInOrOut()
            com.android.internal.telephony.Call$State r1 = r12.getState()
            com.android.internal.telephony.Call$State r2 = com.android.internal.telephony.Call.State.HOLDING
            r3 = 0
            r4 = 1
            if (r1 != r2) goto L_0x0010
            r1 = r4
            goto L_0x0011
        L_0x0010:
            r1 = r3
        L_0x0011:
            com.android.internal.telephony.DriverCall$State r5 = r13.state
            com.android.internal.telephony.GsmCdmaCall r5 = r12.parentFromDCState(r5)
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r7 = "parent= "
            r6.append(r7)
            com.android.internal.telephony.GsmCdmaCall r7 = r12.mParent
            r6.append(r7)
            java.lang.String r7 = ", newParent= "
            r6.append(r7)
            r6.append(r5)
            java.lang.String r6 = r6.toString()
            r12.log(r6)
            boolean r6 = r12.isPhoneTypeGsm()
            if (r6 == 0) goto L_0x0046
            com.android.internal.telephony.Connection r6 = r12.mOrigConnection
            if (r6 == 0) goto L_0x0046
            java.lang.String r6 = "update: mOrigConnection is not null"
            r12.log(r6)
            goto L_0x0070
        L_0x0046:
            boolean r6 = r12.isIncoming()
            if (r6 == 0) goto L_0x0070
            java.lang.String r6 = r12.mAddress
            java.lang.String r7 = r13.number
            boolean r6 = equalsBaseDialString(r6, r7)
            if (r6 != 0) goto L_0x0070
            boolean r6 = r12.mNumberConverted
            if (r6 == 0) goto L_0x0064
            java.lang.String r6 = r12.mConvertedNumber
            java.lang.String r7 = r13.number
            boolean r6 = equalsBaseDialString(r6, r7)
            if (r6 != 0) goto L_0x0070
        L_0x0064:
            java.lang.String r6 = "update: phone # changed!"
            r12.log(r6)
            java.lang.String r6 = r13.number
            r12.mAddress = r6
            r6 = r4
            goto L_0x0071
        L_0x0070:
            r6 = r3
        L_0x0071:
            int r7 = r13.audioQuality
            int r7 = r12.getAudioQualityFromDC(r7)
            int r8 = r12.getAudioQuality()
            if (r8 == r7) goto L_0x009f
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r8 = "update: audioQuality # changed!:  "
            r6.append(r8)
            r8 = 2
            if (r7 != r8) goto L_0x008e
            java.lang.String r8 = "high"
            goto L_0x0091
        L_0x008e:
            java.lang.String r8 = "standard"
        L_0x0091:
            r6.append(r8)
            java.lang.String r6 = r6.toString()
            r12.log(r6)
            r12.setAudioQuality(r7)
            r6 = r4
        L_0x009f:
            int r7 = r13.audioQuality
            int r8 = r12.mAudioCodec
            if (r7 == r8) goto L_0x00c7
            r12.mAudioCodec = r7
            com.android.internal.telephony.metrics.TelephonyMetrics r7 = r12.mMetrics
            com.android.internal.telephony.GsmCdmaCallTracker r8 = r12.mOwner
            com.android.internal.telephony.GsmCdmaPhone r8 = r8.getPhone()
            int r8 = r8.getPhoneId()
            int r9 = r13.audioQuality
            r7.writeAudioCodecGsmCdma(r8, r9)
            com.android.internal.telephony.GsmCdmaCallTracker r7 = r12.mOwner
            com.android.internal.telephony.GsmCdmaPhone r7 = r7.getPhone()
            com.android.internal.telephony.metrics.VoiceCallSessionStats r7 = r7.getVoiceCallSessionStats()
            int r8 = r13.audioQuality
            r7.onAudioCodecChanged(r12, r8)
        L_0x00c7:
            java.lang.String r7 = r13.forwardedNumber
            boolean r7 = android.text.TextUtils.isEmpty(r7)
            r8 = 0
            if (r7 == 0) goto L_0x00d2
            r7 = r8
            goto L_0x00d4
        L_0x00d2:
            java.lang.String r7 = r13.forwardedNumber
        L_0x00d4:
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r10 = "update: forwardedNumber="
            r9.append(r10)
            java.lang.String r10 = "GsmCdmaConnection"
            java.lang.String r11 = com.android.telephony.Rlog.pii(r10, r7)
            r9.append(r11)
            java.lang.String r9 = r9.toString()
            com.android.telephony.Rlog.i(r10, r9)
            if (r7 != 0) goto L_0x00f2
            goto L_0x00fd
        L_0x00f2:
            java.util.ArrayList r8 = new java.util.ArrayList
            java.lang.String r7 = r13.forwardedNumber
            java.util.List r7 = java.util.Collections.singletonList(r7)
            r8.<init>(r7)
        L_0x00fd:
            java.util.ArrayList<java.lang.String> r7 = r12.mForwardedNumber
            boolean r7 = equalsHandlesNulls(r7, r8)
            if (r7 != 0) goto L_0x010e
            java.lang.String r6 = "update: mForwardedNumber, # changed"
            r12.log(r6)
            r12.mForwardedNumber = r8
            r6 = r4
        L_0x010e:
            java.lang.String r7 = r13.name
            boolean r7 = android.text.TextUtils.isEmpty(r7)
            if (r7 == 0) goto L_0x0123
            java.lang.String r7 = r12.mCnapName
            boolean r7 = android.text.TextUtils.isEmpty(r7)
            if (r7 != 0) goto L_0x0132
            java.lang.String r6 = ""
            r12.mCnapName = r6
            goto L_0x0131
        L_0x0123:
            java.lang.String r7 = r13.name
            java.lang.String r8 = r12.mCnapName
            boolean r7 = r7.equals(r8)
            if (r7 != 0) goto L_0x0132
            java.lang.String r6 = r13.name
            r12.mCnapName = r6
        L_0x0131:
            r6 = r4
        L_0x0132:
            java.lang.StringBuilder r7 = new java.lang.StringBuilder
            r7.<init>()
            java.lang.String r8 = "--dssds----"
            r7.append(r8)
            java.lang.String r8 = r12.mCnapName
            r7.append(r8)
            java.lang.String r7 = r7.toString()
            r12.log(r7)
            int r7 = r13.namePresentation
            r12.mCnapNamePresentation = r7
            int r7 = r13.numberPresentation
            r12.mNumberPresentation = r7
            com.android.internal.telephony.GsmCdmaCall r7 = r12.mParent
            if (r5 == r7) goto L_0x0160
            if (r7 == 0) goto L_0x0159
            r7.detach(r12)
        L_0x0159:
            r5.attach(r12, r13)
            r12.mParent = r5
        L_0x015e:
            r13 = r4
            goto L_0x016a
        L_0x0160:
            boolean r13 = r7.update(r12, r13)
            if (r6 != 0) goto L_0x015e
            if (r13 == 0) goto L_0x0169
            goto L_0x015e
        L_0x0169:
            r13 = r3
        L_0x016a:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r7 = "update: parent="
            r6.append(r7)
            com.android.internal.telephony.GsmCdmaCall r7 = r12.mParent
            r6.append(r7)
            java.lang.String r7 = ", hasNewParent="
            r6.append(r7)
            com.android.internal.telephony.GsmCdmaCall r7 = r12.mParent
            if (r5 == r7) goto L_0x0184
            r3 = r4
        L_0x0184:
            r6.append(r3)
            java.lang.String r3 = ", wasConnectingInOrOut="
            r6.append(r3)
            r6.append(r0)
            java.lang.String r3 = ", wasHolding="
            r6.append(r3)
            r6.append(r1)
            java.lang.String r3 = ", isConnectingInOrOut="
            r6.append(r3)
            boolean r3 = r12.isConnectingInOrOut()
            r6.append(r3)
            java.lang.String r3 = ", changed="
            r6.append(r3)
            r6.append(r13)
            java.lang.String r3 = r6.toString()
            r12.log(r3)
            if (r0 == 0) goto L_0x01bd
            boolean r0 = r12.isConnectingInOrOut()
            if (r0 != 0) goto L_0x01bd
            r12.onConnectedInOrOut()
        L_0x01bd:
            if (r13 == 0) goto L_0x01ca
            if (r1 != 0) goto L_0x01ca
            com.android.internal.telephony.Call$State r0 = r12.getState()
            if (r0 != r2) goto L_0x01ca
            r12.onStartedHolding()
        L_0x01ca:
            r12.onUpdateDone()
            return r13
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaConnection.update(com.android.internal.telephony.DriverCall):boolean");
    }

    /* access modifiers changed from: package-private */
    public void fakeHoldBeforeDial() {
        GsmCdmaCall gsmCdmaCall = this.mParent;
        if (gsmCdmaCall != null) {
            gsmCdmaCall.detach(this);
        }
        GsmCdmaCall gsmCdmaCall2 = this.mOwner.mBackgroundCall;
        this.mParent = gsmCdmaCall2;
        gsmCdmaCall2.attachFake(this, Call.State.HOLDING);
        onStartedHolding();
    }

    public int getGsmCdmaIndex() throws CallStateException {
        int i = this.mIndex;
        if (i >= 0) {
            return i + 1;
        }
        throw new CallStateException("GsmCdma index not yet assigned");
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void onConnectedInOrOut() {
        this.mConnectTime = System.currentTimeMillis();
        this.mConnectTimeReal = SystemClock.elapsedRealtime();
        this.mDuration = 0;
        log("onConnectedInOrOut: connectTime=" + this.mConnectTime);
        if (!this.mIsIncoming) {
            onConnectedOut();
        } else {
            releaseWakeLock();
        }
    }

    /* access modifiers changed from: package-private */
    public void onConnectedConnectionMigrated() {
        releaseWakeLock();
    }

    private void doDisconnect() {
        this.mIndex = -1;
        this.mDisconnectTime = System.currentTimeMillis();
        this.mDuration = SystemClock.elapsedRealtime() - this.mConnectTimeReal;
        this.mDisconnected = true;
        clearPostDialListeners();
    }

    /* access modifiers changed from: protected */
    public void onStartedHolding() {
        this.mHoldingStartTime = SystemClock.elapsedRealtime();
    }

    /* access modifiers changed from: protected */
    public boolean processPostDialChar(char c) {
        if (PhoneNumberUtils.is12Key(c)) {
            this.mOwner.mCi.sendDtmf(c, this.mHandler.obtainMessage(1));
        } else if (isPause(c)) {
            if (!isPhoneTypeGsm()) {
                setPostDialState(Connection.PostDialState.PAUSE);
            }
            Handler handler = this.mHandler;
            handler.sendMessageDelayed(handler.obtainMessage(2), isPhoneTypeGsm() ? 3000 : LaunchConfig.ACTIVITY_CONSIDERED_RESUME);
        } else if (isWait(c)) {
            setPostDialState(Connection.PostDialState.WAIT);
        } else if (!isWild(c)) {
            return false;
        } else {
            setPostDialState(Connection.PostDialState.WILD);
        }
        return true;
    }

    public String getRemainingPostDialString() {
        String remainingPostDialString = super.getRemainingPostDialString();
        if (isPhoneTypeGsm() || TextUtils.isEmpty(remainingPostDialString)) {
            return remainingPostDialString;
        }
        int indexOf = remainingPostDialString.indexOf(59);
        int indexOf2 = remainingPostDialString.indexOf(44);
        if (indexOf <= 0 || (indexOf >= indexOf2 && indexOf2 > 0)) {
            return indexOf2 > 0 ? remainingPostDialString.substring(0, indexOf2) : remainingPostDialString;
        }
        return remainingPostDialString.substring(0, indexOf);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updateParent(GsmCdmaCall gsmCdmaCall, GsmCdmaCall gsmCdmaCall2) {
        if (gsmCdmaCall2 != gsmCdmaCall) {
            if (gsmCdmaCall != null) {
                gsmCdmaCall.detach(this);
            }
            gsmCdmaCall2.attachFake(this, Call.State.ACTIVE);
            this.mParent = gsmCdmaCall2;
        }
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        PowerManager.WakeLock wakeLock = this.mPartialWakeLock;
        if (wakeLock != null && wakeLock.isHeld()) {
            Rlog.e(LOG_TAG, "UNEXPECTED; mPartialWakeLock is held when finalizing.");
        }
        clearPostDialListeners();
        releaseWakeLock();
    }

    /* access modifiers changed from: protected */
    public void processNextPostDialChar() {
        char c;
        Message messageForRegistrant;
        if (this.mPostDialState == Connection.PostDialState.CANCELLED) {
            releaseWakeLock();
            return;
        }
        String str = this.mPostDialString;
        if (str == null || str.length() <= this.mNextPostDialChar) {
            setPostDialState(Connection.PostDialState.COMPLETE);
            releaseWakeLock();
            c = 0;
        } else {
            setPostDialState(Connection.PostDialState.STARTED);
            String str2 = this.mPostDialString;
            int i = this.mNextPostDialChar;
            this.mNextPostDialChar = i + 1;
            c = str2.charAt(i);
            if (!processPostDialChar(c)) {
                this.mHandler.obtainMessage(3).sendToTarget();
                Rlog.e(LOG_TAG, "processNextPostDialChar: c=" + c + " isn't valid!");
                return;
            }
        }
        notifyPostDialListenersNextChar(c);
        Registrant postDialHandler = this.mOwner.getPhone().getPostDialHandler();
        if (postDialHandler != null && (messageForRegistrant = postDialHandler.messageForRegistrant()) != null) {
            Connection.PostDialState postDialState = this.mPostDialState;
            AsyncResult forMessage = AsyncResult.forMessage(messageForRegistrant);
            forMessage.result = this;
            forMessage.userObj = postDialState;
            messageForRegistrant.arg1 = c;
            messageForRegistrant.sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:4:0x000a, code lost:
        r1 = r0.mState;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean isConnectingInOrOut() {
        /*
            r1 = this;
            com.android.internal.telephony.GsmCdmaCall r0 = r1.mParent
            if (r0 == 0) goto L_0x0017
            com.android.internal.telephony.GsmCdmaCallTracker r1 = r1.mOwner
            com.android.internal.telephony.GsmCdmaCall r1 = r1.mRingingCall
            if (r0 == r1) goto L_0x0017
            com.android.internal.telephony.Call$State r1 = r0.mState
            com.android.internal.telephony.Call$State r0 = com.android.internal.telephony.Call.State.DIALING
            if (r1 == r0) goto L_0x0017
            com.android.internal.telephony.Call$State r0 = com.android.internal.telephony.Call.State.ALERTING
            if (r1 != r0) goto L_0x0015
            goto L_0x0017
        L_0x0015:
            r1 = 0
            goto L_0x0018
        L_0x0017:
            r1 = 1
        L_0x0018:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaConnection.isConnectingInOrOut():boolean");
    }

    /* renamed from: com.android.internal.telephony.GsmCdmaConnection$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$DriverCall$State;

        /* JADX WARNING: Can't wrap try/catch for region: R(14:0|1|2|3|4|5|6|7|8|9|10|11|12|14) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.DriverCall$State[] r0 = com.android.internal.telephony.DriverCall.State.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$DriverCall$State = r0
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.ACTIVE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.DIALING     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.ALERTING     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.HOLDING     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.INCOMING     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.WAITING     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaConnection.AnonymousClass1.<clinit>():void");
        }
    }

    /* access modifiers changed from: protected */
    public GsmCdmaCall parentFromDCState(DriverCall.State state) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$DriverCall$State[state.ordinal()]) {
            case 1:
            case 2:
            case 3:
                return this.mOwner.mForegroundCall;
            case 4:
                return this.mOwner.mBackgroundCall;
            case 5:
            case 6:
                return this.mOwner.mRingingCall;
            default:
                throw new RuntimeException("illegal call state: " + state);
        }
    }

    /* access modifiers changed from: protected */
    public void setPostDialState(Connection.PostDialState postDialState) {
        if (postDialState == Connection.PostDialState.STARTED || postDialState == Connection.PostDialState.PAUSE) {
            synchronized (this.mPartialWakeLock) {
                if (this.mPartialWakeLock.isHeld()) {
                    this.mHandler.removeMessages(4);
                } else {
                    acquireWakeLock();
                }
                this.mHandler.sendMessageDelayed(this.mHandler.obtainMessage(4), 60000);
            }
        } else {
            this.mHandler.removeMessages(4);
            releaseWakeLock();
        }
        this.mPostDialState = postDialState;
        notifyPostDialListeners();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void createWakeLock(Context context) {
        this.mPartialWakeLock = ((PowerManager) context.getSystemService(XmlTagConst.TAG_POWER)).newWakeLock(1, LOG_TAG);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void acquireWakeLock() {
        PowerManager.WakeLock wakeLock = this.mPartialWakeLock;
        if (wakeLock != null) {
            synchronized (wakeLock) {
                log("acquireWakeLock");
                this.mPartialWakeLock.acquire();
            }
        }
    }

    /* access modifiers changed from: protected */
    public void releaseWakeLock() {
        PowerManager.WakeLock wakeLock = this.mPartialWakeLock;
        if (wakeLock != null) {
            synchronized (wakeLock) {
                if (this.mPartialWakeLock.isHeld()) {
                    log("releaseWakeLock");
                    this.mPartialWakeLock.release();
                }
            }
        }
    }

    private void releaseAllWakeLocks() {
        PowerManager.WakeLock wakeLock = this.mPartialWakeLock;
        if (wakeLock != null) {
            synchronized (wakeLock) {
                while (this.mPartialWakeLock.isHeld()) {
                    this.mPartialWakeLock.release();
                }
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static int findNextPCharOrNonPOrNonWCharIndex(String str, int i) {
        boolean isWait = isWait(str.charAt(i));
        int i2 = i + 1;
        int length = str.length();
        int i3 = i2;
        while (i3 < length) {
            char charAt = str.charAt(i3);
            if (isWait(charAt)) {
                isWait = true;
            }
            if (!isWait(charAt) && !isPause(charAt)) {
                break;
            }
            i3++;
        }
        return (i3 >= length || i3 <= i2 || isWait || !isPause(str.charAt(i))) ? i3 : i2;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static char findPOrWCharToAppend(String str, int i, int i2) {
        char c = isPause(str.charAt(i)) ? ',' : ';';
        if (i2 > i + 1) {
            return ';';
        }
        return c;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void fetchDtmfToneDelay(GsmCdmaPhone gsmCdmaPhone) {
        PersistableBundle configForSubId = ((CarrierConfigManager) gsmCdmaPhone.getContext().getSystemService("carrier_config")).getConfigForSubId(gsmCdmaPhone.getSubId());
        if (configForSubId != null) {
            this.mDtmfToneDelay = configForSubId.getInt(gsmCdmaPhone.getDtmfToneDelayKey());
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isPhoneTypeGsm() {
        return this.mOwner.getPhone().getPhoneType() == 1;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        Rlog.d(LOG_TAG, "[GsmCdmaConn] " + str);
    }

    public int getNumberPresentation() {
        return this.mNumberPresentation;
    }

    public UUSInfo getUUSInfo() {
        return this.mUusInfo;
    }

    public int getPreciseDisconnectCause() {
        return this.mPreciseCause;
    }

    public String getVendorDisconnectCause() {
        return this.mVendorCause;
    }

    public void migrateFrom(Connection connection) {
        if (connection != null) {
            super.migrateFrom(connection);
            this.mUusInfo = connection.getUUSInfo();
            setUserData(connection.getUserData());
        }
    }

    public Connection getOrigConnection() {
        return this.mOrigConnection;
    }

    public boolean isMultiparty() {
        Connection connection = this.mOrigConnection;
        if (connection != null) {
            return connection.isMultiparty();
        }
        return false;
    }

    public EmergencyNumberTracker getEmergencyNumberTracker() {
        GsmCdmaPhone phone;
        GsmCdmaCallTracker gsmCdmaCallTracker = this.mOwner;
        if (gsmCdmaCallTracker == null || (phone = gsmCdmaCallTracker.getPhone()) == null) {
            return null;
        }
        return phone.getEmergencyNumberTracker();
    }

    public boolean isOtaspCall() {
        String str = this.mAddress;
        return str != null && OTASP_NUMBER.equals(str);
    }

    /* access modifiers changed from: protected */
    public void onConnectedOut() {
        processNextPostDialChar();
    }
}
