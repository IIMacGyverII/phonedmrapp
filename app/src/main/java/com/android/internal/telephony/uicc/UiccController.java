package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.SharedPreferences;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.preference.PreferenceManager;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.UiccSlotMapping;
import android.text.TextUtils;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.IccCardConstants;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.PhoneConfigurationManager;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.RadioConfig;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.SubscriptionInfoUpdater;
import com.android.internal.telephony.TelephonyComponentFactory;
import com.android.internal.telephony.uicc.euicc.EuiccCard;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.IntStream;

public class UiccController extends Handler {
    public static final int APP_FAM_3GPP = 1;
    public static final int APP_FAM_3GPP2 = 2;
    public static final int APP_FAM_IMS = 3;
    private static final String CARD_STRINGS = "card_strings";
    protected static final boolean DBG = true;
    private static final String DEFAULT_CARD = "default_card";
    private static final int EID_LENGTH = 32;
    private static final int EVENT_EID_READY = 9;
    protected static final int EVENT_GET_ICC_STATUS_DONE = 3;
    protected static final int EVENT_GET_SLOT_STATUS_DONE = 4;
    protected static final int EVENT_ICC_STATUS_CHANGED = 1;
    protected static final int EVENT_MULTI_SIM_CONFIG_CHANGED = 10;
    protected static final int EVENT_RADIO_AVAILABLE = 6;
    protected static final int EVENT_RADIO_ON = 5;
    private static final int EVENT_RADIO_UNAVAILABLE = 7;
    private static final int EVENT_SIM_REFRESH = 8;
    private static final int EVENT_SLOT_STATUS_CHANGED = 2;
    public static final int INVALID_SLOT_ID = -1;
    private static final String LOG_TAG = "UiccController";
    private static final String REMOVABLE_ESIM_AS_DEFAULT = "removable_esim";
    private static final int TEMPORARILY_UNSUPPORTED_CARD_ID = -3;
    protected static final boolean VDBG = false;
    @UnsupportedAppUsage
    private static UiccController mInstance;
    @UnsupportedAppUsage
    protected static final Object mLock = new Object();
    @VisibleForTesting
    public static ArrayList<IccSlotStatus> sLastSlotStatus;
    private static LocalLog sLocalLog = new LocalLog(TelephonyUtils.IS_DEBUGGABLE ? 256 : 64);
    private ArrayList<String> mCardStrings;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected CommandsInterface[] mCis;
    @UnsupportedAppUsage
    @VisibleForTesting
    public Context mContext;
    private int mDefaultEuiccCardId;
    private final int[] mEuiccSlots;
    private boolean mHasActiveBuiltInEuicc = false;
    private boolean mHasBuiltInEuicc = false;
    protected RegistrantList mIccChangedRegistrants = new RegistrantList();
    private boolean mIsSlotStatusSupported = true;
    private UiccStateChangedLauncher mLauncher;
    protected int[] mPhoneIdToSlotId;
    private final PinStorage mPinStorage;
    private RadioConfig mRadioConfig;
    @VisibleForTesting
    public UiccSlot[] mUiccSlots;
    private boolean mUseRemovableEsimAsDefault = false;

    public static UiccController make(Context context) {
        UiccController makeUiccController;
        synchronized (mLock) {
            if (mInstance == null) {
                makeUiccController = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeUiccController(context);
                mInstance = makeUiccController;
            } else {
                throw new RuntimeException("UiccController.make() should only be called once");
            }
        }
        return makeUiccController;
    }

    public UiccController(Context context) {
        log("Creating UiccController");
        this.mContext = context;
        this.mCis = PhoneFactory.getCommandsInterfaces();
        int intValue = TelephonyProperties.sim_slots_count().orElse(Integer.valueOf(context.getResources().getInteger(17694907))).intValue();
        logWithLocalLog("config_num_physical_slots = " + intValue);
        CommandsInterface[] commandsInterfaceArr = this.mCis;
        this.mUiccSlots = new UiccSlot[(intValue < commandsInterfaceArr.length ? commandsInterfaceArr.length : intValue)];
        int[] iArr = new int[commandsInterfaceArr.length];
        this.mPhoneIdToSlotId = iArr;
        Arrays.fill(iArr, -1);
        RadioConfig instance = RadioConfig.getInstance();
        this.mRadioConfig = instance;
        instance.registerForSimSlotStatusChanged(this, 2, (Object) null);
        int i = 0;
        while (true) {
            CommandsInterface[] commandsInterfaceArr2 = this.mCis;
            if (i >= commandsInterfaceArr2.length) {
                break;
            }
            commandsInterfaceArr2[i].registerForIccStatusChanged(this, 1, Integer.valueOf(i));
            this.mCis[i].registerForAvailable(this, 6, Integer.valueOf(i));
            this.mCis[i].registerForNotAvailable(this, 7, Integer.valueOf(i));
            this.mCis[i].registerForIccRefresh(this, 8, Integer.valueOf(i));
            i++;
        }
        this.mLauncher = new UiccStateChangedLauncher(context, this);
        this.mCardStrings = loadCardStrings();
        this.mDefaultEuiccCardId = -2;
        this.mEuiccSlots = this.mContext.getResources().getIntArray(17236184);
        this.mHasBuiltInEuicc = hasBuiltInEuicc();
        PhoneConfigurationManager.registerForMultiSimConfigChange(this, 10, (Object) null);
        this.mPinStorage = new PinStorage(this.mContext);
        if (!TelephonyUtils.IS_USER) {
            this.mUseRemovableEsimAsDefault = PreferenceManager.getDefaultSharedPreferences(this.mContext).getBoolean(REMOVABLE_ESIM_AS_DEFAULT, false);
        }
    }

    public int getPhoneIdFromSlotPortIndex(int i, int i2) {
        UiccSlot uiccSlot = getUiccSlot(i);
        if (uiccSlot == null) {
            return -1;
        }
        return uiccSlot.getPhoneIdFromPortIndex(i2);
    }

    public int getSlotIdFromPhoneId(int i) {
        try {
            return this.mPhoneIdToSlotId[i];
        } catch (ArrayIndexOutOfBoundsException unused) {
            return -1;
        }
    }

    @UnsupportedAppUsage
    public static UiccController getInstance() {
        UiccController uiccController;
        synchronized (mLock) {
            uiccController = mInstance;
            if (uiccController == null) {
                throw new RuntimeException("UiccController.getInstance can't be called before make()");
            }
        }
        return uiccController;
    }

    @UnsupportedAppUsage
    public UiccCard getUiccCard(int i) {
        UiccCard uiccCardForPhone;
        synchronized (mLock) {
            uiccCardForPhone = getUiccCardForPhone(i);
        }
        return uiccCardForPhone;
    }

    public UiccPort getUiccPort(int i) {
        UiccPort uiccPortForPhone;
        synchronized (mLock) {
            uiccPortForPhone = getUiccPortForPhone(i);
        }
        return uiccPortForPhone;
    }

    public UiccPort getUiccPortForSlot(int i, int i2) {
        UiccCard uiccCard;
        synchronized (mLock) {
            UiccSlot uiccSlot = getUiccSlot(i);
            if (uiccSlot == null || (uiccCard = uiccSlot.getUiccCard()) == null) {
                return null;
            }
            UiccPort uiccPort = uiccCard.getUiccPort(i2);
            return uiccPort;
        }
    }

    public UiccCard getUiccCardForSlot(int i) {
        synchronized (mLock) {
            UiccSlot uiccSlot = getUiccSlot(i);
            if (uiccSlot == null) {
                return null;
            }
            UiccCard uiccCard = uiccSlot.getUiccCard();
            return uiccCard;
        }
    }

    public UiccCard getUiccCardForPhone(int i) {
        UiccSlot uiccSlotForPhone;
        synchronized (mLock) {
            if (!isValidPhoneIndex(i) || (uiccSlotForPhone = getUiccSlotForPhone(i)) == null) {
                return null;
            }
            UiccCard uiccCard = uiccSlotForPhone.getUiccCard();
            return uiccCard;
        }
    }

    public UiccPort getUiccPortForPhone(int i) {
        UiccSlot uiccSlotForPhone;
        UiccCard uiccCard;
        synchronized (mLock) {
            if (!isValidPhoneIndex(i) || (uiccSlotForPhone = getUiccSlotForPhone(i)) == null || (uiccCard = uiccSlotForPhone.getUiccCard()) == null) {
                return null;
            }
            UiccPort uiccPortForPhone = uiccCard.getUiccPortForPhone(i);
            return uiccPortForPhone;
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:9:0x0015, code lost:
        return r2;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public com.android.internal.telephony.uicc.UiccProfile getUiccProfileForPhone(int r4) {
        /*
            r3 = this;
            java.lang.Object r0 = mLock
            monitor-enter(r0)
            boolean r1 = r3.isValidPhoneIndex(r4)     // Catch:{ all -> 0x0018 }
            r2 = 0
            if (r1 == 0) goto L_0x0016
            com.android.internal.telephony.uicc.UiccPort r3 = r3.getUiccPortForPhone(r4)     // Catch:{ all -> 0x0018 }
            if (r3 == 0) goto L_0x0014
            com.android.internal.telephony.uicc.UiccProfile r2 = r3.getUiccProfile()     // Catch:{ all -> 0x0018 }
        L_0x0014:
            monitor-exit(r0)     // Catch:{ all -> 0x0018 }
            return r2
        L_0x0016:
            monitor-exit(r0)     // Catch:{ all -> 0x0018 }
            return r2
        L_0x0018:
            r3 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0018 }
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccController.getUiccProfileForPhone(int):com.android.internal.telephony.uicc.UiccProfile");
    }

    public UiccSlot[] getUiccSlots() {
        UiccSlot[] uiccSlotArr;
        synchronized (mLock) {
            uiccSlotArr = this.mUiccSlots;
        }
        return uiccSlotArr;
    }

    public void switchSlots(List<UiccSlotMapping> list, Message message) {
        logWithLocalLog("switchSlots: " + list);
        this.mRadioConfig.setSimSlotsMapping(list, message);
    }

    public UiccSlot getUiccSlot(int i) {
        synchronized (mLock) {
            if (!isValidSlotIndex(i)) {
                return null;
            }
            UiccSlot uiccSlot = this.mUiccSlots[i];
            return uiccSlot;
        }
    }

    public UiccSlot getUiccSlotForPhone(int i) {
        synchronized (mLock) {
            if (isValidPhoneIndex(i)) {
                int slotIdFromPhoneId = getSlotIdFromPhoneId(i);
                if (isValidSlotIndex(slotIdFromPhoneId)) {
                    UiccSlot uiccSlot = this.mUiccSlots[slotIdFromPhoneId];
                    return uiccSlot;
                }
            }
            return null;
        }
    }

    public int getUiccSlotForCardId(String str) {
        UiccCard uiccCard;
        synchronized (mLock) {
            int i = 0;
            int i2 = 0;
            while (true) {
                UiccSlot[] uiccSlotArr = this.mUiccSlots;
                if (i2 < uiccSlotArr.length) {
                    UiccSlot uiccSlot = uiccSlotArr[i2];
                    if (uiccSlot != null && (uiccCard = uiccSlot.getUiccCard()) != null && str.equals(uiccCard.getCardId())) {
                        return i2;
                    }
                    i2++;
                } else {
                    while (true) {
                        UiccSlot[] uiccSlotArr2 = this.mUiccSlots;
                        if (i >= uiccSlotArr2.length) {
                            return -1;
                        }
                        UiccSlot uiccSlot2 = uiccSlotArr2[i];
                        if (uiccSlot2 != null && IntStream.of(uiccSlot2.getPortList()).anyMatch(new UiccController$$ExternalSyntheticLambda0(str, uiccSlot2))) {
                            return i;
                        }
                        i++;
                    }
                }
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public IccRecords getIccRecords(int i, int i2) {
        synchronized (mLock) {
            UiccCardApplication uiccCardApplication = getUiccCardApplication(i, i2);
            if (uiccCardApplication == null) {
                return null;
            }
            IccRecords iccRecords = uiccCardApplication.getIccRecords();
            return iccRecords;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public IccFileHandler getIccFileHandler(int i, int i2) {
        synchronized (mLock) {
            UiccCardApplication uiccCardApplication = getUiccCardApplication(i, i2);
            if (uiccCardApplication == null) {
                return null;
            }
            IccFileHandler iccFileHandler = uiccCardApplication.getIccFileHandler();
            return iccFileHandler;
        }
    }

    @UnsupportedAppUsage
    public void registerForIccChanged(Handler handler, int i, Object obj) {
        synchronized (mLock) {
            this.mIccChangedRegistrants.addUnique(handler, i, obj);
        }
        Message.obtain(handler, i, new AsyncResult(obj, (Object) null, (Throwable) null)).sendToTarget();
    }

    public void unregisterForIccChanged(Handler handler) {
        synchronized (mLock) {
            this.mIccChangedRegistrants.remove(handler);
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:26:0x00fe, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleMessage(android.os.Message r6) {
        /*
            r5 = this;
            java.lang.Object r0 = mLock
            monitor-enter(r0)
            java.lang.Integer r1 = r5.getCiIndex(r6)     // Catch:{ all -> 0x011f }
            int r2 = r6.what     // Catch:{ all -> 0x011f }
            java.lang.String r2 = eventToString(r2)     // Catch:{ all -> 0x011f }
            int r3 = r1.intValue()     // Catch:{ all -> 0x011f }
            if (r3 < 0) goto L_0x00ff
            int r3 = r1.intValue()     // Catch:{ all -> 0x011f }
            com.android.internal.telephony.CommandsInterface[] r4 = r5.mCis     // Catch:{ all -> 0x011f }
            int r4 = r4.length     // Catch:{ all -> 0x011f }
            if (r3 < r4) goto L_0x001e
            goto L_0x00ff
        L_0x001e:
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x011f }
            r3.<init>()     // Catch:{ all -> 0x011f }
            java.lang.String r4 = "handleMessage: Received "
            r3.append(r4)     // Catch:{ all -> 0x011f }
            r3.append(r2)     // Catch:{ all -> 0x011f }
            java.lang.String r2 = " for phoneId "
            r3.append(r2)     // Catch:{ all -> 0x011f }
            r3.append(r1)     // Catch:{ all -> 0x011f }
            java.lang.String r2 = r3.toString()     // Catch:{ all -> 0x011f }
            r5.logWithLocalLog(r2)     // Catch:{ all -> 0x011f }
            java.lang.Object r2 = r6.obj     // Catch:{ all -> 0x011f }
            android.os.AsyncResult r2 = (android.os.AsyncResult) r2     // Catch:{ all -> 0x011f }
            int r3 = r6.what     // Catch:{ all -> 0x011f }
            r4 = 3
            switch(r3) {
                case 1: goto L_0x00d2;
                case 2: goto L_0x00c9;
                case 3: goto L_0x00c0;
                case 4: goto L_0x00c9;
                case 5: goto L_0x0096;
                case 6: goto L_0x0096;
                case 7: goto L_0x0072;
                case 8: goto L_0x0068;
                case 9: goto L_0x005e;
                case 10: goto L_0x0048;
                default: goto L_0x0044;
            }     // Catch:{ all -> 0x011f }
        L_0x0044:
            java.lang.String r5 = "UiccController"
            goto L_0x00e7
        L_0x0048:
            java.lang.String r1 = "Received EVENT_MULTI_SIM_CONFIG_CHANGED"
            r5.log(r1)     // Catch:{ all -> 0x011f }
            java.lang.Object r6 = r6.obj     // Catch:{ all -> 0x011f }
            android.os.AsyncResult r6 = (android.os.AsyncResult) r6     // Catch:{ all -> 0x011f }
            java.lang.Object r6 = r6.result     // Catch:{ all -> 0x011f }
            java.lang.Integer r6 = (java.lang.Integer) r6     // Catch:{ all -> 0x011f }
            int r6 = r6.intValue()     // Catch:{ all -> 0x011f }
            r5.onMultiSimConfigChanged(r6)     // Catch:{ all -> 0x011f }
            goto L_0x00fd
        L_0x005e:
            java.lang.String r6 = "Received EVENT_EID_READY"
            r5.log(r6)     // Catch:{ all -> 0x011f }
            r5.onEidReady(r2, r1)     // Catch:{ all -> 0x011f }
            goto L_0x00fd
        L_0x0068:
            java.lang.String r6 = "Received EVENT_SIM_REFRESH"
            r5.log(r6)     // Catch:{ all -> 0x011f }
            r5.onSimRefresh(r2, r1)     // Catch:{ all -> 0x011f }
            goto L_0x00fd
        L_0x0072:
            java.lang.String r6 = "EVENT_RADIO_UNAVAILABLE, dispose card"
            r5.log(r6)     // Catch:{ all -> 0x011f }
            r6 = 0
            sLastSlotStatus = r6     // Catch:{ all -> 0x011f }
            int r2 = r1.intValue()     // Catch:{ all -> 0x011f }
            com.android.internal.telephony.uicc.UiccSlot r2 = r5.getUiccSlotForPhone(r2)     // Catch:{ all -> 0x011f }
            if (r2 == 0) goto L_0x008b
            int r3 = r1.intValue()     // Catch:{ all -> 0x011f }
            r2.onRadioStateUnavailable(r3)     // Catch:{ all -> 0x011f }
        L_0x008b:
            com.android.internal.telephony.RegistrantList r5 = r5.mIccChangedRegistrants     // Catch:{ all -> 0x011f }
            android.os.AsyncResult r2 = new android.os.AsyncResult     // Catch:{ all -> 0x011f }
            r2.<init>(r6, r1, r6)     // Catch:{ all -> 0x011f }
            r5.notifyRegistrants(r2)     // Catch:{ all -> 0x011f }
            goto L_0x00fd
        L_0x0096:
            java.lang.String r6 = "Received EVENT_RADIO_AVAILABLE/EVENT_RADIO_ON, calling getIccCardStatus"
            r5.log(r6)     // Catch:{ all -> 0x011f }
            com.android.internal.telephony.CommandsInterface[] r6 = r5.mCis     // Catch:{ all -> 0x011f }
            int r2 = r1.intValue()     // Catch:{ all -> 0x011f }
            r6 = r6[r2]     // Catch:{ all -> 0x011f }
            android.os.Message r2 = r5.obtainMessage(r4, r1)     // Catch:{ all -> 0x011f }
            r6.getIccCardStatus(r2)     // Catch:{ all -> 0x011f }
            int r6 = r1.intValue()     // Catch:{ all -> 0x011f }
            if (r6 != 0) goto L_0x00fd
            java.lang.String r6 = "Received EVENT_RADIO_AVAILABLE/EVENT_RADIO_ON for phoneId 0, calling getIccSlotsStatus"
            r5.log(r6)     // Catch:{ all -> 0x011f }
            com.android.internal.telephony.RadioConfig r6 = r5.mRadioConfig     // Catch:{ all -> 0x011f }
            r2 = 4
            android.os.Message r5 = r5.obtainMessage(r2, r1)     // Catch:{ all -> 0x011f }
            r6.getSimSlotsStatus(r5)     // Catch:{ all -> 0x011f }
            goto L_0x00fd
        L_0x00c0:
            java.lang.String r6 = "Received EVENT_GET_ICC_STATUS_DONE"
            r5.log(r6)     // Catch:{ all -> 0x011f }
            r5.onGetIccCardStatusDone(r2, r1)     // Catch:{ all -> 0x011f }
            goto L_0x00fd
        L_0x00c9:
            java.lang.String r6 = "Received EVENT_SLOT_STATUS_CHANGED or EVENT_GET_SLOT_STATUS_DONE"
            r5.log(r6)     // Catch:{ all -> 0x011f }
            r5.onGetSlotStatusDone(r2)     // Catch:{ all -> 0x011f }
            goto L_0x00fd
        L_0x00d2:
            java.lang.String r6 = "Received EVENT_ICC_STATUS_CHANGED, calling getIccCardStatus"
            r5.log(r6)     // Catch:{ all -> 0x011f }
            com.android.internal.telephony.CommandsInterface[] r6 = r5.mCis     // Catch:{ all -> 0x011f }
            int r2 = r1.intValue()     // Catch:{ all -> 0x011f }
            r6 = r6[r2]     // Catch:{ all -> 0x011f }
            android.os.Message r5 = r5.obtainMessage(r4, r1)     // Catch:{ all -> 0x011f }
            r6.getIccCardStatus(r5)     // Catch:{ all -> 0x011f }
            goto L_0x00fd
        L_0x00e7:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x011f }
            r1.<init>()     // Catch:{ all -> 0x011f }
            java.lang.String r2 = " Unknown Event "
            r1.append(r2)     // Catch:{ all -> 0x011f }
            int r6 = r6.what     // Catch:{ all -> 0x011f }
            r1.append(r6)     // Catch:{ all -> 0x011f }
            java.lang.String r6 = r1.toString()     // Catch:{ all -> 0x011f }
            com.android.telephony.Rlog.e(r5, r6)     // Catch:{ all -> 0x011f }
        L_0x00fd:
            monitor-exit(r0)     // Catch:{ all -> 0x011f }
            return
        L_0x00ff:
            java.lang.String r5 = "UiccController"
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x011f }
            r6.<init>()     // Catch:{ all -> 0x011f }
            java.lang.String r3 = "Invalid phoneId : "
            r6.append(r3)     // Catch:{ all -> 0x011f }
            r6.append(r1)     // Catch:{ all -> 0x011f }
            java.lang.String r1 = " received with event "
            r6.append(r1)     // Catch:{ all -> 0x011f }
            r6.append(r2)     // Catch:{ all -> 0x011f }
            java.lang.String r6 = r6.toString()     // Catch:{ all -> 0x011f }
            com.android.telephony.Rlog.e(r5, r6)     // Catch:{ all -> 0x011f }
            monitor-exit(r0)     // Catch:{ all -> 0x011f }
            return
        L_0x011f:
            r5 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x011f }
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccController.handleMessage(android.os.Message):void");
    }

    private void onMultiSimConfigChanged(int i) {
        int length = this.mCis.length;
        this.mCis = PhoneFactory.getCommandsInterfaces();
        logWithLocalLog("onMultiSimConfigChanged: prevActiveModemCount " + length + ", newActiveModemCount " + i);
        this.mPhoneIdToSlotId = Arrays.copyOf(this.mPhoneIdToSlotId, i);
        while (length < i) {
            this.mPhoneIdToSlotId[length] = -1;
            this.mCis[length].registerForIccStatusChanged(this, 1, Integer.valueOf(length));
            this.mCis[length].registerForAvailable(this, 6, Integer.valueOf(length));
            this.mCis[length].registerForNotAvailable(this, 7, Integer.valueOf(length));
            this.mCis[length].registerForIccRefresh(this, 8, Integer.valueOf(length));
            length++;
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:10:0x001a, code lost:
        r2 = ((android.os.AsyncResult) r2).userObj;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.lang.Integer getCiIndex(android.os.Message r2) {
        /*
            r1 = this;
            java.lang.Integer r1 = new java.lang.Integer
            r0 = 0
            r1.<init>(r0)
            if (r2 == 0) goto L_0x0027
            java.lang.Object r2 = r2.obj
            if (r2 == 0) goto L_0x0014
            boolean r0 = r2 instanceof java.lang.Integer
            if (r0 == 0) goto L_0x0014
            r1 = r2
            java.lang.Integer r1 = (java.lang.Integer) r1
            goto L_0x0027
        L_0x0014:
            if (r2 == 0) goto L_0x0027
            boolean r0 = r2 instanceof android.os.AsyncResult
            if (r0 == 0) goto L_0x0027
            android.os.AsyncResult r2 = (android.os.AsyncResult) r2
            java.lang.Object r2 = r2.userObj
            if (r2 == 0) goto L_0x0027
            boolean r0 = r2 instanceof java.lang.Integer
            if (r0 == 0) goto L_0x0027
            r1 = r2
            java.lang.Integer r1 = (java.lang.Integer) r1
        L_0x0027:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccController.getCiIndex(android.os.Message):java.lang.Integer");
    }

    private static String eventToString(int i) {
        switch (i) {
            case 1:
                return "ICC_STATUS_CHANGED";
            case 2:
                return "SLOT_STATUS_CHANGED";
            case 3:
                return "GET_ICC_STATUS_DONE";
            case 4:
                return "GET_SLOT_STATUS_DONE";
            case 5:
                return "RADIO_ON";
            case 6:
                return "RADIO_AVAILABLE";
            case 7:
                return "RADIO_UNAVAILABLE";
            case 8:
                return "SIM_REFRESH";
            case 9:
                return "EID_READY";
            case 10:
                return "MULTI_SIM_CONFIG_CHANGED";
            default:
                return "UNKNOWN(" + i + ")";
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public UiccCardApplication getUiccCardApplication(int i, int i2) {
        synchronized (mLock) {
            UiccPort uiccPortForPhone = getUiccPortForPhone(i);
            if (uiccPortForPhone == null) {
                return null;
            }
            UiccCardApplication application = uiccPortForPhone.getApplication(i2);
            return application;
        }
    }

    /* renamed from: com.android.internal.telephony.uicc.UiccController$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$IccCardConstants$State;

        /* JADX WARNING: Can't wrap try/catch for region: R(20:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|(3:19|20|22)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(22:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|22) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:17:0x0060 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x006c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.IccCardConstants$State[] r0 = com.android.internal.telephony.IccCardConstants.State.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$IccCardConstants$State = r0
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.ABSENT     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.PIN_REQUIRED     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.PUK_REQUIRED     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.NETWORK_LOCKED     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.READY     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.NOT_READY     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.PERM_DISABLED     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.CARD_IO_ERROR     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.CARD_RESTRICTED     // Catch:{ NoSuchFieldError -> 0x006c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r2 = 9
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.IccCardConstants$State r1 = com.android.internal.telephony.IccCardConstants.State.LOADED     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r2 = 10
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccController.AnonymousClass1.<clinit>():void");
        }
    }

    public static String getIccStateIntentString(IccCardConstants.State state) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$IccCardConstants$State[state.ordinal()]) {
            case 1:
                return "ABSENT";
            case 2:
            case 3:
            case 4:
                return "LOCKED";
            case 5:
                return "READY";
            case 6:
                return "NOT_READY";
            case 7:
                return "LOCKED";
            case 8:
                return "CARD_IO_ERROR";
            case 9:
                return "CARD_RESTRICTED";
            case 10:
                return "LOADED";
            default:
                return "UNKNOWN";
        }
    }

    static void updateInternalIccStateForInactivePort(Context context, int i, String str) {
        if (SubscriptionManager.isValidPhoneId(i)) {
            ((TelephonyManager) context.getSystemService("phone")).setSimStateForPhone(i, IccCardConstants.State.ABSENT.toString());
        }
        SubscriptionInfoUpdater subscriptionInfoUpdater = PhoneFactory.getSubscriptionInfoUpdater();
        if (subscriptionInfoUpdater != null) {
            subscriptionInfoUpdater.updateInternalIccStateForInactivePort(i, str);
        } else {
            Rlog.e(LOG_TAG, "subInfoUpdate is null.");
        }
    }

    public static void updateInternalIccState(Context context, IccCardConstants.State state, String str, int i) {
        ((TelephonyManager) context.getSystemService("phone")).setSimStateForPhone(i, state.toString());
        SubscriptionInfoUpdater subscriptionInfoUpdater = PhoneFactory.getSubscriptionInfoUpdater();
        if (subscriptionInfoUpdater != null) {
            subscriptionInfoUpdater.updateInternalIccState(getIccStateIntentString(state), str, i);
        } else {
            Rlog.e(LOG_TAG, "subInfoUpdate is null.");
        }
    }

    /* access modifiers changed from: protected */
    public synchronized void onGetIccCardStatusDone(AsyncResult asyncResult, Integer num) {
        String str;
        int i;
        Throwable th = asyncResult.exception;
        if (th != null) {
            Rlog.e(LOG_TAG, "Error getting ICC status. RIL_REQUEST_GET_ICC_STATUS should never return an error", th);
        } else if (!isValidPhoneIndex(num.intValue())) {
            Rlog.e(LOG_TAG, "onGetIccCardStatusDone: invalid index : " + num);
        } else if (isShuttingDown()) {
            log("onGetIccCardStatusDone: shudown in progress ignore event");
        } else {
            IccCardStatus iccCardStatus = (IccCardStatus) asyncResult.result;
            logWithLocalLog("onGetIccCardStatusDone: phoneId " + num + " IccCardStatus: " + iccCardStatus);
            int i2 = iccCardStatus.mSlotPortMapping.mPhysicalSlotIndex;
            if (i2 == -1) {
                i2 = num.intValue();
            }
            if (!this.mCis[0].supportsEid()) {
                log("eid is not supported");
                this.mDefaultEuiccCardId = -1;
            }
            this.mPhoneIdToSlotId[num.intValue()] = i2;
            if (this.mUiccSlots[i2] == null) {
                this.mUiccSlots[i2] = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeUiccSlot(this.mContext, true);
            }
            this.mUiccSlots[i2].update(this.mCis[num.intValue()], iccCardStatus, num.intValue(), i2);
            UiccCard uiccCard = this.mUiccSlots[i2].getUiccCard();
            if (uiccCard == null) {
                log("mUiccSlots[" + i2 + "] has no card. Notifying IccChangedRegistrants");
                this.mIccChangedRegistrants.notifyRegistrants(new AsyncResult((Object) null, num, (Throwable) null));
                return;
            }
            boolean isEuicc = this.mUiccSlots[i2].isEuicc();
            if (isEuicc) {
                str = ((EuiccCard) uiccCard).getEid();
            } else {
                str = uiccCard.getUiccPort(iccCardStatus.mSlotPortMapping.mPortIndex).getIccId();
            }
            if (str != null) {
                addCardId(str);
            }
            if (isEuicc && (i = this.mDefaultEuiccCardId) != -1) {
                if (str == null) {
                    ((EuiccCard) uiccCard).registerForEidReady(this, 9, num);
                } else if (i == -2 || i == -3) {
                    this.mDefaultEuiccCardId = convertToPublicCardId(str);
                    logWithLocalLog("IccCardStatus eid=" + Rlog.pii(TelephonyUtils.IS_DEBUGGABLE, str) + " slot=" + i2 + " mDefaultEuiccCardId=" + this.mDefaultEuiccCardId);
                }
            }
            log("Notifying IccChangedRegistrants");
            this.mIccChangedRegistrants.notifyRegistrants(new AsyncResult((Object) null, num, (Throwable) null));
        }
    }

    private void addCardId(String str) {
        if (!TextUtils.isEmpty(str)) {
            if (str.length() < 32) {
                str = IccUtils.stripTrailingFs(str);
            }
            if (!this.mCardStrings.contains(str)) {
                this.mCardStrings.add(str);
                saveCardStrings();
            }
        }
    }

    public String convertToCardString(int i) {
        if (i >= 0 && i < this.mCardStrings.size()) {
            return this.mCardStrings.get(i);
        }
        log("convertToCardString: cardId " + i + " is not valid");
        return null;
    }

    public int convertToPublicCardId(String str) {
        if (this.mDefaultEuiccCardId == -1) {
            return -1;
        }
        if (TextUtils.isEmpty(str)) {
            return -2;
        }
        if (str.length() < 32) {
            str = IccUtils.stripTrailingFs(str);
        }
        int indexOf = this.mCardStrings.indexOf(str);
        if (indexOf == -1) {
            return -2;
        }
        return indexOf;
    }

    /* JADX WARNING: Removed duplicated region for block: B:25:0x0074 A[LOOP:1: B:24:0x0072->B:25:0x0074, LOOP_END] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.util.ArrayList<android.telephony.UiccCardInfo> getAllUiccCardInfos() {
        /*
            r17 = this;
            r0 = r17
            java.util.ArrayList r1 = new java.util.ArrayList
            r1.<init>()
            r2 = 0
            r11 = r2
        L_0x0009:
            com.android.internal.telephony.uicc.UiccSlot[] r3 = r0.mUiccSlots
            int r4 = r3.length
            if (r11 >= r4) goto L_0x00a9
            r3 = r3[r11]
            if (r3 != 0) goto L_0x0014
            goto L_0x00a2
        L_0x0014:
            boolean r4 = r3.isEuicc()
            com.android.internal.telephony.uicc.UiccCard r5 = r3.getUiccCard()
            r6 = -2
            boolean r8 = r3.isRemovable()
            r7 = 0
            if (r5 == 0) goto L_0x0054
            if (r4 == 0) goto L_0x0036
            com.android.internal.telephony.uicc.euicc.EuiccCard r5 = (com.android.internal.telephony.uicc.euicc.EuiccCard) r5
            java.lang.String r5 = r5.getEid()
            int r6 = r0.convertToPublicCardId(r5)
            r16 = r6
            r6 = r5
            r5 = r16
            goto L_0x0067
        L_0x0036:
            com.android.internal.telephony.uicc.UiccPort r5 = r5.getUiccPort(r2)
            if (r5 != 0) goto L_0x0047
            java.lang.String r6 = "92885ba7-98bb-490a-ba19-987b1c8b2055"
            java.util.UUID r6 = java.util.UUID.fromString(r6)
            java.lang.String r9 = "UiccController: Found UiccPort Null object."
            android.telephony.AnomalyReporter.reportAnomaly(r6, r9)
        L_0x0047:
            if (r5 == 0) goto L_0x004e
            java.lang.String r5 = r5.getIccId()
            goto L_0x004f
        L_0x004e:
            r5 = r7
        L_0x004f:
            int r5 = r0.convertToPublicCardId(r5)
            goto L_0x0066
        L_0x0054:
            java.lang.String r5 = r3.getIccId(r2)
            if (r4 != 0) goto L_0x0065
            boolean r9 = android.text.TextUtils.isEmpty(r5)
            if (r9 != 0) goto L_0x0065
            int r5 = r0.convertToPublicCardId(r5)
            goto L_0x0066
        L_0x0065:
            r5 = r6
        L_0x0066:
            r6 = r7
        L_0x0067:
            java.util.ArrayList r10 = new java.util.ArrayList
            r10.<init>()
            int[] r7 = r3.getPortList()
            int r9 = r7.length
            r12 = r2
        L_0x0072:
            if (r12 >= r9) goto L_0x0094
            r13 = r7[r12]
            java.lang.String r14 = r3.getIccId(r13)
            java.lang.String r14 = com.android.internal.telephony.uicc.IccUtils.stripTrailingFs(r14)
            android.telephony.UiccPortInfo r15 = new android.telephony.UiccPortInfo
            int r2 = r3.getPhoneIdFromPortIndex(r13)
            boolean r0 = r3.isPortActive(r13)
            r15.<init>(r14, r13, r2, r0)
            r10.add(r15)
            int r12 = r12 + 1
            r0 = r17
            r2 = 0
            goto L_0x0072
        L_0x0094:
            android.telephony.UiccCardInfo r0 = new android.telephony.UiccCardInfo
            boolean r9 = r3.isMultipleEnabledProfileSupported()
            r3 = r0
            r7 = r11
            r3.<init>(r4, r5, r6, r7, r8, r9, r10)
            r1.add(r0)
        L_0x00a2:
            int r11 = r11 + 1
            r0 = r17
            r2 = 0
            goto L_0x0009
        L_0x00a9:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccController.getAllUiccCardInfos():java.util.ArrayList");
    }

    public int getCardIdForDefaultEuicc() {
        if (this.mDefaultEuiccCardId == -3) {
            return -1;
        }
        if (this.mUseRemovableEsimAsDefault && !TelephonyUtils.IS_USER) {
            UiccSlot[] uiccSlotArr = this.mUiccSlots;
            int length = uiccSlotArr.length;
            int i = 0;
            while (i < length) {
                UiccSlot uiccSlot = uiccSlotArr[i];
                if (uiccSlot == null || !uiccSlot.isRemovable() || !uiccSlot.isEuicc() || !uiccSlot.isActive()) {
                    i++;
                } else {
                    int convertToPublicCardId = convertToPublicCardId(uiccSlot.getEid());
                    Rlog.d(LOG_TAG, "getCardIdForDefaultEuicc: Removable eSIM is default, cardId: " + convertToPublicCardId);
                    return convertToPublicCardId;
                }
            }
            Rlog.d(LOG_TAG, "getCardIdForDefaultEuicc: No removable eSIM slot is found");
        }
        return this.mDefaultEuiccCardId;
    }

    public PinStorage getPinStorage() {
        return this.mPinStorage;
    }

    private ArrayList<String> loadCardStrings() {
        String string = PreferenceManager.getDefaultSharedPreferences(this.mContext).getString(CARD_STRINGS, "");
        if (TextUtils.isEmpty(string)) {
            return new ArrayList<>();
        }
        return new ArrayList<>(Arrays.asList(string.split(",")));
    }

    private void saveCardStrings() {
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(this.mContext).edit();
        edit.putString(CARD_STRINGS, TextUtils.join(",", this.mCardStrings));
        edit.commit();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:17:0x003a, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private synchronized void onGetSlotStatusDone(android.os.AsyncResult r15) {
        /*
            r14 = this;
            monitor-enter(r14)
            boolean r0 = r14.mIsSlotStatusSupported     // Catch:{ all -> 0x028f }
            if (r0 != 0) goto L_0x0007
            monitor-exit(r14)
            return
        L_0x0007:
            java.lang.Throwable r0 = r15.exception     // Catch:{ all -> 0x028f }
            r1 = 0
            if (r0 == 0) goto L_0x003b
            boolean r2 = r0 instanceof com.android.internal.telephony.CommandException     // Catch:{ all -> 0x028f }
            if (r2 == 0) goto L_0x0023
            com.android.internal.telephony.CommandException r0 = (com.android.internal.telephony.CommandException) r0     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.CommandException$Error r0 = r0.getCommandError()     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.CommandException$Error r2 = com.android.internal.telephony.CommandException.Error.REQUEST_NOT_SUPPORTED     // Catch:{ all -> 0x028f }
            if (r0 == r2) goto L_0x001b
            goto L_0x0023
        L_0x001b:
            java.lang.String r15 = "onGetSlotStatusDone: request not supported; marking mIsSlotStatusSupported to false"
            r14.logWithLocalLog(r15)     // Catch:{ all -> 0x028f }
            r14.mIsSlotStatusSupported = r1     // Catch:{ all -> 0x028f }
            goto L_0x0039
        L_0x0023:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x028f }
            r0.<init>()     // Catch:{ all -> 0x028f }
            java.lang.String r1 = "Unexpected error getting slot status: "
            r0.append(r1)     // Catch:{ all -> 0x028f }
            java.lang.Throwable r15 = r15.exception     // Catch:{ all -> 0x028f }
            r0.append(r15)     // Catch:{ all -> 0x028f }
            java.lang.String r15 = r0.toString()     // Catch:{ all -> 0x028f }
            r14.logeWithLocalLog(r15)     // Catch:{ all -> 0x028f }
        L_0x0039:
            monitor-exit(r14)
            return
        L_0x003b:
            boolean r0 = r14.isShuttingDown()     // Catch:{ all -> 0x028f }
            if (r0 == 0) goto L_0x0048
            java.lang.String r15 = "onGetSlotStatusDone: shudown in progress ignore event"
            r14.log(r15)     // Catch:{ all -> 0x028f }
            monitor-exit(r14)
            return
        L_0x0048:
            java.lang.Object r15 = r15.result     // Catch:{ all -> 0x028f }
            java.util.ArrayList r15 = (java.util.ArrayList) r15     // Catch:{ all -> 0x028f }
            boolean r0 = r14.slotStatusChanged(r15)     // Catch:{ all -> 0x028f }
            if (r0 != 0) goto L_0x0059
            java.lang.String r15 = "onGetSlotStatusDone: No change in slot status"
            r14.log(r15)     // Catch:{ all -> 0x028f }
            monitor-exit(r14)
            return
        L_0x0059:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x028f }
            r0.<init>()     // Catch:{ all -> 0x028f }
            java.lang.String r2 = "onGetSlotStatusDone: "
            r0.append(r2)     // Catch:{ all -> 0x028f }
            r0.append(r15)     // Catch:{ all -> 0x028f }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x028f }
            r14.logWithLocalLog(r0)     // Catch:{ all -> 0x028f }
            sLastSlotStatus = r15     // Catch:{ all -> 0x028f }
            r14.mHasActiveBuiltInEuicc = r1     // Catch:{ all -> 0x028f }
            int r0 = r15.size()     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot[] r2 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            int r2 = r2.length     // Catch:{ all -> 0x028f }
            if (r2 >= r0) goto L_0x009c
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x028f }
            r2.<init>()     // Catch:{ all -> 0x028f }
            java.lang.String r3 = "The number of the physical slots reported "
            r2.append(r3)     // Catch:{ all -> 0x028f }
            r2.append(r0)     // Catch:{ all -> 0x028f }
            java.lang.String r0 = " is greater than the expectation "
            r2.append(r0)     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot[] r0 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            int r0 = r0.length     // Catch:{ all -> 0x028f }
            r2.append(r0)     // Catch:{ all -> 0x028f }
            java.lang.String r0 = r2.toString()     // Catch:{ all -> 0x028f }
            r14.logeWithLocalLog(r0)     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot[] r0 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            int r0 = r0.length     // Catch:{ all -> 0x028f }
        L_0x009c:
            r2 = r1
            r3 = r2
            r4 = r3
            r5 = r4
        L_0x00a0:
            r6 = 1
            if (r2 >= r0) goto L_0x0185
            java.lang.Object r7 = r15.get(r2)     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.IccSlotStatus r7 = (com.android.internal.telephony.uicc.IccSlotStatus) r7     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.IccSimPortInfo[] r8 = r7.mSimPortInfos     // Catch:{ all -> 0x028f }
            boolean r8 = r14.hasActivePort(r8)     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot[] r9 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            r9 = r9[r2]     // Catch:{ all -> 0x028f }
            if (r9 != 0) goto L_0x00cd
            com.android.internal.telephony.TelephonyComponentFactory r9 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()     // Catch:{ all -> 0x028f }
            java.lang.Class<com.android.internal.telephony.TelephonyComponentFactory> r10 = com.android.internal.telephony.TelephonyComponentFactory.class
            java.lang.String r10 = r10.getName()     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.TelephonyComponentFactory r9 = r9.inject(r10)     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot[] r10 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            android.content.Context r11 = r14.mContext     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot r9 = r9.makeUiccSlot(r11, r8)     // Catch:{ all -> 0x028f }
            r10[r2] = r9     // Catch:{ all -> 0x028f }
        L_0x00cd:
            if (r8 == 0) goto L_0x0118
            r9 = r1
        L_0x00d0:
            com.android.internal.telephony.uicc.IccSimPortInfo[] r10 = r7.mSimPortInfos     // Catch:{ all -> 0x028f }
            int r11 = r10.length     // Catch:{ all -> 0x028f }
            if (r9 >= r11) goto L_0x0118
            r10 = r10[r9]     // Catch:{ all -> 0x028f }
            boolean r11 = r10.mPortActive     // Catch:{ all -> 0x028f }
            if (r11 == 0) goto L_0x0115
            int r10 = r10.mLogicalSlotIndex     // Catch:{ all -> 0x028f }
            boolean r11 = r14.isValidPhoneIndex(r10)     // Catch:{ all -> 0x028f }
            if (r11 != 0) goto L_0x010f
            java.lang.String r11 = "UiccController"
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ all -> 0x028f }
            r12.<init>()     // Catch:{ all -> 0x028f }
            java.lang.String r13 = "Skipping slot "
            r12.append(r13)     // Catch:{ all -> 0x028f }
            r12.append(r2)     // Catch:{ all -> 0x028f }
            java.lang.String r13 = " portIndex "
            r12.append(r13)     // Catch:{ all -> 0x028f }
            r12.append(r9)     // Catch:{ all -> 0x028f }
            java.lang.String r13 = " as phone "
            r12.append(r13)     // Catch:{ all -> 0x028f }
            r12.append(r10)     // Catch:{ all -> 0x028f }
            java.lang.String r10 = " is not available to communicate with this slot"
            r12.append(r10)     // Catch:{ all -> 0x028f }
            java.lang.String r10 = r12.toString()     // Catch:{ all -> 0x028f }
            com.android.telephony.Rlog.e(r11, r10)     // Catch:{ all -> 0x028f }
            goto L_0x0113
        L_0x010f:
            int[] r11 = r14.mPhoneIdToSlotId     // Catch:{ all -> 0x028f }
            r11[r10] = r2     // Catch:{ all -> 0x028f }
        L_0x0113:
            int r4 = r4 + 1
        L_0x0115:
            int r9 = r9 + 1
            goto L_0x00d0
        L_0x0118:
            com.android.internal.telephony.uicc.UiccSlot[] r9 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            r9 = r9[r2]     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.CommandsInterface[] r10 = r14.mCis     // Catch:{ all -> 0x028f }
            r9.update(r10, r7, r2)     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot[] r9 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            r9 = r9[r2]     // Catch:{ all -> 0x028f }
            boolean r9 = r9.isEuicc()     // Catch:{ all -> 0x028f }
            if (r9 == 0) goto L_0x0181
            if (r8 == 0) goto L_0x0136
            boolean r5 = r14.isBuiltInEuiccSlot(r2)     // Catch:{ all -> 0x028f }
            if (r5 == 0) goto L_0x0135
            r14.mHasActiveBuiltInEuicc = r6     // Catch:{ all -> 0x028f }
        L_0x0135:
            r5 = r6
        L_0x0136:
            java.lang.String r7 = r7.eid     // Catch:{ all -> 0x028f }
            boolean r8 = android.text.TextUtils.isEmpty(r7)     // Catch:{ all -> 0x028f }
            if (r8 == 0) goto L_0x013f
            goto L_0x0181
        L_0x013f:
            r14.addCardId(r7)     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot[] r8 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            r8 = r8[r2]     // Catch:{ all -> 0x028f }
            boolean r8 = r8.isRemovable()     // Catch:{ all -> 0x028f }
            if (r8 != 0) goto L_0x0181
            if (r3 != 0) goto L_0x0181
            int r3 = r14.convertToPublicCardId(r7)     // Catch:{ all -> 0x028f }
            r14.mDefaultEuiccCardId = r3     // Catch:{ all -> 0x028f }
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x028f }
            r3.<init>()     // Catch:{ all -> 0x028f }
            java.lang.String r8 = "Using eid="
            r3.append(r8)     // Catch:{ all -> 0x028f }
            boolean r8 = com.android.internal.telephony.util.TelephonyUtils.IS_DEBUGGABLE     // Catch:{ all -> 0x028f }
            java.lang.String r7 = com.android.telephony.Rlog.pii(r8, r7)     // Catch:{ all -> 0x028f }
            r3.append(r7)     // Catch:{ all -> 0x028f }
            java.lang.String r7 = " in slot="
            r3.append(r7)     // Catch:{ all -> 0x028f }
            r3.append(r2)     // Catch:{ all -> 0x028f }
            java.lang.String r7 = " to set mDefaultEuiccCardId="
            r3.append(r7)     // Catch:{ all -> 0x028f }
            int r7 = r14.mDefaultEuiccCardId     // Catch:{ all -> 0x028f }
            r3.append(r7)     // Catch:{ all -> 0x028f }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x028f }
            r14.logWithLocalLog(r3)     // Catch:{ all -> 0x028f }
            r3 = r6
        L_0x0181:
            int r2 = r2 + 1
            goto L_0x00a0
        L_0x0185:
            boolean r2 = r14.mHasActiveBuiltInEuicc     // Catch:{ all -> 0x028f }
            if (r2 != 0) goto L_0x01dd
            if (r3 != 0) goto L_0x01dd
            r2 = r1
        L_0x018c:
            if (r2 >= r0) goto L_0x01dd
            com.android.internal.telephony.uicc.UiccSlot[] r7 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            r7 = r7[r2]     // Catch:{ all -> 0x028f }
            boolean r7 = r7.isEuicc()     // Catch:{ all -> 0x028f }
            if (r7 == 0) goto L_0x01da
            java.lang.Object r7 = r15.get(r2)     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.IccSlotStatus r7 = (com.android.internal.telephony.uicc.IccSlotStatus) r7     // Catch:{ all -> 0x028f }
            java.lang.String r7 = r7.eid     // Catch:{ all -> 0x028f }
            boolean r8 = android.text.TextUtils.isEmpty(r7)     // Catch:{ all -> 0x028f }
            if (r8 != 0) goto L_0x01da
            int r15 = r14.convertToPublicCardId(r7)     // Catch:{ all -> 0x028f }
            r14.mDefaultEuiccCardId = r15     // Catch:{ all -> 0x028f }
            java.lang.StringBuilder r15 = new java.lang.StringBuilder     // Catch:{ all -> 0x028f }
            r15.<init>()     // Catch:{ all -> 0x028f }
            java.lang.String r0 = "Using eid="
            r15.append(r0)     // Catch:{ all -> 0x028f }
            boolean r0 = com.android.internal.telephony.util.TelephonyUtils.IS_DEBUGGABLE     // Catch:{ all -> 0x028f }
            java.lang.String r0 = com.android.telephony.Rlog.pii(r0, r7)     // Catch:{ all -> 0x028f }
            r15.append(r0)     // Catch:{ all -> 0x028f }
            java.lang.String r0 = " from removable eUICC in slot="
            r15.append(r0)     // Catch:{ all -> 0x028f }
            r15.append(r2)     // Catch:{ all -> 0x028f }
            java.lang.String r0 = " to set mDefaultEuiccCardId="
            r15.append(r0)     // Catch:{ all -> 0x028f }
            int r0 = r14.mDefaultEuiccCardId     // Catch:{ all -> 0x028f }
            r15.append(r0)     // Catch:{ all -> 0x028f }
            java.lang.String r15 = r15.toString()     // Catch:{ all -> 0x028f }
            r14.logWithLocalLog(r15)     // Catch:{ all -> 0x028f }
            r3 = r6
            goto L_0x01dd
        L_0x01da:
            int r2 = r2 + 1
            goto L_0x018c
        L_0x01dd:
            boolean r15 = r14.mHasBuiltInEuicc     // Catch:{ all -> 0x028f }
            if (r15 == 0) goto L_0x01ee
            if (r5 != 0) goto L_0x01ee
            if (r3 != 0) goto L_0x01ee
            java.lang.String r15 = "onGetSlotStatusDone: mDefaultEuiccCardId=TEMPORARILY_UNSUPPORTED_CARD_ID"
            r14.logWithLocalLog(r15)     // Catch:{ all -> 0x028f }
            r15 = -3
            r14.mDefaultEuiccCardId = r15     // Catch:{ all -> 0x028f }
            r3 = r6
        L_0x01ee:
            if (r3 != 0) goto L_0x0249
            int r15 = r14.mDefaultEuiccCardId     // Catch:{ all -> 0x028f }
            r0 = -2
            if (r15 < 0) goto L_0x0242
            java.util.ArrayList<java.lang.String> r2 = r14.mCardStrings     // Catch:{ all -> 0x028f }
            java.lang.Object r15 = r2.get(r15)     // Catch:{ all -> 0x028f }
            java.lang.String r15 = (java.lang.String) r15     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccSlot[] r2 = r14.mUiccSlots     // Catch:{ all -> 0x028f }
            int r3 = r2.length     // Catch:{ all -> 0x028f }
            r5 = r1
        L_0x0201:
            if (r1 >= r3) goto L_0x0222
            r7 = r2[r1]     // Catch:{ all -> 0x028f }
            com.android.internal.telephony.uicc.UiccCard r8 = r7.getUiccCard()     // Catch:{ all -> 0x028f }
            if (r8 != 0) goto L_0x020c
            goto L_0x021f
        L_0x020c:
            com.android.internal.telephony.uicc.UiccCard r7 = r7.getUiccCard()     // Catch:{ all -> 0x028f }
            java.lang.String r7 = r7.getCardId()     // Catch:{ all -> 0x028f }
            java.lang.String r7 = com.android.internal.telephony.uicc.IccUtils.stripTrailingFs(r7)     // Catch:{ all -> 0x028f }
            boolean r7 = r15.equals(r7)     // Catch:{ all -> 0x028f }
            if (r7 == 0) goto L_0x021f
            r5 = r6
        L_0x021f:
            int r1 = r1 + 1
            goto L_0x0201
        L_0x0222:
            if (r5 != 0) goto L_0x0249
            java.lang.StringBuilder r15 = new java.lang.StringBuilder     // Catch:{ all -> 0x028f }
            r15.<init>()     // Catch:{ all -> 0x028f }
            java.lang.String r1 = "onGetSlotStatusDone: mDefaultEuiccCardId="
            r15.append(r1)     // Catch:{ all -> 0x028f }
            int r1 = r14.mDefaultEuiccCardId     // Catch:{ all -> 0x028f }
            r15.append(r1)     // Catch:{ all -> 0x028f }
            java.lang.String r1 = " is no longer inserted. Setting mDefaultEuiccCardId=UNINITIALIZED"
            r15.append(r1)     // Catch:{ all -> 0x028f }
            java.lang.String r15 = r15.toString()     // Catch:{ all -> 0x028f }
            r14.logWithLocalLog(r15)     // Catch:{ all -> 0x028f }
            r14.mDefaultEuiccCardId = r0     // Catch:{ all -> 0x028f }
            goto L_0x0249
        L_0x0242:
            java.lang.String r15 = "onGetSlotStatusDone: mDefaultEuiccCardId=UNINITIALIZED"
            r14.logWithLocalLog(r15)     // Catch:{ all -> 0x028f }
            r14.mDefaultEuiccCardId = r0     // Catch:{ all -> 0x028f }
        L_0x0249:
            int[] r15 = r14.mPhoneIdToSlotId     // Catch:{ all -> 0x028f }
            int r15 = r15.length     // Catch:{ all -> 0x028f }
            if (r4 == r15) goto L_0x026f
            java.lang.String r15 = "UiccController"
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x028f }
            r0.<init>()     // Catch:{ all -> 0x028f }
            java.lang.String r1 = "Number of active ports "
            r0.append(r1)     // Catch:{ all -> 0x028f }
            r0.append(r4)     // Catch:{ all -> 0x028f }
            java.lang.String r1 = " does not match the number of Phones"
            r0.append(r1)     // Catch:{ all -> 0x028f }
            int[] r1 = r14.mPhoneIdToSlotId     // Catch:{ all -> 0x028f }
            int r1 = r1.length     // Catch:{ all -> 0x028f }
            r0.append(r1)     // Catch:{ all -> 0x028f }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x028f }
            com.android.telephony.Rlog.e(r15, r0)     // Catch:{ all -> 0x028f }
        L_0x026f:
            android.app.BroadcastOptions r15 = android.app.BroadcastOptions.makeBasic()     // Catch:{ all -> 0x028f }
            r15.setBackgroundActivityStartsAllowed(r6)     // Catch:{ all -> 0x028f }
            android.content.Intent r0 = new android.content.Intent     // Catch:{ all -> 0x028f }
            java.lang.String r1 = "android.telephony.action.SIM_SLOT_STATUS_CHANGED"
            r0.<init>(r1)     // Catch:{ all -> 0x028f }
            r1 = 67108864(0x4000000, float:1.5046328E-36)
            r0.addFlags(r1)     // Catch:{ all -> 0x028f }
            android.content.Context r1 = r14.mContext     // Catch:{ all -> 0x028f }
            java.lang.String r2 = "android.permission.READ_PRIVILEGED_PHONE_STATE"
            android.os.Bundle r15 = r15.toBundle()     // Catch:{ all -> 0x028f }
            r1.sendBroadcast(r0, r2, r15)     // Catch:{ all -> 0x028f }
            monitor-exit(r14)
            return
        L_0x028f:
            r15 = move-exception
            monitor-exit(r14)
            throw r15
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccController.onGetSlotStatusDone(android.os.AsyncResult):void");
    }

    private boolean hasActivePort(IccSimPortInfo[] iccSimPortInfoArr) {
        for (IccSimPortInfo iccSimPortInfo : iccSimPortInfoArr) {
            if (iccSimPortInfo.mPortActive) {
                return true;
            }
        }
        return false;
    }

    @VisibleForTesting
    public boolean slotStatusChanged(ArrayList<IccSlotStatus> arrayList) {
        ArrayList<IccSlotStatus> arrayList2 = sLastSlotStatus;
        if (arrayList2 == null || arrayList2.size() != arrayList.size()) {
            return true;
        }
        for (int i = 0; i < arrayList.size(); i++) {
            if (!sLastSlotStatus.get(i).equals(arrayList.get(i))) {
                return true;
            }
        }
        return false;
    }

    private void logPhoneIdToSlotIdMapping() {
        log("mPhoneIdToSlotId mapping:");
        for (int i = 0; i < this.mPhoneIdToSlotId.length; i++) {
            log("    phoneId " + i + " slotId " + this.mPhoneIdToSlotId[i]);
        }
    }

    private void onSimRefresh(AsyncResult asyncResult, Integer num) {
        if (asyncResult.exception != null) {
            Rlog.e(LOG_TAG, "onSimRefresh: Sim REFRESH with exception: " + asyncResult.exception);
        } else if (!isValidPhoneIndex(num.intValue())) {
            Rlog.e(LOG_TAG, "onSimRefresh: invalid index : " + num);
        } else {
            IccRefreshResponse iccRefreshResponse = (IccRefreshResponse) asyncResult.result;
            logWithLocalLog("onSimRefresh: index " + num + ", " + iccRefreshResponse);
            if (iccRefreshResponse == null) {
                Rlog.e(LOG_TAG, "onSimRefresh: received without input");
            } else if (getUiccCardForPhone(num.intValue()) == null) {
                Rlog.e(LOG_TAG, "onSimRefresh: refresh on null card : " + num);
            } else {
                UiccPort uiccPortForPhone = getUiccPortForPhone(num.intValue());
                if (uiccPortForPhone == null) {
                    Rlog.e(LOG_TAG, "onSimRefresh: refresh on null port : " + num);
                    return;
                }
                int i = iccRefreshResponse.refreshResult;
                boolean z = false;
                if (i == 1) {
                    z = uiccPortForPhone.resetAppWithAid(iccRefreshResponse.aid, false);
                } else if (i == 2) {
                    z = uiccPortForPhone.resetAppWithAid(iccRefreshResponse.aid, true);
                } else if (i != 4) {
                    return;
                }
                if (z && iccRefreshResponse.refreshResult == 2) {
                    ((CarrierConfigManager) this.mContext.getSystemService("carrier_config")).updateConfigForPhoneId(num.intValue(), "UNKNOWN");
                }
                this.mCis[num.intValue()].getIccCardStatus(obtainMessage(3, num));
            }
        }
    }

    private void onEidReady(AsyncResult asyncResult, Integer num) {
        if (asyncResult.exception != null) {
            Rlog.e(LOG_TAG, "onEidReady: exception: " + asyncResult.exception);
        } else if (!isValidPhoneIndex(num.intValue())) {
            Rlog.e(LOG_TAG, "onEidReady: invalid index: " + num);
        } else {
            int i = this.mPhoneIdToSlotId[num.intValue()];
            EuiccCard euiccCard = (EuiccCard) this.mUiccSlots[i].getUiccCard();
            if (euiccCard == null) {
                Rlog.e(LOG_TAG, "onEidReady: UiccCard in slot " + i + " is null");
                return;
            }
            String eid = euiccCard.getEid();
            addCardId(eid);
            int i2 = this.mDefaultEuiccCardId;
            if (i2 == -2 || i2 == -3) {
                if (!this.mUiccSlots[i].isRemovable()) {
                    this.mDefaultEuiccCardId = convertToPublicCardId(eid);
                    logWithLocalLog("onEidReady: eid=" + Rlog.pii(TelephonyUtils.IS_DEBUGGABLE, eid) + " slot=" + i + " mDefaultEuiccCardId=" + this.mDefaultEuiccCardId);
                } else if (!this.mHasActiveBuiltInEuicc) {
                    this.mDefaultEuiccCardId = convertToPublicCardId(eid);
                    logWithLocalLog("onEidReady: eid=" + Rlog.pii(TelephonyUtils.IS_DEBUGGABLE, eid) + " from removable eUICC in slot=" + i + " mDefaultEuiccCardId=" + this.mDefaultEuiccCardId);
                }
            }
            euiccCard.unregisterForEidReady(this);
        }
    }

    private boolean hasBuiltInEuicc() {
        int[] iArr = this.mEuiccSlots;
        return iArr != null && iArr.length > 0;
    }

    private boolean isBuiltInEuiccSlot(int i) {
        if (!this.mHasBuiltInEuicc) {
            return false;
        }
        for (int i2 : this.mEuiccSlots) {
            if (i2 == i) {
                return true;
            }
        }
        return false;
    }

    public static boolean isCdmaSupported(Context context) {
        return context.getPackageManager().hasSystemFeature("android.hardware.telephony.cdma");
    }

    private boolean isValidPhoneIndex(int i) {
        return i >= 0 && i < TelephonyManager.getDefault().getPhoneCount();
    }

    private boolean isValidSlotIndex(int i) {
        return i >= 0 && i < this.mUiccSlots.length;
    }

    private boolean isShuttingDown() {
        for (int i = 0; i < TelephonyManager.getDefault().getActiveModemCount(); i++) {
            if (PhoneFactory.getPhone(i) != null && PhoneFactory.getPhone(i).isShuttingDown()) {
                return true;
            }
        }
        return false;
    }

    private static boolean iccidMatches(String str, String str2) {
        for (String startsWith : str.split(",")) {
            if (str2.startsWith(startsWith)) {
                Log.d(LOG_TAG, "mvno icc id match found");
                return true;
            }
        }
        return false;
    }

    private static boolean imsiMatches(String str, String str2) {
        int length = str.length();
        if (length <= 0 || length > str2.length()) {
            return false;
        }
        for (int i = 0; i < length; i++) {
            char charAt = str.charAt(i);
            if (charAt != 'x' && charAt != 'X' && charAt != str2.charAt(i)) {
                return false;
            }
        }
        return true;
    }

    /* JADX WARNING: Removed duplicated region for block: B:32:0x005c A[RETURN] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean mvnoMatches(int r3, int r4, java.lang.String r5) {
        /*
            r2 = this;
            r0 = 1
            com.android.internal.telephony.uicc.IccRecords r2 = r2.getIccRecords(r3, r0)
            r3 = 0
            if (r2 != 0) goto L_0x0010
            java.lang.String r2 = "UiccController"
            java.lang.String r4 = "isMvnoMatched# IccRecords is null"
            android.util.Log.d(r2, r4)
            return r3
        L_0x0010:
            if (r4 != 0) goto L_0x001f
            java.lang.String r2 = r2.getServiceProviderNameWithBrandOverride()
            if (r2 == 0) goto L_0x005c
            boolean r2 = r2.equalsIgnoreCase(r5)
            if (r2 == 0) goto L_0x005c
            return r0
        L_0x001f:
            if (r4 != r0) goto L_0x002e
            java.lang.String r2 = r2.getIMSI()
            if (r2 == 0) goto L_0x005c
            boolean r2 = imsiMatches(r5, r2)
            if (r2 == 0) goto L_0x005c
            return r0
        L_0x002e:
            r1 = 2
            if (r4 != r1) goto L_0x004c
            java.lang.String r2 = r2.getGid1()
            int r4 = r5.length()
            if (r2 == 0) goto L_0x005c
            int r1 = r2.length()
            if (r1 < r4) goto L_0x005c
            java.lang.String r2 = r2.substring(r3, r4)
            boolean r2 = r2.equalsIgnoreCase(r5)
            if (r2 == 0) goto L_0x005c
            return r0
        L_0x004c:
            r1 = 3
            if (r4 != r1) goto L_0x005c
            java.lang.String r2 = r2.getIccId()
            if (r2 == 0) goto L_0x005c
            boolean r2 = iccidMatches(r5, r2)
            if (r2 == 0) goto L_0x005c
            return r0
        L_0x005c:
            return r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccController.mvnoMatches(int, int, java.lang.String):boolean");
    }

    public void setRemovableEsimAsDefaultEuicc(boolean z) {
        this.mUseRemovableEsimAsDefault = z;
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(this.mContext).edit();
        edit.putBoolean(REMOVABLE_ESIM_AS_DEFAULT, z);
        edit.apply();
        Rlog.d(LOG_TAG, "setRemovableEsimAsDefaultEuicc isDefault: " + z);
    }

    public boolean isRemovableEsimDefaultEuicc() {
        Rlog.d(LOG_TAG, "mUseRemovableEsimAsDefault: " + this.mUseRemovableEsimAsDefault);
        return this.mUseRemovableEsimAsDefault;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    private void logWithLocalLog(String str) {
        Rlog.d(LOG_TAG, str);
        LocalLog localLog = sLocalLog;
        localLog.log("UiccController: " + str);
    }

    private void logeWithLocalLog(String str) {
        Rlog.e(LOG_TAG, str);
        LocalLog localLog = sLocalLog;
        localLog.log("UiccController: " + str);
    }

    public static void addLocalLog(String str) {
        sLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("UiccController: " + this);
        printWriter.println(" mContext=" + this.mContext);
        printWriter.println(" mInstance=" + mInstance);
        printWriter.println(" mIccChangedRegistrants: size=" + this.mIccChangedRegistrants.size());
        int i = 0;
        for (int i2 = 0; i2 < this.mIccChangedRegistrants.size(); i2++) {
            printWriter.println("  mIccChangedRegistrants[" + i2 + "]=" + ((Registrant) this.mIccChangedRegistrants.get(i2)).getHandler());
        }
        printWriter.println();
        printWriter.flush();
        printWriter.println(" mIsCdmaSupported=" + isCdmaSupported(this.mContext));
        printWriter.println(" mHasBuiltInEuicc=" + this.mHasBuiltInEuicc);
        printWriter.println(" mHasActiveBuiltInEuicc=" + this.mHasActiveBuiltInEuicc);
        printWriter.println(" mCardStrings=" + this.mCardStrings);
        printWriter.println(" mDefaultEuiccCardId=" + this.mDefaultEuiccCardId);
        printWriter.println(" mPhoneIdToSlotId=" + Arrays.toString(this.mPhoneIdToSlotId));
        printWriter.println(" mUseRemovableEsimAsDefault=" + this.mUseRemovableEsimAsDefault);
        printWriter.println(" mUiccSlots: size=" + this.mUiccSlots.length);
        while (true) {
            UiccSlot[] uiccSlotArr = this.mUiccSlots;
            if (i < uiccSlotArr.length) {
                if (uiccSlotArr[i] == null) {
                    printWriter.println("  mUiccSlots[" + i + "]=null");
                } else {
                    printWriter.println("  mUiccSlots[" + i + "]=" + this.mUiccSlots[i]);
                    this.mUiccSlots[i].dump(fileDescriptor, printWriter, strArr);
                }
                i++;
            } else {
                printWriter.println(" sLocalLog= ");
                sLocalLog.dump(fileDescriptor, printWriter, strArr);
                this.mPinStorage.dump(fileDescriptor, printWriter, strArr);
                return;
            }
        }
    }
}
