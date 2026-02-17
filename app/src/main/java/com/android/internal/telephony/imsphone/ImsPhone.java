package com.android.internal.telephony.imsphone;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.PowerManager;
import android.os.ResultReceiver;
import android.os.UserHandle;
import android.preference.PreferenceManager;
import android.telecom.Connection;
import android.telephony.AccessNetworkConstants;
import android.telephony.CallQuality;
import android.telephony.CarrierConfigManager;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.NetworkScanRequest;
import android.telephony.PhoneNumberUtils;
import android.telephony.ServiceState;
import android.telephony.SignalStrength;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.UssdResponse;
import android.telephony.ims.ImsCallForwardInfo;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.ImsSsInfo;
import android.telephony.ims.RegistrationManager;
import android.text.TextUtils;
import com.android.ims.ImsEcbmStateListener;
import com.android.ims.ImsException;
import com.android.ims.ImsManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CallFailCause;
import com.android.internal.telephony.CallForwardInfo;
import com.android.internal.telephony.CallStateException;
import com.android.internal.telephony.CallTracker;
import com.android.internal.telephony.CarrierPrivilegesTracker;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.Connection;
import com.android.internal.telephony.GsmCdmaPhone;
import com.android.internal.telephony.IccCard;
import com.android.internal.telephony.IccPhoneBookInterfaceManager;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.MmiCode;
import com.android.internal.telephony.OperatorInfo;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.PhoneNotifier;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.ServiceStateTracker;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.TelephonyComponentFactory;
import com.android.internal.telephony.emergency.EmergencyNumberTracker;
import com.android.internal.telephony.gsm.SuppServiceNotification;
import com.android.internal.telephony.imsphone.ImsRegistrationCallbackHelper;
import com.android.internal.telephony.metrics.ImsStats;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.metrics.VoiceCallSessionStats;
import com.android.internal.telephony.uicc.IccFileHandler;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.util.NotificationChannelController;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.function.Consumer;

public class ImsPhone extends ImsPhoneBase {
    public static final int CANCEL_ECM_TIMER = 1;
    protected static final boolean DBG = true;
    protected static final long DEFAULT_ECM_EXIT_TIMER_VALUE = 300000;
    private static final int EVENT_DEFAULT_PHONE_DATA_STATE_CHANGED = 71;
    protected static final int EVENT_GET_CALL_BARRING_DONE = 66;
    protected static final int EVENT_GET_CALL_WAITING_DONE = 68;
    private static final int EVENT_GET_CLIP_DONE = 75;
    protected static final int EVENT_GET_CLIR_DONE = 70;
    private static final int EVENT_INITIATE_VOLTE_SILENT_REDIAL = 74;
    @VisibleForTesting
    public static final int EVENT_SERVICE_STATE_CHANGED = 72;
    protected static final int EVENT_SET_CALL_BARRING_DONE = 65;
    protected static final int EVENT_SET_CALL_WAITING_DONE = 67;
    protected static final int EVENT_SET_CLIR_DONE = 69;
    protected static final int EVENT_VOICE_CALL_ENDED = 73;
    private static final String LOG_TAG = "ImsPhone";
    private static final String PREF_USER_SET_CALL_COMPOSER_PREFIX = "userset_callcomposer_prefix";
    public static final int RESTART_ECM_TIMER = 0;
    private static final boolean VDBG = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCallTracker mCT;
    private Uri[] mCurrentSubscriberUris;
    public Phone mDefaultPhone;
    protected Registrant mEcmExitRespRegistrant;
    protected Runnable mExitEcmRunnable;
    protected ImsExternalCallTracker mExternalCallTracker;
    private ImsEcbmStateListener mImsEcbmStateListener;
    private final ImsManagerFactory mImsManagerFactory;
    private ImsRegistrationCallbackHelper mImsMmTelRegistrationHelper;
    private SharedPreferences mImsPhoneSharedPreferences;
    /* access modifiers changed from: private */
    public ImsStats mImsStats;
    private boolean mIsInImsEcm;
    private String mLastDialString;
    protected boolean mLastKnownRoamingState;
    /* access modifiers changed from: private */
    public TelephonyMetrics mMetrics;
    private ImsRegistrationCallbackHelper.ImsRegistrationUpdate mMmTelRegistrationUpdate;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ArrayList<ImsPhoneMmiCode> mPendingMMIs;
    /* access modifiers changed from: private */
    public final LocalLog mRegLocalLog;
    protected BroadcastReceiver mResultReceiver;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ServiceState mSS;
    private final RegistrantList mSilentRedialRegistrants;
    private RegistrantList mSsnRegistrants;
    protected PowerManager.WakeLock mWakeLock;

    @VisibleForTesting
    public interface ImsManagerFactory {
        ImsManager create(Context context, int i);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getActionFromCFAction(int i) {
        if (i == 0) {
            return 0;
        }
        if (i == 1) {
            return 1;
        }
        if (i != 3) {
            return i != 4 ? -1 : 4;
        }
        return 3;
    }

    /* access modifiers changed from: protected */
    public int getCFReasonFromCondition(int i) {
        if (i == 0) {
            return 0;
        }
        if (i == 1) {
            return 1;
        }
        if (i == 2) {
            return 2;
        }
        if (i != 4) {
            return i != 5 ? 3 : 5;
        }
        return 4;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getConditionFromCFReason(int i) {
        if (i == 0) {
            return 0;
        }
        if (i == 1) {
            return 1;
        }
        if (i == 2) {
            return 2;
        }
        if (i == 3) {
            return 3;
        }
        if (i != 4) {
            return i != 5 ? -1 : 5;
        }
        return 4;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isCfEnable(int i) {
        return i == 1 || i == 3;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isValidCommandInterfaceCFAction(int i) {
        return i == 0 || i == 1 || i == 3 || i == 4;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isValidCommandInterfaceCFReason(int i) {
        return i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5;
    }

    public /* bridge */ /* synthetic */ void activateCellBroadcastSms(int i, Message message) {
        super.activateCellBroadcastSms(i, message);
    }

    public /* bridge */ /* synthetic */ boolean disableDataConnectivity() {
        return super.disableDataConnectivity();
    }

    public /* bridge */ /* synthetic */ void disableLocationUpdates() {
        super.disableLocationUpdates();
    }

    public /* bridge */ /* synthetic */ boolean enableDataConnectivity() {
        return super.enableDataConnectivity();
    }

    public /* bridge */ /* synthetic */ void enableLocationUpdates() {
        super.enableLocationUpdates();
    }

    public /* bridge */ /* synthetic */ void getAvailableNetworks(Message message) {
        super.getAvailableNetworks(message);
    }

    public /* bridge */ /* synthetic */ void getCellBroadcastSmsConfig(Message message) {
        super.getCellBroadcastSmsConfig(message);
    }

    public /* bridge */ /* synthetic */ List getCurrentDataConnectionList() {
        return super.getCurrentDataConnectionList();
    }

    public /* bridge */ /* synthetic */ int getDataActivityState() {
        return super.getDataActivityState();
    }

    public /* bridge */ /* synthetic */ PhoneConstants.DataState getDataConnectionState() {
        return super.getDataConnectionState();
    }

    public /* bridge */ /* synthetic */ boolean getDataRoamingEnabled() {
        return super.getDataRoamingEnabled();
    }

    public /* bridge */ /* synthetic */ String getDeviceId() {
        return super.getDeviceId();
    }

    public /* bridge */ /* synthetic */ String getDeviceSvn() {
        return super.getDeviceSvn();
    }

    public /* bridge */ /* synthetic */ String getEsn() {
        return super.getEsn();
    }

    public /* bridge */ /* synthetic */ String getGroupIdLevel1() {
        return super.getGroupIdLevel1();
    }

    public /* bridge */ /* synthetic */ String getGroupIdLevel2() {
        return super.getGroupIdLevel2();
    }

    public /* bridge */ /* synthetic */ IccCard getIccCard() {
        return super.getIccCard();
    }

    public /* bridge */ /* synthetic */ IccFileHandler getIccFileHandler() {
        return super.getIccFileHandler();
    }

    public /* bridge */ /* synthetic */ IccPhoneBookInterfaceManager getIccPhoneBookInterfaceManager() {
        return super.getIccPhoneBookInterfaceManager();
    }

    public /* bridge */ /* synthetic */ boolean getIccRecordsLoaded() {
        return super.getIccRecordsLoaded();
    }

    public /* bridge */ /* synthetic */ String getIccSerialNumber() {
        return super.getIccSerialNumber();
    }

    public /* bridge */ /* synthetic */ String getImei() {
        return super.getImei();
    }

    public /* bridge */ /* synthetic */ String getLine1AlphaTag() {
        return super.getLine1AlphaTag();
    }

    public /* bridge */ /* synthetic */ String getMeid() {
        return super.getMeid();
    }

    public /* bridge */ /* synthetic */ boolean getMessageWaitingIndicator() {
        return super.getMessageWaitingIndicator();
    }

    public /* bridge */ /* synthetic */ int getPhoneType() {
        return super.getPhoneType();
    }

    public /* bridge */ /* synthetic */ SignalStrength getSignalStrength() {
        return super.getSignalStrength();
    }

    public /* bridge */ /* synthetic */ String getSubscriberId() {
        return super.getSubscriberId();
    }

    public /* bridge */ /* synthetic */ String getVoiceMailAlphaTag() {
        return super.getVoiceMailAlphaTag();
    }

    public /* bridge */ /* synthetic */ String getVoiceMailNumber() {
        return super.getVoiceMailNumber();
    }

    public /* bridge */ /* synthetic */ boolean handlePinMmi(String str) {
        return super.handlePinMmi(str);
    }

    public /* bridge */ /* synthetic */ boolean isDataAllowed() {
        return super.isDataAllowed();
    }

    public /* bridge */ /* synthetic */ boolean isUserDataEnabled() {
        return super.isUserDataEnabled();
    }

    public /* bridge */ /* synthetic */ void migrateFrom(Phone phone) {
        super.migrateFrom(phone);
    }

    public /* bridge */ /* synthetic */ boolean needsOtaServiceProvisioning() {
        return super.needsOtaServiceProvisioning();
    }

    public /* bridge */ /* synthetic */ void notifyCallForwardingIndicator() {
        super.notifyCallForwardingIndicator();
    }

    public /* bridge */ /* synthetic */ void notifyDisconnect(Connection connection) {
        super.notifyDisconnect(connection);
    }

    public /* bridge */ /* synthetic */ void notifyImsReason(ImsReasonInfo imsReasonInfo) {
        super.notifyImsReason(imsReasonInfo);
    }

    public /* bridge */ /* synthetic */ void notifyPhoneStateChanged() {
        super.notifyPhoneStateChanged();
    }

    public /* bridge */ /* synthetic */ void notifyPreciseCallStateChanged() {
        super.notifyPreciseCallStateChanged();
    }

    public /* bridge */ /* synthetic */ void notifySuppServiceFailed(PhoneInternalInterface.SuppService suppService) {
        super.notifySuppServiceFailed(suppService);
    }

    public /* bridge */ /* synthetic */ void onCallQualityChanged(CallQuality callQuality, int i) {
        super.onCallQualityChanged(callQuality, i);
    }

    public /* bridge */ /* synthetic */ void onTtyModeReceived(int i) {
        super.onTtyModeReceived(i);
    }

    public /* bridge */ /* synthetic */ void registerForOnHoldTone(Handler handler, int i, Object obj) {
        super.registerForOnHoldTone(handler, i, obj);
    }

    public /* bridge */ /* synthetic */ void registerForRingbackTone(Handler handler, int i, Object obj) {
        super.registerForRingbackTone(handler, i, obj);
    }

    public /* bridge */ /* synthetic */ void registerForTtyModeReceived(Handler handler, int i, Object obj) {
        super.registerForTtyModeReceived(handler, i, obj);
    }

    public /* bridge */ /* synthetic */ void selectNetworkManually(OperatorInfo operatorInfo, boolean z, Message message) {
        super.selectNetworkManually(operatorInfo, z, message);
    }

    public /* bridge */ /* synthetic */ void setCellBroadcastSmsConfig(int[] iArr, Message message) {
        super.setCellBroadcastSmsConfig(iArr, message);
    }

    public /* bridge */ /* synthetic */ void setDataRoamingEnabled(boolean z) {
        super.setDataRoamingEnabled(z);
    }

    public /* bridge */ /* synthetic */ boolean setLine1Number(String str, String str2, Message message) {
        return super.setLine1Number(str, str2, message);
    }

    public /* bridge */ /* synthetic */ void setNetworkSelectionModeAutomatic(Message message) {
        super.setNetworkSelectionModeAutomatic(message);
    }

    public /* bridge */ /* synthetic */ void setRadioPower(boolean z) {
        super.setRadioPower(z);
    }

    public /* bridge */ /* synthetic */ void setVoiceMailNumber(String str, String str2, Message message) {
        super.setVoiceMailNumber(str, str2, message);
    }

    public /* bridge */ /* synthetic */ void startNetworkScan(NetworkScanRequest networkScanRequest, Message message) {
        super.startNetworkScan(networkScanRequest, message);
    }

    @VisibleForTesting
    public /* bridge */ /* synthetic */ void startOnHoldTone(Connection connection) {
        super.startOnHoldTone(connection);
    }

    public /* bridge */ /* synthetic */ void startRingbackTone() {
        super.startRingbackTone();
    }

    public /* bridge */ /* synthetic */ void stopNetworkScan(Message message) {
        super.stopNetworkScan(message);
    }

    public /* bridge */ /* synthetic */ void stopOnHoldTone(Connection connection) {
        super.stopOnHoldTone(connection);
    }

    public /* bridge */ /* synthetic */ void stopRingbackTone() {
        super.stopRingbackTone();
    }

    public /* bridge */ /* synthetic */ void unregisterForOnHoldTone(Handler handler) {
        super.unregisterForOnHoldTone(handler);
    }

    public /* bridge */ /* synthetic */ void unregisterForRingbackTone(Handler handler) {
        super.unregisterForRingbackTone(handler);
    }

    public /* bridge */ /* synthetic */ void unregisterForTtyModeReceived(Handler handler) {
        super.unregisterForTtyModeReceived(handler);
    }

    public /* bridge */ /* synthetic */ void updateServiceLocation() {
        super.updateServiceLocation();
    }

    public static class ImsDialArgs extends PhoneInternalInterface.DialArgs {
        public final boolean isWpsCall;
        public final int retryCallFailCause;
        public final int retryCallFailNetworkType;
        public final Connection.RttTextStream rttTextStream;

        public static class Builder extends PhoneInternalInterface.DialArgs.Builder<Builder> {
            /* access modifiers changed from: private */
            public boolean mIsWpsCall = false;
            /* access modifiers changed from: private */
            public int mRetryCallFailCause = 0;
            /* access modifiers changed from: private */
            public int mRetryCallFailNetworkType = 0;
            /* access modifiers changed from: private */
            public Connection.RttTextStream mRttTextStream;

            public static Builder from(PhoneInternalInterface.DialArgs dialArgs) {
                if (!(dialArgs instanceof ImsDialArgs)) {
                    return (Builder) ((Builder) ((Builder) ((Builder) ((Builder) new Builder().setUusInfo(dialArgs.uusInfo)).setIsEmergency(dialArgs.isEmergency)).setVideoState(dialArgs.videoState)).setClirMode(dialArgs.clirMode)).setIntentExtras(dialArgs.intentExtras);
                }
                ImsDialArgs imsDialArgs = (ImsDialArgs) dialArgs;
                return ((Builder) ((Builder) ((Builder) ((Builder) ((Builder) new Builder().setUusInfo(dialArgs.uusInfo)).setIsEmergency(dialArgs.isEmergency)).setVideoState(dialArgs.videoState)).setIntentExtras(dialArgs.intentExtras)).setRttTextStream(imsDialArgs.rttTextStream).setClirMode(dialArgs.clirMode)).setRetryCallFailCause(imsDialArgs.retryCallFailCause).setRetryCallFailNetworkType(imsDialArgs.retryCallFailNetworkType).setIsWpsCall(imsDialArgs.isWpsCall);
            }

            public Builder setRttTextStream(Connection.RttTextStream rttTextStream) {
                this.mRttTextStream = rttTextStream;
                return this;
            }

            public Builder setRetryCallFailCause(int i) {
                this.mRetryCallFailCause = i;
                return this;
            }

            public Builder setRetryCallFailNetworkType(int i) {
                this.mRetryCallFailNetworkType = i;
                return this;
            }

            public Builder setIsWpsCall(boolean z) {
                this.mIsWpsCall = z;
                return this;
            }

            public ImsDialArgs build() {
                return new ImsDialArgs(this);
            }
        }

        private ImsDialArgs(Builder builder) {
            super(builder);
            this.rttTextStream = builder.mRttTextStream;
            this.retryCallFailCause = builder.mRetryCallFailCause;
            this.retryCallFailNetworkType = builder.mRetryCallFailNetworkType;
            this.isWpsCall = builder.mIsWpsCall;
        }
    }

    public void setCurrentSubscriberUris(Uri[] uriArr) {
        this.mCurrentSubscriberUris = uriArr;
    }

    public Uri[] getCurrentSubscriberUris() {
        return this.mCurrentSubscriberUris;
    }

    public void setCallComposerStatus(int i) {
        SharedPreferences.Editor edit = this.mImsPhoneSharedPreferences.edit();
        edit.putInt(PREF_USER_SET_CALL_COMPOSER_PREFIX + getSubId(), i).commit();
    }

    public int getCallComposerStatus() {
        SharedPreferences sharedPreferences = this.mImsPhoneSharedPreferences;
        return sharedPreferences.getInt(PREF_USER_SET_CALL_COMPOSER_PREFIX + getSubId(), 0);
    }

    public int getEmergencyNumberDbVersion() {
        return getEmergencyNumberTracker().getEmergencyNumberDbVersion();
    }

    public EmergencyNumberTracker getEmergencyNumberTracker() {
        return this.mDefaultPhone.getEmergencyNumberTracker();
    }

    public ServiceStateTracker getServiceStateTracker() {
        return this.mDefaultPhone.getServiceStateTracker();
    }

    protected static class Cf {
        public final boolean mIsCfu;
        public final Message mOnComplete;
        public final String mSetCfNumber;

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public Cf(String str, boolean z, Message message) {
            this.mSetCfNumber = str;
            this.mIsCfu = z;
            this.mOnComplete = message;
        }
    }

    @VisibleForTesting
    public static class SS {
        int mCfAction;
        public int mCfReason;
        int mClirMode;
        public String mDialingNumber;
        boolean mEnable;
        String mFacility;
        boolean mLockState;
        @VisibleForTesting
        public Message mOnComplete;
        String mPassword;
        public int mServiceClass;
        int mTimerSeconds;

        SS(Message message) {
            this.mOnComplete = message;
        }

        SS(boolean z, Message message) {
            this.mEnable = z;
            this.mOnComplete = message;
        }

        SS(int i, Message message) {
            this.mClirMode = i;
            this.mOnComplete = message;
        }

        SS(boolean z, int i, Message message) {
            this.mEnable = z;
            this.mServiceClass = i;
            this.mOnComplete = message;
        }

        SS(int i, int i2, Message message) {
            this.mCfReason = i;
            this.mServiceClass = i2;
            this.mOnComplete = message;
        }

        SS(int i, int i2, String str, int i3, int i4, Message message) {
            this.mCfAction = i;
            this.mCfReason = i2;
            this.mDialingNumber = str;
            this.mServiceClass = i3;
            this.mTimerSeconds = i4;
            this.mOnComplete = message;
        }

        SS(String str, String str2, int i, Message message) {
            this.mFacility = str;
            this.mPassword = str2;
            this.mServiceClass = i;
            this.mOnComplete = message;
        }

        SS(String str, boolean z, String str2, int i, Message message) {
            this.mFacility = str;
            this.mLockState = z;
            this.mPassword = str2;
            this.mServiceClass = i;
            this.mOnComplete = message;
        }
    }

    public ImsPhone(Context context, PhoneNotifier phoneNotifier, Phone phone) {
        this(context, phoneNotifier, phone, new ImsPhone$$ExternalSyntheticLambda5(), false);
    }

    @VisibleForTesting
    public ImsPhone(Context context, PhoneNotifier phoneNotifier, Phone phone, ImsManagerFactory imsManagerFactory, boolean z) {
        super(LOG_TAG, context, phoneNotifier, z);
        this.mPendingMMIs = new ArrayList<>();
        this.mSS = new ServiceState();
        this.mSilentRedialRegistrants = new RegistrantList();
        this.mRegLocalLog = new LocalLog(64);
        this.mLastKnownRoamingState = false;
        this.mIsInImsEcm = false;
        this.mSsnRegistrants = new RegistrantList();
        this.mExitEcmRunnable = new Runnable() {
            public void run() {
                ImsPhone.this.exitEmergencyCallbackMode();
            }
        };
        this.mImsEcbmStateListener = new ImsEcbmStateListener(this.mContext.getMainExecutor()) {
            public void onECBMEntered(Executor executor) {
                ImsPhone.this.logd("onECBMEntered");
                TelephonyUtils.runWithCleanCallingIdentity(new ImsPhone$2$$ExternalSyntheticLambda1(this), executor);
            }

            /* access modifiers changed from: private */
            public /* synthetic */ void lambda$onECBMEntered$0() {
                ImsPhone.this.handleEnterEmergencyCallbackMode();
            }

            public void onECBMExited(Executor executor) {
                ImsPhone.this.logd("onECBMExited");
                TelephonyUtils.runWithCleanCallingIdentity(new ImsPhone$2$$ExternalSyntheticLambda0(this), executor);
            }

            /* access modifiers changed from: private */
            public /* synthetic */ void lambda$onECBMExited$1() {
                ImsPhone.this.handleExitEmergencyCallbackMode();
            }
        };
        this.mResultReceiver = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if (getResultCode() == -1) {
                    CharSequence charSequenceExtra = intent.getCharSequenceExtra(Phone.EXTRA_KEY_ALERT_TITLE);
                    CharSequence charSequenceExtra2 = intent.getCharSequenceExtra(Phone.EXTRA_KEY_ALERT_MESSAGE);
                    CharSequence charSequenceExtra3 = intent.getCharSequenceExtra(Phone.EXTRA_KEY_NOTIFICATION_MESSAGE);
                    Intent intent2 = new Intent("android.intent.action.MAIN");
                    intent2.setClassName("com.android.settings", "com.android.settings.Settings$WifiCallingSettingsActivity");
                    intent2.putExtra(Phone.EXTRA_KEY_ALERT_SHOW, true);
                    intent2.putExtra(Phone.EXTRA_KEY_ALERT_TITLE, charSequenceExtra);
                    intent2.putExtra(Phone.EXTRA_KEY_ALERT_MESSAGE, charSequenceExtra2);
                    ((NotificationManager) ImsPhone.this.mContext.getSystemService("notification")).notify("wifi_calling", 1, new Notification.Builder(ImsPhone.this.mContext).setSmallIcon(17301642).setContentTitle(charSequenceExtra).setContentText(charSequenceExtra3).setAutoCancel(true).setContentIntent(PendingIntent.getActivity(ImsPhone.this.mContext, 0, intent2, 201326592)).setStyle(new Notification.BigTextStyle().bigText(charSequenceExtra3)).setChannelId(NotificationChannelController.CHANNEL_ID_WFC).build());
                }
            }
        };
        this.mMmTelRegistrationUpdate = new ImsRegistrationCallbackHelper.ImsRegistrationUpdate() {
            public void handleImsRegistered(int i) {
                ImsPhone imsPhone = ImsPhone.this;
                imsPhone.logd("handleImsRegistered: onImsMmTelConnected imsRadioTech=" + AccessNetworkConstants.transportTypeToString(i));
                LocalLog r0 = ImsPhone.this.mRegLocalLog;
                r0.log("handleImsRegistered: onImsMmTelConnected imsRadioTech=" + AccessNetworkConstants.transportTypeToString(i));
                ImsPhone.this.setServiceState(0);
                ImsPhone.this.getDefaultPhone().setImsRegistrationState(true);
                ImsPhone.this.mMetrics.writeOnImsConnectionState(ImsPhone.this.mPhoneId, 1, (ImsReasonInfo) null);
                ImsPhone.this.mImsStats.onImsRegistered(i);
            }

            public void handleImsRegistering(int i) {
                ImsPhone imsPhone = ImsPhone.this;
                imsPhone.logd("handleImsRegistering: onImsMmTelProgressing imsRadioTech=" + AccessNetworkConstants.transportTypeToString(i));
                LocalLog r0 = ImsPhone.this.mRegLocalLog;
                r0.log("handleImsRegistering: onImsMmTelProgressing imsRadioTech=" + AccessNetworkConstants.transportTypeToString(i));
                ImsPhone.this.setServiceState(1);
                ImsPhone.this.getDefaultPhone().setImsRegistrationState(false);
                ImsPhone.this.mMetrics.writeOnImsConnectionState(ImsPhone.this.mPhoneId, 2, (ImsReasonInfo) null);
                ImsPhone.this.mImsStats.onImsRegistering(i);
            }

            public void handleImsUnregistered(ImsReasonInfo imsReasonInfo) {
                ImsPhone imsPhone = ImsPhone.this;
                imsPhone.logd("handleImsUnregistered: onImsMmTelDisconnected imsReasonInfo=" + imsReasonInfo);
                LocalLog r0 = ImsPhone.this.mRegLocalLog;
                r0.log("handleImsUnregistered: onImsMmTelDisconnected imsRadioTech=" + imsReasonInfo);
                ImsPhone.this.setServiceState(1);
                ImsPhone.this.processDisconnectReason(imsReasonInfo);
                ImsPhone.this.getDefaultPhone().setImsRegistrationState(false);
                ImsPhone.this.mMetrics.writeOnImsConnectionState(ImsPhone.this.mPhoneId, 3, imsReasonInfo);
                ImsPhone.this.mImsStats.onImsUnregistered(imsReasonInfo);
            }

            public void handleImsSubscriberAssociatedUriChanged(Uri[] uriArr) {
                ImsPhone.this.logd("handleImsSubscriberAssociatedUriChanged");
                ImsPhone.this.setCurrentSubscriberUris(uriArr);
                ImsPhone.this.setPhoneNumberForSourceIms(uriArr);
            }
        };
        this.mDefaultPhone = phone;
        this.mImsManagerFactory = imsManagerFactory;
        this.mImsPhoneSharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        this.mImsStats = new ImsStats(this);
        this.mExternalCallTracker = TelephonyComponentFactory.getInstance().inject(ImsExternalCallTracker.class.getName()).makeImsExternalCallTracker(this);
        ImsPhoneCallTracker makeImsPhoneCallTracker = TelephonyComponentFactory.getInstance().inject(ImsPhoneCallTracker.class.getName()).makeImsPhoneCallTracker(this);
        this.mCT = makeImsPhoneCallTracker;
        makeImsPhoneCallTracker.registerPhoneStateListener(this.mExternalCallTracker);
        this.mExternalCallTracker.setCallPuller(this.mCT);
        this.mSS.setOutOfService(this.mDefaultPhone.getAccessNetworksManager() != null ? this.mDefaultPhone.getAccessNetworksManager().isInLegacyMode() : true, false);
        this.mPhoneId = this.mDefaultPhone.getPhoneId();
        this.mMetrics = TelephonyMetrics.getInstance();
        this.mImsMmTelRegistrationHelper = new ImsRegistrationCallbackHelper(this.mMmTelRegistrationUpdate, context.getMainExecutor());
        PowerManager.WakeLock newWakeLock = ((PowerManager) context.getSystemService(XmlTagConst.TAG_POWER)).newWakeLock(1, LOG_TAG);
        this.mWakeLock = newWakeLock;
        newWakeLock.setReferenceCounted(false);
        if (!(this.mDefaultPhone.getServiceStateTracker() == null || this.mDefaultPhone.getAccessNetworksManager() == null)) {
            for (int registerForDataRegStateOrRatChanged : this.mDefaultPhone.getAccessNetworksManager().getAvailableTransports()) {
                this.mDefaultPhone.getServiceStateTracker().registerForDataRegStateOrRatChanged(registerForDataRegStateOrRatChanged, this, 71, (Object) null);
            }
        }
        setServiceState(1);
        this.mDefaultPhone.registerForServiceStateChanged(this, 72, (Object) null);
        this.mDefaultPhone.registerForVolteSilentRedial(this, 74, (Object) null);
    }

    public void dispose() {
        logd("dispose");
        this.mPendingMMIs.clear();
        this.mExternalCallTracker.tearDown();
        this.mCT.unregisterPhoneStateListener(this.mExternalCallTracker);
        this.mCT.unregisterForVoiceCallEnded(this);
        this.mCT.dispose();
        Phone phone = this.mDefaultPhone;
        if (!(phone == null || phone.getServiceStateTracker() == null)) {
            for (int unregisterForDataRegStateOrRatChanged : this.mDefaultPhone.getAccessNetworksManager().getAvailableTransports()) {
                this.mDefaultPhone.getServiceStateTracker().unregisterForDataRegStateOrRatChanged(unregisterForDataRegStateOrRatChanged, this);
            }
            this.mDefaultPhone.unregisterForServiceStateChanged(this);
        }
        Phone phone2 = this.mDefaultPhone;
        if (phone2 != null) {
            phone2.unregisterForVolteSilentRedial(this);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ServiceState getServiceState() {
        return new ServiceState(this.mSS);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @VisibleForTesting
    public void setServiceState(int i) {
        boolean z;
        synchronized (this) {
            z = this.mSS.getState() != i;
            this.mSS.setVoiceRegState(i);
        }
        updateDataServiceState();
        if (z && this.mDefaultPhone.getServiceStateTracker() != null) {
            this.mDefaultPhone.getServiceStateTracker().onImsServiceStateChanged();
        }
    }

    public CallTracker getCallTracker() {
        return this.mCT;
    }

    public ImsExternalCallTracker getExternalCallTracker() {
        return this.mExternalCallTracker;
    }

    public List<? extends ImsPhoneMmiCode> getPendingMmiCodes() {
        return this.mPendingMMIs;
    }

    public void acceptCall(int i) throws CallStateException {
        this.mCT.acceptCall(i);
    }

    public void rejectCall() throws CallStateException {
        this.mCT.rejectCall();
    }

    public void switchHoldingAndActive() throws CallStateException {
        throw new UnsupportedOperationException("Use hold() and unhold() instead.");
    }

    public boolean canConference() {
        return this.mCT.canConference();
    }

    public boolean canDial() {
        try {
            this.mCT.checkForDialIssues();
            return true;
        } catch (CallStateException unused) {
            return false;
        }
    }

    public void conference() {
        this.mCT.conference();
    }

    public void clearDisconnected() {
        this.mCT.clearDisconnected();
    }

    public boolean canTransfer() {
        return this.mCT.canTransfer();
    }

    public void explicitCallTransfer() throws CallStateException {
        this.mCT.explicitCallTransfer();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCall getForegroundCall() {
        return this.mCT.mForegroundCall;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCall getBackgroundCall() {
        return this.mCT.mBackgroundCall;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCall getRingingCall() {
        return this.mCT.mRingingCall;
    }

    public boolean isImsAvailable() {
        return this.mCT.isImsServiceReady();
    }

    public CarrierPrivilegesTracker getCarrierPrivilegesTracker() {
        return this.mDefaultPhone.getCarrierPrivilegesTracker();
    }

    public void holdActiveCall() throws CallStateException {
        this.mCT.holdActiveCall();
    }

    public void unholdHeldCall() throws CallStateException {
        this.mCT.unholdHeldCall();
    }

    private boolean handleCallDeflectionIncallSupplementaryService(String str) {
        if (str.length() > 1) {
            return false;
        }
        Call.State state = getRingingCall().getState();
        Call.State state2 = Call.State.IDLE;
        if (state != state2) {
            logd("MmiCode 0: rejectCall");
            try {
                this.mCT.rejectCall();
            } catch (CallStateException e) {
                Rlog.d(LOG_TAG, "reject failed", e);
                notifySuppServiceFailed(PhoneInternalInterface.SuppService.REJECT);
            }
        } else if (getBackgroundCall().getState() != state2) {
            logd("MmiCode 0: hangupWaitingOrBackground");
            try {
                this.mCT.hangup(getBackgroundCall());
            } catch (CallStateException e2) {
                Rlog.d(LOG_TAG, "hangup failed", e2);
            }
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public void sendUssdResponse(String str, CharSequence charSequence, int i, ResultReceiver resultReceiver) {
        UssdResponse ussdResponse = new UssdResponse(str, charSequence);
        Bundle bundle = new Bundle();
        bundle.putParcelable("USSD_RESPONSE", ussdResponse);
        resultReceiver.send(i, bundle);
    }

    public boolean handleUssdRequest(String str, ResultReceiver resultReceiver) throws CallStateException {
        if (this.mPendingMMIs.size() > 0) {
            logi("handleUssdRequest: queue full: " + Rlog.pii(LOG_TAG, str));
            sendUssdResponse(str, (CharSequence) null, -1, resultReceiver);
            return true;
        }
        try {
            dialInternal(str, new ImsDialArgs.Builder().build(), resultReceiver);
        } catch (CallStateException e) {
            if (!Phone.CS_FALLBACK.equals(e.getMessage())) {
                Rlog.w(LOG_TAG, "Could not execute USSD " + e);
                sendUssdResponse(str, (CharSequence) null, -1, resultReceiver);
            } else {
                throw e;
            }
        } catch (Exception e2) {
            Rlog.w(LOG_TAG, "Could not execute USSD " + e2);
            sendUssdResponse(str, (CharSequence) null, -1, resultReceiver);
            return false;
        }
        return true;
    }

    private boolean handleCallWaitingIncallSupplementaryService(String str) {
        int length = str.length();
        if (length > 2) {
            return false;
        }
        ImsPhoneCall foregroundCall = getForegroundCall();
        if (length > 1) {
            try {
                logd("not support 1X SEND");
                notifySuppServiceFailed(PhoneInternalInterface.SuppService.HANGUP);
            } catch (CallStateException e) {
                Rlog.d(LOG_TAG, "hangup failed", e);
                notifySuppServiceFailed(PhoneInternalInterface.SuppService.HANGUP);
            }
        } else if (foregroundCall.getState() != Call.State.IDLE) {
            logd("MmiCode 1: hangup foreground");
            this.mCT.hangup(foregroundCall);
        } else {
            logd("MmiCode 1: holdActiveCallForWaitingCall");
            this.mCT.holdActiveCallForWaitingCall();
        }
        return true;
    }

    private boolean handleCallHoldIncallSupplementaryService(String str) {
        int length = str.length();
        if (length > 2) {
            return false;
        }
        if (length > 1) {
            logd("separate not supported");
            notifySuppServiceFailed(PhoneInternalInterface.SuppService.SEPARATE);
        } else {
            try {
                Call.State state = getRingingCall().getState();
                Call.State state2 = Call.State.IDLE;
                if (state != state2) {
                    logd("MmiCode 2: accept ringing call");
                    this.mCT.acceptCall(0);
                } else if (getBackgroundCall().getState() == Call.State.HOLDING) {
                    if (getForegroundCall().getState() != state2) {
                        logd("MmiCode 2: switch holding and active");
                        this.mCT.holdActiveCall();
                    } else {
                        logd("MmiCode 2: unhold held call");
                        this.mCT.unholdHeldCall();
                    }
                } else if (getForegroundCall().getState() != state2) {
                    logd("MmiCode 2: hold active call");
                    this.mCT.holdActiveCall();
                }
            } catch (CallStateException e) {
                Rlog.d(LOG_TAG, "switch failed", e);
                notifySuppServiceFailed(PhoneInternalInterface.SuppService.SWITCH);
            }
        }
        return true;
    }

    private boolean handleMultipartyIncallSupplementaryService(String str) {
        if (str.length() > 1) {
            return false;
        }
        logd("MmiCode 3: merge calls");
        conference();
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean handleEctIncallSupplementaryService(String str) {
        if (str.length() != 1) {
            return false;
        }
        logd("MmiCode 4: explicit call transfer");
        try {
            explicitCallTransfer();
        } catch (CallStateException e) {
            Rlog.d(LOG_TAG, "explicit call transfer failed", e);
            notifySuppServiceFailed(PhoneInternalInterface.SuppService.TRANSFER);
        }
        return true;
    }

    private boolean handleCcbsIncallSupplementaryService(String str) {
        if (str.length() > 1) {
            return false;
        }
        logi("MmiCode 5: CCBS not supported!");
        notifySuppServiceFailed(PhoneInternalInterface.SuppService.UNKNOWN);
        return true;
    }

    public void notifySuppSvcNotification(SuppServiceNotification suppServiceNotification) {
        logd("notifySuppSvcNotification: suppSvc = " + suppServiceNotification);
        this.mSsnRegistrants.notifyRegistrants(new AsyncResult((Object) null, suppServiceNotification, (Throwable) null));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean handleInCallMmiCommands(String str) {
        if (!isInCall() || TextUtils.isEmpty(str)) {
            return false;
        }
        switch (str.charAt(0)) {
            case '0':
                return handleCallDeflectionIncallSupplementaryService(str);
            case '1':
                return handleCallWaitingIncallSupplementaryService(str);
            case '2':
                return handleCallHoldIncallSupplementaryService(str);
            case '3':
                return handleMultipartyIncallSupplementaryService(str);
            case '4':
                return handleEctIncallSupplementaryService(str);
            case '5':
                return handleCcbsIncallSupplementaryService(str);
            default:
                return false;
        }
    }

    public boolean isInCall() {
        return getForegroundCall().getState().isAlive() || getBackgroundCall().getState().isAlive() || getRingingCall().getState().isAlive();
    }

    public boolean isInImsEcm() {
        return this.mIsInImsEcm;
    }

    public boolean isInEcm() {
        return this.mDefaultPhone.isInEcm();
    }

    public void setIsInEcm(boolean z) {
        this.mIsInImsEcm = z;
        this.mDefaultPhone.setIsInEcm(z);
    }

    public void notifyNewRingingConnection(com.android.internal.telephony.Connection connection) {
        this.mDefaultPhone.notifyNewRingingConnectionP(connection);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void notifyUnknownConnection(com.android.internal.telephony.Connection connection) {
        this.mDefaultPhone.notifyUnknownConnectionP(connection);
    }

    public void notifyForVideoCapabilityChanged(boolean z) {
        this.mIsVideoCapable = z;
        this.mDefaultPhone.notifyForVideoCapabilityChanged(z);
    }

    public void setRadioPower(boolean z, boolean z2, boolean z3, boolean z4) {
        this.mDefaultPhone.setRadioPower(z, z2, z3, z4);
    }

    public com.android.internal.telephony.Connection startConference(String[] strArr, PhoneInternalInterface.DialArgs dialArgs) throws CallStateException {
        return this.mCT.startConference(strArr, ImsDialArgs.Builder.from(dialArgs).build());
    }

    public com.android.internal.telephony.Connection dial(String str, PhoneInternalInterface.DialArgs dialArgs, Consumer<Phone> consumer) throws CallStateException {
        consumer.accept(this);
        return dialInternal(str, dialArgs, (ResultReceiver) null);
    }

    /* access modifiers changed from: protected */
    public com.android.internal.telephony.Connection dialInternal(String str, PhoneInternalInterface.DialArgs dialArgs, ResultReceiver resultReceiver) throws CallStateException {
        this.mLastDialString = str;
        String stripSeparators = PhoneNumberUtils.stripSeparators(str);
        if (handleInCallMmiCommands(stripSeparators)) {
            return null;
        }
        ImsDialArgs.Builder from = ImsDialArgs.Builder.from(dialArgs);
        from.setClirMode(this.mCT.getClirMode());
        if (this.mDefaultPhone.getPhoneType() == 2) {
            return this.mCT.dial(str, from.build());
        }
        ImsPhoneMmiCode newFromDialString = ImsPhoneMmiCode.newFromDialString(PhoneNumberUtils.extractNetworkPortionAlt(stripSeparators), this, resultReceiver);
        logd("dialInternal: dialing w/ mmi '" + newFromDialString + "'...");
        if (newFromDialString == null) {
            return this.mCT.dial(str, from.build());
        }
        if (newFromDialString.isTemporaryModeCLIR()) {
            from.setClirMode(newFromDialString.getCLIRMode());
            return this.mCT.dial(newFromDialString.getDialingNumber(), from.build());
        } else if (newFromDialString.isSupportedOverImsPhone()) {
            this.mPendingMMIs.add(newFromDialString);
            this.mMmiRegistrants.notifyRegistrants(new AsyncResult((Object) null, newFromDialString, (Throwable) null));
            try {
                newFromDialString.processCode();
            } catch (CallStateException e) {
                if (Phone.CS_FALLBACK.equals(e.getMessage())) {
                    logi("dialInternal: fallback to GSM required.");
                    this.mPendingMMIs.remove(newFromDialString);
                    throw e;
                }
            }
            return null;
        } else {
            logi("dialInternal: USSD not supported by IMS; fallback to CS.");
            throw new CallStateException(Phone.CS_FALLBACK);
        }
    }

    public void sendDtmf(char c) {
        if (!PhoneNumberUtils.is12Key(c)) {
            loge("sendDtmf called with invalid character '" + c + "'");
        } else if (this.mCT.getState() == PhoneConstants.State.OFFHOOK) {
            this.mCT.sendDtmf(c, (Message) null);
        }
    }

    public void startDtmf(char c) {
        if (PhoneNumberUtils.is12Key(c) || (c >= 'A' && c <= 'D')) {
            this.mCT.startDtmf(c);
            return;
        }
        loge("startDtmf called with invalid character '" + c + "'");
    }

    public void stopDtmf() {
        this.mCT.stopDtmf();
    }

    public void notifyIncomingRing() {
        logd("notifyIncomingRing");
        sendMessage(obtainMessage(14, new AsyncResult((Object) null, (Object) null, (Throwable) null)));
    }

    public void setMute(boolean z) {
        this.mCT.setMute(z);
    }

    public void setTTYMode(int i, Message message) {
        this.mCT.setTtyMode(i);
    }

    public void setUiTTYMode(int i, Message message) {
        this.mCT.setUiTTYMode(i, message);
    }

    public boolean getMute() {
        return this.mCT.getMute();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public PhoneConstants.State getState() {
        return this.mCT.getState();
    }

    public void getOutgoingCallerIdDisplay(Message message) {
        logd("getCLIR");
        try {
            this.mCT.getUtInterface().queryCLIR(obtainMessage(70, new SS(message)));
        } catch (ImsException e) {
            sendErrorResponse(message, e);
        }
    }

    public void setOutgoingCallerIdDisplay(int i, Message message) {
        logd("setCLIR action= " + i);
        try {
            this.mCT.getUtInterface().updateCLIR(i, obtainMessage(69, new SS(i, message)));
        } catch (ImsException e) {
            sendErrorResponse(message, e);
        }
    }

    public void queryCLIP(Message message) {
        Message obtainMessage = obtainMessage(75, new SS(message));
        try {
            Rlog.d(LOG_TAG, "ut.queryCLIP");
            this.mCT.getUtInterface().queryCLIP(obtainMessage);
        } catch (ImsException e) {
            sendErrorResponse(message, e);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void getCallForwardingOption(int i, Message message) {
        getCallForwardingOption(i, 1, message);
    }

    public void getCallForwardingOption(int i, int i2, Message message) {
        logd("getCallForwardingOption reason=" + i);
        if (isValidCommandInterfaceCFReason(i)) {
            logd("requesting call forwarding query.");
            try {
                this.mCT.getUtInterface().queryCallForward(getConditionFromCFReason(i), (String) null, obtainMessage(13, new SS(i, i2, message)));
            } catch (ImsException e) {
                sendErrorResponse(message, e);
            }
        } else if (message != null) {
            sendErrorResponse(message);
        }
    }

    public void setCallForwardingOption(int i, int i2, String str, int i3, Message message) {
        setCallForwardingOption(i, i2, str, 1, i3, message);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setCallForwardingOption(int i, int i2, String str, int i3, int i4, Message message) {
        logd("setCallForwardingOption action=" + i + ", reason=" + i2 + " serviceClass=" + i3);
        if (isValidCommandInterfaceCFAction(i) && isValidCommandInterfaceCFReason(i2)) {
            try {
                this.mCT.getUtInterface().updateCallForward(getActionFromCFAction(i), getConditionFromCFReason(i2), str, i3, i4, obtainMessage(12, new SS(i, i2, str, i3, i4, message)));
            } catch (ImsException e) {
                sendErrorResponse(message, e);
            }
        } else if (message != null) {
            sendErrorResponse(message);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void getCallWaiting(Message message) {
        logd("getCallWaiting");
        try {
            this.mCT.getUtInterface().queryCallWaiting(obtainMessage(68, new SS(message)));
        } catch (ImsException e) {
            sendErrorResponse(message, e);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setCallWaiting(boolean z, Message message) {
        PersistableBundle configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId());
        int i = 1;
        if (configForSubId != null) {
            i = configForSubId.getInt("call_waiting_service_class_int", 1);
        }
        setCallWaiting(z, i, message);
    }

    public void setCallWaiting(boolean z, int i, Message message) {
        logd("setCallWaiting enable=" + z);
        try {
            this.mCT.getUtInterface().updateCallWaiting(z, i, obtainMessage(67, new SS(z, i, message)));
        } catch (ImsException e) {
            sendErrorResponse(message, e);
        }
    }

    /* access modifiers changed from: protected */
    public int getCBTypeFromFacility(String str) {
        if (CommandsInterface.CB_FACILITY_BAOC.equals(str)) {
            return 2;
        }
        if (CommandsInterface.CB_FACILITY_BAOIC.equals(str)) {
            return 3;
        }
        if (CommandsInterface.CB_FACILITY_BAOICxH.equals(str)) {
            return 4;
        }
        if (CommandsInterface.CB_FACILITY_BAIC.equals(str)) {
            return 1;
        }
        if (CommandsInterface.CB_FACILITY_BAICr.equals(str)) {
            return 5;
        }
        if (CommandsInterface.CB_FACILITY_BA_ALL.equals(str)) {
            return 7;
        }
        if (CommandsInterface.CB_FACILITY_BA_MO.equals(str)) {
            return 8;
        }
        if (CommandsInterface.CB_FACILITY_BA_MT.equals(str)) {
            return 9;
        }
        return CommandsInterface.CB_FACILITY_BIC_ACR.equals(str) ? 6 : 0;
    }

    public void getCallBarring(String str, Message message) {
        getCallBarring(str, message, 1);
    }

    public void getCallBarring(String str, Message message, int i) {
        getCallBarring(str, "", message, i);
    }

    public void getCallBarring(String str, String str2, Message message, int i) {
        logd("getCallBarring facility=" + str + ", serviceClass = " + i);
        try {
            this.mCT.getUtInterface().queryCallBarring(getCBTypeFromFacility(str), obtainMessage(66, new SS(str, str2, i, message)), i);
        } catch (ImsException e) {
            sendErrorResponse(message, e);
        }
    }

    public void setCallBarring(String str, boolean z, String str2, Message message) {
        setCallBarring(str, z, str2, message, 1);
    }

    public void setCallBarring(String str, boolean z, String str2, Message message, int i) {
        logd("setCallBarring facility=" + str + ", lockState=" + z + ", serviceClass = " + i);
        Message obtainMessage = obtainMessage(65, new SS(str, z, str2, i, message));
        try {
            this.mCT.getUtInterface().updateCallBarring(getCBTypeFromFacility(str), z ? 1 : 0, obtainMessage, (String[]) null, i, str2);
        } catch (ImsException e) {
            sendErrorResponse(message, e);
        }
    }

    public void sendUssdResponse(String str) {
        logd("sendUssdResponse");
        ImsPhoneMmiCode newFromUssdUserInput = ImsPhoneMmiCode.newFromUssdUserInput(str, this);
        this.mPendingMMIs.add(newFromUssdUserInput);
        this.mMmiRegistrants.notifyRegistrants(new AsyncResult((Object) null, newFromUssdUserInput, (Throwable) null));
        newFromUssdUserInput.sendUssd(str);
    }

    public void sendUSSD(String str, Message message) {
        Rlog.d(LOG_TAG, "sendUssd ussdString = " + str);
        this.mLastDialString = str;
        this.mCT.sendUSSD(str, message);
    }

    public void cancelUSSD(Message message) {
        this.mCT.cancelUSSD(message);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void sendErrorResponse(Message message) {
        logd("sendErrorResponse");
        if (message != null) {
            AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.GENERIC_FAILURE));
            message.sendToTarget();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @VisibleForTesting
    public void sendErrorResponse(Message message, Throwable th) {
        logd("sendErrorResponse");
        if (message != null) {
            AsyncResult.forMessage(message, (Object) null, getCommandException(th));
            message.sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    public CommandException getCommandException(int i, String str) {
        logd("getCommandException code= " + i + ", errorString= " + str);
        CommandException.Error error = CommandException.Error.GENERIC_FAILURE;
        if (i != 241) {
            switch (i) {
                case 801:
                case 803:
                    error = CommandException.Error.REQUEST_NOT_SUPPORTED;
                    break;
                case 802:
                    error = CommandException.Error.RADIO_NOT_AVAILABLE;
                    break;
                default:
                    switch (i) {
                        case 821:
                            error = CommandException.Error.PASSWORD_INCORRECT;
                            break;
                        case 822:
                            error = CommandException.Error.SS_MODIFIED_TO_DIAL;
                            break;
                        case 823:
                            error = CommandException.Error.SS_MODIFIED_TO_USSD;
                            break;
                        case 824:
                            error = CommandException.Error.SS_MODIFIED_TO_SS;
                            break;
                        case 825:
                            error = CommandException.Error.SS_MODIFIED_TO_DIAL_VIDEO;
                            break;
                    }
            }
        } else {
            error = CommandException.Error.FDN_CHECK_FAILURE;
        }
        return new CommandException(error, str);
    }

    /* access modifiers changed from: protected */
    public CommandException getCommandException(Throwable th) {
        if (th instanceof ImsException) {
            return getCommandException(((ImsException) th).getCode(), th.getMessage());
        }
        logd("getCommandException generic failure");
        return new CommandException(CommandException.Error.GENERIC_FAILURE);
    }

    /* access modifiers changed from: protected */
    public void onNetworkInitiatedUssd(ImsPhoneMmiCode imsPhoneMmiCode) {
        logd("onNetworkInitiatedUssd");
        this.mMmiCompleteRegistrants.notifyRegistrants(new AsyncResult((Object) null, imsPhoneMmiCode, (Throwable) null));
    }

    /* access modifiers changed from: protected */
    public void onIncomingUSSD(int i, String str) {
        logd("onIncomingUSSD ussdMode=" + i);
        int i2 = 0;
        boolean z = i == 1;
        boolean z2 = (i == 0 || i == 1) ? false : true;
        ImsPhoneMmiCode imsPhoneMmiCode = null;
        int size = this.mPendingMMIs.size();
        while (true) {
            if (i2 >= size) {
                break;
            } else if (this.mPendingMMIs.get(i2).isPendingUSSD()) {
                imsPhoneMmiCode = this.mPendingMMIs.get(i2);
                break;
            } else {
                i2++;
            }
        }
        if (imsPhoneMmiCode != null) {
            if (z2) {
                imsPhoneMmiCode.onUssdFinishedError();
            } else {
                imsPhoneMmiCode.onUssdFinished(str, z);
            }
        } else if (!z2 && !TextUtils.isEmpty(str)) {
            onNetworkInitiatedUssd(ImsPhoneMmiCode.newNetworkInitiatedUssd(str, z, this));
        } else if (z2) {
            ImsPhoneMmiCode.newNetworkInitiatedUssd(str, true, this).onUssdFinishedError();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void onMMIDone(ImsPhoneMmiCode imsPhoneMmiCode) {
        logd("onMMIDone: mmi=" + imsPhoneMmiCode);
        if (this.mPendingMMIs.remove(imsPhoneMmiCode) || imsPhoneMmiCode.isUssdRequest() || imsPhoneMmiCode.isSsInfo()) {
            ResultReceiver ussdCallbackReceiver = imsPhoneMmiCode.getUssdCallbackReceiver();
            if (ussdCallbackReceiver != null) {
                sendUssdResponse(imsPhoneMmiCode.getDialString(), imsPhoneMmiCode.getMessage(), imsPhoneMmiCode.getState() == MmiCode.State.COMPLETE ? 100 : -1, ussdCallbackReceiver);
                return;
            }
            logv("onMMIDone: notifyRegistrants");
            this.mMmiCompleteRegistrants.notifyRegistrants(new AsyncResult((Object) null, imsPhoneMmiCode, (Throwable) null));
        }
    }

    public ArrayList<com.android.internal.telephony.Connection> getHandoverConnection() {
        ArrayList<com.android.internal.telephony.Connection> arrayList = new ArrayList<>();
        arrayList.addAll(getForegroundCall().getConnections());
        arrayList.addAll(getBackgroundCall().getConnections());
        arrayList.addAll(getRingingCall().getConnections());
        if (arrayList.size() > 0) {
            return arrayList;
        }
        return null;
    }

    public void notifySrvccState(Call.SrvccState srvccState) {
        this.mCT.notifySrvccState(srvccState);
    }

    public void initiateSilentRedial() {
        initiateSilentRedial(false, 0);
    }

    /* access modifiers changed from: package-private */
    public void initiateSilentRedial(boolean z, int i) {
        this.mContext.getMainExecutor().execute(new ImsPhone$$ExternalSyntheticLambda6(this, z, i, new AsyncResult((Object) null, new Phone.SilentRedialParam(this.mLastDialString, CallFailCause.LOCAL_CALL_CS_RETRY_REQUIRED, new PhoneInternalInterface.DialArgs.Builder().setIsEmergency(z).setEccCategory(i).build()), (Throwable) null)));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$initiateSilentRedial$0(boolean z, int i, AsyncResult asyncResult) {
        logd("initiateSilentRedial: notifying registrants, isEmergency=" + z + ", eccCategory=" + i);
        this.mSilentRedialRegistrants.notifyRegistrants(asyncResult);
    }

    public void registerForSilentRedial(Handler handler, int i, Object obj) {
        this.mSilentRedialRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSilentRedial(Handler handler) {
        this.mSilentRedialRegistrants.remove(handler);
    }

    public void registerForSuppServiceNotification(Handler handler, int i, Object obj) {
        this.mSsnRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSuppServiceNotification(Handler handler) {
        this.mSsnRegistrants.remove(handler);
    }

    public int getSubId() {
        return this.mDefaultPhone.getSubId();
    }

    public int getPhoneId() {
        return this.mDefaultPhone.getPhoneId();
    }

    /* access modifiers changed from: protected */
    public CallForwardInfo getCallForwardInfo(ImsCallForwardInfo imsCallForwardInfo) {
        CallForwardInfo callForwardInfo = new CallForwardInfo();
        callForwardInfo.status = imsCallForwardInfo.getStatus();
        callForwardInfo.reason = getCFReasonFromCondition(imsCallForwardInfo.getCondition());
        callForwardInfo.serviceClass = 1;
        callForwardInfo.toa = imsCallForwardInfo.getToA();
        callForwardInfo.number = imsCallForwardInfo.getNumber();
        callForwardInfo.timeSeconds = imsCallForwardInfo.getTimeSeconds();
        return callForwardInfo;
    }

    public String getLine1Number() {
        return this.mDefaultPhone.getLine1Number();
    }

    public CallForwardInfo[] handleCfQueryResult(ImsCallForwardInfo[] imsCallForwardInfoArr) {
        CallForwardInfo[] callForwardInfoArr = (imsCallForwardInfoArr == null || imsCallForwardInfoArr.length == 0) ? null : new CallForwardInfo[imsCallForwardInfoArr.length];
        if (imsCallForwardInfoArr == null || imsCallForwardInfoArr.length == 0) {
            setVoiceCallForwardingFlag(getIccRecords(), 1, false, (String) null);
        } else {
            int length = imsCallForwardInfoArr.length;
            for (int i = 0; i < length; i++) {
                if (imsCallForwardInfoArr[i].getCondition() == 0) {
                    setVoiceCallForwardingFlag(getIccRecords(), 1, imsCallForwardInfoArr[i].getStatus() == 1, imsCallForwardInfoArr[i].getNumber());
                }
                callForwardInfoArr[i] = getCallForwardInfo(imsCallForwardInfoArr[i]);
            }
        }
        return callForwardInfoArr;
    }

    /* access modifiers changed from: protected */
    public int[] handleCbQueryResult(ImsSsInfo[] imsSsInfoArr) {
        int[] iArr = {0};
        if (imsSsInfoArr[0].getStatus() == 1) {
            iArr[0] = 1;
        }
        return iArr;
    }

    /* access modifiers changed from: protected */
    public int[] handleCwQueryResult(ImsSsInfo[] imsSsInfoArr) {
        int[] iArr = new int[2];
        iArr[0] = 0;
        if (imsSsInfoArr[0].getStatus() == 1) {
            iArr[0] = 1;
            iArr[1] = 1;
        }
        return iArr;
    }

    /* access modifiers changed from: protected */
    public void sendResponse(Message message, Object obj, Throwable th) {
        if (message != null) {
            CommandException commandException = null;
            if (th != null) {
                commandException = getCommandException(th);
            }
            AsyncResult.forMessage(message, obj, commandException);
            message.sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    public void updateDataServiceState() {
        if (this.mSS != null && this.mDefaultPhone.getServiceStateTracker() != null && this.mDefaultPhone.getServiceStateTracker().mSS != null) {
            ServiceState serviceState = this.mDefaultPhone.getServiceStateTracker().mSS;
            this.mSS.setDataRegState(serviceState.getDataRegistrationState());
            for (NetworkRegistrationInfo addNetworkRegistrationInfo : serviceState.getNetworkRegistrationInfoListForDomain(2)) {
                this.mSS.addNetworkRegistrationInfo(addNetworkRegistrationInfo);
            }
            this.mSS.setIwlanPreferred(serviceState.isIwlanPreferred());
            logd("updateDataServiceState: defSs = " + serviceState + " imsSs = " + this.mSS);
        }
    }

    /* access modifiers changed from: package-private */
    public boolean isCsRetryException(Throwable th) {
        return th != null && (th instanceof ImsException) && ((ImsException) th).getCode() == 146;
    }

    private Bundle setCsfbBundle(boolean z) {
        Bundle bundle = new Bundle();
        bundle.putBoolean(Phone.CS_FALLBACK_SS, z);
        return bundle;
    }

    /* access modifiers changed from: protected */
    public void sendResponseOrRetryOnCsfbSs(SS ss, int i, Throwable th, Object obj) {
        if (!isCsRetryException(th)) {
            sendResponse(ss.mOnComplete, obj, th);
            return;
        }
        Rlog.d(LOG_TAG, "Try CSFB: " + i);
        ss.mOnComplete.setData(setCsfbBundle(true));
        if (i == 12) {
            this.mDefaultPhone.setCallForwardingOption(ss.mCfAction, ss.mCfReason, ss.mDialingNumber, ss.mServiceClass, ss.mTimerSeconds, ss.mOnComplete);
        } else if (i == 13) {
            this.mDefaultPhone.getCallForwardingOption(ss.mCfReason, ss.mServiceClass, ss.mOnComplete);
        } else if (i != 75) {
            switch (i) {
                case 65:
                    this.mDefaultPhone.setCallBarring(ss.mFacility, ss.mLockState, ss.mPassword, ss.mOnComplete, ss.mServiceClass);
                    return;
                case 66:
                    this.mDefaultPhone.getCallBarring(ss.mFacility, ss.mPassword, ss.mOnComplete, ss.mServiceClass);
                    return;
                case 67:
                    this.mDefaultPhone.setCallWaiting(ss.mEnable, ss.mServiceClass, ss.mOnComplete);
                    return;
                case 68:
                    this.mDefaultPhone.getCallWaiting(ss.mOnComplete);
                    return;
                case 69:
                    this.mDefaultPhone.setOutgoingCallerIdDisplay(ss.mClirMode, ss.mOnComplete);
                    return;
                case 70:
                    this.mDefaultPhone.getOutgoingCallerIdDisplay(ss.mOnComplete);
                    return;
                default:
                    return;
            }
        } else {
            this.mDefaultPhone.queryCLIP(ss.mOnComplete);
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:63:0x0143  */
    /* JADX WARNING: Removed duplicated region for block: B:8:0x002f  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleMessage(android.os.Message r8) {
        /*
            r7 = this;
            java.lang.String r0 = "ImsPhone"
            java.lang.Object r1 = r8.obj
            android.os.AsyncResult r1 = (android.os.AsyncResult) r1
            r2 = 0
            if (r1 == 0) goto L_0x0012
            java.lang.Object r3 = r1.userObj
            boolean r4 = r3 instanceof com.android.internal.telephony.imsphone.ImsPhone.SS
            if (r4 == 0) goto L_0x0012
            com.android.internal.telephony.imsphone.ImsPhone$SS r3 = (com.android.internal.telephony.imsphone.ImsPhone.SS) r3
            goto L_0x0013
        L_0x0012:
            r3 = r2
        L_0x0013:
            java.lang.StringBuilder r4 = new java.lang.StringBuilder
            r4.<init>()
            java.lang.String r5 = "handleMessage what="
            r4.append(r5)
            int r5 = r8.what
            r4.append(r5)
            java.lang.String r4 = r4.toString()
            r7.logd(r4)
            int r4 = r8.what
            r5 = 12
            if (r4 == r5) goto L_0x0143
            r5 = 13
            if (r4 == r5) goto L_0x012d
            switch(r4) {
                case 65: goto L_0x0123;
                case 66: goto L_0x00fc;
                case 67: goto L_0x0123;
                case 68: goto L_0x00fc;
                case 69: goto L_0x00f0;
                case 70: goto L_0x00d9;
                case 71: goto L_0x00cf;
                case 72: goto L_0x00c2;
                case 73: goto L_0x00a7;
                case 74: goto L_0x004f;
                case 75: goto L_0x003b;
                default: goto L_0x0036;
            }
        L_0x0036:
            super.handleMessage(r8)
            goto L_0x0166
        L_0x003b:
            java.lang.Throwable r8 = r1.exception
            if (r8 != 0) goto L_0x0048
            java.lang.Object r0 = r1.result
            boolean r1 = r0 instanceof android.telephony.ims.ImsSsInfo
            if (r1 == 0) goto L_0x0048
            r2 = r0
            android.telephony.ims.ImsSsInfo r2 = (android.telephony.ims.ImsSsInfo) r2
        L_0x0048:
            if (r3 == 0) goto L_0x0166
            r7.sendResponseOrRetryOnCsfbSs(r3, r4, r8, r2)
            goto L_0x0166
        L_0x004f:
            java.lang.Object r8 = r8.obj
            android.os.AsyncResult r8 = (android.os.AsyncResult) r8
            java.lang.Throwable r1 = r8.exception
            if (r1 != 0) goto L_0x0166
            java.lang.Object r8 = r8.result
            if (r8 == 0) goto L_0x0166
            com.android.internal.telephony.Phone$SilentRedialParam r8 = (com.android.internal.telephony.Phone.SilentRedialParam) r8
            java.lang.String r1 = r8.dialString
            int r3 = r8.causeCode
            com.android.internal.telephony.PhoneInternalInterface$DialArgs r8 = r8.dialArgs
            com.android.internal.telephony.PhoneInternalInterface$DialArgs r8 = r7.updateDialArgsForVolteSilentRedial(r8, r3)     // Catch:{ CallStateException -> 0x0088 }
            com.android.internal.telephony.Connection r8 = r7.dial(r1, r8)     // Catch:{ CallStateException -> 0x0088 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ CallStateException -> 0x0088 }
            r1.<init>()     // Catch:{ CallStateException -> 0x0088 }
            java.lang.String r3 = "Notify volte redial connection changed cn: "
            r1.append(r3)     // Catch:{ CallStateException -> 0x0088 }
            r1.append(r8)     // Catch:{ CallStateException -> 0x0088 }
            java.lang.String r1 = r1.toString()     // Catch:{ CallStateException -> 0x0088 }
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ CallStateException -> 0x0088 }
            com.android.internal.telephony.Phone r1 = r7.mDefaultPhone     // Catch:{ CallStateException -> 0x0088 }
            if (r1 == 0) goto L_0x0166
            r1.notifyRedialConnectionChanged(r8)     // Catch:{ CallStateException -> 0x0088 }
            goto L_0x0166
        L_0x0088:
            r8 = move-exception
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r3 = "volte silent redial failed: "
            r1.append(r3)
            r1.append(r8)
            java.lang.String r8 = r1.toString()
            com.android.telephony.Rlog.e(r0, r8)
            com.android.internal.telephony.Phone r7 = r7.mDefaultPhone
            if (r7 == 0) goto L_0x0166
            r7.notifyRedialConnectionChanged(r2)
            goto L_0x0166
        L_0x00a7:
            java.lang.String r8 = "Voice call ended. Handle pending updateRoamingState."
            r7.logd(r8)
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = r7.mCT
            r8.unregisterForVoiceCallEnded(r7)
            com.android.internal.telephony.Phone r8 = r7.getDefaultPhone()
            com.android.internal.telephony.ServiceStateTracker r8 = r8.getServiceStateTracker()
            if (r8 == 0) goto L_0x0166
            android.telephony.ServiceState r8 = r8.mSS
            r7.updateRoamingState(r8)
            goto L_0x0166
        L_0x00c2:
            java.lang.Object r8 = r8.obj
            android.os.AsyncResult r8 = (android.os.AsyncResult) r8
            java.lang.Object r8 = r8.result
            android.telephony.ServiceState r8 = (android.telephony.ServiceState) r8
            r7.updateRoamingState(r8)
            goto L_0x0166
        L_0x00cf:
            java.lang.String r8 = "EVENT_DEFAULT_PHONE_DATA_STATE_CHANGED"
            r7.logd(r8)
            r7.updateDataServiceState()
            goto L_0x0166
        L_0x00d9:
            java.lang.Object r0 = r1.result
            android.telephony.ims.ImsSsInfo r0 = (android.telephony.ims.ImsSsInfo) r0
            if (r0 == 0) goto L_0x00e5
            r2 = 8
            int[] r2 = r0.getCompatArray(r2)
        L_0x00e5:
            if (r3 == 0) goto L_0x0166
            int r8 = r8.what
            java.lang.Throwable r0 = r1.exception
            r7.sendResponseOrRetryOnCsfbSs(r3, r8, r0, r2)
            goto L_0x0166
        L_0x00f0:
            java.lang.Throwable r0 = r1.exception
            if (r0 != 0) goto L_0x0123
            if (r3 == 0) goto L_0x0123
            int r0 = r3.mClirMode
            r7.saveClirSetting(r0)
            goto L_0x0123
        L_0x00fc:
            java.lang.Throwable r0 = r1.exception
            if (r0 != 0) goto L_0x0119
            r0 = 66
            if (r4 != r0) goto L_0x010d
            java.lang.Object r0 = r1.result
            android.telephony.ims.ImsSsInfo[] r0 = (android.telephony.ims.ImsSsInfo[]) r0
            int[] r2 = r7.handleCbQueryResult(r0)
            goto L_0x0119
        L_0x010d:
            r0 = 68
            if (r4 != r0) goto L_0x0119
            java.lang.Object r0 = r1.result
            android.telephony.ims.ImsSsInfo[] r0 = (android.telephony.ims.ImsSsInfo[]) r0
            int[] r2 = r7.handleCwQueryResult(r0)
        L_0x0119:
            if (r3 == 0) goto L_0x0166
            int r8 = r8.what
            java.lang.Throwable r0 = r1.exception
            r7.sendResponseOrRetryOnCsfbSs(r3, r8, r0, r2)
            goto L_0x0166
        L_0x0123:
            if (r3 == 0) goto L_0x0166
            int r8 = r8.what
            java.lang.Throwable r0 = r1.exception
            r7.sendResponseOrRetryOnCsfbSs(r3, r8, r0, r2)
            goto L_0x0166
        L_0x012d:
            java.lang.Throwable r0 = r1.exception
            if (r0 != 0) goto L_0x0139
            java.lang.Object r0 = r1.result
            android.telephony.ims.ImsCallForwardInfo[] r0 = (android.telephony.ims.ImsCallForwardInfo[]) r0
            com.android.internal.telephony.CallForwardInfo[] r2 = r7.handleCfQueryResult(r0)
        L_0x0139:
            if (r3 == 0) goto L_0x0166
            int r8 = r8.what
            java.lang.Throwable r0 = r1.exception
            r7.sendResponseOrRetryOnCsfbSs(r3, r8, r0, r2)
            goto L_0x0166
        L_0x0143:
            java.lang.Throwable r0 = r1.exception
            if (r0 != 0) goto L_0x015d
            if (r3 == 0) goto L_0x015d
            int r0 = r3.mCfReason
            if (r0 != 0) goto L_0x015d
            com.android.internal.telephony.uicc.IccRecords r0 = r7.getIccRecords()
            r4 = 1
            int r5 = r3.mCfAction
            boolean r5 = r7.isCfEnable(r5)
            java.lang.String r6 = r3.mDialingNumber
            r7.setVoiceCallForwardingFlag(r0, r4, r5, r6)
        L_0x015d:
            if (r3 == 0) goto L_0x0166
            int r8 = r8.what
            java.lang.Throwable r0 = r1.exception
            r7.sendResponseOrRetryOnCsfbSs(r3, r8, r0, r2)
        L_0x0166:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhone.handleMessage(android.os.Message):void");
    }

    @VisibleForTesting
    public ImsEcbmStateListener getImsEcbmStateListener() {
        return this.mImsEcbmStateListener;
    }

    public boolean isInEmergencyCall() {
        return this.mCT.isInEmergencyCall();
    }

    /* access modifiers changed from: protected */
    public void sendEmergencyCallbackModeChange() {
        Intent intent = new Intent("android.intent.action.EMERGENCY_CALLBACK_MODE_CHANGED");
        intent.putExtra("android.telephony.extra.PHONE_IN_ECM_STATE", isInEcm());
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, getPhoneId());
        this.mContext.sendStickyBroadcastAsUser(intent, UserHandle.ALL);
        logd("sendEmergencyCallbackModeChange: isInEcm=" + isInEcm());
    }

    public void exitEmergencyCallbackMode() {
        if (this.mWakeLock.isHeld()) {
            this.mWakeLock.release();
        }
        logd("exitEmergencyCallbackMode()");
        try {
            this.mCT.getEcbmInterface().exitEmergencyCallbackMode();
        } catch (ImsException e) {
            e.printStackTrace();
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void handleEnterEmergencyCallbackMode() {
        logd("handleEnterEmergencyCallbackMode,mIsPhoneInEcmState= " + isInEcm());
        if (!isInImsEcm()) {
            setIsInEcm(true);
            sendEmergencyCallbackModeChange();
            ((GsmCdmaPhone) this.mDefaultPhone).notifyEmergencyCallRegistrants(true);
            postDelayed(this.mExitEcmRunnable, TelephonyProperties.ecm_exit_timer().orElse(Long.valueOf(DEFAULT_ECM_EXIT_TIMER_VALUE)).longValue());
            this.mWakeLock.acquire();
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void handleExitEmergencyCallbackMode() {
        logd("handleExitEmergencyCallbackMode: mIsPhoneInEcmState = " + isInEcm());
        if (isInEcm()) {
            setIsInEcm(false);
        }
        removeCallbacks(this.mExitEcmRunnable);
        Registrant registrant = this.mEcmExitRespRegistrant;
        if (registrant != null) {
            registrant.notifyResult(Boolean.TRUE);
        }
        if (this.mWakeLock.isHeld()) {
            this.mWakeLock.release();
        }
        sendEmergencyCallbackModeChange();
        ((GsmCdmaPhone) this.mDefaultPhone).notifyEmergencyCallRegistrants(false);
    }

    /* access modifiers changed from: package-private */
    public void handleTimerInEmergencyCallbackMode(int i) {
        if (i == 0) {
            postDelayed(this.mExitEcmRunnable, TelephonyProperties.ecm_exit_timer().orElse(Long.valueOf(DEFAULT_ECM_EXIT_TIMER_VALUE)).longValue());
            ((GsmCdmaPhone) this.mDefaultPhone).notifyEcbmTimerReset(Boolean.FALSE);
            setEcmCanceledForEmergency(false);
        } else if (i != 1) {
            loge("handleTimerInEmergencyCallbackMode, unsupported action " + i);
        } else {
            removeCallbacks(this.mExitEcmRunnable);
            ((GsmCdmaPhone) this.mDefaultPhone).notifyEcbmTimerReset(Boolean.TRUE);
            setEcmCanceledForEmergency(true);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setOnEcbModeExitResponse(Handler handler, int i, Object obj) {
        this.mEcmExitRespRegistrant = new Registrant(handler, i, obj);
    }

    public void unsetOnEcbModeExitResponse(Handler handler) {
        this.mEcmExitRespRegistrant.clear();
    }

    public void onFeatureCapabilityChanged() {
        this.mDefaultPhone.getServiceStateTracker().onImsCapabilityChanged();
    }

    public boolean isImsCapabilityAvailable(int i, int i2) throws ImsException {
        return this.mCT.isImsCapabilityAvailable(i, i2);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isVolteEnabled() {
        return isVoiceOverCellularImsEnabled();
    }

    public boolean isVoiceOverCellularImsEnabled() {
        return this.mCT.isVoiceOverCellularImsEnabled();
    }

    public boolean isWifiCallingEnabled() {
        return this.mCT.isVowifiEnabled();
    }

    public boolean isVideoEnabled() {
        return this.mCT.isVideoCallEnabled();
    }

    public int getImsRegistrationTech() {
        return this.mCT.getImsRegistrationTech();
    }

    public void getImsRegistrationTech(Consumer<Integer> consumer) {
        this.mCT.getImsRegistrationTech(consumer);
    }

    public void getImsRegistrationState(Consumer<Integer> consumer) {
        consumer.accept(Integer.valueOf(this.mImsMmTelRegistrationHelper.getImsRegistrationState()));
    }

    public Phone getDefaultPhone() {
        return this.mDefaultPhone;
    }

    public boolean isImsRegistered() {
        return this.mImsMmTelRegistrationHelper.isImsRegistered();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setImsRegistered(boolean z) {
        this.mImsMmTelRegistrationHelper.updateRegistrationState(z ? 2 : 0);
    }

    public void callEndCleanupHandOverCallIfAny() {
        this.mCT.callEndCleanupHandOverCallIfAny();
    }

    public void processDisconnectReason(ImsReasonInfo imsReasonInfo) {
        if (imsReasonInfo.mCode == 1000 && imsReasonInfo.mExtraMessage != null && this.mImsManagerFactory.create(this.mContext, this.mPhoneId).isWfcEnabledByUser()) {
            processWfcDisconnectForNotification(imsReasonInfo);
        }
    }

    private void processWfcDisconnectForNotification(ImsReasonInfo imsReasonInfo) {
        String str;
        ImsReasonInfo imsReasonInfo2 = imsReasonInfo;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config");
        if (carrierConfigManager == null) {
            loge("processDisconnectReason: CarrierConfigManager is not ready");
            return;
        }
        PersistableBundle configForSubId = carrierConfigManager.getConfigForSubId(getSubId());
        if (configForSubId == null) {
            loge("processDisconnectReason: no config for subId " + getSubId());
            return;
        }
        String[] stringArray = configForSubId.getStringArray("wfc_operator_error_codes_string_array");
        if (stringArray != null) {
            String[] stringArray2 = this.mContext.getResources().getStringArray(17236214);
            String[] stringArray3 = this.mContext.getResources().getStringArray(17236215);
            for (int i = 0; i < stringArray.length; i++) {
                String[] split = stringArray[i].split("\\|");
                if (split.length != 2) {
                    loge("Invalid carrier config: " + stringArray[i]);
                } else if (!imsReasonInfo2.mExtraMessage.startsWith(split[0])) {
                    continue;
                } else {
                    int length = split[0].length();
                    if (!Character.isLetterOrDigit(split[0].charAt(length - 1)) || imsReasonInfo2.mExtraMessage.length() <= length || !Character.isLetterOrDigit(imsReasonInfo2.mExtraMessage.charAt(length))) {
                        CharSequence text = this.mContext.getText(17041769);
                        int parseInt = Integer.parseInt(split[1]);
                        if (parseInt < 0 || parseInt >= stringArray2.length || parseInt >= stringArray3.length) {
                            loge("Invalid index: " + stringArray[i]);
                        } else {
                            String str2 = imsReasonInfo2.mExtraMessage;
                            if (!stringArray2[parseInt].isEmpty()) {
                                str = String.format(stringArray2[parseInt], new Object[]{imsReasonInfo2.mExtraMessage});
                            } else {
                                str = str2;
                            }
                            if (!stringArray3[parseInt].isEmpty()) {
                                str2 = String.format(stringArray3[parseInt], new Object[]{imsReasonInfo2.mExtraMessage});
                            }
                            Intent intent = new Intent("android.telephony.ims.action.WFC_IMS_REGISTRATION_ERROR");
                            intent.putExtra(Phone.EXTRA_KEY_ALERT_TITLE, text);
                            intent.putExtra(Phone.EXTRA_KEY_ALERT_MESSAGE, str);
                            intent.putExtra(Phone.EXTRA_KEY_NOTIFICATION_MESSAGE, str2);
                            intent.putExtra("android:phone_id", getPhoneId());
                            this.mContext.sendOrderedBroadcast(intent, (String) null, this.mResultReceiver, (Handler) null, -1, (String) null, (Bundle) null);
                            return;
                        }
                    }
                }
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isUtEnabled() {
        return this.mCT.isUtEnabled();
    }

    public void sendEmergencyCallStateChange(boolean z) {
        this.mDefaultPhone.sendEmergencyCallStateChange(z);
    }

    public void setBroadcastEmergencyCallStateChanges(boolean z) {
        this.mDefaultPhone.setBroadcastEmergencyCallStateChanges(z);
    }

    @VisibleForTesting
    public PowerManager.WakeLock getWakeLock() {
        return this.mWakeLock;
    }

    /* access modifiers changed from: protected */
    public void updateRoamingState(ServiceState serviceState) {
        if (serviceState == null) {
            loge("updateRoamingState: null ServiceState!");
            return;
        }
        boolean roaming = serviceState.getRoaming();
        if (this.mLastKnownRoamingState != roaming) {
            if (!(serviceState.getState() == 0 || serviceState.getDataRegistrationState() == 0) || !this.mDefaultPhone.isRadioOn()) {
                logi("updateRoamingState: we are not IN_SERVICE, ignoring roaming change.");
            } else if (isCsNotInServiceAndPsWwanReportingWlan(serviceState)) {
                logi("updateRoamingState: IWLAN masking roaming, ignore roaming change.");
            } else if (this.mCT.getState() == PhoneConstants.State.IDLE) {
                logd("updateRoamingState now: " + roaming);
                this.mLastKnownRoamingState = roaming;
                CarrierConfigManager carrierConfigManager = (CarrierConfigManager) getContext().getSystemService("carrier_config");
                if (carrierConfigManager != null && CarrierConfigManager.isConfigForIdentifiedCarrier(carrierConfigManager.getConfigForSubId(getSubId()))) {
                    ImsManager create = this.mImsManagerFactory.create(this.mContext, this.mPhoneId);
                    create.setWfcMode(create.getWfcMode(roaming), roaming);
                }
            } else {
                logd("updateRoamingState postponed: " + roaming);
                this.mCT.registerForVoiceCallEnded(this, 73, (Object) null);
            }
        }
    }

    /* access modifiers changed from: protected */
    public boolean isCsNotInServiceAndPsWwanReportingWlan(ServiceState serviceState) {
        if (this.mDefaultPhone.getAccessNetworksManager() == null || !this.mDefaultPhone.getAccessNetworksManager().isInLegacyMode()) {
            return false;
        }
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(1, 1);
        NetworkRegistrationInfo networkRegistrationInfo2 = serviceState.getNetworkRegistrationInfo(2, 1);
        if (networkRegistrationInfo2 == null || networkRegistrationInfo == null || networkRegistrationInfo.isInService() || networkRegistrationInfo2.getAccessNetworkTechnology() != 18) {
            return false;
        }
        return true;
    }

    public RegistrationManager.RegistrationCallback getImsMmTelRegistrationCallback() {
        return this.mImsMmTelRegistrationHelper.getCallback();
    }

    public void resetImsRegistrationState() {
        logd("resetImsRegistrationState");
        this.mImsMmTelRegistrationHelper.reset();
    }

    @VisibleForTesting
    public void setPhoneNumberForSourceIms(Uri[] uriArr) {
        String extractPhoneNumberFromAssociatedUris = extractPhoneNumberFromAssociatedUris(uriArr);
        if (extractPhoneNumberFromAssociatedUris != null) {
            int subId = getSubId();
            if (SubscriptionManager.isValidSubscriptionId(subId)) {
                SubscriptionController instance = SubscriptionController.getInstance();
                String formatNumberToE164 = PhoneNumberUtils.formatNumberToE164(extractPhoneNumberFromAssociatedUris, getCountryIso(instance, subId));
                if (formatNumberToE164 != null) {
                    instance.setSubscriptionProperty(subId, "phone_number_source_ims", formatNumberToE164);
                }
            }
        }
    }

    private static String getCountryIso(SubscriptionController subscriptionController, int i) {
        String str;
        SubscriptionInfo subscriptionInfo = subscriptionController.getSubscriptionInfo(i);
        if (subscriptionInfo == null) {
            str = "";
        } else {
            str = subscriptionInfo.getCountryIso();
        }
        if (str == null) {
            return "";
        }
        return str;
    }

    private static String extractPhoneNumberFromAssociatedUris(Uri[] uriArr) {
        if (uriArr == null) {
            return null;
        }
        return (String) Arrays.stream(uriArr).filter(new ImsPhone$$ExternalSyntheticLambda0()).filter(new ImsPhone$$ExternalSyntheticLambda1()).map(new ImsPhone$$ExternalSyntheticLambda2()).filter(new ImsPhone$$ExternalSyntheticLambda3()).map(new ImsPhone$$ExternalSyntheticLambda4()).findFirst().orElse((Object) null);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$extractPhoneNumberFromAssociatedUris$1(Uri uri) {
        return uri != null && uri.isOpaque();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$extractPhoneNumberFromAssociatedUris$2(Uri uri) {
        return "tel".equalsIgnoreCase(uri.getScheme()) || "sip".equalsIgnoreCase(uri.getScheme());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$extractPhoneNumberFromAssociatedUris$3(String str) {
        return str != null && str.startsWith("+");
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String lambda$extractPhoneNumberFromAssociatedUris$4(String str) {
        return str.split("@")[0];
    }

    public IccRecords getIccRecords() {
        return this.mDefaultPhone.getIccRecords();
    }

    public PhoneInternalInterface.DialArgs updateDialArgsForVolteSilentRedial(PhoneInternalInterface.DialArgs dialArgs, int i) {
        if (dialArgs == null) {
            return new PhoneInternalInterface.DialArgs.Builder().build();
        }
        ImsDialArgs.Builder from = ImsDialArgs.Builder.from(dialArgs);
        Bundle bundle = new Bundle(dialArgs.intentExtras);
        if (i == 3002) {
            bundle.putString("CallRadioTech", String.valueOf(18));
            logd("trigger VoWifi emergency call");
            from.setIntentExtras(bundle);
        } else if (i == 3001) {
            logd("trigger VoLte emergency call");
        }
        return from.build();
    }

    public VoiceCallSessionStats getVoiceCallSessionStats() {
        return this.mDefaultPhone.getVoiceCallSessionStats();
    }

    public ImsStats getImsStats() {
        return this.mImsStats;
    }

    @VisibleForTesting
    public void setImsStats(ImsStats imsStats) {
        this.mImsStats = imsStats;
    }

    public boolean hasAliveCall() {
        Call.State state = getForegroundCall().getState();
        Call.State state2 = Call.State.IDLE;
        return (state == state2 && getBackgroundCall().getState() == state2) ? false : true;
    }

    public boolean getLastKnownRoamingState() {
        return this.mLastKnownRoamingState;
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println("ImsPhone extends:");
        super.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.flush();
        indentingPrintWriter.println("ImsPhone:");
        indentingPrintWriter.println("  mDefaultPhone = " + this.mDefaultPhone);
        indentingPrintWriter.println("  mPendingMMIs = " + this.mPendingMMIs);
        indentingPrintWriter.println("  mPostDialHandler = " + this.mPostDialHandler);
        indentingPrintWriter.println("  mSS = " + this.mSS);
        indentingPrintWriter.println("  mWakeLock = " + this.mWakeLock);
        indentingPrintWriter.println("  mIsPhoneInEcmState = " + isInEcm());
        indentingPrintWriter.println("  mEcmExitRespRegistrant = " + this.mEcmExitRespRegistrant);
        indentingPrintWriter.println("  mSilentRedialRegistrants = " + this.mSilentRedialRegistrants);
        indentingPrintWriter.println("  mImsMmTelRegistrationState = " + this.mImsMmTelRegistrationHelper.getImsRegistrationState());
        indentingPrintWriter.println("  mLastKnownRoamingState = " + this.mLastKnownRoamingState);
        indentingPrintWriter.println("  mSsnRegistrants = " + this.mSsnRegistrants);
        indentingPrintWriter.println(" Registration Log:");
        indentingPrintWriter.increaseIndent();
        this.mRegLocalLog.dump(indentingPrintWriter);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.flush();
    }

    /* access modifiers changed from: protected */
    public void logi(String str) {
        Rlog.i(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    /* access modifiers changed from: protected */
    public void logv(String str) {
        Rlog.v(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    /* access modifiers changed from: protected */
    public void logd(String str) {
        Rlog.d(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }
}
