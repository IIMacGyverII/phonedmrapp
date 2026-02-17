package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.telephony.PhoneNumberUtils;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

public class CallManager {
    private static final boolean DBG = true;
    @VisibleForTesting
    protected static final int EVENT_CALL_WAITING = 108;
    protected static final int EVENT_CDMA_OTA_STATUS_CHANGE = 111;
    protected static final int EVENT_DISCONNECT = 100;
    protected static final int EVENT_DISPLAY_INFO = 109;
    protected static final int EVENT_ECM_TIMER_RESET = 115;
    protected static final int EVENT_INCOMING_RING = 104;
    protected static final int EVENT_IN_CALL_VOICE_PRIVACY_OFF = 107;
    protected static final int EVENT_IN_CALL_VOICE_PRIVACY_ON = 106;
    protected static final int EVENT_MMI_COMPLETE = 114;
    protected static final int EVENT_MMI_INITIATE = 113;
    protected static final int EVENT_NEW_RINGING_CONNECTION = 102;
    protected static final int EVENT_ONHOLD_TONE = 120;
    protected static final int EVENT_POST_DIAL_CHARACTER = 119;
    @VisibleForTesting
    protected static final int EVENT_PRECISE_CALL_STATE_CHANGED = 101;
    protected static final int EVENT_RESEND_INCALL_MUTE = 112;
    @VisibleForTesting
    protected static final int EVENT_RINGBACK_TONE = 105;
    protected static final int EVENT_SERVICE_STATE_CHANGED = 118;
    protected static final int EVENT_SIGNAL_INFO = 110;
    protected static final int EVENT_SUBSCRIPTION_INFO_READY = 116;
    protected static final int EVENT_SUPP_SERVICE_FAILED = 117;
    protected static final int EVENT_TTY_MODE_RECEIVED = 122;
    protected static final int EVENT_UNKNOWN_CONNECTION = 103;
    private static CallManager INSTANCE = null;
    protected static final String LOG_TAG = "CallManager";
    protected static final boolean VDBG = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final ArrayList<Call> mBackgroundCalls = new ArrayList<>();
    protected final RegistrantList mCallWaitingRegistrants = new RegistrantList();
    protected final RegistrantList mCdmaOtaStatusChangeRegistrants = new RegistrantList();
    private Phone mDefaultPhone = null;
    protected final RegistrantList mDisconnectRegistrants = new RegistrantList();
    protected final RegistrantList mDisplayInfoRegistrants = new RegistrantList();
    protected final RegistrantList mEcmTimerResetRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final ArrayList<Connection> mEmptyConnections = new ArrayList<>();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final ArrayList<Call> mForegroundCalls = new ArrayList<>();
    protected final HashMap<Phone, CallManagerHandler> mHandlerMap = new HashMap<>();
    protected final RegistrantList mInCallVoicePrivacyOffRegistrants = new RegistrantList();
    protected final RegistrantList mInCallVoicePrivacyOnRegistrants = new RegistrantList();
    protected final RegistrantList mIncomingRingRegistrants = new RegistrantList();
    protected final RegistrantList mMmiCompleteRegistrants = new RegistrantList();
    protected final RegistrantList mMmiInitiateRegistrants = new RegistrantList();
    protected final RegistrantList mMmiRegistrants = new RegistrantList();
    protected final RegistrantList mNewRingingConnectionRegistrants = new RegistrantList();
    protected final RegistrantList mOnHoldToneRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final ArrayList<Phone> mPhones = new ArrayList<>();
    protected final RegistrantList mPostDialCharacterRegistrants = new RegistrantList();
    protected final RegistrantList mPreciseCallStateRegistrants = new RegistrantList();
    protected Object mRegistrantidentifier = new Object();
    protected final RegistrantList mResendIncallMuteRegistrants = new RegistrantList();
    protected final RegistrantList mRingbackToneRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final ArrayList<Call> mRingingCalls = new ArrayList<>();
    protected final RegistrantList mServiceStateChangedRegistrants = new RegistrantList();
    protected final RegistrantList mSignalInfoRegistrants = new RegistrantList();
    private boolean mSpeedUpAudioForMtCall = false;
    protected final RegistrantList mSubscriptionInfoReadyRegistrants = new RegistrantList();
    protected final RegistrantList mSuppServiceFailedRegistrants = new RegistrantList();
    protected final RegistrantList mTtyModeReceivedRegistrants = new RegistrantList();
    protected final RegistrantList mUnknownConnectionRegistrants = new RegistrantList();

    /* access modifiers changed from: protected */
    public boolean onSetIncomingRejected(boolean z) {
        return z;
    }

    protected CallManager() {
    }

    @UnsupportedAppUsage
    public static CallManager getInstance() {
        if (INSTANCE == null) {
            INSTANCE = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeCallManager();
        }
        return INSTANCE;
    }

    private Phone getPhone(int i) {
        Iterator<Phone> it = this.mPhones.iterator();
        while (it.hasNext()) {
            Phone next = it.next();
            if (next.getSubId() == i && next.getPhoneType() != 5) {
                return next;
            }
        }
        return null;
    }

    @UnsupportedAppUsage
    public PhoneConstants.State getState() {
        PhoneConstants.State state = PhoneConstants.State.IDLE;
        Iterator<Phone> it = this.mPhones.iterator();
        while (it.hasNext()) {
            Phone next = it.next();
            PhoneConstants.State state2 = next.getState();
            PhoneConstants.State state3 = PhoneConstants.State.RINGING;
            if (state2 == state3) {
                state = state3;
            } else if (next.getState() == PhoneConstants.State.OFFHOOK && state == PhoneConstants.State.IDLE) {
                state = PhoneConstants.State.OFFHOOK;
            }
        }
        return state;
    }

    @UnsupportedAppUsage
    public PhoneConstants.State getState(int i) {
        PhoneConstants.State state = PhoneConstants.State.IDLE;
        Iterator<Phone> it = this.mPhones.iterator();
        while (it.hasNext()) {
            Phone next = it.next();
            if (next.getSubId() == i) {
                PhoneConstants.State state2 = next.getState();
                PhoneConstants.State state3 = PhoneConstants.State.RINGING;
                if (state2 == state3) {
                    state = state3;
                } else if (next.getState() == PhoneConstants.State.OFFHOOK && state == PhoneConstants.State.IDLE) {
                    state = PhoneConstants.State.OFFHOOK;
                }
            }
        }
        return state;
    }

    public int getServiceState() {
        Iterator<Phone> it = this.mPhones.iterator();
        while (it.hasNext()) {
            int state = it.next().getServiceState().getState();
            if (state == 0) {
                return state;
            }
            if (state == 1) {
            }
        }
        return 1;
    }

    public int getServiceState(int i) {
        Iterator<Phone> it = this.mPhones.iterator();
        while (it.hasNext()) {
            Phone next = it.next();
            if (next.getSubId() == i) {
                int state = next.getServiceState().getState();
                if (state == 0) {
                    return state;
                }
                if (state == 1) {
                }
            }
        }
        return 1;
    }

    @UnsupportedAppUsage
    public Phone getPhoneInCall() {
        if (!getFirstActiveRingingCall().isIdle()) {
            return getFirstActiveRingingCall().getPhone();
        }
        if (!getActiveFgCall().isIdle()) {
            return getActiveFgCall().getPhone();
        }
        return getFirstActiveBgCall().getPhone();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean registerPhone(Phone phone) {
        if (phone == null || this.mPhones.contains(phone)) {
            return false;
        }
        Rlog.d(LOG_TAG, "registerPhone(" + phone.getPhoneName() + " " + phone + ")");
        if (this.mPhones.isEmpty()) {
            this.mDefaultPhone = phone;
        }
        this.mPhones.add(phone);
        this.mRingingCalls.add(phone.getRingingCall());
        this.mBackgroundCalls.add(phone.getBackgroundCall());
        this.mForegroundCalls.add(phone.getForegroundCall());
        registerForPhoneStates(phone);
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void unregisterPhone(Phone phone) {
        if (phone != null && this.mPhones.contains(phone)) {
            Rlog.d(LOG_TAG, "unregisterPhone(" + phone.getPhoneName() + " " + phone + ")");
            Phone imsPhone = phone.getImsPhone();
            if (imsPhone != null) {
                unregisterPhone(imsPhone);
            }
            this.mPhones.remove(phone);
            this.mRingingCalls.remove(phone.getRingingCall());
            this.mBackgroundCalls.remove(phone.getBackgroundCall());
            this.mForegroundCalls.remove(phone.getForegroundCall());
            unregisterForPhoneStates(phone);
            if (phone != this.mDefaultPhone) {
                return;
            }
            if (this.mPhones.isEmpty()) {
                this.mDefaultPhone = null;
            } else {
                this.mDefaultPhone = this.mPhones.get(0);
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Phone getDefaultPhone() {
        return this.mDefaultPhone;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Phone getFgPhone() {
        return getActiveFgCall().getPhone();
    }

    @UnsupportedAppUsage
    public Phone getFgPhone(int i) {
        return getActiveFgCall(i).getPhone();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Phone getBgPhone() {
        return getFirstActiveBgCall().getPhone();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Phone getRingingPhone() {
        return getFirstActiveRingingCall().getPhone();
    }

    public Phone getRingingPhone(int i) {
        return getFirstActiveRingingCall(i).getPhone();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private Context getContext() {
        Phone defaultPhone = getDefaultPhone();
        if (defaultPhone == null) {
            return null;
        }
        return defaultPhone.getContext();
    }

    public Object getRegistrantIdentifier() {
        return this.mRegistrantidentifier;
    }

    /* access modifiers changed from: protected */
    public void registerForPhoneStates(Phone phone) {
        if (this.mHandlerMap.get(phone) != null) {
            Rlog.d(LOG_TAG, "This phone has already been registered.");
            return;
        }
        CallManagerHandler callManagerHandler = new CallManagerHandler();
        this.mHandlerMap.put(phone, callManagerHandler);
        phone.registerForPreciseCallStateChanged(callManagerHandler, 101, this.mRegistrantidentifier);
        phone.registerForDisconnect(callManagerHandler, 100, this.mRegistrantidentifier);
        phone.registerForNewRingingConnection(callManagerHandler, 102, this.mRegistrantidentifier);
        phone.registerForUnknownConnection(callManagerHandler, 103, this.mRegistrantidentifier);
        phone.registerForIncomingRing(callManagerHandler, 104, this.mRegistrantidentifier);
        phone.registerForRingbackTone(callManagerHandler, 105, this.mRegistrantidentifier);
        phone.registerForInCallVoicePrivacyOn(callManagerHandler, 106, this.mRegistrantidentifier);
        phone.registerForInCallVoicePrivacyOff(callManagerHandler, 107, this.mRegistrantidentifier);
        phone.registerForDisplayInfo(callManagerHandler, 109, this.mRegistrantidentifier);
        phone.registerForSignalInfo(callManagerHandler, 110, this.mRegistrantidentifier);
        phone.registerForResendIncallMute(callManagerHandler, 112, this.mRegistrantidentifier);
        phone.registerForMmiInitiate(callManagerHandler, 113, this.mRegistrantidentifier);
        phone.registerForMmiComplete(callManagerHandler, 114, this.mRegistrantidentifier);
        phone.registerForSuppServiceFailed(callManagerHandler, 117, this.mRegistrantidentifier);
        phone.registerForServiceStateChanged(callManagerHandler, 118, this.mRegistrantidentifier);
        phone.setOnPostDialCharacter(callManagerHandler, 119, (Object) null);
        phone.registerForCdmaOtaStatusChange(callManagerHandler, 111, (Object) null);
        phone.registerForSubscriptionInfoReady(callManagerHandler, 116, (Object) null);
        phone.registerForCallWaiting(callManagerHandler, 108, (Object) null);
        phone.registerForEcmTimerReset(callManagerHandler, 115, (Object) null);
        phone.registerForOnHoldTone(callManagerHandler, 120, (Object) null);
        phone.registerForSuppServiceFailed(callManagerHandler, 117, (Object) null);
        phone.registerForTtyModeReceived(callManagerHandler, 122, (Object) null);
    }

    private void unregisterForPhoneStates(Phone phone) {
        CallManagerHandler callManagerHandler = this.mHandlerMap.get(phone);
        if (callManagerHandler == null) {
            Rlog.e(LOG_TAG, "Could not find Phone handler for unregistration");
            return;
        }
        this.mHandlerMap.remove(phone);
        phone.unregisterForPreciseCallStateChanged(callManagerHandler);
        phone.unregisterForDisconnect(callManagerHandler);
        phone.unregisterForNewRingingConnection(callManagerHandler);
        phone.unregisterForUnknownConnection(callManagerHandler);
        phone.unregisterForIncomingRing(callManagerHandler);
        phone.unregisterForRingbackTone(callManagerHandler);
        phone.unregisterForInCallVoicePrivacyOn(callManagerHandler);
        phone.unregisterForInCallVoicePrivacyOff(callManagerHandler);
        phone.unregisterForDisplayInfo(callManagerHandler);
        phone.unregisterForSignalInfo(callManagerHandler);
        phone.unregisterForResendIncallMute(callManagerHandler);
        phone.unregisterForMmiInitiate(callManagerHandler);
        phone.unregisterForMmiComplete(callManagerHandler);
        phone.unregisterForSuppServiceFailed(callManagerHandler);
        phone.unregisterForServiceStateChanged(callManagerHandler);
        phone.unregisterForTtyModeReceived(callManagerHandler);
        phone.setOnPostDialCharacter((Handler) null, 119, (Object) null);
        phone.unregisterForCdmaOtaStatusChange(callManagerHandler);
        phone.unregisterForSubscriptionInfoReady(callManagerHandler);
        phone.unregisterForCallWaiting(callManagerHandler);
        phone.unregisterForEcmTimerReset(callManagerHandler);
        phone.unregisterForOnHoldTone(callManagerHandler);
        phone.unregisterForSuppServiceFailed(callManagerHandler);
    }

    public void rejectCall(Call call) throws CallStateException {
        call.getPhone().rejectCall();
    }

    public boolean canConference(Call call) {
        Phone phone = null;
        Phone phone2 = hasActiveFgCall() ? getActiveFgCall().getPhone() : null;
        if (call != null) {
            phone = call.getPhone();
        }
        return phone.getClass().equals(phone2.getClass());
    }

    @UnsupportedAppUsage
    public boolean canConference(Call call, int i) {
        Phone phone = null;
        Phone phone2 = hasActiveFgCall(i) ? getActiveFgCall(i).getPhone() : null;
        if (call != null) {
            phone = call.getPhone();
        }
        return phone.getClass().equals(phone2.getClass());
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void conference(Call call) throws CallStateException {
        Phone fgPhone = getFgPhone(call.getPhone().getSubId());
        if (fgPhone == null) {
            Rlog.d(LOG_TAG, "conference: fgPhone=null");
        } else if (canConference(call)) {
            fgPhone.conference();
        } else {
            throw new CallStateException("Can't conference foreground and selected background call");
        }
    }

    public Connection dial(Phone phone, String str, int i) throws CallStateException {
        int subId = phone.getSubId();
        if (canDial(phone)) {
            if (hasActiveFgCall(subId)) {
                Phone phone2 = getActiveFgCall(subId).getPhone();
                boolean z = true;
                boolean z2 = !phone2.getBackgroundCall().isIdle();
                StringBuilder sb = new StringBuilder();
                sb.append("hasBgCall: ");
                sb.append(z2);
                sb.append(" sameChannel:");
                if (phone2 != phone) {
                    z = false;
                }
                sb.append(z);
                Rlog.d(LOG_TAG, sb.toString());
                Phone imsPhone = phone.getImsPhone();
                if (phone2 != phone && (imsPhone == null || imsPhone != phone2)) {
                    if (z2) {
                        Rlog.d(LOG_TAG, "Hangup");
                        getActiveFgCall(subId).hangup();
                    } else {
                        Rlog.d(LOG_TAG, "Switch");
                        phone2.switchHoldingAndActive();
                    }
                }
            }
            return phone.dial(str, new PhoneInternalInterface.DialArgs.Builder().setVideoState(i).build());
        } else if (phone.handleInCallMmiCommands(PhoneNumberUtils.stripSeparators(str))) {
            return null;
        } else {
            throw new CallStateException("cannot dial in current state");
        }
    }

    public Connection dial(Phone phone, String str, UUSInfo uUSInfo, int i) throws CallStateException {
        return phone.dial(str, new PhoneInternalInterface.DialArgs.Builder().setUusInfo(uUSInfo).setVideoState(i).build());
    }

    public void clearDisconnected() {
        Iterator<Phone> it = this.mPhones.iterator();
        while (it.hasNext()) {
            it.next().clearDisconnected();
        }
    }

    public void clearDisconnected(int i) {
        Iterator<Phone> it = this.mPhones.iterator();
        while (it.hasNext()) {
            Phone next = it.next();
            if (next.getSubId() == i) {
                next.clearDisconnected();
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private boolean canDial(Phone phone) {
        int state = phone.getServiceState().getState();
        int subId = phone.getSubId();
        boolean hasActiveRingingCall = hasActiveRingingCall();
        Call.State activeFgCallState = getActiveFgCallState(subId);
        boolean z = state != 3 && !hasActiveRingingCall && (activeFgCallState == Call.State.ACTIVE || activeFgCallState == Call.State.IDLE || activeFgCallState == Call.State.DISCONNECTED || activeFgCallState == Call.State.ALERTING);
        if (!z) {
            Rlog.d(LOG_TAG, "canDial serviceState=" + state + " hasRingingCall=" + hasActiveRingingCall + " fgCallState=" + activeFgCallState);
        }
        return z;
    }

    public boolean canTransfer(Call call) {
        Phone phone = null;
        Phone phone2 = hasActiveFgCall() ? getActiveFgCall().getPhone() : null;
        if (call != null) {
            phone = call.getPhone();
        }
        return phone == phone2 && phone2.canTransfer();
    }

    public boolean canTransfer(Call call, int i) {
        Phone phone = null;
        Phone phone2 = hasActiveFgCall(i) ? getActiveFgCall(i).getPhone() : null;
        if (call != null) {
            phone = call.getPhone();
        }
        return phone == phone2 && phone2.canTransfer();
    }

    public void explicitCallTransfer(Call call) throws CallStateException {
        if (canTransfer(call)) {
            call.getPhone().explicitCallTransfer();
        }
    }

    public List<? extends MmiCode> getPendingMmiCodes(Phone phone) {
        Rlog.e(LOG_TAG, "getPendingMmiCodes not implemented");
        return null;
    }

    public boolean sendUssdResponse(Phone phone, String str) {
        Rlog.e(LOG_TAG, "sendUssdResponse not implemented");
        return false;
    }

    public void setMute(boolean z) {
        if (hasActiveFgCall()) {
            getActiveFgCall().getPhone().setMute(z);
        }
    }

    public boolean getMute() {
        if (hasActiveFgCall()) {
            return getActiveFgCall().getPhone().getMute();
        }
        if (hasActiveBgCall()) {
            return getFirstActiveBgCall().getPhone().getMute();
        }
        return false;
    }

    public void setEchoSuppressionEnabled() {
        if (hasActiveFgCall()) {
            getActiveFgCall().getPhone().setEchoSuppressionEnabled();
        }
    }

    public boolean sendDtmf(char c) {
        if (!hasActiveFgCall()) {
            return false;
        }
        getActiveFgCall().getPhone().sendDtmf(c);
        return true;
    }

    public boolean startDtmf(char c) {
        if (!hasActiveFgCall()) {
            return false;
        }
        getActiveFgCall().getPhone().startDtmf(c);
        return true;
    }

    public void stopDtmf() {
        if (hasActiveFgCall()) {
            getFgPhone().stopDtmf();
        }
    }

    public boolean sendBurstDtmf(String str, int i, int i2, Message message) {
        if (!hasActiveFgCall()) {
            return false;
        }
        getActiveFgCall().getPhone().sendBurstDtmf(str, i, i2, message);
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void registerForDisconnect(Handler handler, int i, Object obj) {
        this.mDisconnectRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void unregisterForDisconnect(Handler handler) {
        this.mDisconnectRegistrants.remove(handler);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void registerForPreciseCallStateChanged(Handler handler, int i, Object obj) {
        this.mPreciseCallStateRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void unregisterForPreciseCallStateChanged(Handler handler) {
        this.mPreciseCallStateRegistrants.remove(handler);
    }

    public void registerForUnknownConnection(Handler handler, int i, Object obj) {
        this.mUnknownConnectionRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForUnknownConnection(Handler handler) {
        this.mUnknownConnectionRegistrants.remove(handler);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void registerForNewRingingConnection(Handler handler, int i, Object obj) {
        this.mNewRingingConnectionRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void unregisterForNewRingingConnection(Handler handler) {
        this.mNewRingingConnectionRegistrants.remove(handler);
    }

    public void registerForIncomingRing(Handler handler, int i, Object obj) {
        this.mIncomingRingRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForIncomingRing(Handler handler) {
        this.mIncomingRingRegistrants.remove(handler);
    }

    public void registerForRingbackTone(Handler handler, int i, Object obj) {
        this.mRingbackToneRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForRingbackTone(Handler handler) {
        this.mRingbackToneRegistrants.remove(handler);
    }

    public void registerForOnHoldTone(Handler handler, int i, Object obj) {
        this.mOnHoldToneRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForOnHoldTone(Handler handler) {
        this.mOnHoldToneRegistrants.remove(handler);
    }

    public void registerForResendIncallMute(Handler handler, int i, Object obj) {
        this.mResendIncallMuteRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForResendIncallMute(Handler handler) {
        this.mResendIncallMuteRegistrants.remove(handler);
    }

    public void registerForMmiInitiate(Handler handler, int i, Object obj) {
        this.mMmiInitiateRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForMmiInitiate(Handler handler) {
        this.mMmiInitiateRegistrants.remove(handler);
    }

    public void registerForMmiComplete(Handler handler, int i, Object obj) {
        Rlog.d(LOG_TAG, "registerForMmiComplete");
        this.mMmiCompleteRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForMmiComplete(Handler handler) {
        this.mMmiCompleteRegistrants.remove(handler);
    }

    public void registerForEcmTimerReset(Handler handler, int i, Object obj) {
        this.mEcmTimerResetRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForEcmTimerReset(Handler handler) {
        this.mEcmTimerResetRegistrants.remove(handler);
    }

    public void registerForServiceStateChanged(Handler handler, int i, Object obj) {
        this.mServiceStateChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForServiceStateChanged(Handler handler) {
        this.mServiceStateChangedRegistrants.remove(handler);
    }

    public void registerForSuppServiceFailed(Handler handler, int i, Object obj) {
        this.mSuppServiceFailedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSuppServiceFailed(Handler handler) {
        this.mSuppServiceFailedRegistrants.remove(handler);
    }

    public void registerForInCallVoicePrivacyOn(Handler handler, int i, Object obj) {
        this.mInCallVoicePrivacyOnRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForInCallVoicePrivacyOn(Handler handler) {
        this.mInCallVoicePrivacyOnRegistrants.remove(handler);
    }

    public void registerForInCallVoicePrivacyOff(Handler handler, int i, Object obj) {
        this.mInCallVoicePrivacyOffRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForInCallVoicePrivacyOff(Handler handler) {
        this.mInCallVoicePrivacyOffRegistrants.remove(handler);
    }

    public void registerForCallWaiting(Handler handler, int i, Object obj) {
        this.mCallWaitingRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCallWaiting(Handler handler) {
        this.mCallWaitingRegistrants.remove(handler);
    }

    public void registerForSignalInfo(Handler handler, int i, Object obj) {
        this.mSignalInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSignalInfo(Handler handler) {
        this.mSignalInfoRegistrants.remove(handler);
    }

    public void registerForDisplayInfo(Handler handler, int i, Object obj) {
        this.mDisplayInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForDisplayInfo(Handler handler) {
        this.mDisplayInfoRegistrants.remove(handler);
    }

    public void registerForCdmaOtaStatusChange(Handler handler, int i, Object obj) {
        this.mCdmaOtaStatusChangeRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCdmaOtaStatusChange(Handler handler) {
        this.mCdmaOtaStatusChangeRegistrants.remove(handler);
    }

    public void registerForSubscriptionInfoReady(Handler handler, int i, Object obj) {
        this.mSubscriptionInfoReadyRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSubscriptionInfoReady(Handler handler) {
        this.mSubscriptionInfoReadyRegistrants.remove(handler);
    }

    public void registerForPostDialCharacter(Handler handler, int i, Object obj) {
        this.mPostDialCharacterRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForPostDialCharacter(Handler handler) {
        this.mPostDialCharacterRegistrants.remove(handler);
    }

    public void registerForTtyModeReceived(Handler handler, int i, Object obj) {
        this.mTtyModeReceivedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForTtyModeReceived(Handler handler) {
        this.mTtyModeReceivedRegistrants.remove(handler);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public List<Call> getRingingCalls() {
        return Collections.unmodifiableList(this.mRingingCalls);
    }

    public List<Call> getForegroundCalls() {
        return Collections.unmodifiableList(this.mForegroundCalls);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public List<Call> getBackgroundCalls() {
        return Collections.unmodifiableList(this.mBackgroundCalls);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean hasActiveFgCall() {
        return getFirstActiveCall(this.mForegroundCalls) != null;
    }

    @UnsupportedAppUsage
    public boolean hasActiveFgCall(int i) {
        return getFirstActiveCall(this.mForegroundCalls, i) != null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean hasActiveBgCall() {
        return getFirstActiveCall(this.mBackgroundCalls) != null;
    }

    @UnsupportedAppUsage
    public boolean hasActiveBgCall(int i) {
        return getFirstActiveCall(this.mBackgroundCalls, i) != null;
    }

    public boolean hasActiveRingingCall() {
        return getFirstActiveCall(this.mRingingCalls) != null;
    }

    @UnsupportedAppUsage
    public boolean hasActiveRingingCall(int i) {
        return getFirstActiveCall(this.mRingingCalls, i) != null;
    }

    public Call getActiveFgCall() {
        Call call;
        Call firstNonIdleCall = getFirstNonIdleCall(this.mForegroundCalls);
        if (firstNonIdleCall != null) {
            return firstNonIdleCall;
        }
        Phone phone = this.mDefaultPhone;
        if (phone == null) {
            call = null;
        } else {
            call = phone.getForegroundCall();
        }
        return call;
    }

    @UnsupportedAppUsage
    public Call getActiveFgCall(int i) {
        Call call;
        Call firstNonIdleCall = getFirstNonIdleCall(this.mForegroundCalls, i);
        if (firstNonIdleCall != null) {
            return firstNonIdleCall;
        }
        Phone phone = getPhone(i);
        if (phone == null) {
            call = null;
        } else {
            call = phone.getForegroundCall();
        }
        return call;
    }

    private Call getFirstNonIdleCall(List<Call> list) {
        Call call = null;
        for (Call next : list) {
            if (!next.isIdle()) {
                return next;
            }
            if (next.getState() != Call.State.IDLE && call == null) {
                call = next;
            }
        }
        return call;
    }

    private Call getFirstNonIdleCall(List<Call> list, int i) {
        Call call = null;
        for (Call next : list) {
            if (next.getPhone().getSubId() == i) {
                if (!next.isIdle()) {
                    return next;
                }
                if (next.getState() != Call.State.IDLE && call == null) {
                    call = next;
                }
            }
        }
        return call;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Call getFirstActiveBgCall() {
        Call call;
        Call firstNonIdleCall = getFirstNonIdleCall(this.mBackgroundCalls);
        if (firstNonIdleCall != null) {
            return firstNonIdleCall;
        }
        Phone phone = this.mDefaultPhone;
        if (phone == null) {
            call = null;
        } else {
            call = phone.getBackgroundCall();
        }
        return call;
    }

    @UnsupportedAppUsage
    public Call getFirstActiveBgCall(int i) {
        Phone phone = getPhone(i);
        if (hasMoreThanOneHoldingCall(i)) {
            return phone.getBackgroundCall();
        }
        Call firstNonIdleCall = getFirstNonIdleCall(this.mBackgroundCalls, i);
        if (firstNonIdleCall != null) {
            return firstNonIdleCall;
        }
        if (phone == null) {
            return null;
        }
        return phone.getBackgroundCall();
    }

    @UnsupportedAppUsage
    public Call getFirstActiveRingingCall() {
        Call call;
        Call firstNonIdleCall = getFirstNonIdleCall(this.mRingingCalls);
        if (firstNonIdleCall != null) {
            return firstNonIdleCall;
        }
        Phone phone = this.mDefaultPhone;
        if (phone == null) {
            call = null;
        } else {
            call = phone.getRingingCall();
        }
        return call;
    }

    @UnsupportedAppUsage
    public Call getFirstActiveRingingCall(int i) {
        Phone phone = getPhone(i);
        Call firstNonIdleCall = getFirstNonIdleCall(this.mRingingCalls, i);
        if (firstNonIdleCall != null) {
            return firstNonIdleCall;
        }
        if (phone == null) {
            return null;
        }
        return phone.getRingingCall();
    }

    public Call.State getActiveFgCallState() {
        Call activeFgCall = getActiveFgCall();
        if (activeFgCall != null) {
            return activeFgCall.getState();
        }
        return Call.State.IDLE;
    }

    @UnsupportedAppUsage
    public Call.State getActiveFgCallState(int i) {
        Call activeFgCall = getActiveFgCall(i);
        if (activeFgCall != null) {
            return activeFgCall.getState();
        }
        return Call.State.IDLE;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public List<Connection> getFgCallConnections() {
        Call activeFgCall = getActiveFgCall();
        if (activeFgCall != null) {
            return activeFgCall.getConnections();
        }
        return this.mEmptyConnections;
    }

    public List<Connection> getFgCallConnections(int i) {
        Call activeFgCall = getActiveFgCall(i);
        if (activeFgCall != null) {
            return activeFgCall.getConnections();
        }
        return this.mEmptyConnections;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public List<Connection> getBgCallConnections() {
        Call firstActiveBgCall = getFirstActiveBgCall();
        if (firstActiveBgCall != null) {
            return firstActiveBgCall.getConnections();
        }
        return this.mEmptyConnections;
    }

    public boolean hasDisconnectedFgCall() {
        return getFirstCallOfState(this.mForegroundCalls, Call.State.DISCONNECTED) != null;
    }

    public boolean hasDisconnectedFgCall(int i) {
        return getFirstCallOfState(this.mForegroundCalls, Call.State.DISCONNECTED, i) != null;
    }

    public boolean hasDisconnectedBgCall() {
        return getFirstCallOfState(this.mBackgroundCalls, Call.State.DISCONNECTED) != null;
    }

    public boolean hasDisconnectedBgCall(int i) {
        return getFirstCallOfState(this.mBackgroundCalls, Call.State.DISCONNECTED, i) != null;
    }

    private Call getFirstActiveCall(ArrayList<Call> arrayList) {
        Iterator<Call> it = arrayList.iterator();
        while (it.hasNext()) {
            Call next = it.next();
            if (!next.isIdle()) {
                return next;
            }
        }
        return null;
    }

    private Call getFirstActiveCall(ArrayList<Call> arrayList, int i) {
        Iterator<Call> it = arrayList.iterator();
        while (it.hasNext()) {
            Call next = it.next();
            if (!next.isIdle() && next.getPhone().getSubId() == i) {
                return next;
            }
        }
        return null;
    }

    private Call getFirstCallOfState(ArrayList<Call> arrayList, Call.State state) {
        Iterator<Call> it = arrayList.iterator();
        while (it.hasNext()) {
            Call next = it.next();
            if (next.getState() == state) {
                return next;
            }
        }
        return null;
    }

    /* JADX WARNING: Removed duplicated region for block: B:3:0x000a  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private com.android.internal.telephony.Call getFirstCallOfState(java.util.ArrayList<com.android.internal.telephony.Call> r2, com.android.internal.telephony.Call.State r3, int r4) {
        /*
            r1 = this;
            java.util.Iterator r1 = r2.iterator()
        L_0x0004:
            boolean r2 = r1.hasNext()
            if (r2 == 0) goto L_0x0021
            java.lang.Object r2 = r1.next()
            com.android.internal.telephony.Call r2 = (com.android.internal.telephony.Call) r2
            com.android.internal.telephony.Call$State r0 = r2.getState()
            if (r0 == r3) goto L_0x0020
            com.android.internal.telephony.Phone r0 = r2.getPhone()
            int r0 = r0.getSubId()
            if (r0 != r4) goto L_0x0004
        L_0x0020:
            return r2
        L_0x0021:
            r1 = 0
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.CallManager.getFirstCallOfState(java.util.ArrayList, com.android.internal.telephony.Call$State, int):com.android.internal.telephony.Call");
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean hasMoreThanOneRingingCall() {
        Iterator<Call> it = this.mRingingCalls.iterator();
        int i = 0;
        while (it.hasNext()) {
            if (it.next().getState().isRinging() && (i = i + 1) > 1) {
                return true;
            }
        }
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private boolean hasMoreThanOneRingingCall(int i) {
        Iterator<Call> it = this.mRingingCalls.iterator();
        int i2 = 0;
        while (it.hasNext()) {
            Call next = it.next();
            if (next.getState().isRinging() && next.getPhone().getSubId() == i && (i2 = i2 + 1) > 1) {
                return true;
            }
        }
        return false;
    }

    private boolean hasMoreThanOneHoldingCall(int i) {
        Iterator<Call> it = this.mBackgroundCalls.iterator();
        int i2 = 0;
        while (it.hasNext()) {
            Call next = it.next();
            if (next.getState() == Call.State.HOLDING && next.getPhone().getSubId() == i && (i2 = i2 + 1) > 1) {
                return true;
            }
        }
        return false;
    }

    protected class CallManagerHandler extends Handler {
        protected CallManagerHandler() {
        }

        /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r1v1, resolved type: boolean} */
        /* JADX WARNING: type inference failed for: r1v0 */
        /* JADX WARNING: type inference failed for: r1v3 */
        /* JADX WARNING: type inference failed for: r1v4, types: [int] */
        /* JADX WARNING: type inference failed for: r1v6 */
        /* JADX WARNING: Multi-variable type inference failed */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void handleMessage(android.os.Message r7) {
            /*
                r6 = this;
                int r0 = r7.what
                r1 = 0
                java.lang.String r2 = "CallManager"
                switch(r0) {
                    case 100: goto L_0x01a8;
                    case 101: goto L_0x019c;
                    case 102: goto L_0x0127;
                    case 103: goto L_0x011a;
                    case 104: goto L_0x0105;
                    case 105: goto L_0x00f8;
                    case 106: goto L_0x00eb;
                    case 107: goto L_0x00de;
                    case 108: goto L_0x00d1;
                    case 109: goto L_0x00c4;
                    case 110: goto L_0x00b7;
                    case 111: goto L_0x00aa;
                    case 112: goto L_0x009d;
                    case 113: goto L_0x0090;
                    case 114: goto L_0x007e;
                    case 115: goto L_0x0071;
                    case 116: goto L_0x0064;
                    case 117: goto L_0x0057;
                    case 118: goto L_0x004a;
                    case 119: goto L_0x0024;
                    case 120: goto L_0x0017;
                    case 121: goto L_0x0008;
                    case 122: goto L_0x000a;
                    default: goto L_0x0008;
                }
            L_0x0008:
                goto L_0x01b3
            L_0x000a:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mTtyModeReceivedRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x0017:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mOnHoldToneRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x0024:
                com.android.internal.telephony.CallManager r0 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r0 = r0.mPostDialCharacterRegistrants
                int r0 = r0.size()
                if (r1 >= r0) goto L_0x01b3
                com.android.internal.telephony.CallManager r0 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r0 = r0.mPostDialCharacterRegistrants
                java.lang.Object r0 = r0.get(r1)
                com.android.internal.telephony.Registrant r0 = (com.android.internal.telephony.Registrant) r0
                android.os.Message r0 = r0.messageForRegistrant()
                java.lang.Object r2 = r7.obj
                r0.obj = r2
                int r2 = r7.arg1
                r0.arg1 = r2
                r0.sendToTarget()
                int r1 = r1 + 1
                goto L_0x0024
            L_0x004a:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mServiceStateChangedRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x0057:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mSuppServiceFailedRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x0064:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mSubscriptionInfoReadyRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x0071:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mEcmTimerResetRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x007e:
                java.lang.String r0 = "CallManager: handleMessage (EVENT_MMI_COMPLETE)"
                com.android.telephony.Rlog.d(r2, r0)
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mMmiCompleteRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x0090:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mMmiInitiateRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x009d:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mResendIncallMuteRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x00aa:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mCdmaOtaStatusChangeRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x00b7:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mSignalInfoRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x00c4:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mDisplayInfoRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x00d1:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mCallWaitingRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x00de:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mInCallVoicePrivacyOffRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x00eb:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mInCallVoicePrivacyOnRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x00f8:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mRingbackToneRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x0105:
                com.android.internal.telephony.CallManager r0 = com.android.internal.telephony.CallManager.this
                boolean r0 = r0.hasActiveFgCall()
                if (r0 != 0) goto L_0x01b3
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mIncomingRingRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x011a:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mUnknownConnectionRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x0127:
                java.lang.Object r0 = r7.obj
                android.os.AsyncResult r0 = (android.os.AsyncResult) r0
                java.lang.Object r0 = r0.result
                com.android.internal.telephony.Connection r0 = (com.android.internal.telephony.Connection) r0
                com.android.internal.telephony.Call r3 = r0.getCall()
                com.android.internal.telephony.Phone r3 = r3.getPhone()
                int r3 = r3.getSubId()
                int r4 = r0.getPhoneType()
                r5 = 5
                if (r4 != r5) goto L_0x014c
                r4 = r0
                com.android.internal.telephony.imsphone.ImsPhoneConnection r4 = (com.android.internal.telephony.imsphone.ImsPhoneConnection) r4
                boolean r4 = r4.isIncomingCallAutoRejected()
                if (r4 == 0) goto L_0x014c
                r1 = 1
            L_0x014c:
                com.android.internal.telephony.CallManager r4 = com.android.internal.telephony.CallManager.this
                boolean r1 = r4.onSetIncomingRejected(r1)
                com.android.internal.telephony.CallManager r4 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.Call$State r3 = r4.getActiveFgCallState(r3)
                boolean r3 = r3.isDialing()
                if (r3 != 0) goto L_0x0166
                com.android.internal.telephony.CallManager r3 = com.android.internal.telephony.CallManager.this
                boolean r3 = r3.hasMoreThanOneRingingCall()
                if (r3 == 0) goto L_0x0190
            L_0x0166:
                if (r1 != 0) goto L_0x0190
                java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ CallStateException -> 0x0189 }
                r6.<init>()     // Catch:{ CallStateException -> 0x0189 }
                java.lang.String r7 = "silently drop incoming call: "
                r6.append(r7)     // Catch:{ CallStateException -> 0x0189 }
                com.android.internal.telephony.Call r7 = r0.getCall()     // Catch:{ CallStateException -> 0x0189 }
                r6.append(r7)     // Catch:{ CallStateException -> 0x0189 }
                java.lang.String r6 = r6.toString()     // Catch:{ CallStateException -> 0x0189 }
                com.android.telephony.Rlog.d(r2, r6)     // Catch:{ CallStateException -> 0x0189 }
                com.android.internal.telephony.Call r6 = r0.getCall()     // Catch:{ CallStateException -> 0x0189 }
                r6.hangup()     // Catch:{ CallStateException -> 0x0189 }
                goto L_0x01b3
            L_0x0189:
                r6 = move-exception
                java.lang.String r7 = "new ringing connection"
                com.android.telephony.Rlog.w(r2, r7, r6)
                goto L_0x01b3
            L_0x0190:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mNewRingingConnectionRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x019c:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mPreciseCallStateRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
                goto L_0x01b3
            L_0x01a8:
                com.android.internal.telephony.CallManager r6 = com.android.internal.telephony.CallManager.this
                com.android.internal.telephony.RegistrantList r6 = r6.mDisconnectRegistrants
                java.lang.Object r7 = r7.obj
                android.os.AsyncResult r7 = (android.os.AsyncResult) r7
                r6.notifyRegistrants(r7)
            L_0x01b3:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.CallManager.CallManagerHandler.handleMessage(android.os.Message):void");
        }
    }
}
