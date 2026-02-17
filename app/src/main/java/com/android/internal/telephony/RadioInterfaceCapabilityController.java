package com.android.internal.telephony;

import android.os.AsyncResult;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.util.ArraySet;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.telephony.Rlog;
import java.util.Collections;
import java.util.Set;

public class RadioInterfaceCapabilityController extends Handler {
    private static final int EVENT_GET_HAL_DEVICE_CAPABILITIES_DONE = 100;
    private static final String LOG_TAG = RadioInterfaceCapabilityController.class.getSimpleName();
    private static RadioInterfaceCapabilityController sInstance;
    private final CommandsInterface mCommandsInterface;
    private final Object mLockRadioInterfaceCapabilities = new Object();
    private final RadioConfig mRadioConfig;
    private Set<String> mRadioInterfaceCapabilities;

    public static RadioInterfaceCapabilityController init(RadioConfig radioConfig, CommandsInterface commandsInterface) {
        RadioInterfaceCapabilityController radioInterfaceCapabilityController;
        synchronized (RadioInterfaceCapabilityController.class) {
            if (sInstance == null) {
                HandlerThread handlerThread = new HandlerThread("RHC");
                handlerThread.start();
                sInstance = new RadioInterfaceCapabilityController(radioConfig, commandsInterface, handlerThread.getLooper());
            } else {
                String str = LOG_TAG;
                Log.wtf(str, "init() called multiple times!  sInstance = " + sInstance);
            }
            radioInterfaceCapabilityController = sInstance;
        }
        return radioInterfaceCapabilityController;
    }

    public static RadioInterfaceCapabilityController getInstance() {
        if (sInstance == null) {
            Log.wtf(LOG_TAG, "getInstance null");
        }
        return sInstance;
    }

    @VisibleForTesting
    public RadioInterfaceCapabilityController(RadioConfig radioConfig, CommandsInterface commandsInterface, Looper looper) {
        super(looper);
        this.mRadioConfig = radioConfig;
        this.mCommandsInterface = commandsInterface;
        register();
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(7:7|8|9|(1:11)|12|13|(3:15|16|17)) */
    /* JADX WARNING: Missing exception handler attribute for start block: B:12:0x0027 */
    /* JADX WARNING: Removed duplicated region for block: B:15:0x002b  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.util.Set<java.lang.String> getCapabilities() {
        /*
            r4 = this;
            java.util.Set<java.lang.String> r0 = r4.mRadioInterfaceCapabilities
            if (r0 != 0) goto L_0x003c
            java.lang.Object r0 = r4.mLockRadioInterfaceCapabilities
            monitor-enter(r0)
            java.util.Set<java.lang.String> r1 = r4.mRadioInterfaceCapabilities     // Catch:{ all -> 0x0039 }
            if (r1 != 0) goto L_0x0037
            com.android.internal.telephony.RadioConfig r1 = r4.mRadioConfig     // Catch:{ all -> 0x0039 }
            r2 = 100
            android.os.Message r2 = r4.obtainMessage(r2)     // Catch:{ all -> 0x0039 }
            r1.getHalDeviceCapabilities(r2)     // Catch:{ all -> 0x0039 }
            android.os.Looper r1 = android.os.Looper.myLooper()     // Catch:{ InterruptedException -> 0x0027 }
            android.os.Looper r2 = r4.getLooper()     // Catch:{ InterruptedException -> 0x0027 }
            if (r1 == r2) goto L_0x0027
            java.lang.Object r1 = r4.mLockRadioInterfaceCapabilities     // Catch:{ InterruptedException -> 0x0027 }
            r2 = 2000(0x7d0, double:9.88E-321)
            r1.wait(r2)     // Catch:{ InterruptedException -> 0x0027 }
        L_0x0027:
            java.util.Set<java.lang.String> r1 = r4.mRadioInterfaceCapabilities     // Catch:{ all -> 0x0039 }
            if (r1 != 0) goto L_0x0037
            java.lang.String r4 = "getRadioInterfaceCapabilities: Radio Capabilities not loaded in time"
            loge(r4)     // Catch:{ all -> 0x0039 }
            android.util.ArraySet r4 = new android.util.ArraySet     // Catch:{ all -> 0x0039 }
            r4.<init>()     // Catch:{ all -> 0x0039 }
            monitor-exit(r0)     // Catch:{ all -> 0x0039 }
            return r4
        L_0x0037:
            monitor-exit(r0)     // Catch:{ all -> 0x0039 }
            goto L_0x003c
        L_0x0039:
            r4 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0039 }
            throw r4
        L_0x003c:
            java.util.Set<java.lang.String> r4 = r4.mRadioInterfaceCapabilities
            return r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RadioInterfaceCapabilityController.getCapabilities():java.util.Set");
    }

    private void setupCapabilities(AsyncResult asyncResult) {
        if (this.mRadioInterfaceCapabilities == null) {
            synchronized (this.mLockRadioInterfaceCapabilities) {
                if (this.mRadioInterfaceCapabilities == null) {
                    if (asyncResult.exception != null) {
                        loge("setupRadioInterfaceCapabilities: " + asyncResult.exception);
                    }
                    if (asyncResult.result == null) {
                        loge("setupRadioInterfaceCapabilities: ar.result is null");
                        return;
                    }
                    log("setupRadioInterfaceCapabilities: mRadioInterfaceCapabilities now setup");
                    Set<String> unmodifiableSet = Collections.unmodifiableSet((Set) asyncResult.result);
                    this.mRadioInterfaceCapabilities = unmodifiableSet;
                    if (unmodifiableSet != null) {
                        unregister();
                    }
                }
                this.mLockRadioInterfaceCapabilities.notify();
            }
        }
    }

    private void register() {
        CommandsInterface commandsInterface = this.mCommandsInterface;
        if (commandsInterface == null) {
            this.mRadioInterfaceCapabilities = Collections.unmodifiableSet(new ArraySet());
        } else {
            commandsInterface.registerForAvailable(this, 1, (Object) null);
        }
    }

    private void unregister() {
        this.mCommandsInterface.unregisterForAvailable(this);
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1 || i == 5) {
            getCapabilities();
        } else if (i == 100) {
            setupCapabilities((AsyncResult) message.obj);
        }
    }

    private static void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    private static void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }
}
