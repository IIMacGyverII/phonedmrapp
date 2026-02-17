package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.hardware.radio.V1_0.IRadio;
import android.hardware.radio.V1_0.RadioResponseInfo;
import android.hardware.radio.data.IRadioData;
import android.hardware.radio.messaging.IRadioMessaging;
import android.hardware.radio.modem.IRadioModem;
import android.hardware.radio.network.IRadioNetwork;
import android.hardware.radio.sim.IRadioSim;
import android.hardware.radio.voice.IRadioVoice;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.net.KeepalivePacketData;
import android.net.LinkProperties;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.IBinder;
import android.os.IHwBinder;
import android.os.Message;
import android.os.PowerManager;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.os.WorkSource;
import android.provider.Settings;
import android.telephony.AccessNetworkConstants;
import android.telephony.CarrierRestrictionRules;
import android.telephony.CellSignalStrengthCdma;
import android.telephony.CellSignalStrengthGsm;
import android.telephony.CellSignalStrengthLte;
import android.telephony.CellSignalStrengthNr;
import android.telephony.CellSignalStrengthTdscdma;
import android.telephony.CellSignalStrengthWcdma;
import android.telephony.ClientRequestStats;
import android.telephony.ImsiEncryptionInfo;
import android.telephony.ModemActivityInfo;
import android.telephony.NeighboringCellInfo;
import android.telephony.NetworkScanRequest;
import android.telephony.RadioAccessFamily;
import android.telephony.RadioAccessSpecifier;
import android.telephony.ServiceState;
import android.telephony.SignalStrength;
import android.telephony.SignalThresholdInfo;
import android.telephony.TelephonyHistogram;
import android.telephony.TelephonyManager;
import android.telephony.data.DataProfile;
import android.telephony.data.NetworkSliceInfo;
import android.telephony.data.TrafficDescriptor;
import android.telephony.emergency.EmergencyNumber;
import android.telephony.gsm.SmsMessage;
import android.text.TextUtils;
import android.util.SparseArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.SMSDispatcher;
import com.android.internal.telephony.cat.BerTlv;
import com.android.internal.telephony.cdma.CdmaInformationRecords;
import com.android.internal.telephony.cdma.CdmaSmsBroadcastConfigInfo;
import com.android.internal.telephony.gsm.SmsBroadcastConfigInfo;
import com.android.internal.telephony.metrics.ModemRestartStats;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.SimPhonebookRecord;
import com.android.internal.telephony.util.NetworkStackConstants;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import com.pri.prizeinterphone.InterPhoneService;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;

public class RIL extends BaseCommands implements CommandsInterface {
    public static final int DATA_SERVICE = 1;
    private static final int DEFAULT_ACK_WAKE_LOCK_TIMEOUT_MS = 200;
    protected static final int DEFAULT_BLOCKING_MESSAGE_RESPONSE_TIMEOUT_MS = 2000;
    private static final int DEFAULT_WAKE_LOCK_TIMEOUT_MS = 60000;
    static final int EVENT_ACK_WAKE_LOCK_TIMEOUT = 4;
    protected static final int EVENT_AIDL_PROXY_DEAD = 7;
    protected static final int EVENT_BLOCKING_RESPONSE_TIMEOUT = 5;
    protected static final int EVENT_RADIO_PROXY_DEAD = 6;
    static final int EVENT_WAKE_LOCK_TIMEOUT = 2;
    public static final int FOR_ACK_WAKELOCK = 1;
    public static final int FOR_WAKELOCK = 0;
    static final String[] HIDL_SERVICE_NAME = {"slot1", "slot2", "slot3"};
    public static final int INVALID_WAKELOCK = -1;
    protected static final int IRADIO_GET_SERVICE_DELAY_MILLIS = 1000;
    public static final int MAX_SERVICE_IDX = 6;
    public static final int MESSAGING_SERVICE = 2;
    public static final int MIN_SERVICE_IDX = 0;
    public static final int MODEM_SERVICE = 3;
    public static final int NETWORK_SERVICE = 4;
    private static final String PROPERTY_IS_VONR_ENABLED = "persist.radio.is_vonr_enabled_";
    public static final HalVersion RADIO_HAL_VERSION_1_0 = new HalVersion(1, 0);
    public static final HalVersion RADIO_HAL_VERSION_1_1 = new HalVersion(1, 1);
    public static final HalVersion RADIO_HAL_VERSION_1_2 = new HalVersion(1, 2);
    public static final HalVersion RADIO_HAL_VERSION_1_3 = new HalVersion(1, 3);
    public static final HalVersion RADIO_HAL_VERSION_1_4 = new HalVersion(1, 4);
    public static final HalVersion RADIO_HAL_VERSION_1_5 = new HalVersion(1, 5);
    public static final HalVersion RADIO_HAL_VERSION_1_6 = new HalVersion(1, 6);
    public static final HalVersion RADIO_HAL_VERSION_2_0 = new HalVersion(2, 0);
    public static final HalVersion RADIO_HAL_VERSION_UNKNOWN = HalVersion.UNKNOWN;
    public static final int RADIO_SERVICE = 0;
    static final String RILJ_ACK_WAKELOCK_NAME = "RILJ_ACK_WL";
    static final boolean RILJ_LOGD = true;
    static final boolean RILJ_LOGV = false;
    static final String RILJ_LOG_TAG = "RILJ";
    static final String RILJ_WAKELOCK_TAG = "*telephony-radio*";
    static final int RIL_HISTOGRAM_BUCKET_COUNT = 5;
    public static final int SIM_SERVICE = 5;
    public static final int VOICE_SERVICE = 6;
    static SparseArray<TelephonyHistogram> sRilTimeHistograms = new SparseArray<>();
    @VisibleForTesting
    public final PowerManager.WakeLock mAckWakeLock;
    final int mAckWakeLockTimeout;
    volatile int mAckWlSequenceNum;
    private WorkSource mActiveWakelockWorkSource;
    private final ClientWakelockTracker mClientWakelockTracker;
    private final ConcurrentHashMap<Integer, HalVersion> mCompatOverrides;
    public DataIndication mDataIndication;
    public DataResponse mDataResponse;
    protected final SparseArray<BinderServiceDeathRecipient> mDeathRecipients;
    private final SparseArray<Set<Integer>> mDisabledRadioServices;
    protected boolean mIsCellularSupported;
    boolean mIsRadioProxyInitialized;
    Object[] mLastNITZTimeInfo;
    int mLastRadioPowerResult;
    public MessagingIndication mMessagingIndication;
    public MessagingResponse mMessagingResponse;
    protected TelephonyMetrics mMetrics;
    protected MockModem mMockModem;
    public ModemIndication mModemIndication;
    public ModemResponse mModemResponse;
    public NetworkIndication mNetworkIndication;
    public NetworkResponse mNetworkResponse;
    protected final Integer mPhoneId;
    protected WorkSource mRILDefaultWorkSource;
    /* access modifiers changed from: private */
    public RadioBugDetector mRadioBugDetector;
    RadioIndication mRadioIndication;
    protected volatile IRadio mRadioProxy;
    protected final RadioProxyDeathRecipient mRadioProxyDeathRecipient;
    RadioResponse mRadioResponse;
    protected HalVersion mRadioVersion;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    SparseArray<RILRequest> mRequestList;
    protected RilHandler mRilHandler;
    protected final SparseArray<AtomicLong> mServiceCookies;
    protected SparseArray<RadioServiceProxy> mServiceProxies;
    public SimIndication mSimIndication;
    public SimResponse mSimResponse;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public AtomicBoolean mTestingEmergencyCall;
    public VoiceIndication mVoiceIndication;
    public VoiceResponse mVoiceResponse;
    @UnsupportedAppUsage
    @VisibleForTesting
    public final PowerManager.WakeLock mWakeLock;
    int mWakeLockCount;
    final int mWakeLockTimeout;
    volatile int mWlSequenceNum;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void invokeOemRilRequestRaw(byte[] bArr, Message message) {
    }

    public void invokeOemRilRequestStrings(String[] strArr, Message message) {
    }

    /* access modifiers changed from: protected */
    public boolean isGetHidlServiceSync() {
        return true;
    }

    public static List<TelephonyHistogram> getTelephonyRILTimingHistograms() {
        ArrayList arrayList;
        synchronized (sRilTimeHistograms) {
            arrayList = new ArrayList(sRilTimeHistograms.size());
            for (int i = 0; i < sRilTimeHistograms.size(); i++) {
                arrayList.add(new TelephonyHistogram(sRilTimeHistograms.valueAt(i)));
            }
        }
        return arrayList;
    }

    @VisibleForTesting
    public class RilHandler extends Handler {
        public RilHandler() {
        }

        public void handleMessage(Message message) {
            int i = message.what;
            if (i == 2) {
                synchronized (RIL.this.mRequestList) {
                    if (message.arg1 == RIL.this.mWlSequenceNum && RIL.this.clearWakeLock(0)) {
                        if (RIL.this.mRadioBugDetector != null) {
                            RIL.this.mRadioBugDetector.processWakelockTimeout();
                        }
                        int size = RIL.this.mRequestList.size();
                        Rlog.d(RIL.RILJ_LOG_TAG, "WAKE_LOCK_TIMEOUT  mRequestList=" + size);
                        for (int i2 = 0; i2 < size; i2++) {
                            RILRequest valueAt = RIL.this.mRequestList.valueAt(i2);
                            Rlog.d(RIL.RILJ_LOG_TAG, i2 + ": [" + valueAt.mSerial + "] " + RILUtils.requestToString(valueAt.mRequest));
                        }
                    }
                }
            } else if (i != 4) {
                if (i == 5) {
                    RILRequest r8 = RIL.this.findAndRemoveRequestFromList(((Integer) message.obj).intValue());
                    if (r8 != null) {
                        if (r8.mResult != null) {
                            AsyncResult.forMessage(r8.mResult, RIL.getResponseForTimedOutRILRequest(r8), (Throwable) null);
                            r8.mResult.sendToTarget();
                            RIL ril = RIL.this;
                            ril.mMetrics.writeOnRilTimeoutResponse(ril.mPhoneId.intValue(), r8.mSerial, r8.mRequest);
                        }
                        RIL.this.decrementWakeLock(r8);
                        r8.release();
                    }
                } else if (i == 6) {
                    int i3 = message.arg1;
                    RIL ril2 = RIL.this;
                    ril2.riljLog("handleMessage: EVENT_RADIO_PROXY_DEAD cookie = " + message.obj + ", service = " + RIL.serviceToString(i3) + ", service cookie = " + RIL.this.mServiceCookies.get(i3));
                    if (((Long) message.obj).longValue() == RIL.this.mServiceCookies.get(i3).get()) {
                        RIL ril3 = RIL.this;
                        ril3.mIsRadioProxyInitialized = false;
                        ril3.resetProxyAndRequestList(i3);
                    }
                } else if (i == 7) {
                    int i4 = message.arg1;
                    long longValue = ((Long) message.obj).longValue();
                    RIL ril4 = RIL.this;
                    ril4.riljLog("handleMessage: EVENT_AIDL_PROXY_DEAD cookie = " + longValue + ", service = " + RIL.serviceToString(i4) + ", cookie = " + RIL.this.mServiceCookies.get(i4));
                    if (longValue == RIL.this.mServiceCookies.get(i4).get()) {
                        RIL ril5 = RIL.this;
                        ril5.mIsRadioProxyInitialized = false;
                        ril5.resetProxyAndRequestList(i4);
                    }
                }
            } else if (message.arg1 == RIL.this.mAckWlSequenceNum) {
                boolean unused = RIL.this.clearWakeLock(1);
            }
        }
    }

    @VisibleForTesting
    public RadioBugDetector getRadioBugDetector() {
        if (this.mRadioBugDetector == null) {
            this.mRadioBugDetector = new RadioBugDetector(this.mContext, this.mPhoneId.intValue());
        }
        return this.mRadioBugDetector;
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static Object getResponseForTimedOutRILRequest(RILRequest rILRequest) {
        if (rILRequest != null && rILRequest.mRequest == 135) {
            return new ModemActivityInfo(0, 0, 0, new int[ModemActivityInfo.getNumTxPowerLevels()], 0);
        }
        return null;
    }

    final class RadioProxyDeathRecipient implements IHwBinder.DeathRecipient {
        RadioProxyDeathRecipient() {
        }

        public void serviceDied(long j) {
            RIL.this.riljLog("serviceDied");
            RIL.this.mRilHandler.removeMessages(6);
            RilHandler rilHandler = RIL.this.mRilHandler;
            rilHandler.sendMessageDelayed(rilHandler.obtainMessage(6, 0, 0, Long.valueOf(j)), 1000);
        }
    }

    private final class BinderServiceDeathRecipient implements IBinder.DeathRecipient {
        private IBinder mBinder;
        private final int mService;

        BinderServiceDeathRecipient(int i) {
            this.mService = i;
        }

        public void linkToDeath(IBinder iBinder) throws RemoteException {
            if (iBinder != null) {
                this.mBinder = iBinder;
                iBinder.linkToDeath(this, (int) RIL.this.mServiceCookies.get(this.mService).incrementAndGet());
            }
        }

        public synchronized void unlinkToDeath() {
            IBinder iBinder = this.mBinder;
            if (iBinder != null) {
                iBinder.unlinkToDeath(this, 0);
                this.mBinder = null;
            }
        }

        public void binderDied() {
            RIL ril = RIL.this;
            ril.riljLog("Service " + RIL.serviceToString(this.mService) + " has died.");
            RIL ril2 = RIL.this;
            RilHandler rilHandler = ril2.mRilHandler;
            int i = this.mService;
            rilHandler.sendMessage(rilHandler.obtainMessage(7, i, 0, Long.valueOf(ril2.mServiceCookies.get(i).get())));
            unlinkToDeath();
        }
    }

    /* access modifiers changed from: protected */
    public synchronized void resetProxyAndRequestList(int i) {
        if (i == 0) {
            this.mRadioProxy = null;
        } else {
            this.mServiceProxies.get(i).clear();
        }
        this.mServiceCookies.get(i).incrementAndGet();
        setRadioState(2, true);
        RILRequest.resetSerial();
        clearRequestList(1, false);
        if (i == 0) {
            getRadioProxy((Message) null);
        } else {
            getRadioServiceProxy(i, (Message) null);
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:11:0x0047  */
    /* JADX WARNING: Removed duplicated region for block: B:38:0x0073 A[SYNTHETIC] */
    /* JADX WARNING: Removed duplicated region for block: B:40:0x0092 A[SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean setModemService(java.lang.String r10) {
        /*
            r9 = this;
            r0 = 0
            r1 = 6
            r2 = 1
            r3 = 0
            if (r10 == 0) goto L_0x00a2
            java.lang.String r4 = "Binding to MockModemService"
            r9.riljLog(r4)
            r9.mMockModem = r0
            com.android.internal.telephony.MockModem r4 = new com.android.internal.telephony.MockModem
            android.content.Context r5 = r9.mContext
            java.lang.Integer r6 = r9.mPhoneId
            int r6 = r6.intValue()
            r4.<init>(r5, r10, r6)
            r9.mMockModem = r4
            android.hardware.radio.V1_0.IRadio r4 = r9.mRadioProxy
            if (r4 == 0) goto L_0x0032
            java.lang.String r4 = "Disable HIDL service"
            r9.riljLog(r4)
            android.util.SparseArray<java.util.Set<java.lang.Integer>> r4 = r9.mDisabledRadioServices
            java.lang.Object r4 = r4.get(r3)
            java.util.Set r4 = (java.util.Set) r4
            java.lang.Integer r5 = r9.mPhoneId
            r4.add(r5)
        L_0x0032:
            com.android.internal.telephony.MockModem r4 = r9.mMockModem
            r4.bindAllMockModemService()
            r4 = r3
        L_0x0038:
            if (r4 > r1) goto L_0x0095
            if (r4 != 0) goto L_0x003d
            goto L_0x0092
        L_0x003d:
            r5 = r3
        L_0x003e:
            com.android.internal.telephony.MockModem r6 = r9.mMockModem
            android.os.IBinder r6 = r6.getServiceBinder(r4)
            int r5 = r5 + r2
            if (r6 != 0) goto L_0x006c
            java.lang.StringBuilder r7 = new java.lang.StringBuilder
            r7.<init>()
            java.lang.String r8 = "Retry("
            r7.append(r8)
            r7.append(r5)
            java.lang.String r8 = ") Service "
            r7.append(r8)
            java.lang.String r8 = serviceToString(r4)
            r7.append(r8)
            java.lang.String r7 = r7.toString()
            r9.riljLog(r7)
            r7 = 300(0x12c, double:1.48E-321)
            java.lang.Thread.sleep(r7)     // Catch:{ InterruptedException -> 0x006c }
        L_0x006c:
            if (r6 != 0) goto L_0x0071
            r7 = 3
            if (r5 < r7) goto L_0x003e
        L_0x0071:
            if (r6 != 0) goto L_0x0092
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r5 = "Service "
            r2.append(r5)
            java.lang.String r4 = serviceToString(r4)
            r2.append(r4)
            java.lang.String r4 = " bind fail"
            r2.append(r4)
            java.lang.String r2 = r2.toString()
            r9.riljLoge(r2)
            r2 = r3
            goto L_0x0095
        L_0x0092:
            int r4 = r4 + 1
            goto L_0x0038
        L_0x0095:
            if (r2 == 0) goto L_0x00a2
            r9.mIsRadioProxyInitialized = r3
            r4 = r3
        L_0x009a:
            if (r4 > r1) goto L_0x00a2
            r9.resetProxyAndRequestList(r4)
            int r4 = r4 + 1
            goto L_0x009a
        L_0x00a2:
            if (r10 == 0) goto L_0x00a6
            if (r2 != 0) goto L_0x00da
        L_0x00a6:
            if (r2 == 0) goto L_0x00ad
            java.lang.String r10 = "Unbinding to MockModemService"
            r9.riljLog(r10)
        L_0x00ad:
            android.util.SparseArray<java.util.Set<java.lang.Integer>> r10 = r9.mDisabledRadioServices
            java.lang.Object r10 = r10.get(r3)
            java.util.Set r10 = (java.util.Set) r10
            java.lang.Integer r4 = r9.mPhoneId
            boolean r10 = r10.contains(r4)
            if (r10 == 0) goto L_0x00c8
            android.util.SparseArray<java.util.Set<java.lang.Integer>> r10 = r9.mDisabledRadioServices
            java.lang.Object r10 = r10.get(r3)
            java.util.Set r10 = (java.util.Set) r10
            r10.clear()
        L_0x00c8:
            com.android.internal.telephony.MockModem r10 = r9.mMockModem
            if (r10 == 0) goto L_0x00da
            com.android.internal.telephony.HalVersion r10 = RADIO_HAL_VERSION_UNKNOWN
            r9.mRadioVersion = r10
            r9.mMockModem = r0
        L_0x00d2:
            if (r3 > r1) goto L_0x00da
            r9.resetProxyAndRequestList(r3)
            int r3 = r3 + 1
            goto L_0x00d2
        L_0x00da:
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RIL.setModemService(java.lang.String):boolean");
    }

    public String getModemService() {
        MockModem mockModem = this.mMockModem;
        return mockModem != null ? mockModem.getServiceName() : "default";
    }

    @VisibleForTesting
    public void setCompatVersion(int i, HalVersion halVersion) {
        HalVersion compatVersion = getCompatVersion(i);
        if (compatVersion == null || !halVersion.greaterOrEqual(compatVersion)) {
            this.mCompatOverrides.put(Integer.valueOf(i), halVersion);
            return;
        }
        riljLoge("setCompatVersion with equal or greater one, ignored, halVerion=" + halVersion + ", oldVerion=" + compatVersion);
    }

    @VisibleForTesting
    public HalVersion getCompatVersion(int i) {
        return this.mCompatOverrides.getOrDefault(Integer.valueOf(i), (Object) null);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:18:0x002e, code lost:
        return null;
     */
    @com.android.internal.annotations.VisibleForTesting
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized android.hardware.radio.V1_0.IRadio getRadioProxy(android.os.Message r8) {
        /*
            r7 = this;
            monitor-enter(r7)
            com.android.internal.telephony.HalVersion r0 = r7.mRadioVersion     // Catch:{ all -> 0x01c4 }
            com.android.internal.telephony.HalVersion r1 = RADIO_HAL_VERSION_2_0     // Catch:{ all -> 0x01c4 }
            boolean r0 = r0.greaterOrEqual(r1)     // Catch:{ all -> 0x01c4 }
            r1 = 0
            if (r0 == 0) goto L_0x000e
            monitor-exit(r7)
            return r1
        L_0x000e:
            java.lang.Integer r0 = r7.mPhoneId     // Catch:{ all -> 0x01c4 }
            int r0 = r0.intValue()     // Catch:{ all -> 0x01c4 }
            boolean r0 = android.telephony.SubscriptionManager.isValidPhoneId(r0)     // Catch:{ all -> 0x01c4 }
            if (r0 != 0) goto L_0x001c
            monitor-exit(r7)
            return r1
        L_0x001c:
            boolean r0 = r7.mIsCellularSupported     // Catch:{ all -> 0x01c4 }
            r2 = 1
            if (r0 != 0) goto L_0x002f
            if (r8 == 0) goto L_0x002d
            com.android.internal.telephony.CommandException r0 = com.android.internal.telephony.CommandException.fromRilErrno(r2)     // Catch:{ all -> 0x01c4 }
            android.os.AsyncResult.forMessage(r8, r1, r0)     // Catch:{ all -> 0x01c4 }
            r8.sendToTarget()     // Catch:{ all -> 0x01c4 }
        L_0x002d:
            monitor-exit(r7)
            return r1
        L_0x002f:
            android.hardware.radio.V1_0.IRadio r0 = r7.mRadioProxy     // Catch:{ all -> 0x01c4 }
            if (r0 == 0) goto L_0x0037
            android.hardware.radio.V1_0.IRadio r8 = r7.mRadioProxy     // Catch:{ all -> 0x01c4 }
            monitor-exit(r7)
            return r8
        L_0x0037:
            r0 = 0
            android.util.SparseArray<java.util.Set<java.lang.Integer>> r3 = r7.mDisabledRadioServices     // Catch:{ RemoteException -> 0x0163 }
            java.lang.Object r3 = r3.get(r0)     // Catch:{ RemoteException -> 0x0163 }
            java.util.Set r3 = (java.util.Set) r3     // Catch:{ RemoteException -> 0x0163 }
            java.lang.Integer r4 = r7.mPhoneId     // Catch:{ RemoteException -> 0x0163 }
            boolean r3 = r3.contains(r4)     // Catch:{ RemoteException -> 0x0163 }
            if (r3 == 0) goto L_0x006d
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x0163 }
            r3.<init>()     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String r4 = "getRadioProxy: mRadioProxy for "
            r3.append(r4)     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String[] r4 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x0163 }
            java.lang.Integer r5 = r7.mPhoneId     // Catch:{ RemoteException -> 0x0163 }
            int r5 = r5.intValue()     // Catch:{ RemoteException -> 0x0163 }
            r4 = r4[r5]     // Catch:{ RemoteException -> 0x0163 }
            r3.append(r4)     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String r4 = " is disabled"
            r3.append(r4)     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String r3 = r3.toString()     // Catch:{ RemoteException -> 0x0163 }
            r7.riljLoge(r3)     // Catch:{ RemoteException -> 0x0163 }
            goto L_0x017a
        L_0x006d:
            java.lang.String[] r3 = HIDL_SERVICE_NAME     // Catch:{ NoSuchElementException -> 0x0086 }
            java.lang.Integer r4 = r7.mPhoneId     // Catch:{ NoSuchElementException -> 0x0086 }
            int r4 = r4.intValue()     // Catch:{ NoSuchElementException -> 0x0086 }
            r3 = r3[r4]     // Catch:{ NoSuchElementException -> 0x0086 }
            boolean r4 = r7.isGetHidlServiceSync()     // Catch:{ NoSuchElementException -> 0x0086 }
            android.hardware.radio.V1_0.IRadio r3 = android.hardware.radio.V1_0.IRadio.getService(r3, r4)     // Catch:{ NoSuchElementException -> 0x0086 }
            r7.mRadioProxy = r3     // Catch:{ NoSuchElementException -> 0x0086 }
            com.android.internal.telephony.HalVersion r3 = RADIO_HAL_VERSION_1_0     // Catch:{ NoSuchElementException -> 0x0086 }
            r7.mRadioVersion = r3     // Catch:{ NoSuchElementException -> 0x0086 }
            goto L_0x008b
        L_0x0086:
            java.lang.String r3 = "getRadioProxy: NoSuchElementException "
            r7.riljLoge(r3)     // Catch:{ RemoteException -> 0x0163 }
        L_0x008b:
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            if (r3 == 0) goto L_0x013f
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_6.IRadio r3 = android.hardware.radio.V1_6.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            if (r3 == 0) goto L_0x00a4
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_6.IRadio r3 = android.hardware.radio.V1_6.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioProxy = r3     // Catch:{ RemoteException -> 0x0163 }
            com.android.internal.telephony.HalVersion r3 = RADIO_HAL_VERSION_1_6     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioVersion = r3     // Catch:{ RemoteException -> 0x0163 }
            goto L_0x010c
        L_0x00a4:
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_5.IRadio r3 = android.hardware.radio.V1_5.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            if (r3 == 0) goto L_0x00b9
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_5.IRadio r3 = android.hardware.radio.V1_5.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioProxy = r3     // Catch:{ RemoteException -> 0x0163 }
            com.android.internal.telephony.HalVersion r3 = RADIO_HAL_VERSION_1_5     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioVersion = r3     // Catch:{ RemoteException -> 0x0163 }
            goto L_0x010c
        L_0x00b9:
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_4.IRadio r3 = android.hardware.radio.V1_4.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            if (r3 == 0) goto L_0x00ce
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_4.IRadio r3 = android.hardware.radio.V1_4.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioProxy = r3     // Catch:{ RemoteException -> 0x0163 }
            com.android.internal.telephony.HalVersion r3 = RADIO_HAL_VERSION_1_4     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioVersion = r3     // Catch:{ RemoteException -> 0x0163 }
            goto L_0x010c
        L_0x00ce:
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_3.IRadio r3 = android.hardware.radio.V1_3.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            if (r3 == 0) goto L_0x00e3
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_3.IRadio r3 = android.hardware.radio.V1_3.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioProxy = r3     // Catch:{ RemoteException -> 0x0163 }
            com.android.internal.telephony.HalVersion r3 = RADIO_HAL_VERSION_1_3     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioVersion = r3     // Catch:{ RemoteException -> 0x0163 }
            goto L_0x010c
        L_0x00e3:
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_2.IRadio r3 = android.hardware.radio.V1_2.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            if (r3 == 0) goto L_0x00f8
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_2.IRadio r3 = android.hardware.radio.V1_2.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioProxy = r3     // Catch:{ RemoteException -> 0x0163 }
            com.android.internal.telephony.HalVersion r3 = RADIO_HAL_VERSION_1_2     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioVersion = r3     // Catch:{ RemoteException -> 0x0163 }
            goto L_0x010c
        L_0x00f8:
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_1.IRadio r3 = android.hardware.radio.V1_1.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            if (r3 == 0) goto L_0x010c
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_1.IRadio r3 = android.hardware.radio.V1_1.IRadio.castFrom(r3)     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioProxy = r3     // Catch:{ RemoteException -> 0x0163 }
            com.android.internal.telephony.HalVersion r3 = RADIO_HAL_VERSION_1_1     // Catch:{ RemoteException -> 0x0163 }
            r7.mRadioVersion = r3     // Catch:{ RemoteException -> 0x0163 }
        L_0x010c:
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x0163 }
            r3.<init>()     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String r4 = "getRadioProxy: mRadioVersion "
            r3.append(r4)     // Catch:{ RemoteException -> 0x0163 }
            com.android.internal.telephony.HalVersion r4 = r7.mRadioVersion     // Catch:{ RemoteException -> 0x0163 }
            r3.append(r4)     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String r3 = r3.toString()     // Catch:{ RemoteException -> 0x0163 }
            r7.riljLoge(r3)     // Catch:{ RemoteException -> 0x0163 }
            boolean r3 = r7.mIsRadioProxyInitialized     // Catch:{ RemoteException -> 0x0163 }
            if (r3 != 0) goto L_0x017a
            r7.mIsRadioProxyInitialized = r2     // Catch:{ RemoteException -> 0x0163 }
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ RemoteException -> 0x0163 }
            com.android.internal.telephony.RIL$RadioProxyDeathRecipient r4 = r7.mRadioProxyDeathRecipient     // Catch:{ RemoteException -> 0x0163 }
            android.util.SparseArray<java.util.concurrent.atomic.AtomicLong> r5 = r7.mServiceCookies     // Catch:{ RemoteException -> 0x0163 }
            java.lang.Object r5 = r5.get(r0)     // Catch:{ RemoteException -> 0x0163 }
            java.util.concurrent.atomic.AtomicLong r5 = (java.util.concurrent.atomic.AtomicLong) r5     // Catch:{ RemoteException -> 0x0163 }
            long r5 = r5.incrementAndGet()     // Catch:{ RemoteException -> 0x0163 }
            r3.linkToDeath(r4, r5)     // Catch:{ RemoteException -> 0x0163 }
            r7.setResponseFunctions()     // Catch:{ RemoteException -> 0x0163 }
            goto L_0x017a
        L_0x013f:
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x0163 }
            r3.<init>()     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String r4 = "getRadioProxy: set mRadioProxy for "
            r3.append(r4)     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String[] r4 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x0163 }
            java.lang.Integer r5 = r7.mPhoneId     // Catch:{ RemoteException -> 0x0163 }
            int r5 = r5.intValue()     // Catch:{ RemoteException -> 0x0163 }
            r4 = r4[r5]     // Catch:{ RemoteException -> 0x0163 }
            r3.append(r4)     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String r4 = " as disabled"
            r3.append(r4)     // Catch:{ RemoteException -> 0x0163 }
            java.lang.String r3 = r3.toString()     // Catch:{ RemoteException -> 0x0163 }
            r7.riljLoge(r3)     // Catch:{ RemoteException -> 0x0163 }
            goto L_0x017a
        L_0x0163:
            r3 = move-exception
            r7.mRadioProxy = r1     // Catch:{ all -> 0x01c4 }
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x01c4 }
            r4.<init>()     // Catch:{ all -> 0x01c4 }
            java.lang.String r5 = "RadioProxy getService/setResponseFunctions: "
            r4.append(r5)     // Catch:{ all -> 0x01c4 }
            r4.append(r3)     // Catch:{ all -> 0x01c4 }
            java.lang.String r3 = r4.toString()     // Catch:{ all -> 0x01c4 }
            r7.riljLoge(r3)     // Catch:{ all -> 0x01c4 }
        L_0x017a:
            android.hardware.radio.V1_0.IRadio r3 = r7.mRadioProxy     // Catch:{ all -> 0x01c4 }
            if (r3 != 0) goto L_0x01c0
            java.lang.String r3 = "getRadioProxy: mRadioProxy == null"
            r7.riljLoge(r3)     // Catch:{ all -> 0x01c4 }
            if (r8 == 0) goto L_0x018f
            com.android.internal.telephony.CommandException r3 = com.android.internal.telephony.CommandException.fromRilErrno(r2)     // Catch:{ all -> 0x01c4 }
            android.os.AsyncResult.forMessage(r8, r1, r3)     // Catch:{ all -> 0x01c4 }
            r8.sendToTarget()     // Catch:{ all -> 0x01c4 }
        L_0x018f:
            android.util.SparseArray<java.util.Set<java.lang.Integer>> r8 = r7.mDisabledRadioServices     // Catch:{ all -> 0x01c4 }
            java.lang.Object r8 = r8.get(r0)     // Catch:{ all -> 0x01c4 }
            java.util.Set r8 = (java.util.Set) r8     // Catch:{ all -> 0x01c4 }
            java.lang.Integer r1 = r7.mPhoneId     // Catch:{ all -> 0x01c4 }
            boolean r8 = r8.contains(r1)     // Catch:{ all -> 0x01c4 }
            if (r8 == r2) goto L_0x01c0
            com.android.internal.telephony.RIL$RilHandler r8 = r7.mRilHandler     // Catch:{ all -> 0x01c4 }
            r1 = 6
            r8.removeMessages(r1)     // Catch:{ all -> 0x01c4 }
            com.android.internal.telephony.RIL$RilHandler r8 = r7.mRilHandler     // Catch:{ all -> 0x01c4 }
            android.util.SparseArray<java.util.concurrent.atomic.AtomicLong> r2 = r7.mServiceCookies     // Catch:{ all -> 0x01c4 }
            java.lang.Object r2 = r2.get(r0)     // Catch:{ all -> 0x01c4 }
            java.util.concurrent.atomic.AtomicLong r2 = (java.util.concurrent.atomic.AtomicLong) r2     // Catch:{ all -> 0x01c4 }
            long r2 = r2.get()     // Catch:{ all -> 0x01c4 }
            java.lang.Long r2 = java.lang.Long.valueOf(r2)     // Catch:{ all -> 0x01c4 }
            android.os.Message r0 = r8.obtainMessage(r1, r0, r0, r2)     // Catch:{ all -> 0x01c4 }
            r1 = 1000(0x3e8, double:4.94E-321)
            r8.sendMessageDelayed(r0, r1)     // Catch:{ all -> 0x01c4 }
        L_0x01c0:
            android.hardware.radio.V1_0.IRadio r8 = r7.mRadioProxy     // Catch:{ all -> 0x01c4 }
            monitor-exit(r7)
            return r8
        L_0x01c4:
            r8 = move-exception
            monitor-exit(r7)
            throw r8
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RIL.getRadioProxy(android.os.Message):android.hardware.radio.V1_0.IRadio");
    }

    public <T extends RadioServiceProxy> T getRadioServiceProxy(Class<T> cls, Message message) {
        if (cls == RadioDataProxy.class) {
            return getRadioServiceProxy(1, message);
        }
        if (cls == RadioMessagingProxy.class) {
            return getRadioServiceProxy(2, message);
        }
        if (cls == RadioModemProxy.class) {
            return getRadioServiceProxy(3, message);
        }
        if (cls == RadioNetworkProxy.class) {
            return getRadioServiceProxy(4, message);
        }
        if (cls == RadioSimProxy.class) {
            return getRadioServiceProxy(5, message);
        }
        if (cls == RadioVoiceProxy.class) {
            return getRadioServiceProxy(6, message);
        }
        riljLoge("getRadioServiceProxy: unrecognized " + cls);
        return null;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:123:0x0415, code lost:
        return r0;
     */
    @com.android.internal.annotations.VisibleForTesting
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized com.android.internal.telephony.RadioServiceProxy getRadioServiceProxy(int r12, android.os.Message r13) {
        /*
            r11 = this;
            monitor-enter(r11)
            java.lang.Integer r0 = r11.mPhoneId     // Catch:{ all -> 0x0416 }
            int r0 = r0.intValue()     // Catch:{ all -> 0x0416 }
            boolean r0 = android.telephony.SubscriptionManager.isValidPhoneId(r0)     // Catch:{ all -> 0x0416 }
            if (r0 != 0) goto L_0x0017
            android.util.SparseArray<com.android.internal.telephony.RadioServiceProxy> r13 = r11.mServiceProxies     // Catch:{ all -> 0x0416 }
            java.lang.Object r12 = r13.get(r12)     // Catch:{ all -> 0x0416 }
            com.android.internal.telephony.RadioServiceProxy r12 = (com.android.internal.telephony.RadioServiceProxy) r12     // Catch:{ all -> 0x0416 }
            monitor-exit(r11)
            return r12
        L_0x0017:
            boolean r0 = r11.mIsCellularSupported     // Catch:{ all -> 0x0416 }
            r1 = 0
            r2 = 1
            if (r0 != 0) goto L_0x0033
            if (r13 == 0) goto L_0x0029
            com.android.internal.telephony.CommandException r0 = com.android.internal.telephony.CommandException.fromRilErrno(r2)     // Catch:{ all -> 0x0416 }
            android.os.AsyncResult.forMessage(r13, r1, r0)     // Catch:{ all -> 0x0416 }
            r13.sendToTarget()     // Catch:{ all -> 0x0416 }
        L_0x0029:
            android.util.SparseArray<com.android.internal.telephony.RadioServiceProxy> r13 = r11.mServiceProxies     // Catch:{ all -> 0x0416 }
            java.lang.Object r12 = r13.get(r12)     // Catch:{ all -> 0x0416 }
            com.android.internal.telephony.RadioServiceProxy r12 = (com.android.internal.telephony.RadioServiceProxy) r12     // Catch:{ all -> 0x0416 }
            monitor-exit(r11)
            return r12
        L_0x0033:
            android.util.SparseArray<com.android.internal.telephony.RadioServiceProxy> r0 = r11.mServiceProxies     // Catch:{ all -> 0x0416 }
            java.lang.Object r0 = r0.get(r12)     // Catch:{ all -> 0x0416 }
            com.android.internal.telephony.RadioServiceProxy r0 = (com.android.internal.telephony.RadioServiceProxy) r0     // Catch:{ all -> 0x0416 }
            boolean r3 = r0.isEmpty()     // Catch:{ all -> 0x0416 }
            if (r3 != 0) goto L_0x0043
            monitor-exit(r11)
            return r0
        L_0x0043:
            android.util.SparseArray<java.util.Set<java.lang.Integer>> r3 = r11.mDisabledRadioServices     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Object r3 = r3.get(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.util.Set r3 = (java.util.Set) r3     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r4 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            boolean r3 = r3.contains(r4)     // Catch:{ RemoteException -> 0x03e5 }
            if (r3 == 0) goto L_0x0084
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r3.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r4 = "getRadioServiceProxy: "
            r3.append(r4)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r12 = serviceToString(r12)     // Catch:{ RemoteException -> 0x03e5 }
            r3.append(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r12 = " for "
            r3.append(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String[] r12 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r4 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            int r4 = r4.intValue()     // Catch:{ RemoteException -> 0x03e5 }
            r12 = r12[r4]     // Catch:{ RemoteException -> 0x03e5 }
            r3.append(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r12 = " is disabled"
            r3.append(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r12 = r3.toString()     // Catch:{ RemoteException -> 0x03e5 }
            r11.riljLoge(r12)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x0084:
            r3 = 6
            r4 = 5
            r5 = 4
            r6 = 3
            r7 = 2
            switch(r12) {
                case 1: goto L_0x01c8;
                case 2: goto L_0x018a;
                case 3: goto L_0x014b;
                case 4: goto L_0x010c;
                case 5: goto L_0x00cd;
                case 6: goto L_0x008e;
                default: goto L_0x008c;
            }     // Catch:{ RemoteException -> 0x03e5 }
        L_0x008c:
            goto L_0x0205
        L_0x008e:
            com.android.internal.telephony.MockModem r8 = r11.mMockModem     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 != 0) goto L_0x00b7
            java.lang.StringBuilder r8 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r8.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = android.hardware.radio.voice.IRadioVoice.DESCRIPTOR     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = "/"
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String[] r9 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r10 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            int r10 = r10.intValue()     // Catch:{ RemoteException -> 0x03e5 }
            r9 = r9[r10]     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r8 = r8.toString()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r8 = android.os.ServiceManager.waitForDeclaredService(r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x00bb
        L_0x00b7:
            android.os.IBinder r8 = r8.getServiceBinder(r3)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x00bb:
            if (r8 == 0) goto L_0x0205
            com.android.internal.telephony.HalVersion r9 = RADIO_HAL_VERSION_2_0     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r9     // Catch:{ RemoteException -> 0x03e5 }
            r10 = r0
            com.android.internal.telephony.RadioVoiceProxy r10 = (com.android.internal.telephony.RadioVoiceProxy) r10     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.voice.IRadioVoice r8 = android.hardware.radio.voice.IRadioVoice.Stub.asInterface(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r10.setAidl(r9, r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x0205
        L_0x00cd:
            com.android.internal.telephony.MockModem r8 = r11.mMockModem     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 != 0) goto L_0x00f6
            java.lang.StringBuilder r8 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r8.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = android.hardware.radio.sim.IRadioSim.DESCRIPTOR     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = "/"
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String[] r9 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r10 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            int r10 = r10.intValue()     // Catch:{ RemoteException -> 0x03e5 }
            r9 = r9[r10]     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r8 = r8.toString()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r8 = android.os.ServiceManager.waitForDeclaredService(r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x00fa
        L_0x00f6:
            android.os.IBinder r8 = r8.getServiceBinder(r4)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x00fa:
            if (r8 == 0) goto L_0x0205
            com.android.internal.telephony.HalVersion r9 = RADIO_HAL_VERSION_2_0     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r9     // Catch:{ RemoteException -> 0x03e5 }
            r10 = r0
            com.android.internal.telephony.RadioSimProxy r10 = (com.android.internal.telephony.RadioSimProxy) r10     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.sim.IRadioSim r8 = android.hardware.radio.sim.IRadioSim.Stub.asInterface(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r10.setAidl(r9, r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x0205
        L_0x010c:
            com.android.internal.telephony.MockModem r8 = r11.mMockModem     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 != 0) goto L_0x0135
            java.lang.StringBuilder r8 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r8.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = android.hardware.radio.network.IRadioNetwork.DESCRIPTOR     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = "/"
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String[] r9 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r10 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            int r10 = r10.intValue()     // Catch:{ RemoteException -> 0x03e5 }
            r9 = r9[r10]     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r8 = r8.toString()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r8 = android.os.ServiceManager.waitForDeclaredService(r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x0139
        L_0x0135:
            android.os.IBinder r8 = r8.getServiceBinder(r5)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x0139:
            if (r8 == 0) goto L_0x0205
            com.android.internal.telephony.HalVersion r9 = RADIO_HAL_VERSION_2_0     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r9     // Catch:{ RemoteException -> 0x03e5 }
            r10 = r0
            com.android.internal.telephony.RadioNetworkProxy r10 = (com.android.internal.telephony.RadioNetworkProxy) r10     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.network.IRadioNetwork r8 = android.hardware.radio.network.IRadioNetwork.Stub.asInterface(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r10.setAidl(r9, r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x0205
        L_0x014b:
            com.android.internal.telephony.MockModem r8 = r11.mMockModem     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 != 0) goto L_0x0174
            java.lang.StringBuilder r8 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r8.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = android.hardware.radio.modem.IRadioModem.DESCRIPTOR     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = "/"
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String[] r9 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r10 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            int r10 = r10.intValue()     // Catch:{ RemoteException -> 0x03e5 }
            r9 = r9[r10]     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r8 = r8.toString()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r8 = android.os.ServiceManager.waitForDeclaredService(r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x0178
        L_0x0174:
            android.os.IBinder r8 = r8.getServiceBinder(r6)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x0178:
            if (r8 == 0) goto L_0x0205
            com.android.internal.telephony.HalVersion r9 = RADIO_HAL_VERSION_2_0     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r9     // Catch:{ RemoteException -> 0x03e5 }
            r10 = r0
            com.android.internal.telephony.RadioModemProxy r10 = (com.android.internal.telephony.RadioModemProxy) r10     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.modem.IRadioModem r8 = android.hardware.radio.modem.IRadioModem.Stub.asInterface(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r10.setAidl(r9, r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x0205
        L_0x018a:
            com.android.internal.telephony.MockModem r8 = r11.mMockModem     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 != 0) goto L_0x01b3
            java.lang.StringBuilder r8 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r8.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = android.hardware.radio.messaging.IRadioMessaging.DESCRIPTOR     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = "/"
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String[] r9 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r10 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            int r10 = r10.intValue()     // Catch:{ RemoteException -> 0x03e5 }
            r9 = r9[r10]     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r8 = r8.toString()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r8 = android.os.ServiceManager.waitForDeclaredService(r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x01b7
        L_0x01b3:
            android.os.IBinder r8 = r8.getServiceBinder(r7)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x01b7:
            if (r8 == 0) goto L_0x0205
            com.android.internal.telephony.HalVersion r9 = RADIO_HAL_VERSION_2_0     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r9     // Catch:{ RemoteException -> 0x03e5 }
            r10 = r0
            com.android.internal.telephony.RadioMessagingProxy r10 = (com.android.internal.telephony.RadioMessagingProxy) r10     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.messaging.IRadioMessaging r8 = android.hardware.radio.messaging.IRadioMessaging.Stub.asInterface(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r10.setAidl(r9, r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x0205
        L_0x01c8:
            com.android.internal.telephony.MockModem r8 = r11.mMockModem     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 != 0) goto L_0x01f1
            java.lang.StringBuilder r8 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r8.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = android.hardware.radio.data.IRadioData.DESCRIPTOR     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = "/"
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String[] r9 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r10 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            int r10 = r10.intValue()     // Catch:{ RemoteException -> 0x03e5 }
            r9 = r9[r10]     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r8 = r8.toString()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r8 = android.os.ServiceManager.waitForDeclaredService(r8)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x01f5
        L_0x01f1:
            android.os.IBinder r8 = r8.getServiceBinder(r2)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x01f5:
            if (r8 == 0) goto L_0x0205
            com.android.internal.telephony.HalVersion r9 = RADIO_HAL_VERSION_2_0     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r9     // Catch:{ RemoteException -> 0x03e5 }
            r10 = r0
            com.android.internal.telephony.RadioDataProxy r10 = (com.android.internal.telephony.RadioDataProxy) r10     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.data.IRadioData r8 = android.hardware.radio.data.IRadioData.Stub.asInterface(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r10.setAidl(r9, r8)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x0205:
            boolean r8 = r0.isEmpty()     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x02d1
            com.android.internal.telephony.HalVersion r8 = r11.mRadioVersion     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r9 = RADIO_HAL_VERSION_2_0     // Catch:{ RemoteException -> 0x03e5 }
            boolean r8 = r8.less(r9)     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x02d1
            java.lang.String[] r8 = HIDL_SERVICE_NAME     // Catch:{ NoSuchElementException -> 0x022e }
            java.lang.Integer r9 = r11.mPhoneId     // Catch:{ NoSuchElementException -> 0x022e }
            int r9 = r9.intValue()     // Catch:{ NoSuchElementException -> 0x022e }
            r8 = r8[r9]     // Catch:{ NoSuchElementException -> 0x022e }
            boolean r9 = r11.isGetHidlServiceSync()     // Catch:{ NoSuchElementException -> 0x022e }
            android.hardware.radio.V1_0.IRadio r8 = android.hardware.radio.V1_0.IRadio.getService(r8, r9)     // Catch:{ NoSuchElementException -> 0x022e }
            r11.mRadioProxy = r8     // Catch:{ NoSuchElementException -> 0x022e }
            com.android.internal.telephony.HalVersion r8 = RADIO_HAL_VERSION_1_0     // Catch:{ NoSuchElementException -> 0x022e }
            r11.mRadioVersion = r8     // Catch:{ NoSuchElementException -> 0x022e }
            goto L_0x0233
        L_0x022e:
            java.lang.String r8 = "getRadioProxy: NoSuchElementException "
            r11.riljLoge(r8)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x0233:
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x02d1
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_6.IRadio r8 = android.hardware.radio.V1_6.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x024c
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_6.IRadio r8 = android.hardware.radio.V1_6.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioProxy = r8     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r8 = RADIO_HAL_VERSION_1_6     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r8     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x02b4
        L_0x024c:
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_5.IRadio r8 = android.hardware.radio.V1_5.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x0261
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_5.IRadio r8 = android.hardware.radio.V1_5.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioProxy = r8     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r8 = RADIO_HAL_VERSION_1_5     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r8     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x02b4
        L_0x0261:
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_4.IRadio r8 = android.hardware.radio.V1_4.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x0276
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_4.IRadio r8 = android.hardware.radio.V1_4.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioProxy = r8     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r8 = RADIO_HAL_VERSION_1_4     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r8     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x02b4
        L_0x0276:
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_3.IRadio r8 = android.hardware.radio.V1_3.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x028b
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_3.IRadio r8 = android.hardware.radio.V1_3.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioProxy = r8     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r8 = RADIO_HAL_VERSION_1_3     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r8     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x02b4
        L_0x028b:
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_2.IRadio r8 = android.hardware.radio.V1_2.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x02a0
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_2.IRadio r8 = android.hardware.radio.V1_2.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioProxy = r8     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r8 = RADIO_HAL_VERSION_1_2     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r8     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x02b4
        L_0x02a0:
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_1.IRadio r8 = android.hardware.radio.V1_1.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x02b4
            android.hardware.radio.V1_0.IRadio r8 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_1.IRadio r8 = android.hardware.radio.V1_1.IRadio.castFrom(r8)     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioProxy = r8     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r8 = RADIO_HAL_VERSION_1_1     // Catch:{ RemoteException -> 0x03e5 }
            r11.mRadioVersion = r8     // Catch:{ RemoteException -> 0x03e5 }
        L_0x02b4:
            com.android.internal.telephony.HalVersion r8 = r11.mRadioVersion     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_0.IRadio r9 = r11.mRadioProxy     // Catch:{ RemoteException -> 0x03e5 }
            r0.setHidl(r8, r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.StringBuilder r8 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r8.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r9 = "getRadioProxy: mRadioVersion "
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r9 = r11.mRadioVersion     // Catch:{ RemoteException -> 0x03e5 }
            r8.append(r9)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r8 = r8.toString()     // Catch:{ RemoteException -> 0x03e5 }
            r11.riljLoge(r8)     // Catch:{ RemoteException -> 0x03e5 }
        L_0x02d1:
            boolean r8 = r0.isEmpty()     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 != 0) goto L_0x03b5
            boolean r8 = r0.isAidl()     // Catch:{ RemoteException -> 0x03e5 }
            if (r8 == 0) goto L_0x0384
            switch(r12) {
                case 1: goto L_0x0369;
                case 2: goto L_0x034e;
                case 3: goto L_0x0333;
                case 4: goto L_0x0318;
                case 5: goto L_0x02fd;
                case 6: goto L_0x02e2;
                default: goto L_0x02e0;
            }     // Catch:{ RemoteException -> 0x03e5 }
        L_0x02e0:
            goto L_0x03fd
        L_0x02e2:
            android.util.SparseArray<com.android.internal.telephony.RIL$BinderServiceDeathRecipient> r4 = r11.mDeathRecipients     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Object r12 = r4.get(r12)     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.RIL$BinderServiceDeathRecipient r12 = (com.android.internal.telephony.RIL.BinderServiceDeathRecipient) r12     // Catch:{ RemoteException -> 0x03e5 }
            r4 = r0
            com.android.internal.telephony.RadioVoiceProxy r4 = (com.android.internal.telephony.RadioVoiceProxy) r4     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.voice.IRadioVoice r4 = r4.getAidl()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r4 = r4.asBinder()     // Catch:{ RemoteException -> 0x03e5 }
            r12.linkToDeath(r4)     // Catch:{ RemoteException -> 0x03e5 }
            r11.setServiceResponseFunctions(r3)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x02fd:
            android.util.SparseArray<com.android.internal.telephony.RIL$BinderServiceDeathRecipient> r3 = r11.mDeathRecipients     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Object r12 = r3.get(r12)     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.RIL$BinderServiceDeathRecipient r12 = (com.android.internal.telephony.RIL.BinderServiceDeathRecipient) r12     // Catch:{ RemoteException -> 0x03e5 }
            r3 = r0
            com.android.internal.telephony.RadioSimProxy r3 = (com.android.internal.telephony.RadioSimProxy) r3     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.sim.IRadioSim r3 = r3.getAidl()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r3 = r3.asBinder()     // Catch:{ RemoteException -> 0x03e5 }
            r12.linkToDeath(r3)     // Catch:{ RemoteException -> 0x03e5 }
            r11.setServiceResponseFunctions(r4)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x0318:
            android.util.SparseArray<com.android.internal.telephony.RIL$BinderServiceDeathRecipient> r3 = r11.mDeathRecipients     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Object r12 = r3.get(r12)     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.RIL$BinderServiceDeathRecipient r12 = (com.android.internal.telephony.RIL.BinderServiceDeathRecipient) r12     // Catch:{ RemoteException -> 0x03e5 }
            r3 = r0
            com.android.internal.telephony.RadioNetworkProxy r3 = (com.android.internal.telephony.RadioNetworkProxy) r3     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.network.IRadioNetwork r3 = r3.getAidl()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r3 = r3.asBinder()     // Catch:{ RemoteException -> 0x03e5 }
            r12.linkToDeath(r3)     // Catch:{ RemoteException -> 0x03e5 }
            r11.setServiceResponseFunctions(r5)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x0333:
            android.util.SparseArray<com.android.internal.telephony.RIL$BinderServiceDeathRecipient> r3 = r11.mDeathRecipients     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Object r12 = r3.get(r12)     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.RIL$BinderServiceDeathRecipient r12 = (com.android.internal.telephony.RIL.BinderServiceDeathRecipient) r12     // Catch:{ RemoteException -> 0x03e5 }
            r3 = r0
            com.android.internal.telephony.RadioModemProxy r3 = (com.android.internal.telephony.RadioModemProxy) r3     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.modem.IRadioModem r3 = r3.getAidl()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r3 = r3.asBinder()     // Catch:{ RemoteException -> 0x03e5 }
            r12.linkToDeath(r3)     // Catch:{ RemoteException -> 0x03e5 }
            r11.setServiceResponseFunctions(r6)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x034e:
            android.util.SparseArray<com.android.internal.telephony.RIL$BinderServiceDeathRecipient> r3 = r11.mDeathRecipients     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Object r12 = r3.get(r12)     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.RIL$BinderServiceDeathRecipient r12 = (com.android.internal.telephony.RIL.BinderServiceDeathRecipient) r12     // Catch:{ RemoteException -> 0x03e5 }
            r3 = r0
            com.android.internal.telephony.RadioMessagingProxy r3 = (com.android.internal.telephony.RadioMessagingProxy) r3     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.messaging.IRadioMessaging r3 = r3.getAidl()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r3 = r3.asBinder()     // Catch:{ RemoteException -> 0x03e5 }
            r12.linkToDeath(r3)     // Catch:{ RemoteException -> 0x03e5 }
            r11.setServiceResponseFunctions(r7)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x0369:
            android.util.SparseArray<com.android.internal.telephony.RIL$BinderServiceDeathRecipient> r3 = r11.mDeathRecipients     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Object r12 = r3.get(r12)     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.RIL$BinderServiceDeathRecipient r12 = (com.android.internal.telephony.RIL.BinderServiceDeathRecipient) r12     // Catch:{ RemoteException -> 0x03e5 }
            r3 = r0
            com.android.internal.telephony.RadioDataProxy r3 = (com.android.internal.telephony.RadioDataProxy) r3     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.data.IRadioData r3 = r3.getAidl()     // Catch:{ RemoteException -> 0x03e5 }
            android.os.IBinder r3 = r3.asBinder()     // Catch:{ RemoteException -> 0x03e5 }
            r12.linkToDeath(r3)     // Catch:{ RemoteException -> 0x03e5 }
            r11.setServiceResponseFunctions(r2)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x0384:
            com.android.internal.telephony.HalVersion r3 = r11.mRadioVersion     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.HalVersion r4 = RADIO_HAL_VERSION_2_0     // Catch:{ RemoteException -> 0x03e5 }
            boolean r3 = r3.greaterOrEqual(r4)     // Catch:{ RemoteException -> 0x03e5 }
            if (r3 != 0) goto L_0x03ad
            boolean r3 = r11.mIsRadioProxyInitialized     // Catch:{ RemoteException -> 0x03e5 }
            if (r3 != 0) goto L_0x03fd
            r11.mIsRadioProxyInitialized = r2     // Catch:{ RemoteException -> 0x03e5 }
            android.hardware.radio.V1_0.IRadio r3 = r0.getHidl()     // Catch:{ RemoteException -> 0x03e5 }
            com.android.internal.telephony.RIL$RadioProxyDeathRecipient r4 = r11.mRadioProxyDeathRecipient     // Catch:{ RemoteException -> 0x03e5 }
            android.util.SparseArray<java.util.concurrent.atomic.AtomicLong> r5 = r11.mServiceCookies     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Object r12 = r5.get(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.util.concurrent.atomic.AtomicLong r12 = (java.util.concurrent.atomic.AtomicLong) r12     // Catch:{ RemoteException -> 0x03e5 }
            long r5 = r12.incrementAndGet()     // Catch:{ RemoteException -> 0x03e5 }
            r3.linkToDeath(r4, r5)     // Catch:{ RemoteException -> 0x03e5 }
            r11.setResponseFunctions()     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x03ad:
            java.lang.AssertionError r12 = new java.lang.AssertionError     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r3 = "serviceProxy shouldn't be HIDL with HAL 2.0"
            r12.<init>(r3)     // Catch:{ RemoteException -> 0x03e5 }
            throw r12     // Catch:{ RemoteException -> 0x03e5 }
        L_0x03b5:
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ RemoteException -> 0x03e5 }
            r3.<init>()     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r4 = "getRadioServiceProxy: set "
            r3.append(r4)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r12 = serviceToString(r12)     // Catch:{ RemoteException -> 0x03e5 }
            r3.append(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r12 = " for "
            r3.append(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String[] r12 = HIDL_SERVICE_NAME     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.Integer r4 = r11.mPhoneId     // Catch:{ RemoteException -> 0x03e5 }
            int r4 = r4.intValue()     // Catch:{ RemoteException -> 0x03e5 }
            r12 = r12[r4]     // Catch:{ RemoteException -> 0x03e5 }
            r3.append(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r12 = " as disabled"
            r3.append(r12)     // Catch:{ RemoteException -> 0x03e5 }
            java.lang.String r12 = r3.toString()     // Catch:{ RemoteException -> 0x03e5 }
            r11.riljLoge(r12)     // Catch:{ RemoteException -> 0x03e5 }
            goto L_0x03fd
        L_0x03e5:
            r12 = move-exception
            r0.clear()     // Catch:{ all -> 0x0416 }
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x0416 }
            r3.<init>()     // Catch:{ all -> 0x0416 }
            java.lang.String r4 = "ServiceProxy getService/setResponseFunctions: "
            r3.append(r4)     // Catch:{ all -> 0x0416 }
            r3.append(r12)     // Catch:{ all -> 0x0416 }
            java.lang.String r12 = r3.toString()     // Catch:{ all -> 0x0416 }
            r11.riljLoge(r12)     // Catch:{ all -> 0x0416 }
        L_0x03fd:
            boolean r12 = r0.isEmpty()     // Catch:{ all -> 0x0416 }
            if (r12 == 0) goto L_0x0414
            java.lang.String r12 = "getRadioServiceProxy: serviceProxy == null"
            r11.riljLoge(r12)     // Catch:{ all -> 0x0416 }
            if (r13 == 0) goto L_0x0414
            com.android.internal.telephony.CommandException r12 = com.android.internal.telephony.CommandException.fromRilErrno(r2)     // Catch:{ all -> 0x0416 }
            android.os.AsyncResult.forMessage(r13, r1, r12)     // Catch:{ all -> 0x0416 }
            r13.sendToTarget()     // Catch:{ all -> 0x0416 }
        L_0x0414:
            monitor-exit(r11)
            return r0
        L_0x0416:
            r12 = move-exception
            monitor-exit(r11)
            throw r12
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RIL.getRadioServiceProxy(int, android.os.Message):com.android.internal.telephony.RadioServiceProxy");
    }

    public synchronized void onSlotActiveStatusChange(boolean z) {
        this.mIsRadioProxyInitialized = false;
        for (int i = 0; i <= 6; i++) {
            if (!z) {
                resetProxyAndRequestList(i);
            } else if (i == 0) {
                getRadioProxy((Message) null);
            } else {
                getRadioServiceProxy(i, (Message) null);
            }
        }
    }

    @VisibleForTesting
    public RIL() {
        super((Context) null);
        this.mClientWakelockTracker = new ClientWakelockTracker();
        this.mRadioVersion = RADIO_HAL_VERSION_UNKNOWN;
        this.mWlSequenceNum = 0;
        this.mAckWlSequenceNum = 0;
        this.mRequestList = new SparseArray<>();
        this.mLastRadioPowerResult = 0;
        this.mIsRadioProxyInitialized = false;
        this.mTestingEmergencyCall = new AtomicBoolean(false);
        this.mDisabledRadioServices = new SparseArray<>();
        this.mMetrics = TelephonyMetrics.getInstance();
        this.mRadioBugDetector = null;
        this.mRadioProxy = null;
        this.mServiceProxies = new SparseArray<>();
        this.mDeathRecipients = new SparseArray<>();
        this.mServiceCookies = new SparseArray<>();
        this.mCompatOverrides = new ConcurrentHashMap<>();
        this.mAckWakeLock = null;
        this.mWakeLock = null;
        this.mRadioProxyDeathRecipient = null;
        this.mRilHandler = null;
        this.mPhoneId = 0;
        this.mAckWakeLockTimeout = 0;
        this.mWakeLockTimeout = 0;
    }

    @UnsupportedAppUsage
    public RIL(Context context, int i, int i2) {
        this(context, i, i2, (Integer) null);
    }

    @UnsupportedAppUsage
    public RIL(Context context, int i, int i2, Integer num) {
        this(context, i, i2, num, (SparseArray<RadioServiceProxy>) null);
    }

    @VisibleForTesting
    public RIL(Context context, int i, int i2, Integer num, SparseArray<RadioServiceProxy> sparseArray) {
        super(context);
        int i3;
        this.mClientWakelockTracker = new ClientWakelockTracker();
        this.mRadioVersion = RADIO_HAL_VERSION_UNKNOWN;
        this.mWlSequenceNum = 0;
        this.mAckWlSequenceNum = 0;
        this.mRequestList = new SparseArray<>();
        this.mLastRadioPowerResult = 0;
        this.mIsRadioProxyInitialized = false;
        this.mTestingEmergencyCall = new AtomicBoolean(false);
        this.mDisabledRadioServices = new SparseArray<>();
        this.mMetrics = TelephonyMetrics.getInstance();
        this.mRadioBugDetector = null;
        this.mRadioProxy = null;
        this.mServiceProxies = new SparseArray<>();
        this.mDeathRecipients = new SparseArray<>();
        this.mServiceCookies = new SparseArray<>();
        this.mCompatOverrides = new ConcurrentHashMap<>();
        riljLog("RIL: init allowedNetworkTypes=" + i + " cdmaSubscription=" + i2 + ")");
        this.mContext = context;
        this.mCdmaSubscription = i2;
        this.mAllowedNetworkTypesBitmask = i;
        this.mPhoneType = 0;
        if (num == null) {
            i3 = 0;
        } else {
            i3 = num.intValue();
        }
        Integer valueOf = Integer.valueOf(i3);
        this.mPhoneId = valueOf;
        if (isRadioBugDetectionEnabled()) {
            this.mRadioBugDetector = new RadioBugDetector(context, valueOf.intValue());
        }
        try {
            if (isRadioVersion2_0()) {
                this.mRadioVersion = RADIO_HAL_VERSION_2_0;
            }
        } catch (SecurityException e) {
            if (sparseArray == null) {
                throw e;
            }
        }
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService("phone");
        this.mIsCellularSupported = telephonyManager.isVoiceCapable() || telephonyManager.isSmsCapable() || telephonyManager.isDataCapable();
        this.mRadioResponse = new RadioResponse(this);
        this.mRadioIndication = new RadioIndication(this);
        this.mDataResponse = new DataResponse(this);
        this.mDataIndication = new DataIndication(this);
        this.mMessagingResponse = new MessagingResponse(this);
        this.mMessagingIndication = new MessagingIndication(this);
        this.mModemResponse = new ModemResponse(this);
        this.mModemIndication = new ModemIndication(this);
        this.mNetworkResponse = new NetworkResponse(this);
        this.mNetworkIndication = new NetworkIndication(this);
        this.mSimResponse = new SimResponse(this);
        this.mSimIndication = new SimIndication(this);
        this.mVoiceResponse = new VoiceResponse(this);
        this.mVoiceIndication = new VoiceIndication(this);
        this.mRilHandler = new RilHandler();
        this.mRadioProxyDeathRecipient = new RadioProxyDeathRecipient();
        for (int i4 = 0; i4 <= 6; i4++) {
            if (i4 != 0) {
                this.mDeathRecipients.put(i4, new BinderServiceDeathRecipient(i4));
            }
            this.mDisabledRadioServices.put(i4, new HashSet());
            this.mServiceCookies.put(i4, new AtomicLong(0));
        }
        if (sparseArray == null) {
            this.mServiceProxies.put(1, new RadioDataProxy());
            this.mServiceProxies.put(2, new RadioMessagingProxy());
            this.mServiceProxies.put(3, new RadioModemProxy());
            this.mServiceProxies.put(4, new RadioNetworkProxy());
            this.mServiceProxies.put(5, new RadioSimProxy());
            this.mServiceProxies.put(6, new RadioVoiceProxy());
        } else {
            this.mServiceProxies = sparseArray;
        }
        PowerManager powerManager = (PowerManager) context.getSystemService(XmlTagConst.TAG_POWER);
        PowerManager.WakeLock newWakeLock = powerManager.newWakeLock(1, RILJ_WAKELOCK_TAG);
        this.mWakeLock = newWakeLock;
        newWakeLock.setReferenceCounted(false);
        PowerManager.WakeLock newWakeLock2 = powerManager.newWakeLock(1, RILJ_ACK_WAKELOCK_NAME);
        this.mAckWakeLock = newWakeLock2;
        newWakeLock2.setReferenceCounted(false);
        this.mWakeLockTimeout = TelephonyProperties.wake_lock_timeout().orElse(60000).intValue();
        this.mAckWakeLockTimeout = TelephonyProperties.wake_lock_timeout().orElse(200).intValue();
        this.mWakeLockCount = 0;
        this.mRILDefaultWorkSource = new WorkSource(context.getApplicationInfo().uid, context.getPackageName());
        this.mActiveWakelockWorkSource = new WorkSource();
        TelephonyDevController.getInstance();
        if (sparseArray == null) {
            TelephonyDevController.registerRIL(this);
        }
        for (int i5 = 0; i5 <= 6; i5++) {
            if (i5 == 0) {
                getRadioProxy((Message) null);
            } else if (sparseArray == null) {
                getRadioServiceProxy(i5, (Message) null);
            }
        }
        riljLog("Radio HAL version: " + this.mRadioVersion);
    }

    /* access modifiers changed from: protected */
    public boolean isRadioVersion2_0() {
        String[] strArr = {IRadioData.DESCRIPTOR, IRadioMessaging.DESCRIPTOR, IRadioModem.DESCRIPTOR, IRadioNetwork.DESCRIPTOR, IRadioSim.DESCRIPTOR, IRadioVoice.DESCRIPTOR};
        for (int i = 0; i < 6; i++) {
            if (ServiceManager.isDeclared(strArr[i] + '/' + HIDL_SERVICE_NAME[this.mPhoneId.intValue()])) {
                return true;
            }
        }
        return false;
    }

    private boolean isRadioBugDetectionEnabled() {
        return Settings.Global.getInt(this.mContext.getContentResolver(), "enable_radio_bug_detection", 1) != 0;
    }

    public void setOnNITZTime(Handler handler, int i, Object obj) {
        super.setOnNITZTime(handler, i, obj);
        if (this.mLastNITZTimeInfo != null) {
            this.mNITZTimeRegistrant.notifyRegistrant(new AsyncResult((Object) null, this.mLastNITZTimeInfo, (Throwable) null));
        }
    }

    private void addRequest(RILRequest rILRequest) {
        acquireWakeLock(rILRequest, 0);
        synchronized (this.mRequestList) {
            rILRequest.mStartTimeMs = SystemClock.elapsedRealtime();
            this.mRequestList.append(rILRequest.mSerial, rILRequest);
        }
    }

    /* access modifiers changed from: protected */
    public RILRequest obtainRequest(int i, Message message, WorkSource workSource) {
        RILRequest obtain = RILRequest.obtain(i, message, workSource);
        addRequest(obtain);
        return obtain;
    }

    /* access modifiers changed from: protected */
    public RILRequest obtainRequest(int i, Message message, WorkSource workSource, Object... objArr) {
        RILRequest obtain = RILRequest.obtain(i, message, workSource, objArr);
        addRequest(obtain);
        return obtain;
    }

    /* access modifiers changed from: protected */
    public void handleRadioProxyExceptionForRR(int i, String str, Exception exc) {
        riljLoge(str + ": " + exc);
        exc.printStackTrace();
        this.mIsRadioProxyInitialized = false;
        resetProxyAndRequestList(i);
    }

    public void getIccCardStatus(Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(1, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioSimProxy.getIccCardStatus(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "getIccCardStatus", e);
            }
        }
    }

    public void getIccSlotsStatus(Message message) {
        Rlog.d(RILJ_LOG_TAG, "getIccSlotsStatus: REQUEST_NOT_SUPPORTED");
        if (message != null) {
            AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
            message.sendToTarget();
        }
    }

    public void setLogicalToPhysicalSlotMapping(int[] iArr, Message message) {
        Rlog.d(RILJ_LOG_TAG, "setLogicalToPhysicalSlotMapping: REQUEST_NOT_SUPPORTED");
        if (message != null) {
            AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
            message.sendToTarget();
        }
    }

    public void supplyIccPin(String str, Message message) {
        supplyIccPinForApp(str, (String) null, message);
    }

    public void supplyIccPinForApp(String str, String str2, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(2, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " aid = " + str2);
            try {
                radioSimProxy.supplyIccPinForApp(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "supplyIccPinForApp", e);
            }
        }
    }

    public void supplyIccPuk(String str, String str2, Message message) {
        supplyIccPukForApp(str, str2, (String) null, message);
    }

    public void supplyIccPukForApp(String str, String str2, String str3, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(3, message, this.mRILDefaultWorkSource);
            String convertNullToEmptyString = RILUtils.convertNullToEmptyString(str);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " isPukEmpty = " + convertNullToEmptyString.isEmpty() + " aid = " + str3);
            try {
                radioSimProxy.supplyIccPukForApp(obtainRequest.mSerial, convertNullToEmptyString, RILUtils.convertNullToEmptyString(str2), RILUtils.convertNullToEmptyString(str3));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "supplyIccPukForApp", e);
            }
        }
    }

    public void supplyIccPin2(String str, Message message) {
        supplyIccPin2ForApp(str, (String) null, message);
    }

    public void supplyIccPin2ForApp(String str, String str2, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(4, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " aid = " + str2);
            try {
                radioSimProxy.supplyIccPin2ForApp(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "supplyIccPin2ForApp", e);
            }
        }
    }

    public void supplyIccPuk2(String str, String str2, Message message) {
        supplyIccPuk2ForApp(str, str2, (String) null, message);
    }

    public void supplyIccPuk2ForApp(String str, String str2, String str3, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(5, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " aid = " + str3);
            try {
                radioSimProxy.supplyIccPuk2ForApp(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2), RILUtils.convertNullToEmptyString(str3));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "supplyIccPuk2ForApp", e);
            }
        }
    }

    public void changeIccPin(String str, String str2, Message message) {
        changeIccPinForApp(str, str2, (String) null, message);
    }

    public void changeIccPinForApp(String str, String str2, String str3, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(6, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " oldPin = " + str + " newPin = " + str2 + " aid = " + str3);
            try {
                radioSimProxy.changeIccPinForApp(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2), RILUtils.convertNullToEmptyString(str3));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "changeIccPinForApp", e);
            }
        }
    }

    public void changeIccPin2(String str, String str2, Message message) {
        changeIccPin2ForApp(str, str2, (String) null, message);
    }

    public void changeIccPin2ForApp(String str, String str2, String str3, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(7, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " oldPin = " + str + " newPin = " + str2 + " aid = " + str3);
            try {
                radioSimProxy.changeIccPin2ForApp(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2), RILUtils.convertNullToEmptyString(str3));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "changeIccPin2ForApp", e);
            }
        }
    }

    public void supplyNetworkDepersonalization(String str, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(8, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " netpin = " + str);
            try {
                radioNetworkProxy.supplyNetworkDepersonalization(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "supplyNetworkDepersonalization", e);
            }
        }
    }

    public void supplySimDepersonalization(IccCardApplicationStatus.PersoSubState persoSubState, String str, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_5)) {
                RILRequest obtainRequest = obtainRequest(CommandsInterface.GSM_SMS_FAIL_CAUSE_USIM_APP_TOOLKIT_BUSY, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " controlKey = " + str + " persoType" + persoSubState);
                try {
                    radioSimProxy.supplySimDepersonalization(obtainRequest.mSerial, persoSubState, RILUtils.convertNullToEmptyString(str));
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(5, "supplySimDepersonalization", e);
                }
            } else if (IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_NETWORK == persoSubState) {
                supplyNetworkDepersonalization(str, message);
            } else {
                Rlog.d(RILJ_LOG_TAG, "supplySimDepersonalization: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void getCurrentCalls(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(9, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.getCurrentCalls(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getCurrentCalls", e);
            }
        }
    }

    public void dial(String str, boolean z, EmergencyNumber emergencyNumber, boolean z2, int i, Message message) {
        dial(str, z, emergencyNumber, z2, i, (UUSInfo) null, message);
    }

    public void enableModem(boolean z, Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_3)) {
                RILRequest obtainRequest = obtainRequest(146, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " enable = " + z);
                try {
                    radioModemProxy.enableModem(obtainRequest.mSerial, z);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(3, "enableModem", e);
                }
            } else if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void setSystemSelectionChannels(List<RadioAccessSpecifier> list, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_3)) {
                RILRequest obtainRequest = obtainRequest(210, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " setSystemSelectionChannels_1.3= " + list);
                try {
                    radioNetworkProxy.setSystemSelectionChannels(obtainRequest.mSerial, list);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "setSystemSelectionChannels", e);
                }
            } else if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void getSystemSelectionChannels(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(219, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " getSystemSelectionChannels");
                try {
                    radioNetworkProxy.getSystemSelectionChannels(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "getSystemSelectionChannels", e);
                }
            } else if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void getModemStatus(Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_3)) {
                RILRequest obtainRequest = obtainRequest(147, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioModemProxy.getModemStackStatus(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(3, "getModemStatus", e);
                }
            } else if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void dial(String str, boolean z, EmergencyNumber emergencyNumber, boolean z2, int i, UUSInfo uUSInfo, Message message) {
        if (!z || !this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_4) || emergencyNumber == null) {
            RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
            if (!radioVoiceProxy.isEmpty()) {
                RILRequest obtainRequest = obtainRequest(10, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioVoiceProxy.dial(obtainRequest.mSerial, str, i, uUSInfo);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(6, "dial", e);
                }
            }
        } else {
            emergencyDial(str, emergencyNumber, z2, i, uUSInfo, message);
        }
    }

    private void emergencyDial(String str, EmergencyNumber emergencyNumber, boolean z, int i, UUSInfo uUSInfo, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_4)) {
                RILRequest obtainRequest = obtainRequest(205, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioVoiceProxy.emergencyDial(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), emergencyNumber, z, i, uUSInfo);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(6, "emergencyDial", e);
                }
            } else {
                riljLoge("emergencyDial is not supported with 1.4 below IRadio");
            }
        }
    }

    public void getIMSI(Message message) {
        getIMSIForApp((String) null, message);
    }

    public void getIMSIForApp(String str, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(11, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + ">  " + RILUtils.requestToString(obtainRequest.mRequest) + " aid = " + str);
            try {
                radioSimProxy.getImsiForApp(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "getImsiForApp", e);
            }
        }
    }

    public void hangupConnection(int i, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(12, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " gsmIndex = " + i);
            try {
                radioVoiceProxy.hangup(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "hangup", e);
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void hangupWaitingOrBackground(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(13, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.hangupWaitingOrBackground(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "hangupWaitingOrBackground", e);
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void hangupForegroundResumeBackground(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(14, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.hangupForegroundResumeBackground(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "hangupForegroundResumeBackground", e);
            }
        }
    }

    public void switchWaitingOrHoldingAndActive(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(15, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.switchWaitingOrHoldingAndActive(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "switchWaitingOrHoldingAndActive", e);
            }
        }
    }

    public void conference(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(16, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.conference(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "conference", e);
            }
        }
    }

    public void rejectCall(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(17, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.rejectCall(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "rejectCall", e);
            }
        }
    }

    public void getLastCallFailCause(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(18, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.getLastCallFailCause(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getLastCallFailCause", e);
            }
        }
    }

    public void getSignalStrength(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(19, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getSignalStrength(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getSignalStrength", e);
            }
        }
    }

    public void getVoiceRegistrationState(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(20, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            HalVersion compatVersion = getCompatVersion(20);
            riljLog("getVoiceRegistrationState: overrideHalVersion=" + compatVersion);
            try {
                radioNetworkProxy.getVoiceRegistrationState(obtainRequest.mSerial, compatVersion);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getVoiceRegistrationState", e);
            }
        }
    }

    public void getDataRegistrationState(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(21, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            HalVersion compatVersion = getCompatVersion(21);
            riljLog("getDataRegistrationState: overrideHalVersion=" + compatVersion);
            try {
                radioNetworkProxy.getDataRegistrationState(obtainRequest.mSerial, compatVersion);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getDataRegistrationState", e);
            }
        }
    }

    public void getOperator(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(22, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getOperator(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getOperator", e);
            }
        }
    }

    @UnsupportedAppUsage
    public void setRadioPower(boolean z, boolean z2, boolean z3, Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(23, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " on = " + z + " forEmergencyCall= " + z2 + " preferredForEmergencyCall=" + z3);
            try {
                radioModemProxy.setRadioPower(obtainRequest.mSerial, z, z2, z3);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "setRadioPower", e);
            }
        }
    }

    public void sendDtmf(char c, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(24, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                int i = obtainRequest.mSerial;
                radioVoiceProxy.sendDtmf(i, c + "");
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "sendDtmf", e);
            }
        }
    }

    public void sendSMS(String str, String str2, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(25, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.sendSms(obtainRequest.mSerial, str, str2);
                this.mMetrics.writeRilSendSms(this.mPhoneId.intValue(), obtainRequest.mSerial, 1, 1, getOutgoingSmsMessageId(message));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "sendSMS", e);
            }
        }
    }

    public static long getOutgoingSmsMessageId(Message message) {
        if (message == null) {
            return 0;
        }
        Object obj = message.obj;
        if (!(obj instanceof SMSDispatcher.SmsTracker)) {
            return 0;
        }
        return ((SMSDispatcher.SmsTracker) obj).mMessageId;
    }

    public void sendSMSExpectMore(String str, String str2, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(26, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.sendSmsExpectMore(obtainRequest.mSerial, str, str2);
                this.mMetrics.writeRilSendSms(this.mPhoneId.intValue(), obtainRequest.mSerial, 1, 1, getOutgoingSmsMessageId(message));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "sendSMSExpectMore", e);
            }
        }
    }

    public void setupDataCall(int i, DataProfile dataProfile, boolean z, boolean z2, int i2, LinkProperties linkProperties, int i3, NetworkSliceInfo networkSliceInfo, TrafficDescriptor trafficDescriptor, boolean z3, Message message) {
        Message message2 = message;
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message2);
        if (!radioDataProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(27, message2, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + ",reason=" + RILUtils.setupDataReasonToString(i2) + ",accessNetworkType=" + AccessNetworkConstants.AccessNetworkType.toString(i) + ",dataProfile=" + dataProfile + ",isRoaming=" + z + ",allowRoaming=" + z2 + ",linkProperties=" + linkProperties + ",pduSessionId=" + i3 + ",sliceInfo=" + networkSliceInfo + ",trafficDescriptor=" + trafficDescriptor + ",matchAllRuleAllowed=" + z3);
            try {
                radioDataProxy.setupDataCall(obtainRequest.mSerial, this.mPhoneId.intValue(), i, dataProfile, z, z2, i2, linkProperties, i3, networkSliceInfo, trafficDescriptor, z3);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(1, "setupDataCall", e);
            }
        }
    }

    public void iccIO(int i, int i2, String str, int i3, int i4, int i5, String str2, String str3, Message message) {
        iccIOForApp(i, i2, str, i3, i4, i5, str2, str3, (String) null, message);
    }

    public void iccIOForApp(int i, int i2, String str, int i3, int i4, int i5, String str2, String str3, String str4, Message message) {
        Message message2 = message;
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message2);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(28, message2, this.mRILDefaultWorkSource);
            if (TelephonyUtils.IS_DEBUGGABLE) {
                riljLog(obtainRequest.serialString() + "> iccIO: " + RILUtils.requestToString(obtainRequest.mRequest) + " command = 0x" + Integer.toHexString(i) + " fileId = 0x" + Integer.toHexString(i2) + " path = " + str + " p1 = " + i3 + " p2 = " + i4 + " p3 =  data = " + str2 + " aid = " + str4);
            } else {
                String str5 = str;
                int i6 = i3;
                int i7 = i4;
                String str6 = str2;
                String str7 = str4;
                riljLog(obtainRequest.serialString() + "> iccIO: " + RILUtils.requestToString(obtainRequest.mRequest));
            }
            try {
                radioSimProxy.iccIoForApp(obtainRequest.mSerial, i, i2, RILUtils.convertNullToEmptyString(str), i3, i4, i5, RILUtils.convertNullToEmptyString(str2), RILUtils.convertNullToEmptyString(str3), RILUtils.convertNullToEmptyString(str4));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "iccIoForApp", e);
            }
        }
    }

    public void sendUSSD(String str, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(29, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " ussd = " + "*******");
            try {
                radioVoiceProxy.sendUssd(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "sendUssd", e);
            }
        }
    }

    public void cancelPendingUssd(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(30, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.cancelPendingUssd(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "cancelPendingUssd", e);
            }
        }
    }

    public void getCLIR(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(31, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.getClir(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getClir", e);
            }
        }
    }

    public void setCLIR(int i, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(32, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " clirMode = " + i);
            try {
                radioVoiceProxy.setClir(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "setClir", e);
            }
        }
    }

    public void queryCallForwardStatus(int i, int i2, String str, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(33, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " cfreason = " + i + " serviceClass = " + i2);
            try {
                radioVoiceProxy.getCallForwardStatus(obtainRequest.mSerial, i, i2, str);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getCallForwardStatus", e);
            }
        }
    }

    public void setCallForward(int i, int i2, int i3, String str, int i4, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(34, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " action = " + i + " cfReason = " + i2 + " serviceClass = " + i3 + " timeSeconds = " + i4);
            try {
                radioVoiceProxy.setCallForward(obtainRequest.mSerial, i, i2, i3, str, i4);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "setCallForward", e);
            }
        }
    }

    public void queryCallWaiting(int i, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(35, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " serviceClass = " + i);
            try {
                radioVoiceProxy.getCallWaiting(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getCallWaiting", e);
            }
        }
    }

    public void setCallWaiting(boolean z, int i, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(36, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " enable = " + z + " serviceClass = " + i);
            try {
                radioVoiceProxy.setCallWaiting(obtainRequest.mSerial, z, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "setCallWaiting", e);
            }
        }
    }

    public void acknowledgeLastIncomingGsmSms(boolean z, int i, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(37, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " success = " + z + " cause = " + i);
            try {
                radioMessagingProxy.acknowledgeLastIncomingGsmSms(obtainRequest.mSerial, z, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "acknowledgeLastIncomingGsmSms", e);
            }
        }
    }

    public void acceptCall(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(40, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.acceptCall(obtainRequest.mSerial);
                this.mMetrics.writeRilAnswer(this.mPhoneId.intValue(), obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "acceptCall", e);
            }
        }
    }

    public void deactivateDataCall(int i, int i2, Message message) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(41, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " cid = " + i + " reason = " + RILUtils.deactivateDataReasonToString(i2));
            try {
                radioDataProxy.deactivateDataCall(obtainRequest.mSerial, i, i2);
                this.mMetrics.writeRilDeactivateDataCall(this.mPhoneId.intValue(), obtainRequest.mSerial, i, i2);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(1, "deactivateDataCall", e);
            }
        }
    }

    public void queryFacilityLock(String str, String str2, int i, Message message) {
        queryFacilityLockForApp(str, str2, i, (String) null, message);
    }

    public void queryFacilityLockForApp(String str, String str2, int i, String str3, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(42, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " facility = " + str + " serviceClass = " + i + " appId = " + str3);
            try {
                radioSimProxy.getFacilityLockForApp(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2), i, RILUtils.convertNullToEmptyString(str3));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "getFacilityLockForApp", e);
            }
        }
    }

    public void setFacilityLock(String str, boolean z, String str2, int i, Message message) {
        setFacilityLockForApp(str, z, str2, i, (String) null, message);
    }

    public void setFacilityLockForApp(String str, boolean z, String str2, int i, String str3, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(43, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " facility = " + str + " lockstate = " + z + " serviceClass = " + i + " appId = " + str3);
            try {
                radioSimProxy.setFacilityLockForApp(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), z, RILUtils.convertNullToEmptyString(str2), i, RILUtils.convertNullToEmptyString(str3));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "setFacilityLockForApp", e);
            }
        }
    }

    public void changeBarringPassword(String str, String str2, String str3, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(44, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + "facility = " + str);
            try {
                radioNetworkProxy.setBarringPassword(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2), RILUtils.convertNullToEmptyString(str3));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "changeBarringPassword", e);
            }
        }
    }

    public void getNetworkSelectionMode(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(45, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getNetworkSelectionMode(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getNetworkSelectionMode", e);
            }
        }
    }

    public void setNetworkSelectionModeAutomatic(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(46, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.setNetworkSelectionModeAutomatic(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setNetworkSelectionModeAutomatic", e);
            }
        }
    }

    public void setNetworkSelectionModeManual(String str, int i, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(47, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " operatorNumeric = " + str + ", ran = " + i);
            try {
                radioNetworkProxy.setNetworkSelectionModeManual(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setNetworkSelectionModeManual", e);
            }
        }
    }

    public void getAvailableNetworks(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(48, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getAvailableNetworks(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getAvailableNetworks", e);
            }
        }
    }

    public void startNetworkScan(NetworkScanRequest networkScanRequest, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_1)) {
                HalVersion compatVersion = getCompatVersion(142);
                riljLog("startNetworkScan: overrideHalVersion=" + compatVersion);
                RILRequest obtainRequest = obtainRequest(142, message, this.mRILDefaultWorkSource, networkScanRequest);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioNetworkProxy.startNetworkScan(obtainRequest.mSerial, networkScanRequest, compatVersion, message);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "startNetworkScan", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "startNetworkScan: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void stopNetworkScan(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_1)) {
                RILRequest obtainRequest = obtainRequest(143, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioNetworkProxy.stopNetworkScan(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "stopNetworkScan", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "stopNetworkScan: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void startDtmf(char c, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(49, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                int i = obtainRequest.mSerial;
                radioVoiceProxy.startDtmf(i, c + "");
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "startDtmf", e);
            }
        }
    }

    public void stopDtmf(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(50, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.stopDtmf(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "stopDtmf", e);
            }
        }
    }

    public void separateConnection(int i, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(52, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " gsmIndex = " + i);
            try {
                radioVoiceProxy.separateConnection(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "separateConnection", e);
            }
        }
    }

    public void getBasebandVersion(Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(51, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioModemProxy.getBasebandVersion(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "getBasebandVersion", e);
            }
        }
    }

    public void setMute(boolean z, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(53, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " enableMute = " + z);
            try {
                radioVoiceProxy.setMute(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "setMute", e);
            }
        }
    }

    public void getMute(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(54, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.getMute(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getMute", e);
            }
        }
    }

    public void queryCLIP(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(55, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.getClip(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getClip", e);
            }
        }
    }

    @Deprecated
    public void getPDPContextList(Message message) {
        getDataCallList(message);
    }

    public void getDataCallList(Message message) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(57, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioDataProxy.getDataCallList(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(1, "getDataCallList", e);
            }
        }
    }

    public void setSuppServiceNotifications(boolean z, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(62, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " enable = " + z);
            try {
                radioNetworkProxy.setSuppServiceNotifications(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setSuppServiceNotifications", e);
            }
        }
    }

    public void writeSmsToSim(int i, String str, String str2, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            try {
                radioMessagingProxy.writeSmsToSim(obtainRequest(63, message, this.mRILDefaultWorkSource).mSerial, i, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "writeSmsToSim", e);
            }
        }
    }

    public void deleteSmsOnSim(int i, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            try {
                radioMessagingProxy.deleteSmsOnSim(obtainRequest(64, message, this.mRILDefaultWorkSource).mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "deleteSmsOnSim", e);
            }
        }
    }

    public void setBandMode(int i, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(65, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " bandMode = " + i);
            try {
                radioNetworkProxy.setBandMode(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setBandMode", e);
            }
        }
    }

    public void queryAvailableBandMode(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(66, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getAvailableBandModes(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "queryAvailableBandMode", e);
            }
        }
    }

    public void sendEnvelope(String str, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(69, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " contents = " + str);
            try {
                radioSimProxy.sendEnvelope(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "sendEnvelope", e);
            }
        }
    }

    public void sendTerminalResponse(String str, Message message) {
        String str2;
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(70, message, this.mRILDefaultWorkSource);
            StringBuilder sb = new StringBuilder();
            sb.append(obtainRequest.serialString());
            sb.append("> ");
            sb.append(RILUtils.requestToString(obtainRequest.mRequest));
            sb.append(" contents = ");
            if (TelephonyUtils.IS_DEBUGGABLE) {
                str2 = str;
            } else {
                str2 = RILUtils.convertToCensoredTerminalResponse(str);
            }
            sb.append(str2);
            riljLog(sb.toString());
            try {
                radioSimProxy.sendTerminalResponseToSim(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "sendTerminalResponse", e);
            }
        }
    }

    public void sendEnvelopeWithStatus(String str, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(107, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " contents = " + str);
            try {
                radioSimProxy.sendEnvelopeWithStatus(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "sendEnvelopeWithStatus", e);
            }
        }
    }

    public void explicitCallTransfer(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(72, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.explicitCallTransfer(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "explicitCallTransfer", e);
            }
        }
    }

    public void setPreferredNetworkType(int i, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(73, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " networkType = " + i);
            this.mAllowedNetworkTypesBitmask = RadioAccessFamily.getRafFromNetworkType(i);
            this.mMetrics.writeSetPreferredNetworkType(this.mPhoneId.intValue(), i);
            try {
                radioNetworkProxy.setPreferredNetworkTypeBitmap(obtainRequest.mSerial, this.mAllowedNetworkTypesBitmask);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setPreferredNetworkType", e);
            }
        }
    }

    public void getPreferredNetworkType(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(74, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getAllowedNetworkTypesBitmap(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getPreferredNetworkType", e);
            }
        }
    }

    public void setAllowedNetworkTypesBitmap(int i, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (radioNetworkProxy.isEmpty()) {
            return;
        }
        if (this.mRadioVersion.less(RADIO_HAL_VERSION_1_6)) {
            setPreferredNetworkType(RadioAccessFamily.getNetworkTypeFromRaf(i), message);
            return;
        }
        RILRequest obtainRequest = obtainRequest(222, message, this.mRILDefaultWorkSource);
        riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
        this.mAllowedNetworkTypesBitmask = i;
        try {
            radioNetworkProxy.setAllowedNetworkTypesBitmap(obtainRequest.mSerial, i);
        } catch (RemoteException | RuntimeException e) {
            handleRadioProxyExceptionForRR(4, "setAllowedNetworkTypeBitmask", e);
        }
    }

    public void getAllowedNetworkTypesBitmap(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(223, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getAllowedNetworkTypesBitmap(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getAllowedNetworkTypeBitmask", e);
            }
        }
    }

    public void setLocationUpdates(boolean z, WorkSource workSource, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(76, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " enable = " + z);
            try {
                radioNetworkProxy.setLocationUpdates(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setLocationUpdates", e);
            }
        }
    }

    public void isNrDualConnectivityEnabled(Message message, WorkSource workSource) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(BerTlv.BER_EVENT_DOWNLOAD_TAG, message, getDefaultWorkSourceIfInvalid(workSource));
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioNetworkProxy.isNrDualConnectivityEnabled(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "isNrDualConnectivityEnabled", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "isNrDualConnectivityEnabled: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void setNrDualConnectivityState(int i, Message message, WorkSource workSource) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(CommandsInterface.GSM_SMS_FAIL_CAUSE_USIM_DATA_DOWNLOAD_ERROR, message, getDefaultWorkSourceIfInvalid(workSource));
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " enable = " + i);
                try {
                    radioNetworkProxy.setNrDualConnectivityState(obtainRequest.mSerial, (byte) i);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "enableNrDualConnectivity", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "enableNrDualConnectivity: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    private void setVoNrEnabled(boolean z) {
        SystemProperties.set(PROPERTY_IS_VONR_ENABLED + this.mPhoneId, String.valueOf(z));
    }

    private boolean isVoNrEnabled() {
        return SystemProperties.getBoolean(PROPERTY_IS_VONR_ENABLED + this.mPhoneId, true);
    }

    public void isVoNrEnabled(Message message, WorkSource workSource) {
        if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_2_0)) {
            RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
            if (!radioVoiceProxy.isEmpty()) {
                RILRequest obtainRequest = obtainRequest(226, message, getDefaultWorkSourceIfInvalid(workSource));
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioVoiceProxy.isVoNrEnabled(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(6, "isVoNrEnabled", e);
                }
            }
        } else {
            boolean isVoNrEnabled = isVoNrEnabled();
            if (message != null) {
                AsyncResult.forMessage(message, Boolean.valueOf(isVoNrEnabled), (Throwable) null);
                message.sendToTarget();
            }
        }
    }

    public void setVoNrEnabled(boolean z, Message message, WorkSource workSource) {
        setVoNrEnabled(z);
        if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_2_0)) {
            RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
            if (!radioVoiceProxy.isEmpty()) {
                RILRequest obtainRequest = obtainRequest(225, message, getDefaultWorkSourceIfInvalid(workSource));
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioVoiceProxy.setVoNrEnabled(obtainRequest.mSerial, z);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(6, "setVoNrEnabled", e);
                }
            }
        } else {
            isNrDualConnectivityEnabled((Message) null, workSource);
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, (Throwable) null);
                message.sendToTarget();
            }
        }
    }

    public void setCdmaSubscriptionSource(int i, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(77, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " cdmaSubscription = " + i);
            try {
                radioSimProxy.setCdmaSubscriptionSource(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "setCdmaSubscriptionSource", e);
            }
        }
    }

    public void queryCdmaRoamingPreference(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(79, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getCdmaRoamingPreference(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "queryCdmaRoamingPreference", e);
            }
        }
    }

    public void setCdmaRoamingPreference(int i, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(78, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " cdmaRoamingType = " + i);
            try {
                radioNetworkProxy.setCdmaRoamingPreference(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setCdmaRoamingPreference", e);
            }
        }
    }

    public void queryTTYMode(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(81, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.getTtyMode(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getTtyMode", e);
            }
        }
    }

    public void setTTYMode(int i, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(80, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " ttyMode = " + i);
            try {
                radioVoiceProxy.setTtyMode(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "setTtyMode", e);
            }
        }
    }

    public void setPreferredVoicePrivacy(boolean z, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(82, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " enable = " + z);
            try {
                radioVoiceProxy.setPreferredVoicePrivacy(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "setPreferredVoicePrivacy", e);
            }
        }
    }

    public void getPreferredVoicePrivacy(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(83, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.getPreferredVoicePrivacy(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "getPreferredVoicePrivacy", e);
            }
        }
    }

    public void sendCDMAFeatureCode(String str, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(84, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " featureCode = " + Rlog.pii(RILJ_LOG_TAG, str));
            try {
                radioVoiceProxy.sendCdmaFeatureCode(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "sendCdmaFeatureCode", e);
            }
        }
    }

    public void sendBurstDtmf(String str, int i, int i2, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(85, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " dtmfString = " + str + " on = " + i + " off = " + i2);
            try {
                radioVoiceProxy.sendBurstDtmf(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), i, i2);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "sendBurstDtmf", e);
            }
        }
    }

    public void sendCdmaSMSExpectMore(byte[] bArr, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(148, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.sendCdmaSmsExpectMore(obtainRequest.mSerial, bArr);
                if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_5)) {
                    this.mMetrics.writeRilSendSms(this.mPhoneId.intValue(), obtainRequest.mSerial, 2, 2, getOutgoingSmsMessageId(message));
                }
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "sendCdmaSMSExpectMore", e);
            }
        }
    }

    public void sendCdmaSms(byte[] bArr, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(87, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.sendCdmaSms(obtainRequest.mSerial, bArr);
                this.mMetrics.writeRilSendSms(this.mPhoneId.intValue(), obtainRequest.mSerial, 2, 2, getOutgoingSmsMessageId(message));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "sendCdmaSms", e);
            }
        }
    }

    public void acknowledgeLastIncomingCdmaSms(boolean z, int i, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(88, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " success = " + z + " cause = " + i);
            try {
                radioMessagingProxy.acknowledgeLastIncomingCdmaSms(obtainRequest.mSerial, z, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "acknowledgeLastIncomingCdmaSms", e);
            }
        }
    }

    public void getGsmBroadcastConfig(Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(89, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.getGsmBroadcastConfig(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "getGsmBroadcastConfig", e);
            }
        }
    }

    public void setGsmBroadcastConfig(SmsBroadcastConfigInfo[] smsBroadcastConfigInfoArr, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(90, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " with " + smsBroadcastConfigInfoArr.length + " configs : ");
            for (SmsBroadcastConfigInfo smsBroadcastConfigInfo : smsBroadcastConfigInfoArr) {
                riljLog(smsBroadcastConfigInfo.toString());
            }
            try {
                radioMessagingProxy.setGsmBroadcastConfig(obtainRequest.mSerial, smsBroadcastConfigInfoArr);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "setGsmBroadcastConfig", e);
            }
        }
    }

    public void setGsmBroadcastActivation(boolean z, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(91, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " activate = " + z);
            try {
                radioMessagingProxy.setGsmBroadcastActivation(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "setGsmBroadcastActivation", e);
            }
        }
    }

    public void getCdmaBroadcastConfig(Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(92, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.getCdmaBroadcastConfig(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "getCdmaBroadcastConfig", e);
            }
        }
    }

    public void setCdmaBroadcastConfig(CdmaSmsBroadcastConfigInfo[] cdmaSmsBroadcastConfigInfoArr, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(93, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " with " + cdmaSmsBroadcastConfigInfoArr.length + " configs : ");
            for (CdmaSmsBroadcastConfigInfo cdmaSmsBroadcastConfigInfo : cdmaSmsBroadcastConfigInfoArr) {
                riljLog(cdmaSmsBroadcastConfigInfo.toString());
            }
            try {
                radioMessagingProxy.setCdmaBroadcastConfig(obtainRequest.mSerial, cdmaSmsBroadcastConfigInfoArr);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "setCdmaBroadcastConfig", e);
            }
        }
    }

    public void setCdmaBroadcastActivation(boolean z, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(94, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " activate = " + z);
            try {
                radioMessagingProxy.setCdmaBroadcastActivation(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "setCdmaBroadcastActivation", e);
            }
        }
    }

    public void getCDMASubscription(Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(95, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioSimProxy.getCdmaSubscription(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "getCdmaSubscription", e);
            }
        }
    }

    public void writeSmsToRuim(int i, byte[] bArr, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            try {
                radioMessagingProxy.writeSmsToRuim(obtainRequest(96, message, this.mRILDefaultWorkSource).mSerial, i, bArr);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "writeSmsToRuim", e);
            }
        }
    }

    public void deleteSmsOnRuim(int i, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            try {
                radioMessagingProxy.deleteSmsOnRuim(obtainRequest(97, message, this.mRILDefaultWorkSource).mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "deleteSmsOnRuim", e);
            }
        }
    }

    public void getDeviceIdentity(Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(98, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioModemProxy.getDeviceIdentity(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "getDeviceIdentity", e);
            }
        }
    }

    public void exitEmergencyCallbackMode(Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(99, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.exitEmergencyCallbackMode(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "exitEmergencyCallbackMode", e);
            }
        }
    }

    public void getSmscAddress(Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(100, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.getSmscAddress(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "getSmscAddress", e);
            }
        }
    }

    public void setSmscAddress(String str, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(101, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " address = " + str);
            try {
                radioMessagingProxy.setSmscAddress(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "setSmscAddress", e);
            }
        }
    }

    public void reportSmsMemoryStatus(boolean z, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(102, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " available = " + z);
            try {
                radioMessagingProxy.reportSmsMemoryStatus(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "reportSmsMemoryStatus", e);
            }
        }
    }

    public void reportStkServiceIsRunning(Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(103, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioSimProxy.reportStkServiceIsRunning(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "reportStkServiceIsRunning", e);
            }
        }
    }

    public void getCdmaSubscriptionSource(Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(104, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioSimProxy.getCdmaSubscriptionSource(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "getCdmaSubscriptionSource", e);
            }
        }
    }

    public void acknowledgeIncomingGsmSmsWithPdu(boolean z, String str, Message message) {
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(106, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " success = " + z);
            try {
                radioMessagingProxy.acknowledgeIncomingGsmSmsWithPdu(obtainRequest.mSerial, z, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "acknowledgeIncomingGsmSmsWithPdu", e);
            }
        }
    }

    public void getVoiceRadioTechnology(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(108, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getVoiceRadioTechnology(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getVoiceRadioTechnology", e);
            }
        }
    }

    public void getCellInfoList(Message message, WorkSource workSource) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(109, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getCellInfoList(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getCellInfoList", e);
            }
        }
    }

    public void setCellInfoListRate(int i, Message message, WorkSource workSource) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(110, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " rateInMillis = " + i);
            try {
                radioNetworkProxy.setCellInfoListRate(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setCellInfoListRate", e);
            }
        }
    }

    public void setInitialAttachApn(DataProfile dataProfile, boolean z, Message message) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(111, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + dataProfile);
            try {
                radioDataProxy.setInitialAttachApn(obtainRequest.mSerial, dataProfile, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(1, "setInitialAttachApn", e);
            }
        }
    }

    public void getImsRegistrationState(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(112, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioNetworkProxy.getImsRegistrationState(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "getImsRegistrationState", e);
            }
        }
    }

    public void sendImsGsmSms(String str, String str2, int i, int i2, Message message) {
        Message message2 = message;
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message2);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(113, message2, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.sendImsSms(obtainRequest.mSerial, str, str2, (byte[]) null, i, i2);
                this.mMetrics.writeRilSendSms(this.mPhoneId.intValue(), obtainRequest.mSerial, 3, 1, getOutgoingSmsMessageId(message));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "sendImsGsmSms", e);
            }
        }
    }

    public void sendImsCdmaSms(byte[] bArr, int i, int i2, Message message) {
        Message message2 = message;
        RadioMessagingProxy radioMessagingProxy = (RadioMessagingProxy) getRadioServiceProxy(RadioMessagingProxy.class, message2);
        if (!radioMessagingProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(113, message2, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioMessagingProxy.sendImsSms(obtainRequest.mSerial, (String) null, (String) null, bArr, i, i2);
                this.mMetrics.writeRilSendSms(this.mPhoneId.intValue(), obtainRequest.mSerial, 3, 2, getOutgoingSmsMessageId(message));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(2, "sendImsCdmaSms", e);
            }
        }
    }

    public void iccTransmitApduBasicChannel(int i, int i2, int i3, int i4, int i5, String str, Message message) {
        Message message2 = message;
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message2);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(114, message2, this.mRILDefaultWorkSource);
            if (TelephonyUtils.IS_DEBUGGABLE) {
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + String.format(" cla = 0x%02X ins = 0x%02X", new Object[]{Integer.valueOf(i), Integer.valueOf(i2)}) + String.format(" p1 = 0x%02X p2 = 0x%02X p3 = 0x%02X", new Object[]{Integer.valueOf(i3), Integer.valueOf(i4), Integer.valueOf(i5)}) + " data = " + str);
            } else {
                String str2 = str;
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            }
            try {
                radioSimProxy.iccTransmitApduBasicChannel(obtainRequest.mSerial, i, i2, i3, i4, i5, str);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "iccTransmitApduBasicChannel", e);
            }
        }
    }

    public void iccOpenLogicalChannel(String str, int i, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(115, message, this.mRILDefaultWorkSource);
            if (TelephonyUtils.IS_DEBUGGABLE) {
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " aid = " + str + " p2 = " + i);
            } else {
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            }
            try {
                radioSimProxy.iccOpenLogicalChannel(obtainRequest.mSerial, RILUtils.convertNullToEmptyString(str), i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "iccOpenLogicalChannel", e);
            }
        }
    }

    public void iccCloseLogicalChannel(int i, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(116, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " channel = " + i);
            try {
                radioSimProxy.iccCloseLogicalChannel(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "iccCloseLogicalChannel", e);
            }
        }
    }

    public void iccTransmitApduLogicalChannel(int i, int i2, int i3, int i4, int i5, int i6, String str, Message message) {
        Message message2 = message;
        if (i > 0) {
            RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message2);
            if (!radioSimProxy.isEmpty()) {
                RILRequest obtainRequest = obtainRequest(117, message2, this.mRILDefaultWorkSource);
                if (TelephonyUtils.IS_DEBUGGABLE) {
                    riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + String.format(" channel = %d", new Object[]{Integer.valueOf(i)}) + String.format(" cla = 0x%02X ins = 0x%02X", new Object[]{Integer.valueOf(i2), Integer.valueOf(i3)}) + String.format(" p1 = 0x%02X p2 = 0x%02X p3 = 0x%02X", new Object[]{Integer.valueOf(i4), Integer.valueOf(i5), Integer.valueOf(i6)}) + " data = " + str);
                } else {
                    String str2 = str;
                    riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                }
                try {
                    radioSimProxy.iccTransmitApduLogicalChannel(obtainRequest.mSerial, i, i2, i3, i4, i5, i6, str);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(5, "iccTransmitApduLogicalChannel", e);
                }
            }
        } else {
            throw new RuntimeException("Invalid channel in iccTransmitApduLogicalChannel: " + i);
        }
    }

    public void nvReadItem(int i, Message message, WorkSource workSource) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(118, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " itemId = " + i);
            try {
                radioModemProxy.nvReadItem(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "nvReadItem", e);
            }
        }
    }

    public void nvWriteItem(int i, String str, Message message, WorkSource workSource) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(119, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " itemId = " + i + " itemValue = " + str);
            try {
                radioModemProxy.nvWriteItem(obtainRequest.mSerial, i, RILUtils.convertNullToEmptyString(str));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "nvWriteItem", e);
            }
        }
    }

    public void nvWriteCdmaPrl(byte[] bArr, Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(120, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " PreferredRoamingList = 0x" + IccUtils.bytesToHexString(bArr));
            try {
                radioModemProxy.nvWriteCdmaPrl(obtainRequest.mSerial, bArr);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "nvWriteCdmaPrl", e);
            }
        }
    }

    public void nvResetConfig(int i, Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(121, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " resetType = " + i);
            try {
                radioModemProxy.nvResetConfig(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "nvResetConfig", e);
            }
        }
    }

    public void setUiccSubscription(int i, int i2, int i3, int i4, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(122, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " slot = " + i + " appIndex = " + i2 + " subId = " + i3 + " subStatus = " + i4);
            try {
                radioSimProxy.setUiccSubscription(obtainRequest.mSerial, i, i2, i3, i4);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "setUiccSubscription", e);
            }
        }
    }

    public boolean supportsEid() {
        return this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_2);
    }

    public void setDataAllowed(boolean z, Message message) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(123, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " allowed = " + z);
            try {
                radioDataProxy.setDataAllowed(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(1, "setDataAllowed", e);
            }
        }
    }

    public void getHardwareConfig(Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(124, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioModemProxy.getHardwareConfig(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "getHardwareConfig", e);
            }
        }
    }

    public void requestIccSimAuthentication(int i, String str, String str2, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(125, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioSimProxy.requestIccSimAuthentication(obtainRequest.mSerial, i, RILUtils.convertNullToEmptyString(str), RILUtils.convertNullToEmptyString(str2));
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "requestIccSimAuthentication", e);
            }
        }
    }

    public void setDataProfile(DataProfile[] dataProfileArr, boolean z, Message message) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(128, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " with data profiles : ");
            for (DataProfile dataProfile : dataProfileArr) {
                riljLog(dataProfile.toString());
            }
            try {
                radioDataProxy.setDataProfile(obtainRequest.mSerial, dataProfileArr, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(1, "setDataProfile", e);
            }
        }
    }

    public void requestShutdown(Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(129, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioModemProxy.requestShutdown(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "requestShutdown", e);
            }
        }
    }

    public void getRadioCapability(Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioModemProxy.getRadioCapability(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "getRadioCapability", e);
            }
        }
    }

    public void setRadioCapability(RadioCapability radioCapability, Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(InterPhoneService.MSG_UPDATE_ACTIVITY_DESTROY_2_SVC, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " RadioCapability = " + radioCapability.toString());
            try {
                radioModemProxy.setRadioCapability(obtainRequest.mSerial, radioCapability);
            } catch (Exception e) {
                handleRadioProxyExceptionForRR(3, "setRadioCapability", e);
            }
        }
    }

    public void startLceService(int i, boolean z, Message message) {
        if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_2)) {
            Rlog.d(RILJ_LOG_TAG, "startLceService: REQUEST_NOT_SUPPORTED");
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
                return;
            }
            return;
        }
        IRadio radioProxy = getRadioProxy(message);
        if (radioProxy != null) {
            RILRequest obtainRequest = obtainRequest(132, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " reportIntervalMs = " + i + " pullMode = " + z);
            try {
                radioProxy.startLceService(obtainRequest.mSerial, i, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(0, "startLceService", e);
            }
        }
    }

    public void stopLceService(Message message) {
        if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_2)) {
            Rlog.d(RILJ_LOG_TAG, "stopLceService: REQUEST_NOT_SUPPORTED");
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
                return;
            }
            return;
        }
        IRadio radioProxy = getRadioProxy(message);
        if (radioProxy != null) {
            RILRequest obtainRequest = obtainRequest(NetworkStackConstants.ICMPV6_ROUTER_SOLICITATION, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioProxy.stopLceService(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(0, "stopLceService", e);
            }
        }
    }

    public void setDataThrottling(Message message, WorkSource workSource, int i, long j) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(NetworkStackConstants.VENDOR_SPECIFIC_IE_ID, message, getDefaultWorkSourceIfInvalid(workSource));
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " dataThrottlingAction = " + i + " completionWindowMillis " + j);
                try {
                    radioDataProxy.setDataThrottling(obtainRequest.mSerial, (byte) i, j);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(1, "setDataThrottling", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "setDataThrottling: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    @Deprecated
    public void pullLceData(Message message) {
        if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_2)) {
            Rlog.d(RILJ_LOG_TAG, "pullLceData: REQUEST_NOT_SUPPORTED");
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
                return;
            }
            return;
        }
        IRadio radioProxy = getRadioProxy(message);
        if (radioProxy != null) {
            RILRequest obtainRequest = obtainRequest(134, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioProxy.pullLceData(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(0, "pullLceData", e);
            }
        }
    }

    public void getModemActivityInfo(Message message, WorkSource workSource) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(NetworkStackConstants.ICMPV6_NEIGHBOR_SOLICITATION, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioModemProxy.getModemActivityInfo(obtainRequest.mSerial);
                this.mRilHandler.sendMessageDelayed(this.mRilHandler.obtainMessage(5, Integer.valueOf(obtainRequest.mSerial)), LaunchConfig.ACTIVITY_CONSIDERED_RESUME);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "getModemActivityInfo", e);
            }
        }
    }

    public void setAllowedCarriers(CarrierRestrictionRules carrierRestrictionRules, Message message, WorkSource workSource) {
        Objects.requireNonNull(carrierRestrictionRules, "Carrier restriction cannot be null.");
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " params: " + carrierRestrictionRules);
            try {
                radioSimProxy.setAllowedCarriers(obtainRequest.mSerial, carrierRestrictionRules, message);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "setAllowedCarriers", e);
            }
        }
    }

    public void getAllowedCarriers(Message message, WorkSource workSource) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(137, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioSimProxy.getAllowedCarriers(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "getAllowedCarriers", e);
            }
        }
    }

    public void sendDeviceState(int i, boolean z, Message message) {
        RadioModemProxy radioModemProxy = (RadioModemProxy) getRadioServiceProxy(RadioModemProxy.class, message);
        if (!radioModemProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(138, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " " + i + ":" + z);
            try {
                radioModemProxy.sendDeviceState(obtainRequest.mSerial, i, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(3, "sendDeviceState", e);
            }
        }
    }

    public void setUnsolResponseFilter(int i, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(139, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " " + i);
            try {
                radioNetworkProxy.setIndicationFilter(obtainRequest.mSerial, i);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(4, "setIndicationFilter", e);
            }
        }
    }

    public void setSignalStrengthReportingCriteria(List<SignalThresholdInfo> list, Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_2)) {
                RILRequest obtainRequest = obtainRequest(202, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioNetworkProxy.setSignalStrengthReportingCriteria(obtainRequest.mSerial, list);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "setSignalStrengthReportingCriteria", e);
                }
            } else {
                riljLoge("setSignalStrengthReportingCriteria ignored on IRadio version less than 1.2");
            }
        }
    }

    public void setLinkCapacityReportingCriteria(int i, int i2, int i3, int[] iArr, int[] iArr2, int i4, Message message) {
        Message message2 = message;
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message2);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_2)) {
                RILRequest obtainRequest = obtainRequest(203, message2, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioNetworkProxy.setLinkCapacityReportingCriteria(obtainRequest.mSerial, i, i2, i3, iArr, iArr2, i4);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "setLinkCapacityReportingCriteria", e);
                }
            } else {
                riljLoge("setLinkCapacityReportingCriteria ignored on IRadio version less than 1.2");
            }
        }
    }

    public void setSimCardPower(int i, Message message, WorkSource workSource) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(SmsMessage.MAX_USER_DATA_BYTES, message, getDefaultWorkSourceIfInvalid(workSource));
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " " + i);
            try {
                radioSimProxy.setSimCardPower(obtainRequest.mSerial, i, message);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(5, "setSimCardPower", e);
            }
        }
    }

    public void setCarrierInfoForImsiEncryption(ImsiEncryptionInfo imsiEncryptionInfo, Message message) {
        Objects.requireNonNull(imsiEncryptionInfo, "ImsiEncryptionInfo cannot be null.");
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_1)) {
                RILRequest obtainRequest = obtainRequest(141, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioSimProxy.setCarrierInfoForImsiEncryption(obtainRequest.mSerial, imsiEncryptionInfo);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(5, "setCarrierInfoForImsiEncryption", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "setCarrierInfoForImsiEncryption: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void startNattKeepalive(int i, KeepalivePacketData keepalivePacketData, int i2, Message message) {
        Objects.requireNonNull(keepalivePacketData, "KeepaliveRequest cannot be null.");
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_1)) {
                RILRequest obtainRequest = obtainRequest(144, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioDataProxy.startKeepalive(obtainRequest.mSerial, i, keepalivePacketData, i2, message);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(1, "startNattKeepalive", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "startNattKeepalive: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void stopNattKeepalive(int i, Message message) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_1)) {
                RILRequest obtainRequest = obtainRequest(145, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioDataProxy.stopKeepalive(obtainRequest.mSerial, i);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(1, "stopNattKeepalive", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "stopNattKeepalive: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void getIMEI(Message message) {
        throw new RuntimeException("getIMEI not expected to be called");
    }

    public void getIMEISV(Message message) {
        throw new RuntimeException("getIMEISV not expected to be called");
    }

    @Deprecated
    public void getLastPdpFailCause(Message message) {
        throw new RuntimeException("getLastPdpFailCause not expected to be called");
    }

    public void getLastDataCallFailCause(Message message) {
        throw new RuntimeException("getLastDataCallFailCause not expected to be called");
    }

    public void enableUiccApplications(boolean z, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_5)) {
                RILRequest obtainRequest = obtainRequest(BerTlv.BER_PROACTIVE_COMMAND_TAG, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioSimProxy.enableUiccApplications(obtainRequest.mSerial, z);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(5, "enableUiccApplications", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "enableUiccApplications: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void areUiccApplicationsEnabled(Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_5)) {
                RILRequest obtainRequest = obtainRequest(209, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioSimProxy.areUiccApplicationsEnabled(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(5, "areUiccApplicationsEnabled", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "areUiccApplicationsEnabled: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public boolean canToggleUiccApplicationsEnablement() {
        return !((RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, (Message) null)).isEmpty() && this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_5);
    }

    public void resetRadio(Message message) {
        throw new RuntimeException("resetRadio not expected to be called");
    }

    public void handleCallSetupRequestFromSim(boolean z, Message message) {
        RadioVoiceProxy radioVoiceProxy = (RadioVoiceProxy) getRadioServiceProxy(RadioVoiceProxy.class, message);
        if (!radioVoiceProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(71, message, this.mRILDefaultWorkSource);
            riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioVoiceProxy.handleStkCallSetupRequestFromSim(obtainRequest.mSerial, z);
            } catch (RemoteException | RuntimeException e) {
                handleRadioProxyExceptionForRR(6, "handleStkCallSetupRequestFromSim", e);
            }
        }
    }

    public void getBarringInfo(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_5)) {
                RILRequest obtainRequest = obtainRequest(211, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioNetworkProxy.getBarringInfo(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "getBarringInfo", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "getBarringInfo: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void allocatePduSessionId(Message message) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(215, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioDataProxy.allocatePduSessionId(obtainRequest.mSerial);
                } catch (RemoteException e) {
                    handleRadioProxyExceptionForRR(1, "allocatePduSessionId", e);
                }
            } else {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void releasePduSessionId(Message message, int i) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(216, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioDataProxy.releasePduSessionId(obtainRequest.mSerial, i);
                } catch (RemoteException e) {
                    handleRadioProxyExceptionForRR(1, "releasePduSessionId", e);
                }
            } else {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void startHandover(Message message, int i) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(217, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioDataProxy.startHandover(obtainRequest.mSerial, i);
                } catch (RemoteException e) {
                    handleRadioProxyExceptionForRR(1, "startHandover", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "startHandover: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void cancelHandover(Message message, int i) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(218, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioDataProxy.cancelHandover(obtainRequest.mSerial, i);
                } catch (RemoteException e) {
                    handleRadioProxyExceptionForRR(1, "cancelHandover", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "cancelHandover: REQUEST_NOT_SUPPORTED");
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void getSlicingConfig(Message message) {
        RadioDataProxy radioDataProxy = (RadioDataProxy) getRadioServiceProxy(RadioDataProxy.class, message);
        if (!radioDataProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(224, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioDataProxy.getSlicingConfig(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(1, "getSlicingConfig", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "getSlicingConfig: REQUEST_NOT_SUPPORTED");
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void getSimPhonebookRecords(Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(150, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioSimProxy.getSimPhonebookRecords(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(5, "getSimPhonebookRecords", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "getSimPhonebookRecords: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void getSimPhonebookCapacity(Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(149, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioSimProxy.getSimPhonebookCapacity(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(5, "getSimPhonebookCapacity", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "getSimPhonebookCapacity: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void updateSimPhonebookRecord(SimPhonebookRecord simPhonebookRecord, Message message) {
        RadioSimProxy radioSimProxy = (RadioSimProxy) getRadioServiceProxy(RadioSimProxy.class, message);
        if (!radioSimProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_1_6)) {
                RILRequest obtainRequest = obtainRequest(151, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " with " + simPhonebookRecord.toString());
                try {
                    radioSimProxy.updateSimPhonebookRecords(obtainRequest.mSerial, simPhonebookRecord);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(5, "updateSimPhonebookRecords", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "updateSimPhonebookRecords: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void setUsageSetting(Message message, int i) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_2_0)) {
                RILRequest obtainRequest = obtainRequest(227, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioNetworkProxy.setUsageSetting(obtainRequest.mSerial, i);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "setUsageSetting", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "setUsageSetting: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void getUsageSetting(Message message) {
        RadioNetworkProxy radioNetworkProxy = (RadioNetworkProxy) getRadioServiceProxy(RadioNetworkProxy.class, message);
        if (!radioNetworkProxy.isEmpty()) {
            if (this.mRadioVersion.greaterOrEqual(RADIO_HAL_VERSION_2_0)) {
                RILRequest obtainRequest = obtainRequest(228, message, this.mRILDefaultWorkSource);
                riljLog(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioNetworkProxy.getUsageSetting(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(4, "getUsageSetting", e);
                }
            } else {
                Rlog.d(RILJ_LOG_TAG, "getUsageSetting: REQUEST_NOT_SUPPORTED");
                if (message != null) {
                    AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                    message.sendToTarget();
                }
            }
        }
    }

    public void processIndication(int i, int i2) {
        if (i2 == 1) {
            sendAck(i);
            riljLog("Unsol response received; Sending ack to ril.cpp");
        }
    }

    public void processRequestAck(int i) {
        RILRequest rILRequest;
        synchronized (this.mRequestList) {
            rILRequest = this.mRequestList.get(i);
        }
        if (rILRequest == null) {
            Rlog.w(RILJ_LOG_TAG, "processRequestAck: Unexpected solicited ack response! serial: " + i);
            return;
        }
        decrementWakeLock(rILRequest);
        riljLog(rILRequest.serialString() + " Ack < " + RILUtils.requestToString(rILRequest.mRequest));
    }

    @VisibleForTesting
    public RILRequest processResponse(RadioResponseInfo radioResponseInfo) {
        return processResponseInternal(0, radioResponseInfo.serial, radioResponseInfo.error, radioResponseInfo.type);
    }

    @VisibleForTesting
    public RILRequest processResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        return processResponseInternal(0, radioResponseInfo.serial, radioResponseInfo.error, radioResponseInfo.type);
    }

    @VisibleForTesting
    public RILRequest processResponse(int i, android.hardware.radio.RadioResponseInfo radioResponseInfo) {
        return processResponseInternal(i, radioResponseInfo.serial, radioResponseInfo.error, radioResponseInfo.type);
    }

    private RILRequest processResponseInternal(int i, int i2, int i3, int i4) {
        RILRequest rILRequest;
        if (i4 == 1) {
            synchronized (this.mRequestList) {
                rILRequest = this.mRequestList.get(i2);
            }
            if (rILRequest == null) {
                Rlog.w(RILJ_LOG_TAG, "Unexpected solicited ack response! sn: " + i2);
            } else {
                decrementWakeLock(rILRequest);
                RadioBugDetector radioBugDetector = this.mRadioBugDetector;
                if (radioBugDetector != null) {
                    radioBugDetector.detectRadioBug(rILRequest.mRequest, i3);
                }
                riljLog(rILRequest.serialString() + " Ack from " + serviceToString(i) + " < " + RILUtils.requestToString(rILRequest.mRequest));
            }
            return rILRequest;
        }
        RILRequest findAndRemoveRequestFromList = findAndRemoveRequestFromList(i2);
        if (findAndRemoveRequestFromList == null) {
            Rlog.e(RILJ_LOG_TAG, "processResponse: Unexpected response! serial: " + i2 + " ,error: " + i3);
            return null;
        }
        addToRilHistogram(findAndRemoveRequestFromList);
        RadioBugDetector radioBugDetector2 = this.mRadioBugDetector;
        if (radioBugDetector2 != null) {
            radioBugDetector2.detectRadioBug(findAndRemoveRequestFromList.mRequest, i3);
        }
        if (i4 == 2) {
            sendAck(i);
            riljLog("Response received from " + serviceToString(i) + " for " + findAndRemoveRequestFromList.serialString() + " " + RILUtils.requestToString(findAndRemoveRequestFromList.mRequest) + " Sending ack to ril.cpp");
        }
        int i5 = findAndRemoveRequestFromList.mRequest;
        if (i5 == 3 || i5 == 5) {
            if (this.mIccStatusChangedRegistrants != null) {
                riljLog("ON enter sim puk fakeSimStatusChanged: reg count=" + this.mIccStatusChangedRegistrants.size());
                this.mIccStatusChangedRegistrants.notifyRegistrants();
            }
        } else if (i5 == 129) {
            setRadioState(2, false);
        }
        if (i3 != 0) {
            int i6 = findAndRemoveRequestFromList.mRequest;
            if ((i6 == 2 || i6 == 4 || i6 == 43 || i6 == 6 || i6 == 7) && this.mIccStatusChangedRegistrants != null) {
                riljLog("ON some errors fakeSimStatusChanged: reg count=" + this.mIccStatusChangedRegistrants.size());
                this.mIccStatusChangedRegistrants.notifyRegistrants();
            }
        } else if (findAndRemoveRequestFromList.mRequest == 14 && this.mTestingEmergencyCall.getAndSet(false) && this.mEmergencyCallbackModeRegistrant != null) {
            riljLog("testing emergency call, notify ECM Registrants");
            this.mEmergencyCallbackModeRegistrant.notifyRegistrant();
        }
        return findAndRemoveRequestFromList;
    }

    @VisibleForTesting
    public void processResponseDone(RILRequest rILRequest, RadioResponseInfo radioResponseInfo, Object obj) {
        processResponseDoneInternal(rILRequest, radioResponseInfo.error, radioResponseInfo.type, obj);
    }

    @VisibleForTesting
    public void processResponseDone_1_6(RILRequest rILRequest, android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, Object obj) {
        processResponseDoneInternal(rILRequest, radioResponseInfo.error, radioResponseInfo.type, obj);
    }

    @VisibleForTesting
    public void processResponseDone(RILRequest rILRequest, android.hardware.radio.RadioResponseInfo radioResponseInfo, Object obj) {
        processResponseDoneInternal(rILRequest, radioResponseInfo.error, radioResponseInfo.type, obj);
    }

    private void processResponseDoneInternal(RILRequest rILRequest, int i, int i2, Object obj) {
        if (i == 0) {
            riljLog(rILRequest.serialString() + "< " + RILUtils.requestToString(rILRequest.mRequest) + " " + retToString(rILRequest.mRequest, obj));
        } else {
            riljLog(rILRequest.serialString() + "< " + RILUtils.requestToString(rILRequest.mRequest) + " error " + i);
            rILRequest.onError(i, obj);
        }
        processResponseCleanUp(rILRequest, i, i2, obj);
    }

    @VisibleForTesting
    public void processResponseFallback(RILRequest rILRequest, RadioResponseInfo radioResponseInfo, Object obj) {
        if (radioResponseInfo.error == 6) {
            riljLog(rILRequest.serialString() + "< " + RILUtils.requestToString(rILRequest.mRequest) + " request not supported, falling back");
        }
        processResponseCleanUp(rILRequest, radioResponseInfo.error, radioResponseInfo.type, obj);
    }

    private void processResponseCleanUp(RILRequest rILRequest, int i, int i2, Object obj) {
        if (rILRequest != null) {
            this.mMetrics.writeOnRilSolicitedResponse(this.mPhoneId.intValue(), rILRequest.mSerial, i, rILRequest.mRequest, obj);
            if (i2 == 0) {
                decrementWakeLock(rILRequest);
            }
            rILRequest.release();
        }
    }

    private void sendAck(int i) {
        RILRequest obtain = RILRequest.obtain(800, (Message) null, this.mRILDefaultWorkSource);
        acquireWakeLock(obtain, 1);
        if (i == 0) {
            IRadio radioProxy = getRadioProxy((Message) null);
            if (radioProxy != null) {
                try {
                    radioProxy.responseAcknowledgement();
                } catch (RemoteException | RuntimeException e) {
                    handleRadioProxyExceptionForRR(0, "sendAck", e);
                    riljLoge("sendAck: " + e);
                }
            } else {
                Rlog.e(RILJ_LOG_TAG, "Error trying to send ack, radioProxy = null");
            }
        } else {
            RadioServiceProxy radioServiceProxy = getRadioServiceProxy(i, (Message) null);
            if (!radioServiceProxy.isEmpty()) {
                try {
                    radioServiceProxy.responseAcknowledgement();
                } catch (RemoteException | RuntimeException e2) {
                    handleRadioProxyExceptionForRR(i, "sendAck", e2);
                    riljLoge("sendAck: " + e2);
                }
            } else {
                Rlog.e(RILJ_LOG_TAG, "Error trying to send ack, serviceProxy is empty");
            }
        }
        obtain.release();
    }

    private WorkSource getDefaultWorkSourceIfInvalid(WorkSource workSource) {
        return workSource == null ? this.mRILDefaultWorkSource : workSource;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void acquireWakeLock(RILRequest rILRequest, int i) {
        synchronized (rILRequest) {
            if (rILRequest.mWakeLockType != -1) {
                Rlog.d(RILJ_LOG_TAG, "Failed to aquire wakelock for " + rILRequest.serialString());
                return;
            }
            if (i == 0) {
                synchronized (this.mWakeLock) {
                    this.mWakeLock.acquire();
                    this.mWakeLockCount++;
                    this.mWlSequenceNum++;
                    if (!this.mClientWakelockTracker.isClientActive(rILRequest.getWorkSourceClientId())) {
                        this.mActiveWakelockWorkSource.add(rILRequest.mWorkSource);
                        this.mWakeLock.setWorkSource(this.mActiveWakelockWorkSource);
                    }
                    this.mClientWakelockTracker.startTracking(rILRequest.mClientId, rILRequest.mRequest, rILRequest.mSerial, this.mWakeLockCount);
                    Message obtainMessage = this.mRilHandler.obtainMessage(2);
                    obtainMessage.arg1 = this.mWlSequenceNum;
                    this.mRilHandler.sendMessageDelayed(obtainMessage, (long) this.mWakeLockTimeout);
                }
            } else if (i != 1) {
                Rlog.w(RILJ_LOG_TAG, "Acquiring Invalid Wakelock type " + i);
                return;
            } else {
                synchronized (this.mAckWakeLock) {
                    this.mAckWakeLock.acquire();
                    this.mAckWlSequenceNum++;
                    Message obtainMessage2 = this.mRilHandler.obtainMessage(4);
                    obtainMessage2.arg1 = this.mAckWlSequenceNum;
                    this.mRilHandler.sendMessageDelayed(obtainMessage2, (long) this.mAckWakeLockTimeout);
                }
            }
            rILRequest.mWakeLockType = i;
        }
    }

    @VisibleForTesting
    public PowerManager.WakeLock getWakeLock(int i) {
        return i == 0 ? this.mWakeLock : this.mAckWakeLock;
    }

    @VisibleForTesting
    public RilHandler getRilHandler() {
        return this.mRilHandler;
    }

    @VisibleForTesting
    public SparseArray<RILRequest> getRilRequestList() {
        return this.mRequestList;
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void decrementWakeLock(RILRequest rILRequest) {
        synchronized (rILRequest) {
            int i = rILRequest.mWakeLockType;
            if (i != -1) {
                if (i == 0) {
                    synchronized (this.mWakeLock) {
                        ClientWakelockTracker clientWakelockTracker = this.mClientWakelockTracker;
                        String str = rILRequest.mClientId;
                        int i2 = rILRequest.mRequest;
                        int i3 = rILRequest.mSerial;
                        int i4 = this.mWakeLockCount;
                        clientWakelockTracker.stopTracking(str, i2, i3, i4 > 1 ? i4 - 1 : 0);
                        if (!this.mClientWakelockTracker.isClientActive(rILRequest.getWorkSourceClientId())) {
                            this.mActiveWakelockWorkSource.remove(rILRequest.mWorkSource);
                            this.mWakeLock.setWorkSource(this.mActiveWakelockWorkSource);
                        }
                        int i5 = this.mWakeLockCount;
                        if (i5 > 1) {
                            this.mWakeLockCount = i5 - 1;
                        } else {
                            this.mWakeLockCount = 0;
                            this.mWakeLock.release();
                        }
                    }
                } else if (i != 1) {
                    Rlog.w(RILJ_LOG_TAG, "Decrementing Invalid Wakelock type " + rILRequest.mWakeLockType);
                }
            }
            rILRequest.mWakeLockType = -1;
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean clearWakeLock(int i) {
        if (i == 0) {
            synchronized (this.mWakeLock) {
                if (this.mWakeLockCount == 0 && !this.mWakeLock.isHeld()) {
                    return false;
                }
                Rlog.d(RILJ_LOG_TAG, "NOTE: mWakeLockCount is " + this.mWakeLockCount + "at time of clearing");
                this.mWakeLockCount = 0;
                this.mWakeLock.release();
                this.mClientWakelockTracker.stopTrackingAll();
                this.mActiveWakelockWorkSource = new WorkSource();
                return true;
            }
        }
        synchronized (this.mAckWakeLock) {
            if (!this.mAckWakeLock.isHeld()) {
                return false;
            }
            this.mAckWakeLock.release();
            return true;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void clearRequestList(int i, boolean z) {
        synchronized (this.mRequestList) {
            int size = this.mRequestList.size();
            if (z) {
                Rlog.d(RILJ_LOG_TAG, "clearRequestList  mWakeLockCount=" + this.mWakeLockCount + " mRequestList=" + size);
            }
            for (int i2 = 0; i2 < size; i2++) {
                RILRequest valueAt = this.mRequestList.valueAt(i2);
                if (z) {
                    Rlog.d(RILJ_LOG_TAG, i2 + ": [" + valueAt.mSerial + "] " + RILUtils.requestToString(valueAt.mRequest));
                }
                valueAt.onError(i, (Object) null);
                decrementWakeLock(valueAt);
                valueAt.release();
            }
            this.mRequestList.clear();
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage
    public RILRequest findAndRemoveRequestFromList(int i) {
        RILRequest rILRequest;
        synchronized (this.mRequestList) {
            rILRequest = this.mRequestList.get(i);
            if (rILRequest != null) {
                this.mRequestList.remove(i);
            }
        }
        return rILRequest;
    }

    private void addToRilHistogram(RILRequest rILRequest) {
        int elapsedRealtime = (int) (SystemClock.elapsedRealtime() - rILRequest.mStartTimeMs);
        synchronized (sRilTimeHistograms) {
            TelephonyHistogram telephonyHistogram = sRilTimeHistograms.get(rILRequest.mRequest);
            if (telephonyHistogram == null) {
                telephonyHistogram = new TelephonyHistogram(1, rILRequest.mRequest, 5);
                sRilTimeHistograms.put(rILRequest.mRequest, telephonyHistogram);
            }
            telephonyHistogram.addTimeTaken(elapsedRealtime);
        }
    }

    /* access modifiers changed from: package-private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public RadioCapability makeStaticRadioCapability() {
        String string = this.mContext.getResources().getString(17040027);
        int rafTypeFromString = !TextUtils.isEmpty(string) ? RadioAccessFamily.rafTypeFromString(string) : 0;
        RadioCapability radioCapability = new RadioCapability(this.mPhoneId.intValue(), 0, 0, rafTypeFromString, "", 1);
        riljLog("Faking RIL_REQUEST_GET_RADIO_CAPABILITY response using " + rafTypeFromString);
        return radioCapability;
    }

    @UnsupportedAppUsage
    protected static String retToString(int i, Object obj) {
        if (obj == null || i == 11 || i == 115 || i == 117 || i == 38 || i == 39) {
            return "";
        }
        int i2 = 0;
        int i3 = 1;
        if (obj instanceof int[]) {
            int[] iArr = (int[]) obj;
            int length = iArr.length;
            StringBuilder sb = new StringBuilder("{");
            if (length > 0) {
                sb.append(iArr[0]);
                while (i3 < length) {
                    sb.append(", ");
                    sb.append(iArr[i3]);
                    i3++;
                }
            }
            sb.append("}");
            return sb.toString();
        } else if (obj instanceof String[]) {
            String[] strArr = (String[]) obj;
            int length2 = strArr.length;
            StringBuilder sb2 = new StringBuilder("{");
            if (length2 > 0) {
                if (i == 98) {
                    sb2.append(Rlog.pii(RILJ_LOG_TAG, strArr[0]));
                } else {
                    sb2.append(strArr[0]);
                }
                while (i3 < length2) {
                    sb2.append(", ");
                    sb2.append(strArr[i3]);
                    i3++;
                }
            }
            sb2.append("}");
            return sb2.toString();
        } else if (i == 9) {
            StringBuilder sb3 = new StringBuilder("{");
            Iterator it = ((ArrayList) obj).iterator();
            while (it.hasNext()) {
                sb3.append("[");
                sb3.append((DriverCall) it.next());
                sb3.append("] ");
            }
            sb3.append("}");
            return sb3.toString();
        } else if (i == 75) {
            StringBuilder sb4 = new StringBuilder("{");
            Iterator it2 = ((ArrayList) obj).iterator();
            while (it2.hasNext()) {
                sb4.append("[");
                sb4.append((NeighboringCellInfo) it2.next());
                sb4.append("] ");
            }
            sb4.append("}");
            return sb4.toString();
        } else if (i == 33) {
            CallForwardInfo[] callForwardInfoArr = (CallForwardInfo[]) obj;
            int length3 = callForwardInfoArr.length;
            StringBuilder sb5 = new StringBuilder("{");
            while (i2 < length3) {
                sb5.append("[");
                sb5.append(callForwardInfoArr[i2]);
                sb5.append("] ");
                i2++;
            }
            sb5.append("}");
            return sb5.toString();
        } else if (i == 124) {
            StringBuilder sb6 = new StringBuilder(" ");
            Iterator it3 = ((ArrayList) obj).iterator();
            while (it3.hasNext()) {
                sb6.append("[");
                sb6.append((HardwareConfig) it3.next());
                sb6.append("] ");
            }
            return sb6.toString();
        } else {
            try {
                if (obj.getClass().getMethod("toString", new Class[0]).getDeclaringClass() != Object.class) {
                    i2 = 1;
                }
            } catch (NoSuchMethodException e) {
                Rlog.e(RILJ_LOG_TAG, e.getMessage());
            }
            if (i2 != 0) {
                return obj.toString();
            }
            return RILUtils.convertToString(obj) + " [convertToString]";
        }
    }

    /* access modifiers changed from: package-private */
    public void writeMetricsCallRing(char[] cArr) {
        this.mMetrics.writeRilCallRing(this.mPhoneId.intValue(), cArr);
    }

    /* access modifiers changed from: package-private */
    public void writeMetricsSrvcc(int i) {
        this.mMetrics.writeRilSrvcc(this.mPhoneId.intValue(), i);
        PhoneFactory.getPhone(this.mPhoneId.intValue()).getVoiceCallSessionStats().onRilSrvccStateChanged(i);
    }

    /* access modifiers changed from: package-private */
    public void writeMetricsModemRestartEvent(String str) {
        this.mMetrics.writeModemRestartEvent(this.mPhoneId.intValue(), str);
        if (this.mPhoneId.intValue() == 0) {
            ModemRestartStats.onModemRestart(str);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void notifyRegistrantsRilConnectionChanged(int i) {
        this.mRilVersion = i;
        RegistrantList registrantList = this.mRilConnectedRegistrants;
        if (registrantList != null) {
            registrantList.notifyRegistrants(new AsyncResult((Object) null, new Integer(i), (Throwable) null));
        }
    }

    /* access modifiers changed from: package-private */
    @UnsupportedAppUsage
    public void notifyRegistrantsCdmaInfoRec(CdmaInformationRecords cdmaInformationRecords) {
        Object obj = cdmaInformationRecords.record;
        if (obj instanceof CdmaInformationRecords.CdmaDisplayInfoRec) {
            if (this.mDisplayInfoRegistrants != null) {
                unsljLogRet(1027, obj);
                this.mDisplayInfoRegistrants.notifyRegistrants(new AsyncResult((Object) null, cdmaInformationRecords.record, (Throwable) null));
            }
        } else if (obj instanceof CdmaInformationRecords.CdmaSignalInfoRec) {
            if (this.mSignalInfoRegistrants != null) {
                unsljLogRet(1027, obj);
                this.mSignalInfoRegistrants.notifyRegistrants(new AsyncResult((Object) null, cdmaInformationRecords.record, (Throwable) null));
            }
        } else if (obj instanceof CdmaInformationRecords.CdmaNumberInfoRec) {
            if (this.mNumberInfoRegistrants != null) {
                unsljLogRet(1027, obj);
                this.mNumberInfoRegistrants.notifyRegistrants(new AsyncResult((Object) null, cdmaInformationRecords.record, (Throwable) null));
            }
        } else if (obj instanceof CdmaInformationRecords.CdmaRedirectingNumberInfoRec) {
            if (this.mRedirNumInfoRegistrants != null) {
                unsljLogRet(1027, obj);
                this.mRedirNumInfoRegistrants.notifyRegistrants(new AsyncResult((Object) null, cdmaInformationRecords.record, (Throwable) null));
            }
        } else if (obj instanceof CdmaInformationRecords.CdmaLineControlInfoRec) {
            if (this.mLineControlInfoRegistrants != null) {
                unsljLogRet(1027, obj);
                this.mLineControlInfoRegistrants.notifyRegistrants(new AsyncResult((Object) null, cdmaInformationRecords.record, (Throwable) null));
            }
        } else if (obj instanceof CdmaInformationRecords.CdmaT53ClirInfoRec) {
            if (this.mT53ClirInfoRegistrants != null) {
                unsljLogRet(1027, obj);
                this.mT53ClirInfoRegistrants.notifyRegistrants(new AsyncResult((Object) null, cdmaInformationRecords.record, (Throwable) null));
            }
        } else if ((obj instanceof CdmaInformationRecords.CdmaT53AudioControlInfoRec) && this.mT53AudCntrlInfoRegistrants != null) {
            unsljLogRet(1027, obj);
            this.mT53AudCntrlInfoRegistrants.notifyRegistrants(new AsyncResult((Object) null, cdmaInformationRecords.record, (Throwable) null));
        }
    }

    @UnsupportedAppUsage
    public void riljLog(String str) {
        Rlog.d(RILJ_LOG_TAG, str + " [PHONE" + this.mPhoneId + "]");
    }

    public void riljLoge(String str) {
        Rlog.e(RILJ_LOG_TAG, str + " [PHONE" + this.mPhoneId + "]");
    }

    public void riljLogv(String str) {
        Rlog.v(RILJ_LOG_TAG, str + " [PHONE" + this.mPhoneId + "]");
    }

    @UnsupportedAppUsage
    public void unsljLog(int i) {
        riljLog("[UNSL]< " + RILUtils.responseToString(i));
    }

    @UnsupportedAppUsage
    public void unsljLogMore(int i, String str) {
        riljLog("[UNSL]< " + RILUtils.responseToString(i) + " " + str);
    }

    @UnsupportedAppUsage
    public void unsljLogRet(int i, Object obj) {
        riljLog("[UNSL]< " + RILUtils.responseToString(i) + " " + retToString(i, obj));
    }

    @UnsupportedAppUsage
    public void unsljLogvRet(int i, Object obj) {
        riljLogv("[UNSL]< " + RILUtils.responseToString(i) + " " + retToString(i, obj));
    }

    public void setPhoneType(int i) {
        riljLog("setPhoneType=" + i + " old value=" + this.mPhoneType);
        this.mPhoneType = i;
    }

    public void testingEmergencyCall() {
        riljLog("testingEmergencyCall");
        this.mTestingEmergencyCall.set(true);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("RIL: " + this);
        printWriter.println(" mWakeLock=" + this.mWakeLock);
        printWriter.println(" mWakeLockTimeout=" + this.mWakeLockTimeout);
        synchronized (this.mRequestList) {
            synchronized (this.mWakeLock) {
                printWriter.println(" mWakeLockCount=" + this.mWakeLockCount);
            }
            int size = this.mRequestList.size();
            printWriter.println(" mRequestList count=" + size);
            for (int i = 0; i < size; i++) {
                RILRequest valueAt = this.mRequestList.valueAt(i);
                printWriter.println("  [" + valueAt.mSerial + "] " + RILUtils.requestToString(valueAt.mRequest));
            }
        }
        printWriter.println(" mLastNITZTimeInfo=" + Arrays.toString(this.mLastNITZTimeInfo));
        printWriter.println(" mLastRadioPowerResult=" + this.mLastRadioPowerResult);
        printWriter.println(" mTestingEmergencyCall=" + this.mTestingEmergencyCall.get());
        this.mClientWakelockTracker.dumpClientRequestTracker(printWriter);
    }

    public List<ClientRequestStats> getClientRequestStats() {
        return this.mClientWakelockTracker.getClientRequestStats();
    }

    public SignalStrength fixupSignalStrength10(SignalStrength signalStrength) {
        ServiceState serviceState;
        List<CellSignalStrengthGsm> cellSignalStrengths = signalStrength.getCellSignalStrengths(CellSignalStrengthGsm.class);
        if (!cellSignalStrengths.isEmpty()) {
            int i = 0;
            if (cellSignalStrengths.get(0).isValid()) {
                CellSignalStrengthGsm cellSignalStrengthGsm = cellSignalStrengths.get(0);
                Phone phone = PhoneFactory.getPhone(this.mPhoneId.intValue());
                if (!(phone == null || (serviceState = phone.getServiceState()) == null)) {
                    i = serviceState.getRilVoiceRadioTechnology();
                }
                if (!(i == 3 || i == 15)) {
                    switch (i) {
                        case 9:
                        case 10:
                        case 11:
                            break;
                        default:
                            return signalStrength;
                    }
                }
                return new SignalStrength(new CellSignalStrengthCdma(), new CellSignalStrengthGsm(), new CellSignalStrengthWcdma(cellSignalStrengthGsm.getRssi(), cellSignalStrengthGsm.getBitErrorRate(), Integer.MAX_VALUE, Integer.MAX_VALUE), new CellSignalStrengthTdscdma(), new CellSignalStrengthLte(), new CellSignalStrengthNr());
            }
        }
        return signalStrength;
    }

    public HalVersion getHalVersion() {
        return this.mRadioVersion;
    }

    /* access modifiers changed from: protected */
    public void setResponseFunctions() {
        try {
            this.mRadioProxy.setResponseFunctions(this.mRadioResponse, this.mRadioIndication);
        } catch (RemoteException e) {
            riljLoge("getRadioProxy: setResponseFunctions, " + e);
        }
    }

    /* access modifiers changed from: protected */
    public void setServiceResponseFunctions(int i) {
        RadioServiceProxy radioServiceProxy = this.mServiceProxies.get(i);
        if (radioServiceProxy.isEmpty()) {
            riljLoge("getRadioProxy: setResponseFunctions, serviceProxy is empty");
        } else if (i == 1) {
            try {
                ((RadioDataProxy) radioServiceProxy).getAidl().setResponseFunctions(this.mDataResponse, this.mDataIndication);
            } catch (RemoteException e) {
                riljLoge("getRadioProxy: setResponseFunctions, " + e);
            }
        } else if (i == 2) {
            ((RadioMessagingProxy) radioServiceProxy).getAidl().setResponseFunctions(this.mMessagingResponse, this.mMessagingIndication);
        } else if (i == 3) {
            ((RadioModemProxy) radioServiceProxy).getAidl().setResponseFunctions(this.mModemResponse, this.mModemIndication);
        } else if (i == 4) {
            ((RadioNetworkProxy) radioServiceProxy).getAidl().setResponseFunctions(this.mNetworkResponse, this.mNetworkIndication);
        } else if (i == 5) {
            ((RadioSimProxy) radioServiceProxy).getAidl().setResponseFunctions(this.mSimResponse, this.mSimIndication);
        } else if (i == 6) {
            ((RadioVoiceProxy) radioServiceProxy).getAidl().setResponseFunctions(this.mVoiceResponse, this.mVoiceIndication);
        }
    }

    /* access modifiers changed from: private */
    public static String serviceToString(int i) {
        switch (i) {
            case 0:
                return "RADIO";
            case 1:
                return "DATA";
            case 2:
                return "MESSAGING";
            case 3:
                return "MODEM";
            case 4:
                return "NETWORK";
            case 5:
                return "SIM";
            case 6:
                return "VOICE";
            default:
                return "UNKNOWN:" + i;
        }
    }
}
