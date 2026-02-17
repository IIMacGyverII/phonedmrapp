package com.android.internal.telephony;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.os.Handler;
import android.os.HandlerExecutor;
import android.os.Message;
import android.os.PersistableBundle;
import android.provider.Settings;
import android.telephony.CarrierConfigManager;
import android.telephony.RadioAccessFamily;
import android.telephony.ServiceState;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyCallback;
import android.telephony.TelephonyManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.internal.telephony.util.NotificationChannelController;
import com.android.telephony.Rlog;
import java.util.HashMap;
import java.util.Map;

public class CarrierServiceStateTracker extends Handler {
    protected static final int CARRIER_EVENT_BASE = 100;
    protected static final int CARRIER_EVENT_DATA_DEREGISTRATION = 104;
    protected static final int CARRIER_EVENT_DATA_REGISTRATION = 103;
    protected static final int CARRIER_EVENT_IMS_CAPABILITIES_CHANGED = 105;
    protected static final int CARRIER_EVENT_VOICE_DEREGISTRATION = 102;
    protected static final int CARRIER_EVENT_VOICE_REGISTRATION = 101;
    @VisibleForTesting
    public static final String EMERGENCY_NOTIFICATION_TAG = "EmergencyNetworkNotification";
    private static final String LOG_TAG = "CSST";
    public static final int NOTIFICATION_EMERGENCY_NETWORK = 1001;
    public static final int NOTIFICATION_PREF_NETWORK = 1000;
    @VisibleForTesting
    public static final String PREF_NETWORK_NOTIFICATION_TAG = "PrefNetworkNotification";
    private static final int UNINITIALIZED_DELAY_VALUE = -1;
    /* access modifiers changed from: private */
    public long mAllowedNetworkType = -1;
    private AllowedNetworkTypesListener mAllowedNetworkTypesListener;
    private final BroadcastReceiver mBroadcastReceiver;
    /* access modifiers changed from: private */
    public final Map<Integer, NotificationType> mNotificationTypeMap = new HashMap();
    /* access modifiers changed from: private */
    public Phone mPhone;
    /* access modifiers changed from: private */
    public int mPreviousSubId = -1;
    /* access modifiers changed from: private */
    public ServiceStateTracker mSST;
    /* access modifiers changed from: private */
    public TelephonyManager mTelephonyManager;

    public interface NotificationType {
        int getDelay();

        Notification.Builder getNotificationBuilder();

        int getNotificationId();

        String getNotificationTag();

        int getTypeId();

        boolean sendMessage();

        void setDelay(PersistableBundle persistableBundle);
    }

    private boolean checkSupportedBitmask(long j, long j2) {
        return (j2 & j) == j2;
    }

    @VisibleForTesting
    public class AllowedNetworkTypesListener extends TelephonyCallback implements TelephonyCallback.AllowedNetworkTypesListener {
        public AllowedNetworkTypesListener() {
        }

        public void onAllowedNetworkTypesChanged(int i, long j) {
            if (i == 0 && CarrierServiceStateTracker.this.mAllowedNetworkType != j) {
                CarrierServiceStateTracker.this.mAllowedNetworkType = j;
                CarrierServiceStateTracker.this.handleAllowedNetworkTypeChanged();
            }
        }
    }

    public CarrierServiceStateTracker(Phone phone, ServiceStateTracker serviceStateTracker) {
        AnonymousClass2 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                PersistableBundle configForSubId = ((CarrierConfigManager) context.getSystemService("carrier_config")).getConfigForSubId(CarrierServiceStateTracker.this.mPhone.getSubId());
                for (Map.Entry value : CarrierServiceStateTracker.this.mNotificationTypeMap.entrySet()) {
                    ((NotificationType) value.getValue()).setDelay(configForSubId);
                }
                CarrierServiceStateTracker.this.handleConfigChanges();
            }
        };
        this.mBroadcastReceiver = r0;
        this.mPhone = phone;
        this.mSST = serviceStateTracker;
        this.mTelephonyManager = ((TelephonyManager) phone.getContext().getSystemService(TelephonyManager.class)).createForSubscriptionId(this.mPhone.getSubId());
        phone.getContext().registerReceiver(r0, new IntentFilter("android.telephony.action.CARRIER_CONFIG_CHANGED"));
        SubscriptionManager.from(this.mPhone.getContext()).addOnSubscriptionsChangedListener(new SubscriptionManager.OnSubscriptionsChangedListener(getLooper()) {
            public void onSubscriptionsChanged() {
                int subId = CarrierServiceStateTracker.this.mPhone.getSubId();
                if (CarrierServiceStateTracker.this.mPreviousSubId != subId) {
                    CarrierServiceStateTracker.this.mPreviousSubId = subId;
                    CarrierServiceStateTracker carrierServiceStateTracker = CarrierServiceStateTracker.this;
                    carrierServiceStateTracker.mTelephonyManager = carrierServiceStateTracker.mTelephonyManager.createForSubscriptionId(CarrierServiceStateTracker.this.mPhone.getSubId());
                    CarrierServiceStateTracker.this.registerAllowedNetworkTypesListener();
                }
            }
        });
        registerNotificationTypes();
        this.mAllowedNetworkType = (long) RadioAccessFamily.getNetworkTypeFromRaf((int) this.mPhone.getAllowedNetworkTypes(0));
        this.mAllowedNetworkTypesListener = new AllowedNetworkTypesListener();
        registerAllowedNetworkTypesListener();
    }

    @VisibleForTesting
    public AllowedNetworkTypesListener getAllowedNetworkTypesChangedListener() {
        return this.mAllowedNetworkTypesListener;
    }

    /* access modifiers changed from: private */
    public void registerAllowedNetworkTypesListener() {
        TelephonyManager telephonyManager;
        int subId = this.mPhone.getSubId();
        unregisterAllowedNetworkTypesListener();
        if (SubscriptionManager.isValidSubscriptionId(subId) && (telephonyManager = this.mTelephonyManager) != null) {
            telephonyManager.registerTelephonyCallback(new HandlerExecutor(this), this.mAllowedNetworkTypesListener);
        }
    }

    private void unregisterAllowedNetworkTypesListener() {
        this.mTelephonyManager.unregisterTelephonyCallback(this.mAllowedNetworkTypesListener);
    }

    @VisibleForTesting
    public Map<Integer, NotificationType> getNotificationTypeMap() {
        return this.mNotificationTypeMap;
    }

    private void registerNotificationTypes() {
        this.mNotificationTypeMap.put(1000, new PrefNetworkNotification(1000));
        this.mNotificationTypeMap.put(1001, new EmergencyNetworkNotification(1001));
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1000 || i == 1001) {
            Rlog.d(LOG_TAG, "sending notification after delay: " + message.what);
            NotificationType notificationType = this.mNotificationTypeMap.get(Integer.valueOf(message.what));
            if (notificationType != null) {
                sendNotification(notificationType);
                return;
            }
            return;
        }
        switch (i) {
            case 101:
            case 102:
            case 103:
            case 104:
                handleConfigChanges();
                return;
            case 105:
                handleImsCapabilitiesChanged();
                return;
            default:
                return;
        }
    }

    /* access modifiers changed from: private */
    public boolean isPhoneStillRegistered() {
        ServiceState serviceState = this.mSST.mSS;
        if (serviceState == null || serviceState.getState() == 0 || this.mSST.mSS.getDataRegistrationState() == 0) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: private */
    public boolean isPhoneRegisteredForWifiCalling() {
        Rlog.d(LOG_TAG, "isPhoneRegisteredForWifiCalling: " + this.mPhone.isWifiCallingEnabled());
        return this.mPhone.isWifiCallingEnabled();
    }

    @VisibleForTesting
    public boolean isRadioOffOrAirplaneMode() {
        try {
            int i = Settings.Global.getInt(this.mPhone.getContext().getContentResolver(), "airplane_mode_on", 0);
            if (!this.mSST.isRadioOn() || i != 0) {
                return true;
            }
            return false;
        } catch (Exception unused) {
            Rlog.e(LOG_TAG, "Unable to get AIRPLACE_MODE_ON.");
            return true;
        }
    }

    /* access modifiers changed from: private */
    public boolean isGlobalMode() {
        try {
            int calculatePreferredNetworkType = PhoneFactory.calculatePreferredNetworkType(this.mPhone.getPhoneId());
            if (isNrSupported()) {
                if (calculatePreferredNetworkType == RadioAccessFamily.getRafFromNetworkType(27)) {
                    return true;
                }
                return false;
            } else if (calculatePreferredNetworkType == RadioAccessFamily.getRafFromNetworkType(10)) {
                return true;
            } else {
                return false;
            }
        } catch (Exception unused) {
            Rlog.e(LOG_TAG, "Unable to get PREFERRED_NETWORK_MODE.");
            return true;
        }
    }

    private boolean isNrSupported() {
        Context context = this.mPhone.getContext();
        TelephonyManager createForSubscriptionId = ((TelephonyManager) context.getSystemService("phone")).createForSubscriptionId(this.mPhone.getSubId());
        boolean isCarrierConfigEnableNr = isCarrierConfigEnableNr(context);
        boolean checkSupportedBitmask = checkSupportedBitmask(createForSubscriptionId.getSupportedRadioAccessFamily(), 524288);
        boolean checkSupportedBitmask2 = checkSupportedBitmask(createForSubscriptionId.getAllowedNetworkTypesForReason(2), 524288);
        Rlog.i(LOG_TAG, "isNrSupported:  carrierConfigEnabled: " + isCarrierConfigEnableNr + ", AccessFamilySupported: " + checkSupportedBitmask + ", isNrNetworkTypeAllowed: " + checkSupportedBitmask2);
        return isCarrierConfigEnableNr && checkSupportedBitmask && checkSupportedBitmask2;
    }

    private boolean isCarrierConfigEnableNr(Context context) {
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) context.getSystemService("carrier_config");
        if (carrierConfigManager == null) {
            Rlog.e(LOG_TAG, "isCarrierConfigEnableNr: CarrierConfigManager is null");
            return false;
        }
        PersistableBundle configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
        if (configForSubId != null) {
            return !ArrayUtils.isEmpty(configForSubId.getIntArray("carrier_nr_availabilities_int_array"));
        }
        Rlog.e(LOG_TAG, "isCarrierConfigEnableNr: Cannot get config " + this.mPhone.getSubId());
        return false;
    }

    /* access modifiers changed from: private */
    public void handleConfigChanges() {
        for (Map.Entry<Integer, NotificationType> value : this.mNotificationTypeMap.entrySet()) {
            evaluateSendingMessageOrCancelNotification((NotificationType) value.getValue());
        }
    }

    /* access modifiers changed from: private */
    public void handleAllowedNetworkTypeChanged() {
        NotificationType notificationType = this.mNotificationTypeMap.get(1000);
        if (notificationType != null) {
            evaluateSendingMessageOrCancelNotification(notificationType);
        }
    }

    private void handleImsCapabilitiesChanged() {
        NotificationType notificationType = this.mNotificationTypeMap.get(1001);
        if (notificationType != null) {
            evaluateSendingMessageOrCancelNotification(notificationType);
        }
    }

    private void evaluateSendingMessageOrCancelNotification(NotificationType notificationType) {
        if (evaluateSendingMessage(notificationType)) {
            Message obtainMessage = obtainMessage(notificationType.getTypeId(), (Object) null);
            Rlog.i(LOG_TAG, "starting timer for notifications." + notificationType.getTypeId());
            sendMessageDelayed(obtainMessage, (long) getDelay(notificationType));
            return;
        }
        cancelNotification(notificationType);
        Rlog.i(LOG_TAG, "canceling notifications: " + notificationType.getTypeId());
    }

    @VisibleForTesting
    public boolean evaluateSendingMessage(NotificationType notificationType) {
        return notificationType.sendMessage();
    }

    @VisibleForTesting
    public int getDelay(NotificationType notificationType) {
        return notificationType.getDelay();
    }

    @VisibleForTesting
    public Notification.Builder getNotificationBuilder(NotificationType notificationType) {
        return notificationType.getNotificationBuilder();
    }

    @VisibleForTesting
    public NotificationManager getNotificationManager(Context context) {
        return (NotificationManager) context.getSystemService("notification");
    }

    @VisibleForTesting
    public void sendNotification(NotificationType notificationType) {
        if (evaluateSendingMessage(notificationType)) {
            Context context = this.mPhone.getContext();
            Notification.Builder notificationBuilder = getNotificationBuilder(notificationType);
            notificationBuilder.setWhen(System.currentTimeMillis()).setAutoCancel(true).setSmallIcon(17301642).setColor(context.getResources().getColor(17170460));
            getNotificationManager(context).notify(notificationType.getNotificationTag(), notificationType.getNotificationId(), notificationBuilder.build());
        }
    }

    public void cancelNotification(NotificationType notificationType) {
        Context context = this.mPhone.getContext();
        removeMessages(notificationType.getTypeId());
        getNotificationManager(context).cancel(notificationType.getNotificationTag(), notificationType.getNotificationId());
    }

    public void dispose() {
        unregisterAllowedNetworkTypesListener();
    }

    public class PrefNetworkNotification implements NotificationType {
        private int mDelay = -1;
        private final int mTypeId;

        public String getNotificationTag() {
            return CarrierServiceStateTracker.PREF_NETWORK_NOTIFICATION_TAG;
        }

        PrefNetworkNotification(int i) {
            this.mTypeId = i;
        }

        public void setDelay(PersistableBundle persistableBundle) {
            if (persistableBundle == null) {
                Rlog.e(CarrierServiceStateTracker.LOG_TAG, "bundle is null");
                return;
            }
            this.mDelay = persistableBundle.getInt("network_notification_delay_int");
            Rlog.i(CarrierServiceStateTracker.LOG_TAG, "reading time to delay notification pref network: " + this.mDelay);
        }

        public int getDelay() {
            return this.mDelay;
        }

        public int getTypeId() {
            return this.mTypeId;
        }

        public int getNotificationId() {
            return CarrierServiceStateTracker.this.mPhone.getSubId();
        }

        public boolean sendMessage() {
            Rlog.i(CarrierServiceStateTracker.LOG_TAG, "PrefNetworkNotification: sendMessage() w/values: ," + CarrierServiceStateTracker.this.isPhoneStillRegistered() + "," + this.mDelay + "," + CarrierServiceStateTracker.this.isGlobalMode() + "," + CarrierServiceStateTracker.this.mSST.isRadioOn());
            return this.mDelay != -1 && !CarrierServiceStateTracker.this.isPhoneStillRegistered() && !CarrierServiceStateTracker.this.isGlobalMode() && !CarrierServiceStateTracker.this.isRadioOffOrAirplaneMode();
        }

        public Notification.Builder getNotificationBuilder() {
            Context context = CarrierServiceStateTracker.this.mPhone.getContext();
            Intent intent = new Intent("android.settings.DATA_ROAMING_SETTINGS");
            intent.putExtra("expandable", true);
            PendingIntent activity = PendingIntent.getActivity(context, 0, intent, 1140850688);
            Resources resourcesForSubId = SubscriptionManager.getResourcesForSubId(context, CarrierServiceStateTracker.this.mPhone.getSubId());
            CharSequence text = resourcesForSubId.getText(17039448);
            CharSequence text2 = resourcesForSubId.getText(17039447);
            return new Notification.Builder(context).setContentTitle(text).setStyle(new Notification.BigTextStyle().bigText(text2)).setContentText(text2).setChannelId(NotificationChannelController.CHANNEL_ID_ALERT).setContentIntent(activity);
        }
    }

    public class EmergencyNetworkNotification implements NotificationType {
        private int mDelay = -1;
        private final int mTypeId;

        public String getNotificationTag() {
            return CarrierServiceStateTracker.EMERGENCY_NOTIFICATION_TAG;
        }

        EmergencyNetworkNotification(int i) {
            this.mTypeId = i;
        }

        public void setDelay(PersistableBundle persistableBundle) {
            if (persistableBundle == null) {
                Rlog.e(CarrierServiceStateTracker.LOG_TAG, "bundle is null");
                return;
            }
            this.mDelay = persistableBundle.getInt("emergency_notification_delay_int");
            Rlog.i(CarrierServiceStateTracker.LOG_TAG, "reading time to delay notification emergency: " + this.mDelay);
        }

        public int getDelay() {
            return this.mDelay;
        }

        public int getTypeId() {
            return this.mTypeId;
        }

        public int getNotificationId() {
            return CarrierServiceStateTracker.this.mPhone.getSubId();
        }

        public boolean sendMessage() {
            Rlog.i(CarrierServiceStateTracker.LOG_TAG, "EmergencyNetworkNotification: sendMessage() w/values: ," + this.mDelay + "," + CarrierServiceStateTracker.this.isPhoneRegisteredForWifiCalling() + "," + CarrierServiceStateTracker.this.mSST.isRadioOn());
            return this.mDelay != -1 && CarrierServiceStateTracker.this.isPhoneRegisteredForWifiCalling();
        }

        public Notification.Builder getNotificationBuilder() {
            Context context = CarrierServiceStateTracker.this.mPhone.getContext();
            Resources resourcesForSubId = SubscriptionManager.getResourcesForSubId(context, CarrierServiceStateTracker.this.mPhone.getSubId());
            CharSequence text = resourcesForSubId.getText(17039445);
            CharSequence text2 = resourcesForSubId.getText(17039444);
            return new Notification.Builder(context).setContentTitle(text).setStyle(new Notification.BigTextStyle().bigText(text2)).setContentText(text2).setFlag(32, true).setChannelId(NotificationChannelController.CHANNEL_ID_WFC);
        }
    }
}
