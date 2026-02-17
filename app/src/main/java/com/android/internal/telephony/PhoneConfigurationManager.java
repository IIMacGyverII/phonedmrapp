package com.android.internal.telephony;

import android.content.Context;
import android.content.Intent;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.os.AsyncResult;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.os.SystemProperties;
import android.telephony.PhoneCapability;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;

public class PhoneConfigurationManager {
    private static final String ALLOW_MOCK_MODEM_PROPERTY = "persist.radio.allow_mock_modem";
    private static final boolean DEBUG = (!"user".equals(Build.TYPE));
    public static final String DSDA = "dsda";
    public static final String DSDS = "dsds";
    private static final int EVENT_GET_MODEM_STATUS = 101;
    private static final int EVENT_GET_MODEM_STATUS_DONE = 102;
    private static final int EVENT_GET_PHONE_CAPABILITY_DONE = 103;
    private static final int EVENT_SWITCH_DSDS_CONFIG_DONE = 100;
    private static final String LOG_TAG = "PhoneCfgMgr";
    public static final String SSSS = "";
    public static final String TSTS = "tsts";
    private static PhoneConfigurationManager sInstance;
    private static final RegistrantList sMultiSimConfigChangeRegistrants = new RegistrantList();
    private final Context mContext;
    private final Handler mHandler;
    private MockableInterface mMi = new MockableInterface();
    private final Map<Integer, Boolean> mPhoneStatusMap;
    private Phone[] mPhones;
    private final RadioConfig mRadioConfig;
    /* access modifiers changed from: private */
    public PhoneCapability mStaticCapability;
    private TelephonyManager mTelephonyManager;

    public static PhoneConfigurationManager init(Context context) {
        PhoneConfigurationManager phoneConfigurationManager;
        synchronized (PhoneConfigurationManager.class) {
            if (sInstance == null) {
                sInstance = new PhoneConfigurationManager(context);
            } else {
                Log.wtf(LOG_TAG, "init() called multiple times!  sInstance = " + sInstance);
            }
            phoneConfigurationManager = sInstance;
        }
        return phoneConfigurationManager;
    }

    private PhoneConfigurationManager(Context context) {
        this.mContext = context;
        this.mTelephonyManager = (TelephonyManager) context.getSystemService("phone");
        this.mStaticCapability = getDefaultCapability();
        this.mRadioConfig = RadioConfig.getInstance();
        this.mHandler = new ConfigManagerHandler();
        this.mPhoneStatusMap = new HashMap();
        notifyCapabilityChanged();
        Phone[] phones = PhoneFactory.getPhones();
        this.mPhones = phones;
        for (Phone registerForRadioState : phones) {
            registerForRadioState(registerForRadioState);
        }
    }

    private void registerForRadioState(Phone phone) {
        phone.mCi.registerForAvailable(this.mHandler, 1, phone);
    }

    private PhoneCapability getDefaultCapability() {
        if (getPhoneCount() > 1) {
            return PhoneCapability.DEFAULT_DSDS_CAPABILITY;
        }
        return PhoneCapability.DEFAULT_SSSS_CAPABILITY;
    }

    public static PhoneConfigurationManager getInstance() {
        if (sInstance == null) {
            Log.wtf(LOG_TAG, "getInstance null");
        }
        return sInstance;
    }

    private final class ConfigManagerHandler extends Handler {
        private ConfigManagerHandler() {
        }

        public void handleMessage(Message message) {
            int i = message.what;
            if (i == 1 || i == 5) {
                PhoneConfigurationManager.log("Received EVENT_RADIO_AVAILABLE/EVENT_RADIO_ON");
                Object obj = ((AsyncResult) message.obj).userObj;
                if (obj == null || !(obj instanceof Phone)) {
                    PhoneConfigurationManager.log("Unable to add phoneStatus to cache. No phone object provided for event " + message.what);
                } else {
                    PhoneConfigurationManager.this.updatePhoneStatus((Phone) obj);
                }
                PhoneConfigurationManager.this.getStaticPhoneCapability();
            } else if (i == 100) {
                AsyncResult asyncResult = (AsyncResult) message.obj;
                if (asyncResult == null || asyncResult.exception != null) {
                    PhoneConfigurationManager.log(message.what + " failure. Not switching multi-sim config." + asyncResult.exception);
                    return;
                }
                PhoneConfigurationManager.this.onMultiSimConfigChanged(message.arg1);
            } else if (i == 102) {
                AsyncResult asyncResult2 = (AsyncResult) message.obj;
                if (asyncResult2 == null || asyncResult2.exception != null) {
                    PhoneConfigurationManager.log(message.what + " failure. Not updating modem status." + asyncResult2.exception);
                    return;
                }
                PhoneConfigurationManager.this.addToPhoneStatusCache(message.arg1, ((Boolean) asyncResult2.result).booleanValue());
            } else if (i == 103) {
                AsyncResult asyncResult3 = (AsyncResult) message.obj;
                if (asyncResult3 == null || asyncResult3.exception != null) {
                    PhoneConfigurationManager.log(message.what + " failure. Not getting phone capability." + asyncResult3.exception);
                    return;
                }
                PhoneConfigurationManager.this.mStaticCapability = (PhoneCapability) asyncResult3.result;
                PhoneConfigurationManager.this.notifyCapabilityChanged();
            }
        }
    }

    public void enablePhone(Phone phone, boolean z, Message message) {
        if (phone == null) {
            log("enablePhone failed phone is null");
        } else {
            phone.mCi.enableModem(z, message);
        }
    }

    public boolean getPhoneStatus(Phone phone) {
        if (phone == null) {
            log("getPhoneStatus failed phone is null");
            return false;
        }
        try {
            return getPhoneStatusFromCache(phone.getPhoneId());
        } catch (NoSuchElementException unused) {
            return true;
        } finally {
            updatePhoneStatus(phone);
        }
    }

    public void getPhoneStatusFromModem(Phone phone, Message message) {
        if (phone == null) {
            log("getPhoneStatus failed phone is null");
        }
        phone.mCi.getModemStatus(message);
    }

    public boolean getPhoneStatusFromCache(int i) throws NoSuchElementException {
        if (this.mPhoneStatusMap.containsKey(Integer.valueOf(i))) {
            return this.mPhoneStatusMap.get(Integer.valueOf(i)).booleanValue();
        }
        throw new NoSuchElementException("phoneId not found: " + i);
    }

    /* access modifiers changed from: private */
    public void updatePhoneStatus(Phone phone) {
        phone.mCi.getModemStatus(Message.obtain(this.mHandler, 102, phone.getPhoneId(), 0));
    }

    public void addToPhoneStatusCache(int i, boolean z) {
        this.mPhoneStatusMap.put(Integer.valueOf(i), Boolean.valueOf(z));
    }

    public int getPhoneCount() {
        return this.mTelephonyManager.getActiveModemCount();
    }

    public synchronized PhoneCapability getStaticPhoneCapability() {
        if (getDefaultCapability().equals(this.mStaticCapability)) {
            log("getStaticPhoneCapability: sending the request for getting PhoneCapability");
            this.mRadioConfig.getPhoneCapability(Message.obtain(this.mHandler, 103));
        }
        log("getStaticPhoneCapability: mStaticCapability " + this.mStaticCapability);
        return this.mStaticCapability;
    }

    public PhoneCapability getCurrentPhoneCapability() {
        return getStaticPhoneCapability();
    }

    public int getNumberOfModemsWithSimultaneousDataConnections() {
        return this.mStaticCapability.getMaxActiveDataSubscriptions();
    }

    /* access modifiers changed from: private */
    public void notifyCapabilityChanged() {
        new DefaultPhoneNotifier(this.mContext).notifyPhoneCapabilityChanged(this.mStaticCapability);
    }

    public void switchMultiSimConfig(int i) {
        log("switchMultiSimConfig: with numOfSims = " + i);
        if (getStaticPhoneCapability().getLogicalModemList().size() < i) {
            log("switchMultiSimConfig: Phone is not capable of enabling " + i + " sims, exiting!");
        } else if (getPhoneCount() != i) {
            log("switchMultiSimConfig: sending the request for switching");
            this.mRadioConfig.setNumOfLiveModems(i, Message.obtain(this.mHandler, 100, i, 0));
        } else {
            log("switchMultiSimConfig: No need to switch. getNumOfActiveSims is already " + i);
        }
    }

    public boolean isRebootRequiredForModemConfigChange() {
        return this.mMi.isRebootRequiredForModemConfigChange();
    }

    /* access modifiers changed from: private */
    public void onMultiSimConfigChanged(int i) {
        int phoneCount = getPhoneCount();
        setMultiSimProperties(i);
        if (isRebootRequiredForModemConfigChange()) {
            log("onMultiSimConfigChanged: Rebooting.");
            ((PowerManager) this.mContext.getSystemService(XmlTagConst.TAG_POWER)).reboot("Multi-SIM config changed.");
            return;
        }
        log("onMultiSimConfigChanged: Rebooting is not required.");
        this.mMi.notifyPhoneFactoryOnMultiSimConfigChanged(this.mContext, i);
        broadcastMultiSimConfigChange(i);
        boolean z = false;
        int i2 = i;
        while (i2 < phoneCount) {
            SubscriptionController.getInstance().clearSubInfoRecord(i2);
            this.mPhones[i2].mCi.onSlotActiveStatusChange(SubscriptionManager.isValidPhoneId(i2));
            i2++;
            z = true;
        }
        if (z) {
            MultiSimSettingController.getInstance().onPhoneRemoved();
        }
        this.mPhones = PhoneFactory.getPhones();
        for (int i3 = phoneCount; i3 < i; i3++) {
            Phone phone = this.mPhones[i3];
            registerForRadioState(phone);
            phone.mCi.onSlotActiveStatusChange(SubscriptionManager.isValidPhoneId(i3));
        }
        if (i <= phoneCount || i != 2) {
            Log.i(LOG_TAG, "onMultiSimConfigChanged: DSDS mode NOT detected.  NOT setting the default VOICE and SMS subId to -1 (No Preference)");
            return;
        }
        Log.i(LOG_TAG, " onMultiSimConfigChanged: DSDS mode enabled; setting VOICE & SMS subId to -1 (No Preference)");
        SubscriptionController.getInstance().setDefaultVoiceSubId(-1);
    }

    private void setMultiSimProperties(int i) {
        this.mMi.setMultiSimProperties(i);
    }

    @VisibleForTesting
    public static void notifyMultiSimConfigChange(int i) {
        sMultiSimConfigChangeRegistrants.notifyResult(Integer.valueOf(i));
    }

    public static void registerForMultiSimConfigChange(Handler handler, int i, Object obj) {
        sMultiSimConfigChangeRegistrants.addUnique(handler, i, obj);
    }

    public static void unregisterForMultiSimConfigChange(Handler handler) {
        sMultiSimConfigChangeRegistrants.remove(handler);
    }

    public static void unregisterAllMultiSimConfigChangeRegistrants() {
        sMultiSimConfigChangeRegistrants.removeAll();
    }

    private void broadcastMultiSimConfigChange(int i) {
        log("broadcastSimSlotNumChange numOfActiveModems" + i);
        notifyMultiSimConfigChange(i);
        Intent intent = new Intent("android.telephony.action.MULTI_SIM_CONFIG_CHANGED");
        intent.putExtra("android.telephony.extra.ACTIVE_SIM_SUPPORTED_COUNT", i);
        this.mContext.sendBroadcast(intent);
    }

    public boolean setModemService(String str) {
        boolean z;
        boolean z2;
        if (this.mRadioConfig == null || this.mPhones[0] == null) {
            return false;
        }
        log("setModemService: " + str);
        if (SystemProperties.getBoolean(ALLOW_MOCK_MODEM_PROPERTY, false) || DEBUG) {
            if (str != null) {
                z2 = this.mRadioConfig.setModemService(str);
                z = this.mPhones[0].mCi.setModemService(str);
            } else {
                boolean modemService = this.mRadioConfig.setModemService((String) null);
                z = this.mPhones[0].mCi.setModemService((String) null);
                z2 = modemService;
            }
            if (!z2 || !z) {
                return false;
            }
            return true;
        }
        loge("setModemService is not allowed");
        return false;
    }

    public String getModemService() {
        Phone phone = this.mPhones[0];
        if (phone == null) {
            return "";
        }
        return phone.mCi.getModemService();
    }

    @VisibleForTesting
    public static class MockableInterface {
        @VisibleForTesting
        public boolean isRebootRequiredForModemConfigChange() {
            boolean booleanValue = TelephonyProperties.reboot_on_modem_change().orElse(Boolean.FALSE).booleanValue();
            PhoneConfigurationManager.log("isRebootRequiredForModemConfigChange: isRebootRequired = " + booleanValue);
            return booleanValue;
        }

        @VisibleForTesting
        public void setMultiSimProperties(int i) {
            String str = i != 2 ? i != 3 ? "" : PhoneConfigurationManager.TSTS : PhoneConfigurationManager.DSDS;
            PhoneConfigurationManager.log("setMultiSimProperties to " + str);
            TelephonyProperties.multi_sim_config(str);
        }

        @VisibleForTesting
        public void notifyPhoneFactoryOnMultiSimConfigChanged(Context context, int i) {
            PhoneFactory.onMultiSimConfigChanged(context, i);
        }
    }

    /* access modifiers changed from: private */
    public static void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    private static void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    private static void loge(String str, Exception exc) {
        Rlog.e(LOG_TAG, str, exc);
    }
}
