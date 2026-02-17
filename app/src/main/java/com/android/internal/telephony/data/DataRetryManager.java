package com.android.internal.telephony.data;

import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.SystemClock;
import android.telephony.AccessNetworkConstants;
import android.telephony.AnomalyReporter;
import android.telephony.DataFailCause;
import android.telephony.data.DataProfile;
import android.telephony.data.ThrottleStatus;
import android.text.TextUtils;
import android.util.ArraySet;
import android.util.SparseArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.internal.telephony.data.DataProfileManager;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class DataRetryManager extends Handler {
    private static final int EVENT_CANCEL_PENDING_HANDOVER_RETRY = 7;
    private static final int EVENT_DATA_CONFIG_UPDATED = 1;
    protected static final int EVENT_DATA_HANDOVER_RETRY = 4;
    private static final int EVENT_DATA_PROFILE_UNTHROTTLED = 6;
    protected static final int EVENT_DATA_SETUP_RETRY = 3;
    private static final int EVENT_MODEM_RESET = 9;
    private static final int EVENT_RADIO_ON = 8;
    private static final int EVENT_TAC_CHANGED = 10;
    private static final int MAXIMUM_HISTORICAL_ENTRIES = 100;
    private static final int RESET_REASON_DATA_CONFIG_CHANGED = 5;
    private static final int RESET_REASON_DATA_PROFILES_CHANGED = 1;
    private static final int RESET_REASON_DATA_SERVICE_BOUND = 4;
    public static final int RESET_REASON_MODEM_RESTART = 3;
    private static final int RESET_REASON_RADIO_ON = 2;
    private static final int RESET_REASON_TAC_CHANGED = 6;
    private static final boolean VDBG = false;
    private final DataConfigManager mDataConfigManager;
    private List<DataHandoverRetryRule> mDataHandoverRetryRuleList = new ArrayList();
    private final DataProfileManager mDataProfileManager;
    private final List<DataRetryEntry> mDataRetryEntries = new ArrayList();
    private Set<DataRetryManagerCallback> mDataRetryManagerCallbacks = new ArraySet();
    private SparseArray<DataServiceManager> mDataServiceManagers;
    private List<DataSetupRetryRule> mDataSetupRetryRuleList = new ArrayList();
    protected final List<DataThrottlingEntry> mDataThrottlingEntries = new ArrayList();
    private final LocalLog mLocalLog = new LocalLog(128);
    protected final String mLogTag;
    private final Phone mPhone;
    private final CommandsInterface mRil;

    public @interface RetryResetReason {
    }

    /* access modifiers changed from: protected */
    public void logv(String str) {
    }

    public static class DataThrottlingEntry {
        public final DataNetwork dataNetwork;
        public final DataProfile dataProfile;
        public final long expirationTimeMillis;
        public final DataNetworkController.NetworkRequestList networkRequestList;
        @ThrottleStatus.RetryType
        public final int retryType;
        public final int transport;

        public DataThrottlingEntry(DataProfile dataProfile2, DataNetworkController.NetworkRequestList networkRequestList2, DataNetwork dataNetwork2, int i, @ThrottleStatus.RetryType int i2, long j) {
            this.dataProfile = dataProfile2;
            this.networkRequestList = networkRequestList2;
            this.dataNetwork = dataNetwork2;
            this.transport = i;
            this.retryType = i2;
            this.expirationTimeMillis = j;
        }

        public String toString() {
            return "[DataThrottlingEntry: dataProfile=" + this.dataProfile + ", request list=" + this.networkRequestList + ", dataNetwork=" + this.dataNetwork + ", transport=" + AccessNetworkConstants.transportTypeToString(this.transport) + ", expiration time=" + DataUtils.elapsedTimeToString(this.expirationTimeMillis) + "]";
        }
    }

    public static class DataRetryRule {
        private static final String RULE_TAG_FAIL_CAUSES = "fail_causes";
        private static final String RULE_TAG_MAXIMUM_RETRIES = "maximum_retries";
        private static final String RULE_TAG_RETRY_INTERVAL = "retry_interval";
        protected Set<Integer> mFailCauses = new ArraySet();
        protected int mMaxRetries = 10;
        protected Set<Integer> mNetworkCapabilities = new ArraySet();
        protected List<Long> mRetryIntervalsMillis = List.of(Long.valueOf(TimeUnit.SECONDS.toMillis(5)));

        public DataRetryRule(String str) {
            if (!TextUtils.isEmpty(str)) {
                String lowerCase = str.trim().toLowerCase(Locale.ROOT);
                String[] split = lowerCase.split("\\s*,\\s*");
                int length = split.length;
                int i = 0;
                while (i < length) {
                    String[] split2 = split[i].trim().split("\\s*=\\s*");
                    if (split2.length == 2) {
                        String trim = split2[0].trim();
                        String trim2 = split2[1].trim();
                        char c = 65535;
                        try {
                            int hashCode = trim.hashCode();
                            if (hashCode != -958847449) {
                                if (hashCode != -705617557) {
                                    if (hashCode == 384266364) {
                                        if (trim.equals(RULE_TAG_RETRY_INTERVAL)) {
                                            c = 1;
                                        }
                                    }
                                } else if (trim.equals(RULE_TAG_FAIL_CAUSES)) {
                                    c = 0;
                                }
                            } else if (trim.equals(RULE_TAG_MAXIMUM_RETRIES)) {
                                c = 2;
                            }
                            if (c == 0) {
                                this.mFailCauses = (Set) Arrays.stream(trim2.split("\\s*\\|\\s*")).map(new DataNetworkController$HandoverRule$$ExternalSyntheticLambda0()).map(new DataRetryManager$DataRetryRule$$ExternalSyntheticLambda0()).collect(Collectors.toSet());
                            } else if (c == 1) {
                                this.mRetryIntervalsMillis = (List) Arrays.stream(trim2.split("\\s*\\|\\s*")).map(new DataNetworkController$HandoverRule$$ExternalSyntheticLambda0()).map(new DataRetryManager$DataRetryRule$$ExternalSyntheticLambda1()).collect(Collectors.toList());
                            } else if (c == 2) {
                                this.mMaxRetries = Integer.parseInt(trim2);
                            }
                            i++;
                        } catch (Exception e) {
                            e.printStackTrace();
                            throw new IllegalArgumentException("illegal rule " + lowerCase + ", e=" + e);
                        }
                    } else {
                        throw new IllegalArgumentException("illegal rule " + lowerCase);
                    }
                }
                if (this.mMaxRetries == 0) {
                    this.mRetryIntervalsMillis = Collections.emptyList();
                }
                if (this.mMaxRetries < 0) {
                    throw new IllegalArgumentException("Max retries should not be less than 0. mMaxRetries=" + this.mMaxRetries);
                } else if (this.mRetryIntervalsMillis.stream().anyMatch(new DataRetryManager$DataRetryRule$$ExternalSyntheticLambda2())) {
                    throw new IllegalArgumentException("Retry interval should not be less than 0. mRetryIntervalsMillis=" + this.mRetryIntervalsMillis);
                }
            } else {
                throw new IllegalArgumentException("illegal rule " + str);
            }
        }

        /* access modifiers changed from: private */
        public static /* synthetic */ boolean lambda$new$0(Long l) {
            return l.longValue() <= 0;
        }

        public List<Long> getRetryIntervalsMillis() {
            return this.mRetryIntervalsMillis;
        }

        public int getMaxRetries() {
            return this.mMaxRetries;
        }

        @VisibleForTesting
        public Set<Integer> getFailCauses() {
            return this.mFailCauses;
        }
    }

    public static class DataSetupRetryRule extends DataRetryRule {
        private static final String RULE_TAG_CAPABILITIES = "capabilities";

        public DataSetupRetryRule(String str) {
            super(str);
            String lowerCase = str.trim().toLowerCase(Locale.ROOT);
            String[] split = lowerCase.split("\\s*,\\s*");
            int length = split.length;
            int i = 0;
            while (i < length) {
                String[] split2 = split[i].trim().split("\\s*=\\s*");
                if (split2.length == 2) {
                    String trim = split2[0].trim();
                    String trim2 = split2[1].trim();
                    if (trim.equals(RULE_TAG_CAPABILITIES)) {
                        this.mNetworkCapabilities = DataUtils.getNetworkCapabilitiesFromString(trim2);
                    }
                    i++;
                } else {
                    throw new IllegalArgumentException("illegal rule " + lowerCase);
                }
            }
            if (!this.mFailCauses.isEmpty()) {
                return;
            }
            if (this.mNetworkCapabilities.isEmpty() || this.mNetworkCapabilities.contains(-1)) {
                throw new IllegalArgumentException("illegal rule " + lowerCase + ". Should have either valid network capabilities or fail causes.");
            }
        }

        @VisibleForTesting
        public Set<Integer> getNetworkCapabilities() {
            return this.mNetworkCapabilities;
        }

        public boolean canBeMatched(int i, int i2) {
            if (!this.mFailCauses.isEmpty() && !this.mFailCauses.contains(Integer.valueOf(i2))) {
                return false;
            }
            if (this.mNetworkCapabilities.isEmpty() || this.mNetworkCapabilities.contains(Integer.valueOf(i))) {
                return true;
            }
            return false;
        }

        public String toString() {
            return "[DataSetupRetryRule: Network capabilities:" + DataUtils.networkCapabilitiesToString(this.mNetworkCapabilities.stream().mapToInt(new DataRetryManager$DataSetupRetryRule$$ExternalSyntheticLambda0()).toArray()) + ", Fail causes=" + this.mFailCauses + ", Retry intervals=" + this.mRetryIntervalsMillis + ", Maximum retries=" + this.mMaxRetries + "]";
        }
    }

    public static class DataHandoverRetryRule extends DataRetryRule {
        public DataHandoverRetryRule(String str) {
            super(str);
        }

        public String toString() {
            return "[DataHandoverRetryRule: Retry intervals=" + this.mRetryIntervalsMillis + ", Fail causes=" + this.mFailCauses + ", Maximum retries=" + this.mMaxRetries + "]";
        }
    }

    public static class DataRetryEntry {
        public static final int RETRY_STATE_CANCELLED = 4;
        public static final int RETRY_STATE_FAILED = 2;
        public static final int RETRY_STATE_NOT_RETRIED = 1;
        public static final int RETRY_STATE_SUCCEEDED = 3;
        public final DataRetryRule appliedDataRetryRule;
        protected int mRetryState = 1;
        protected long mRetryStateTimestamp = 0;
        public final long retryDelayMillis;
        public final long retryElapsedTime;

        public @interface DataRetryState {
        }

        public DataRetryEntry(DataRetryRule dataRetryRule, long j) {
            this.appliedDataRetryRule = dataRetryRule;
            this.retryDelayMillis = j;
            long elapsedRealtime = SystemClock.elapsedRealtime();
            this.mRetryStateTimestamp = elapsedRealtime;
            this.retryElapsedTime = elapsedRealtime + j;
        }

        public void setState(@DataRetryState int i) {
            this.mRetryState = i;
            this.mRetryStateTimestamp = SystemClock.elapsedRealtime();
        }

        @DataRetryState
        public int getState() {
            return this.mRetryState;
        }

        public static String retryStateToString(@DataRetryState int i) {
            if (i == 1) {
                return "NOT_RETRIED";
            }
            if (i == 2) {
                return "FAILED";
            }
            if (i == 3) {
                return "SUCCEEDED";
            }
            if (i == 4) {
                return "CANCELLED";
            }
            return "Unknown(" + i + ")";
        }

        public static class Builder<T extends Builder<T>> {
            protected DataRetryRule mAppliedDataRetryRule;
            protected long mRetryDelayMillis = TimeUnit.SECONDS.toMillis(5);

            public T setRetryDelay(long j) {
                this.mRetryDelayMillis = j;
                return this;
            }

            public T setAppliedRetryRule(DataRetryRule dataRetryRule) {
                this.mAppliedDataRetryRule = dataRetryRule;
                return this;
            }
        }
    }

    public static class DataSetupRetryEntry extends DataRetryEntry {
        public static final int RETRY_TYPE_DATA_PROFILE = 1;
        public static final int RETRY_TYPE_NETWORK_REQUESTS = 2;
        public static final int RETRY_TYPE_UNKNOWN = 0;
        public final DataProfile dataProfile;
        public final DataNetworkController.NetworkRequestList networkRequestList;
        @SetupRetryType
        public final int setupRetryType;
        public final int transport;

        public @interface SetupRetryType {
        }

        private DataSetupRetryEntry(@SetupRetryType int i, DataNetworkController.NetworkRequestList networkRequestList2, DataProfile dataProfile2, int i2, DataSetupRetryRule dataSetupRetryRule, long j) {
            super(dataSetupRetryRule, j);
            this.setupRetryType = i;
            this.networkRequestList = networkRequestList2;
            this.dataProfile = dataProfile2;
            this.transport = i2;
        }

        private static String retryTypeToString(@SetupRetryType int i) {
            if (i == 1) {
                return "BY_PROFILE";
            }
            if (i == 2) {
                return "BY_NETWORK_REQUESTS";
            }
            return "Unknown(" + i + ")";
        }

        public String toString() {
            return "[DataSetupRetryEntry: delay=" + this.retryDelayMillis + "ms, retry time:" + DataUtils.elapsedTimeToString(this.retryElapsedTime) + ", " + this.dataProfile + ", transport=" + AccessNetworkConstants.transportTypeToString(this.transport) + ", retry type=" + retryTypeToString(this.setupRetryType) + ", retry requests=" + this.networkRequestList + ", applied rule=" + this.appliedDataRetryRule + ", state=" + DataRetryEntry.retryStateToString(this.mRetryState) + ", timestamp=" + DataUtils.elapsedTimeToString(this.mRetryStateTimestamp) + "]";
        }

        public static class Builder<T extends Builder<T>> extends DataRetryEntry.Builder<T> {
            private DataProfile mDataProfile;
            private DataNetworkController.NetworkRequestList mNetworkRequestList;
            @SetupRetryType
            private int mSetupRetryType = 0;
            private int mTransport = -1;

            public Builder<T> setSetupRetryType(@SetupRetryType int i) {
                this.mSetupRetryType = i;
                return this;
            }

            public Builder<T> setNetworkRequestList(DataNetworkController.NetworkRequestList networkRequestList) {
                this.mNetworkRequestList = networkRequestList;
                return this;
            }

            public Builder<T> setDataProfile(DataProfile dataProfile) {
                this.mDataProfile = dataProfile;
                return this;
            }

            public Builder<T> setTransport(int i) {
                this.mTransport = i;
                return this;
            }

            public DataSetupRetryEntry build() {
                DataNetworkController.NetworkRequestList networkRequestList = this.mNetworkRequestList;
                if (networkRequestList != null) {
                    int i = this.mTransport;
                    if (i == 1 || i == 2) {
                        int i2 = this.mSetupRetryType;
                        if (i2 == 1 || i2 == 2) {
                            return new DataSetupRetryEntry(i2, networkRequestList, this.mDataProfile, i, (DataSetupRetryRule) this.mAppliedDataRetryRule, this.mRetryDelayMillis);
                        }
                        throw new IllegalArgumentException("Invalid setup retry type " + this.mSetupRetryType);
                    }
                    throw new IllegalArgumentException("Invalid transport type " + this.mTransport);
                }
                throw new IllegalArgumentException("network request list is not specified.");
            }
        }
    }

    public static class DataHandoverRetryEntry extends DataRetryEntry {
        public final DataNetwork dataNetwork;

        public DataHandoverRetryEntry(DataNetwork dataNetwork2, DataHandoverRetryRule dataHandoverRetryRule, long j) {
            super(dataHandoverRetryRule, j);
            this.dataNetwork = dataNetwork2;
        }

        public String toString() {
            return "[DataHandoverRetryEntry: delay=" + this.retryDelayMillis + "ms, retry time:" + DataUtils.elapsedTimeToString(this.retryElapsedTime) + ", " + this.dataNetwork + ", applied rule=" + this.appliedDataRetryRule + ", state=" + DataRetryEntry.retryStateToString(this.mRetryState) + ", timestamp=" + DataUtils.elapsedTimeToString(this.mRetryStateTimestamp) + "]";
        }

        public static class Builder<T extends Builder<T>> extends DataRetryEntry.Builder<T> {
            public DataNetwork mDataNetwork;

            public Builder<T> setDataNetwork(DataNetwork dataNetwork) {
                this.mDataNetwork = dataNetwork;
                return this;
            }

            public DataHandoverRetryEntry build() {
                return new DataHandoverRetryEntry(this.mDataNetwork, (DataHandoverRetryRule) this.mAppliedDataRetryRule, this.mRetryDelayMillis);
            }
        }
    }

    public static class DataRetryManagerCallback extends DataCallback {
        public void onDataNetworkHandoverRetry(DataHandoverRetryEntry dataHandoverRetryEntry) {
        }

        public void onDataNetworkHandoverRetryStopped(DataNetwork dataNetwork) {
        }

        public void onDataNetworkSetupRetry(DataSetupRetryEntry dataSetupRetryEntry) {
        }

        public void onThrottleStatusChanged(List<ThrottleStatus> list) {
        }

        public DataRetryManagerCallback(Executor executor) {
            super(executor);
        }
    }

    public DataRetryManager(Phone phone, DataNetworkController dataNetworkController, SparseArray<DataServiceManager> sparseArray, Looper looper, DataRetryManagerCallback dataRetryManagerCallback) {
        super(looper);
        this.mPhone = phone;
        CommandsInterface commandsInterface = phone.mCi;
        this.mRil = commandsInterface;
        this.mLogTag = "DRM-" + phone.getPhoneId();
        this.mDataRetryManagerCallbacks.add(dataRetryManagerCallback);
        this.mDataServiceManagers = sparseArray;
        DataConfigManager dataConfigManager = dataNetworkController.getDataConfigManager();
        this.mDataConfigManager = dataConfigManager;
        DataProfileManager dataProfileManager = dataNetworkController.getDataProfileManager();
        this.mDataProfileManager = dataProfileManager;
        dataConfigManager.registerForConfigUpdate(this, 1);
        this.mDataServiceManagers.get(1).registerForApnUnthrottled(this, 6);
        if (!phone.getAccessNetworksManager().isInLegacyMode()) {
            this.mDataServiceManagers.get(2).registerForApnUnthrottled(this, 6);
        }
        dataProfileManager.registerCallback(new DataProfileManager.DataProfileManagerCallback(new DataRetryManager$$ExternalSyntheticLambda28(this)) {
            public void onDataProfilesChanged() {
                DataRetryManager.this.onReset(1);
            }
        });
        dataNetworkController.registerDataNetworkControllerCallback(new DataNetworkController.DataNetworkControllerCallback(new DataRetryManager$$ExternalSyntheticLambda28(this)) {
            public void onDataServiceBound(int i) {
                DataRetryManager.this.onReset(4);
            }
        });
        commandsInterface.registerForOn(this, 8, (Object) null);
        commandsInterface.registerForModemReset(this, 9, (Object) null);
        if (dataConfigManager.shouldResetDataThrottlingWhenTacChanges()) {
            phone.getServiceStateTracker().registerForAreaCodeChanged(this, 10, (Object) null);
        }
    }

    public void handleMessage(Message message) {
        String str;
        switch (message.what) {
            case 1:
                onDataConfigUpdated();
                return;
            case 3:
                DataSetupRetryEntry dataSetupRetryEntry = (DataSetupRetryEntry) message.obj;
                Objects.requireNonNull(dataSetupRetryEntry);
                this.mDataRetryManagerCallbacks.forEach(new DataRetryManager$$ExternalSyntheticLambda29(dataSetupRetryEntry));
                return;
            case 4:
                DataHandoverRetryEntry dataHandoverRetryEntry = (DataHandoverRetryEntry) message.obj;
                Objects.requireNonNull(dataHandoverRetryEntry);
                if (this.mDataRetryEntries.contains(dataHandoverRetryEntry)) {
                    this.mDataRetryManagerCallbacks.forEach(new DataRetryManager$$ExternalSyntheticLambda30(dataHandoverRetryEntry));
                    return;
                }
                log("Handover was cancelled earlier. " + dataHandoverRetryEntry);
                return;
            case 6:
                AsyncResult asyncResult = (AsyncResult) message.obj;
                int intValue = ((Integer) asyncResult.userObj).intValue();
                Object obj = asyncResult.result;
                DataProfile dataProfile = null;
                if (obj instanceof String) {
                    str = (String) obj;
                } else if (obj instanceof DataProfile) {
                    dataProfile = (DataProfile) obj;
                    str = null;
                } else {
                    str = null;
                }
                onDataProfileUnthrottled(dataProfile, str, intValue, true);
                return;
            case 7:
                onCancelPendingHandoverRetry((DataNetwork) message.obj);
                return;
            case 8:
                onReset(2);
                return;
            case 9:
                onReset(3);
                return;
            case 10:
                onReset(6);
                return;
            default:
                loge("Unexpected message " + message.what);
                return;
        }
    }

    private void onDataConfigUpdated() {
        onReset(5);
        this.mDataSetupRetryRuleList = this.mDataConfigManager.getDataSetupRetryRules();
        this.mDataHandoverRetryRuleList = this.mDataConfigManager.getDataHandoverRetryRules();
        log("onDataConfigUpdated: mDataSetupRetryRuleList=" + this.mDataSetupRetryRuleList + ", mDataHandoverRetryRuleList=" + this.mDataHandoverRetryRuleList);
    }

    public void evaluateDataSetupRetry(DataProfile dataProfile, int i, DataNetworkController.NetworkRequestList networkRequestList, int i2, long j) {
        post(new DataRetryManager$$ExternalSyntheticLambda10(this, dataProfile, i, networkRequestList, i2, j));
    }

    /* access modifiers changed from: private */
    /* renamed from: onEvaluateDataSetupRetry */
    public void lambda$evaluateDataSetupRetry$4(DataProfile dataProfile, int i, DataNetworkController.NetworkRequestList networkRequestList, int i2, long j) {
        logl("onEvaluateDataSetupRetry: " + dataProfile + ", transport=" + AccessNetworkConstants.transportTypeToString(i) + ", cause=" + DataFailCause.toString(i2) + ", retryDelayMillis=" + j + "ms, " + networkRequestList);
        if (j == Long.MAX_VALUE || j == 2147483647L) {
            logl("Network suggested never retry for " + dataProfile);
            updateThrottleStatus(dataProfile, networkRequestList, (DataNetwork) null, 2, i, Long.MAX_VALUE);
        } else if (j != -1) {
            DataSetupRetryEntry build = ((DataSetupRetryEntry.Builder) new DataSetupRetryEntry.Builder().setRetryDelay(j)).setSetupRetryType(1).setNetworkRequestList(networkRequestList).setDataProfile(dataProfile).setTransport(i).build();
            updateThrottleStatus(dataProfile, networkRequestList, (DataNetwork) null, 2, i, build.retryElapsedTime);
            schedule(build);
        } else {
            logv("mDataSetupRetryRuleList=" + this.mDataSetupRetryRuleList);
            if (DataFailCause.isPermanentFailure(this.mPhone.getContext(), i2, this.mPhone.getSubId())) {
                log("Stopped timer-based retry. cause=" + DataFailCause.toString(i2));
                return;
            }
            boolean z = false;
            for (DataNetworkController.NetworkRequestList next : DataUtils.getGroupedNetworkRequestList(networkRequestList)) {
                int apnTypeNetworkCapability = ((TelephonyNetworkRequest) next.get(0)).getApnTypeNetworkCapability();
                Iterator<DataSetupRetryRule> it = this.mDataSetupRetryRuleList.iterator();
                while (true) {
                    if (!it.hasNext()) {
                        break;
                    }
                    DataSetupRetryRule next2 = it.next();
                    if (next2.canBeMatched(apnTypeNetworkCapability, i2)) {
                        if (isSimilarNetworkRequestRetryScheduled((TelephonyNetworkRequest) next.get(0), i)) {
                            log(next.get(0) + " already had similar retry scheduled.");
                            return;
                        }
                        int retryFailedCount = getRetryFailedCount(apnTypeNetworkCapability, next2);
                        log("For capability " + DataUtils.networkCapabilityToString(apnTypeNetworkCapability) + ", found matching rule " + next2 + ", failed count=" + retryFailedCount);
                        if (retryFailedCount == next2.getMaxRetries()) {
                            log("Data retry failed for " + retryFailedCount + " times. Stopped timer-based data retry for " + DataUtils.networkCapabilityToString(apnTypeNetworkCapability) + ". Condition-based retry will still happen when condition changes.");
                            return;
                        }
                        schedule(((DataSetupRetryEntry.Builder) ((DataSetupRetryEntry.Builder) new DataSetupRetryEntry.Builder().setRetryDelay(next2.getRetryIntervalsMillis().get(Math.min(retryFailedCount, next2.getRetryIntervalsMillis().size() - 1)).longValue())).setAppliedRetryRule(next2)).setSetupRetryType(2).setTransport(i).setNetworkRequestList(next).build());
                        z = true;
                    }
                }
            }
            if (!z) {
                log("onEvaluateDataSetupRetry: Did not match any retry rule. Stop timer-based retry.");
            }
        }
    }

    public void evaluateDataHandoverRetry(DataNetwork dataNetwork, int i, long j) {
        post(new DataRetryManager$$ExternalSyntheticLambda3(this, dataNetwork, i, j));
    }

    /* access modifiers changed from: private */
    /* renamed from: onEvaluateDataHandoverRetry */
    public void lambda$evaluateDataHandoverRetry$5(DataNetwork dataNetwork, int i, long j) {
        logl("onEvaluateDataHandoverRetry: " + dataNetwork + ", cause=" + DataFailCause.toString(i) + ", retryDelayMillis=" + j + "ms");
        int targetTransport = DataUtils.getTargetTransport(dataNetwork.getTransport());
        if (j == Long.MAX_VALUE || j == 2147483647L) {
            logl("Network suggested never retry handover for " + dataNetwork);
            updateThrottleStatus(dataNetwork.getDataProfile(), dataNetwork.getAttachedNetworkRequestList(), dataNetwork, 3, targetTransport, Long.MAX_VALUE);
        } else if (j != -1) {
            DataHandoverRetryEntry build = ((DataHandoverRetryEntry.Builder) new DataHandoverRetryEntry.Builder().setRetryDelay(j)).setDataNetwork(dataNetwork).build();
            updateThrottleStatus(dataNetwork.getDataProfile(), dataNetwork.getAttachedNetworkRequestList(), dataNetwork, 3, targetTransport, build.retryElapsedTime);
            schedule(build);
        } else {
            for (DataHandoverRetryRule next : this.mDataHandoverRetryRuleList) {
                if (next.getFailCauses().isEmpty() || next.getFailCauses().contains(Integer.valueOf(i))) {
                    int retryFailedCount = getRetryFailedCount(dataNetwork, next);
                    log("Found matching rule " + next + ", failed count=" + retryFailedCount);
                    if (retryFailedCount == next.getMaxRetries()) {
                        log("Data handover retry failed for " + retryFailedCount + " times. Stopped handover retry.");
                        this.mDataRetryManagerCallbacks.forEach(new DataRetryManager$$ExternalSyntheticLambda26(dataNetwork));
                        return;
                    }
                    schedule(((DataHandoverRetryEntry.Builder) ((DataHandoverRetryEntry.Builder) new DataHandoverRetryEntry.Builder().setRetryDelay(next.getRetryIntervalsMillis().get(Math.min(retryFailedCount, next.getRetryIntervalsMillis().size() - 1)).longValue())).setDataNetwork(dataNetwork).setAppliedRetryRule(next)).build());
                }
            }
        }
    }

    public void onReset(@RetryResetReason int i) {
        logl("Remove all retry and throttling entries, reason=" + resetReasonToString(i));
        removeMessages(3);
        removeMessages(4);
        this.mDataRetryEntries.stream().filter(new DataRetryManager$$ExternalSyntheticLambda4()).forEach(new DataRetryManager$$ExternalSyntheticLambda5());
        for (DataThrottlingEntry next : this.mDataThrottlingEntries) {
            DataProfile dataProfile = next.dataProfile;
            onDataProfileUnthrottled(dataProfile, dataProfile.getApnSetting() != null ? dataProfile.getApnSetting().getApnName() : null, next.transport, false);
        }
        this.mDataThrottlingEntries.clear();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onReset$8(DataRetryEntry dataRetryEntry) {
        return dataRetryEntry.getState() == 1;
    }

    private int getRetryFailedCount(DataNetwork dataNetwork, DataHandoverRetryRule dataHandoverRetryRule) {
        int i = 0;
        for (int size = this.mDataRetryEntries.size() - 1; size >= 0; size--) {
            if (this.mDataRetryEntries.get(size) instanceof DataHandoverRetryEntry) {
                DataHandoverRetryEntry dataHandoverRetryEntry = (DataHandoverRetryEntry) this.mDataRetryEntries.get(size);
                if (dataHandoverRetryEntry.dataNetwork == dataNetwork && dataHandoverRetryRule.equals(dataHandoverRetryEntry.appliedDataRetryRule)) {
                    if (dataHandoverRetryEntry.getState() == 3 || dataHandoverRetryEntry.getState() == 4) {
                        break;
                    }
                    i++;
                }
            }
        }
        return i;
    }

    private int getRetryFailedCount(int i, DataSetupRetryRule dataSetupRetryRule) {
        int i2 = 0;
        for (int size = this.mDataRetryEntries.size() - 1; size >= 0; size--) {
            if (this.mDataRetryEntries.get(size) instanceof DataSetupRetryEntry) {
                DataSetupRetryEntry dataSetupRetryEntry = (DataSetupRetryEntry) this.mDataRetryEntries.get(size);
                if (!dataSetupRetryEntry.networkRequestList.isEmpty() && dataSetupRetryEntry.setupRetryType == 2) {
                    if (!dataSetupRetryEntry.networkRequestList.isEmpty()) {
                        if (((TelephonyNetworkRequest) dataSetupRetryEntry.networkRequestList.get(0)).getApnTypeNetworkCapability() == i && dataSetupRetryEntry.appliedDataRetryRule.equals(dataSetupRetryRule)) {
                            if (dataSetupRetryEntry.getState() == 3 || dataSetupRetryEntry.getState() == 4) {
                                break;
                            }
                            i2++;
                        }
                    } else {
                        logl("Invalid data retry entry detected");
                        loge("mDataRetryEntries=" + this.mDataRetryEntries);
                        AnomalyReporter.reportAnomaly(UUID.fromString("afeab78c-c0b0-49fc-a51f-f766814d7aa6"), "Invalid data retry entry detected", this.mPhone.getCarrierId());
                    }
                }
            }
        }
        return i2;
    }

    private void schedule(DataRetryEntry dataRetryEntry) {
        logl("Scheduled data retry: " + dataRetryEntry);
        this.mDataRetryEntries.add(dataRetryEntry);
        if (this.mDataRetryEntries.size() >= 100) {
            this.mDataRetryEntries.remove(0);
        }
        sendMessageDelayed(obtainMessage(dataRetryEntry instanceof DataSetupRetryEntry ? 3 : 4, dataRetryEntry), dataRetryEntry.retryDelayMillis);
    }

    private void updateThrottleStatus(DataProfile dataProfile, DataNetworkController.NetworkRequestList networkRequestList, DataNetwork dataNetwork, @ThrottleStatus.RetryType int i, int i2, long j) {
        DataThrottlingEntry dataThrottlingEntry = new DataThrottlingEntry(dataProfile, networkRequestList, dataNetwork, i2, i, j);
        if (this.mDataThrottlingEntries.size() >= 100) {
            this.mDataThrottlingEntries.remove(0);
        }
        this.mDataThrottlingEntries.removeIf(new DataRetryManager$$ExternalSyntheticLambda19(dataProfile));
        logl("Add throttling entry " + dataThrottlingEntry);
        this.mDataThrottlingEntries.add(dataThrottlingEntry);
        int i3 = j == Long.MAX_VALUE ? 1 : i;
        ArrayList arrayList = new ArrayList();
        if (dataProfile.getApnSetting() != null) {
            arrayList.addAll((Collection) dataProfile.getApnSetting().getApnTypes().stream().map(new DataRetryManager$$ExternalSyntheticLambda20(this, i3, j, i2)).collect(Collectors.toList()));
        }
        this.mDataRetryManagerCallbacks.forEach(new DataRetryManager$$ExternalSyntheticLambda21(arrayList));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ ThrottleStatus lambda$updateThrottleStatus$11(int i, long j, int i2, Integer num) {
        return new ThrottleStatus.Builder().setApnType(num.intValue()).setRetryType(i).setSlotIndex(this.mPhone.getPhoneId()).setThrottleExpiryTimeMillis(j).setTransportType(i2).build();
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r8v10, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v3, resolved type: java.util.List} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r8v12, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v7, resolved type: java.util.List} */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void onDataProfileUnthrottled(android.telephony.data.DataProfile r8, java.lang.String r9, int r10, boolean r11) {
        /*
            r7 = this;
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "onDataProfileUnthrottled: data profile="
            r0.append(r1)
            r0.append(r8)
            java.lang.String r1 = ", apn="
            r0.append(r1)
            r0.append(r9)
            java.lang.String r1 = ", transport="
            r0.append(r1)
            java.lang.String r1 = android.telephony.AccessNetworkConstants.transportTypeToString(r10)
            r0.append(r1)
            java.lang.String r1 = ", remove="
            r0.append(r1)
            r0.append(r11)
            java.lang.String r0 = r0.toString()
            r7.log(r0)
            long r0 = android.os.SystemClock.elapsedRealtime()
            java.util.ArrayList r2 = new java.util.ArrayList
            r2.<init>()
            if (r8 == 0) goto L_0x008b
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r2 = "onDataProfileUnthrottled: dataProfile="
            r9.append(r2)
            r9.append(r8)
            java.lang.String r9 = r9.toString()
            r7.log(r9)
            java.util.List<com.android.internal.telephony.data.DataRetryManager$DataThrottlingEntry> r9 = r7.mDataThrottlingEntries
            java.util.stream.Stream r9 = r9.stream()
            com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda12 r2 = new com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda12
            r2.<init>(r0)
            java.util.stream.Stream r9 = r9.filter(r2)
            android.telephony.data.ApnSetting r0 = r8.getApnSetting()
            if (r0 == 0) goto L_0x0076
            com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda13 r0 = new com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda13
            r0.<init>()
            java.util.stream.Stream r9 = r9.filter(r0)
            com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda14 r0 = new com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda14
            r0.<init>(r8)
            java.util.stream.Stream r9 = r9.filter(r0)
        L_0x0076:
            com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda15 r0 = new com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda15
            r0.<init>(r8)
            java.util.stream.Stream r8 = r9.filter(r0)
            java.util.stream.Collector r9 = java.util.stream.Collectors.toList()
            java.lang.Object r8 = r8.collect(r9)
            r2 = r8
            java.util.List r2 = (java.util.List) r2
            goto L_0x00a7
        L_0x008b:
            if (r9 == 0) goto L_0x00a7
            java.util.List<com.android.internal.telephony.data.DataRetryManager$DataThrottlingEntry> r8 = r7.mDataThrottlingEntries
            java.util.stream.Stream r8 = r8.stream()
            com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda16 r2 = new com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda16
            r2.<init>(r0, r9, r10)
            java.util.stream.Stream r8 = r8.filter(r2)
            java.util.stream.Collector r9 = java.util.stream.Collectors.toList()
            java.lang.Object r8 = r8.collect(r9)
            r2 = r8
            java.util.List r2 = (java.util.List) r2
        L_0x00a7:
            boolean r8 = r2.isEmpty()
            if (r8 == 0) goto L_0x00b3
            java.lang.String r8 = "onDataProfileUnthrottled: Nothing to unthrottle."
            r7.log(r8)
            return
        L_0x00b3:
            java.util.ArrayList r8 = new java.util.ArrayList
            r8.<init>()
            r9 = 0
            r0 = 0
            java.lang.Object r1 = r2.get(r0)
            com.android.internal.telephony.data.DataRetryManager$DataThrottlingEntry r1 = (com.android.internal.telephony.data.DataRetryManager.DataThrottlingEntry) r1
            int r1 = r1.retryType
            r3 = 1
            r4 = 3
            r5 = 2
            if (r1 != r5) goto L_0x00d1
            java.lang.Object r9 = r2.get(r0)
            com.android.internal.telephony.data.DataRetryManager$DataThrottlingEntry r9 = (com.android.internal.telephony.data.DataRetryManager.DataThrottlingEntry) r9
            android.telephony.data.DataProfile r9 = r9.dataProfile
            r0 = r5
            goto L_0x00ea
        L_0x00d1:
            java.lang.Object r1 = r2.get(r0)
            com.android.internal.telephony.data.DataRetryManager$DataThrottlingEntry r1 = (com.android.internal.telephony.data.DataRetryManager.DataThrottlingEntry) r1
            int r1 = r1.retryType
            if (r1 != r4) goto L_0x00e9
            java.lang.Object r9 = r2.get(r0)
            com.android.internal.telephony.data.DataRetryManager$DataThrottlingEntry r9 = (com.android.internal.telephony.data.DataRetryManager.DataThrottlingEntry) r9
            com.android.internal.telephony.data.DataNetwork r9 = r9.dataNetwork
            android.telephony.data.DataProfile r9 = r9.getDataProfile()
            r0 = r4
            goto L_0x00ea
        L_0x00e9:
            r0 = r3
        L_0x00ea:
            if (r9 == 0) goto L_0x0114
            android.telephony.data.ApnSetting r1 = r9.getApnSetting()
            if (r1 == 0) goto L_0x0114
            android.telephony.data.ApnSetting r9 = r9.getApnSetting()
            java.util.List r9 = r9.getApnTypes()
            java.util.stream.Stream r9 = r9.stream()
            com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda17 r1 = new com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda17
            r1.<init>(r7, r0, r10)
            java.util.stream.Stream r9 = r9.map(r1)
            java.util.stream.Collector r10 = java.util.stream.Collectors.toList()
            java.lang.Object r9 = r9.collect(r10)
            java.util.Collection r9 = (java.util.Collection) r9
            r8.addAll(r9)
        L_0x0114:
            java.util.Set<com.android.internal.telephony.data.DataRetryManager$DataRetryManagerCallback> r9 = r7.mDataRetryManagerCallbacks
            com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda18 r10 = new com.android.internal.telephony.data.DataRetryManager$$ExternalSyntheticLambda18
            r10.<init>(r8)
            r9.forEach(r10)
            java.lang.StringBuilder r8 = new java.lang.StringBuilder
            r8.<init>()
            java.lang.String r9 = "onDataProfileUnthrottled: Removing the following throttling entries. "
            r8.append(r9)
            r8.append(r2)
            java.lang.String r8 = r8.toString()
            r7.logl(r8)
            java.util.Iterator r8 = r2.iterator()
        L_0x0136:
            boolean r9 = r8.hasNext()
            if (r9 == 0) goto L_0x018c
            java.lang.Object r9 = r8.next()
            com.android.internal.telephony.data.DataRetryManager$DataThrottlingEntry r9 = (com.android.internal.telephony.data.DataRetryManager.DataThrottlingEntry) r9
            int r10 = r9.retryType
            r0 = 0
            if (r10 != r5) goto L_0x0171
            com.android.internal.telephony.data.DataRetryManager$DataSetupRetryEntry$Builder r10 = new com.android.internal.telephony.data.DataRetryManager$DataSetupRetryEntry$Builder
            r10.<init>()
            android.telephony.data.DataProfile r6 = r9.dataProfile
            com.android.internal.telephony.data.DataRetryManager$DataSetupRetryEntry$Builder r10 = r10.setDataProfile(r6)
            int r6 = r9.transport
            com.android.internal.telephony.data.DataRetryManager$DataSetupRetryEntry$Builder r10 = r10.setTransport(r6)
            com.android.internal.telephony.data.DataRetryManager$DataSetupRetryEntry$Builder r10 = r10.setSetupRetryType(r3)
            com.android.internal.telephony.data.DataNetworkController$NetworkRequestList r9 = r9.networkRequestList
            com.android.internal.telephony.data.DataRetryManager$DataSetupRetryEntry$Builder r9 = r10.setNetworkRequestList(r9)
            com.android.internal.telephony.data.DataRetryManager$DataRetryEntry$Builder r9 = r9.setRetryDelay(r0)
            com.android.internal.telephony.data.DataRetryManager$DataSetupRetryEntry$Builder r9 = (com.android.internal.telephony.data.DataRetryManager.DataSetupRetryEntry.Builder) r9
            com.android.internal.telephony.data.DataRetryManager$DataSetupRetryEntry r9 = r9.build()
            r7.schedule(r9)
            goto L_0x0136
        L_0x0171:
            if (r10 != r4) goto L_0x0136
            com.android.internal.telephony.data.DataRetryManager$DataHandoverRetryEntry$Builder r10 = new com.android.internal.telephony.data.DataRetryManager$DataHandoverRetryEntry$Builder
            r10.<init>()
            com.android.internal.telephony.data.DataNetwork r9 = r9.dataNetwork
            com.android.internal.telephony.data.DataRetryManager$DataHandoverRetryEntry$Builder r9 = r10.setDataNetwork(r9)
            com.android.internal.telephony.data.DataRetryManager$DataRetryEntry$Builder r9 = r9.setRetryDelay(r0)
            com.android.internal.telephony.data.DataRetryManager$DataHandoverRetryEntry$Builder r9 = (com.android.internal.telephony.data.DataRetryManager.DataHandoverRetryEntry.Builder) r9
            com.android.internal.telephony.data.DataRetryManager$DataHandoverRetryEntry r9 = r9.build()
            r7.schedule(r9)
            goto L_0x0136
        L_0x018c:
            if (r11 == 0) goto L_0x0193
            java.util.List<com.android.internal.telephony.data.DataRetryManager$DataThrottlingEntry> r7 = r7.mDataThrottlingEntries
            r7.removeAll(r2)
        L_0x0193:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.DataRetryManager.onDataProfileUnthrottled(android.telephony.data.DataProfile, java.lang.String, int, boolean):void");
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onDataProfileUnthrottled$14(long j, DataThrottlingEntry dataThrottlingEntry) {
        return dataThrottlingEntry.expirationTimeMillis > j;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onDataProfileUnthrottled$15(DataThrottlingEntry dataThrottlingEntry) {
        return dataThrottlingEntry.dataProfile.getApnSetting() != null;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onDataProfileUnthrottled$18(long j, String str, int i, DataThrottlingEntry dataThrottlingEntry) {
        return dataThrottlingEntry.expirationTimeMillis > j && dataThrottlingEntry.dataProfile.getApnSetting() != null && str.equals(dataThrottlingEntry.dataProfile.getApnSetting().getApnName()) && dataThrottlingEntry.transport == i;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ ThrottleStatus lambda$onDataProfileUnthrottled$19(int i, int i2, Integer num) {
        return new ThrottleStatus.Builder().setApnType(num.intValue()).setSlotIndex(this.mPhone.getPhoneId()).setNoThrottle().setRetryType(i).setTransportType(i2).build();
    }

    public boolean isSimilarNetworkRequestRetryScheduled(TelephonyNetworkRequest telephonyNetworkRequest, int i) {
        for (int size = this.mDataRetryEntries.size() - 1; size >= 0; size--) {
            if (this.mDataRetryEntries.get(size) instanceof DataSetupRetryEntry) {
                DataSetupRetryEntry dataSetupRetryEntry = (DataSetupRetryEntry) this.mDataRetryEntries.get(size);
                if (!dataSetupRetryEntry.networkRequestList.isEmpty() && dataSetupRetryEntry.getState() == 1 && dataSetupRetryEntry.setupRetryType == 2) {
                    if (dataSetupRetryEntry.networkRequestList.isEmpty()) {
                        logl("Invalid data retry entry detected");
                        loge("mDataRetryEntries=" + this.mDataRetryEntries);
                        AnomalyReporter.reportAnomaly(UUID.fromString("781af571-f55d-476d-b510-7a5381f633dc"), "Invalid data retry entry detected", this.mPhone.getCarrierId());
                    } else if (((TelephonyNetworkRequest) dataSetupRetryEntry.networkRequestList.get(0)).getApnTypeNetworkCapability() == telephonyNetworkRequest.getApnTypeNetworkCapability() && dataSetupRetryEntry.transport == i) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public boolean isAnySetupRetryScheduled(DataProfile dataProfile, int i) {
        Class<DataSetupRetryEntry> cls = DataSetupRetryEntry.class;
        return this.mDataRetryEntries.stream().filter(new DataRetryManager$$ExternalSyntheticLambda6(cls)).map(new DataRetryManager$$ExternalSyntheticLambda7(cls)).anyMatch(new DataRetryManager$$ExternalSyntheticLambda8(dataProfile, i));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isAnySetupRetryScheduled$22(DataProfile dataProfile, int i, DataSetupRetryEntry dataSetupRetryEntry) {
        if (dataSetupRetryEntry.getState() == 1 && dataProfile.equals(dataSetupRetryEntry.dataProfile) && dataSetupRetryEntry.transport == i) {
            return true;
        }
        return false;
    }

    public boolean isDataProfileThrottled(DataProfile dataProfile, int i) {
        return this.mDataThrottlingEntries.stream().anyMatch(new DataRetryManager$$ExternalSyntheticLambda23(dataProfile, SystemClock.elapsedRealtime(), i));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isDataProfileThrottled$23(DataProfile dataProfile, long j, int i, DataThrottlingEntry dataThrottlingEntry) {
        return dataThrottlingEntry.dataProfile.equals(dataProfile) && dataThrottlingEntry.expirationTimeMillis > j && dataThrottlingEntry.transport == i;
    }

    public void cancelPendingHandoverRetry(DataNetwork dataNetwork) {
        sendMessage(obtainMessage(7, dataNetwork));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onCancelPendingHandoverRetry$24(DataNetwork dataNetwork, DataRetryEntry dataRetryEntry) {
        return (dataRetryEntry instanceof DataHandoverRetryEntry) && ((DataHandoverRetryEntry) dataRetryEntry).dataNetwork == dataNetwork;
    }

    private void onCancelPendingHandoverRetry(DataNetwork dataNetwork) {
        this.mDataRetryEntries.removeIf(new DataRetryManager$$ExternalSyntheticLambda1(dataNetwork));
        this.mDataThrottlingEntries.removeIf(new DataRetryManager$$ExternalSyntheticLambda2(dataNetwork));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onCancelPendingHandoverRetry$25(DataNetwork dataNetwork, DataThrottlingEntry dataThrottlingEntry) {
        return dataThrottlingEntry.dataNetwork == dataNetwork;
    }

    public boolean isAnyHandoverRetryScheduled(DataNetwork dataNetwork) {
        Class<DataHandoverRetryEntry> cls = DataHandoverRetryEntry.class;
        return this.mDataRetryEntries.stream().filter(new DataRetryManager$$ExternalSyntheticLambda6(cls)).map(new DataRetryManager$$ExternalSyntheticLambda24(cls)).anyMatch(new DataRetryManager$$ExternalSyntheticLambda25(dataNetwork));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isAnyHandoverRetryScheduled$26(DataNetwork dataNetwork, DataHandoverRetryEntry dataHandoverRetryEntry) {
        return dataHandoverRetryEntry.getState() == 1 && dataHandoverRetryEntry.dataNetwork == dataNetwork;
    }

    public void registerCallback(DataRetryManagerCallback dataRetryManagerCallback) {
        this.mDataRetryManagerCallbacks.add(dataRetryManagerCallback);
    }

    public void unregisterCallback(DataRetryManagerCallback dataRetryManagerCallback) {
        this.mDataRetryManagerCallbacks.remove(dataRetryManagerCallback);
    }

    private static String resetReasonToString(int i) {
        switch (i) {
            case 1:
                return "DATA_PROFILES_CHANGED";
            case 2:
                return "RADIO_ON";
            case 3:
                return "MODEM_RESTART";
            case 4:
                return "DATA_SERVICE_BOUND";
            case 5:
                return "DATA_CONFIG_CHANGED";
            case 6:
                return "TAC_CHANGED";
            default:
                return "UNKNOWN(" + i + ")";
        }
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    /* access modifiers changed from: protected */
    public void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(DataRetryManager.class.getSimpleName() + "-" + this.mPhone.getPhoneId() + ":");
        androidUtilIndentingPrintWriter.increaseIndent();
        androidUtilIndentingPrintWriter.println("Data Setup Retry rules:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mDataSetupRetryRuleList.forEach(new DataConfigManager$$ExternalSyntheticLambda4(androidUtilIndentingPrintWriter));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Data Handover Retry rules:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mDataHandoverRetryRuleList.forEach(new DataConfigManager$$ExternalSyntheticLambda5(androidUtilIndentingPrintWriter));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Retry entries:");
        androidUtilIndentingPrintWriter.increaseIndent();
        for (DataRetryEntry println : this.mDataRetryEntries) {
            androidUtilIndentingPrintWriter.println(println);
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Throttling entries:");
        androidUtilIndentingPrintWriter.increaseIndent();
        for (DataThrottlingEntry println2 : this.mDataThrottlingEntries) {
            androidUtilIndentingPrintWriter.println(println2);
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Local logs:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.decreaseIndent();
    }
}
