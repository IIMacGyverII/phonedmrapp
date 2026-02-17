package com.android.internal.telephony;

import android.content.Context;
import android.hardware.radio.RadioResponseInfo;
import android.hardware.radio.config.IRadioConfig;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.os.SystemProperties;
import android.os.WorkSource;
import android.telephony.TelephonyManager;
import android.telephony.UiccSlotMapping;
import android.util.SparseArray;
import com.android.telephony.Rlog;
import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.concurrent.atomic.AtomicLong;

public class RadioConfig extends Handler {
    private static final boolean DBG = true;
    static final int EVENT_AIDL_SERVICE_DEAD = 2;
    static final int EVENT_HIDL_SERVICE_DEAD = 1;
    protected static final HalVersion RADIO_CONFIG_HAL_VERSION_1_0 = new HalVersion(1, 0);
    protected static final HalVersion RADIO_CONFIG_HAL_VERSION_1_1 = new HalVersion(1, 1);
    protected static final HalVersion RADIO_CONFIG_HAL_VERSION_1_3 = new HalVersion(1, 3);
    protected static final HalVersion RADIO_CONFIG_HAL_VERSION_2_0 = new HalVersion(2, 0);
    protected static final HalVersion RADIO_CONFIG_HAL_VERSION_UNKNOWN = new HalVersion(-1, -1);
    private static final String TAG = "RadioConfig";
    private static final boolean VDBG = false;
    private static Context sContext;
    private static final Object sLock = new Object();
    private static RadioConfig sRadioConfig;
    private final WorkSource mDefaultWorkSource;
    private final int[] mDeviceNrCapabilities;
    private final boolean mIsMobileNetworkSupported;
    private MockModem mMockModem;
    protected final RadioConfigProxy mRadioConfigProxy;
    protected final AtomicLong mRadioConfigProxyCookie = new AtomicLong(0);
    private final SparseArray<RILRequest> mRequestList = new SparseArray<>();
    protected Registrant mSimSlotStatusRegistrant;

    /* access modifiers changed from: protected */
    public boolean isGetHidlServiceSync() {
        return true;
    }

    private boolean isMobileDataCapable(Context context) {
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(TelephonyManager.class);
        return telephonyManager != null && telephonyManager.isDataCapable();
    }

    protected RadioConfig(Context context, HalVersion halVersion) {
        this.mIsMobileNetworkSupported = isMobileDataCapable(context);
        this.mRadioConfigProxy = new RadioConfigProxy(this, halVersion);
        this.mDefaultWorkSource = new WorkSource(context.getApplicationInfo().uid, context.getPackageName());
        boolean z = context.getResources().getBoolean(17891802);
        boolean z2 = context.getResources().getBoolean(17891801);
        if (z || z2) {
            ArrayList arrayList = new ArrayList();
            if (z2) {
                arrayList.add(1);
            }
            if (z) {
                arrayList.add(2);
            }
            this.mDeviceNrCapabilities = arrayList.stream().mapToInt(new RadioConfig$$ExternalSyntheticLambda0()).toArray();
            return;
        }
        this.mDeviceNrCapabilities = new int[0];
    }

    public static RadioConfig getInstance() {
        RadioConfig radioConfig;
        synchronized (sLock) {
            radioConfig = sRadioConfig;
            if (radioConfig == null) {
                throw new RuntimeException("RadioConfig.getInstance can't be called before make()");
            }
        }
        return radioConfig;
    }

    public static RadioConfig make(Context context, HalVersion halVersion) {
        RadioConfig radioConfig;
        synchronized (sLock) {
            if (sRadioConfig == null) {
                sContext = context;
                if (SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
                    try {
                        Class<?> cls = Class.forName("com.mediatek.internal.telephony.MtkRadioConfig", false, ClassLoader.getSystemClassLoader());
                        logd("class = " + cls);
                        Constructor<?> constructor = cls.getConstructor(new Class[]{Context.class, HalVersion.class});
                        logd("constructor function = " + constructor);
                        sRadioConfig = (RadioConfig) constructor.newInstance(new Object[]{context, halVersion});
                    } catch (Exception e) {
                        loge("No MtkRadioConfig! Used AOSP! e: " + e);
                        sRadioConfig = new RadioConfig(context, halVersion);
                    }
                } else {
                    sRadioConfig = new RadioConfig(context, halVersion);
                }
                radioConfig = sRadioConfig;
            } else {
                throw new RuntimeException("RadioConfig.make() should only be called once");
            }
        }
        return radioConfig;
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            logd("handleMessage: EVENT_HIDL_SERVICE_DEAD cookie = " + message.obj + " mRadioConfigProxyCookie = " + this.mRadioConfigProxyCookie.get());
            if (((Long) message.obj).longValue() == this.mRadioConfigProxyCookie.get()) {
                resetProxyAndRequestList("EVENT_HIDL_SERVICE_DEAD", (Exception) null);
            }
        } else if (i == 2) {
            logd("handleMessage: EVENT_AIDL_SERVICE_DEAD mRadioConfigProxyCookie = " + this.mRadioConfigProxyCookie.get());
            resetProxyAndRequestList("EVENT_AIDL_SERVICE_DEAD", (Exception) null);
        }
    }

    private void clearRequestList(int i, boolean z) {
        synchronized (this.mRequestList) {
            int size = this.mRequestList.size();
            if (z) {
                logd("clearRequestList: mRequestList=" + size);
            }
            for (int i2 = 0; i2 < size; i2++) {
                RILRequest valueAt = this.mRequestList.valueAt(i2);
                if (z) {
                    logd(i2 + ": [" + valueAt.mSerial + "] " + RILUtils.requestToString(valueAt.mRequest));
                }
                valueAt.onError(i, (Object) null);
                valueAt.release();
            }
            this.mRequestList.clear();
        }
    }

    private void resetProxyAndRequestList(String str, Exception exc) {
        loge(str + ": " + exc);
        this.mRadioConfigProxy.clear();
        this.mRadioConfigProxyCookie.incrementAndGet();
        RILRequest.resetSerial();
        clearRequestList(1, false);
        getRadioConfigProxy((Message) null);
    }

    public RadioConfigProxy getRadioConfigProxy(Message message) {
        if (!this.mIsMobileNetworkSupported) {
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(1));
                message.sendToTarget();
            }
            this.mRadioConfigProxy.clear();
            return this.mRadioConfigProxy;
        } else if (!this.mRadioConfigProxy.isEmpty()) {
            return this.mRadioConfigProxy;
        } else {
            updateRadioConfigProxy();
            if (this.mRadioConfigProxy.isEmpty() && message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(1));
                message.sendToTarget();
            }
            return this.mRadioConfigProxy;
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:13:0x0048  */
    /* JADX WARNING: Removed duplicated region for block: B:5:0x0023  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean setModemService(java.lang.String r9) {
        /*
            r8 = this;
            r0 = 1
            r1 = 0
            if (r9 == 0) goto L_0x0055
            java.lang.String r2 = "Overriding connected service to MockModemService"
            logd(r2)
            r8.mMockModem = r1
            com.android.internal.telephony.MockModem r2 = new com.android.internal.telephony.MockModem
            android.content.Context r3 = sContext
            r2.<init>(r3, r9)
            r8.mMockModem = r2
            r3 = 7
            r2.bindToMockModemService(r3)
            r2 = 0
            r4 = r2
        L_0x001a:
            com.android.internal.telephony.MockModem r5 = r8.mMockModem
            android.os.IBinder r5 = r5.getServiceBinder(r3)
            int r4 = r4 + r0
            if (r5 != 0) goto L_0x0041
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r7 = "Retry("
            r6.append(r7)
            r6.append(r4)
            java.lang.String r7 = ") Mock RadioConfig"
            r6.append(r7)
            java.lang.String r6 = r6.toString()
            logd(r6)
            r6 = 300(0x12c, double:1.48E-321)
            java.lang.Thread.sleep(r6)     // Catch:{ InterruptedException -> 0x0041 }
        L_0x0041:
            if (r5 != 0) goto L_0x0046
            r6 = 3
            if (r4 < r6) goto L_0x001a
        L_0x0046:
            if (r5 != 0) goto L_0x004e
            java.lang.String r0 = "Mock RadioConfig bind fail"
            loge(r0)
            r0 = r2
        L_0x004e:
            if (r0 == 0) goto L_0x0055
            java.lang.String r2 = "EVENT_HIDL_SERVICE_DEAD"
            r8.resetProxyAndRequestList(r2, r1)
        L_0x0055:
            if (r9 == 0) goto L_0x0059
            if (r0 != 0) goto L_0x006b
        L_0x0059:
            if (r0 == 0) goto L_0x0060
            java.lang.String r9 = "Unbinding to mock RadioConfig service"
            logd(r9)
        L_0x0060:
            com.android.internal.telephony.MockModem r9 = r8.mMockModem
            if (r9 == 0) goto L_0x006b
            r8.mMockModem = r1
            java.lang.String r9 = "EVENT_AIDL_SERVICE_DEAD"
            r8.resetProxyAndRequestList(r9, r1)
        L_0x006b:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RadioConfig.setModemService(java.lang.String):boolean");
    }

    /* access modifiers changed from: protected */
    public void updateRadioConfigProxy() {
        IBinder iBinder;
        MockModem mockModem = this.mMockModem;
        if (mockModem == null) {
            iBinder = ServiceManager.waitForDeclaredService(IRadioConfig.DESCRIPTOR + "/default");
        } else {
            iBinder = mockModem.getServiceBinder(7);
        }
        if (iBinder != null) {
            this.mRadioConfigProxy.setAidl(RADIO_CONFIG_HAL_VERSION_2_0, IRadioConfig.Stub.asInterface(iBinder));
        }
        if (this.mRadioConfigProxy.isEmpty()) {
            try {
                this.mRadioConfigProxy.setHidl(RADIO_CONFIG_HAL_VERSION_1_3, android.hardware.radio.config.V1_3.IRadioConfig.getService(true));
            } catch (RemoteException | NoSuchElementException e) {
                this.mRadioConfigProxy.clear();
                loge("getHidlRadioConfigProxy1_3: RadioConfigProxy getService: " + e);
            }
        }
        if (this.mRadioConfigProxy.isEmpty()) {
            try {
                this.mRadioConfigProxy.setHidl(RADIO_CONFIG_HAL_VERSION_1_1, android.hardware.radio.config.V1_1.IRadioConfig.getService(true));
            } catch (RemoteException | NoSuchElementException e2) {
                this.mRadioConfigProxy.clear();
                loge("getHidlRadioConfigProxy1_1: RadioConfigProxy getService | linkToDeath: " + e2);
            }
        }
        if (this.mRadioConfigProxy.isEmpty()) {
            try {
                this.mRadioConfigProxy.setHidl(RADIO_CONFIG_HAL_VERSION_1_0, android.hardware.radio.config.V1_0.IRadioConfig.getService(true));
            } catch (RemoteException | NoSuchElementException e3) {
                this.mRadioConfigProxy.clear();
                loge("getHidlRadioConfigProxy1_0: RadioConfigProxy getService | linkToDeath: " + e3);
            }
        }
        if (!this.mRadioConfigProxy.isEmpty()) {
            try {
                this.mRadioConfigProxy.linkToDeath(this.mRadioConfigProxyCookie.incrementAndGet());
                this.mRadioConfigProxy.setResponseFunctions(this);
                return;
            } catch (RemoteException unused) {
                this.mRadioConfigProxy.clear();
                loge("RadioConfigProxy: failed to linkToDeath() or setResponseFunction()");
            }
        }
        loge("getRadioConfigProxy: mRadioConfigProxy == null");
    }

    private RILRequest obtainRequest(int i, Message message, WorkSource workSource) {
        RILRequest obtain = RILRequest.obtain(i, message, workSource);
        synchronized (this.mRequestList) {
            this.mRequestList.append(obtain.mSerial, obtain);
        }
        return obtain;
    }

    private RILRequest findAndRemoveRequestFromList(int i) {
        RILRequest rILRequest;
        synchronized (this.mRequestList) {
            rILRequest = this.mRequestList.get(i);
            if (rILRequest != null) {
                this.mRequestList.remove(i);
            }
        }
        return rILRequest;
    }

    public RILRequest processResponse(RadioResponseInfo radioResponseInfo) {
        int i = radioResponseInfo.serial;
        int i2 = radioResponseInfo.error;
        int i3 = radioResponseInfo.type;
        if (i3 != 0) {
            loge("processResponse: Unexpected response type " + i3);
        }
        RILRequest findAndRemoveRequestFromList = findAndRemoveRequestFromList(i);
        if (findAndRemoveRequestFromList != null) {
            return findAndRemoveRequestFromList;
        }
        loge("processResponse: Unexpected response! serial: " + i + " error: " + i2);
        return null;
    }

    public RILRequest processResponse(android.hardware.radio.V1_0.RadioResponseInfo radioResponseInfo) {
        int i = radioResponseInfo.serial;
        int i2 = radioResponseInfo.error;
        int i3 = radioResponseInfo.type;
        if (i3 != 0) {
            loge("processResponse: Unexpected response type " + i3);
        }
        RILRequest findAndRemoveRequestFromList = findAndRemoveRequestFromList(i);
        if (findAndRemoveRequestFromList != null) {
            return findAndRemoveRequestFromList;
        }
        loge("processResponse: Unexpected response! serial: " + i + " error: " + i2);
        return null;
    }

    public RILRequest processResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        int i = radioResponseInfo.serial;
        int i2 = radioResponseInfo.error;
        int i3 = radioResponseInfo.type;
        if (i3 != 0) {
            loge("processResponse: Unexpected response type " + i3);
        }
        RILRequest findAndRemoveRequestFromList = findAndRemoveRequestFromList(i);
        if (findAndRemoveRequestFromList != null) {
            return findAndRemoveRequestFromList;
        }
        loge("processResponse: Unexpected response! serial: " + i + " error: " + i2);
        return null;
    }

    public void getSimSlotsStatus(Message message) {
        RadioConfigProxy radioConfigProxy = getRadioConfigProxy(message);
        if (!radioConfigProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(200, message, this.mDefaultWorkSource);
            logd(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
            try {
                radioConfigProxy.getSimSlotStatus(obtainRequest.mSerial);
            } catch (RemoteException | RuntimeException e) {
                resetProxyAndRequestList("getSimSlotsStatus", e);
            }
        }
    }

    public void setPreferredDataModem(int i, Message message) {
        RadioConfigProxy radioConfigProxy = getRadioConfigProxy((Message) null);
        if (!radioConfigProxy.isEmpty()) {
            if (isSetPreferredDataCommandSupported()) {
                RILRequest obtainRequest = obtainRequest(204, message, this.mDefaultWorkSource);
                logd(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioConfigProxy.setPreferredDataModem(obtainRequest.mSerial, i);
                } catch (RemoteException | RuntimeException e) {
                    resetProxyAndRequestList("setPreferredDataModem", e);
                }
            } else if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void getPhoneCapability(Message message) {
        RadioConfigProxy radioConfigProxy = getRadioConfigProxy((Message) null);
        if (!radioConfigProxy.isEmpty()) {
            if (!radioConfigProxy.getVersion().less(RADIO_CONFIG_HAL_VERSION_1_1)) {
                RILRequest obtainRequest = obtainRequest(206, message, this.mDefaultWorkSource);
                logd(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioConfigProxy.getPhoneCapability(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    resetProxyAndRequestList("getPhoneCapability", e);
                }
            } else if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public boolean isSetPreferredDataCommandSupported() {
        RadioConfigProxy radioConfigProxy = getRadioConfigProxy((Message) null);
        return !radioConfigProxy.isEmpty() && radioConfigProxy.getVersion().greaterOrEqual(RADIO_CONFIG_HAL_VERSION_1_1);
    }

    public void setSimSlotsMapping(List<UiccSlotMapping> list, Message message) {
        RadioConfigProxy radioConfigProxy = getRadioConfigProxy(message);
        if (!radioConfigProxy.isEmpty()) {
            RILRequest obtainRequest = obtainRequest(201, message, this.mDefaultWorkSource);
            logd(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + " " + list);
            try {
                radioConfigProxy.setSimSlotsMapping(obtainRequest.mSerial, list);
            } catch (RemoteException | RuntimeException e) {
                resetProxyAndRequestList("setSimSlotsMapping", e);
            }
        }
    }

    public void setNumOfLiveModems(int i, Message message) {
        RadioConfigProxy radioConfigProxy = getRadioConfigProxy(message);
        if (!radioConfigProxy.isEmpty()) {
            if (!radioConfigProxy.getVersion().less(RADIO_CONFIG_HAL_VERSION_1_1)) {
                RILRequest obtainRequest = obtainRequest(207, message, this.mDefaultWorkSource);
                logd(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest) + ", numOfLiveModems = " + i);
                try {
                    radioConfigProxy.setNumOfLiveModems(obtainRequest.mSerial, i);
                } catch (RemoteException | RuntimeException e) {
                    resetProxyAndRequestList("setNumOfLiveModems", e);
                }
            } else if (message != null) {
                AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                message.sendToTarget();
            }
        }
    }

    public void registerForSimSlotStatusChanged(Handler handler, int i, Object obj) {
        this.mSimSlotStatusRegistrant = new Registrant(handler, i, obj);
    }

    public void unregisterForSimSlotStatusChanged(Handler handler) {
        Registrant registrant = this.mSimSlotStatusRegistrant;
        if (registrant != null && registrant.getHandler() == handler) {
            this.mSimSlotStatusRegistrant.clear();
            this.mSimSlotStatusRegistrant = null;
        }
    }

    public void getHalDeviceCapabilities(Message message) {
        RadioConfigProxy radioConfigProxy = getRadioConfigProxy(Message.obtain(message));
        if (!radioConfigProxy.isEmpty()) {
            if (!radioConfigProxy.getVersion().less(RADIO_CONFIG_HAL_VERSION_1_3)) {
                RILRequest obtainRequest = obtainRequest(220, message, this.mDefaultWorkSource);
                logd(obtainRequest.serialString() + "> " + RILUtils.requestToString(obtainRequest.mRequest));
                try {
                    radioConfigProxy.getHalDeviceCapabilities(obtainRequest.mSerial);
                } catch (RemoteException | RuntimeException e) {
                    resetProxyAndRequestList("getHalDeviceCapabilities", e);
                }
            } else if (message != null) {
                logd("RIL_REQUEST_GET_HAL_DEVICE_CAPABILITIES > REQUEST_NOT_SUPPORTED");
                AsyncResult.forMessage(message, radioConfigProxy.getFullCapabilitySet(), CommandException.fromRilErrno(6));
                message.sendToTarget();
            } else {
                logd("RIL_REQUEST_GET_HAL_DEVICE_CAPABILITIES > REQUEST_NOT_SUPPORTED on complete message not set.");
            }
        }
    }

    public int[] getDeviceNrCapabilities() {
        return this.mDeviceNrCapabilities;
    }

    private static void logd(String str) {
        Rlog.d(TAG, str);
    }

    private static void loge(String str) {
        Rlog.e(TAG, str);
    }
}
