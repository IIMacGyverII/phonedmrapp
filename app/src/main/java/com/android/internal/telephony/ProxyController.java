package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.telephony.RadioAccessFamily;
import android.telephony.SubscriptionManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.data.PhoneSwitcher;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

public class ProxyController {
    protected static final int EVENT_APPLY_RC_RESPONSE = 3;
    protected static final int EVENT_FINISH_RC_RESPONSE = 4;
    @VisibleForTesting
    protected static final int EVENT_MULTI_SIM_CONFIG_CHANGED = 6;
    protected static final int EVENT_NOTIFICATION_RC_CHANGED = 1;
    @VisibleForTesting
    protected static final int EVENT_START_RC_RESPONSE = 2;
    protected static final int EVENT_TIMEOUT = 5;
    static final String LOG_TAG = "ProxyController";
    protected static final int SET_RC_STATUS_APPLYING = 3;
    protected static final int SET_RC_STATUS_FAIL = 5;
    protected static final int SET_RC_STATUS_IDLE = 0;
    protected static final int SET_RC_STATUS_STARTED = 2;
    protected static final int SET_RC_STATUS_STARTING = 1;
    protected static final int SET_RC_STATUS_SUCCESS = 4;
    protected static final int SET_RC_TIMEOUT_WAITING_MSEC = 45000;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static ProxyController sProxyController;
    protected Context mContext;
    protected String[] mCurrentLogicalModemIds;
    @VisibleForTesting
    protected final Handler mHandler = new Handler() {
        public void handleMessage(Message message) {
            ProxyController proxyController = ProxyController.this;
            proxyController.logd("handleMessage msg.what=" + message.what);
            switch (message.what) {
                case 1:
                    ProxyController.this.onNotificationRadioCapabilityChanged(message);
                    return;
                case 2:
                    ProxyController.this.onStartRadioCapabilityResponse(message);
                    return;
                case 3:
                    ProxyController.this.onApplyRadioCapabilityResponse(message);
                    return;
                case 4:
                    ProxyController.this.onFinishRadioCapabilityResponse(message);
                    return;
                case 5:
                    ProxyController.this.onTimeoutRadioCapability(message);
                    return;
                case 6:
                    ProxyController.this.onMultiSimConfigChanged();
                    return;
                default:
                    return;
            }
        }
    };
    protected String[] mNewLogicalModemIds;
    protected int[] mNewRadioAccessFamily;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int[] mOldRadioAccessFamily;
    protected PhoneSubInfoController mPhoneSubInfoController;
    protected PhoneSwitcher mPhoneSwitcher;
    protected Phone[] mPhones;
    protected int mRadioAccessFamilyStatusCounter;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mRadioCapabilitySessionId;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int[] mSetRadioAccessFamilyStatus;
    private SmsController mSmsController;
    protected boolean mTransactionFailed = false;
    protected UiccPhoneBookController mUiccPhoneBookController;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected AtomicInteger mUniqueIdGenerator = new AtomicInteger(new Random().nextInt());
    protected PowerManager.WakeLock mWakeLock;

    /* access modifiers changed from: protected */
    public void onApplyExceptionHandler(Message message) {
    }

    /* access modifiers changed from: protected */
    public void onApplyRadioCapabilityErrorHandler(Message message) {
    }

    public static ProxyController getInstance(Context context) {
        if (sProxyController == null) {
            sProxyController = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeProxyController(context);
        }
        return sProxyController;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static ProxyController getInstance() {
        return sProxyController;
    }

    public ProxyController(Context context) {
        int i = 0;
        logd("Constructor - Enter");
        this.mContext = context;
        this.mPhones = PhoneFactory.getPhones();
        this.mPhoneSwitcher = PhoneSwitcher.getInstance();
        this.mUiccPhoneBookController = new UiccPhoneBookController();
        this.mPhoneSubInfoController = new PhoneSubInfoController(this.mContext);
        this.mSmsController = new SmsController(this.mContext);
        Phone[] phoneArr = this.mPhones;
        this.mSetRadioAccessFamilyStatus = new int[phoneArr.length];
        this.mNewRadioAccessFamily = new int[phoneArr.length];
        this.mOldRadioAccessFamily = new int[phoneArr.length];
        this.mCurrentLogicalModemIds = new String[phoneArr.length];
        this.mNewLogicalModemIds = new String[phoneArr.length];
        PowerManager.WakeLock newWakeLock = ((PowerManager) context.getSystemService(XmlTagConst.TAG_POWER)).newWakeLock(1, LOG_TAG);
        this.mWakeLock = newWakeLock;
        newWakeLock.setReferenceCounted(false);
        clearTransaction();
        while (true) {
            Phone[] phoneArr2 = this.mPhones;
            if (i < phoneArr2.length) {
                phoneArr2[i].registerForRadioCapabilityChanged(this.mHandler, 1, (Object) null);
                i++;
            } else {
                PhoneConfigurationManager.registerForMultiSimConfigChange(this.mHandler, 6, (Object) null);
                logd("Constructor - Exit");
                return;
            }
        }
    }

    public void registerForAllDataDisconnected(int i, Handler handler, int i2) {
        int phoneId = SubscriptionController.getInstance().getPhoneId(i);
        if (SubscriptionManager.isValidPhoneId(phoneId)) {
            this.mPhones[phoneId].registerForAllDataDisconnected(handler, i2);
        }
    }

    public void unregisterForAllDataDisconnected(int i, Handler handler) {
        int phoneId = SubscriptionController.getInstance().getPhoneId(i);
        if (SubscriptionManager.isValidPhoneId(phoneId)) {
            this.mPhones[phoneId].unregisterForAllDataDisconnected(handler);
        }
    }

    public boolean areAllDataDisconnected(int i) {
        int phoneId = SubscriptionController.getInstance().getPhoneId(i);
        if (SubscriptionManager.isValidPhoneId(phoneId)) {
            return this.mPhones[phoneId].areAllDataDisconnected();
        }
        return true;
    }

    public int getRadioAccessFamily(int i) {
        Phone[] phoneArr = this.mPhones;
        if (i >= phoneArr.length) {
            return 0;
        }
        return phoneArr[i].getRadioAccessFamily();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:16:0x0036, code lost:
        r3 = true;
        r1 = 0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:17:0x0039, code lost:
        r4 = r6.mPhones;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:18:0x003c, code lost:
        if (r1 >= r4.length) goto L_0x0050;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:20:0x004a, code lost:
        if (r4[r1].getRadioAccessFamily() == r7[r1].getRadioAccessFamily()) goto L_0x004d;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:21:0x004c, code lost:
        r3 = false;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:22:0x004d, code lost:
        r1 = r1 + 1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:23:0x0050, code lost:
        if (r3 == false) goto L_0x0058;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:24:0x0052, code lost:
        logd("setRadioCapability: Already in requested configuration, nothing to do.");
     */
    /* JADX WARNING: Code restructure failed: missing block: B:25:0x0057, code lost:
        return true;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:26:0x0058, code lost:
        clearTransaction();
        r6.mWakeLock.acquire();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:27:0x0064, code lost:
        return doSetRadioCapabilities(r7);
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean setRadioCapability(android.telephony.RadioAccessFamily[] r7) {
        /*
            r6 = this;
            int r0 = r7.length
            com.android.internal.telephony.Phone[] r1 = r6.mPhones
            int r1 = r1.length
            r2 = 0
            if (r0 == r1) goto L_0x0008
            return r2
        L_0x0008:
            int[] r0 = r6.mSetRadioAccessFamilyStatus
            monitor-enter(r0)
            r1 = r2
        L_0x000c:
            com.android.internal.telephony.Phone[] r3 = r6.mPhones     // Catch:{ all -> 0x0065 }
            int r3 = r3.length     // Catch:{ all -> 0x0065 }
            if (r1 >= r3) goto L_0x0035
            int[] r3 = r6.mSetRadioAccessFamilyStatus     // Catch:{ all -> 0x0065 }
            r3 = r3[r1]     // Catch:{ all -> 0x0065 }
            if (r3 == 0) goto L_0x0032
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x0065 }
            r7.<init>()     // Catch:{ all -> 0x0065 }
            java.lang.String r3 = "setRadioCapability: Phone["
            r7.append(r3)     // Catch:{ all -> 0x0065 }
            r7.append(r1)     // Catch:{ all -> 0x0065 }
            java.lang.String r1 = "] is not idle. Rejecting request."
            r7.append(r1)     // Catch:{ all -> 0x0065 }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x0065 }
            r6.loge(r7)     // Catch:{ all -> 0x0065 }
            monitor-exit(r0)     // Catch:{ all -> 0x0065 }
            return r2
        L_0x0032:
            int r1 = r1 + 1
            goto L_0x000c
        L_0x0035:
            monitor-exit(r0)     // Catch:{ all -> 0x0065 }
            r0 = 1
            r3 = r0
            r1 = r2
        L_0x0039:
            com.android.internal.telephony.Phone[] r4 = r6.mPhones
            int r5 = r4.length
            if (r1 >= r5) goto L_0x0050
            r4 = r4[r1]
            int r4 = r4.getRadioAccessFamily()
            r5 = r7[r1]
            int r5 = r5.getRadioAccessFamily()
            if (r4 == r5) goto L_0x004d
            r3 = r2
        L_0x004d:
            int r1 = r1 + 1
            goto L_0x0039
        L_0x0050:
            if (r3 == 0) goto L_0x0058
            java.lang.String r7 = "setRadioCapability: Already in requested configuration, nothing to do."
            r6.logd(r7)
            return r0
        L_0x0058:
            r6.clearTransaction()
            android.os.PowerManager$WakeLock r0 = r6.mWakeLock
            r0.acquire()
            boolean r6 = r6.doSetRadioCapabilities(r7)
            return r6
        L_0x0065:
            r6 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0065 }
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ProxyController.setRadioCapability(android.telephony.RadioAccessFamily[]):boolean");
    }

    public SmsController getSmsController() {
        return this.mSmsController;
    }

    /* access modifiers changed from: protected */
    public boolean doSetRadioCapabilities(RadioAccessFamily[] radioAccessFamilyArr) {
        int andIncrement = this.mUniqueIdGenerator.getAndIncrement();
        this.mRadioCapabilitySessionId = andIncrement;
        this.mHandler.sendMessageDelayed(this.mHandler.obtainMessage(5, andIncrement, 0), 45000);
        synchronized (this.mSetRadioAccessFamilyStatus) {
            logd("setRadioCapability: new request session id=" + this.mRadioCapabilitySessionId);
            resetRadioAccessFamilyStatusCounter();
            for (int i = 0; i < radioAccessFamilyArr.length; i++) {
                int phoneId = radioAccessFamilyArr[i].getPhoneId();
                logd("setRadioCapability: phoneId=" + phoneId + " status=STARTING");
                this.mSetRadioAccessFamilyStatus[phoneId] = 1;
                this.mOldRadioAccessFamily[phoneId] = this.mPhones[phoneId].getRadioAccessFamily();
                int radioAccessFamily = radioAccessFamilyArr[i].getRadioAccessFamily();
                this.mNewRadioAccessFamily[phoneId] = radioAccessFamily;
                this.mCurrentLogicalModemIds[phoneId] = this.mPhones[phoneId].getModemUuId();
                this.mNewLogicalModemIds[phoneId] = getLogicalModemIdFromRaf(radioAccessFamily);
                logd("setRadioCapability: mOldRadioAccessFamily[" + phoneId + "]=" + this.mOldRadioAccessFamily[phoneId]);
                logd("setRadioCapability: mNewRadioAccessFamily[" + phoneId + "]=" + this.mNewRadioAccessFamily[phoneId]);
                sendRadioCapabilityRequest(phoneId, this.mRadioCapabilitySessionId, 1, this.mOldRadioAccessFamily[phoneId], this.mCurrentLogicalModemIds[phoneId], 0, 2);
            }
        }
        return true;
    }

    /* access modifiers changed from: private */
    public void onMultiSimConfigChanged() {
        int length = this.mPhones.length;
        Phone[] phones = PhoneFactory.getPhones();
        this.mPhones = phones;
        this.mSetRadioAccessFamilyStatus = Arrays.copyOf(this.mSetRadioAccessFamilyStatus, phones.length);
        this.mNewRadioAccessFamily = Arrays.copyOf(this.mNewRadioAccessFamily, this.mPhones.length);
        this.mOldRadioAccessFamily = Arrays.copyOf(this.mOldRadioAccessFamily, this.mPhones.length);
        this.mCurrentLogicalModemIds = (String[]) Arrays.copyOf(this.mCurrentLogicalModemIds, this.mPhones.length);
        this.mNewLogicalModemIds = (String[]) Arrays.copyOf(this.mNewLogicalModemIds, this.mPhones.length);
        clearTransaction();
        while (true) {
            Phone[] phoneArr = this.mPhones;
            if (length < phoneArr.length) {
                phoneArr[length].registerForRadioCapabilityChanged(this.mHandler, 1, (Object) null);
                length++;
            } else {
                return;
            }
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:46:0x0158, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onStartRadioCapabilityResponse(android.os.Message r10) {
        /*
            r9 = this;
            int[] r0 = r9.mSetRadioAccessFamilyStatus
            monitor-enter(r0)
            java.lang.Object r1 = r10.obj     // Catch:{ all -> 0x0179 }
            android.os.AsyncResult r1 = (android.os.AsyncResult) r1     // Catch:{ all -> 0x0179 }
            java.lang.Throwable r2 = r1.exception     // Catch:{ all -> 0x0179 }
            r3 = 0
            r4 = 1
            if (r2 == 0) goto L_0x0059
            boolean r5 = r2 instanceof com.android.internal.telephony.CommandException     // Catch:{ all -> 0x0179 }
            if (r5 == 0) goto L_0x001d
            com.android.internal.telephony.CommandException r2 = (com.android.internal.telephony.CommandException) r2     // Catch:{ all -> 0x0179 }
            com.android.internal.telephony.CommandException$Error r2 = r2.getCommandError()     // Catch:{ all -> 0x0179 }
            com.android.internal.telephony.CommandException$Error r5 = com.android.internal.telephony.CommandException.Error.REQUEST_NOT_SUPPORTED     // Catch:{ all -> 0x0179 }
            if (r2 != r5) goto L_0x001d
            r2 = r4
            goto L_0x001e
        L_0x001d:
            r2 = r3
        L_0x001e:
            android.telephony.TelephonyManager r5 = android.telephony.TelephonyManager.getDefault()     // Catch:{ all -> 0x0179 }
            int r5 = r5.getPhoneCount()     // Catch:{ all -> 0x0179 }
            if (r5 == r4) goto L_0x002a
            if (r2 == 0) goto L_0x0059
        L_0x002a:
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ all -> 0x0179 }
            r10.<init>()     // Catch:{ all -> 0x0179 }
            java.lang.String r2 = "onStartRadioCapabilityResponse got exception="
            r10.append(r2)     // Catch:{ all -> 0x0179 }
            java.lang.Throwable r1 = r1.exception     // Catch:{ all -> 0x0179 }
            r10.append(r1)     // Catch:{ all -> 0x0179 }
            java.lang.String r10 = r10.toString()     // Catch:{ all -> 0x0179 }
            r9.logd(r10)     // Catch:{ all -> 0x0179 }
            java.util.concurrent.atomic.AtomicInteger r10 = r9.mUniqueIdGenerator     // Catch:{ all -> 0x0179 }
            int r10 = r10.getAndIncrement()     // Catch:{ all -> 0x0179 }
            r9.mRadioCapabilitySessionId = r10     // Catch:{ all -> 0x0179 }
            android.content.Intent r10 = new android.content.Intent     // Catch:{ all -> 0x0179 }
            java.lang.String r1 = "android.intent.action.ACTION_SET_RADIO_CAPABILITY_FAILED"
            r10.<init>(r1)     // Catch:{ all -> 0x0179 }
            android.content.Context r1 = r9.mContext     // Catch:{ all -> 0x0179 }
            r1.sendBroadcast(r10)     // Catch:{ all -> 0x0179 }
            r9.clearTransaction()     // Catch:{ all -> 0x0179 }
            monitor-exit(r0)     // Catch:{ all -> 0x0179 }
            return
        L_0x0059:
            java.lang.Object r10 = r10.obj     // Catch:{ all -> 0x0179 }
            android.os.AsyncResult r10 = (android.os.AsyncResult) r10     // Catch:{ all -> 0x0179 }
            java.lang.Object r10 = r10.result     // Catch:{ all -> 0x0179 }
            com.android.internal.telephony.RadioCapability r10 = (com.android.internal.telephony.RadioCapability) r10     // Catch:{ all -> 0x0179 }
            if (r10 == 0) goto L_0x0159
            int r2 = r10.getSession()     // Catch:{ all -> 0x0179 }
            int r5 = r9.mRadioCapabilitySessionId     // Catch:{ all -> 0x0179 }
            if (r2 == r5) goto L_0x006d
            goto L_0x0159
        L_0x006d:
            int r2 = r9.mRadioAccessFamilyStatusCounter     // Catch:{ all -> 0x0179 }
            int r2 = r2 - r4
            r9.mRadioAccessFamilyStatusCounter = r2     // Catch:{ all -> 0x0179 }
            int r2 = r10.getPhoneId()     // Catch:{ all -> 0x0179 }
            java.lang.Throwable r1 = r1.exception     // Catch:{ all -> 0x0179 }
            if (r1 == 0) goto L_0x00b3
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0179 }
            r1.<init>()     // Catch:{ all -> 0x0179 }
            java.lang.String r5 = "onStartRadioCapabilityResponse: Error response session="
            r1.append(r5)     // Catch:{ all -> 0x0179 }
            int r10 = r10.getSession()     // Catch:{ all -> 0x0179 }
            r1.append(r10)     // Catch:{ all -> 0x0179 }
            java.lang.String r10 = r1.toString()     // Catch:{ all -> 0x0179 }
            r9.logd(r10)     // Catch:{ all -> 0x0179 }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ all -> 0x0179 }
            r10.<init>()     // Catch:{ all -> 0x0179 }
            java.lang.String r1 = "onStartRadioCapabilityResponse: phoneId="
            r10.append(r1)     // Catch:{ all -> 0x0179 }
            r10.append(r2)     // Catch:{ all -> 0x0179 }
            java.lang.String r1 = " status=FAIL"
            r10.append(r1)     // Catch:{ all -> 0x0179 }
            java.lang.String r10 = r10.toString()     // Catch:{ all -> 0x0179 }
            r9.logd(r10)     // Catch:{ all -> 0x0179 }
            int[] r10 = r9.mSetRadioAccessFamilyStatus     // Catch:{ all -> 0x0179 }
            r1 = 5
            r10[r2] = r1     // Catch:{ all -> 0x0179 }
            r9.mTransactionFailed = r4     // Catch:{ all -> 0x0179 }
            goto L_0x00d1
        L_0x00b3:
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ all -> 0x0179 }
            r10.<init>()     // Catch:{ all -> 0x0179 }
            java.lang.String r1 = "onStartRadioCapabilityResponse: phoneId="
            r10.append(r1)     // Catch:{ all -> 0x0179 }
            r10.append(r2)     // Catch:{ all -> 0x0179 }
            java.lang.String r1 = " status=STARTED"
            r10.append(r1)     // Catch:{ all -> 0x0179 }
            java.lang.String r10 = r10.toString()     // Catch:{ all -> 0x0179 }
            r9.logd(r10)     // Catch:{ all -> 0x0179 }
            int[] r10 = r9.mSetRadioAccessFamilyStatus     // Catch:{ all -> 0x0179 }
            r1 = 2
            r10[r2] = r1     // Catch:{ all -> 0x0179 }
        L_0x00d1:
            int r10 = r9.mRadioAccessFamilyStatusCounter     // Catch:{ all -> 0x0179 }
            if (r10 != 0) goto L_0x0157
            java.util.HashSet r10 = new java.util.HashSet     // Catch:{ all -> 0x0179 }
            java.lang.String[] r1 = r9.mNewLogicalModemIds     // Catch:{ all -> 0x0179 }
            int r1 = r1.length     // Catch:{ all -> 0x0179 }
            r10.<init>(r1)     // Catch:{ all -> 0x0179 }
            java.lang.String[] r1 = r9.mNewLogicalModemIds     // Catch:{ all -> 0x0179 }
            int r2 = r1.length     // Catch:{ all -> 0x0179 }
            r5 = r3
        L_0x00e1:
            if (r5 >= r2) goto L_0x00f7
            r6 = r1[r5]     // Catch:{ all -> 0x0179 }
            boolean r6 = r10.add(r6)     // Catch:{ all -> 0x0179 }
            if (r6 != 0) goto L_0x00f4
            r9.mTransactionFailed = r4     // Catch:{ all -> 0x0179 }
            java.lang.String r6 = "ProxyController"
            java.lang.String r7 = "ERROR: sending down the same id for different phones"
            android.util.Log.wtf(r6, r7)     // Catch:{ all -> 0x0179 }
        L_0x00f4:
            int r5 = r5 + 1
            goto L_0x00e1
        L_0x00f7:
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ all -> 0x0179 }
            r10.<init>()     // Catch:{ all -> 0x0179 }
            java.lang.String r1 = "onStartRadioCapabilityResponse: success="
            r10.append(r1)     // Catch:{ all -> 0x0179 }
            boolean r1 = r9.mTransactionFailed     // Catch:{ all -> 0x0179 }
            if (r1 != 0) goto L_0x0106
            goto L_0x0107
        L_0x0106:
            r4 = r3
        L_0x0107:
            r10.append(r4)     // Catch:{ all -> 0x0179 }
            java.lang.String r10 = r10.toString()     // Catch:{ all -> 0x0179 }
            r9.logd(r10)     // Catch:{ all -> 0x0179 }
            boolean r10 = r9.mTransactionFailed     // Catch:{ all -> 0x0179 }
            if (r10 == 0) goto L_0x011b
            int r10 = r9.mRadioCapabilitySessionId     // Catch:{ all -> 0x0179 }
            r9.issueFinish(r10)     // Catch:{ all -> 0x0179 }
            goto L_0x0157
        L_0x011b:
            r9.resetRadioAccessFamilyStatusCounter()     // Catch:{ all -> 0x0179 }
            r10 = r3
        L_0x011f:
            com.android.internal.telephony.Phone[] r1 = r9.mPhones     // Catch:{ all -> 0x0179 }
            int r1 = r1.length     // Catch:{ all -> 0x0179 }
            if (r10 >= r1) goto L_0x0157
            int r3 = r9.mRadioCapabilitySessionId     // Catch:{ all -> 0x0179 }
            r4 = 2
            int[] r1 = r9.mNewRadioAccessFamily     // Catch:{ all -> 0x0179 }
            r5 = r1[r10]     // Catch:{ all -> 0x0179 }
            java.lang.String[] r1 = r9.mNewLogicalModemIds     // Catch:{ all -> 0x0179 }
            r6 = r1[r10]     // Catch:{ all -> 0x0179 }
            r7 = 0
            r8 = 3
            r1 = r9
            r2 = r10
            r1.sendRadioCapabilityRequest(r2, r3, r4, r5, r6, r7, r8)     // Catch:{ all -> 0x0179 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0179 }
            r1.<init>()     // Catch:{ all -> 0x0179 }
            java.lang.String r2 = "onStartRadioCapabilityResponse: phoneId="
            r1.append(r2)     // Catch:{ all -> 0x0179 }
            r1.append(r10)     // Catch:{ all -> 0x0179 }
            java.lang.String r2 = " status=APPLYING"
            r1.append(r2)     // Catch:{ all -> 0x0179 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x0179 }
            r9.logd(r1)     // Catch:{ all -> 0x0179 }
            int[] r1 = r9.mSetRadioAccessFamilyStatus     // Catch:{ all -> 0x0179 }
            r2 = 3
            r1[r10] = r2     // Catch:{ all -> 0x0179 }
            int r10 = r10 + 1
            goto L_0x011f
        L_0x0157:
            monitor-exit(r0)     // Catch:{ all -> 0x0179 }
            return
        L_0x0159:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0179 }
            r1.<init>()     // Catch:{ all -> 0x0179 }
            java.lang.String r2 = "onStartRadioCapabilityResponse: Ignore session="
            r1.append(r2)     // Catch:{ all -> 0x0179 }
            int r2 = r9.mRadioCapabilitySessionId     // Catch:{ all -> 0x0179 }
            r1.append(r2)     // Catch:{ all -> 0x0179 }
            java.lang.String r2 = " rc="
            r1.append(r2)     // Catch:{ all -> 0x0179 }
            r1.append(r10)     // Catch:{ all -> 0x0179 }
            java.lang.String r10 = r1.toString()     // Catch:{ all -> 0x0179 }
            r9.logd(r10)     // Catch:{ all -> 0x0179 }
            monitor-exit(r0)     // Catch:{ all -> 0x0179 }
            return
        L_0x0179:
            r9 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0179 }
            throw r9
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ProxyController.onStartRadioCapabilityResponse(android.os.Message):void");
    }

    /* access modifiers changed from: protected */
    public void onApplyRadioCapabilityResponse(Message message) {
        RadioCapability radioCapability = (RadioCapability) ((AsyncResult) message.obj).result;
        if (radioCapability == null || radioCapability.getSession() != this.mRadioCapabilitySessionId) {
            logd("onApplyRadioCapabilityResponse: Ignore session=" + this.mRadioCapabilitySessionId + " rc=" + radioCapability);
            onApplyRadioCapabilityErrorHandler(message);
            return;
        }
        logd("onApplyRadioCapabilityResponse: rc=" + radioCapability);
        if (((AsyncResult) message.obj).exception != null) {
            synchronized (this.mSetRadioAccessFamilyStatus) {
                logd("onApplyRadioCapabilityResponse: Error response session=" + radioCapability.getSession());
                int phoneId = radioCapability.getPhoneId();
                onApplyExceptionHandler(message);
                logd("onApplyRadioCapabilityResponse: phoneId=" + phoneId + " status=FAIL");
                this.mSetRadioAccessFamilyStatus[phoneId] = 5;
                this.mTransactionFailed = true;
            }
            return;
        }
        logd("onApplyRadioCapabilityResponse: Valid start expecting notification rc=" + radioCapability);
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:23:0x00d6, code lost:
        return;
     */
    /* JADX WARNING: Removed duplicated region for block: B:21:0x00ba  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onNotificationRadioCapabilityChanged(android.os.Message r6) {
        /*
            r5 = this;
            java.lang.Object r0 = r6.obj
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0
            java.lang.Object r0 = r0.result
            com.android.internal.telephony.RadioCapability r0 = (com.android.internal.telephony.RadioCapability) r0
            if (r0 == 0) goto L_0x00da
            int r1 = r0.getSession()
            int r2 = r5.mRadioCapabilitySessionId
            if (r1 == r2) goto L_0x0014
            goto L_0x00da
        L_0x0014:
            int[] r1 = r5.mSetRadioAccessFamilyStatus
            monitor-enter(r1)
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d7 }
            r2.<init>()     // Catch:{ all -> 0x00d7 }
            java.lang.String r3 = "onNotificationRadioCapabilityChanged: rc="
            r2.append(r3)     // Catch:{ all -> 0x00d7 }
            r2.append(r0)     // Catch:{ all -> 0x00d7 }
            java.lang.String r2 = r2.toString()     // Catch:{ all -> 0x00d7 }
            r5.logd(r2)     // Catch:{ all -> 0x00d7 }
            int r2 = r0.getSession()     // Catch:{ all -> 0x00d7 }
            int r3 = r5.mRadioCapabilitySessionId     // Catch:{ all -> 0x00d7 }
            if (r2 == r3) goto L_0x0053
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d7 }
            r6.<init>()     // Catch:{ all -> 0x00d7 }
            java.lang.String r2 = "onNotificationRadioCapabilityChanged: Ignore session="
            r6.append(r2)     // Catch:{ all -> 0x00d7 }
            int r2 = r5.mRadioCapabilitySessionId     // Catch:{ all -> 0x00d7 }
            r6.append(r2)     // Catch:{ all -> 0x00d7 }
            java.lang.String r2 = " rc="
            r6.append(r2)     // Catch:{ all -> 0x00d7 }
            r6.append(r0)     // Catch:{ all -> 0x00d7 }
            java.lang.String r6 = r6.toString()     // Catch:{ all -> 0x00d7 }
            r5.logd(r6)     // Catch:{ all -> 0x00d7 }
            monitor-exit(r1)     // Catch:{ all -> 0x00d7 }
            return
        L_0x0053:
            int r2 = r0.getPhoneId()     // Catch:{ all -> 0x00d7 }
            java.lang.Object r6 = r6.obj     // Catch:{ all -> 0x00d7 }
            android.os.AsyncResult r6 = (android.os.AsyncResult) r6     // Catch:{ all -> 0x00d7 }
            java.lang.Throwable r6 = r6.exception     // Catch:{ all -> 0x00d7 }
            r3 = 1
            if (r6 != 0) goto L_0x0093
            int r6 = r0.getStatus()     // Catch:{ all -> 0x00d7 }
            r4 = 2
            if (r6 != r4) goto L_0x0068
            goto L_0x0093
        L_0x0068:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d7 }
            r6.<init>()     // Catch:{ all -> 0x00d7 }
            java.lang.String r4 = "onNotificationRadioCapabilityChanged: phoneId="
            r6.append(r4)     // Catch:{ all -> 0x00d7 }
            r6.append(r2)     // Catch:{ all -> 0x00d7 }
            java.lang.String r4 = " status=SUCCESS"
            r6.append(r4)     // Catch:{ all -> 0x00d7 }
            java.lang.String r6 = r6.toString()     // Catch:{ all -> 0x00d7 }
            r5.logd(r6)     // Catch:{ all -> 0x00d7 }
            int[] r6 = r5.mSetRadioAccessFamilyStatus     // Catch:{ all -> 0x00d7 }
            r4 = 4
            r6[r2] = r4     // Catch:{ all -> 0x00d7 }
            com.android.internal.telephony.data.PhoneSwitcher r6 = r5.mPhoneSwitcher     // Catch:{ all -> 0x00d7 }
            r6.onRadioCapChanged(r2)     // Catch:{ all -> 0x00d7 }
            com.android.internal.telephony.Phone[] r6 = r5.mPhones     // Catch:{ all -> 0x00d7 }
            r6 = r6[r2]     // Catch:{ all -> 0x00d7 }
            r6.radioCapabilityUpdated(r0, r3)     // Catch:{ all -> 0x00d7 }
            goto L_0x00b3
        L_0x0093:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d7 }
            r6.<init>()     // Catch:{ all -> 0x00d7 }
            java.lang.String r0 = "onNotificationRadioCapabilityChanged: phoneId="
            r6.append(r0)     // Catch:{ all -> 0x00d7 }
            r6.append(r2)     // Catch:{ all -> 0x00d7 }
            java.lang.String r0 = " status=FAIL"
            r6.append(r0)     // Catch:{ all -> 0x00d7 }
            java.lang.String r6 = r6.toString()     // Catch:{ all -> 0x00d7 }
            r5.logd(r6)     // Catch:{ all -> 0x00d7 }
            int[] r6 = r5.mSetRadioAccessFamilyStatus     // Catch:{ all -> 0x00d7 }
            r0 = 5
            r6[r2] = r0     // Catch:{ all -> 0x00d7 }
            r5.mTransactionFailed = r3     // Catch:{ all -> 0x00d7 }
        L_0x00b3:
            int r6 = r5.mRadioAccessFamilyStatusCounter     // Catch:{ all -> 0x00d7 }
            int r6 = r6 - r3
            r5.mRadioAccessFamilyStatusCounter = r6     // Catch:{ all -> 0x00d7 }
            if (r6 != 0) goto L_0x00d5
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d7 }
            r6.<init>()     // Catch:{ all -> 0x00d7 }
            java.lang.String r0 = "onNotificationRadioCapabilityChanged: APPLY URC success="
            r6.append(r0)     // Catch:{ all -> 0x00d7 }
            boolean r0 = r5.mTransactionFailed     // Catch:{ all -> 0x00d7 }
            r6.append(r0)     // Catch:{ all -> 0x00d7 }
            java.lang.String r6 = r6.toString()     // Catch:{ all -> 0x00d7 }
            r5.logd(r6)     // Catch:{ all -> 0x00d7 }
            int r6 = r5.mRadioCapabilitySessionId     // Catch:{ all -> 0x00d7 }
            r5.issueFinish(r6)     // Catch:{ all -> 0x00d7 }
        L_0x00d5:
            monitor-exit(r1)     // Catch:{ all -> 0x00d7 }
            return
        L_0x00d7:
            r5 = move-exception
            monitor-exit(r1)     // Catch:{ all -> 0x00d7 }
            throw r5
        L_0x00da:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r1 = "onNotificationRadioCapabilityChanged: Ignore session="
            r6.append(r1)
            int r1 = r5.mRadioCapabilitySessionId
            r6.append(r1)
            java.lang.String r1 = " rc="
            r6.append(r1)
            r6.append(r0)
            java.lang.String r6 = r6.toString()
            r5.logd(r6)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ProxyController.onNotificationRadioCapabilityChanged(android.os.Message):void");
    }

    /* access modifiers changed from: protected */
    public void onFinishRadioCapabilityResponse(Message message) {
        RadioCapability radioCapability = (RadioCapability) ((AsyncResult) message.obj).result;
        if (radioCapability == null || radioCapability.getSession() != this.mRadioCapabilitySessionId) {
            logd("onFinishRadioCapabilityResponse: Ignore session=" + this.mRadioCapabilitySessionId + " rc=" + radioCapability);
            return;
        }
        synchronized (this.mSetRadioAccessFamilyStatus) {
            logd(" onFinishRadioCapabilityResponse mRadioAccessFamilyStatusCounter=" + this.mRadioAccessFamilyStatusCounter);
            int i = this.mRadioAccessFamilyStatusCounter + -1;
            this.mRadioAccessFamilyStatusCounter = i;
            if (i == 0) {
                completeRadioCapabilityTransaction();
            }
        }
    }

    /* access modifiers changed from: protected */
    public void onTimeoutRadioCapability(Message message) {
        if (message.arg1 != this.mRadioCapabilitySessionId) {
            logd("RadioCapability timeout: Ignore msg.arg1=" + message.arg1 + "!= mRadioCapabilitySessionId=" + this.mRadioCapabilitySessionId);
            return;
        }
        synchronized (this.mSetRadioAccessFamilyStatus) {
            for (int i = 0; i < this.mPhones.length; i++) {
                logd("RadioCapability timeout: mSetRadioAccessFamilyStatus[" + i + "]=" + this.mSetRadioAccessFamilyStatus[i]);
            }
            int andIncrement = this.mUniqueIdGenerator.getAndIncrement();
            this.mRadioCapabilitySessionId = andIncrement;
            this.mRadioAccessFamilyStatusCounter = 0;
            this.mTransactionFailed = true;
            issueFinish(andIncrement);
        }
    }

    /* access modifiers changed from: protected */
    public void issueFinish(int i) {
        int i2;
        String str;
        synchronized (this.mSetRadioAccessFamilyStatus) {
            for (int i3 = 0; i3 < this.mPhones.length; i3++) {
                logd("issueFinish: phoneId=" + i3 + " sessionId=" + i + " mTransactionFailed=" + this.mTransactionFailed);
                this.mRadioAccessFamilyStatusCounter = this.mRadioAccessFamilyStatusCounter + 1;
                boolean z = this.mTransactionFailed;
                if (z) {
                    i2 = this.mOldRadioAccessFamily[i3];
                } else {
                    i2 = this.mNewRadioAccessFamily[i3];
                }
                int i4 = i2;
                if (z) {
                    str = this.mCurrentLogicalModemIds[i3];
                } else {
                    str = this.mNewLogicalModemIds[i3];
                }
                sendRadioCapabilityRequest(i3, i, 4, i4, str, z ? 2 : 1, 4);
                if (this.mTransactionFailed) {
                    logd("issueFinish: phoneId: " + i3 + " status: FAIL");
                    this.mSetRadioAccessFamilyStatus[i3] = 5;
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void completeRadioCapabilityTransaction() {
        Intent intent;
        StringBuilder sb = new StringBuilder();
        sb.append("onFinishRadioCapabilityResponse: success=");
        sb.append(!this.mTransactionFailed);
        logd(sb.toString());
        int i = 0;
        if (!this.mTransactionFailed) {
            ArrayList arrayList = new ArrayList();
            while (true) {
                Phone[] phoneArr = this.mPhones;
                if (i >= phoneArr.length) {
                    break;
                }
                int radioAccessFamily = phoneArr[i].getRadioAccessFamily();
                logd("radioAccessFamily[" + i + "]=" + radioAccessFamily);
                arrayList.add(new RadioAccessFamily(i, radioAccessFamily));
                i++;
            }
            intent = new Intent("android.intent.action.ACTION_SET_RADIO_CAPABILITY_DONE");
            intent.putParcelableArrayListExtra("rafs", arrayList);
            this.mRadioCapabilitySessionId = this.mUniqueIdGenerator.getAndIncrement();
            clearTransaction();
        } else {
            Intent intent2 = new Intent("android.intent.action.ACTION_SET_RADIO_CAPABILITY_FAILED");
            this.mTransactionFailed = false;
            RadioAccessFamily[] radioAccessFamilyArr = new RadioAccessFamily[this.mPhones.length];
            while (i < this.mPhones.length) {
                radioAccessFamilyArr[i] = new RadioAccessFamily(i, this.mOldRadioAccessFamily[i]);
                i++;
            }
            doSetRadioCapabilities(radioAccessFamilyArr);
            intent = intent2;
        }
        this.mContext.sendBroadcast(intent, "android.permission.READ_PHONE_STATE");
    }

    /* access modifiers changed from: protected */
    public void clearTransaction() {
        logd("clearTransaction");
        synchronized (this.mSetRadioAccessFamilyStatus) {
            for (int i = 0; i < this.mPhones.length; i++) {
                logd("clearTransaction: phoneId=" + i + " status=IDLE");
                this.mSetRadioAccessFamilyStatus[i] = 0;
                this.mOldRadioAccessFamily[i] = 0;
                this.mNewRadioAccessFamily[i] = 0;
                this.mTransactionFailed = false;
            }
            if (isWakeLockHeld()) {
                this.mWakeLock.release();
            }
        }
    }

    @VisibleForTesting
    public boolean isWakeLockHeld() {
        boolean isHeld;
        synchronized (this.mSetRadioAccessFamilyStatus) {
            isHeld = this.mWakeLock.isHeld();
        }
        return isHeld;
    }

    /* access modifiers changed from: protected */
    public void resetRadioAccessFamilyStatusCounter() {
        this.mRadioAccessFamilyStatusCounter = this.mPhones.length;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void sendRadioCapabilityRequest(int i, int i2, int i3, int i4, String str, int i5, int i6) {
        this.mPhones[i].setRadioCapability(new RadioCapability(i, i2, i3, i4, str, i5), this.mHandler.obtainMessage(i6));
    }

    public int getMaxRafSupported() {
        int[] iArr = new int[this.mPhones.length];
        int i = 0;
        int i2 = 0;
        int i3 = 0;
        while (true) {
            Phone[] phoneArr = this.mPhones;
            if (i >= phoneArr.length) {
                return i2;
            }
            int bitCount = Integer.bitCount(phoneArr[i].getRadioAccessFamily());
            iArr[i] = bitCount;
            if (i3 < bitCount) {
                i2 = this.mPhones[i].getRadioAccessFamily();
                i3 = bitCount;
            }
            i++;
        }
    }

    public int getMinRafSupported() {
        int[] iArr = new int[this.mPhones.length];
        int i = 0;
        int i2 = 0;
        int i3 = 0;
        while (true) {
            Phone[] phoneArr = this.mPhones;
            if (i >= phoneArr.length) {
                return i2;
            }
            int bitCount = Integer.bitCount(phoneArr[i].getRadioAccessFamily());
            iArr[i] = bitCount;
            if (i3 == 0 || i3 > bitCount) {
                i2 = this.mPhones[i].getRadioAccessFamily();
                i3 = bitCount;
            }
            i++;
        }
    }

    /* access modifiers changed from: protected */
    public String getLogicalModemIdFromRaf(int i) {
        int i2 = 0;
        while (true) {
            Phone[] phoneArr = this.mPhones;
            if (i2 >= phoneArr.length) {
                return null;
            }
            if (phoneArr[i2].getRadioAccessFamily() == i) {
                return this.mPhones[i2].getModemUuId();
            }
            i2++;
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void logd(String str) {
        Rlog.d(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }
}
