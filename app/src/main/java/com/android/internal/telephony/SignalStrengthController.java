package com.android.internal.telephony;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.telephony.CarrierConfigManager;
import android.telephony.CellIdentity;
import android.telephony.CellIdentityLte;
import android.telephony.CellIdentityNr;
import android.telephony.ServiceState;
import android.telephony.SignalStrength;
import android.telephony.SignalStrengthUpdateRequest;
import android.telephony.SignalThresholdInfo;
import android.telephony.SubscriptionInfo;
import android.telephony.TelephonyManager;
import android.util.Pair;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.TreeSet;
import java.util.concurrent.TimeUnit;
import java.util.regex.PatternSyntaxException;

public class SignalStrengthController extends Handler {
    private static final int ALIGNMENT_HYSTERESIS_DB = 1;
    private static final boolean DBG = false;
    private static final int EVENT_CARRIER_CONFIG_CHANGED = 10;
    private static final int EVENT_CLEAR_SIGNAL_STRENGTH_UPDATE_REQUEST = 2;
    private static final int EVENT_GET_SIGNAL_STRENGTH = 6;
    private static final int EVENT_ON_DEVICE_IDLE_STATE_CHANGED = 3;
    private static final int EVENT_POLL_SIGNAL_STRENGTH = 7;
    private static final int EVENT_POLL_SIGNAL_STRENGTH_DONE = 9;
    private static final int EVENT_RADIO_AVAILABLE = 5;
    private static final int EVENT_RIL_CONNECTED = 4;
    private static final int EVENT_SET_SIGNAL_STRENGTH_UPDATE_REQUEST = 1;
    private static final int EVENT_SIGNAL_STRENGTH_UPDATE = 8;
    private static final int INVALID_ARFCN = -1;
    private static final long POLL_PERIOD_MILLIS;
    private static final int REPORTING_HYSTERESIS_DB = 2;
    private static final int REPORTING_HYSTERESIS_MILLIS = 3000;
    private static final long SIGNAL_STRENGTH_REFRESH_THRESHOLD_IN_MS;
    private static final String TAG = "SSCtr";
    private BroadcastReceiver mBroadcastReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            if ("android.telephony.action.CARRIER_CONFIG_CHANGED".equals(intent.getAction()) && intent.getExtras().getInt("android.telephony.extra.SLOT_INDEX") == SignalStrengthController.this.mPhone.getPhoneId()) {
                SignalStrengthController.this.sendEmptyMessage(10);
            }
        }
    };
    protected PersistableBundle mCarrierConfig;
    protected final CommandsInterface mCi;
    private ArrayList<Pair<Integer, Integer>> mEarfcnPairListForRsrpBoost = null;
    private SignalStrength mLastSignalStrength = null;
    private final LocalLog mLocalLog = new LocalLog(64);
    private int mLteRsrpBoost = 0;
    private int[] mNrRsrpBoost = null;
    private ArrayList<Pair<Integer, Integer>> mNrarfcnRangeListForRsrpBoost = null;
    protected final Phone mPhone;
    private final Object mRsrpBoostLock = new Object();
    private final List<SignalRequestRecord> mSignalRequestRecords = new ArrayList();
    protected SignalStrength mSignalStrength;
    protected long mSignalStrengthUpdatedTime;

    private static void log(String str) {
    }

    static {
        TimeUnit timeUnit = TimeUnit.SECONDS;
        SIGNAL_STRENGTH_REFRESH_THRESHOLD_IN_MS = timeUnit.toMillis(10);
        POLL_PERIOD_MILLIS = timeUnit.toMillis(20);
    }

    public SignalStrengthController(Phone phone) {
        this.mPhone = phone;
        CommandsInterface commandsInterface = phone.mCi;
        this.mCi = commandsInterface;
        commandsInterface.registerForRilConnected(this, 4, (Object) null);
        commandsInterface.registerForAvailable(this, 5, (Object) null);
        commandsInterface.setOnSignalStrengthUpdate(this, 8, (Object) null);
        setSignalStrengthDefaultValues();
        this.mCarrierConfig = getCarrierConfig();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        phone.getContext().registerReceiver(this.mBroadcastReceiver, intentFilter);
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case 1:
                Pair pair = (Pair) message.obj;
                SignalRequestRecord signalRequestRecord = (SignalRequestRecord) pair.first;
                Message message2 = (Message) pair.second;
                AsyncResult forMessage = AsyncResult.forMessage(message2);
                if (this.mSignalRequestRecords.stream().anyMatch(new SignalStrengthController$$ExternalSyntheticLambda1(signalRequestRecord))) {
                    forMessage.exception = new IllegalStateException("setSignalStrengthUpdateRequest called again with same subId");
                    message2.sendToTarget();
                    return;
                }
                try {
                    signalRequestRecord.mRequest.getLiveToken().linkToDeath(signalRequestRecord, 0);
                    this.mSignalRequestRecords.add(signalRequestRecord);
                    updateAlwaysReportSignalStrength();
                    updateReportingCriteria();
                    message2.sendToTarget();
                    return;
                } catch (RemoteException | NullPointerException unused) {
                    forMessage.exception = new IllegalStateException("Signal request client is already dead.");
                    message2.sendToTarget();
                    return;
                }
            case 2:
                Pair pair2 = (Pair) message.obj;
                SignalRequestRecord signalRequestRecord2 = (SignalRequestRecord) pair2.first;
                Message message3 = (Message) pair2.second;
                Iterator<SignalRequestRecord> it = this.mSignalRequestRecords.iterator();
                while (it.hasNext()) {
                    if (it.next().mRequest.getLiveToken().equals(signalRequestRecord2.mRequest.getLiveToken())) {
                        it.remove();
                    }
                }
                updateAlwaysReportSignalStrength();
                updateReportingCriteria();
                if (message3 != null) {
                    AsyncResult.forMessage(message3);
                    message3.sendToTarget();
                    return;
                }
                return;
            case 3:
                updateReportingCriteria();
                return;
            case 4:
            case 5:
                onReset();
                return;
            case 6:
            case 9:
                if (this.mCi.getRadioState() == 1) {
                    onSignalStrengthResult((AsyncResult) message.obj);
                    return;
                }
                return;
            case 7:
                this.mCi.getSignalStrength(obtainMessage(9));
                return;
            case 8:
                onSignalStrengthResult((AsyncResult) message.obj);
                return;
            case 10:
                onCarrierConfigChanged();
                return;
            default:
                log("Unhandled message with number: " + message.what);
                return;
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$handleMessage$0(SignalRequestRecord signalRequestRecord, SignalRequestRecord signalRequestRecord2) {
        return signalRequestRecord2.mCallingUid == signalRequestRecord.mCallingUid && signalRequestRecord2.mSubId == signalRequestRecord.mSubId;
    }

    /* access modifiers changed from: package-private */
    public void dispose() {
        this.mCi.unSetOnSignalStrengthUpdate(this);
    }

    private void onReset() {
        setDefaultSignalStrengthReportingCriteria();
    }

    public void getSignalStrengthFromCi() {
        this.mCi.getSignalStrength(obtainMessage(6));
    }

    /* access modifiers changed from: protected */
    public boolean onSignalStrengthResult(AsyncResult asyncResult) {
        Object obj;
        if (asyncResult.exception != null || (obj = asyncResult.result) == null) {
            log("onSignalStrengthResult() Exception from RIL : " + asyncResult.exception);
            this.mSignalStrength = new SignalStrength();
        } else {
            this.mSignalStrength = (SignalStrength) obj;
            if (this.mPhone.getServiceStateTracker() != null) {
                this.mSignalStrength.updateLevel(this.mCarrierConfig, this.mPhone.getServiceStateTracker().mSS);
            }
        }
        this.mSignalStrengthUpdatedTime = System.currentTimeMillis();
        return notifySignalStrength();
    }

    public SignalStrength getSignalStrength() {
        if (shouldRefreshSignalStrength()) {
            log("getSignalStrength() refreshing signal strength.");
            obtainMessage(7).sendToTarget();
        }
        return this.mSignalStrength;
    }

    private boolean shouldRefreshSignalStrength() {
        ServiceState serviceState;
        long currentTimeMillis = System.currentTimeMillis();
        long j = this.mSignalStrengthUpdatedTime;
        if (!(j > currentTimeMillis || currentTimeMillis - j > SIGNAL_STRENGTH_REFRESH_THRESHOLD_IN_MS)) {
            return false;
        }
        List<SubscriptionInfo> activeSubscriptionInfoList = SubscriptionController.getInstance().getActiveSubscriptionInfoList(this.mPhone.getContext().getOpPackageName(), this.mPhone.getContext().getAttributionTag());
        if (!ArrayUtils.isEmpty(activeSubscriptionInfoList)) {
            for (SubscriptionInfo next : activeSubscriptionInfoList) {
                if (next.isOpportunistic() && (serviceState = TelephonyManager.from(this.mPhone.getContext()).createForSubscriptionId(next.getSubscriptionId()).getServiceState()) != null && serviceState.getDataRegistrationState() == 0) {
                    return true;
                }
            }
        }
        return false;
    }

    @VisibleForTesting
    public void updateReportingCriteria() {
        ArrayList arrayList = new ArrayList();
        int[] intArray = this.mCarrierConfig.getIntArray("gsm_rssi_thresholds_int_array");
        boolean z = true;
        if (intArray != null) {
            arrayList.add(createSignalThresholdsInfo(1, intArray, 1, true));
        }
        int[] intArray2 = this.mCarrierConfig.getIntArray("wcdma_rscp_thresholds_int_array");
        if (intArray2 != null) {
            arrayList.add(createSignalThresholdsInfo(2, intArray2, 2, true));
        }
        int i = this.mCarrierConfig.getInt("parameters_used_for_lte_signal_bar_int", 1);
        int[] intArray3 = this.mCarrierConfig.getIntArray("lte_rsrp_thresholds_int_array");
        if (intArray3 != null) {
            arrayList.add(createSignalThresholdsInfo(3, intArray3, 3, (i & 1) != 0));
        }
        if (this.mPhone.getHalVersion().greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
            int[] intArray4 = this.mCarrierConfig.getIntArray("lte_rsrq_thresholds_int_array");
            if (intArray4 != null) {
                arrayList.add(createSignalThresholdsInfo(4, intArray4, 3, (i & 2) != 0));
            }
            int[] intArray5 = this.mCarrierConfig.getIntArray("lte_rssnr_thresholds_int_array");
            if (intArray5 != null) {
                arrayList.add(createSignalThresholdsInfo(5, intArray5, 3, (i & 4) != 0));
            }
            int i2 = this.mCarrierConfig.getInt("parameters_use_for_5g_nr_signal_bar_int", 1);
            int[] intArray6 = this.mCarrierConfig.getIntArray("5g_nr_ssrsrp_thresholds_int_array");
            if (intArray6 != null) {
                arrayList.add(createSignalThresholdsInfo(6, intArray6, 6, (i2 & 1) != 0));
            }
            int[] intArray7 = this.mCarrierConfig.getIntArray("5g_nr_ssrsrq_thresholds_int_array");
            if (intArray7 != null) {
                arrayList.add(createSignalThresholdsInfo(7, intArray7, 6, (i2 & 2) != 0));
            }
            int[] intArray8 = this.mCarrierConfig.getIntArray("5g_nr_sssinr_thresholds_int_array");
            if (intArray8 != null) {
                if ((i2 & 4) == 0) {
                    z = false;
                }
                arrayList.add(createSignalThresholdsInfo(8, intArray8, 6, z));
            }
        }
        consolidatedAndSetReportingCriteria(arrayList);
    }

    private void setDefaultSignalStrengthReportingCriteria() {
        ArrayList arrayList = new ArrayList();
        arrayList.add(createSignalThresholdsInfo(1, AccessNetworkThresholds.GERAN, 1, true));
        arrayList.add(createSignalThresholdsInfo(2, AccessNetworkThresholds.UTRAN, 2, true));
        arrayList.add(createSignalThresholdsInfo(3, AccessNetworkThresholds.EUTRAN_RSRP, 3, true));
        arrayList.add(createSignalThresholdsInfo(1, AccessNetworkThresholds.CDMA2000, 4, true));
        if (this.mPhone.getHalVersion().greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
            arrayList.add(createSignalThresholdsInfo(4, AccessNetworkThresholds.EUTRAN_RSRQ, 3, false));
            arrayList.add(createSignalThresholdsInfo(5, AccessNetworkThresholds.EUTRAN_RSSNR, 3, true));
            arrayList.add(createSignalThresholdsInfo(6, AccessNetworkThresholds.NGRAN_SSRSRP, 6, true));
            arrayList.add(createSignalThresholdsInfo(7, AccessNetworkThresholds.NGRAN_SSRSRQ, 6, false));
            arrayList.add(createSignalThresholdsInfo(8, AccessNetworkThresholds.NGRAN_SSSINR, 6, false));
        }
        consolidatedAndSetReportingCriteria(arrayList);
    }

    private void consolidatedAndSetReportingCriteria(List<SignalThresholdInfo> list) {
        ArrayList arrayList = new ArrayList(list.size());
        for (SignalThresholdInfo next : list) {
            int radioAccessNetworkType = next.getRadioAccessNetworkType();
            int signalMeasurementType = next.getSignalMeasurementType();
            boolean isEnabled = next.isEnabled();
            boolean z = false;
            int[] consolidatedSignalThresholds = getConsolidatedSignalThresholds(radioAccessNetworkType, signalMeasurementType, (!isEnabled || !shouldHonorSystemThresholds()) ? new int[0] : next.getThresholds(), 1);
            boolean shouldEnableSignalThresholdForAppRequest = shouldEnableSignalThresholdForAppRequest(radioAccessNetworkType, signalMeasurementType, this.mPhone.getSubId(), this.mPhone.isDeviceIdle());
            SignalThresholdInfo.Builder thresholds = new SignalThresholdInfo.Builder().setRadioAccessNetworkType(radioAccessNetworkType).setSignalMeasurementType(signalMeasurementType).setHysteresisMs(3000).setHysteresisDb(2).setThresholds(consolidatedSignalThresholds, true);
            if (isEnabled || shouldEnableSignalThresholdForAppRequest) {
                z = true;
            }
            arrayList.add(thresholds.setIsEnabled(z).build());
        }
        this.mCi.setSignalStrengthReportingCriteria(arrayList, (Message) null);
        localLog("setSignalStrengthReportingCriteria consolidatedSignalThresholdInfos=" + arrayList);
    }

    public void setSignalStrengthDefaultValues() {
        this.mSignalStrength = new SignalStrength();
        this.mSignalStrengthUpdatedTime = System.currentTimeMillis();
    }

    public boolean notifySignalStrength() {
        boolean z = false;
        if (this.mSignalStrength.equals(this.mLastSignalStrength)) {
            return false;
        }
        try {
            this.mPhone.notifySignalStrength();
            z = true;
            this.mLastSignalStrength = this.mSignalStrength;
            return true;
        } catch (NullPointerException e) {
            log("updateSignalStrength() Phone already destroyed: " + e + "SignalStrength not notified");
            return z;
        }
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("SignalStrengthController - phoneId: " + this.mPhone.getPhoneId());
        printWriter.println("SignalStrengthController - Log Begin ----");
        this.mLocalLog.dump(fileDescriptor, printWriter, strArr);
        printWriter.println("SignalStrengthController - Log End ----");
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.increaseIndent();
        printWriter.println("mSignalRequestRecords=" + this.mSignalRequestRecords);
        printWriter.println(" mLastSignalStrength=" + this.mLastSignalStrength);
        printWriter.println(" mSignalStrength=" + this.mSignalStrength);
        printWriter.println(" mLteRsrpBoost=" + this.mLteRsrpBoost);
        printWriter.println(" mNrRsrpBoost=" + Arrays.toString(this.mNrRsrpBoost));
        printWriter.println(" mEarfcnPairListForRsrpBoost=" + this.mEarfcnPairListForRsrpBoost);
        printWriter.println(" mNrarfcnRangeListForRsrpBoost=" + this.mNrarfcnRangeListForRsrpBoost);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.flush();
    }

    public void setSignalStrengthUpdateRequest(int i, int i2, SignalStrengthUpdateRequest signalStrengthUpdateRequest, Message message) {
        sendMessage(obtainMessage(1, new Pair(new SignalRequestRecord(i, i2, signalStrengthUpdateRequest), message)));
        localLog("setSignalStrengthUpdateRequest subId=" + i + " callingUid=" + i2 + " request=" + signalStrengthUpdateRequest);
    }

    public void clearSignalStrengthUpdateRequest(int i, int i2, SignalStrengthUpdateRequest signalStrengthUpdateRequest, Message message) {
        sendMessage(obtainMessage(2, new Pair(new SignalRequestRecord(i, i2, signalStrengthUpdateRequest), message)));
        localLog("clearSignalStrengthUpdateRequest subId=" + i + " callingUid=" + i2 + " request=" + signalStrengthUpdateRequest);
    }

    @VisibleForTesting
    public int[] getConsolidatedSignalThresholds(int i, int i2, int[] iArr, int i3) {
        TreeSet<Integer> treeSet = new TreeSet<>(new SignalStrengthController$$ExternalSyntheticLambda2(i3));
        int i4 = 0;
        if (iArr != null) {
            for (int valueOf : iArr) {
                treeSet.add(Integer.valueOf(valueOf));
            }
        }
        boolean isDeviceIdle = this.mPhone.isDeviceIdle();
        int subId = this.mPhone.getSubId();
        for (SignalRequestRecord next : this.mSignalRequestRecords) {
            if (subId == next.mSubId && (!isDeviceIdle || next.mRequest.isReportingRequestedWhileIdle())) {
                for (SignalThresholdInfo signalThresholdInfo : next.mRequest.getSignalThresholdInfos()) {
                    if (isRanAndSignalMeasurementTypeMatch(i, i2, signalThresholdInfo)) {
                        for (int valueOf2 : signalThresholdInfo.getThresholds()) {
                            treeSet.add(Integer.valueOf(valueOf2));
                        }
                    }
                }
            }
        }
        int[] iArr2 = new int[treeSet.size()];
        for (Integer intValue : treeSet) {
            iArr2[i4] = intValue.intValue();
            i4++;
        }
        return iArr2;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$getConsolidatedSignalThresholds$1(int i, Integer num, Integer num2) {
        if (num2.intValue() < num.intValue() - i || num2.intValue() > num.intValue() + i) {
            return Integer.compare(num.intValue(), num2.intValue());
        }
        return 0;
    }

    @VisibleForTesting
    public boolean shouldHonorSystemThresholds() {
        if (!this.mPhone.isDeviceIdle()) {
            return true;
        }
        return this.mSignalRequestRecords.stream().anyMatch(new SignalStrengthController$$ExternalSyntheticLambda0(this.mPhone.getSubId()));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$shouldHonorSystemThresholds$2(int i, SignalRequestRecord signalRequestRecord) {
        return i == signalRequestRecord.mSubId && signalRequestRecord.mRequest.isSystemThresholdReportingRequestedWhileIdle();
    }

    /* access modifiers changed from: package-private */
    public void onDeviceIdleStateChanged(boolean z) {
        sendMessage(obtainMessage(3, Boolean.valueOf(z)));
        localLog("onDeviceIdleStateChanged isDeviceIdle=" + z);
    }

    @VisibleForTesting
    public boolean shouldEnableSignalThresholdForAppRequest(int i, int i2, int i3, boolean z) {
        for (SignalRequestRecord next : this.mSignalRequestRecords) {
            if (i3 == next.mSubId) {
                for (SignalThresholdInfo isRanAndSignalMeasurementTypeMatch : next.mRequest.getSignalThresholdInfos()) {
                    if (isRanAndSignalMeasurementTypeMatch(i, i2, isRanAndSignalMeasurementTypeMatch) && (!z || isSignalReportRequestedWhileIdle(next.mRequest))) {
                        return true;
                    }
                }
                continue;
            }
        }
        return false;
    }

    private static boolean isRanAndSignalMeasurementTypeMatch(int i, int i2, SignalThresholdInfo signalThresholdInfo) {
        return i == signalThresholdInfo.getRadioAccessNetworkType() && i2 == signalThresholdInfo.getSignalMeasurementType();
    }

    private static boolean isSignalReportRequestedWhileIdle(SignalStrengthUpdateRequest signalStrengthUpdateRequest) {
        return signalStrengthUpdateRequest.isSystemThresholdReportingRequestedWhileIdle() || signalStrengthUpdateRequest.isReportingRequestedWhileIdle();
    }

    private PersistableBundle getCarrierConfig() {
        PersistableBundle configForSubId;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null) {
            return CarrierConfigManager.getDefaultConfig();
        }
        return configForSubId;
    }

    private class SignalRequestRecord implements IBinder.DeathRecipient {
        final int mCallingUid;
        final SignalStrengthUpdateRequest mRequest;
        final int mSubId;

        SignalRequestRecord(int i, int i2, SignalStrengthUpdateRequest signalStrengthUpdateRequest) {
            this.mCallingUid = i2;
            this.mSubId = i;
            this.mRequest = signalStrengthUpdateRequest;
        }

        public void binderDied() {
            SignalStrengthController signalStrengthController = SignalStrengthController.this;
            signalStrengthController.localLog("binderDied record=" + this);
            SignalStrengthController.this.clearSignalStrengthUpdateRequest(this.mSubId, this.mCallingUid, this.mRequest, (Message) null);
        }

        public String toString() {
            StringBuffer stringBuffer = new StringBuffer("SignalRequestRecord {");
            stringBuffer.append("mSubId=");
            stringBuffer.append(this.mSubId);
            stringBuffer.append(" mCallingUid=");
            stringBuffer.append(this.mCallingUid);
            stringBuffer.append(" mRequest=");
            stringBuffer.append(this.mRequest);
            stringBuffer.append("}");
            return stringBuffer.toString();
        }
    }

    private void updateAlwaysReportSignalStrength() {
        this.mPhone.setAlwaysReportSignalStrength(this.mSignalRequestRecords.stream().anyMatch(new SignalStrengthController$$ExternalSyntheticLambda3(this.mPhone.getSubId())));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$updateAlwaysReportSignalStrength$3(int i, SignalRequestRecord signalRequestRecord) {
        return signalRequestRecord.mSubId == i && isSignalReportRequestedWhileIdle(signalRequestRecord.mRequest);
    }

    /* access modifiers changed from: package-private */
    public void updateArfcnLists() {
        synchronized (this.mRsrpBoostLock) {
            this.mLteRsrpBoost = this.mCarrierConfig.getInt("lte_earfcns_rsrp_boost_int", 0);
            this.mEarfcnPairListForRsrpBoost = convertEarfcnStringArrayToPairList(this.mCarrierConfig.getStringArray("boosted_lte_earfcns_string_array"));
            this.mNrRsrpBoost = this.mCarrierConfig.getIntArray("nrarfcns_rsrp_boost_int_array");
            ArrayList<Pair<Integer, Integer>> convertEarfcnStringArrayToPairList = convertEarfcnStringArrayToPairList(this.mCarrierConfig.getStringArray("boosted_nrarfcns_string_array"));
            this.mNrarfcnRangeListForRsrpBoost = convertEarfcnStringArrayToPairList;
            int[] iArr = this.mNrRsrpBoost;
            if ((iArr == null && convertEarfcnStringArrayToPairList != null) || ((iArr != null && convertEarfcnStringArrayToPairList == null) || !(iArr == null || convertEarfcnStringArrayToPairList == null || iArr.length == convertEarfcnStringArrayToPairList.size()))) {
                loge("Invalid parameters for NR RSRP boost");
                this.mNrRsrpBoost = null;
                this.mNrarfcnRangeListForRsrpBoost = null;
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void updateServiceStateArfcnRsrpBoost(ServiceState serviceState, CellIdentity cellIdentity) {
        int containsEarfcnInEarfcnRange;
        int[] iArr;
        if (cellIdentity != null) {
            int i = 0;
            synchronized (this.mRsrpBoostLock) {
                int type = cellIdentity.getType();
                if (type == 3) {
                    int earfcn = ((CellIdentityLte) cellIdentity).getEarfcn();
                    if (!(earfcn == -1 || containsEarfcnInEarfcnRange(this.mEarfcnPairListForRsrpBoost, earfcn) == -1)) {
                        i = this.mLteRsrpBoost;
                    }
                } else if (type == 6) {
                    int nrarfcn = ((CellIdentityNr) cellIdentity).getNrarfcn();
                    if (!(nrarfcn == -1 || (containsEarfcnInEarfcnRange = containsEarfcnInEarfcnRange(this.mNrarfcnRangeListForRsrpBoost, nrarfcn)) == -1 || (iArr = this.mNrRsrpBoost) == null)) {
                        i = iArr[containsEarfcnInEarfcnRange];
                    }
                }
            }
            serviceState.setArfcnRsrpBoost(i);
        }
    }

    private static int containsEarfcnInEarfcnRange(ArrayList<Pair<Integer, Integer>> arrayList, int i) {
        if (arrayList == null) {
            return -1;
        }
        Iterator<Pair<Integer, Integer>> it = arrayList.iterator();
        int i2 = 0;
        while (it.hasNext()) {
            Pair next = it.next();
            if (i >= ((Integer) next.first).intValue() && i <= ((Integer) next.second).intValue()) {
                return i2;
            }
            i2++;
        }
        return -1;
    }

    private static ArrayList<Pair<Integer, Integer>> convertEarfcnStringArrayToPairList(String[] strArr) {
        int parseInt;
        int parseInt2;
        ArrayList<Pair<Integer, Integer>> arrayList = new ArrayList<>();
        if (strArr != null) {
            int i = 0;
            while (i < strArr.length) {
                try {
                    String[] split = strArr[i].split("-");
                    if (split.length != 2 || (parseInt = Integer.parseInt(split[0])) > (parseInt2 = Integer.parseInt(split[1]))) {
                        return null;
                    }
                    arrayList.add(new Pair(Integer.valueOf(parseInt), Integer.valueOf(parseInt2)));
                    i++;
                } catch (NumberFormatException | PatternSyntaxException unused) {
                    return null;
                }
            }
        }
        return arrayList;
    }

    private void onCarrierConfigChanged() {
        this.mCarrierConfig = getCarrierConfig();
        log("Carrier Config changed.");
        updateArfcnLists();
        updateReportingCriteria();
    }

    private static SignalThresholdInfo createSignalThresholdsInfo(int i, int[] iArr, int i2, boolean z) {
        return new SignalThresholdInfo.Builder().setSignalMeasurementType(i).setThresholds(iArr).setRadioAccessNetworkType(i2).setIsEnabled(z).build();
    }

    private static final class AccessNetworkThresholds {
        public static final int[] CDMA2000 = {-105, -90, -75, -65};
        public static final int[] EUTRAN_RSRP = {-128, -118, -108, -98};
        public static final int[] EUTRAN_RSRQ = {-20, -17, -14, -11};
        public static final int[] EUTRAN_RSSNR = {-3, 1, 5, 13};
        public static final int[] GERAN = {-109, -103, -97, -89};
        public static final int[] NGRAN_SSRSRP = {-110, -90, -80, -65};
        public static final int[] NGRAN_SSRSRQ = {-31, -19, -7, 6};
        public static final int[] NGRAN_SSSINR = {-5, 5, 15, 30};
        public static final int[] UTRAN = {-114, -104, -94, -84};

        private AccessNetworkThresholds() {
        }
    }

    private static void loge(String str) {
        Rlog.e(TAG, str);
    }

    /* access modifiers changed from: private */
    public void localLog(String str) {
        Rlog.d(TAG, str);
        LocalLog localLog = this.mLocalLog;
        localLog.log("SSCtr: " + str);
    }
}
