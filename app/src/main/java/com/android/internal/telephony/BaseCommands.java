package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.telephony.emergency.EmergencyNumber;
import com.android.internal.telephony.uicc.SimPhonebookRecord;
import java.util.ArrayList;
import java.util.List;

public abstract class BaseCommands implements CommandsInterface {
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mAllowedNetworkTypesBitmask;
    protected RegistrantList mApnUnthrottledRegistrants = new RegistrantList();
    protected RegistrantList mAvailRegistrants = new RegistrantList();
    protected RegistrantList mBarringInfoChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mCallStateRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mCallWaitingInfoRegistrants = new RegistrantList();
    protected RegistrantList mCarrierInfoForImsiEncryptionRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mCatCallSetUpRegistrant;
    @UnsupportedAppUsage
    protected Registrant mCatCcAlphaRegistrant;
    @UnsupportedAppUsage
    protected Registrant mCatEventRegistrant;
    @UnsupportedAppUsage
    protected Registrant mCatProCmdRegistrant;
    @UnsupportedAppUsage
    protected Registrant mCatSessionEndRegistrant;
    @UnsupportedAppUsage
    protected RegistrantList mCdmaPrlChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mCdmaSmsRegistrant;
    public int mCdmaSubscription;
    @UnsupportedAppUsage
    protected RegistrantList mCdmaSubscriptionChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Context mContext;
    protected RegistrantList mDataCallListChangedRegistrants = new RegistrantList();
    protected RegistrantList mDisplayInfoRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    public Registrant mEmergencyCallbackModeRegistrant;
    protected RegistrantList mEmergencyNumberListRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mExitEmergencyCallbackModeRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mGsmBroadcastSmsRegistrant;
    @UnsupportedAppUsage
    protected Registrant mGsmSmsRegistrant;
    @UnsupportedAppUsage
    protected RegistrantList mHardwareConfigChangeRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mIccRefreshRegistrants = new RegistrantList();
    protected RegistrantList mIccSlotStatusChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mIccSmsFullRegistrant;
    @UnsupportedAppUsage
    protected RegistrantList mIccStatusChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mImsNetworkStateChangedRegistrants = new RegistrantList();
    private final List<EmergencyNumber> mLastEmergencyNumberListIndication = new ArrayList();
    private Object mLastEmergencyNumberListIndicationLock = new Object();
    protected RegistrantList mLceInfoRegistrants = new RegistrantList();
    protected RegistrantList mLineControlInfoRegistrants = new RegistrantList();
    protected RegistrantList mModemResetRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mNITZTimeRegistrant;
    protected RegistrantList mNattKeepaliveStatusRegistrants = new RegistrantList();
    protected RegistrantList mNetworkStateRegistrants = new RegistrantList();
    protected RegistrantList mNotAvailRegistrants = new RegistrantList();
    protected RegistrantList mNumberInfoRegistrants = new RegistrantList();
    protected RegistrantList mOffOrNotAvailRegistrants = new RegistrantList();
    protected RegistrantList mOnRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mOtaProvisionRegistrants = new RegistrantList();
    protected RegistrantList mPcoDataRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mPhoneRadioCapabilityChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected int mPhoneType;
    protected RegistrantList mPhysicalChannelConfigurationRegistrants = new RegistrantList();
    protected RegistrantList mRadioStateChangedRegistrants = new RegistrantList();
    protected RegistrantList mRedirNumInfoRegistrants = new RegistrantList();
    protected Registrant mRegistrationFailedRegistrant;
    @UnsupportedAppUsage
    protected RegistrantList mResendIncallMuteRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mRestrictedStateRegistrant;
    @UnsupportedAppUsage
    protected RegistrantList mRilCellInfoListRegistrants = new RegistrantList();
    protected RegistrantList mRilConnectedRegistrants = new RegistrantList();
    protected RegistrantList mRilNetworkScanResultRegistrants = new RegistrantList();
    protected int mRilVersion = -1;
    @UnsupportedAppUsage
    protected Registrant mRingRegistrant;
    @UnsupportedAppUsage
    protected RegistrantList mRingbackToneRegistrants = new RegistrantList();
    protected RegistrantList mSignalInfoRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mSignalStrengthRegistrant;
    protected RegistrantList mSimPhonebookChangedRegistrants = new RegistrantList();
    protected RegistrantList mSimPhonebookRecordsReceivedRegistrants = new RegistrantList();
    protected RegistrantList mSlicingConfigChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mSmsOnSimRegistrant;
    @UnsupportedAppUsage
    protected Registrant mSmsStatusRegistrant;
    @UnsupportedAppUsage
    protected RegistrantList mSrvccStateRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mSsRegistrant;
    @UnsupportedAppUsage
    protected Registrant mSsnRegistrant;
    protected int mState = 2;
    @UnsupportedAppUsage
    protected Object mStateMonitor = new Object();
    @UnsupportedAppUsage
    protected RegistrantList mSubscriptionStatusRegistrants = new RegistrantList();
    protected RegistrantList mT53AudCntrlInfoRegistrants = new RegistrantList();
    protected RegistrantList mT53ClirInfoRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mUSSDRegistrant;
    protected RegistrantList mUiccApplicationsEnablementRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected Registrant mUnsolOemHookRawRegistrant;
    public RegistrantList mVoicePrivacyOffRegistrants = new RegistrantList();
    public RegistrantList mVoicePrivacyOnRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mVoiceRadioTechChangedRegistrants = new RegistrantList();

    public void getRadioCapability(Message message) {
    }

    public void getSimPhonebookCapacity(Message message) {
    }

    public void getSimPhonebookRecords(Message message) {
    }

    public void pullLceData(Message message) {
    }

    public void requestShutdown(Message message) {
    }

    public void setDataAllowed(boolean z, Message message) {
    }

    public void setRadioCapability(RadioCapability radioCapability, Message message) {
    }

    public void setUiccSubscription(int i, int i2, int i3, int i4, Message message) {
    }

    public void startLceService(int i, boolean z, Message message) {
    }

    public void stopLceService(Message message) {
    }

    public void testingEmergencyCall() {
    }

    public void updateSimPhonebookRecord(SimPhonebookRecord simPhonebookRecord, Message message) {
    }

    public BaseCommands(Context context) {
        this.mContext = context;
    }

    public int getRadioState() {
        return this.mState;
    }

    public void registerForRadioStateChanged(Handler handler, int i, Object obj) {
        synchronized (this.mStateMonitor) {
            this.mRadioStateChangedRegistrants.addUnique(handler, i, obj);
            Message.obtain(handler, i, new AsyncResult(obj, (Object) null, (Throwable) null)).sendToTarget();
        }
    }

    public void unregisterForRadioStateChanged(Handler handler) {
        synchronized (this.mStateMonitor) {
            this.mRadioStateChangedRegistrants.remove(handler);
        }
    }

    public void registerForImsNetworkStateChanged(Handler handler, int i, Object obj) {
        this.mImsNetworkStateChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForImsNetworkStateChanged(Handler handler) {
        this.mImsNetworkStateChangedRegistrants.remove(handler);
    }

    public void registerForOn(Handler handler, int i, Object obj) {
        synchronized (this.mStateMonitor) {
            this.mOnRegistrants.addUnique(handler, i, obj);
            if (this.mState == 1) {
                Message.obtain(handler, i, new AsyncResult(obj, (Object) null, (Throwable) null)).sendToTarget();
            }
        }
    }

    public void unregisterForOn(Handler handler) {
        synchronized (this.mStateMonitor) {
            this.mOnRegistrants.remove(handler);
        }
    }

    public void registerForAvailable(Handler handler, int i, Object obj) {
        synchronized (this.mStateMonitor) {
            this.mAvailRegistrants.addUnique(handler, i, obj);
            if (this.mState != 2) {
                Message.obtain(handler, i, new AsyncResult(obj, (Object) null, (Throwable) null)).sendToTarget();
            }
        }
    }

    public void unregisterForAvailable(Handler handler) {
        synchronized (this.mStateMonitor) {
            this.mAvailRegistrants.remove(handler);
        }
    }

    public void registerForNotAvailable(Handler handler, int i, Object obj) {
        synchronized (this.mStateMonitor) {
            this.mNotAvailRegistrants.addUnique(handler, i, obj);
            if (this.mState == 2) {
                Message.obtain(handler, i, new AsyncResult(obj, (Object) null, (Throwable) null)).sendToTarget();
            }
        }
    }

    public void unregisterForNotAvailable(Handler handler) {
        synchronized (this.mStateMonitor) {
            this.mNotAvailRegistrants.remove(handler);
        }
    }

    public void registerForOffOrNotAvailable(Handler handler, int i, Object obj) {
        synchronized (this.mStateMonitor) {
            this.mOffOrNotAvailRegistrants.addUnique(handler, i, obj);
            int i2 = this.mState;
            if (i2 == 0 || i2 == 2) {
                Message.obtain(handler, i, new AsyncResult(obj, (Object) null, (Throwable) null)).sendToTarget();
            }
        }
    }

    public void unregisterForOffOrNotAvailable(Handler handler) {
        synchronized (this.mStateMonitor) {
            this.mOffOrNotAvailRegistrants.remove(handler);
        }
    }

    public void registerForCallStateChanged(Handler handler, int i, Object obj) {
        this.mCallStateRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCallStateChanged(Handler handler) {
        this.mCallStateRegistrants.remove(handler);
    }

    public void registerForNetworkStateChanged(Handler handler, int i, Object obj) {
        this.mNetworkStateRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForNetworkStateChanged(Handler handler) {
        this.mNetworkStateRegistrants.remove(handler);
    }

    public void registerForDataCallListChanged(Handler handler, int i, Object obj) {
        this.mDataCallListChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForDataCallListChanged(Handler handler) {
        this.mDataCallListChangedRegistrants.remove(handler);
    }

    public void registerForApnUnthrottled(Handler handler, int i, Object obj) {
        this.mApnUnthrottledRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForApnUnthrottled(Handler handler) {
        this.mApnUnthrottledRegistrants.remove(handler);
    }

    public void registerForSlicingConfigChanged(Handler handler, int i, Object obj) {
        this.mSlicingConfigChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSlicingConfigChanged(Handler handler) {
        this.mSlicingConfigChangedRegistrants.remove(handler);
    }

    public void registerForVoiceRadioTechChanged(Handler handler, int i, Object obj) {
        this.mVoiceRadioTechChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForVoiceRadioTechChanged(Handler handler) {
        this.mVoiceRadioTechChangedRegistrants.remove(handler);
    }

    public void registerForIccStatusChanged(Handler handler, int i, Object obj) {
        this.mIccStatusChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForIccStatusChanged(Handler handler) {
        this.mIccStatusChangedRegistrants.remove(handler);
    }

    public void registerForIccSlotStatusChanged(Handler handler, int i, Object obj) {
        this.mIccSlotStatusChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForIccSlotStatusChanged(Handler handler) {
        this.mIccSlotStatusChangedRegistrants.remove(handler);
    }

    public void setOnNewGsmSms(Handler handler, int i, Object obj) {
        this.mGsmSmsRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnNewGsmSms(Handler handler) {
        Registrant registrant = this.mGsmSmsRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mGsmSmsRegistrant.clear();
            this.mGsmSmsRegistrant = null;
        }
    }

    public void setOnNewCdmaSms(Handler handler, int i, Object obj) {
        this.mCdmaSmsRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnNewCdmaSms(Handler handler) {
        Registrant registrant = this.mCdmaSmsRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mCdmaSmsRegistrant.clear();
            this.mCdmaSmsRegistrant = null;
        }
    }

    public void setOnNewGsmBroadcastSms(Handler handler, int i, Object obj) {
        this.mGsmBroadcastSmsRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnNewGsmBroadcastSms(Handler handler) {
        Registrant registrant = this.mGsmBroadcastSmsRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mGsmBroadcastSmsRegistrant.clear();
            this.mGsmBroadcastSmsRegistrant = null;
        }
    }

    public void setOnSmsOnSim(Handler handler, int i, Object obj) {
        this.mSmsOnSimRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnSmsOnSim(Handler handler) {
        Registrant registrant = this.mSmsOnSimRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mSmsOnSimRegistrant.clear();
            this.mSmsOnSimRegistrant = null;
        }
    }

    public void setOnSmsStatus(Handler handler, int i, Object obj) {
        this.mSmsStatusRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnSmsStatus(Handler handler) {
        Registrant registrant = this.mSmsStatusRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mSmsStatusRegistrant.clear();
            this.mSmsStatusRegistrant = null;
        }
    }

    public void setOnSignalStrengthUpdate(Handler handler, int i, Object obj) {
        this.mSignalStrengthRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnSignalStrengthUpdate(Handler handler) {
        Registrant registrant = this.mSignalStrengthRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mSignalStrengthRegistrant.clear();
            this.mSignalStrengthRegistrant = null;
        }
    }

    public void setOnNITZTime(Handler handler, int i, Object obj) {
        this.mNITZTimeRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnNITZTime(Handler handler) {
        Registrant registrant = this.mNITZTimeRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mNITZTimeRegistrant.clear();
            this.mNITZTimeRegistrant = null;
        }
    }

    public void setOnUSSD(Handler handler, int i, Object obj) {
        this.mUSSDRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnUSSD(Handler handler) {
        Registrant registrant = this.mUSSDRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mUSSDRegistrant.clear();
            this.mUSSDRegistrant = null;
        }
    }

    public void setOnSuppServiceNotification(Handler handler, int i, Object obj) {
        this.mSsnRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnSuppServiceNotification(Handler handler) {
        Registrant registrant = this.mSsnRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mSsnRegistrant.clear();
            this.mSsnRegistrant = null;
        }
    }

    public void setOnCatSessionEnd(Handler handler, int i, Object obj) {
        this.mCatSessionEndRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnCatSessionEnd(Handler handler) {
        Registrant registrant = this.mCatSessionEndRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mCatSessionEndRegistrant.clear();
            this.mCatSessionEndRegistrant = null;
        }
    }

    public void setOnCatProactiveCmd(Handler handler, int i, Object obj) {
        this.mCatProCmdRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnCatProactiveCmd(Handler handler) {
        Registrant registrant = this.mCatProCmdRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mCatProCmdRegistrant.clear();
            this.mCatProCmdRegistrant = null;
        }
    }

    public void setOnCatEvent(Handler handler, int i, Object obj) {
        this.mCatEventRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnCatEvent(Handler handler) {
        Registrant registrant = this.mCatEventRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mCatEventRegistrant.clear();
            this.mCatEventRegistrant = null;
        }
    }

    public void setOnCatCallSetUp(Handler handler, int i, Object obj) {
        this.mCatCallSetUpRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnCatCallSetUp(Handler handler) {
        Registrant registrant = this.mCatCallSetUpRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mCatCallSetUpRegistrant.clear();
            this.mCatCallSetUpRegistrant = null;
        }
    }

    public void setOnIccSmsFull(Handler handler, int i, Object obj) {
        this.mIccSmsFullRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnIccSmsFull(Handler handler) {
        Registrant registrant = this.mIccSmsFullRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mIccSmsFullRegistrant.clear();
            this.mIccSmsFullRegistrant = null;
        }
    }

    public void registerForIccRefresh(Handler handler, int i, Object obj) {
        this.mIccRefreshRegistrants.addUnique(handler, i, obj);
    }

    public void setOnIccRefresh(Handler handler, int i, Object obj) {
        registerForIccRefresh(handler, i, obj);
    }

    public void setEmergencyCallbackMode(Handler handler, int i, Object obj) {
        this.mEmergencyCallbackModeRegistrant = new Registrant(handler, i, obj);
    }

    public void unregisterForIccRefresh(Handler handler) {
        this.mIccRefreshRegistrants.remove(handler);
    }

    public void unsetOnIccRefresh(Handler handler) {
        unregisterForIccRefresh(handler);
    }

    public void setOnCallRing(Handler handler, int i, Object obj) {
        this.mRingRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnCallRing(Handler handler) {
        Registrant registrant = this.mRingRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mRingRegistrant.clear();
            this.mRingRegistrant = null;
        }
    }

    public void setOnSs(Handler handler, int i, Object obj) {
        this.mSsRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnSs(Handler handler) {
        this.mSsRegistrant.clear();
    }

    public void setOnCatCcAlphaNotify(Handler handler, int i, Object obj) {
        this.mCatCcAlphaRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnCatCcAlphaNotify(Handler handler) {
        this.mCatCcAlphaRegistrant.clear();
    }

    public void setOnRegistrationFailed(Handler handler, int i, Object obj) {
        this.mRegistrationFailedRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnRegistrationFailed(Handler handler) {
        this.mRegistrationFailedRegistrant.clear();
    }

    public void registerForInCallVoicePrivacyOn(Handler handler, int i, Object obj) {
        this.mVoicePrivacyOnRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForInCallVoicePrivacyOn(Handler handler) {
        this.mVoicePrivacyOnRegistrants.remove(handler);
    }

    public void registerForInCallVoicePrivacyOff(Handler handler, int i, Object obj) {
        this.mVoicePrivacyOffRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForInCallVoicePrivacyOff(Handler handler) {
        this.mVoicePrivacyOffRegistrants.remove(handler);
    }

    public void setOnRestrictedStateChanged(Handler handler, int i, Object obj) {
        this.mRestrictedStateRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnRestrictedStateChanged(Handler handler) {
        Registrant registrant = this.mRestrictedStateRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mRestrictedStateRegistrant.clear();
            this.mRestrictedStateRegistrant = null;
        }
    }

    public void registerForDisplayInfo(Handler handler, int i, Object obj) {
        this.mDisplayInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForDisplayInfo(Handler handler) {
        this.mDisplayInfoRegistrants.remove(handler);
    }

    public void registerForCallWaitingInfo(Handler handler, int i, Object obj) {
        this.mCallWaitingInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCallWaitingInfo(Handler handler) {
        this.mCallWaitingInfoRegistrants.remove(handler);
    }

    public void registerForSignalInfo(Handler handler, int i, Object obj) {
        this.mSignalInfoRegistrants.addUnique(handler, i, obj);
    }

    public void setOnUnsolOemHookRaw(Handler handler, int i, Object obj) {
        this.mUnsolOemHookRawRegistrant = new Registrant(handler, i, obj);
    }

    public void unSetOnUnsolOemHookRaw(Handler handler) {
        Registrant registrant = this.mUnsolOemHookRawRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mUnsolOemHookRawRegistrant.clear();
            this.mUnsolOemHookRawRegistrant = null;
        }
    }

    public void unregisterForSignalInfo(Handler handler) {
        this.mSignalInfoRegistrants.remove(handler);
    }

    public void registerForCdmaOtaProvision(Handler handler, int i, Object obj) {
        this.mOtaProvisionRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCdmaOtaProvision(Handler handler) {
        this.mOtaProvisionRegistrants.remove(handler);
    }

    public void registerForNumberInfo(Handler handler, int i, Object obj) {
        this.mNumberInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForNumberInfo(Handler handler) {
        this.mNumberInfoRegistrants.remove(handler);
    }

    public void registerForRedirectedNumberInfo(Handler handler, int i, Object obj) {
        this.mRedirNumInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForRedirectedNumberInfo(Handler handler) {
        this.mRedirNumInfoRegistrants.remove(handler);
    }

    public void registerForLineControlInfo(Handler handler, int i, Object obj) {
        this.mLineControlInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForLineControlInfo(Handler handler) {
        this.mLineControlInfoRegistrants.remove(handler);
    }

    public void registerFoT53ClirlInfo(Handler handler, int i, Object obj) {
        this.mT53ClirInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForT53ClirInfo(Handler handler) {
        this.mT53ClirInfoRegistrants.remove(handler);
    }

    public void registerForT53AudioControlInfo(Handler handler, int i, Object obj) {
        this.mT53AudCntrlInfoRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForT53AudioControlInfo(Handler handler) {
        this.mT53AudCntrlInfoRegistrants.remove(handler);
    }

    public void registerForRingbackTone(Handler handler, int i, Object obj) {
        this.mRingbackToneRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForRingbackTone(Handler handler) {
        this.mRingbackToneRegistrants.remove(handler);
    }

    public void registerForResendIncallMute(Handler handler, int i, Object obj) {
        this.mResendIncallMuteRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForResendIncallMute(Handler handler) {
        this.mResendIncallMuteRegistrants.remove(handler);
    }

    public void registerForCdmaSubscriptionChanged(Handler handler, int i, Object obj) {
        this.mCdmaSubscriptionChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCdmaSubscriptionChanged(Handler handler) {
        this.mCdmaSubscriptionChangedRegistrants.remove(handler);
    }

    public void registerForCdmaPrlChanged(Handler handler, int i, Object obj) {
        this.mCdmaPrlChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCdmaPrlChanged(Handler handler) {
        this.mCdmaPrlChangedRegistrants.remove(handler);
    }

    public void registerForExitEmergencyCallbackMode(Handler handler, int i, Object obj) {
        this.mExitEmergencyCallbackModeRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForExitEmergencyCallbackMode(Handler handler) {
        this.mExitEmergencyCallbackModeRegistrants.remove(handler);
    }

    public void registerForHardwareConfigChanged(Handler handler, int i, Object obj) {
        this.mHardwareConfigChangeRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForHardwareConfigChanged(Handler handler) {
        this.mHardwareConfigChangeRegistrants.remove(handler);
    }

    public void registerForNetworkScanResult(Handler handler, int i, Object obj) {
        this.mRilNetworkScanResultRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForNetworkScanResult(Handler handler) {
        this.mRilNetworkScanResultRegistrants.remove(handler);
    }

    public void registerForRilConnected(Handler handler, int i, Object obj) {
        this.mRilConnectedRegistrants.addUnique(handler, i, obj);
        if (this.mRilVersion != -1) {
            Message.obtain(handler, i, new AsyncResult(obj, new Integer(this.mRilVersion), (Throwable) null)).sendToTarget();
        }
    }

    public void unregisterForRilConnected(Handler handler) {
        this.mRilConnectedRegistrants.remove(handler);
    }

    public void registerForSubscriptionStatusChanged(Handler handler, int i, Object obj) {
        this.mSubscriptionStatusRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSubscriptionStatusChanged(Handler handler) {
        this.mSubscriptionStatusRegistrants.remove(handler);
    }

    public void registerForEmergencyNumberList(Handler handler, int i, Object obj) {
        this.mEmergencyNumberListRegistrants.addUnique(handler, i, obj);
        List<EmergencyNumber> lastEmergencyNumberListIndication = getLastEmergencyNumberListIndication();
        if (lastEmergencyNumberListIndication != null) {
            this.mEmergencyNumberListRegistrants.notifyRegistrants(new AsyncResult((Object) null, lastEmergencyNumberListIndication, (Throwable) null));
        }
    }

    public void unregisterForEmergencyNumberList(Handler handler) {
        this.mEmergencyNumberListRegistrants.remove(handler);
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:26:0x0043, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void setRadioState(int r4, boolean r5) {
        /*
            r3 = this;
            java.lang.Object r0 = r3.mStateMonitor
            monitor-enter(r0)
            int r1 = r3.mState     // Catch:{ all -> 0x0044 }
            r3.mState = r4     // Catch:{ all -> 0x0044 }
            if (r1 != r4) goto L_0x000d
            if (r5 != 0) goto L_0x000d
            monitor-exit(r0)     // Catch:{ all -> 0x0044 }
            return
        L_0x000d:
            com.android.internal.telephony.RegistrantList r4 = r3.mRadioStateChangedRegistrants     // Catch:{ all -> 0x0044 }
            r4.notifyRegistrants()     // Catch:{ all -> 0x0044 }
            int r4 = r3.mState     // Catch:{ all -> 0x0044 }
            r5 = 2
            if (r4 == r5) goto L_0x001e
            if (r1 != r5) goto L_0x001e
            com.android.internal.telephony.RegistrantList r4 = r3.mAvailRegistrants     // Catch:{ all -> 0x0044 }
            r4.notifyRegistrants()     // Catch:{ all -> 0x0044 }
        L_0x001e:
            int r4 = r3.mState     // Catch:{ all -> 0x0044 }
            if (r4 != r5) goto L_0x0029
            if (r1 == r5) goto L_0x0029
            com.android.internal.telephony.RegistrantList r4 = r3.mNotAvailRegistrants     // Catch:{ all -> 0x0044 }
            r4.notifyRegistrants()     // Catch:{ all -> 0x0044 }
        L_0x0029:
            int r4 = r3.mState     // Catch:{ all -> 0x0044 }
            r2 = 1
            if (r4 != r2) goto L_0x0035
            if (r1 == r2) goto L_0x0035
            com.android.internal.telephony.RegistrantList r4 = r3.mOnRegistrants     // Catch:{ all -> 0x0044 }
            r4.notifyRegistrants()     // Catch:{ all -> 0x0044 }
        L_0x0035:
            int r4 = r3.mState     // Catch:{ all -> 0x0044 }
            if (r4 == 0) goto L_0x003b
            if (r4 != r5) goto L_0x0042
        L_0x003b:
            if (r1 != r2) goto L_0x0042
            com.android.internal.telephony.RegistrantList r3 = r3.mOffOrNotAvailRegistrants     // Catch:{ all -> 0x0044 }
            r3.notifyRegistrants()     // Catch:{ all -> 0x0044 }
        L_0x0042:
            monitor-exit(r0)     // Catch:{ all -> 0x0044 }
            return
        L_0x0044:
            r3 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0044 }
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.BaseCommands.setRadioState(int, boolean):void");
    }

    /* access modifiers changed from: protected */
    public void cacheEmergencyNumberListIndication(List<EmergencyNumber> list) {
        synchronized (this.mLastEmergencyNumberListIndicationLock) {
            this.mLastEmergencyNumberListIndication.clear();
            this.mLastEmergencyNumberListIndication.addAll(list);
        }
    }

    private List<EmergencyNumber> getLastEmergencyNumberListIndication() {
        ArrayList arrayList;
        synchronized (this.mLastEmergencyNumberListIndicationLock) {
            arrayList = new ArrayList(this.mLastEmergencyNumberListIndication);
        }
        return arrayList;
    }

    public void registerForCellInfoList(Handler handler, int i, Object obj) {
        this.mRilCellInfoListRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCellInfoList(Handler handler) {
        this.mRilCellInfoListRegistrants.remove(handler);
    }

    public void registerForPhysicalChannelConfiguration(Handler handler, int i, Object obj) {
        this.mPhysicalChannelConfigurationRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForPhysicalChannelConfiguration(Handler handler) {
        this.mPhysicalChannelConfigurationRegistrants.remove(handler);
    }

    public void registerForSrvccStateChanged(Handler handler, int i, Object obj) {
        this.mSrvccStateRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSrvccStateChanged(Handler handler) {
        this.mSrvccStateRegistrants.remove(handler);
    }

    public int getRilVersion() {
        return this.mRilVersion;
    }

    public void registerForRadioCapabilityChanged(Handler handler, int i, Object obj) {
        this.mPhoneRadioCapabilityChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForRadioCapabilityChanged(Handler handler) {
        this.mPhoneRadioCapabilityChangedRegistrants.remove(handler);
    }

    public void registerForLceInfo(Handler handler, int i, Object obj) {
        synchronized (this.mStateMonitor) {
            this.mLceInfoRegistrants.addUnique(handler, i, obj);
        }
    }

    public void unregisterForLceInfo(Handler handler) {
        synchronized (this.mStateMonitor) {
            this.mLceInfoRegistrants.remove(handler);
        }
    }

    public void registerForModemReset(Handler handler, int i, Object obj) {
        this.mModemResetRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForModemReset(Handler handler) {
        this.mModemResetRegistrants.remove(handler);
    }

    public void registerForPcoData(Handler handler, int i, Object obj) {
        this.mPcoDataRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForPcoData(Handler handler) {
        this.mPcoDataRegistrants.remove(handler);
    }

    public void registerForCarrierInfoForImsiEncryption(Handler handler, int i, Object obj) {
        this.mCarrierInfoForImsiEncryptionRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForCarrierInfoForImsiEncryption(Handler handler) {
        this.mCarrierInfoForImsiEncryptionRegistrants.remove(handler);
    }

    public void registerForNattKeepaliveStatus(Handler handler, int i, Object obj) {
        synchronized (this.mStateMonitor) {
            this.mNattKeepaliveStatusRegistrants.addUnique(handler, i, obj);
        }
    }

    public void unregisterForNattKeepaliveStatus(Handler handler) {
        synchronized (this.mStateMonitor) {
            this.mNattKeepaliveStatusRegistrants.remove(handler);
        }
    }

    public void registerUiccApplicationEnablementChanged(Handler handler, int i, Object obj) {
        this.mUiccApplicationsEnablementRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterUiccApplicationEnablementChanged(Handler handler) {
        this.mUiccApplicationsEnablementRegistrants.remove(handler);
    }

    public void registerForBarringInfoChanged(Handler handler, int i, Object obj) {
        this.mBarringInfoChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForBarringInfoChanged(Handler handler) {
        this.mBarringInfoChangedRegistrants.remove(handler);
    }

    public void registerForSimPhonebookChanged(Handler handler, int i, Object obj) {
        this.mSimPhonebookChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSimPhonebookChanged(Handler handler) {
        this.mSimPhonebookChangedRegistrants.remove(handler);
    }

    public void registerForSimPhonebookRecordsReceived(Handler handler, int i, Object obj) {
        this.mSimPhonebookRecordsReceivedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSimPhonebookRecordsReceived(Handler handler) {
        this.mSimPhonebookRecordsReceivedRegistrants.remove(handler);
    }
}
