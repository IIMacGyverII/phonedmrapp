package com.android.internal.telephony.imsphone;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.os.PersistableBundle;
import android.os.PowerManager;
import android.os.SystemClock;
import android.telecom.Connection;
import android.telecom.VideoProfile;
import android.telephony.CarrierConfigManager;
import android.telephony.PhoneNumberUtils;
import android.telephony.ServiceState;
import android.telephony.ims.AudioCodecAttributes;
import android.telephony.ims.ImsCallProfile;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.ImsStreamMediaProfile;
import android.telephony.ims.RtpHeaderExtension;
import android.telephony.ims.RtpHeaderExtensionType;
import com.android.ims.ImsCall;
import com.android.ims.ImsException;
import com.android.ims.internal.ImsVideoCallProviderWrapper;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CallStateException;
import com.android.internal.telephony.Connection;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.UUSInfo;
import com.android.internal.telephony.emergency.EmergencyNumberTracker;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Objects;
import java.util.Set;

public class ImsPhoneConnection extends Connection implements ImsVideoCallProviderWrapper.ImsVideoProviderWrapperCallback {
    private static final boolean DBG = true;
    private static final int EVENT_DTMF_DELAY_DONE = 5;
    private static final int EVENT_DTMF_DONE = 1;
    private static final int EVENT_NEXT_POST_DIAL = 3;
    private static final int EVENT_PAUSE_DONE = 2;
    private static final int EVENT_WAKE_LOCK_TIMEOUT = 4;
    private static final String LOG_TAG = "ImsPhoneConnection";
    @VisibleForTesting
    static final int PAUSE_DELAY_MILLIS = 3000;
    private static final int WAKE_LOCK_TIMEOUT_MILLIS = 60000;
    private long mConferenceConnectTime = 0;
    private long mDisconnectTime;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mDisconnected;
    /* access modifiers changed from: private */
    public int mDtmfToneDelay = 0;
    private Bundle mExtras = new Bundle();
    /* access modifiers changed from: private */
    public Handler mHandler;
    private final Messenger mHandlerMessenger;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsCall mImsCall;
    private ImsReasonInfo mImsReasonInfo;
    private ImsVideoCallProviderWrapper mImsVideoCallProviderWrapper;
    private boolean mIsEmergency = false;
    private boolean mIsLocalVideoCapable = true;
    private boolean mIsMergeInProcess = false;
    private boolean mIsRttEnabledForCall = false;
    private boolean mIsWpsCall = false;
    private TelephonyMetrics mMetrics = TelephonyMetrics.getInstance();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsPhoneCallTracker mOwner;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsPhoneCall mParent;
    private PowerManager.WakeLock mPartialWakeLock;
    private int mPreciseDisconnectCause = 0;
    public ImsRttTextHandler mRttTextHandler;
    public Connection.RttTextStream mRttTextStream;
    private boolean mShouldIgnoreVideoStateChanges = false;
    private UUSInfo mUusInfo;

    public static int toTelecomVerificationStatus(int i) {
        int i2 = 1;
        if (i != 1) {
            i2 = 2;
            if (i != 2) {
                return 0;
            }
        }
        return i2;
    }

    /* access modifiers changed from: protected */
    public boolean allowedUpdateMOAddress() {
        return false;
    }

    /* access modifiers changed from: protected */
    public int applyVideoRingtoneCapabilities(ImsCallProfile imsCallProfile, int i) {
        return i;
    }

    public void dispose() {
    }

    public com.android.internal.telephony.Connection getOrigConnection() {
        return null;
    }

    public String getVendorDisconnectCause() {
        return null;
    }

    /* access modifiers changed from: protected */
    public boolean skipSwitchingCallToForeground() {
        return false;
    }

    /* access modifiers changed from: protected */
    public void switchCallToBackgroundIfNecessary() {
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
                        ImsPhoneConnection.this.releaseWakeLock();
                        return;
                    } else if (i != 5) {
                        return;
                    }
                }
                ImsPhoneConnection.this.processNextPostDialChar();
                return;
            }
            ImsPhoneConnection.this.mHandler.sendMessageDelayed(ImsPhoneConnection.this.mHandler.obtainMessage(5), (long) ImsPhoneConnection.this.mDtmfToneDelay);
        }
    }

    public ImsPhoneConnection(Phone phone, ImsCall imsCall, ImsPhoneCallTracker imsPhoneCallTracker, ImsPhoneCall imsPhoneCall, boolean z) {
        super(5);
        createWakeLock(phone.getContext());
        acquireWakeLock();
        this.mOwner = imsPhoneCallTracker;
        this.mHandler = new MyHandler(this.mOwner.getLooper());
        this.mHandlerMessenger = new Messenger(this.mHandler);
        this.mImsCall = imsCall;
        this.mIsAdhocConference = isMultiparty();
        if (imsCall == null || imsCall.getCallProfile() == null) {
            this.mNumberPresentation = 3;
            this.mCnapNamePresentation = 3;
        } else {
            this.mAddress = imsCall.getCallProfile().getCallExtra("oi");
            this.mCnapName = imsCall.getCallProfile().getCallExtra("cna");
            this.mNumberPresentation = ImsCallProfile.OIRToPresentation(imsCall.getCallProfile().getCallExtraInt("oir"));
            this.mCnapNamePresentation = ImsCallProfile.OIRToPresentation(imsCall.getCallProfile().getCallExtraInt("cnap"));
            setNumberVerificationStatus(toTelecomVerificationStatus(imsCall.getCallProfile().getCallerNumberVerificationStatus()));
            updateMediaCapabilities(imsCall);
        }
        this.mIsIncoming = !z;
        this.mCreateTime = System.currentTimeMillis();
        this.mUusInfo = null;
        updateExtras(imsCall);
        this.mParent = imsPhoneCall;
        imsPhoneCall.attach(this, this.mIsIncoming ? Call.State.INCOMING : Call.State.DIALING);
        fetchDtmfToneDelay(phone);
        if (phone.getContext().getResources().getBoolean(17891827)) {
            setAudioModeIsVoip(true);
        }
    }

    public ImsPhoneConnection(Phone phone, String str, ImsPhoneCallTracker imsPhoneCallTracker, ImsPhoneCall imsPhoneCall, boolean z, boolean z2) {
        super(5);
        createWakeLock(phone.getContext());
        acquireWakeLock();
        this.mOwner = imsPhoneCallTracker;
        this.mHandler = new MyHandler(this.mOwner.getLooper());
        this.mHandlerMessenger = new Messenger(this.mHandler);
        this.mDialString = str;
        this.mAddress = PhoneNumberUtils.extractNetworkPortionAlt(str);
        this.mPostDialString = PhoneNumberUtils.extractPostDialPortion(str);
        this.mIsIncoming = false;
        this.mCnapName = null;
        this.mCnapNamePresentation = 1;
        this.mNumberPresentation = 1;
        this.mCreateTime = System.currentTimeMillis();
        this.mParent = imsPhoneCall;
        imsPhoneCall.attachFake(this, Call.State.DIALING);
        this.mIsEmergency = z;
        if (z) {
            setEmergencyCallInfo(this.mOwner);
        }
        this.mIsWpsCall = z2;
        fetchDtmfToneDelay(phone);
        if (phone.getContext().getResources().getBoolean(17891827)) {
            setAudioModeIsVoip(true);
        }
    }

    public ImsPhoneConnection(Phone phone, String[] strArr, ImsPhoneCallTracker imsPhoneCallTracker, ImsPhoneCall imsPhoneCall, boolean z) {
        super(5);
        createWakeLock(phone.getContext());
        acquireWakeLock();
        this.mOwner = imsPhoneCallTracker;
        this.mHandler = new MyHandler(this.mOwner.getLooper());
        this.mHandlerMessenger = new Messenger(this.mHandler);
        this.mAddress = com.android.internal.telephony.Connection.ADHOC_CONFERENCE_ADDRESS;
        this.mDialString = com.android.internal.telephony.Connection.ADHOC_CONFERENCE_ADDRESS;
        this.mParticipantsToDial = strArr;
        this.mIsAdhocConference = true;
        this.mIsIncoming = false;
        this.mCnapName = null;
        this.mCnapNamePresentation = 1;
        this.mNumberPresentation = 1;
        this.mCreateTime = System.currentTimeMillis();
        this.mParent = imsPhoneCall;
        imsPhoneCall.attachFake(this, Call.State.DIALING);
        if (phone.getContext().getResources().getBoolean(17891827)) {
            setAudioModeIsVoip(true);
        }
    }

    @VisibleForTesting
    public void setTelephonyMetrics(TelephonyMetrics telephonyMetrics) {
        this.mMetrics = telephonyMetrics;
    }

    protected static boolean equalsHandlesNulls(Object obj, Object obj2) {
        if (obj == null) {
            return obj2 == null;
        }
        return obj.equals(obj2);
    }

    protected static boolean equalsBaseDialString(String str, String str2) {
        if (str == null) {
            if (str2 == null) {
                return true;
            }
        } else if (str2 != null && str.startsWith(str2)) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: protected */
    public int applyLocalCallCapabilities(ImsCallProfile imsCallProfile, int i) {
        Rlog.i(LOG_TAG, "applyLocalCallCapabilities - localProfile = " + imsCallProfile);
        int removeCapability = com.android.internal.telephony.Connection.removeCapability(i, 4);
        if (!this.mIsLocalVideoCapable) {
            Rlog.i(LOG_TAG, "applyLocalCallCapabilities - disabling video (overidden)");
            return removeCapability;
        }
        int i2 = imsCallProfile.mCallType;
        return (i2 == 3 || i2 == 4) ? com.android.internal.telephony.Connection.addCapability(removeCapability, 4) : removeCapability;
    }

    private static int applyRemoteCallCapabilities(ImsCallProfile imsCallProfile, int i) {
        Rlog.w(LOG_TAG, "applyRemoteCallCapabilities - remoteProfile = " + imsCallProfile);
        int removeCapability = com.android.internal.telephony.Connection.removeCapability(com.android.internal.telephony.Connection.removeCapability(i, 8), 64);
        int i2 = imsCallProfile.mCallType;
        if (i2 == 3 || i2 == 4) {
            removeCapability = com.android.internal.telephony.Connection.addCapability(removeCapability, 8);
        }
        return imsCallProfile.getMediaProfile().getRttMode() == 1 ? com.android.internal.telephony.Connection.addCapability(removeCapability, 64) : removeCapability;
    }

    public String getOrigDialString() {
        return this.mDialString;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCall getCall() {
        return this.mParent;
    }

    public long getDisconnectTime() {
        return this.mDisconnectTime;
    }

    public long getHoldingStartTime() {
        return this.mHoldingStartTime;
    }

    public long getHoldDurationMillis() {
        if (getState() != Call.State.HOLDING) {
            return 0;
        }
        return SystemClock.elapsedRealtime() - this.mHoldingStartTime;
    }

    public void setDisconnectCause(int i) {
        Rlog.d(LOG_TAG, "setDisconnectCause: cause=" + i);
        this.mCause = i;
    }

    public int getDisconnectCause() {
        Rlog.d(LOG_TAG, "getDisconnectCause: cause=" + this.mCause);
        return this.mCause;
    }

    public boolean isIncomingCallAutoRejected() {
        return this.mCause == 81;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCallTracker getOwner() {
        return this.mOwner;
    }

    public Call.State getState() {
        if (this.mDisconnected) {
            return Call.State.DISCONNECTED;
        }
        return super.getState();
    }

    public void deflect(String str) throws CallStateException {
        if (this.mParent.getState().isRinging()) {
            try {
                ImsCall imsCall = this.mImsCall;
                if (imsCall != null) {
                    imsCall.deflect(str);
                    return;
                }
                throw new CallStateException("no valid ims call to deflect");
            } catch (ImsException unused) {
                throw new CallStateException("cannot deflect call");
            }
        } else {
            throw new CallStateException("phone not ringing");
        }
    }

    public void transfer(String str, boolean z) throws CallStateException {
        try {
            ImsCall imsCall = this.mImsCall;
            if (imsCall != null) {
                imsCall.transfer(str, z);
                return;
            }
            throw new CallStateException("no valid ims call to transfer");
        } catch (ImsException unused) {
            throw new CallStateException("cannot transfer call");
        }
    }

    public void consultativeTransfer(com.android.internal.telephony.Connection connection) throws CallStateException {
        try {
            ImsCall imsCall = this.mImsCall;
            if (imsCall != null) {
                imsCall.consultativeTransfer(((ImsPhoneConnection) connection).getImsCall());
                return;
            }
            throw new CallStateException("no valid ims call to transfer");
        } catch (ImsException unused) {
            throw new CallStateException("cannot transfer call");
        }
    }

    public void hangup() throws CallStateException {
        if (!this.mDisconnected) {
            this.mOwner.hangup(this);
            return;
        }
        throw new CallStateException("disconnected");
    }

    public void separate() throws CallStateException {
        throw new CallStateException("not supported");
    }

    public void proceedAfterWaitChar() {
        if (this.mPostDialState != Connection.PostDialState.WAIT) {
            Rlog.w(LOG_TAG, "ImsPhoneConnection.proceedAfterWaitChar(): Expected getPostDialState() to be WAIT but was " + this.mPostDialState);
            return;
        }
        setPostDialState(Connection.PostDialState.STARTED);
        processNextPostDialChar();
    }

    public void proceedAfterWildChar(String str) {
        if (this.mPostDialState != Connection.PostDialState.WILD) {
            Rlog.w(LOG_TAG, "ImsPhoneConnection.proceedAfterWaitChar(): Expected getPostDialState() to be WILD but was " + this.mPostDialState);
            return;
        }
        setPostDialState(Connection.PostDialState.STARTED);
        this.mPostDialString = str + this.mPostDialString.substring(this.mNextPostDialChar);
        this.mNextPostDialChar = 0;
        Rlog.d(LOG_TAG, "proceedAfterWildChar: new postDialString is " + this.mPostDialString);
        processNextPostDialChar();
    }

    public void cancelPostDial() {
        setPostDialState(Connection.PostDialState.CANCELLED);
    }

    public void onHangupLocal() {
        this.mCause = 3;
    }

    public boolean onDisconnect(int i) {
        Rlog.d(LOG_TAG, "onDisconnect: cause=" + i);
        if (this.mCause != 3 || i == 16) {
            this.mCause = i;
        }
        return onDisconnect();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean onDisconnect() {
        boolean z = false;
        if (!this.mDisconnected) {
            this.mDisconnectTime = System.currentTimeMillis();
            this.mDuration = SystemClock.elapsedRealtime() - this.mConnectTimeReal;
            this.mDisconnected = true;
            this.mOwner.mPhone.notifyDisconnect(this);
            notifyDisconnect(this.mCause);
            ImsPhoneCall imsPhoneCall = this.mParent;
            if (imsPhoneCall != null) {
                z = imsPhoneCall.connectionDisconnected(this);
            } else {
                Rlog.d(LOG_TAG, "onDisconnect: no parent");
            }
            synchronized (this) {
                ImsRttTextHandler imsRttTextHandler = this.mRttTextHandler;
                if (imsRttTextHandler != null) {
                    imsRttTextHandler.tearDown();
                }
                ImsCall imsCall = this.mImsCall;
                if (imsCall != null) {
                    imsCall.close();
                }
                this.mImsCall = null;
                ImsVideoCallProviderWrapper imsVideoCallProviderWrapper = this.mImsVideoCallProviderWrapper;
                if (imsVideoCallProviderWrapper != null) {
                    imsVideoCallProviderWrapper.tearDown();
                }
            }
        }
        releaseWakeLock();
        return z;
    }

    /* access modifiers changed from: package-private */
    public void onConnectedInOrOut() {
        this.mConnectTime = System.currentTimeMillis();
        this.mConnectTimeReal = SystemClock.elapsedRealtime();
        this.mDuration = 0;
        Rlog.d(LOG_TAG, "onConnectedInOrOut: connectTime=" + this.mConnectTime);
        if (!this.mIsIncoming) {
            processNextPostDialChar();
        }
        releaseWakeLock();
    }

    /* access modifiers changed from: protected */
    public void onStartedHolding() {
        this.mHoldingStartTime = SystemClock.elapsedRealtime();
    }

    private boolean processPostDialChar(char c) {
        if (PhoneNumberUtils.is12Key(c)) {
            Message obtainMessage = this.mHandler.obtainMessage(1);
            obtainMessage.replyTo = this.mHandlerMessenger;
            this.mOwner.sendDtmf(c, obtainMessage);
        } else if (c == ',') {
            Handler handler = this.mHandler;
            handler.sendMessageDelayed(handler.obtainMessage(2), 3000);
        } else if (c == ';') {
            setPostDialState(Connection.PostDialState.WAIT);
        } else if (c != 'N') {
            return false;
        } else {
            setPostDialState(Connection.PostDialState.WILD);
        }
        return true;
    }

    public void finalize() {
        releaseWakeLock();
    }

    /* access modifiers changed from: private */
    public void processNextPostDialChar() {
        char c;
        Message messageForRegistrant;
        if (this.mPostDialState != Connection.PostDialState.CANCELLED) {
            String str = this.mPostDialString;
            if (str == null || str.length() <= this.mNextPostDialChar) {
                setPostDialState(Connection.PostDialState.COMPLETE);
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
            Registrant postDialHandler = this.mOwner.mPhone.getPostDialHandler();
            if (postDialHandler != null && (messageForRegistrant = postDialHandler.messageForRegistrant()) != null) {
                Connection.PostDialState postDialState = this.mPostDialState;
                AsyncResult forMessage = AsyncResult.forMessage(messageForRegistrant);
                forMessage.result = this;
                forMessage.userObj = postDialState;
                messageForRegistrant.arg1 = c;
                messageForRegistrant.sendToTarget();
            }
        }
    }

    private void setPostDialState(Connection.PostDialState postDialState) {
        Connection.PostDialState postDialState2 = this.mPostDialState;
        Connection.PostDialState postDialState3 = Connection.PostDialState.STARTED;
        if (postDialState2 != postDialState3 && postDialState == postDialState3) {
            acquireWakeLock();
            this.mHandler.sendMessageDelayed(this.mHandler.obtainMessage(4), 60000);
        } else if (postDialState2 == postDialState3 && postDialState != postDialState3) {
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
        Rlog.d(LOG_TAG, "acquireWakeLock");
        this.mPartialWakeLock.acquire();
    }

    public void releaseWakeLock() {
        PowerManager.WakeLock wakeLock = this.mPartialWakeLock;
        if (wakeLock != null) {
            synchronized (wakeLock) {
                if (this.mPartialWakeLock.isHeld()) {
                    Rlog.d(LOG_TAG, "releaseWakeLock");
                    this.mPartialWakeLock.release();
                }
            }
        }
    }

    private void fetchDtmfToneDelay(Phone phone) {
        PersistableBundle configForSubId = ((CarrierConfigManager) phone.getContext().getSystemService("carrier_config")).getConfigForSubId(phone.getSubId());
        if (configForSubId != null) {
            this.mDtmfToneDelay = configForSubId.getInt("ims_dtmf_tone_delay_int");
        }
    }

    public int getNumberPresentation() {
        return this.mNumberPresentation;
    }

    public UUSInfo getUUSInfo() {
        return this.mUusInfo;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public synchronized boolean isMultiparty() {
        ImsCall imsCall;
        imsCall = this.mImsCall;
        return imsCall != null && imsCall.isMultiparty();
    }

    public synchronized boolean isConferenceHost() {
        ImsCall imsCall;
        imsCall = this.mImsCall;
        return imsCall != null && imsCall.isConferenceHost();
    }

    public boolean isMemberOfPeerConference() {
        return !isConferenceHost();
    }

    public synchronized ImsCall getImsCall() {
        return this.mImsCall;
    }

    public synchronized void setImsCall(ImsCall imsCall) {
        this.mImsCall = imsCall;
    }

    public void changeParent(ImsPhoneCall imsPhoneCall) {
        this.mParent = imsPhoneCall;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean update(ImsCall imsCall, Call.State state) {
        if (state == Call.State.ACTIVE) {
            if (imsCall.isPendingHold()) {
                Rlog.w(LOG_TAG, "update : state is ACTIVE, but call is pending hold, skipping");
                return false;
            }
            if (this.mParent.getState().isRinging() || this.mParent.getState().isDialing()) {
                onConnectedInOrOut();
            }
            if ((this.mParent.getState().isRinging() || this.mParent == this.mOwner.mBackgroundCall) && !skipSwitchingCallToForeground()) {
                this.mParent.detach(this);
                ImsPhoneCall imsPhoneCall = this.mOwner.mForegroundCall;
                this.mParent = imsPhoneCall;
                imsPhoneCall.attach(this);
            }
        } else if (state == Call.State.HOLDING) {
            switchCallToBackgroundIfNecessary();
            onStartedHolding();
        }
        boolean update = this.mParent.update(this, imsCall, state);
        boolean updateAddressDisplay = updateAddressDisplay(imsCall);
        boolean updateMediaCapabilities = updateMediaCapabilities(imsCall);
        boolean updateExtras = updateExtras(imsCall);
        if (update || updateAddressDisplay || updateMediaCapabilities || updateExtras) {
            return true;
        }
        return false;
    }

    public void maybeChangeRingbackState() {
        Rlog.i(LOG_TAG, "maybeChangeRingbackState");
        this.mParent.maybeChangeRingbackState(this.mImsCall);
    }

    public int getPreciseDisconnectCause() {
        return this.mPreciseDisconnectCause;
    }

    public void setPreciseDisconnectCause(int i) {
        this.mPreciseDisconnectCause = i;
    }

    public void onDisconnectConferenceParticipant(Uri uri) {
        ImsCall imsCall = getImsCall();
        if (imsCall != null) {
            try {
                imsCall.removeParticipants(new String[]{uri.toString()});
            } catch (ImsException unused) {
                Rlog.e(LOG_TAG, "onDisconnectConferenceParticipant: no session in place. Failed to disconnect endpoint = " + uri);
            }
        }
    }

    public void setConferenceConnectTime(long j) {
        this.mConferenceConnectTime = j;
    }

    public long getConferenceConnectTime() {
        return this.mConferenceConnectTime;
    }

    /* JADX WARNING: Removed duplicated region for block: B:25:0x00a3  */
    /* JADX WARNING: Removed duplicated region for block: B:28:0x00aa  */
    /* JADX WARNING: Removed duplicated region for block: B:33:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean updateAddressDisplay(com.android.ims.ImsCall r9) {
        /*
            r8 = this;
            r0 = 0
            if (r9 != 0) goto L_0x0004
            return r0
        L_0x0004:
            android.telephony.ims.ImsCallProfile r9 = r9.getCallProfile()
            r1 = 1
            if (r9 == 0) goto L_0x00ad
            boolean r2 = r8.isIncoming()
            if (r2 != 0) goto L_0x0017
            boolean r2 = r8.allowedUpdateMOAddress()
            if (r2 == 0) goto L_0x00ad
        L_0x0017:
            java.lang.String r2 = "oi"
            java.lang.String r2 = r9.getCallExtra(r2)
            java.lang.String r3 = "cna"
            java.lang.String r3 = r9.getCallExtra(r3)
            int r4 = r8.callNumberPresentation(r9)
            java.lang.String r5 = "cnap"
            int r9 = r9.getCallExtraInt(r5)
            int r9 = android.telephony.ims.ImsCallProfile.OIRToPresentation(r9)
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r6 = "updateAddressDisplay: callId = "
            r5.append(r6)
            java.lang.String r6 = r8.getTelecomCallId()
            r5.append(r6)
            java.lang.String r6 = " address = "
            r5.append(r6)
            java.lang.String r6 = "ImsPhoneConnection"
            java.lang.String r7 = com.android.telephony.Rlog.pii(r6, r2)
            r5.append(r7)
            java.lang.String r7 = " name = "
            r5.append(r7)
            java.lang.String r7 = com.android.telephony.Rlog.pii(r6, r3)
            r5.append(r7)
            java.lang.String r7 = " nump = "
            r5.append(r7)
            r5.append(r4)
            java.lang.String r7 = " namep = "
            r5.append(r7)
            r5.append(r9)
            java.lang.String r5 = r5.toString()
            com.android.telephony.Rlog.d(r6, r5)
            boolean r5 = r8.mIsMergeInProcess
            if (r5 != 0) goto L_0x00ad
            boolean r5 = r8.needUpdateAddress(r2)
            if (r5 == 0) goto L_0x0081
            r8.mAddress = r2
            r0 = r1
        L_0x0081:
            boolean r2 = android.text.TextUtils.isEmpty(r3)
            if (r2 == 0) goto L_0x0094
            java.lang.String r2 = r8.mCnapName
            boolean r2 = android.text.TextUtils.isEmpty(r2)
            if (r2 != 0) goto L_0x009f
            java.lang.String r0 = ""
            r8.mCnapName = r0
            goto L_0x009e
        L_0x0094:
            java.lang.String r2 = r8.mCnapName
            boolean r2 = r3.equals(r2)
            if (r2 != 0) goto L_0x009f
            r8.mCnapName = r3
        L_0x009e:
            r0 = r1
        L_0x009f:
            int r2 = r8.mNumberPresentation
            if (r2 == r4) goto L_0x00a6
            r8.mNumberPresentation = r4
            r0 = r1
        L_0x00a6:
            int r2 = r8.mCnapNamePresentation
            if (r2 == r9) goto L_0x00ad
            r8.mCnapNamePresentation = r9
            r0 = r1
        L_0x00ad:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneConnection.updateAddressDisplay(com.android.ims.ImsCall):boolean");
    }

    public boolean updateMediaCapabilities(ImsCall imsCall) {
        boolean z;
        int i;
        boolean z2;
        int i2;
        boolean z3 = false;
        if (imsCall == null) {
            return false;
        }
        try {
            ImsCallProfile callProfile = imsCall.getCallProfile();
            if (callProfile != null) {
                int videoState = getVideoState();
                int videoStateFromImsCallProfile = ImsCallProfile.getVideoStateFromImsCallProfile(callProfile);
                if (videoState != videoStateFromImsCallProfile) {
                    if (VideoProfile.isPaused(videoState) && !VideoProfile.isPaused(videoStateFromImsCallProfile)) {
                        this.mShouldIgnoreVideoStateChanges = false;
                    }
                    if (!this.mShouldIgnoreVideoStateChanges) {
                        updateVideoState(videoStateFromImsCallProfile);
                        z = true;
                    } else {
                        Rlog.d(LOG_TAG, "updateMediaCapabilities - ignoring video state change due to paused state.");
                        z = false;
                    }
                    try {
                        if (!VideoProfile.isPaused(videoState) && VideoProfile.isPaused(videoStateFromImsCallProfile)) {
                            this.mShouldIgnoreVideoStateChanges = true;
                        }
                    } catch (ImsException unused) {
                        z3 = z;
                    }
                } else {
                    z = false;
                }
                ImsStreamMediaProfile imsStreamMediaProfile = callProfile.mMediaProfile;
                if (imsStreamMediaProfile != null) {
                    boolean isRttCall = imsStreamMediaProfile.isRttCall();
                    this.mIsRttEnabledForCall = isRttCall;
                    if (isRttCall && this.mRttTextHandler == null) {
                        Rlog.d(LOG_TAG, "updateMediaCapabilities -- turning RTT on, profile=" + callProfile);
                        startRttTextProcessing();
                        onRttInitiated();
                        try {
                            this.mOwner.getPhone().getVoiceCallSessionStats().onRttStarted(this);
                        } catch (ImsException unused2) {
                            z3 = true;
                        }
                    } else if (!isRttCall) {
                        if (this.mRttTextHandler != null) {
                            Rlog.d(LOG_TAG, "updateMediaCapabilities -- turning RTT off, profile=" + callProfile);
                            this.mRttTextHandler.tearDown();
                            this.mRttTextHandler = null;
                            this.mRttTextStream = null;
                            onRttTerminated();
                        }
                    }
                    z = true;
                }
            } else {
                z = false;
            }
            int connectionCapabilities = getConnectionCapabilities();
            if (this.mOwner.isCarrierDowngradeOfVtCallSupported()) {
                i = com.android.internal.telephony.Connection.addCapability(connectionCapabilities, 3);
            } else {
                i = com.android.internal.telephony.Connection.removeCapability(connectionCapabilities, 3);
            }
            ImsCallProfile localCallProfile = imsCall.getLocalCallProfile();
            Rlog.v(LOG_TAG, "update localCallProfile=" + localCallProfile);
            if (localCallProfile != null) {
                i = applyLocalCallCapabilities(localCallProfile, i);
            }
            ImsCallProfile remoteCallProfile = imsCall.getRemoteCallProfile();
            Rlog.v(LOG_TAG, "update remoteCallProfile=" + remoteCallProfile);
            if (remoteCallProfile != null) {
                i = applyVideoRingtoneCapabilities(remoteCallProfile, applyRemoteCallCapabilities(remoteCallProfile, i));
            }
            if (getConnectionCapabilities() != i) {
                setConnectionCapabilities(i);
                z = true;
            }
            if (!this.mOwner.isViLteDataMetered()) {
                Rlog.v(LOG_TAG, "data is not metered");
            } else {
                ImsVideoCallProviderWrapper imsVideoCallProviderWrapper = this.mImsVideoCallProviderWrapper;
                if (imsVideoCallProviderWrapper != null) {
                    imsVideoCallProviderWrapper.setIsVideoEnabled(hasCapabilities(4));
                }
            }
            if (localCallProfile == null || (i2 = localCallProfile.mMediaProfile.mAudioQuality) == this.mAudioCodec) {
                z2 = false;
                z3 = z;
            } else {
                this.mAudioCodec = i2;
                this.mMetrics.writeAudioCodecIms(this.mOwner.mPhone.getPhoneId(), imsCall.getCallSession());
                this.mOwner.getPhone().getVoiceCallSessionStats().onAudioCodecChanged(this, this.mAudioCodec);
                z2 = true;
                z3 = true;
            }
            if (localCallProfile != null) {
                if (localCallProfile.mMediaProfile.getAudioCodecAttributes() != null) {
                    AudioCodecAttributes audioCodecAttributes = localCallProfile.mMediaProfile.getAudioCodecAttributes();
                    if (Math.abs(this.mAudioCodecBitrateKbps - ((Float) audioCodecAttributes.getBitrateRangeKbps().getUpper()).floatValue()) > 0.01f) {
                        this.mAudioCodecBitrateKbps = ((Float) audioCodecAttributes.getBitrateRangeKbps().getUpper()).floatValue();
                        z2 = true;
                        z3 = true;
                    }
                    if (Math.abs(this.mAudioCodecBandwidthKhz - ((Float) audioCodecAttributes.getBandwidthRangeKhz().getUpper()).floatValue()) > 0.01f) {
                        this.mAudioCodecBandwidthKhz = ((Float) audioCodecAttributes.getBandwidthRangeKhz().getUpper()).floatValue();
                        z2 = true;
                        z3 = true;
                    }
                }
            }
            if (z2) {
                Rlog.i(LOG_TAG, "updateMediaCapabilities: mediate attributes changed: codec = " + this.mAudioCodec + ", bitRate=" + this.mAudioCodecBitrateKbps + ", bandwidth=" + this.mAudioCodecBandwidthKhz);
                notifyMediaAttributesChanged();
            }
            int audioQualityFromCallProfile = getAudioQualityFromCallProfile(localCallProfile, remoteCallProfile);
            if (getAudioQuality() != audioQualityFromCallProfile) {
                setAudioQuality(audioQualityFromCallProfile);
                return true;
            }
        } catch (ImsException unused3) {
        }
        return z3;
    }

    private void updateVideoState(int i) {
        ImsVideoCallProviderWrapper imsVideoCallProviderWrapper = this.mImsVideoCallProviderWrapper;
        if (imsVideoCallProviderWrapper != null) {
            imsVideoCallProviderWrapper.onVideoStateChanged(i);
        }
        setVideoState(i);
        this.mOwner.getPhone().getVoiceCallSessionStats().onVideoStateChange(this, i);
    }

    public void startRtt(Connection.RttTextStream rttTextStream) {
        if (getImsCall() != null) {
            getImsCall().sendRttModifyRequest(true);
            setCurrentRttTextStream(rttTextStream);
        }
    }

    public void stopRtt() {
        getImsCall().sendRttModifyRequest(false);
    }

    public void sendRttModifyResponse(Connection.RttTextStream rttTextStream) {
        boolean z = rttTextStream != null;
        ImsCall imsCall = getImsCall();
        if (imsCall != null) {
            imsCall.sendRttModifyResponse(z);
            if (z) {
                setCurrentRttTextStream(rttTextStream);
            } else {
                Rlog.e(LOG_TAG, "sendRttModifyResponse: foreground call has no connections");
            }
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x001d, code lost:
        r2.mRttTextHandler.sendToInCall(r3);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:12:0x0022, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onRttMessageReceived(java.lang.String r3) {
        /*
            r2 = this;
            monitor-enter(r2)
            com.android.internal.telephony.imsphone.ImsRttTextHandler r0 = r2.mRttTextHandler     // Catch:{ all -> 0x0023 }
            if (r0 != 0) goto L_0x001c
            java.lang.String r0 = "ImsPhoneConnection"
            java.lang.String r1 = "onRttMessageReceived: RTT text handler not available. Attempting to create one."
            com.android.telephony.Rlog.w(r0, r1)     // Catch:{ all -> 0x0023 }
            android.telecom.Connection$RttTextStream r0 = r2.mRttTextStream     // Catch:{ all -> 0x0023 }
            if (r0 != 0) goto L_0x0019
            java.lang.String r3 = "ImsPhoneConnection"
            java.lang.String r0 = "onRttMessageReceived: Unable to process incoming message. No textstream available"
            com.android.telephony.Rlog.e(r3, r0)     // Catch:{ all -> 0x0023 }
            monitor-exit(r2)     // Catch:{ all -> 0x0023 }
            return
        L_0x0019:
            r2.createRttTextHandler()     // Catch:{ all -> 0x0023 }
        L_0x001c:
            monitor-exit(r2)     // Catch:{ all -> 0x0023 }
            com.android.internal.telephony.imsphone.ImsRttTextHandler r2 = r2.mRttTextHandler
            r2.sendToInCall(r3)
            return
        L_0x0023:
            r3 = move-exception
            monitor-exit(r2)     // Catch:{ all -> 0x0023 }
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneConnection.onRttMessageReceived(java.lang.String):void");
    }

    public void onRttAudioIndicatorChanged(ImsStreamMediaProfile imsStreamMediaProfile) {
        Bundle bundle = new Bundle();
        bundle.putBoolean("android.telecom.extra.IS_RTT_AUDIO_PRESENT", imsStreamMediaProfile.isReceivingRttAudio());
        onConnectionEvent("android.telecom.event.RTT_AUDIO_INDICATION_CHANGED", bundle);
    }

    public void setCurrentRttTextStream(Connection.RttTextStream rttTextStream) {
        synchronized (this) {
            this.mRttTextStream = rttTextStream;
            if (this.mRttTextHandler == null && this.mIsRttEnabledForCall) {
                Rlog.i(LOG_TAG, "setCurrentRttTextStream: Creating a text handler");
                createRttTextHandler();
            }
        }
    }

    public EmergencyNumberTracker getEmergencyNumberTracker() {
        ImsPhone phone;
        ImsPhoneCallTracker imsPhoneCallTracker = this.mOwner;
        if (imsPhoneCallTracker == null || (phone = imsPhoneCallTracker.getPhone()) == null) {
            return null;
        }
        return phone.getEmergencyNumberTracker();
    }

    public boolean hasRttTextStream() {
        return this.mRttTextStream != null;
    }

    public boolean isRttEnabledForCall() {
        return this.mIsRttEnabledForCall;
    }

    public void startRttTextProcessing() {
        synchronized (this) {
            if (this.mRttTextStream == null) {
                Rlog.w(LOG_TAG, "startRttTextProcessing: no RTT text stream. Ignoring.");
            } else if (this.mRttTextHandler != null) {
                Rlog.w(LOG_TAG, "startRttTextProcessing: RTT text handler already exists");
            } else {
                createRttTextHandler();
            }
        }
    }

    private void createRttTextHandler() {
        ImsRttTextHandler imsRttTextHandler = new ImsRttTextHandler(Looper.getMainLooper(), new ImsPhoneConnection$$ExternalSyntheticLambda0(this));
        this.mRttTextHandler = imsRttTextHandler;
        imsRttTextHandler.initialize(this.mRttTextStream);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$createRttTextHandler$0(String str) {
        ImsCall imsCall = getImsCall();
        if (imsCall != null) {
            imsCall.sendRttMessage(str);
        }
    }

    private void updateImsCallRatFromExtras(Bundle bundle) {
        if (bundle != null) {
            if (bundle.containsKey("android.telephony.ims.extra.CALL_NETWORK_TYPE") || bundle.containsKey("CallRadioTech") || bundle.containsKey("callRadioTech")) {
                ImsCall imsCall = getImsCall();
                int i = 0;
                if (imsCall != null) {
                    i = imsCall.getNetworkType();
                }
                setCallRadioTech(ServiceState.networkTypeToRilRadioTechnology(i));
            }
        }
    }

    private void updateEmergencyCallFromExtras(Bundle bundle) {
        if (bundle != null && bundle.getBoolean("e_call")) {
            setIsNetworkIdentifiedEmergencyCall(true);
        }
    }

    private void updateForwardedNumberFromExtras(Bundle bundle) {
        String[] stringArray;
        if (bundle != null && bundle.containsKey("android.telephony.ims.extra.FORWARDED_NUMBER") && (stringArray = bundle.getStringArray("android.telephony.ims.extra.FORWARDED_NUMBER")) != null) {
            this.mForwardedNumber = new ArrayList<>(Arrays.asList(stringArray));
        }
    }

    /* access modifiers changed from: protected */
    public boolean updateExtras(ImsCall imsCall) {
        if (imsCall == null) {
            return false;
        }
        ImsCallProfile callProfile = imsCall.getCallProfile();
        Bundle bundle = callProfile != null ? callProfile.mCallExtras : null;
        if (bundle == null) {
            Rlog.d(LOG_TAG, "Call profile extras are null.");
        }
        boolean z = !areBundlesEqual(bundle, this.mExtras);
        if (z) {
            updateImsCallRatFromExtras(bundle);
            updateEmergencyCallFromExtras(bundle);
            updateForwardedNumberFromExtras(bundle);
            synchronized (this.mExtras) {
                this.mExtras.clear();
                if (bundle != null) {
                    this.mExtras.putAll(bundle);
                }
            }
            setConnectionExtras(this.mExtras);
        }
        return z;
    }

    private static boolean areBundlesEqual(Bundle bundle, Bundle bundle2) {
        if (bundle == null || bundle2 == null) {
            if (bundle == bundle2) {
                return true;
            }
            return false;
        } else if (bundle.size() != bundle2.size()) {
            return false;
        } else {
            for (String str : bundle.keySet()) {
                if (str != null && !Objects.equals(bundle.get(str), bundle2.get(str))) {
                    return false;
                }
            }
            return true;
        }
    }

    private int getAudioQualityFromCallProfile(ImsCallProfile imsCallProfile, ImsCallProfile imsCallProfile2) {
        ImsStreamMediaProfile imsStreamMediaProfile;
        if (imsCallProfile == null || imsCallProfile2 == null || (imsStreamMediaProfile = imsCallProfile.mMediaProfile) == null) {
            return 1;
        }
        int i = imsStreamMediaProfile.mAudioQuality;
        boolean z = false;
        boolean z2 = i == 18 || i == 19 || i == 20;
        if ((i == 2 || i == 6 || z2) && imsCallProfile2.getRestrictCause() == 0) {
            z = true;
        }
        if (z) {
            return 2;
        }
        return 1;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("[ImsPhoneConnection objId: ");
        sb.append(System.identityHashCode(this));
        sb.append(" telecomCallID: ");
        sb.append(getTelecomCallId());
        sb.append(" address: ");
        sb.append(Rlog.pii(LOG_TAG, getAddress()));
        sb.append(" isAdhocConf: ");
        sb.append(isAdhocConference() ? "Y" : "N");
        sb.append(" ImsCall: ");
        synchronized (this) {
            ImsCall imsCall = this.mImsCall;
            if (imsCall == null) {
                sb.append("null");
            } else {
                sb.append(imsCall);
            }
        }
        sb.append("]");
        return sb.toString();
    }

    public void setVideoProvider(Connection.VideoProvider videoProvider) {
        super.setVideoProvider(videoProvider);
        if (videoProvider instanceof ImsVideoCallProviderWrapper) {
            this.mImsVideoCallProviderWrapper = (ImsVideoCallProviderWrapper) videoProvider;
        }
    }

    public boolean isEmergency() {
        return this.mIsEmergency;
    }

    /* access modifiers changed from: protected */
    public boolean isWpsCall() {
        return this.mIsWpsCall;
    }

    public boolean isCrossSimCall() {
        ImsCall imsCall = this.mImsCall;
        return imsCall != null && imsCall.isCrossSimCall();
    }

    public void onReceiveSessionModifyResponse(int i, VideoProfile videoProfile, VideoProfile videoProfile2) {
        if (i == 1 && this.mShouldIgnoreVideoStateChanges) {
            int videoState = getVideoState();
            int videoState2 = videoProfile2.getVideoState();
            int i2 = (videoState ^ videoState2) & 3;
            if (i2 != 0) {
                int i3 = (videoState & (~(i2 & videoState))) | (videoState2 & i2);
                Rlog.d(LOG_TAG, "onReceiveSessionModifyResponse : received " + VideoProfile.videoStateToString(videoProfile.getVideoState()) + " / " + VideoProfile.videoStateToString(videoProfile2.getVideoState()) + " while paused ; sending new videoState = " + VideoProfile.videoStateToString(i3));
                setVideoState(i3);
            }
        }
    }

    public void pauseVideo(int i) {
        ImsVideoCallProviderWrapper imsVideoCallProviderWrapper = this.mImsVideoCallProviderWrapper;
        if (imsVideoCallProviderWrapper != null) {
            imsVideoCallProviderWrapper.pauseVideo(getVideoState(), i);
        }
    }

    public void resumeVideo(int i) {
        ImsVideoCallProviderWrapper imsVideoCallProviderWrapper = this.mImsVideoCallProviderWrapper;
        if (imsVideoCallProviderWrapper != null) {
            imsVideoCallProviderWrapper.resumeVideo(getVideoState(), i);
        }
    }

    public boolean wasVideoPausedFromSource(int i) {
        ImsVideoCallProviderWrapper imsVideoCallProviderWrapper = this.mImsVideoCallProviderWrapper;
        if (imsVideoCallProviderWrapper == null) {
            return false;
        }
        return imsVideoCallProviderWrapper.wasVideoPausedFromSource(i);
    }

    public void handleMergeStart() {
        this.mIsMergeInProcess = true;
        onConnectionEvent("android.telecom.event.MERGE_START", (Bundle) null);
    }

    public void handleMergeComplete() {
        this.mIsMergeInProcess = false;
        onConnectionEvent("android.telecom.event.MERGE_COMPLETE", (Bundle) null);
    }

    public void changeToPausedState() {
        int videoState = getVideoState() | 4;
        Rlog.i(LOG_TAG, "ImsPhoneConnection: changeToPausedState - setting paused bit; newVideoState=" + VideoProfile.videoStateToString(videoState));
        updateVideoState(videoState);
        this.mShouldIgnoreVideoStateChanges = true;
    }

    public void changeToUnPausedState() {
        int videoState = getVideoState() & -5;
        Rlog.i(LOG_TAG, "ImsPhoneConnection: changeToUnPausedState - unsetting paused bit; newVideoState=" + VideoProfile.videoStateToString(videoState));
        updateVideoState(videoState);
        this.mShouldIgnoreVideoStateChanges = false;
    }

    public void setLocalVideoCapable(boolean z) {
        this.mIsLocalVideoCapable = z;
        Rlog.i(LOG_TAG, "setLocalVideoCapable: mIsLocalVideoCapable = " + this.mIsLocalVideoCapable + "; updating local video availability.");
        updateMediaCapabilities(getImsCall());
    }

    public void sendRtpHeaderExtensions(Set<RtpHeaderExtension> set) {
        if (this.mImsCall == null) {
            Rlog.w(LOG_TAG, "sendRtpHeaderExtensions: Not an IMS call");
            return;
        }
        Rlog.i(LOG_TAG, "sendRtpHeaderExtensions: numExtensions = " + set.size());
        this.mImsCall.sendRtpHeaderExtensions(set);
    }

    public Set<RtpHeaderExtensionType> getAcceptedRtpHeaderExtensions() {
        ImsCall imsCall = this.mImsCall;
        if (imsCall == null || imsCall.getCallProfile() == null) {
            return Collections.EMPTY_SET;
        }
        return this.mImsCall.getCallProfile().getAcceptedRtpHeaderExtensionTypes();
    }

    public void setImsReasonInfo(ImsReasonInfo imsReasonInfo) {
        this.mImsReasonInfo = imsReasonInfo;
    }

    public ImsReasonInfo getImsReasonInfo() {
        return this.mImsReasonInfo;
    }

    /* access modifiers changed from: protected */
    public int getCallPriority() {
        if (isEmergency()) {
            return 2;
        }
        return isWpsCall() ? 1 : 0;
    }

    /* access modifiers changed from: protected */
    public int callNumberPresentation(ImsCallProfile imsCallProfile) {
        return ImsCallProfile.OIRToPresentation(imsCallProfile.getCallExtraInt("oir"));
    }

    /* access modifiers changed from: protected */
    public boolean needUpdateAddress(String str) {
        return !equalsBaseDialString(this.mAddress, str);
    }
}
