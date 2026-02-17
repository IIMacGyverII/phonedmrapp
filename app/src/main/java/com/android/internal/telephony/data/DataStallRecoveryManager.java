package com.android.internal.telephony.data;

import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.SystemClock;
import android.telephony.SubscriptionManager;
import android.telephony.data.DataProfile;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.internal.telephony.data.DataSettingsManager;
import com.android.internal.telephony.metrics.DataStallRecoveryStats;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.Executor;

public class DataStallRecoveryManager extends Handler {
    private static final int EVENT_DATA_CONFIG_UPDATED = 1;
    private static final int EVENT_DO_RECOVERY = 2;
    private static final int EVENT_RADIO_STATE_CHANGED = 3;
    private static final int RECOVERED_REASON_DSRM = 1;
    private static final int RECOVERED_REASON_MODEM = 2;
    private static final int RECOVERED_REASON_NONE = 0;
    private static final int RECOVERED_REASON_USER = 3;
    public static final int RECOVERY_ACTION_CLEANUP = 1;
    public static final int RECOVERY_ACTION_GET_DATA_CALL_LIST = 0;
    public static final int RECOVERY_ACTION_RADIO_RESTART = 3;
    @Deprecated
    public static final int RECOVERY_ACTION_REREGISTER = 2;
    public static final int RECOVERY_ACTION_RESET_MODEM = 4;
    private static final boolean VDBG = false;
    private final DataConfigManager mDataConfigManager;
    private final DataNetworkController mDataNetworkController;
    private long[] mDataStallRecoveryDelayMillisArray;
    private DataStallRecoveryManagerCallback mDataStallRecoveryManagerCallback;
    private long mDataStallStartMs;
    private boolean mDataStalled;
    private boolean mIsAttemptedAllSteps;
    /* access modifiers changed from: private */
    public boolean mIsInternetNetworkConnected;
    private boolean mIsValidNetwork;
    private int mLastAction;
    private boolean mLastActionReported;
    private final LocalLog mLocalLog = new LocalLog(128);
    private final String mLogTag;
    private boolean mMobileDataChangedToEnabledDuringDataStall;
    private boolean mNetworkCheckTimerStarted = false;
    private final Phone mPhone;
    private int mRadioPowerState;
    private boolean mRadioStateChangedDuringDataStall;
    private int mRecovryAction;
    private boolean[] mSkipRecoveryActionArray;
    private long mTimeLastRecoveryStartMs;
    private final DataServiceManager mWwanDataServiceManager;

    @Retention(RetentionPolicy.SOURCE)
    public @interface RecoveredReason {
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface RecoveryAction {
    }

    private void logv(String str) {
    }

    public static abstract class DataStallRecoveryManagerCallback extends DataCallback {
        public abstract void onDataStallReestablishInternet();

        public DataStallRecoveryManagerCallback(Executor executor) {
            super(executor);
        }
    }

    public DataStallRecoveryManager(Phone phone, DataNetworkController dataNetworkController, DataServiceManager dataServiceManager, Looper looper, DataStallRecoveryManagerCallback dataStallRecoveryManagerCallback) {
        super(looper);
        this.mPhone = phone;
        this.mLogTag = "DSRM-" + phone.getPhoneId();
        log("DataStallRecoveryManager created.");
        this.mDataNetworkController = dataNetworkController;
        this.mWwanDataServiceManager = dataServiceManager;
        this.mDataConfigManager = dataNetworkController.getDataConfigManager();
        dataNetworkController.getDataSettingsManager().registerCallback(new DataSettingsManager.DataSettingsManagerCallback(new DataStallRecoveryManager$$ExternalSyntheticLambda0(this)) {
            public void onDataEnabledChanged(boolean z, int i, String str) {
                DataStallRecoveryManager.this.onMobileDataEnabledChanged(z);
            }
        });
        this.mDataStallRecoveryManagerCallback = dataStallRecoveryManagerCallback;
        this.mRadioPowerState = phone.getRadioPowerState();
        updateDataStallRecoveryConfigs();
        registerAllEvents();
    }

    private void registerAllEvents() {
        this.mDataConfigManager.registerForConfigUpdate(this, 1);
        this.mDataNetworkController.registerDataNetworkControllerCallback(new DataNetworkController.DataNetworkControllerCallback(new DataStallRecoveryManager$$ExternalSyntheticLambda0(this)) {
            public void onInternetDataNetworkValidationStatusChanged(int i) {
                DataStallRecoveryManager.this.onInternetValidationStatusChanged(i);
            }

            public void onInternetDataNetworkConnected(List<DataProfile> list) {
                DataStallRecoveryManager.this.mIsInternetNetworkConnected = true;
                DataStallRecoveryManager.this.logl("onInternetDataNetworkConnected");
            }

            public void onInternetDataNetworkDisconnected() {
                DataStallRecoveryManager.this.mIsInternetNetworkConnected = false;
                DataStallRecoveryManager.this.logl("onInternetDataNetworkDisconnected");
            }
        });
        this.mPhone.mCi.registerForRadioStateChanged(this, 3, (Object) null);
    }

    public void handleMessage(Message message) {
        logv("handleMessage = " + message);
        int i = message.what;
        if (i == 1) {
            onDataConfigUpdated();
        } else if (i == 2) {
            doRecovery();
        } else if (i != 3) {
            loge("Unexpected message = " + message);
        } else {
            this.mRadioPowerState = this.mPhone.getRadioPowerState();
            if (this.mDataStalled) {
                this.mRadioStateChangedDuringDataStall = true;
            }
        }
    }

    private void updateDataStallRecoveryConfigs() {
        this.mDataStallRecoveryDelayMillisArray = this.mDataConfigManager.getDataStallRecoveryDelayMillis();
        this.mSkipRecoveryActionArray = this.mDataConfigManager.getDataStallRecoveryShouldSkipArray();
    }

    private long getDataStallRecoveryDelayMillis(int i) {
        return this.mDataStallRecoveryDelayMillisArray[i];
    }

    private boolean shouldSkipRecoveryAction(int i) {
        return this.mSkipRecoveryActionArray[i];
    }

    private void onDataConfigUpdated() {
        updateDataStallRecoveryConfigs();
    }

    /* access modifiers changed from: private */
    public void onMobileDataEnabledChanged(boolean z) {
        logl("onMobileDataEnabledChanged: DataEnabled:" + z + ",DataStalled:" + this.mDataStalled);
        if (this.mDataStalled && z) {
            this.mMobileDataChangedToEnabledDuringDataStall = true;
        }
    }

    private void reset() {
        this.mIsValidNetwork = true;
        this.mIsAttemptedAllSteps = false;
        this.mRadioStateChangedDuringDataStall = false;
        this.mMobileDataChangedToEnabledDuringDataStall = false;
        cancelNetworkCheckTimer();
        this.mTimeLastRecoveryStartMs = 0;
        this.mLastAction = 0;
        this.mRecovryAction = 0;
    }

    /* access modifiers changed from: private */
    public void onInternetValidationStatusChanged(int i) {
        logl("onInternetValidationStatusChanged: " + DataUtils.validationStatusToString(i));
        boolean z = i == 1;
        setNetworkValidationState(z);
        if (z) {
            reset();
        } else if (this.mIsValidNetwork || isRecoveryAlreadyStarted()) {
            this.mIsValidNetwork = false;
            if (isRecoveryNeeded(true)) {
                log("trigger data stall recovery");
                this.mTimeLastRecoveryStartMs = SystemClock.elapsedRealtime();
                sendMessage(obtainMessage(2));
            }
        }
    }

    private void resetAction() {
        this.mTimeLastRecoveryStartMs = 0;
        this.mMobileDataChangedToEnabledDuringDataStall = false;
        this.mRadioStateChangedDuringDataStall = false;
        setRecoveryAction(0);
    }

    @VisibleForTesting
    public int getRecoveryAction() {
        log("getRecoveryAction: " + recoveryActionToString(this.mRecovryAction));
        return this.mRecovryAction;
    }

    @VisibleForTesting
    public void setRecoveryAction(int i) {
        this.mRecovryAction = i;
        if (this.mMobileDataChangedToEnabledDuringDataStall && i < 3) {
            this.mRecovryAction = 3;
        }
        if (this.mRadioStateChangedDuringDataStall && this.mRadioPowerState == 1) {
            this.mRecovryAction = 4;
        }
        if (shouldSkipRecoveryAction(this.mRecovryAction)) {
            int i2 = this.mRecovryAction;
            if (i2 == 0) {
                setRecoveryAction(1);
            } else if (i2 == 1) {
                setRecoveryAction(3);
            } else if (i2 == 3) {
                setRecoveryAction(4);
            } else if (i2 == 4) {
                resetAction();
            }
        }
        log("setRecoveryAction: " + recoveryActionToString(this.mRecovryAction));
    }

    private boolean isRecoveryAlreadyStarted() {
        return getRecoveryAction() != 0;
    }

    private long getElapsedTimeSinceRecoveryMs() {
        return SystemClock.elapsedRealtime() - this.mTimeLastRecoveryStartMs;
    }

    private void broadcastDataStallDetected(int i) {
        log("broadcastDataStallDetected recoveryAction: " + i);
        Intent intent = new Intent("android.intent.action.DATA_STALL_DETECTED");
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, this.mPhone.getPhoneId());
        intent.putExtra("recoveryAction", i);
        this.mPhone.getContext().sendBroadcast(intent);
    }

    private void getDataCallList() {
        log("getDataCallList: request data call list");
        this.mWwanDataServiceManager.requestDataCallList((Message) null);
    }

    private void cleanUpDataNetwork() {
        log("cleanUpDataNetwork: notify clean up data network");
        this.mDataStallRecoveryManagerCallback.invokeFromExecutor(new DataStallRecoveryManager$$ExternalSyntheticLambda1(this));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$cleanUpDataNetwork$0() {
        this.mDataStallRecoveryManagerCallback.onDataStallReestablishInternet();
    }

    private void powerOffRadio() {
        log("powerOffRadio: Restart radio");
        this.mPhone.getServiceStateTracker().powerOffRadioSafely();
    }

    private void rebootModem() {
        log("rebootModem: reboot modem");
        this.mPhone.rebootModem((Message) null);
    }

    private void startNetworkCheckTimer(int i) {
        if (i != 4) {
            log("startNetworkCheckTimer(): " + getDataStallRecoveryDelayMillis(i) + "ms");
            if (!this.mNetworkCheckTimerStarted) {
                this.mNetworkCheckTimerStarted = true;
                this.mTimeLastRecoveryStartMs = SystemClock.elapsedRealtime();
                sendMessageDelayed(obtainMessage(2), getDataStallRecoveryDelayMillis(i));
            }
        }
    }

    private void cancelNetworkCheckTimer() {
        log("cancelNetworkCheckTimer()");
        if (this.mNetworkCheckTimerStarted) {
            this.mNetworkCheckTimerStarted = false;
            removeMessages(2);
        }
    }

    private boolean isRecoveryNeeded(boolean z) {
        logv("enter: isRecoveryNeeded()");
        if (this.mIsAttemptedAllSteps) {
            logl("skip retrying continue recovery action");
            return false;
        } else if (getElapsedTimeSinceRecoveryMs() < getDataStallRecoveryDelayMillis(this.mLastAction) && z) {
            logl("skip back to back data stall recovery");
            return false;
        } else if (this.mPhone.getState() != PhoneConstants.State.IDLE && getRecoveryAction() > 1) {
            logl("skip data stall recovery as there is an active call");
            return false;
        } else if (this.mPhone.getSignalStrength().getLevel() <= 1) {
            logl("skip data stall recovery as in poor signal condition");
            return false;
        } else if (!this.mDataNetworkController.isInternetDataAllowed()) {
            logl("skip data stall recovery as data not allowed.");
            return false;
        } else if (this.mIsInternetNetworkConnected) {
            return true;
        } else {
            logl("skip data stall recovery as data not connected");
            return false;
        }
    }

    private void setNetworkValidationState(boolean z) {
        if (z && !this.mDataStalled) {
            return;
        }
        if (!this.mDataStalled) {
            this.mDataStalled = true;
            this.mDataStallStartMs = SystemClock.elapsedRealtime();
            logl("data stall: start time = " + DataUtils.elapsedTimeToString(this.mDataStallStartMs));
            return;
        }
        if (!this.mLastActionReported) {
            int recoveredReason = getRecoveredReason(z);
            int elapsedRealtime = (int) (SystemClock.elapsedRealtime() - this.mDataStallStartMs);
            logl("data stall: lastaction = " + recoveryActionToString(this.mLastAction) + ", isRecovered = " + z + ", reason = " + recoveredReasonToString(recoveredReason) + ", TimeDuration = " + elapsedRealtime);
            DataStallRecoveryStats.onDataStallEvent(this.mLastAction, this.mPhone, z, elapsedRealtime, recoveredReason);
            this.mLastActionReported = true;
        }
        if (z) {
            this.mLastActionReported = false;
            this.mDataStalled = false;
        }
    }

    private int getRecoveredReason(boolean z) {
        if (!z) {
            return 0;
        }
        if (this.mRadioStateChangedDuringDataStall) {
            int i = this.mLastAction;
            int i2 = i <= 1 ? 2 : 1;
            if (i > 1) {
                return 1;
            }
            return i2;
        } else if (this.mMobileDataChangedToEnabledDuringDataStall) {
            return 3;
        } else {
            return 1;
        }
    }

    private void doRecovery() {
        int recoveryAction = getRecoveryAction();
        int level = this.mPhone.getSignalStrength().getLevel();
        if (!isRecoveryNeeded(false)) {
            cancelNetworkCheckTimer();
            startNetworkCheckTimer(recoveryAction);
            return;
        }
        TelephonyMetrics.getInstance().writeSignalStrengthEvent(this.mPhone.getPhoneId(), level);
        TelephonyMetrics.getInstance().writeDataStallEvent(this.mPhone.getPhoneId(), recoveryAction);
        this.mLastAction = recoveryAction;
        this.mLastActionReported = false;
        broadcastDataStallDetected(recoveryAction);
        this.mNetworkCheckTimerStarted = false;
        if (recoveryAction == 0) {
            logl("doRecovery(): get data call list");
            getDataCallList();
            setRecoveryAction(1);
        } else if (recoveryAction == 1) {
            logl("doRecovery(): cleanup all connections");
            cleanUpDataNetwork();
            setRecoveryAction(3);
        } else if (recoveryAction == 3) {
            logl("doRecovery(): restarting radio");
            setRecoveryAction(4);
            powerOffRadio();
        } else if (recoveryAction == 4) {
            logl("doRecovery(): modem reset");
            rebootModem();
            resetAction();
            this.mIsAttemptedAllSteps = true;
        } else {
            throw new RuntimeException("doRecovery: Invalid recoveryAction = " + recoveryActionToString(recoveryAction));
        }
        startNetworkCheckTimer(this.mLastAction);
    }

    private static String recoveredReasonToString(int i) {
        if (i == 0) {
            return "RECOVERED_REASON_NONE";
        }
        if (i == 1) {
            return "RECOVERED_REASON_DSRM";
        }
        if (i == 2) {
            return "RECOVERED_REASON_MODEM";
        }
        if (i == 3) {
            return "RECOVERED_REASON_USER";
        }
        return "Unknown(" + i + ")";
    }

    private static String radioPowerStateToString(int i) {
        if (i == 0) {
            return "RADIO_POWER_OFF";
        }
        if (i == 1) {
            return "RADIO_POWER_ON";
        }
        if (i == 2) {
            return "RADIO_POWER_UNAVAILABLE";
        }
        return "Unknown(" + i + ")";
    }

    private static String recoveryActionToString(int i) {
        if (i == 0) {
            return "RECOVERY_ACTION_GET_DATA_CALL_LIST";
        }
        if (i == 1) {
            return "RECOVERY_ACTION_CLEANUP";
        }
        if (i == 3) {
            return "RECOVERY_ACTION_RADIO_RESTART";
        }
        if (i == 4) {
            return "RECOVERY_ACTION_RESET_MODEM";
        }
        return "Unknown(" + i + ")";
    }

    private void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    /* access modifiers changed from: private */
    public void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(DataStallRecoveryManager.class.getSimpleName() + "-" + this.mPhone.getPhoneId() + ":");
        androidUtilIndentingPrintWriter.increaseIndent();
        StringBuilder sb = new StringBuilder();
        sb.append("mIsValidNetwork=");
        sb.append(this.mIsValidNetwork);
        androidUtilIndentingPrintWriter.println(sb.toString());
        androidUtilIndentingPrintWriter.println("mIsInternetNetworkConnected=" + this.mIsInternetNetworkConnected);
        androidUtilIndentingPrintWriter.println("mDataStalled=" + this.mDataStalled);
        androidUtilIndentingPrintWriter.println("mLastAction=" + recoveryActionToString(this.mLastAction));
        androidUtilIndentingPrintWriter.println("mIsAttemptedAllSteps=" + this.mIsAttemptedAllSteps);
        androidUtilIndentingPrintWriter.println("mDataStallStartMs=" + DataUtils.elapsedTimeToString(this.mDataStallStartMs));
        androidUtilIndentingPrintWriter.println("mRadioPowerState=" + radioPowerStateToString(this.mRadioPowerState));
        androidUtilIndentingPrintWriter.println("mLastActionReported=" + this.mLastActionReported);
        androidUtilIndentingPrintWriter.println("mTimeLastRecoveryStartMs=" + DataUtils.elapsedTimeToString(this.mTimeLastRecoveryStartMs));
        androidUtilIndentingPrintWriter.println("getRecoveryAction()=" + recoveryActionToString(getRecoveryAction()));
        androidUtilIndentingPrintWriter.println("mRadioStateChangedDuringDataStall=" + this.mRadioStateChangedDuringDataStall);
        androidUtilIndentingPrintWriter.println("mMobileDataChangedToEnabledDuringDataStall=" + this.mMobileDataChangedToEnabledDuringDataStall);
        androidUtilIndentingPrintWriter.println("DataStallRecoveryDelayMillisArray=" + Arrays.toString(this.mDataStallRecoveryDelayMillisArray));
        androidUtilIndentingPrintWriter.println("SkipRecoveryActionArray=" + Arrays.toString(this.mSkipRecoveryActionArray));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("");
        androidUtilIndentingPrintWriter.println("Local logs:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.decreaseIndent();
    }
}
