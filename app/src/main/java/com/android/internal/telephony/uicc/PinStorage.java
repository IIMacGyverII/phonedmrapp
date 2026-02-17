package com.android.internal.telephony.uicc;

import android.app.KeyguardManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.security.keystore.KeyGenParameterSpec;
import android.telephony.TelephonyManager;
import android.util.Base64;
import android.util.SparseArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.SubscriptionInfoUpdater;
import com.android.internal.telephony.TelephonyStatsLog;
import com.android.internal.telephony.nano.StoredPinProto;
import com.android.internal.telephony.protobuf.nano.MessageNano;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.util.ArrayUtils;
import com.android.telephony.Rlog;
import com.mediatek.aee.ExceptionLogImpl;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.security.KeyStore;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;

public class PinStorage extends Handler {
    private static final String ANDROID_KEY_STORE_PROVIDER = "AndroidKeyStore";
    private static final int CARRIER_CONFIG_CHANGED_EVENT = 2;
    private static final String CIPHER_TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_PARAMETER_TAG_BIT_LEN = 128;
    private static final int ICC_CHANGED_EVENT = 1;
    private static final String KEYSTORE_ALIAS_LONG_TERM_ALWAYS = "PinStorage_longTerm_always_key";
    private static final String KEYSTORE_ALIAS_LONG_TERM_USER_AUTH = "PinStorage_longTerm_ua_key";
    private static final String KEYSTORE_ALIAS_SHORT_TERM = "PinStorage_shortTerm_key";
    private static final int MAX_PIN_LENGTH = 8;
    private static final int MIN_ICCID_LENGTH = 12;
    private static final int MIN_PIN_LENGTH = 4;
    private static final String SHARED_PREFS_AVAILABLE_PIN_BASE_KEY = "encrypted_pin_available_";
    private static final String SHARED_PREFS_NAME = "pinstorage_prefs";
    private static final String SHARED_PREFS_REBOOT_PIN_BASE_KEY = "encrypted_pin_reboot_";
    private static final String SHARED_PREFS_STORED_PINS = "stored_pins";
    private static final int SHORT_TERM_KEY_DURATION_MINUTES = 15;
    private static final int SUPPLY_PIN_COMPLETE = 5;
    private static final String TAG = "PinStorage";
    private static final int TIMER_EXPIRATION_EVENT = 3;
    private static final int TIMER_VALUE_AFTER_OTA_MILLIS = 20000;
    private static final int TIMER_VALUE_BEFORE_OTA_MILLIS = 20000;
    private static final int USER_UNLOCKED_EVENT = 4;
    private static final boolean VDBG = false;
    private final int mBootCount;
    private final BroadcastReceiver mCarrierConfigChangedReceiver;
    private final Context mContext;
    private boolean mIsDeviceLocked;
    private boolean mIsDeviceSecure;
    private final KeyStore mKeyStore;
    private boolean mLastCommitResult = true;
    private SecretKey mLongTermSecretKey;
    private final SparseArray<byte[]> mRamStorage;
    private SecretKey mShortTermSecretKey;
    @VisibleForTesting
    public int mShortTermSecretKeyDurationMinutes;

    private static void logv(String str, Object... objArr) {
    }

    public PinStorage(Context context) {
        AnonymousClass1 r1 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                if ("android.telephony.action.CARRIER_CONFIG_CHANGED".equals(action)) {
                    int intExtra = intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1);
                    PinStorage pinStorage = PinStorage.this;
                    pinStorage.sendMessage(pinStorage.obtainMessage(2, intExtra, 0));
                } else if ("android.telephony.action.SIM_CARD_STATE_CHANGED".equals(action) || "android.telephony.action.SIM_APPLICATION_STATE_CHANGED".equals(action)) {
                    int intExtra2 = intent.getIntExtra("phone", -1);
                    int intExtra3 = intent.getIntExtra("android.telephony.extra.SIM_STATE", 0);
                    if (PinStorage.this.validateSlotId(intExtra2)) {
                        PinStorage pinStorage2 = PinStorage.this;
                        pinStorage2.sendMessage(pinStorage2.obtainMessage(1, intExtra2, intExtra3));
                    }
                } else if ("android.intent.action.USER_UNLOCKED".equals(action)) {
                    PinStorage pinStorage3 = PinStorage.this;
                    pinStorage3.sendMessage(pinStorage3.obtainMessage(4));
                }
            }
        };
        this.mCarrierConfigChangedReceiver = r1;
        this.mContext = context;
        this.mBootCount = getBootCount();
        this.mKeyStore = initializeKeyStore();
        this.mShortTermSecretKeyDurationMinutes = 15;
        boolean isDeviceSecure = isDeviceSecure();
        this.mIsDeviceSecure = isDeviceSecure;
        this.mIsDeviceLocked = isDeviceSecure ? isDeviceLocked() : false;
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        intentFilter.addAction("android.telephony.action.SIM_CARD_STATE_CHANGED");
        intentFilter.addAction("android.telephony.action.SIM_APPLICATION_STATE_CHANGED");
        intentFilter.addAction("android.intent.action.USER_UNLOCKED");
        context.registerReceiver(r1, intentFilter);
        this.mLongTermSecretKey = initializeSecretKey((!this.mIsDeviceSecure || this.mIsDeviceLocked) ? KEYSTORE_ALIAS_LONG_TERM_ALWAYS : KEYSTORE_ALIAS_LONG_TERM_USER_AUTH, true);
        if (!this.mIsDeviceSecure || !this.mIsDeviceLocked) {
            this.mRamStorage = null;
            onDeviceReady();
            return;
        }
        logd("Device is locked - Postponing initialization", new Object[0]);
        this.mRamStorage = new SparseArray<>();
    }

    public synchronized void storePin(String str, int i) {
        String iccid = getIccid(i);
        if (validatePin(str) && validateIccid(iccid)) {
            if (validateSlotId(i)) {
                if (!isCacheAllowed(i)) {
                    logd("storePin[%d]: caching it not allowed", Integer.valueOf(i));
                    return;
                }
                logd("storePin[%d]", Integer.valueOf(i));
                StoredPinProto.StoredPin storedPin = new StoredPinProto.StoredPin();
                storedPin.iccid = iccid;
                storedPin.pin = str;
                storedPin.slotId = i;
                storedPin.status = 1;
                savePinInformation(i, storedPin);
                return;
            }
        }
        loge("storePin[%d] - Invalid PIN, slotId or ICCID", Integer.valueOf(i));
        clearPin(i);
    }

    public synchronized void clearPin(int i) {
        logd("clearPin[%d]", Integer.valueOf(i));
        if (validateSlotId(i)) {
            savePinInformation(i, (StoredPinProto.StoredPin) null);
        }
    }

    public synchronized String getPin(int i, String str) {
        if (validateSlotId(i)) {
            if (validateIccid(str)) {
                StoredPinProto.StoredPin loadPinInformation = loadPinInformation(i);
                if (loadPinInformation != null) {
                    if (!loadPinInformation.iccid.equals(str)) {
                        savePinInformation(i, (StoredPinProto.StoredPin) null);
                        TelephonyStatsLog.write(336, 6, 1, "");
                    } else if (loadPinInformation.status == 3) {
                        logd("getPin[%d] - Found PIN ready for verification", Integer.valueOf(i));
                        loadPinInformation.status = 1;
                        savePinInformation(i, loadPinInformation);
                        return loadPinInformation.pin;
                    }
                }
                return "";
            }
        }
        return "";
    }

    /* JADX WARNING: Removed duplicated region for block: B:38:0x0083  */
    /* JADX WARNING: Removed duplicated region for block: B:39:0x0095  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized int prepareUnattendedReboot(android.os.WorkSource r12) {
        /*
            r11 = this;
            monitor-enter(r11)
            boolean r0 = r11.mIsDeviceLocked     // Catch:{ all -> 0x00ad }
            r1 = 2
            r2 = 0
            if (r0 == 0) goto L_0x0010
            java.lang.String r12 = "prepareUnattendedReboot - Device is locked"
            java.lang.Object[] r0 = new java.lang.Object[r2]     // Catch:{ all -> 0x00ad }
            loge((java.lang.String) r12, (java.lang.Object[]) r0)     // Catch:{ all -> 0x00ad }
            monitor-exit(r11)
            return r1
        L_0x0010:
            r0 = 20000(0x4e20, float:2.8026E-41)
            boolean r0 = r11.startTimer(r0)     // Catch:{ all -> 0x00ad }
            if (r0 != 0) goto L_0x001a
            monitor-exit(r11)
            return r1
        L_0x001a:
            int r0 = r11.getSlotCount()     // Catch:{ all -> 0x00ad }
            android.util.SparseArray r3 = r11.loadPinInformation()     // Catch:{ all -> 0x00ad }
            java.lang.String r4 = "PinStorage_shortTerm_key"
            r11.deleteSecretKey(r4)     // Catch:{ all -> 0x00ad }
            r4 = 0
            r11.mShortTermSecretKey = r4     // Catch:{ all -> 0x00ad }
            int r4 = r3.size()     // Catch:{ all -> 0x00ad }
            r5 = 1
            if (r4 <= 0) goto L_0x0039
            java.lang.String r4 = "PinStorage_shortTerm_key"
            javax.crypto.SecretKey r4 = r11.initializeSecretKey(r4, r5)     // Catch:{ all -> 0x00ad }
            r11.mShortTermSecretKey = r4     // Catch:{ all -> 0x00ad }
        L_0x0039:
            r4 = r2
            r6 = r4
            r7 = r6
            r8 = r7
        L_0x003d:
            if (r4 >= r0) goto L_0x006e
            java.lang.Object r9 = r3.get(r4)     // Catch:{ all -> 0x00ad }
            com.android.internal.telephony.nano.StoredPinProto$StoredPin r9 = (com.android.internal.telephony.nano.StoredPinProto.StoredPin) r9     // Catch:{ all -> 0x00ad }
            if (r9 == 0) goto L_0x0053
            r9.status = r1     // Catch:{ all -> 0x00ad }
            boolean r9 = r11.savePinInformation(r4, r9)     // Catch:{ all -> 0x00ad }
            if (r9 != 0) goto L_0x0050
            goto L_0x006f
        L_0x0050:
            int r6 = r6 + 1
            goto L_0x006b
        L_0x0053:
            com.android.internal.telephony.uicc.IccCardStatus$PinState r9 = com.android.internal.telephony.uicc.IccCardStatus.PinState.PINSTATE_ENABLED_VERIFIED     // Catch:{ all -> 0x00ad }
            boolean r9 = r11.isPinState(r4, r9)     // Catch:{ all -> 0x00ad }
            if (r9 == 0) goto L_0x006b
            java.lang.String r7 = "Slot %d requires PIN and is not cached"
            java.lang.Object[] r9 = new java.lang.Object[r5]     // Catch:{ all -> 0x00ad }
            java.lang.Integer r10 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x00ad }
            r9[r2] = r10     // Catch:{ all -> 0x00ad }
            loge((java.lang.String) r7, (java.lang.Object[]) r9)     // Catch:{ all -> 0x00ad }
            int r8 = r8 + 1
            r7 = r5
        L_0x006b:
            int r4 = r4 + 1
            goto L_0x003d
        L_0x006e:
            r1 = r7
        L_0x006f:
            if (r12 == 0) goto L_0x007d
            int r0 = r12.size()     // Catch:{ all -> 0x00ad }
            if (r0 != 0) goto L_0x0078
            goto L_0x007d
        L_0x0078:
            java.lang.String r12 = r12.getPackageName(r2)     // Catch:{ all -> 0x00ad }
            goto L_0x007f
        L_0x007d:
            java.lang.String r12 = ""
        L_0x007f:
            r0 = 336(0x150, float:4.71E-43)
            if (r1 != 0) goto L_0x0095
            java.lang.String r3 = "prepareUnattendedReboot - Stored %d PINs"
            java.lang.Object[] r4 = new java.lang.Object[r5]     // Catch:{ all -> 0x00ad }
            java.lang.Integer r5 = java.lang.Integer.valueOf(r6)     // Catch:{ all -> 0x00ad }
            r4[r2] = r5     // Catch:{ all -> 0x00ad }
            logd(r3, r4)     // Catch:{ all -> 0x00ad }
            r2 = 4
            com.android.internal.telephony.TelephonyStatsLog.write(r0, r2, r6, r12)     // Catch:{ all -> 0x00ad }
            goto L_0x00a8
        L_0x0095:
            if (r1 != r5) goto L_0x00a8
            java.lang.String r3 = "prepareUnattendedReboot - Required %d PINs after reboot"
            java.lang.Object[] r4 = new java.lang.Object[r5]     // Catch:{ all -> 0x00ad }
            java.lang.Integer r5 = java.lang.Integer.valueOf(r8)     // Catch:{ all -> 0x00ad }
            r4[r2] = r5     // Catch:{ all -> 0x00ad }
            logd(r3, r4)     // Catch:{ all -> 0x00ad }
            r2 = 5
            com.android.internal.telephony.TelephonyStatsLog.write(r0, r2, r8, r12)     // Catch:{ all -> 0x00ad }
        L_0x00a8:
            r11.saveNumberOfCachedPins(r6)     // Catch:{ all -> 0x00ad }
            monitor-exit(r11)
            return r1
        L_0x00ad:
            r12 = move-exception
            monitor-exit(r11)
            throw r12
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.PinStorage.prepareUnattendedReboot(android.os.WorkSource):int");
    }

    private synchronized void onUserUnlocked() {
        if (this.mIsDeviceLocked) {
            logd("onUserUnlocked - Device is unlocked", new Object[0]);
            SparseArray<StoredPinProto.StoredPin> loadPinInformation = loadPinInformation();
            cleanRamStorage();
            this.mIsDeviceLocked = false;
            this.mLongTermSecretKey = initializeSecretKey(KEYSTORE_ALIAS_LONG_TERM_USER_AUTH, true);
            for (int i = 0; i < loadPinInformation.size(); i++) {
                savePinInformation(loadPinInformation.keyAt(i), loadPinInformation.valueAt(i));
            }
            onDeviceReady();
            verifyPendingPins();
        }
    }

    private void onDeviceReady() {
        logd("onDeviceReady", new Object[0]);
        this.mShortTermSecretKey = initializeSecretKey(KEYSTORE_ALIAS_SHORT_TERM, false);
        int slotCount = getSlotCount();
        int i = 0;
        for (int i2 = 0; i2 < slotCount; i2++) {
            StoredPinProto.StoredPin loadPinInformation = loadPinInformation(i2);
            if (loadPinInformation != null) {
                if (loadPinInformation.status == 1) {
                    if (loadPinInformation.bootCount != this.mBootCount) {
                        logd("Boot count [%d] does not match - remove PIN", Integer.valueOf(i2));
                        savePinInformation(i2, (StoredPinProto.StoredPin) null);
                    } else {
                        logd("Boot count [%d] matches - keep stored PIN", Integer.valueOf(i2));
                    }
                }
                if (loadPinInformation.status == 2) {
                    loadPinInformation.status = 3;
                    savePinInformation(i2, loadPinInformation);
                    i++;
                }
            }
        }
        if (i > 0) {
            startTimer(20000);
        }
        int saveNumberOfCachedPins = saveNumberOfCachedPins(0);
        if (saveNumberOfCachedPins > i) {
            TelephonyStatsLog.write(336, 7, saveNumberOfCachedPins - i, "");
        }
    }

    private synchronized void onTimerExpiration() {
        logd("onTimerExpiration", new Object[0]);
        int slotCount = getSlotCount();
        int i = 0;
        for (int i2 = 0; i2 < slotCount; i2++) {
            StoredPinProto.StoredPin loadPinInformation = loadPinInformation(i2);
            if (loadPinInformation != null) {
                int i3 = loadPinInformation.status;
                if (i3 == 3) {
                    logd("onTimerExpiration - Discarding PIN in slot %d", Integer.valueOf(i2));
                    savePinInformation(i2, (StoredPinProto.StoredPin) null);
                    i++;
                } else if (i3 == 2) {
                    logd("onTimerExpiration - Moving PIN in slot %d back to AVAILABLE", Integer.valueOf(i2));
                    loadPinInformation.status = 1;
                    savePinInformation(i2, loadPinInformation);
                }
            }
        }
        deleteSecretKey(KEYSTORE_ALIAS_SHORT_TERM);
        this.mShortTermSecretKey = null;
        saveNumberOfCachedPins(0);
        if (i > 0) {
            TelephonyStatsLog.write(336, 3, i, "");
        }
    }

    private synchronized void onSimStatusChange(int i, @TelephonyManager.SimState int i2) {
        logd("SIM card/application changed[%d]: %s", Integer.valueOf(i), SubscriptionInfoUpdater.simStateString(i2));
        switch (i2) {
            case 1:
            case 2:
                StoredPinProto.StoredPin loadPinInformation = loadPinInformation(i);
                if (!(loadPinInformation == null || loadPinInformation.status == 3)) {
                    savePinInformation(i, (StoredPinProto.StoredPin) null);
                    break;
                }
            case 3:
            case 7:
            case 8:
                clearPin(i);
                break;
            case 4:
            case 5:
            case 9:
            case 10:
                StoredPinProto.StoredPin loadPinInformation2 = loadPinInformation(i);
                if (!(loadPinInformation2 == null || loadPinInformation2.status == 1)) {
                    savePinInformation(i, (StoredPinProto.StoredPin) null);
                    break;
                }
        }
    }

    private void onCarrierConfigChanged(int i) {
        logv("onCarrierConfigChanged[%d]", Integer.valueOf(i));
        if (!isCacheAllowed(i)) {
            logd("onCarrierConfigChanged[%d] - PIN caching not allowed", Integer.valueOf(i));
            clearPin(i);
        }
    }

    private void onSupplyPinComplete(int i, boolean z) {
        int i2 = 2;
        logd("onSupplyPinComplete[%d] - success: %s", Integer.valueOf(i), Boolean.valueOf(z));
        if (!z) {
            clearPin(i);
        }
        if (z) {
            i2 = 1;
        }
        TelephonyStatsLog.write(336, i2, 1, "");
    }

    public void handleMessage(Message message) {
        int i = message.what;
        boolean z = true;
        if (i == 1) {
            onSimStatusChange(message.arg1, message.arg2);
        } else if (i == 2) {
            onCarrierConfigChanged(message.arg1);
        } else if (i == 3) {
            onTimerExpiration();
        } else if (i == 4) {
            onUserUnlocked();
        } else if (i == 5) {
            AsyncResult asyncResult = (AsyncResult) message.obj;
            if (asyncResult == null || asyncResult.exception != null) {
                z = false;
            }
            onSupplyPinComplete(message.arg2, z);
        }
    }

    private boolean isDeviceSecure() {
        KeyguardManager keyguardManager = (KeyguardManager) this.mContext.getSystemService(KeyguardManager.class);
        if (keyguardManager != null) {
            return keyguardManager.isDeviceSecure();
        }
        return false;
    }

    private boolean isDeviceLocked() {
        KeyguardManager keyguardManager = (KeyguardManager) this.mContext.getSystemService(KeyguardManager.class);
        if (keyguardManager == null || !keyguardManager.isDeviceSecure() || !keyguardManager.isDeviceLocked()) {
            return false;
        }
        return true;
    }

    private SparseArray<StoredPinProto.StoredPin> loadPinInformation() {
        SparseArray<StoredPinProto.StoredPin> sparseArray = new SparseArray<>();
        int slotCount = getSlotCount();
        for (int i = 0; i < slotCount; i++) {
            StoredPinProto.StoredPin loadPinInformation = loadPinInformation(i);
            if (loadPinInformation != null) {
                sparseArray.put(i, loadPinInformation);
            }
        }
        return sparseArray;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:16:0x0043, code lost:
        if (r5 != null) goto L_0x0047;
     */
    /* JADX WARNING: Removed duplicated region for block: B:22:0x004e  */
    /* JADX WARNING: Removed duplicated region for block: B:23:0x0063  */
    /* JADX WARNING: Removed duplicated region for block: B:25:0x0066  */
    /* JADX WARNING: Removed duplicated region for block: B:26:0x0074  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private com.android.internal.telephony.nano.StoredPinProto.StoredPin loadPinInformation(int r6) {
        /*
            r5 = this;
            boolean r0 = r5.mLastCommitResult
            r1 = 0
            r2 = 0
            if (r0 != 0) goto L_0x000e
            java.lang.Object[] r5 = new java.lang.Object[r2]
            java.lang.String r6 = "Last commit failed - returning empty values"
            loge((java.lang.String) r6, (java.lang.Object[]) r5)
            return r1
        L_0x000e:
            boolean r0 = r5.mIsDeviceLocked
            if (r0 == 0) goto L_0x002b
            android.util.SparseArray<byte[]> r0 = r5.mRamStorage
            if (r0 == 0) goto L_0x0046
            java.lang.Object r0 = r0.get(r6)
            if (r0 == 0) goto L_0x0046
            android.util.SparseArray<byte[]> r0 = r5.mRamStorage
            java.lang.Object r0 = r0.get(r6)
            byte[] r0 = (byte[]) r0
            javax.crypto.SecretKey r3 = r5.mLongTermSecretKey
            com.android.internal.telephony.nano.StoredPinProto$StoredPin r5 = r5.decryptStoredPin(r0, r3)
            goto L_0x0047
        L_0x002b:
            javax.crypto.SecretKey r0 = r5.mLongTermSecretKey
            java.lang.String r3 = "encrypted_pin_available_"
            com.android.internal.telephony.nano.StoredPinProto$StoredPin r0 = r5.loadPinInformationFromDisk(r6, r3, r0)
            javax.crypto.SecretKey r3 = r5.mShortTermSecretKey
            java.lang.String r4 = "encrypted_pin_reboot_"
            com.android.internal.telephony.nano.StoredPinProto$StoredPin r5 = r5.loadPinInformationFromDisk(r6, r4, r3)
            if (r0 == 0) goto L_0x0041
            if (r5 != 0) goto L_0x0041
            r5 = r0
            goto L_0x0047
        L_0x0041:
            if (r0 != 0) goto L_0x0046
            if (r5 == 0) goto L_0x0046
            goto L_0x0047
        L_0x0046:
            r5 = r1
        L_0x0047:
            r0 = 1
            if (r5 == 0) goto L_0x0063
            int r3 = r5.slotId
            if (r3 == r6) goto L_0x0063
            r5 = 2
            java.lang.Object[] r5 = new java.lang.Object[r5]
            java.lang.Integer r3 = java.lang.Integer.valueOf(r3)
            r5[r2] = r3
            java.lang.Integer r3 = java.lang.Integer.valueOf(r6)
            r5[r0] = r3
            java.lang.String r3 = "Load PIN: slot ID does not match (%d != %d)"
            loge((java.lang.String) r3, (java.lang.Object[]) r5)
            goto L_0x0064
        L_0x0063:
            r1 = r5
        L_0x0064:
            if (r1 == 0) goto L_0x0074
            java.lang.Object[] r5 = new java.lang.Object[r0]
            java.lang.String r6 = r1.toString()
            r5[r2] = r6
            java.lang.String r6 = "Load PIN: %s"
            logv(r6, r5)
            goto L_0x0081
        L_0x0074:
            java.lang.Object[] r5 = new java.lang.Object[r0]
            java.lang.Integer r6 = java.lang.Integer.valueOf(r6)
            r5[r2] = r6
            java.lang.String r6 = "Load PIN for slot %d: null"
            logv(r6, r5)
        L_0x0081:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.PinStorage.loadPinInformation(int):com.android.internal.telephony.nano.StoredPinProto$StoredPin");
    }

    private StoredPinProto.StoredPin loadPinInformationFromDisk(int i, String str, SecretKey secretKey) {
        SharedPreferences sharedPreferences = this.mContext.getSharedPreferences(SHARED_PREFS_NAME, 0);
        String string = sharedPreferences.getString(str + i, "");
        if (string.isEmpty()) {
            return null;
        }
        try {
            return decryptStoredPin(Base64.decode(string, 0), secretKey);
        } catch (Exception unused) {
            return null;
        }
    }

    private StoredPinProto.StoredPin decryptStoredPin(byte[] bArr, SecretKey secretKey) {
        if (secretKey == null) {
            return null;
        }
        try {
            byte[] decrypt = decrypt(secretKey, bArr);
            if (decrypt.length > 0) {
                return StoredPinProto.StoredPin.parseFrom(decrypt);
            }
            return null;
        } catch (Exception e) {
            loge("cannot decrypt/parse PIN information", (Throwable) e);
            return null;
        }
    }

    private boolean savePinInformation(int i, StoredPinProto.StoredPin storedPin) {
        boolean z;
        if (storedPin != null) {
            storedPin.bootCount = this.mBootCount;
        }
        if (this.mIsDeviceLocked) {
            return savePinInformationToRam(i, storedPin);
        }
        boolean z2 = false;
        SharedPreferences.Editor remove = this.mContext.getSharedPreferences(SHARED_PREFS_NAME, 0).edit().remove(SHARED_PREFS_AVAILABLE_PIN_BASE_KEY + i).remove(SHARED_PREFS_REBOOT_PIN_BASE_KEY + i);
        if (storedPin != null) {
            logd("Saving PIN for slot %d", Integer.valueOf(i));
            if (storedPin.status == 1) {
                z = savePinInformation(remove, i, storedPin, SHARED_PREFS_AVAILABLE_PIN_BASE_KEY, this.mLongTermSecretKey);
            } else {
                z = savePinInformation(remove, i, storedPin, SHARED_PREFS_REBOOT_PIN_BASE_KEY, this.mShortTermSecretKey);
            }
        } else {
            logv("Deleting PIN for slot %d (if existed)", Integer.valueOf(i));
            z = true;
        }
        if (remove.commit() && z) {
            z2 = true;
        }
        this.mLastCommitResult = z2;
        return z2;
    }

    private boolean savePinInformation(SharedPreferences.Editor editor, int i, StoredPinProto.StoredPin storedPin, String str, SecretKey secretKey) {
        if (secretKey == null) {
            return false;
        }
        if (i != storedPin.slotId) {
            loge("Save PIN: the slotId does not match (%d != %d)", Integer.valueOf(i), Integer.valueOf(storedPin.slotId));
            return false;
        }
        logv("Save PIN: %s", storedPin.toString());
        byte[] encrypt = encrypt(secretKey, MessageNano.toByteArray(storedPin));
        if (encrypt.length <= 0) {
            return false;
        }
        editor.putString(str + i, Base64.encodeToString(encrypt, 0));
        return true;
    }

    private boolean savePinInformationToRam(int i, StoredPinProto.StoredPin storedPin) {
        byte[] encrypt;
        cleanRamStorage(i);
        if (storedPin == null) {
            return true;
        }
        if (storedPin.status != 1 || (encrypt = encrypt(this.mLongTermSecretKey, MessageNano.toByteArray(storedPin))) == null || encrypt.length <= 0) {
            return false;
        }
        logd("Saving PIN for slot %d in RAM", Integer.valueOf(i));
        this.mRamStorage.put(i, encrypt);
        return true;
    }

    private void cleanRamStorage() {
        int slotCount = getSlotCount();
        for (int i = 0; i < slotCount; i++) {
            cleanRamStorage(i);
        }
    }

    private void cleanRamStorage(int i) {
        SparseArray<byte[]> sparseArray = this.mRamStorage;
        if (sparseArray != null) {
            byte[] bArr = sparseArray.get(i);
            if (bArr != null) {
                Arrays.fill(bArr, (byte) 0);
            }
            this.mRamStorage.delete(i);
        }
    }

    private void verifyPendingPins() {
        int slotCount = getSlotCount();
        for (int i = 0; i < slotCount; i++) {
            if (isPinState(i, IccCardStatus.PinState.PINSTATE_ENABLED_NOT_VERIFIED)) {
                verifyPendingPin(i);
            }
        }
    }

    private void verifyPendingPin(int i) {
        String pin = getPin(i, getIccid(i));
        if (!pin.isEmpty()) {
            logd("Perform automatic verification of PIN in slot %d", Integer.valueOf(i));
            UiccProfile uiccProfileForPhone = UiccController.getInstance().getUiccProfileForPhone(i);
            if (uiccProfileForPhone != null) {
                Message obtainMessage = obtainMessage(5);
                obtainMessage.arg2 = i;
                uiccProfileForPhone.supplyPin(pin, obtainMessage);
                return;
            }
            logd("Perform automatic verification of PIN in slot %d not possible", Integer.valueOf(i));
        }
    }

    private int getBootCount() {
        return Settings.Global.getInt(this.mContext.getContentResolver(), "boot_count", -1);
    }

    private int getSlotCount() {
        try {
            return PhoneFactory.getPhones().length;
        } catch (Exception unused) {
            return TelephonyManager.getDefault().getActiveModemCount();
        }
    }

    private int saveNumberOfCachedPins(int i) {
        SharedPreferences sharedPreferences = this.mContext.getSharedPreferences(SHARED_PREFS_NAME, 0);
        int i2 = sharedPreferences.getInt(SHARED_PREFS_STORED_PINS, 0);
        sharedPreferences.edit().putInt(SHARED_PREFS_STORED_PINS, i).commit();
        return i2;
    }

    private boolean startTimer(int i) {
        removeMessages(3);
        if (i > 0) {
            return sendEmptyMessageDelayed(3, (long) i);
        }
        return true;
    }

    private String getIccid(int i) {
        Phone phone = PhoneFactory.getPhone(i);
        return phone != null ? phone.getFullIccSerialNumber() : "";
    }

    private boolean validatePin(String str) {
        return str != null && str.length() >= 4 && str.length() <= 8;
    }

    private boolean validateIccid(String str) {
        return str != null && str.length() >= 12;
    }

    /* access modifiers changed from: private */
    public boolean validateSlotId(int i) {
        return i >= 0 && i < getSlotCount();
    }

    private boolean isPinState(int i, IccCardStatus.PinState pinState) {
        UiccProfile uiccProfileForPhone = UiccController.getInstance().getUiccProfileForPhone(i);
        if (uiccProfileForPhone != null) {
            int i2 = 0;
            while (i2 < 3) {
                UiccCardApplication application = uiccProfileForPhone.getApplication(i2);
                if (application == null) {
                    i2++;
                } else if (application.getPin1State() == pinState) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        return false;
    }

    private boolean isCacheAllowed(int i) {
        return isCacheAllowedByDevice();
    }

    private boolean isCacheAllowedByDevice() {
        if (this.mContext.getResources().getBoolean(17891365)) {
            return true;
        }
        logv("Pin caching disabled in resources", new Object[0]);
        return false;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x000c, code lost:
        r2 = com.android.internal.telephony.PhoneFactory.getPhone(r2);
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean isCacheAllowedByCarrier(int r2) {
        /*
            r1 = this;
            android.content.Context r1 = r1.mContext
            java.lang.Class<android.telephony.CarrierConfigManager> r0 = android.telephony.CarrierConfigManager.class
            java.lang.Object r1 = r1.getSystemService(r0)
            android.telephony.CarrierConfigManager r1 = (android.telephony.CarrierConfigManager) r1
            if (r1 == 0) goto L_0x001b
            com.android.internal.telephony.Phone r2 = com.android.internal.telephony.PhoneFactory.getPhone(r2)
            if (r2 == 0) goto L_0x001b
            int r2 = r2.getSubId()
            android.os.PersistableBundle r1 = r1.getConfigForSubId(r2)
            goto L_0x001c
        L_0x001b:
            r1 = 0
        L_0x001c:
            if (r1 != 0) goto L_0x0022
            android.os.PersistableBundle r1 = android.telephony.CarrierConfigManager.getDefaultConfig()
        L_0x0022:
            r2 = 1
            java.lang.String r0 = "store_sim_pin_for_unattended_reboot_bool"
            boolean r1 = r1.getBoolean(r0, r2)
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.PinStorage.isCacheAllowedByCarrier(int):boolean");
    }

    private static KeyStore initializeKeyStore() {
        try {
            KeyStore instance = KeyStore.getInstance(ANDROID_KEY_STORE_PROVIDER);
            instance.load((KeyStore.LoadStoreParameter) null);
            logv("KeyStore ready", new Object[0]);
            return instance;
        } catch (Exception e) {
            loge("Error loading KeyStore", (Throwable) e);
            return null;
        }
    }

    private SecretKey initializeSecretKey(String str, boolean z) {
        Date date = null;
        if (this.mKeyStore == null) {
            return null;
        }
        SecretKey secretKey = getSecretKey(str);
        if (secretKey != null) {
            logd("KeyStore: alias %s exists", str);
            return secretKey;
        } else if (z) {
            if (KEYSTORE_ALIAS_SHORT_TERM.equals(str)) {
                date = getShortLivedKeyValidityEnd();
            }
            boolean z2 = !KEYSTORE_ALIAS_LONG_TERM_ALWAYS.equals(str) && isDeviceSecure();
            Object[] objArr = new Object[3];
            objArr[0] = str;
            objArr[1] = date != null ? date.toString() : "";
            objArr[2] = Boolean.valueOf(z2);
            logd("KeyStore: alias %s does not exist - Creating (exp=%s, auth=%s)", objArr);
            return createSecretKey(str, date, z2);
        } else {
            logd("KeyStore: alias %s does not exist - Nothing to do", str);
            return null;
        }
    }

    private SecretKey getSecretKey(String str) {
        try {
            KeyStore.SecretKeyEntry secretKeyEntry = (KeyStore.SecretKeyEntry) this.mKeyStore.getEntry(str, (KeyStore.ProtectionParameter) null);
            if (secretKeyEntry != null) {
                return secretKeyEntry.getSecretKey();
            }
        } catch (Exception e) {
            loge("Exception with getting the key " + str, (Throwable) e);
            deleteSecretKey(str);
        }
        return null;
    }

    private SecretKey createSecretKey(String str, Date date, boolean z) {
        try {
            KeyGenerator instance = KeyGenerator.getInstance(ExceptionLogImpl.TAG, ANDROID_KEY_STORE_PROVIDER);
            KeyGenParameterSpec.Builder encryptionPaddings = new KeyGenParameterSpec.Builder(str, 3).setBlockModes(new String[]{"GCM"}).setEncryptionPaddings(new String[]{"NoPadding"});
            if (date != null) {
                encryptionPaddings = encryptionPaddings.setKeyValidityEnd(date);
            }
            if (z) {
                encryptionPaddings = encryptionPaddings.setUserAuthenticationRequired(true).setUserAuthenticationParameters(Integer.MAX_VALUE, 1);
            }
            instance.init(encryptionPaddings.build());
            return instance.generateKey();
        } catch (Exception e) {
            loge("Create key exception", (Throwable) e);
            return null;
        }
    }

    private Date getShortLivedKeyValidityEnd() {
        if (this.mShortTermSecretKeyDurationMinutes <= 0) {
            return null;
        }
        Calendar instance = Calendar.getInstance();
        instance.setTime(new Date());
        instance.add(12, this.mShortTermSecretKeyDurationMinutes);
        return instance.getTime();
    }

    private void deleteSecretKey(String str) {
        if (this.mKeyStore != null) {
            logd("Delete key: %s", str);
            try {
                this.mKeyStore.deleteEntry(str);
            } catch (Exception unused) {
                loge("Delete key exception", new Object[0]);
            }
        }
    }

    private byte[] encrypt(SecretKey secretKey, byte[] bArr) {
        if (secretKey == null) {
            loge("Encrypt: Secret key is null", new Object[0]);
            return new byte[0];
        }
        try {
            Cipher instance = Cipher.getInstance(CIPHER_TRANSFORMATION);
            instance.init(1, secretKey);
            StoredPinProto.EncryptedPin encryptedPin = new StoredPinProto.EncryptedPin();
            encryptedPin.iv = instance.getIV();
            encryptedPin.encryptedStoredPin = instance.doFinal(bArr);
            return MessageNano.toByteArray(encryptedPin);
        } catch (Exception e) {
            loge("Encrypt exception", (Throwable) e);
            TelephonyStatsLog.write(336, 9, 1, "");
            return new byte[0];
        }
    }

    private byte[] decrypt(SecretKey secretKey, byte[] bArr) {
        if (secretKey == null) {
            loge("Decrypt: Secret key is null", new Object[0]);
            return new byte[0];
        }
        try {
            StoredPinProto.EncryptedPin parseFrom = StoredPinProto.EncryptedPin.parseFrom(bArr);
            if (!ArrayUtils.isEmpty(parseFrom.encryptedStoredPin) && !ArrayUtils.isEmpty(parseFrom.iv)) {
                Cipher instance = Cipher.getInstance(CIPHER_TRANSFORMATION);
                instance.init(2, secretKey, new GCMParameterSpec(128, parseFrom.iv));
                return instance.doFinal(parseFrom.encryptedStoredPin);
            }
        } catch (Exception e) {
            loge("Decrypt exception", (Throwable) e);
            TelephonyStatsLog.write(336, 8, 1, "");
        }
        return new byte[0];
    }

    private static void logd(String str, Object... objArr) {
        Rlog.d(TAG, String.format(str, objArr));
    }

    private static void loge(String str, Object... objArr) {
        Rlog.e(TAG, String.format(str, objArr));
    }

    private static void loge(String str, Throwable th) {
        Rlog.e(TAG, str, th);
    }

    /* access modifiers changed from: package-private */
    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("PinStorage:");
        printWriter.println(" mIsDeviceSecure=" + this.mIsDeviceSecure);
        printWriter.println(" mIsDeviceLocked=" + this.mIsDeviceLocked);
        StringBuilder sb = new StringBuilder();
        sb.append(" isLongTermSecretKey=");
        boolean z = true;
        sb.append(this.mLongTermSecretKey != null);
        printWriter.println(sb.toString());
        StringBuilder sb2 = new StringBuilder();
        sb2.append(" isShortTermSecretKey=");
        if (this.mShortTermSecretKey == null) {
            z = false;
        }
        sb2.append(z);
        printWriter.println(sb2.toString());
        printWriter.println(" isCacheAllowedByDevice=" + isCacheAllowedByDevice());
        int slotCount = getSlotCount();
        for (int i = 0; i < slotCount; i++) {
            printWriter.println(" isCacheAllowedByCarrier[" + i + "]=" + isCacheAllowedByCarrier(i));
        }
    }
}
