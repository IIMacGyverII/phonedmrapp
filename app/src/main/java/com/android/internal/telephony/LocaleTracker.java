package com.android.internal.telephony;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.WorkSource;
import android.telephony.CellInfo;
import android.telephony.ServiceState;
import android.text.TextUtils;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.MccTable;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

public class LocaleTracker extends Handler {
    private static final String ACTION_COUNTRY_OVERRIDE = "com.android.internal.telephony.action.COUNTRY_OVERRIDE";
    private static final long CELL_INFO_MAX_DELAY_MS = 600000;
    private static final long CELL_INFO_MIN_DELAY_MS = 2000;
    private static final long CELL_INFO_PERIODIC_POLLING_DELAY_MS = 600000;
    private static final boolean DBG = true;
    private static final int EVENT_OPERATOR_LOST = 6;
    private static final int EVENT_OVERRIDE_LOCALE = 7;
    private static final int EVENT_REQUEST_CELL_INFO = 1;
    private static final int EVENT_RESPONSE_CELL_INFO = 5;
    private static final int EVENT_SERVICE_STATE_CHANGED = 2;
    private static final int EVENT_SIM_STATE_CHANGED = 3;
    private static final int EVENT_UNSOL_CELL_INFO = 4;
    private static final String EXTRA_COUNTRY = "country";
    private static final String EXTRA_RESET = "reset";
    private static final String LAST_KNOWN_COUNTRY_ISO_SHARED_PREFS_KEY = "last_known_country_iso";
    private static final int MAX_FAIL_COUNT = 30;
    private static final long SERVICE_OPERATOR_LOST_DELAY_MS = 600000;
    private final BroadcastReceiver mBroadcastReceiver;
    private List<CellInfo> mCellInfoList;
    private String mCountryOverride;
    private String mCurrentCountryIso;
    private int mFailCellInfoCount;
    private boolean mIsTracking = false;
    private int mLastServiceState = 3;
    private final LocalLog mLocalLog = new LocalLog(32, false);
    private final NitzStateMachine mNitzStateMachine;
    private String mOperatorNumeric;
    /* access modifiers changed from: private */
    public final Phone mPhone;
    private int mSimState;
    private String mTag;

    public void handleMessage(Message message) {
        boolean z = true;
        switch (message.what) {
            case 1:
                this.mPhone.requestCellInfoUpdate((WorkSource) null, obtainMessage(5));
                return;
            case 2:
                onServiceStateChanged((ServiceState) ((AsyncResult) message.obj).result);
                return;
            case 3:
                onSimCardStateChanged(message.arg1);
                return;
            case 4:
                processCellInfo((AsyncResult) message.obj);
                List<CellInfo> list = this.mCellInfoList;
                if (list != null && list.size() > 0) {
                    requestNextCellInfo(true);
                    return;
                }
                return;
            case 5:
                processCellInfo((AsyncResult) message.obj);
                List<CellInfo> list2 = this.mCellInfoList;
                if (list2 == null || list2.size() <= 0) {
                    z = false;
                }
                requestNextCellInfo(z);
                return;
            case 6:
                updateOperatorNumericImmediate("");
                updateTrackingStatus();
                return;
            case 7:
                this.mCountryOverride = (String) message.obj;
                updateLocale();
                return;
            default:
                throw new IllegalStateException("Unexpected message arrives. msg = " + message.what);
        }
    }

    public LocaleTracker(Phone phone, NitzStateMachine nitzStateMachine, Looper looper) {
        super(looper);
        AnonymousClass1 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if ("android.telephony.action.SIM_CARD_STATE_CHANGED".equals(intent.getAction())) {
                    if (intent.getIntExtra("phone", 0) == LocaleTracker.this.mPhone.getPhoneId()) {
                        LocaleTracker.this.obtainMessage(3, intent.getIntExtra("android.telephony.extra.SIM_STATE", 0), 0).sendToTarget();
                    }
                } else if (LocaleTracker.ACTION_COUNTRY_OVERRIDE.equals(intent.getAction())) {
                    String stringExtra = intent.getStringExtra(LocaleTracker.EXTRA_COUNTRY);
                    if (intent.getBooleanExtra(LocaleTracker.EXTRA_RESET, false)) {
                        stringExtra = null;
                    }
                    LocaleTracker localeTracker = LocaleTracker.this;
                    localeTracker.log("Received country override: " + stringExtra);
                    LocaleTracker.this.obtainMessage(7, stringExtra).sendToTarget();
                }
            }
        };
        this.mBroadcastReceiver = r0;
        this.mPhone = phone;
        this.mNitzStateMachine = nitzStateMachine;
        this.mSimState = 0;
        this.mTag = LocaleTracker.class.getSimpleName() + "-" + phone.getPhoneId();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.SIM_CARD_STATE_CHANGED");
        if (TelephonyUtils.IS_DEBUGGABLE) {
            intentFilter.addAction(ACTION_COUNTRY_OVERRIDE);
        }
        phone.getContext().registerReceiver(r0, intentFilter);
        phone.registerForServiceStateChanged(this, 2, (Object) null);
        phone.registerForCellInfo(this, 4, (Object) null);
    }

    public String getCurrentCountry() {
        String str = this.mCurrentCountryIso;
        return str != null ? str : "";
    }

    private String getMccFromCellInfo() {
        String str = null;
        if (this.mCellInfoList != null) {
            HashMap hashMap = new HashMap();
            int i = 0;
            for (CellInfo cellIdentity : this.mCellInfoList) {
                String mccString = cellIdentity.getCellIdentity().getMccString();
                if (mccString != null) {
                    int i2 = 1;
                    if (hashMap.containsKey(mccString)) {
                        i2 = 1 + ((Integer) hashMap.get(mccString)).intValue();
                    }
                    hashMap.put(mccString, Integer.valueOf(i2));
                    if (i2 > i) {
                        str = mccString;
                        i = i2;
                    }
                }
            }
        }
        return str;
    }

    private MccTable.MccMnc getMccMncFromCellInfo(String str) {
        MccTable.MccMnc mccMnc = null;
        if (this.mCellInfoList != null) {
            HashMap hashMap = new HashMap();
            int i = 0;
            for (CellInfo next : this.mCellInfoList) {
                String mccString = next.getCellIdentity().getMccString();
                if (Objects.equals(mccString, str)) {
                    MccTable.MccMnc mccMnc2 = new MccTable.MccMnc(mccString, next.getCellIdentity().getMncString());
                    int i2 = 1;
                    if (hashMap.containsKey(mccMnc2)) {
                        i2 = 1 + ((Integer) hashMap.get(mccMnc2)).intValue();
                    }
                    hashMap.put(mccMnc2, Integer.valueOf(i2));
                    if (i2 > i) {
                        i = i2;
                        mccMnc = mccMnc2;
                    }
                }
            }
        }
        return mccMnc;
    }

    private void onSimCardStateChanged(int i) {
        this.mSimState = i;
        updateLocale();
        updateTrackingStatus();
    }

    private void onServiceStateChanged(ServiceState serviceState) {
        this.mLastServiceState = serviceState.getState();
        updateLocale();
        updateTrackingStatus();
    }

    public void updateOperatorNumeric(String str) {
        if (TextUtils.isEmpty(str)) {
            sendMessageDelayed(obtainMessage(6), 600000);
            return;
        }
        removeMessages(6);
        updateOperatorNumericImmediate(str);
    }

    private void updateOperatorNumericImmediate(String str) {
        if (!str.equals(this.mOperatorNumeric)) {
            String str2 = "Operator numeric changes to \"" + str + "\"";
            log(str2);
            this.mLocalLog.log(str2);
            this.mOperatorNumeric = str;
            updateLocale();
        }
    }

    private void processCellInfo(AsyncResult asyncResult) {
        if (asyncResult == null || asyncResult.exception != null) {
            this.mCellInfoList = null;
            return;
        }
        List<CellInfo> list = (List) asyncResult.result;
        log("processCellInfo: cell info=" + list);
        this.mCellInfoList = list;
        updateLocale();
    }

    private void requestNextCellInfo(boolean z) {
        if (this.mIsTracking) {
            removeMessages(1);
            if (z) {
                resetCellInfoRetry();
                removeMessages(4);
                removeMessages(5);
                sendMessageDelayed(obtainMessage(1), 600000);
                return;
            }
            int i = this.mFailCellInfoCount + 1;
            this.mFailCellInfoCount = i;
            long cellInfoDelayTime = getCellInfoDelayTime(i);
            log("Can't get cell info. Try again in " + (cellInfoDelayTime / 1000) + " secs.");
            sendMessageDelayed(obtainMessage(1), cellInfoDelayTime);
        }
    }

    @VisibleForTesting
    public static long getCellInfoDelayTime(int i) {
        return Math.min(Math.max(((long) Math.pow(2.0d, (double) (Math.min(i, 30) - 1))) * 2000, 2000), 600000);
    }

    private void resetCellInfoRetry() {
        this.mFailCellInfoCount = 0;
        removeMessages(1);
    }

    private void updateTrackingStatus() {
        int i;
        boolean z = true;
        if ((this.mSimState != 1 && !TextUtils.isEmpty(this.mOperatorNumeric)) || !((i = this.mLastServiceState) == 1 || i == 2)) {
            z = false;
        }
        if (z) {
            startTracking();
        } else {
            stopTracking();
        }
    }

    private void stopTracking() {
        if (this.mIsTracking) {
            this.mIsTracking = false;
            log("Stopping LocaleTracker");
            this.mLocalLog.log("Stopping LocaleTracker");
            this.mCellInfoList = null;
            resetCellInfoRetry();
        }
    }

    private void startTracking() {
        if (!this.mIsTracking) {
            this.mLocalLog.log("Starting LocaleTracker");
            log("Starting LocaleTracker");
            this.mIsTracking = true;
            sendMessage(obtainMessage(1));
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:16:0x009e  */
    /* JADX WARNING: Removed duplicated region for block: B:19:0x00bc  */
    /* JADX WARNING: Removed duplicated region for block: B:22:0x00df  */
    /* JADX WARNING: Removed duplicated region for block: B:25:0x0108  */
    /* JADX WARNING: Removed duplicated region for block: B:42:0x01ba  */
    /* JADX WARNING: Removed duplicated region for block: B:43:0x01cc  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private synchronized void updateLocale() {
        /*
            r8 = this;
            monitor-enter(r8)
            java.lang.String r0 = ""
            java.lang.String r1 = "empty as default"
            java.lang.String r2 = r8.mOperatorNumeric     // Catch:{ all -> 0x01ff }
            boolean r2 = android.text.TextUtils.isEmpty(r2)     // Catch:{ all -> 0x01ff }
            r3 = 0
            if (r2 != 0) goto L_0x0070
            java.lang.String r2 = r8.mOperatorNumeric     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.MccTable$MccMnc r2 = com.android.internal.telephony.MccTable.MccMnc.fromOperatorNumeric(r2)     // Catch:{ all -> 0x01ff }
            if (r2 == 0) goto L_0x0059
            java.lang.String r0 = r2.mcc     // Catch:{ all -> 0x01ff }
            java.lang.String r0 = com.android.internal.telephony.MccTable.countryCodeForMcc((java.lang.String) r0)     // Catch:{ all -> 0x01ff }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r1.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = "OperatorNumeric("
            r1.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = r8.mOperatorNumeric     // Catch:{ all -> 0x01ff }
            r1.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = "): MccTable.countryCodeForMcc(\""
            r1.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = r2.mcc     // Catch:{ all -> 0x01ff }
            r1.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = "\")"
            r1.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = com.android.internal.telephony.MccTable.geoCountryCodeForMccMnc(r2)     // Catch:{ all -> 0x01ff }
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r5.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "OperatorNumeric: MccTable.geoCountryCodeForMccMnc("
            r5.append(r6)     // Catch:{ all -> 0x01ff }
            r5.append(r2)     // Catch:{ all -> 0x01ff }
            java.lang.String r2 = ")"
            r5.append(r2)     // Catch:{ all -> 0x01ff }
            java.lang.String r2 = r5.toString()     // Catch:{ all -> 0x01ff }
            goto L_0x0072
        L_0x0059:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r2.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = "updateLocale: Can't get country from operator numeric. mOperatorNumeric = "
            r2.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = r8.mOperatorNumeric     // Catch:{ all -> 0x01ff }
            r2.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r2 = r2.toString()     // Catch:{ all -> 0x01ff }
            r8.loge(r2)     // Catch:{ all -> 0x01ff }
        L_0x0070:
            r2 = r3
            r4 = r2
        L_0x0072:
            boolean r5 = android.text.TextUtils.isEmpty(r0)     // Catch:{ all -> 0x01ff }
            if (r5 == 0) goto L_0x00b8
            java.lang.String r5 = r8.getMccFromCellInfo()     // Catch:{ all -> 0x01ff }
            if (r5 == 0) goto L_0x00b8
            java.lang.String r0 = com.android.internal.telephony.MccTable.countryCodeForMcc((java.lang.String) r5)     // Catch:{ all -> 0x01ff }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r1.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "CellInfo: MccTable.countryCodeForMcc(\""
            r1.append(r6)     // Catch:{ all -> 0x01ff }
            r1.append(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "\")"
            r1.append(r6)     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.MccTable$MccMnc r5 = r8.getMccMncFromCellInfo(r5)     // Catch:{ all -> 0x01ff }
            if (r5 == 0) goto L_0x00b8
            java.lang.String r4 = com.android.internal.telephony.MccTable.geoCountryCodeForMccMnc(r5)     // Catch:{ all -> 0x01ff }
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r2.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "CellInfo: MccTable.geoCountryCodeForMccMnc("
            r2.append(r6)     // Catch:{ all -> 0x01ff }
            r2.append(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = ")"
            r2.append(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r2 = r2.toString()     // Catch:{ all -> 0x01ff }
        L_0x00b8:
            java.lang.String r5 = r8.mCountryOverride     // Catch:{ all -> 0x01ff }
            if (r5 == 0) goto L_0x00d7
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r0.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = "mCountryOverride = \""
            r0.append(r1)     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = r8.mCountryOverride     // Catch:{ all -> 0x01ff }
            r0.append(r1)     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = "\""
            r0.append(r1)     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = r0.toString()     // Catch:{ all -> 0x01ff }
            r2 = r1
            r0 = r5
            r4 = r0
        L_0x00d7:
            com.android.internal.telephony.Phone r5 = r8.mPhone     // Catch:{ all -> 0x01ff }
            boolean r5 = r5.isRadioOn()     // Catch:{ all -> 0x01ff }
            if (r5 != 0) goto L_0x00e3
            java.lang.String r0 = ""
            java.lang.String r1 = "radio off"
        L_0x00e3:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r5.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "updateLocale: countryIso = "
            r5.append(r6)     // Catch:{ all -> 0x01ff }
            r5.append(r0)     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = ", countryIsoDebugInfo = "
            r5.append(r6)     // Catch:{ all -> 0x01ff }
            r5.append(r1)     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x01ff }
            r8.log(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = r8.mCurrentCountryIso     // Catch:{ all -> 0x01ff }
            boolean r5 = java.util.Objects.equals(r0, r5)     // Catch:{ all -> 0x01ff }
            if (r5 != 0) goto L_0x018f
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r5.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "updateLocale: Change the current country to \""
            r5.append(r6)     // Catch:{ all -> 0x01ff }
            r5.append(r0)     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "\", countryIsoDebugInfo = "
            r5.append(r6)     // Catch:{ all -> 0x01ff }
            r5.append(r1)     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = ", mCellInfoList = "
            r5.append(r6)     // Catch:{ all -> 0x01ff }
            java.util.List<android.telephony.CellInfo> r6 = r8.mCellInfoList     // Catch:{ all -> 0x01ff }
            r5.append(r6)     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x01ff }
            r8.log(r5)     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.LocalLog r6 = r8.mLocalLog     // Catch:{ all -> 0x01ff }
            r6.log(r5)     // Catch:{ all -> 0x01ff }
            r8.mCurrentCountryIso = r0     // Catch:{ all -> 0x01ff }
            boolean r5 = android.text.TextUtils.isEmpty(r0)     // Catch:{ all -> 0x01ff }
            if (r5 != 0) goto L_0x0141
            java.lang.String r5 = r8.mCurrentCountryIso     // Catch:{ all -> 0x01ff }
            r8.updateLastKnownCountryIso(r5)     // Catch:{ all -> 0x01ff }
        L_0x0141:
            com.android.internal.telephony.Phone r5 = r8.mPhone     // Catch:{ all -> 0x01ff }
            int r5 = r5.getPhoneId()     // Catch:{ all -> 0x01ff }
            boolean r6 = android.telephony.SubscriptionManager.isValidPhoneId(r5)     // Catch:{ all -> 0x01ff }
            if (r6 == 0) goto L_0x0168
            java.util.ArrayList r6 = new java.util.ArrayList     // Catch:{ all -> 0x01ff }
            java.util.List r7 = android.internal.telephony.sysprop.TelephonyProperties.operator_iso_country()     // Catch:{ all -> 0x01ff }
            r6.<init>(r7)     // Catch:{ all -> 0x01ff }
        L_0x0156:
            int r7 = r6.size()     // Catch:{ all -> 0x01ff }
            if (r7 > r5) goto L_0x0160
            r6.add(r3)     // Catch:{ all -> 0x01ff }
            goto L_0x0156
        L_0x0160:
            java.lang.String r3 = r8.mCurrentCountryIso     // Catch:{ all -> 0x01ff }
            r6.set(r5, r3)     // Catch:{ all -> 0x01ff }
            android.internal.telephony.sysprop.TelephonyProperties.operator_iso_country(r6)     // Catch:{ all -> 0x01ff }
        L_0x0168:
            android.content.Intent r3 = new android.content.Intent     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = "android.telephony.action.NETWORK_COUNTRY_CHANGED"
            r3.<init>(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = "android.telephony.extra.NETWORK_COUNTRY"
            r3.putExtra(r5, r0)     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = "android.telephony.extra.LAST_KNOWN_NETWORK_COUNTRY"
            java.lang.String r6 = r8.getLastKnownCountryIso()     // Catch:{ all -> 0x01ff }
            r3.putExtra(r5, r6)     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.Phone r5 = r8.mPhone     // Catch:{ all -> 0x01ff }
            int r5 = r5.getPhoneId()     // Catch:{ all -> 0x01ff }
            android.telephony.SubscriptionManager.putPhoneIdAndSubIdExtra(r3, r5)     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.Phone r5 = r8.mPhone     // Catch:{ all -> 0x01ff }
            android.content.Context r5 = r5.getContext()     // Catch:{ all -> 0x01ff }
            r5.sendBroadcast(r3)     // Catch:{ all -> 0x01ff }
        L_0x018f:
            r3 = 0
            java.lang.String r5 = r8.mOperatorNumeric     // Catch:{ all -> 0x01ff }
            boolean r5 = android.text.TextUtils.isEmpty(r5)     // Catch:{ all -> 0x01ff }
            if (r5 != 0) goto L_0x01b8
            java.lang.String r5 = r8.mOperatorNumeric     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "001"
            boolean r5 = r5.startsWith(r6)     // Catch:{ all -> 0x01ff }
            if (r5 == 0) goto L_0x01b8
            r3 = 1
            java.lang.String r4 = ""
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r2.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = "Test cell: "
            r2.append(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r5 = r8.mOperatorNumeric     // Catch:{ all -> 0x01ff }
            r2.append(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r2 = r2.toString()     // Catch:{ all -> 0x01ff }
        L_0x01b8:
            if (r4 != 0) goto L_0x01cc
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r2.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = "Defaulted: "
            r2.append(r4)     // Catch:{ all -> 0x01ff }
            r2.append(r1)     // Catch:{ all -> 0x01ff }
            java.lang.String r2 = r2.toString()     // Catch:{ all -> 0x01ff }
            goto L_0x01cd
        L_0x01cc:
            r0 = r4
        L_0x01cd:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r1.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = "updateLocale: timeZoneCountryIso = "
            r1.append(r4)     // Catch:{ all -> 0x01ff }
            r1.append(r0)     // Catch:{ all -> 0x01ff }
            java.lang.String r4 = ", timeZoneCountryIsoDebugInfo = "
            r1.append(r4)     // Catch:{ all -> 0x01ff }
            r1.append(r2)     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x01ff }
            r8.log(r1)     // Catch:{ all -> 0x01ff }
            boolean r1 = android.text.TextUtils.isEmpty(r0)     // Catch:{ all -> 0x01ff }
            if (r1 == 0) goto L_0x01f8
            if (r3 != 0) goto L_0x01f8
            com.android.internal.telephony.NitzStateMachine r0 = r8.mNitzStateMachine     // Catch:{ all -> 0x01ff }
            r0.handleCountryUnavailable()     // Catch:{ all -> 0x01ff }
            goto L_0x01fd
        L_0x01f8:
            com.android.internal.telephony.NitzStateMachine r1 = r8.mNitzStateMachine     // Catch:{ all -> 0x01ff }
            r1.handleCountryDetected(r0)     // Catch:{ all -> 0x01ff }
        L_0x01fd:
            monitor-exit(r8)
            return
        L_0x01ff:
            r0 = move-exception
            monitor-exit(r8)
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.LocaleTracker.updateLocale():void");
    }

    public boolean isTracking() {
        return this.mIsTracking;
    }

    private void updateLastKnownCountryIso(String str) {
        if (!TextUtils.isEmpty(str)) {
            SharedPreferences.Editor edit = this.mPhone.getContext().getSharedPreferences(LAST_KNOWN_COUNTRY_ISO_SHARED_PREFS_KEY, 0).edit();
            edit.putString(LAST_KNOWN_COUNTRY_ISO_SHARED_PREFS_KEY, str);
            edit.commit();
            log("update country iso in sharedPrefs " + str);
        }
    }

    public String getLastKnownCountryIso() {
        return this.mPhone.getContext().getSharedPreferences(LAST_KNOWN_COUNTRY_ISO_SHARED_PREFS_KEY, 0).getString(LAST_KNOWN_COUNTRY_ISO_SHARED_PREFS_KEY, "");
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(this.mTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mTag, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        printWriter.println("LocaleTracker-" + this.mPhone.getPhoneId() + ":");
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("mIsTracking = " + this.mIsTracking);
        indentingPrintWriter.println("mOperatorNumeric = " + this.mOperatorNumeric);
        indentingPrintWriter.println("mSimState = " + this.mSimState);
        indentingPrintWriter.println("mCellInfoList = " + this.mCellInfoList);
        indentingPrintWriter.println("mCurrentCountryIso = " + this.mCurrentCountryIso);
        indentingPrintWriter.println("mFailCellInfoCount = " + this.mFailCellInfoCount);
        indentingPrintWriter.println("Local logs:");
        indentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.flush();
    }

    @VisibleForTesting
    public String getCountryOverride() {
        return this.mCountryOverride;
    }
}
