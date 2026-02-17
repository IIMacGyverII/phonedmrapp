package com.android.internal.telephony.data;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.NetworkCapabilities;
import android.net.NetworkPolicyManager;
import android.net.NetworkRequest;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.SystemProperties;
import android.telephony.AccessNetworkConstants;
import android.telephony.AnomalyReporter;
import android.telephony.DataFailCause;
import android.telephony.DataSpecificRegistrationInfo;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.PcoData;
import android.telephony.ServiceState;
import android.telephony.SubscriptionManager;
import android.telephony.SubscriptionPlan;
import android.telephony.TelephonyManager;
import android.telephony.TelephonyRegistryManager;
import android.telephony.data.ApnSetting;
import android.telephony.data.DataCallResponse;
import android.telephony.data.DataProfile;
import android.telephony.ims.ImsException;
import android.telephony.ims.ImsManager;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.ImsRegistrationAttributes;
import android.telephony.ims.ImsStateCallback;
import android.telephony.ims.RegistrationManager;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.ArraySet;
import android.util.SparseArray;
import android.util.SparseBooleanArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.SlidingWindowEventCounter;
import com.android.internal.telephony.SubscriptionInfoUpdater;
import com.android.internal.telephony.TelephonyComponentFactory;
import com.android.internal.telephony.data.AccessNetworksManager;
import com.android.internal.telephony.data.DataEvaluation;
import com.android.internal.telephony.data.DataNetwork;
import com.android.internal.telephony.data.DataProfileManager;
import com.android.internal.telephony.data.DataRetryManager;
import com.android.internal.telephony.data.DataSettingsManager;
import com.android.internal.telephony.data.DataStallRecoveryManager;
import com.android.internal.telephony.data.LinkBandwidthEstimator;
import com.android.internal.telephony.ims.ImsResolver;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DataNetworkController extends Handler {
    private static final int EVENT_ADD_NETWORK_REQUEST = 2;
    private static final int EVENT_DATA_CONFIG_UPDATED = 1;
    private static final int EVENT_DATA_SERVICE_BINDING_CHANGED = 8;
    private static final int EVENT_EMERGENCY_CALL_CHANGED = 20;
    private static final int EVENT_EVALUATE_PREFERRED_TRANSPORT = 21;
    private static final int EVENT_PS_RESTRICT_DISABLED = 7;
    private static final int EVENT_PS_RESTRICT_ENABLED = 6;
    protected static final int EVENT_REEVALUATE_EXISTING_DATA_NETWORKS = 16;
    protected static final int EVENT_REEVALUATE_UNSATISFIED_NETWORK_REQUESTS = 5;
    private static final int EVENT_REGISTER_ALL_EVENTS = 19;
    private static final int EVENT_REGISTER_DATA_NETWORK_CONTROLLER_CALLBACK = 13;
    private static final int EVENT_REMOVE_NETWORK_REQUEST = 3;
    protected static final int EVENT_SERVICE_STATE_CHANGED = 17;
    private static final int EVENT_SIM_STATE_CHANGED = 9;
    private static final int EVENT_SLICE_CONFIG_CHANGED = 24;
    private static final int EVENT_SUBSCRIPTION_CHANGED = 15;
    private static final int EVENT_SUBSCRIPTION_OVERRIDE = 23;
    private static final int EVENT_SUBSCRIPTION_PLANS_CHANGED = 22;
    private static final int EVENT_TAC_CHANGED = 25;
    private static final int EVENT_TEAR_DOWN_ALL_DATA_NETWORKS = 12;
    private static final int EVENT_UNREGISTER_DATA_NETWORK_CONTROLLER_CALLBACK = 14;
    private static final int EVENT_VOICE_CALL_ENDED = 18;
    private static final int MAX_HISTORICAL_CONNECTED_DATA_NETWORKS = 10;
    private static final long REEVALUATE_PREFERRED_TRANSPORT_DELAY_MILLIS = TimeUnit.SECONDS.toMillis(3);
    private static final long REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_AFTER_CALL_END_DELAY_MILLIS;
    private static final long REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_TAC_CHANGED_DELAY_MILLIS;
    private static final Collection<Integer> SUPPORTED_IMS_FEATURES = List.of(1, 2);
    private static final boolean VDBG = false;
    /* access modifiers changed from: private */
    public final AccessNetworksManager mAccessNetworksManager;
    protected final NetworkRequestList mAllNetworkRequestList;
    protected boolean mAnyDataNetworkExisting;
    private final Set<Integer> mCongestedOverrideNetworkTypes;
    private int mDataActivity;
    protected final DataConfigManager mDataConfigManager;
    private final Set<DataNetworkControllerCallback> mDataNetworkControllerCallbacks;
    protected final List<DataNetwork> mDataNetworkList;
    protected final DataProfileManager mDataProfileManager;
    protected final DataRetryManager mDataRetryManager;
    private final SparseBooleanArray mDataServiceBound;
    protected final SparseArray<DataServiceManager> mDataServiceManagers;
    protected final DataSettingsManager mDataSettingsManager;
    private final DataStallRecoveryManager mDataStallRecoveryManager;
    private int mImsDataNetworkState;
    /* access modifiers changed from: private */
    public final SparseArray<String> mImsFeaturePackageName;
    private final SparseArray<RegistrationManager.RegistrationCallback> mImsFeatureRegistrationCallbacks;
    private final ImsManager mImsManager;
    private final SparseArray<ImsStateCallback> mImsStateCallbacks;
    protected SlidingWindowEventCounter mImsThrottleCounter;
    private final BroadcastReceiver mIntentReceiver;
    private int mInternetDataNetworkState;
    private int mInternetLinkStatus;
    private boolean mLastImsOperationIsRelease;
    protected int[] mLastReleasedImsRequestCapabilities;
    protected final LocalLog mLocalLog = new LocalLog(128);
    protected final String mLogTag;
    private final NetworkPolicyManager mNetworkPolicyManager;
    private SlidingWindowEventCounter mNetworkUnwantedCounter;
    private boolean mNrAdvancedCapableByPco;
    private final Map<DataNetwork, Runnable> mPendingImsDeregDataNetworks;
    private boolean mPendingTearDownAllNetworks;
    protected final Phone mPhone;
    private final List<DataNetwork> mPreviousConnectedDataNetworkList;
    private boolean mPsRestricted;
    /* access modifiers changed from: private */
    public final Set<Integer> mRegisteredImsFeatures;
    private ServiceState mServiceState;
    private SlidingWindowEventCounter mSetupDataCallWlanFailureCounter;
    private SlidingWindowEventCounter mSetupDataCallWwanFailureCounter;
    @TelephonyManager.SimState
    private int mSimState;
    /* access modifiers changed from: private */
    public int mSubId;
    private final List<SubscriptionPlan> mSubscriptionPlans;
    private final Set<Integer> mUnmeteredOverrideNetworkTypes;

    private void logv(String str) {
    }

    /* access modifiers changed from: protected */
    public int getProfileID(int i) {
        if (i == 0) {
            return 1001;
        }
        int i2 = 1;
        if (i == 1) {
            return 1002;
        }
        if (i != 2) {
            i2 = 3;
            if (i != 3) {
                if (i == 4) {
                    return 2;
                }
                if (i == 5) {
                    return 4;
                }
                if (i == 9) {
                    return 1005;
                }
                if (i == 10) {
                    return 1004;
                }
                if (i == 23) {
                    return 1009;
                }
                if (i != 30) {
                    return i != 31 ? 0 : 1007;
                }
                return 1008;
            }
        }
        return i2;
    }

    /* access modifiers changed from: protected */
    public void mtkEvaluateDataNetwork(DataEvaluation dataEvaluation, DataNetwork dataNetwork, DataEvaluation.DataEvaluationReason dataEvaluationReason, int i) {
    }

    /* access modifiers changed from: protected */
    public void mtkEvaluateNetworkRequest(DataEvaluation dataEvaluation, TelephonyNetworkRequest telephonyNetworkRequest, DataEvaluation.DataEvaluationReason dataEvaluationReason, int i) {
    }

    /* access modifiers changed from: protected */
    public void resetMdDataRetryCount(ApnSetting apnSetting) {
    }

    /* access modifiers changed from: protected */
    public boolean shouldIgnoreHandover(DataNetwork dataNetwork) {
        return false;
    }

    static {
        TimeUnit timeUnit = TimeUnit.MILLISECONDS;
        REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_AFTER_CALL_END_DELAY_MILLIS = timeUnit.toMillis(500);
        REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_TAC_CHANGED_DELAY_MILLIS = timeUnit.toMillis(100);
    }

    @VisibleForTesting
    public static class NetworkRequestList extends LinkedList<TelephonyNetworkRequest> {
        public NetworkRequestList() {
        }

        public NetworkRequestList(NetworkRequestList networkRequestList) {
            addAll(networkRequestList);
        }

        public NetworkRequestList(List<TelephonyNetworkRequest> list) {
            addAll(list);
        }

        public NetworkRequestList(TelephonyNetworkRequest telephonyNetworkRequest) {
            this();
            add(telephonyNetworkRequest);
        }

        public boolean add(TelephonyNetworkRequest telephonyNetworkRequest) {
            int i = 0;
            while (i < size()) {
                TelephonyNetworkRequest telephonyNetworkRequest2 = (TelephonyNetworkRequest) get(i);
                if (telephonyNetworkRequest2.equals(telephonyNetworkRequest)) {
                    return false;
                }
                if (telephonyNetworkRequest.getPriority() > telephonyNetworkRequest2.getPriority()) {
                    break;
                }
                i++;
            }
            super.add(i, telephonyNetworkRequest);
            return true;
        }

        public void add(int i, TelephonyNetworkRequest telephonyNetworkRequest) {
            throw new UnsupportedOperationException("Insertion to certain position is illegal.");
        }

        public boolean addAll(Collection<? extends TelephonyNetworkRequest> collection) {
            for (TelephonyNetworkRequest add : collection) {
                add(add);
            }
            return true;
        }

        public TelephonyNetworkRequest get(int[] iArr) {
            for (int i = 0; i < size(); i++) {
                TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) get(i);
                if (((Set) Arrays.stream(telephonyNetworkRequest.getCapabilities()).boxed().collect(Collectors.toSet())).containsAll((Collection) Arrays.stream(iArr).boxed().collect(Collectors.toList()))) {
                    return telephonyNetworkRequest;
                }
            }
            return null;
        }

        public boolean hasNetworkRequestsFromPackage(String str) {
            Iterator it = iterator();
            while (it.hasNext()) {
                if (str.equals(((TelephonyNetworkRequest) it.next()).getNativeNetworkRequest().getRequestorPackageName())) {
                    return true;
                }
            }
            return false;
        }

        public String toString() {
            String str;
            StringBuilder sb = new StringBuilder();
            sb.append("[NetworkRequestList: size=");
            sb.append(size());
            if (size() > 0) {
                str = ", leading by " + get(0);
            } else {
                str = "";
            }
            sb.append(str);
            sb.append("]");
            return sb.toString();
        }

        public void dump(AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter) {
            androidUtilIndentingPrintWriter.increaseIndent();
            Iterator it = iterator();
            while (it.hasNext()) {
                androidUtilIndentingPrintWriter.println((TelephonyNetworkRequest) it.next());
            }
            androidUtilIndentingPrintWriter.decreaseIndent();
        }
    }

    public static class DataNetworkControllerCallback extends DataCallback {
        public void onAnyDataNetworkExistingChanged(boolean z) {
        }

        public void onDataServiceBound(int i) {
        }

        public void onInternetDataNetworkConnected(List<DataProfile> list) {
        }

        public void onInternetDataNetworkDisconnected() {
        }

        public void onInternetDataNetworkValidationStatusChanged(int i) {
        }

        public void onNrAdvancedCapableByPcoChanged(boolean z) {
        }

        public void onPhysicalLinkStatusChanged(int i) {
        }

        public void onSubscriptionPlanOverride() {
        }

        public DataNetworkControllerCallback(Executor executor) {
            super(executor);
        }
    }

    public static class HandoverRule {
        private static final String RULE_TAG_CAPABILITIES = "capabilities";
        private static final String RULE_TAG_ROAMING = "roaming";
        private static final String RULE_TAG_SOURCE_ACCESS_NETWORKS = "source";
        private static final String RULE_TAG_TARGET_ACCESS_NETWORKS = "target";
        private static final String RULE_TAG_TYPE = "type";
        public static final int RULE_TYPE_ALLOWED = 1;
        public static final int RULE_TYPE_DISALLOWED = 2;
        public final boolean isOnlyForRoaming;
        public final Set<Integer> networkCapabilities;
        public final Set<Integer> sourceAccessNetworks;
        public final Set<Integer> targetAccessNetworks;
        public final int type;

        @Retention(RetentionPolicy.SOURCE)
        public @interface HandoverRuleType {
        }

        /* JADX WARNING: Can't fix incorrect switch cases order */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public HandoverRule(java.lang.String r18) {
            /*
                r17 = this;
                r0 = r17
                r17.<init>()
                boolean r1 = android.text.TextUtils.isEmpty(r18)
                java.lang.String r2 = "illegal rule "
                if (r1 != 0) goto L_0x0275
                java.util.Set r1 = java.util.Collections.emptySet()
                java.lang.String r3 = r18.trim()
                java.util.Locale r4 = java.util.Locale.ROOT
                java.lang.String r3 = r3.toLowerCase(r4)
                java.lang.String r4 = "\\s*,\\s*"
                java.lang.String[] r4 = r3.split(r4)
                int r5 = r4.length
                r6 = 0
                r7 = 0
                r8 = r6
                r9 = r7
                r10 = r9
                r11 = r10
            L_0x0028:
                if (r9 >= r5) goto L_0x0181
                r13 = r4[r9]
                java.lang.String r13 = r13.trim()
                java.lang.String r14 = "\\s*=\\s*"
                java.lang.String[] r13 = r13.split(r14)
                int r14 = r13.length
                r15 = 2
                if (r14 != r15) goto L_0x0160
                r14 = r13[r7]
                java.lang.String r14 = r14.trim()
                r12 = 1
                r13 = r13[r12]
                java.lang.String r13 = r13.trim()
                int r16 = r14.hashCode()     // Catch:{ Exception -> 0x013d }
                switch(r16) {
                    case -1487597642: goto L_0x007a;
                    case -896505829: goto L_0x006f;
                    case -880905839: goto L_0x0064;
                    case 3575610: goto L_0x0059;
                    case 1366973465: goto L_0x004f;
                    default: goto L_0x004e;
                }     // Catch:{ Exception -> 0x013d }
            L_0x004e:
                goto L_0x0084
            L_0x004f:
                java.lang.String r7 = "roaming"
                boolean r7 = r14.equals(r7)     // Catch:{ Exception -> 0x013d }
                if (r7 == 0) goto L_0x0084
                r7 = 4
                goto L_0x0085
            L_0x0059:
                java.lang.String r7 = "type"
                boolean r7 = r14.equals(r7)     // Catch:{ Exception -> 0x013d }
                if (r7 == 0) goto L_0x0084
                r7 = r15
                goto L_0x0085
            L_0x0064:
                java.lang.String r7 = "target"
                boolean r7 = r14.equals(r7)     // Catch:{ Exception -> 0x013d }
                if (r7 == 0) goto L_0x0084
                r7 = r12
                goto L_0x0085
            L_0x006f:
                java.lang.String r7 = "source"
                boolean r7 = r14.equals(r7)     // Catch:{ Exception -> 0x013d }
                if (r7 == 0) goto L_0x0084
                r7 = 0
                goto L_0x0085
            L_0x007a:
                java.lang.String r7 = "capabilities"
                boolean r7 = r14.equals(r7)     // Catch:{ Exception -> 0x013d }
                if (r7 == 0) goto L_0x0084
                r7 = 3
                goto L_0x0085
            L_0x0084:
                r7 = -1
            L_0x0085:
                java.lang.String r15 = "\\s*\\|\\s*"
                if (r7 == 0) goto L_0x0114
                if (r7 == r12) goto L_0x00ee
                r12 = 2
                if (r7 == r12) goto L_0x00b8
                r15 = 3
                if (r7 == r15) goto L_0x00b2
                r12 = 4
                if (r7 != r12) goto L_0x009a
                boolean r11 = java.lang.Boolean.parseBoolean(r13)     // Catch:{ Exception -> 0x013d }
                goto L_0x0138
            L_0x009a:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException     // Catch:{ Exception -> 0x013d }
                java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x013d }
                r1.<init>()     // Catch:{ Exception -> 0x013d }
                java.lang.String r2 = "unexpected key "
                r1.append(r2)     // Catch:{ Exception -> 0x013d }
                r1.append(r14)     // Catch:{ Exception -> 0x013d }
                java.lang.String r1 = r1.toString()     // Catch:{ Exception -> 0x013d }
                r0.<init>(r1)     // Catch:{ Exception -> 0x013d }
                throw r0     // Catch:{ Exception -> 0x013d }
            L_0x00b2:
                java.util.Set r1 = com.android.internal.telephony.data.DataUtils.getNetworkCapabilitiesFromString(r13)     // Catch:{ Exception -> 0x013d }
                goto L_0x0138
            L_0x00b8:
                java.util.Locale r7 = java.util.Locale.ROOT     // Catch:{ Exception -> 0x013d }
                java.lang.String r10 = r13.toLowerCase(r7)     // Catch:{ Exception -> 0x013d }
                java.lang.String r14 = "allowed"
                boolean r10 = r10.equals(r14)     // Catch:{ Exception -> 0x013d }
                if (r10 == 0) goto L_0x00c8
                r10 = 1
                goto L_0x0138
            L_0x00c8:
                java.lang.String r7 = r13.toLowerCase(r7)     // Catch:{ Exception -> 0x013d }
                java.lang.String r10 = "disallowed"
                boolean r7 = r7.equals(r10)     // Catch:{ Exception -> 0x013d }
                if (r7 == 0) goto L_0x00d6
                r10 = r12
                goto L_0x0138
            L_0x00d6:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException     // Catch:{ Exception -> 0x013d }
                java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x013d }
                r1.<init>()     // Catch:{ Exception -> 0x013d }
                java.lang.String r2 = "unexpected rule type "
                r1.append(r2)     // Catch:{ Exception -> 0x013d }
                r1.append(r13)     // Catch:{ Exception -> 0x013d }
                java.lang.String r1 = r1.toString()     // Catch:{ Exception -> 0x013d }
                r0.<init>(r1)     // Catch:{ Exception -> 0x013d }
                throw r0     // Catch:{ Exception -> 0x013d }
            L_0x00ee:
                java.lang.String[] r7 = r13.split(r15)     // Catch:{ Exception -> 0x013d }
                java.util.stream.Stream r7 = java.util.Arrays.stream(r7)     // Catch:{ Exception -> 0x013d }
                com.android.internal.telephony.data.DataNetworkController$HandoverRule$$ExternalSyntheticLambda0 r8 = new com.android.internal.telephony.data.DataNetworkController$HandoverRule$$ExternalSyntheticLambda0     // Catch:{ Exception -> 0x013d }
                r8.<init>()     // Catch:{ Exception -> 0x013d }
                java.util.stream.Stream r7 = r7.map(r8)     // Catch:{ Exception -> 0x013d }
                com.android.internal.telephony.data.DataNetworkController$HandoverRule$$ExternalSyntheticLambda1 r8 = new com.android.internal.telephony.data.DataNetworkController$HandoverRule$$ExternalSyntheticLambda1     // Catch:{ Exception -> 0x013d }
                r8.<init>()     // Catch:{ Exception -> 0x013d }
                java.util.stream.Stream r7 = r7.map(r8)     // Catch:{ Exception -> 0x013d }
                java.util.stream.Collector r8 = java.util.stream.Collectors.toSet()     // Catch:{ Exception -> 0x013d }
                java.lang.Object r7 = r7.collect(r8)     // Catch:{ Exception -> 0x013d }
                java.util.Set r7 = (java.util.Set) r7     // Catch:{ Exception -> 0x013d }
                r8 = r7
                goto L_0x0138
            L_0x0114:
                java.lang.String[] r6 = r13.split(r15)     // Catch:{ Exception -> 0x013d }
                java.util.stream.Stream r6 = java.util.Arrays.stream(r6)     // Catch:{ Exception -> 0x013d }
                com.android.internal.telephony.data.DataNetworkController$HandoverRule$$ExternalSyntheticLambda0 r7 = new com.android.internal.telephony.data.DataNetworkController$HandoverRule$$ExternalSyntheticLambda0     // Catch:{ Exception -> 0x013d }
                r7.<init>()     // Catch:{ Exception -> 0x013d }
                java.util.stream.Stream r6 = r6.map(r7)     // Catch:{ Exception -> 0x013d }
                com.android.internal.telephony.data.DataNetworkController$HandoverRule$$ExternalSyntheticLambda1 r7 = new com.android.internal.telephony.data.DataNetworkController$HandoverRule$$ExternalSyntheticLambda1     // Catch:{ Exception -> 0x013d }
                r7.<init>()     // Catch:{ Exception -> 0x013d }
                java.util.stream.Stream r6 = r6.map(r7)     // Catch:{ Exception -> 0x013d }
                java.util.stream.Collector r7 = java.util.stream.Collectors.toSet()     // Catch:{ Exception -> 0x013d }
                java.lang.Object r6 = r6.collect(r7)     // Catch:{ Exception -> 0x013d }
                java.util.Set r6 = (java.util.Set) r6     // Catch:{ Exception -> 0x013d }
            L_0x0138:
                int r9 = r9 + 1
                r7 = 0
                goto L_0x0028
            L_0x013d:
                r0 = move-exception
                r0.printStackTrace()
                java.lang.IllegalArgumentException r1 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r2 = new java.lang.StringBuilder
                r2.<init>()
                java.lang.String r4 = "illegal rule \""
                r2.append(r4)
                r2.append(r3)
                java.lang.String r3 = "\", e="
                r2.append(r3)
                r2.append(r0)
                java.lang.String r0 = r2.toString()
                r1.<init>(r0)
                throw r1
            L_0x0160:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                r1.append(r2)
                r1.append(r3)
                java.lang.String r2 = ", tokens="
                r1.append(r2)
                java.lang.String r2 = java.util.Arrays.toString(r13)
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.<init>(r1)
                throw r0
            L_0x0181:
                java.lang.String r2 = "\""
                if (r6 == 0) goto L_0x025b
                if (r8 == 0) goto L_0x025b
                boolean r4 = r6.isEmpty()
                if (r4 != 0) goto L_0x025b
                boolean r4 = r8.isEmpty()
                if (r4 != 0) goto L_0x025b
                r4 = 0
                java.lang.Integer r5 = java.lang.Integer.valueOf(r4)
                boolean r5 = r6.contains(r5)
                if (r5 != 0) goto L_0x0241
                java.lang.Integer r4 = java.lang.Integer.valueOf(r4)
                boolean r4 = r8.contains(r4)
                if (r4 != 0) goto L_0x0227
                if (r10 == 0) goto L_0x020d
                if (r1 == 0) goto L_0x01d2
                r4 = -1
                java.lang.Integer r4 = java.lang.Integer.valueOf(r4)
                boolean r4 = r1.contains(r4)
                if (r4 != 0) goto L_0x01b8
                goto L_0x01d2
            L_0x01b8:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r4 = "Network capabilities contains unknown. \""
                r1.append(r4)
                r1.append(r3)
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.<init>(r1)
                throw r0
            L_0x01d2:
                r4 = 5
                java.lang.Integer r5 = java.lang.Integer.valueOf(r4)
                boolean r5 = r6.contains(r5)
                if (r5 != 0) goto L_0x0202
                java.lang.Integer r4 = java.lang.Integer.valueOf(r4)
                boolean r4 = r8.contains(r4)
                if (r4 == 0) goto L_0x01e8
                goto L_0x0202
            L_0x01e8:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r4 = "IWLAN must be specified in either source or target access networks.\""
                r1.append(r4)
                r1.append(r3)
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.<init>(r1)
                throw r0
            L_0x0202:
                r0.sourceAccessNetworks = r6
                r0.targetAccessNetworks = r8
                r0.type = r10
                r0.networkCapabilities = r1
                r0.isOnlyForRoaming = r11
                return
            L_0x020d:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r4 = "Rule type is not specified correctly. \""
                r1.append(r4)
                r1.append(r3)
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.<init>(r1)
                throw r0
            L_0x0227:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r4 = "Target access networks contains unknown. \""
                r1.append(r4)
                r1.append(r3)
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.<init>(r1)
                throw r0
            L_0x0241:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r4 = "Source access networks contains unknown. \""
                r1.append(r4)
                r1.append(r3)
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.<init>(r1)
                throw r0
            L_0x025b:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r4 = "Need to specify both source and target. \""
                r1.append(r4)
                r1.append(r3)
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.<init>(r1)
                throw r0
            L_0x0275:
                java.lang.IllegalArgumentException r0 = new java.lang.IllegalArgumentException
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                r1.append(r2)
                r2 = r18
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.<init>(r1)
                throw r0
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.DataNetworkController.HandoverRule.<init>(java.lang.String):void");
        }

        public String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append("[HandoverRule: type=");
            sb.append(this.type == 1 ? "allowed" : "disallowed");
            sb.append(", source=");
            sb.append((String) this.sourceAccessNetworks.stream().map(new DataNetworkController$HandoverRule$$ExternalSyntheticLambda2()).collect(Collectors.joining("|")));
            sb.append(", target=");
            sb.append((String) this.targetAccessNetworks.stream().map(new DataNetworkController$HandoverRule$$ExternalSyntheticLambda2()).collect(Collectors.joining("|")));
            sb.append(", isRoaming=");
            sb.append(this.isOnlyForRoaming);
            sb.append(", capabilities=");
            sb.append(DataUtils.networkCapabilitiesToString((Collection<Integer>) this.networkCapabilities));
            sb.append("]");
            return sb.toString();
        }
    }

    public DataNetworkController(Phone phone, Looper looper) {
        super(looper);
        SparseArray<DataServiceManager> sparseArray = new SparseArray<>();
        this.mDataServiceManagers = sparseArray;
        this.mSubId = -1;
        this.mSubscriptionPlans = new ArrayList();
        this.mUnmeteredOverrideNetworkTypes = new ArraySet();
        this.mCongestedOverrideNetworkTypes = new ArraySet();
        this.mAllNetworkRequestList = new NetworkRequestList();
        this.mDataNetworkList = new ArrayList();
        this.mPreviousConnectedDataNetworkList = new ArrayList();
        this.mInternetDataNetworkState = 0;
        this.mImsDataNetworkState = 0;
        this.mInternetLinkStatus = -1;
        this.mDataNetworkControllerCallbacks = new ArraySet();
        this.mPsRestricted = false;
        this.mNrAdvancedCapableByPco = false;
        this.mDataServiceBound = new SparseBooleanArray();
        this.mSimState = 0;
        this.mDataActivity = 0;
        this.mImsStateCallbacks = new SparseArray<>();
        this.mRegisteredImsFeatures = new ArraySet();
        this.mImsFeaturePackageName = new SparseArray<>();
        this.mPendingImsDeregDataNetworks = new ArrayMap();
        this.mImsFeatureRegistrationCallbacks = new SparseArray<>();
        this.mPendingTearDownAllNetworks = false;
        this.mIntentReceiver = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                action.hashCode();
                if ((action.equals("android.telephony.action.SIM_APPLICATION_STATE_CHANGED") || action.equals("android.telephony.action.SIM_CARD_STATE_CHANGED")) && DataNetworkController.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1)) {
                    int intExtra = intent.getIntExtra("android.telephony.extra.SIM_STATE", 0);
                    DataNetworkController dataNetworkController = DataNetworkController.this;
                    dataNetworkController.sendMessage(dataNetworkController.obtainMessage(9, intExtra, 0));
                }
            }
        };
        this.mPhone = phone;
        this.mLogTag = "DNC-" + phone.getPhoneId();
        log("DataNetworkController created.");
        AccessNetworksManager accessNetworksManager = phone.getAccessNetworksManager();
        this.mAccessNetworksManager = accessNetworksManager;
        sparseArray.put(1, new DataServiceManager(phone, looper, 1));
        if (!accessNetworksManager.isInLegacyMode()) {
            sparseArray.put(2, new DataServiceManager(phone, looper, 2));
        }
        DataConfigManager makeDataConfigManager = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeDataConfigManager(phone, looper);
        this.mDataConfigManager = makeDataConfigManager;
        this.mImsThrottleCounter = new SlidingWindowEventCounter(makeDataConfigManager.getAnomalyImsReleaseRequestThreshold().timeWindow, makeDataConfigManager.getAnomalyImsReleaseRequestThreshold().eventNumOccurrence);
        this.mNetworkUnwantedCounter = new SlidingWindowEventCounter(makeDataConfigManager.getAnomalyNetworkUnwantedThreshold().timeWindow, makeDataConfigManager.getAnomalyNetworkUnwantedThreshold().eventNumOccurrence);
        this.mSetupDataCallWlanFailureCounter = new SlidingWindowEventCounter(makeDataConfigManager.getAnomalySetupDataCallThreshold().timeWindow, makeDataConfigManager.getAnomalySetupDataCallThreshold().eventNumOccurrence);
        this.mSetupDataCallWwanFailureCounter = new SlidingWindowEventCounter(makeDataConfigManager.getAnomalySetupDataCallThreshold().timeWindow, makeDataConfigManager.getAnomalySetupDataCallThreshold().eventNumOccurrence);
        this.mDataSettingsManager = TelephonyComponentFactory.getInstance().inject(DataSettingsManager.class.getName()).makeDataSettingsManager(phone, this, looper, new DataSettingsManager.DataSettingsManagerCallback(new DataNetworkController$$ExternalSyntheticLambda6(this)) {
            public void onDataEnabledChanged(boolean z, int i, String str) {
                DataNetworkController dataNetworkController = DataNetworkController.this;
                dataNetworkController.logl("onDataEnabledChanged: enabled=" + z);
                DataNetworkController dataNetworkController2 = DataNetworkController.this;
                dataNetworkController2.sendMessage(dataNetworkController2.obtainMessage(z ? 5 : 16, DataEvaluation.DataEvaluationReason.DATA_ENABLED_CHANGED));
            }

            public void onDataEnabledOverrideChanged(boolean z, int i) {
                DataNetworkController dataNetworkController = DataNetworkController.this;
                dataNetworkController.logl("onDataEnabledOverrideChanged: enabled=" + z);
                DataNetworkController dataNetworkController2 = DataNetworkController.this;
                dataNetworkController2.sendMessage(dataNetworkController2.obtainMessage(z ? 5 : 16, DataEvaluation.DataEvaluationReason.DATA_ENABLED_OVERRIDE_CHANGED));
            }

            public void onDataRoamingEnabledChanged(boolean z) {
                DataNetworkController dataNetworkController = DataNetworkController.this;
                dataNetworkController.logl("onDataRoamingEnabledChanged: enabled=" + z);
                DataNetworkController dataNetworkController2 = DataNetworkController.this;
                dataNetworkController2.sendMessage(dataNetworkController2.obtainMessage(z ? 5 : 16, DataEvaluation.DataEvaluationReason.ROAMING_ENABLED_CHANGED));
            }
        });
        Phone phone2 = phone;
        Looper looper2 = looper;
        this.mDataProfileManager = TelephonyComponentFactory.getInstance().inject(DataProfileManager.class.getName()).makeDataProfileManager(phone2, this, sparseArray.get(1), looper2, new DataProfileManager.DataProfileManagerCallback(new DataNetworkController$$ExternalSyntheticLambda6(this)) {
            public void onDataProfilesChanged() {
                DataNetworkController dataNetworkController = DataNetworkController.this;
                DataEvaluation.DataEvaluationReason dataEvaluationReason = DataEvaluation.DataEvaluationReason.DATA_PROFILES_CHANGED;
                dataNetworkController.sendMessage(dataNetworkController.obtainMessage(16, dataEvaluationReason));
                DataNetworkController dataNetworkController2 = DataNetworkController.this;
                dataNetworkController2.sendMessage(dataNetworkController2.obtainMessage(5, dataEvaluationReason));
            }
        });
        this.mDataStallRecoveryManager = new DataStallRecoveryManager(phone2, this, sparseArray.get(1), looper2, new DataStallRecoveryManager.DataStallRecoveryManagerCallback(new DataNetworkController$$ExternalSyntheticLambda6(this)) {
            public void onDataStallReestablishInternet() {
                DataNetworkController.this.onDataStallReestablishInternet();
            }
        });
        this.mDataRetryManager = new DataRetryManager(phone, this, sparseArray, looper, new DataRetryManager.DataRetryManagerCallback(new DataNetworkController$$ExternalSyntheticLambda6(this)) {
            public void onDataNetworkSetupRetry(DataRetryManager.DataSetupRetryEntry dataSetupRetryEntry) {
                Objects.requireNonNull(dataSetupRetryEntry);
                DataNetworkController.this.onDataNetworkSetupRetry(dataSetupRetryEntry);
            }

            public void onDataNetworkHandoverRetry(DataRetryManager.DataHandoverRetryEntry dataHandoverRetryEntry) {
                Objects.requireNonNull(dataHandoverRetryEntry);
                DataNetworkController.this.onDataNetworkHandoverRetry(dataHandoverRetryEntry);
            }

            public void onDataNetworkHandoverRetryStopped(DataNetwork dataNetwork) {
                Objects.requireNonNull(dataNetwork);
                int preferredTransportByNetworkCapability = DataNetworkController.this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(dataNetwork.getApnTypeNetworkCapability());
                if (dataNetwork.getTransport() == preferredTransportByNetworkCapability) {
                    DataNetworkController dataNetworkController = DataNetworkController.this;
                    dataNetworkController.log("onDataNetworkHandoverRetryStopped: " + dataNetwork + " is already on the preferred transport " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability));
                } else if (dataNetwork.shouldDelayImsTearDown()) {
                    DataNetworkController dataNetworkController2 = DataNetworkController.this;
                    dataNetworkController2.log("onDataNetworkHandoverRetryStopped: Delay IMS tear down until call ends. " + dataNetwork);
                } else {
                    DataNetworkController.this.tearDownGracefully(dataNetwork, 13);
                }
            }
        });
        this.mImsManager = (ImsManager) phone.getContext().getSystemService(ImsManager.class);
        this.mNetworkPolicyManager = (NetworkPolicyManager) phone.getContext().getSystemService(NetworkPolicyManager.class);
        this.mServiceState = phone.getServiceStateTracker().getServiceState();
        sendEmptyMessage(19);
    }

    /* access modifiers changed from: protected */
    public void onRegisterAllEvents() {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.SIM_CARD_STATE_CHANGED");
        intentFilter.addAction("android.telephony.action.SIM_APPLICATION_STATE_CHANGED");
        this.mPhone.getContext().registerReceiver(this.mIntentReceiver, intentFilter, (String) null, this.mPhone);
        this.mAccessNetworksManager.registerCallback(new AccessNetworksManager.AccessNetworksManagerCallback(new DataNetworkController$$ExternalSyntheticLambda6(this)) {
            public void onPreferredTransportChanged(int i) {
                int preferredTransportByNetworkCapability = DataNetworkController.this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(i);
                DataNetworkController dataNetworkController = DataNetworkController.this;
                dataNetworkController.logl("onPreferredTransportChanged: " + DataUtils.networkCapabilityToString(i) + " preferred on " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability));
                DataNetworkController.this.onEvaluatePreferredTransport(i);
                if (!DataNetworkController.this.hasMessages(5)) {
                    DataNetworkController dataNetworkController2 = DataNetworkController.this;
                    dataNetworkController2.sendMessage(dataNetworkController2.obtainMessage(5, DataEvaluation.DataEvaluationReason.PREFERRED_TRANSPORT_CHANGED));
                    return;
                }
                DataNetworkController.this.log("onPreferredTransportChanged: Skipped evaluating unsatisfied network requests because another evaluation was already scheduled.");
            }
        });
        this.mNetworkPolicyManager.registerSubscriptionCallback(new NetworkPolicyManager.SubscriptionCallback() {
            public void onSubscriptionPlansChanged(int i, SubscriptionPlan[] subscriptionPlanArr) {
                if (DataNetworkController.this.mSubId == i) {
                    DataNetworkController.this.obtainMessage(22, subscriptionPlanArr).sendToTarget();
                }
            }

            public void onSubscriptionOverride(int i, int i2, int i3, int[] iArr) {
                if (DataNetworkController.this.mSubId == i) {
                    DataNetworkController.this.obtainMessage(23, i2, i3, iArr).sendToTarget();
                }
            }
        });
        this.mPhone.getServiceStateTracker().registerForServiceStateChanged(this, 17);
        this.mDataConfigManager.registerForConfigUpdate(this, 1);
        this.mPhone.getServiceStateTracker().registerForPsRestrictedEnabled(this, 6, (Object) null);
        this.mPhone.getServiceStateTracker().registerForPsRestrictedDisabled(this, 7, (Object) null);
        this.mPhone.getServiceStateTracker().registerForAreaCodeChanged(this, 25, (Object) null);
        this.mPhone.registerForEmergencyCallToggle(this, 20, (Object) null);
        this.mDataServiceManagers.get(1).registerForServiceBindingChanged(this, 8);
        if (!this.mAccessNetworksManager.isInLegacyMode()) {
            this.mPhone.getServiceStateTracker().registerForServiceStateChanged(this, 17);
            this.mDataServiceManagers.get(2).registerForServiceBindingChanged(this, 8);
        }
        ((TelephonyRegistryManager) this.mPhone.getContext().getSystemService(TelephonyRegistryManager.class)).addOnSubscriptionsChangedListener(new SubscriptionManager.OnSubscriptionsChangedListener() {
            public void onSubscriptionsChanged() {
                DataNetworkController.this.sendEmptyMessage(15);
            }
        }, new DataNetworkController$$ExternalSyntheticLambda6(this));
        this.mPhone.getCallTracker().registerForVoiceCallEnded(this, 18, (Object) null);
        if (this.mPhone.getImsPhone() != null) {
            this.mPhone.getImsPhone().getCallTracker().registerForVoiceCallEnded(this, 18, (Object) null);
        }
        this.mPhone.mCi.registerForSlicingConfigChanged(this, 24, (Object) null);
        this.mPhone.getLinkBandwidthEstimator().registerCallback(new LinkBandwidthEstimator.LinkBandwidthEstimatorCallback(new DataNetworkController$$ExternalSyntheticLambda6(this)) {
            public void onDataActivityChanged(int i) {
                DataNetworkController.this.updateDataActivity();
            }
        });
    }

    public void handleMessage(Message message) {
        int i = 0;
        switch (message.what) {
            case 1:
                onDataConfigUpdated();
                return;
            case 2:
                onAddNetworkRequest((TelephonyNetworkRequest) message.obj);
                return;
            case 3:
                onRemoveNetworkRequest((TelephonyNetworkRequest) message.obj);
                return;
            case 5:
                onReevaluateUnsatisfiedNetworkRequests((DataEvaluation.DataEvaluationReason) message.obj);
                return;
            case 6:
                this.mPsRestricted = true;
                return;
            case 7:
                this.mPsRestricted = false;
                sendMessage(obtainMessage(5, DataEvaluation.DataEvaluationReason.DATA_RESTRICTED_CHANGED));
                return;
            case 8:
                AsyncResult asyncResult = (AsyncResult) message.obj;
                onDataServiceBindingChanged(((Integer) asyncResult.userObj).intValue(), ((Boolean) asyncResult.result).booleanValue());
                return;
            case 9:
                onSimStateChanged(message.arg1);
                return;
            case 12:
                onTearDownAllDataNetworks(message.arg1);
                return;
            case 13:
                this.mDataNetworkControllerCallbacks.add((DataNetworkControllerCallback) message.obj);
                return;
            case 14:
                this.mDataNetworkControllerCallbacks.remove((DataNetworkControllerCallback) message.obj);
                return;
            case 15:
                onSubscriptionChanged();
                return;
            case 16:
                onReevaluateExistingDataNetworks((DataEvaluation.DataEvaluationReason) message.obj);
                return;
            case 17:
                onServiceStateChanged();
                return;
            case 18:
                DataEvaluation.DataEvaluationReason dataEvaluationReason = DataEvaluation.DataEvaluationReason.VOICE_CALL_ENDED;
                sendMessage(obtainMessage(16, dataEvaluationReason));
                sendMessageDelayed(obtainMessage(5, dataEvaluationReason), REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_AFTER_CALL_END_DELAY_MILLIS);
                return;
            case 19:
                onRegisterAllEvents();
                return;
            case 20:
                if (this.mPhone.isInEcm()) {
                    sendMessage(obtainMessage(16, DataEvaluation.DataEvaluationReason.EMERGENCY_CALL_CHANGED));
                    return;
                } else {
                    sendMessage(obtainMessage(5, DataEvaluation.DataEvaluationReason.EMERGENCY_CALL_CHANGED));
                    return;
                }
            case 21:
                onEvaluatePreferredTransport(message.arg1);
                return;
            case 22:
                SubscriptionPlan[] subscriptionPlanArr = (SubscriptionPlan[]) message.obj;
                log("Subscription plans changed: " + Arrays.toString(subscriptionPlanArr));
                this.mSubscriptionPlans.clear();
                this.mSubscriptionPlans.addAll(Arrays.asList(subscriptionPlanArr));
                this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda19());
                return;
            case 23:
                int i2 = message.arg1;
                boolean z = message.arg2 != 0;
                int[] iArr = (int[]) message.obj;
                if (i2 == 1) {
                    log("Unmetered subscription override: override=" + z + ", networkTypes=" + ((String) Arrays.stream(iArr).mapToObj(new DataNetworkController$$ExternalSyntheticLambda20()).collect(Collectors.joining(","))));
                    int length = iArr.length;
                    while (i < length) {
                        int i3 = iArr[i];
                        if (z) {
                            this.mUnmeteredOverrideNetworkTypes.add(Integer.valueOf(i3));
                        } else {
                            this.mUnmeteredOverrideNetworkTypes.remove(Integer.valueOf(i3));
                        }
                        i++;
                    }
                    this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda21());
                    return;
                } else if (i2 == 2) {
                    log("Congested subscription override: override=" + z + ", networkTypes=" + ((String) Arrays.stream(iArr).mapToObj(new DataNetworkController$$ExternalSyntheticLambda20()).collect(Collectors.joining(","))));
                    int length2 = iArr.length;
                    while (i < length2) {
                        int i4 = iArr[i];
                        if (z) {
                            this.mCongestedOverrideNetworkTypes.add(Integer.valueOf(i4));
                        } else {
                            this.mCongestedOverrideNetworkTypes.remove(Integer.valueOf(i4));
                        }
                        i++;
                    }
                    this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda22());
                    return;
                } else {
                    loge("Unknown override mask: " + i2);
                    return;
                }
            case 24:
                sendMessage(obtainMessage(5, DataEvaluation.DataEvaluationReason.SLICE_CONFIG_CHANGED));
                return;
            case 25:
                sendMessageDelayed(obtainMessage(5, DataEvaluation.DataEvaluationReason.TAC_CHANGED), REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_TAC_CHANGED_DELAY_MILLIS);
                return;
            default:
                loge("Unexpected event " + message.what);
                return;
        }
    }

    public void addNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        sendMessage(obtainMessage(2, telephonyNetworkRequest));
    }

    private void onAddNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        if (this.mLastImsOperationIsRelease) {
            this.mLastImsOperationIsRelease = false;
            if (Arrays.equals(this.mLastReleasedImsRequestCapabilities, telephonyNetworkRequest.getCapabilities()) && this.mImsThrottleCounter.addOccurrence()) {
                reportAnomaly(telephonyNetworkRequest.getNativeNetworkRequest().getRequestorPackageName() + " requested with same capabilities " + this.mImsThrottleCounter.getFrequencyString(), "ead6f8db-d2f2-4ed3-8da5-1d8560fe7daf");
            }
        }
        if (!this.mAllNetworkRequestList.add(telephonyNetworkRequest)) {
            loge("onAddNetworkRequest: Duplicate network request. " + telephonyNetworkRequest);
            return;
        }
        log("onAddNetworkRequest: added " + telephonyNetworkRequest);
        onSatisfyNetworkRequest(telephonyNetworkRequest);
    }

    /* access modifiers changed from: protected */
    public void onSatisfyNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        if (telephonyNetworkRequest.getState() == 1) {
            logv("Already satisfied. " + telephonyNetworkRequest);
        } else if (!findCompatibleDataNetworkAndAttach(telephonyNetworkRequest)) {
            DataEvaluation evaluateNetworkRequest = evaluateNetworkRequest(telephonyNetworkRequest, DataEvaluation.DataEvaluationReason.NEW_REQUEST);
            if (!evaluateNetworkRequest.containsDisallowedReasons()) {
                DataProfile candidateDataProfile = evaluateNetworkRequest.getCandidateDataProfile();
                if (candidateDataProfile != null) {
                    setupDataNetwork(candidateDataProfile, (DataRetryManager.DataSetupRetryEntry) null, evaluateNetworkRequest.getDataAllowedReason());
                }
            } else if (evaluateNetworkRequest.contains(DataEvaluation.DataDisallowedReason.ONLY_ALLOWED_SINGLE_NETWORK)) {
                sendMessage(obtainMessage(16, DataEvaluation.DataEvaluationReason.SINGLE_DATA_NETWORK_ARBITRATION));
            }
        }
    }

    private boolean findCompatibleDataNetworkAndAttach(TelephonyNetworkRequest telephonyNetworkRequest) {
        return findCompatibleDataNetworkAndAttach(new NetworkRequestList(telephonyNetworkRequest));
    }

    private boolean findCompatibleDataNetworkAndAttach(NetworkRequestList networkRequestList) {
        for (DataNetwork next : this.mDataNetworkList) {
            if (((TelephonyNetworkRequest) networkRequestList.stream().filter(new DataNetworkController$$ExternalSyntheticLambda4(next)).findAny().orElse((Object) null)) == null) {
                logv("Found a compatible data network " + next + ". Attaching " + networkRequestList);
                return next.attachNetworkRequests(networkRequestList);
            }
        }
        return false;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$findCompatibleDataNetworkAndAttach$6(DataNetwork dataNetwork, TelephonyNetworkRequest telephonyNetworkRequest) {
        return !telephonyNetworkRequest.canBeSatisfiedBy(dataNetwork.getNetworkCapabilities());
    }

    private boolean serviceStateAllowsPSAttach(ServiceState serviceState, int i) {
        int dataRegistrationState = getDataRegistrationState(serviceState, i);
        if (dataRegistrationState == 1 || dataRegistrationState == 5) {
            return true;
        }
        if (serviceState.getVoiceRegState() != 0 || this.mPhone.getPhoneId() == PhoneSwitcher.getInstance().getPreferredDataPhoneId() || !isLegacyCs(serviceState.getVoiceNetworkType())) {
            return false;
        }
        return true;
    }

    private boolean isLegacyCs(int i) {
        int networkTypeToAccessNetworkType = DataUtils.networkTypeToAccessNetworkType(i);
        return networkTypeToAccessNetworkType == 1 || networkTypeToAccessNetworkType == 2 || networkTypeToAccessNetworkType == 4;
    }

    private boolean isOnlySingleDataNetworkAllowed(int i) {
        if (i == 2) {
            return false;
        }
        return this.mDataConfigManager.getNetworkTypesOnlySupportSingleDataNetwork().contains(Integer.valueOf(getDataNetworkType(i)));
    }

    public boolean isInternetDataAllowed() {
        return !evaluateNetworkRequest(new TelephonyNetworkRequest(new NetworkRequest.Builder().addCapability(12).addTransportType(0).build(), this.mPhone), DataEvaluation.DataEvaluationReason.EXTERNAL_QUERY).containsDisallowedReasons();
    }

    public boolean isInternetUnmetered() {
        return this.mDataNetworkList.stream().filter(new DataNetworkController$$ExternalSyntheticLambda49()).filter(new DataNetworkController$$ExternalSyntheticLambda17()).allMatch(new DataNetworkController$$ExternalSyntheticLambda50());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isInternetUnmetered$7(DataNetwork dataNetwork) {
        return !dataNetwork.isConnecting() && !dataNetwork.isDisconnected();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isInternetUnmetered$8(DataNetwork dataNetwork) {
        return dataNetwork.getNetworkCapabilities().hasCapability(11) || dataNetwork.getNetworkCapabilities().hasCapability(25);
    }

    public List<DataEvaluation.DataDisallowedReason> getInternetDataDisallowedReasons() {
        return evaluateNetworkRequest(new TelephonyNetworkRequest(new NetworkRequest.Builder().addCapability(12).addTransportType(0).build(), this.mPhone), DataEvaluation.DataEvaluationReason.EXTERNAL_QUERY).getDataDisallowedReasons();
    }

    /* access modifiers changed from: protected */
    public DataEvaluation evaluateNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest, DataEvaluation.DataEvaluationReason dataEvaluationReason) {
        NetworkRegistrationInfo networkRegistrationInfo;
        DataSpecificRegistrationInfo dataSpecificInfo;
        DataEvaluation dataEvaluation = new DataEvaluation(dataEvaluationReason);
        int preferredTransportByNetworkCapability = this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(telephonyNetworkRequest.getApnTypeNetworkCapability());
        if (telephonyNetworkRequest.hasCapability(10)) {
            dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.EMERGENCY_REQUEST);
            dataEvaluation.setCandidateDataProfile(this.mDataProfileManager.getDataProfileForNetworkRequest(telephonyNetworkRequest, getDataNetworkType(preferredTransportByNetworkCapability)));
            telephonyNetworkRequest.setEvaluation(dataEvaluation);
            log(dataEvaluation.toString());
            return dataEvaluation;
        }
        if (!serviceStateAllowsPSAttach(this.mServiceState, preferredTransportByNetworkCapability)) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.NOT_IN_SERVICE);
        }
        if (this.mSimState != 10) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.SIM_NOT_READY);
        }
        if (!this.mDataConfigManager.isConfigCarrierSpecific()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_CONFIG_NOT_READY);
        }
        if (this.mPhone.getCallTracker().getState() != PhoneConstants.State.IDLE && !this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.CONCURRENT_VOICE_DATA_NOT_ALLOWED);
        }
        if (preferredTransportByNetworkCapability == 1 && telephonyNetworkRequest.hasCapability(33) && (networkRegistrationInfo = this.mServiceState.getNetworkRegistrationInfo(2, 1)) != null && (dataSpecificInfo = networkRegistrationInfo.getDataSpecificInfo()) != null && dataSpecificInfo.getVopsSupportInfo() != null && !dataSpecificInfo.getVopsSupportInfo().isVopsSupported()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.VOPS_NOT_SUPPORTED);
        }
        if (!SubscriptionManager.isValidSubscriptionId(SubscriptionManager.getDefaultDataSubscriptionId())) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DEFAULT_DATA_UNSELECTED);
        }
        if (this.mServiceState.getDataRoaming() && !this.mDataSettingsManager.isDataRoamingEnabled()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.ROAMING_DISABLED);
        }
        if (this.mPsRestricted) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_RESTRICTED_BY_NETWORK);
        }
        if (this.mPendingTearDownAllNetworks) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.PENDING_TEAR_DOWN_ALL);
        }
        if (preferredTransportByNetworkCapability == 1 && (!this.mPhone.getServiceStateTracker().getDesiredPowerState() || this.mPhone.mCi.getRadioState() != 1)) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.RADIO_POWER_OFF);
        }
        if (!this.mPhone.getServiceStateTracker().getPowerStateFromCarrier()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.RADIO_DISABLED_BY_CARRIER);
        }
        if (!this.mDataServiceBound.get(preferredTransportByNetworkCapability)) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_SERVICE_NOT_READY);
        }
        if (this.mPhone.isInCdmaEcm()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.CDMA_EMERGENCY_CALLBACK_MODE);
        }
        if (isOnlySingleDataNetworkAllowed(preferredTransportByNetworkCapability) && !telephonyNetworkRequest.hasCapability(4) && this.mDataNetworkList.stream().anyMatch(new DataNetworkController$$ExternalSyntheticLambda58())) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.ONLY_ALLOWED_SINGLE_NETWORK);
        }
        if (!this.mDataSettingsManager.isDataInitialized()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_SETTINGS_NOT_READY);
        } else if (!this.mDataSettingsManager.isDataEnabled(DataUtils.networkCapabilityToApnType(telephonyNetworkRequest.getApnTypeNetworkCapability()))) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_DISABLED);
        }
        if (!dataEvaluation.containsDisallowedReasons()) {
            dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.NORMAL);
            if (!this.mDataSettingsManager.isDataEnabled() && telephonyNetworkRequest.hasCapability(0) && this.mDataSettingsManager.isMmsAlwaysAllowed()) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.MMS_REQUEST);
            }
        } else if (!dataEvaluation.containsHardDisallowedReasons()) {
            if ((this.mPhone.isInEmergencyCall() || this.mPhone.isInEcm()) && telephonyNetworkRequest.hasCapability(1)) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.EMERGENCY_SUPL);
            } else if (!telephonyNetworkRequest.hasCapability(13) && !telephonyNetworkRequest.hasCapability(2)) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.RESTRICTED_REQUEST);
            } else if (preferredTransportByNetworkCapability == 2) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.UNMETERED_USAGE);
            } else if (preferredTransportByNetworkCapability == 1 && !telephonyNetworkRequest.isMeteredRequest()) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.UNMETERED_USAGE);
            }
        }
        DataProfile dataProfileForNetworkRequest = this.mDataProfileManager.getDataProfileForNetworkRequest(telephonyNetworkRequest, getDataNetworkType(preferredTransportByNetworkCapability));
        if (dataProfileForNetworkRequest == null) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.NO_SUITABLE_DATA_PROFILE);
        } else if (dataEvaluationReason == DataEvaluation.DataEvaluationReason.NEW_REQUEST && (this.mDataRetryManager.isAnySetupRetryScheduled(dataProfileForNetworkRequest, preferredTransportByNetworkCapability) || this.mDataRetryManager.isSimilarNetworkRequestRetryScheduled(telephonyNetworkRequest, preferredTransportByNetworkCapability))) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.RETRY_SCHEDULED);
        } else if (this.mDataRetryManager.isDataProfileThrottled(dataProfileForNetworkRequest, preferredTransportByNetworkCapability)) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_THROTTLED);
        }
        mtkEvaluateNetworkRequest(dataEvaluation, telephonyNetworkRequest, dataEvaluationReason, preferredTransportByNetworkCapability);
        if (!dataEvaluation.containsDisallowedReasons()) {
            dataEvaluation.setCandidateDataProfile(dataProfileForNetworkRequest);
        }
        telephonyNetworkRequest.setEvaluation(dataEvaluation);
        if (dataEvaluationReason != DataEvaluation.DataEvaluationReason.EXTERNAL_QUERY) {
            log(dataEvaluation.toString() + ", network type=" + TelephonyManager.getNetworkTypeName(getDataNetworkType(preferredTransportByNetworkCapability)) + ", reg state=" + NetworkRegistrationInfo.registrationStateToString(getDataRegistrationState(this.mServiceState, preferredTransportByNetworkCapability)) + ", " + telephonyNetworkRequest);
        }
        return dataEvaluation;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$evaluateNetworkRequest$9(DataNetwork dataNetwork) {
        return !dataNetwork.getNetworkCapabilities().hasCapability(4);
    }

    private List<NetworkRequestList> getGroupedUnsatisfiedNetworkRequests() {
        NetworkRequestList networkRequestList = new NetworkRequestList();
        Iterator it = this.mAllNetworkRequestList.iterator();
        while (it.hasNext()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) it.next();
            if (telephonyNetworkRequest.getState() == 0) {
                networkRequestList.add(telephonyNetworkRequest);
            }
        }
        return DataUtils.getGroupedNetworkRequestList(networkRequestList);
    }

    private void onReevaluateUnsatisfiedNetworkRequests(DataEvaluation.DataEvaluationReason dataEvaluationReason) {
        DataProfile candidateDataProfile;
        List<NetworkRequestList> groupedUnsatisfiedNetworkRequests = getGroupedUnsatisfiedNetworkRequests();
        log("Re-evaluating " + groupedUnsatisfiedNetworkRequests.stream().mapToInt(new DataNetworkController$$ExternalSyntheticLambda13()).sum() + " unsatisfied network requests in " + groupedUnsatisfiedNetworkRequests.size() + " groups, " + ((String) groupedUnsatisfiedNetworkRequests.stream().map(new DataNetworkController$$ExternalSyntheticLambda14()).collect(Collectors.joining(", "))) + " due to " + dataEvaluationReason);
        for (NetworkRequestList next : groupedUnsatisfiedNetworkRequests) {
            if (!findCompatibleDataNetworkAndAttach(next)) {
                DataEvaluation evaluateNetworkRequest = evaluateNetworkRequest((TelephonyNetworkRequest) next.get(0), dataEvaluationReason);
                if (!evaluateNetworkRequest.containsDisallowedReasons() && (candidateDataProfile = evaluateNetworkRequest.getCandidateDataProfile()) != null) {
                    setupDataNetwork(candidateDataProfile, (DataRetryManager.DataSetupRetryEntry) null, evaluateNetworkRequest.getDataAllowedReason());
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public DataEvaluation evaluateDataNetwork(DataNetwork dataNetwork, DataEvaluation.DataEvaluationReason dataEvaluationReason) {
        NetworkRegistrationInfo networkRegistrationInfo;
        DataSpecificRegistrationInfo dataSpecificInfo;
        DataEvaluation dataEvaluation = new DataEvaluation(dataEvaluationReason);
        if (dataNetwork.getNetworkCapabilities().hasCapability(10)) {
            dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.EMERGENCY_REQUEST);
            log(dataEvaluation.toString());
            return dataEvaluation;
        }
        if (this.mSimState != 10) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.SIM_NOT_READY);
        }
        if (this.mPhone.isInCdmaEcm()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.CDMA_EMERGENCY_CALLBACK_MODE);
        }
        if (isOnlySingleDataNetworkAllowed(dataNetwork.getTransport()) && !dataNetwork.getNetworkCapabilities().hasCapability(4)) {
            if (this.mAllNetworkRequestList.stream().filter(new DataNetworkController$$ExternalSyntheticLambda34(this, dataNetwork)).anyMatch(new DataNetworkController$$ExternalSyntheticLambda35(dataNetwork))) {
                dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.ONLY_ALLOWED_SINGLE_NETWORK);
            } else {
                log("evaluateDataNetwork: " + dataNetwork + " has the highest priority. No need to tear down");
            }
        }
        if (dataNetwork.getAttachedNetworkRequestList().get(new int[]{33}) != null) {
            if (dataNetwork.shouldDelayImsTearDown()) {
                log("Ignored VoPS check due to delay IMS tear down until call ends.");
            } else if (!(dataNetwork.getTransport() != 1 || (networkRegistrationInfo = this.mServiceState.getNetworkRegistrationInfo(2, 1)) == null || (dataSpecificInfo = networkRegistrationInfo.getDataSpecificInfo()) == null || dataSpecificInfo.getVopsSupportInfo() == null || dataSpecificInfo.getVopsSupportInfo().isVopsSupported())) {
                dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.VOPS_NOT_SUPPORTED);
            }
        }
        boolean z = !this.mDataSettingsManager.isDataEnabled();
        if (this.mServiceState.getDataRoaming() && !this.mDataSettingsManager.isDataRoamingEnabled()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.ROAMING_DISABLED);
        }
        int dataNetworkType = getDataNetworkType(dataNetwork.getTransport());
        DataProfile dataProfile = dataNetwork.getDataProfile();
        if (dataProfile.getApnSetting() != null) {
            z = !this.mDataSettingsManager.isDataEnabled(DataUtils.networkCapabilityToApnType(DataUtils.getHighestPriorityNetworkCapabilityFromDataProfile(this.mDataConfigManager, dataProfile)));
            if (dataNetworkType != 0 && !dataProfile.getApnSetting().canSupportLingeringNetworkType(dataNetworkType)) {
                log("networkType=" + TelephonyManager.getNetworkTypeName(dataNetworkType) + ", networkTypeBitmask=" + dataProfile.getApnSetting().getNetworkTypeBitmask() + ", lingeringNetworkTypeBitmask=" + dataProfile.getApnSetting().getLingeringNetworkTypeBitmask());
                dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_NETWORK_TYPE_NOT_ALLOWED);
            }
        }
        if (z) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_DISABLED);
        }
        if (!this.mDataProfileManager.isDataProfileCompatible(dataProfile)) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_PROFILE_INVALID);
        }
        if (dataNetwork.isInternetSupported() && !this.mDataProfileManager.isDataProfilePreferred(dataProfile) && this.mDataProfileManager.isAnyPreferredDataProfileExisting()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.DATA_PROFILE_NOT_PREFERRED);
        }
        mtkEvaluateDataNetwork(dataEvaluation, dataNetwork, dataEvaluationReason, dataNetwork.getTransport());
        if (!dataEvaluation.containsDisallowedReasons()) {
            dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.NORMAL);
        } else if (!dataEvaluation.containsHardDisallowedReasons()) {
            if ((this.mPhone.isInEmergencyCall() || this.mPhone.isInEcm()) && dataNetwork.isEmergencySupl()) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.EMERGENCY_SUPL);
            } else if (!dataNetwork.getNetworkCapabilities().hasCapability(13) && !dataNetwork.getNetworkCapabilities().hasCapability(2)) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.RESTRICTED_REQUEST);
            } else if (dataNetwork.getTransport() == 2) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.UNMETERED_USAGE);
            } else if (!this.mDataConfigManager.isAnyMeteredCapability(dataNetwork.getNetworkCapabilities().getCapabilities(), this.mServiceState.getDataRoaming())) {
                dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.UNMETERED_USAGE);
            }
        }
        log("Evaluated " + dataNetwork + ", " + dataEvaluation.toString());
        return dataEvaluation;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$evaluateDataNetwork$11(DataNetwork dataNetwork, TelephonyNetworkRequest telephonyNetworkRequest) {
        return dataNetwork.getTransport() == this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(telephonyNetworkRequest.getApnTypeNetworkCapability());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$evaluateDataNetwork$12(DataNetwork dataNetwork, TelephonyNetworkRequest telephonyNetworkRequest) {
        return telephonyNetworkRequest.getPriority() > dataNetwork.getPriority();
    }

    private void onReevaluateExistingDataNetworks(DataEvaluation.DataEvaluationReason dataEvaluationReason) {
        if (this.mDataNetworkList.isEmpty()) {
            log("onReevaluateExistingDataNetworks: No existing data networks to re-evaluate.");
            return;
        }
        log("Re-evaluating " + this.mDataNetworkList.size() + " existing data networks due to " + dataEvaluationReason);
        for (DataNetwork next : this.mDataNetworkList) {
            if (next.isConnecting() || next.isConnected()) {
                DataEvaluation evaluateDataNetwork = evaluateDataNetwork(next, dataEvaluationReason);
                if (evaluateDataNetwork.containsDisallowedReasons()) {
                    tearDownGracefully(next, getTearDownReason(evaluateDataNetwork));
                }
            }
        }
    }

    private DataEvaluation evaluateDataNetworkHandover(DataNetwork dataNetwork) {
        NetworkRegistrationInfo networkRegistrationInfo;
        DataSpecificRegistrationInfo dataSpecificInfo;
        DataEvaluation dataEvaluation = new DataEvaluation(DataEvaluation.DataEvaluationReason.DATA_HANDOVER);
        if (!dataNetwork.isConnecting() && !dataNetwork.isConnected()) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.ILLEGAL_STATE);
            return dataEvaluation;
        } else if (this.mDataRetryManager.isAnyHandoverRetryScheduled(dataNetwork)) {
            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.RETRY_SCHEDULED);
            return dataEvaluation;
        } else {
            if (this.mDataConfigManager.isEnhancedIwlanHandoverCheckEnabled() && (networkRegistrationInfo = this.mServiceState.getNetworkRegistrationInfo(2, DataUtils.getTargetTransport(dataNetwork.getTransport()))) != null) {
                if (!networkRegistrationInfo.isInService() && (!isMtkImsDataSupport() || !dataNetwork.getNetworkCapabilities().hasCapability(4))) {
                    dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.NOT_IN_SERVICE);
                }
                if (dataNetwork.getAttachedNetworkRequestList().stream().anyMatch(new DataNetworkController$$ExternalSyntheticLambda0()) && (dataSpecificInfo = networkRegistrationInfo.getDataSpecificInfo()) != null && dataSpecificInfo.getVopsSupportInfo() != null && !dataSpecificInfo.getVopsSupportInfo().isVopsSupported()) {
                    dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.VOPS_NOT_SUPPORTED);
                }
                if (dataEvaluation.containsDisallowedReasons()) {
                    return dataEvaluation;
                }
            }
            if (this.mDataConfigManager.isIwlanHandoverPolicyEnabled()) {
                List<HandoverRule> handoverRules = this.mDataConfigManager.getHandoverRules();
                int networkTypeToAccessNetworkType = DataUtils.networkTypeToAccessNetworkType(getDataNetworkType(dataNetwork.getTransport()));
                int networkTypeToAccessNetworkType2 = DataUtils.networkTypeToAccessNetworkType(getDataNetworkType(DataUtils.getTargetTransport(dataNetwork.getTransport())));
                NetworkCapabilities networkCapabilities = dataNetwork.getNetworkCapabilities();
                log("evaluateDataNetworkHandover: source=" + AccessNetworkConstants.AccessNetworkType.toString(networkTypeToAccessNetworkType) + ", target=" + AccessNetworkConstants.AccessNetworkType.toString(networkTypeToAccessNetworkType2) + ", ServiceState=" + this.mServiceState + ", capabilities=" + networkCapabilities);
                for (HandoverRule next : handoverRules) {
                    if ((!next.isOnlyForRoaming || this.mServiceState.getDataRoamingFromRegistration()) && next.sourceAccessNetworks.contains(Integer.valueOf(networkTypeToAccessNetworkType)) && next.targetAccessNetworks.contains(Integer.valueOf(networkTypeToAccessNetworkType2))) {
                        if (!next.networkCapabilities.isEmpty()) {
                            Stream stream = next.networkCapabilities.stream();
                            Objects.requireNonNull(networkCapabilities);
                            if (stream.anyMatch(new DataNetworkController$$ExternalSyntheticLambda1(networkCapabilities))) {
                            }
                        }
                        log("evaluateDataNetworkHandover: Matched " + next);
                        if (next.type == 2) {
                            dataEvaluation.addDataDisallowedReason(DataEvaluation.DataDisallowedReason.NOT_ALLOWED_BY_POLICY);
                        } else {
                            dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.NORMAL);
                        }
                        log("evaluateDataNetworkHandover: " + dataEvaluation);
                        return dataEvaluation;
                    }
                }
                log("evaluateDataNetworkHandover: Did not find matching rule.");
            } else {
                log("evaluateDataNetworkHandover: IWLAN handover policy not enabled.");
            }
            dataEvaluation.addDataAllowedReason(DataEvaluation.DataAllowedReason.NORMAL);
            return dataEvaluation;
        }
    }

    /* renamed from: com.android.internal.telephony.data.DataNetworkController$13  reason: invalid class name */
    static /* synthetic */ class AnonymousClass13 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason;

        /* JADX WARNING: Can't wrap try/catch for region: R(44:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|(3:43|44|46)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(46:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|46) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:17:0x0060 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x006c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:21:0x0078 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:23:0x0084 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:25:0x0090 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:27:0x009c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:29:0x00a8 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:31:0x00b4 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:33:0x00c0 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:35:0x00cc */
        /* JADX WARNING: Missing exception handler attribute for start block: B:37:0x00d8 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:39:0x00e4 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:41:0x00f0 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:43:0x00fc */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason[] r0 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason = r0
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.DATA_DISABLED     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.ROAMING_DISABLED     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.DEFAULT_DATA_UNSELECTED     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.NOT_IN_SERVICE     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.DATA_CONFIG_NOT_READY     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.SIM_NOT_READY     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.CONCURRENT_VOICE_DATA_NOT_ALLOWED     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.RADIO_POWER_OFF     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.PENDING_TEAR_DOWN_ALL     // Catch:{ NoSuchFieldError -> 0x006c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r2 = 9
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.RADIO_DISABLED_BY_CARRIER     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r2 = 10
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0084 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.DATA_SERVICE_NOT_READY     // Catch:{ NoSuchFieldError -> 0x0084 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0084 }
                r2 = 11
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0084 }
            L_0x0084:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0090 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.NO_SUITABLE_DATA_PROFILE     // Catch:{ NoSuchFieldError -> 0x0090 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0090 }
                r2 = 12
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0090 }
            L_0x0090:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x009c }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.DATA_NETWORK_TYPE_NOT_ALLOWED     // Catch:{ NoSuchFieldError -> 0x009c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x009c }
                r2 = 13
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x009c }
            L_0x009c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x00a8 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.CDMA_EMERGENCY_CALLBACK_MODE     // Catch:{ NoSuchFieldError -> 0x00a8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00a8 }
                r2 = 14
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00a8 }
            L_0x00a8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x00b4 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.RETRY_SCHEDULED     // Catch:{ NoSuchFieldError -> 0x00b4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00b4 }
                r2 = 15
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00b4 }
            L_0x00b4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x00c0 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.DATA_THROTTLED     // Catch:{ NoSuchFieldError -> 0x00c0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00c0 }
                r2 = 16
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00c0 }
            L_0x00c0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x00cc }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.DATA_PROFILE_INVALID     // Catch:{ NoSuchFieldError -> 0x00cc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00cc }
                r2 = 17
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00cc }
            L_0x00cc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x00d8 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.DATA_PROFILE_NOT_PREFERRED     // Catch:{ NoSuchFieldError -> 0x00d8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00d8 }
                r2 = 18
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00d8 }
            L_0x00d8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x00e4 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.NOT_ALLOWED_BY_POLICY     // Catch:{ NoSuchFieldError -> 0x00e4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00e4 }
                r2 = 19
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00e4 }
            L_0x00e4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x00f0 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.ILLEGAL_STATE     // Catch:{ NoSuchFieldError -> 0x00f0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00f0 }
                r2 = 20
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00f0 }
            L_0x00f0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x00fc }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.VOPS_NOT_SUPPORTED     // Catch:{ NoSuchFieldError -> 0x00fc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00fc }
                r2 = 21
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00fc }
            L_0x00fc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason     // Catch:{ NoSuchFieldError -> 0x0108 }
                com.android.internal.telephony.data.DataEvaluation$DataDisallowedReason r1 = com.android.internal.telephony.data.DataEvaluation.DataDisallowedReason.ONLY_ALLOWED_SINGLE_NETWORK     // Catch:{ NoSuchFieldError -> 0x0108 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0108 }
                r2 = 22
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0108 }
            L_0x0108:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.DataNetworkController.AnonymousClass13.<clinit>():void");
        }
    }

    @DataNetwork.TearDownReason
    private static int getTearDownReason(DataEvaluation dataEvaluation) {
        if (dataEvaluation.containsDisallowedReasons()) {
            switch (AnonymousClass13.$SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason[dataEvaluation.getDataDisallowedReasons().get(0).ordinal()]) {
                case 1:
                    return 4;
                case 2:
                    return 7;
                case 3:
                    return 17;
                case 4:
                    return 18;
                case 5:
                    return 19;
                case 6:
                    return 2;
                case 7:
                    return 8;
                case 8:
                    return 3;
                case 9:
                    return 20;
                case 10:
                    return 11;
                case 11:
                    return 10;
                case 12:
                    return 21;
                case 13:
                    return 6;
                case 14:
                    return 22;
                case 15:
                    return 23;
                case 16:
                    return 24;
                case 17:
                    return 25;
                case 18:
                    return 26;
                case 19:
                    return 27;
                case 20:
                    return 28;
                case 21:
                    return 16;
                case 22:
                    return 29;
            }
        }
        return 0;
    }

    public boolean isInternetNetwork(int i) {
        for (DataNetwork next : this.mDataNetworkList) {
            if (next.getId() == i && next.isConnected() && next.getNetworkCapabilities().hasCapability(12)) {
                return true;
            }
        }
        return false;
    }

    private boolean isDataDormant() {
        return this.mDataNetworkList.stream().anyMatch(new DataNetworkController$$ExternalSyntheticLambda11()) && this.mDataNetworkList.stream().noneMatch(new DataNetworkController$$ExternalSyntheticLambda12());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isDataDormant$14(DataNetwork dataNetwork) {
        return dataNetwork.getLinkStatus() == 1;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isDataDormant$15(DataNetwork dataNetwork) {
        return dataNetwork.getLinkStatus() == 2;
    }

    /* access modifiers changed from: private */
    public void updateDataActivity() {
        int i;
        if (isDataDormant()) {
            i = 4;
        } else {
            i = this.mPhone.getLinkBandwidthEstimator() != null ? this.mPhone.getLinkBandwidthEstimator().getDataActivity() : 0;
        }
        if (this.mDataActivity != i) {
            logv("updateDataActivity: dataActivity=" + DataUtils.dataActivityToString(i));
            this.mDataActivity = i;
            this.mPhone.notifyDataActivity();
        }
    }

    public void removeNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        sendMessage(obtainMessage(3, telephonyNetworkRequest));
    }

    /* access modifiers changed from: protected */
    public void onRemoveNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        TelephonyNetworkRequest telephonyNetworkRequest2 = (TelephonyNetworkRequest) this.mAllNetworkRequestList.stream().filter(new DataNetworkController$$ExternalSyntheticLambda33(telephonyNetworkRequest)).findFirst().orElse((Object) null);
        if (telephonyNetworkRequest2 == null || !this.mAllNetworkRequestList.remove(telephonyNetworkRequest2)) {
            loge("onRemoveNetworkRequest: Network request does not exist. " + telephonyNetworkRequest2);
            return;
        }
        if (telephonyNetworkRequest2.hasCapability(4)) {
            this.mImsThrottleCounter.addOccurrence();
            this.mLastReleasedImsRequestCapabilities = telephonyNetworkRequest2.getCapabilities();
            this.mLastImsOperationIsRelease = true;
        }
        if (telephonyNetworkRequest2.getAttachedNetwork() != null) {
            telephonyNetworkRequest2.getAttachedNetwork().detachNetworkRequest(telephonyNetworkRequest2);
        }
        log("onRemoveNetworkRequest: Removed " + telephonyNetworkRequest2);
    }

    public boolean isNetworkRequestExisting(TelephonyNetworkRequest telephonyNetworkRequest) {
        return this.mAllNetworkRequestList.contains(telephonyNetworkRequest);
    }

    public boolean isNetworkInterfaceExisting(String str) {
        return this.mDataNetworkList.stream().filter(new DataNetworkController$$ExternalSyntheticLambda31()).anyMatch(new DataNetworkController$$ExternalSyntheticLambda32(str));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isNetworkInterfaceExisting$17(DataNetwork dataNetwork) {
        return !dataNetwork.isDisconnecting();
    }

    /* access modifiers changed from: private */
    public void registerImsFeatureRegistrationState(int i, final int i2) {
        AnonymousClass10 r0 = new RegistrationManager.RegistrationCallback() {
            public void onRegistered(ImsRegistrationAttributes imsRegistrationAttributes) {
                DataNetworkController dataNetworkController = DataNetworkController.this;
                dataNetworkController.log("IMS " + DataUtils.imsFeatureToString(i2) + " registered. Attributes=" + imsRegistrationAttributes);
                DataNetworkController.this.mRegisteredImsFeatures.add(Integer.valueOf(i2));
            }

            public void onUnregistered(ImsReasonInfo imsReasonInfo) {
                DataNetworkController dataNetworkController = DataNetworkController.this;
                dataNetworkController.log("IMS " + DataUtils.imsFeatureToString(i2) + " deregistered. Info=" + imsReasonInfo);
                DataNetworkController.this.mRegisteredImsFeatures.remove(Integer.valueOf(i2));
                DataNetworkController.this.evaluatePendingImsDeregDataNetworks();
            }
        };
        if (i2 == 1) {
            this.mImsManager.getImsMmTelManager(i).registerImsRegistrationCallback(new DataNetworkController$$ExternalSyntheticLambda6(this), r0);
        } else if (i2 == 2) {
            try {
                this.mImsManager.getImsRcsManager(i).registerImsRegistrationCallback(new DataNetworkController$$ExternalSyntheticLambda6(this), r0);
            } catch (ImsException e) {
                loge("updateImsFeatureRegistrationStateListening: subId=" + i + ", imsFeature=" + DataUtils.imsFeatureToString(i2) + ", " + e);
                return;
            }
        }
        this.mImsFeatureRegistrationCallbacks.put(i2, r0);
        log("Successfully register " + DataUtils.imsFeatureToString(i2) + " registration state. subId=" + i);
    }

    /* access modifiers changed from: private */
    public void unregisterImsFeatureRegistrationState(int i, int i2) {
        RegistrationManager.RegistrationCallback registrationCallback = this.mImsFeatureRegistrationCallbacks.get(i2);
        if (registrationCallback != null) {
            if (i2 == 1) {
                this.mImsManager.getImsMmTelManager(i).unregisterImsRegistrationCallback(registrationCallback);
            } else if (i2 == 2) {
                this.mImsManager.getImsRcsManager(i).unregisterImsRegistrationCallback(registrationCallback);
            }
            log("Successfully unregistered " + DataUtils.imsFeatureToString(i2) + " registration state. sudId=" + i);
            this.mImsFeatureRegistrationCallbacks.remove(i2);
        }
    }

    private void registerImsStateCallback(int i) {
        DataNetworkController$$ExternalSyntheticLambda45 dataNetworkController$$ExternalSyntheticLambda45 = new DataNetworkController$$ExternalSyntheticLambda45(this, i);
        try {
            ImsStateCallback imsStateCallback = (ImsStateCallback) dataNetworkController$$ExternalSyntheticLambda45.apply(1);
            this.mImsManager.getImsMmTelManager(i).registerImsStateCallback(new DataNetworkController$$ExternalSyntheticLambda6(this), imsStateCallback);
            this.mImsStateCallbacks.put(1, imsStateCallback);
            log("Successfully register MMTEL state on sub " + i);
            ImsStateCallback imsStateCallback2 = (ImsStateCallback) dataNetworkController$$ExternalSyntheticLambda45.apply(2);
            this.mImsManager.getImsRcsManager(i).registerImsStateCallback(new DataNetworkController$$ExternalSyntheticLambda6(this), imsStateCallback2);
            this.mImsStateCallbacks.put(2, imsStateCallback2);
            log("Successfully register RCS state on sub " + i);
        } catch (ImsException e) {
            loge("Exception when registering IMS state callback. " + e);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ ImsStateCallback lambda$registerImsStateCallback$19(final int i, final Integer num) {
        return new ImsStateCallback() {
            public void onError() {
            }

            public void onUnavailable(int i) {
                DataNetworkController.this.unregisterImsFeatureRegistrationState(i, num.intValue());
            }

            public void onAvailable() {
                DataNetworkController.this.mImsFeaturePackageName.put(num.intValue(), ImsResolver.getInstance().getConfiguredImsServicePackageName(DataNetworkController.this.mPhone.getPhoneId(), num.intValue()));
                DataNetworkController.this.registerImsFeatureRegistrationState(i, num.intValue());
            }
        };
    }

    private void unregisterImsStateCallbacks(int i) {
        ImsStateCallback imsStateCallback = this.mImsStateCallbacks.get(1);
        if (imsStateCallback != null) {
            this.mImsManager.getImsMmTelManager(i).unregisterImsStateCallback(imsStateCallback);
            this.mImsStateCallbacks.remove(1);
            log("Unregister MMTEL state on sub " + i);
        }
        ImsStateCallback imsStateCallback2 = this.mImsStateCallbacks.get(2);
        if (imsStateCallback2 != null) {
            this.mImsManager.getImsRcsManager(i).unregisterImsStateCallback(imsStateCallback2);
            this.mImsStateCallbacks.remove(2);
            log("Unregister RCS state on sub " + i);
        }
    }

    private void onSubscriptionChanged() {
        if (this.mSubId != this.mPhone.getSubId()) {
            log("onDataConfigUpdated: mSubId changed from " + this.mSubId + " to " + this.mPhone.getSubId());
            if (isImsGracefulTearDownSupported()) {
                if (SubscriptionManager.isValidSubscriptionId(this.mPhone.getSubId())) {
                    registerImsStateCallback(this.mPhone.getSubId());
                } else {
                    unregisterImsStateCallbacks(this.mSubId);
                }
            }
            this.mSubId = this.mPhone.getSubId();
            updateSubscriptionPlans();
        }
    }

    private void onDataConfigUpdated() {
        StringBuilder sb = new StringBuilder();
        sb.append("onDataConfigUpdated: config is ");
        sb.append(this.mDataConfigManager.isConfigCarrierSpecific() ? "" : "not ");
        sb.append("carrier specific. mSimState=");
        sb.append(SubscriptionInfoUpdater.simStateString(this.mSimState));
        sb.append(". DeviceConfig updated.");
        log(sb.toString());
        updateAnomalySlidingWindowCounters();
        updateNetworkRequestsPriority();
        sendMessage(obtainMessage(5, DataEvaluation.DataEvaluationReason.DATA_CONFIG_CHANGED));
    }

    private void updateNetworkRequestsPriority() {
        Iterator it = this.mAllNetworkRequestList.iterator();
        while (it.hasNext()) {
            ((TelephonyNetworkRequest) it.next()).updatePriority();
        }
    }

    private void updateAnomalySlidingWindowCounters() {
        this.mImsThrottleCounter = new SlidingWindowEventCounter(this.mDataConfigManager.getAnomalyImsReleaseRequestThreshold().timeWindow, this.mDataConfigManager.getAnomalyImsReleaseRequestThreshold().eventNumOccurrence);
        this.mNetworkUnwantedCounter = new SlidingWindowEventCounter(this.mDataConfigManager.getAnomalyNetworkUnwantedThreshold().timeWindow, this.mDataConfigManager.getAnomalyNetworkUnwantedThreshold().eventNumOccurrence);
        this.mSetupDataCallWwanFailureCounter = new SlidingWindowEventCounter(this.mDataConfigManager.getAnomalySetupDataCallThreshold().timeWindow, this.mDataConfigManager.getAnomalySetupDataCallThreshold().eventNumOccurrence);
        this.mSetupDataCallWlanFailureCounter = new SlidingWindowEventCounter(this.mDataConfigManager.getAnomalySetupDataCallThreshold().timeWindow, this.mDataConfigManager.getAnomalySetupDataCallThreshold().eventNumOccurrence);
    }

    /* access modifiers changed from: private */
    public void onTrackNetworkUnwanted() {
        if (this.mNetworkUnwantedCounter.addOccurrence()) {
            reportAnomaly("Network Unwanted called " + this.mNetworkUnwantedCounter.getFrequencyString(), "9f3bc55b-bfa6-4e26-afaa-5031426a66d3");
        }
    }

    private NetworkRequestList findSatisfiableNetworkRequests(DataProfile dataProfile) {
        return new NetworkRequestList((List<TelephonyNetworkRequest>) (List) this.mAllNetworkRequestList.stream().filter(new DataNetworkController$$ExternalSyntheticLambda29()).filter(new DataNetworkController$$ExternalSyntheticLambda30(dataProfile)).collect(Collectors.toList()));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$findSatisfiableNetworkRequests$20(TelephonyNetworkRequest telephonyNetworkRequest) {
        return telephonyNetworkRequest.getState() == 0;
    }

    private void setupDataNetwork(DataProfile dataProfile, final DataRetryManager.DataSetupRetryEntry dataSetupRetryEntry, DataEvaluation.DataAllowedReason dataAllowedReason) {
        log("onSetupDataNetwork: dataProfile=" + dataProfile + ", retryEntry=" + dataSetupRetryEntry + ", allowed reason=" + dataAllowedReason + ", service state=" + this.mServiceState);
        for (DataNetwork next : this.mDataNetworkList) {
            if (next.getDataProfile().equals(dataProfile)) {
                log("onSetupDataNetwork: Found existing data network " + next + " has the same data profile.");
                if (dataSetupRetryEntry != null) {
                    dataSetupRetryEntry.setState(4);
                    return;
                }
                return;
            }
        }
        NetworkRequestList findSatisfiableNetworkRequests = findSatisfiableNetworkRequests(dataProfile);
        if (findSatisfiableNetworkRequests.isEmpty()) {
            log("Can't find any unsatisfied network requests that can be satisfied by this data profile.");
            if (dataSetupRetryEntry != null) {
                dataSetupRetryEntry.setState(4);
                return;
            }
            return;
        }
        int preferredTransportByNetworkCapability = this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(((TelephonyNetworkRequest) findSatisfiableNetworkRequests.get(0)).getApnTypeNetworkCapability());
        logl("Creating data network on " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability) + " with " + dataProfile + ", and attaching " + findSatisfiableNetworkRequests.size() + " network requests to it.");
        ApnSetting apnSetting = dataProfile.getApnSetting();
        if (apnSetting != null) {
            apnSetting.setProfileId(getProfileID(((TelephonyNetworkRequest) findSatisfiableNetworkRequests.get(0)).getApnTypeNetworkCapability()));
            if (dataSetupRetryEntry == null) {
                resetMdDataRetryCount(apnSetting);
            }
        }
        this.mDataNetworkList.add(TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeDataNetwork(this.mPhone, getLooper(), this.mDataServiceManagers, dataProfile, findSatisfiableNetworkRequests, preferredTransportByNetworkCapability, dataAllowedReason, new DataNetwork.DataNetworkCallback(new DataNetworkController$$ExternalSyntheticLambda6(this)) {
            public void onSetupDataFailed(DataNetwork dataNetwork, NetworkRequestList networkRequestList, int i, long j) {
                DataRetryManager.DataSetupRetryEntry dataSetupRetryEntry = dataSetupRetryEntry;
                if (dataSetupRetryEntry != null) {
                    dataSetupRetryEntry.setState(2);
                }
                DataNetworkController.this.onDataNetworkSetupFailed(dataNetwork, networkRequestList, i, j);
            }

            public void onConnected(DataNetwork dataNetwork) {
                DataRetryManager.DataSetupRetryEntry dataSetupRetryEntry = dataSetupRetryEntry;
                if (dataSetupRetryEntry != null) {
                    dataSetupRetryEntry.setState(3);
                }
                DataNetworkController.this.onDataNetworkConnected(dataNetwork);
            }

            public void onAttachFailed(DataNetwork dataNetwork, NetworkRequestList networkRequestList) {
                DataNetworkController.this.onAttachNetworkRequestsFailed(dataNetwork, networkRequestList);
            }

            public void onValidationStatusChanged(DataNetwork dataNetwork, int i, Uri uri) {
                DataNetworkController.this.onDataNetworkValidationStatusChanged(dataNetwork, i, uri);
            }

            public void onSuspendedStateChanged(DataNetwork dataNetwork, boolean z) {
                DataNetworkController.this.onDataNetworkSuspendedStateChanged(dataNetwork, z);
            }

            public void onDisconnected(DataNetwork dataNetwork, int i) {
                DataNetworkController.this.onDataNetworkDisconnected(dataNetwork, i);
            }

            public void onHandoverSucceeded(DataNetwork dataNetwork) {
                DataNetworkController.this.onDataNetworkHandoverSucceeded(dataNetwork);
            }

            public void onHandoverFailed(DataNetwork dataNetwork, int i, long j, int i2) {
                DataNetworkController.this.onDataNetworkHandoverFailed(dataNetwork, i, j, i2);
            }

            public void onLinkStatusChanged(DataNetwork dataNetwork, int i) {
                DataNetworkController.this.onLinkStatusChanged(dataNetwork, i);
            }

            public void onPcoDataChanged(DataNetwork dataNetwork) {
                DataNetworkController.this.onPcoDataChanged(dataNetwork);
            }

            public void onNetworkCapabilitiesChanged(DataNetwork dataNetwork) {
                DataNetworkController.this.onNetworkCapabilitiesChanged(dataNetwork);
            }

            public void onTrackNetworkUnwanted(DataNetwork dataNetwork) {
                DataNetworkController.this.onTrackNetworkUnwanted();
            }
        }));
        if (!this.mAnyDataNetworkExisting) {
            this.mAnyDataNetworkExisting = true;
            this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda7(this));
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$setupDataNetwork$23(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.invokeFromExecutor(new DataNetworkController$$ExternalSyntheticLambda15(this, dataNetworkControllerCallback));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$setupDataNetwork$22(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.onAnyDataNetworkExistingChanged(this.mAnyDataNetworkExisting);
    }

    /* access modifiers changed from: private */
    public void onDataNetworkSetupFailed(DataNetwork dataNetwork, NetworkRequestList networkRequestList, int i, long j) {
        logl("onDataNetworkSetupDataFailed: " + dataNetwork + ", cause=" + DataFailCause.toString(i) + ", retryDelayMillis=" + j + "ms.");
        this.mDataNetworkList.remove(dataNetwork);
        trackSetupDataCallFailure(dataNetwork.getTransport());
        if (this.mAnyDataNetworkExisting && this.mDataNetworkList.isEmpty()) {
            this.mPendingTearDownAllNetworks = false;
            this.mAnyDataNetworkExisting = false;
            this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda38(this));
        }
        networkRequestList.removeIf(new DataNetworkController$$ExternalSyntheticLambda39(this));
        if (networkRequestList.isEmpty()) {
            log("onDataNetworkSetupFailed: All requests have been released. Will not evaluate retry.");
        } else {
            this.mDataRetryManager.evaluateDataSetupRetry(dataNetwork.getDataProfile(), dataNetwork.getTransport(), networkRequestList, i, j);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onDataNetworkSetupFailed$25(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.invokeFromExecutor(new DataNetworkController$$ExternalSyntheticLambda5(this, dataNetworkControllerCallback));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onDataNetworkSetupFailed$24(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.onAnyDataNetworkExistingChanged(this.mAnyDataNetworkExisting);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$onDataNetworkSetupFailed$26(TelephonyNetworkRequest telephonyNetworkRequest) {
        return !this.mAllNetworkRequestList.contains(telephonyNetworkRequest);
    }

    private void trackSetupDataCallFailure(int i) {
        if (i != 1) {
            if (i != 2) {
                loge("trackSetupDataCallFailure: INVALID transport.");
            } else if (this.mSetupDataCallWlanFailureCounter.addOccurrence()) {
                reportAnomaly("IWLAN data service fails setup data call request " + this.mSetupDataCallWlanFailureCounter.getFrequencyString(), "e2248d8b-d55f-42bd-871c-0cfd80c3ddd1");
            }
        } else if (this.mPhone.getSignalStrength().getLevel() > 1 && this.mSetupDataCallWwanFailureCounter.addOccurrence()) {
            reportAnomaly("RIL fails setup data call request " + this.mSetupDataCallWwanFailureCounter.getFrequencyString(), "e6a98b97-9e34-4977-9a92-01d52a6691f6");
        }
    }

    private void reportAnomaly(String str, String str2) {
        logl(str);
        AnomalyReporter.reportAnomaly(UUID.fromString(str2), str, this.mPhone.getCarrierId());
    }

    /* access modifiers changed from: private */
    public void onDataNetworkConnected(DataNetwork dataNetwork) {
        logl("onDataNetworkConnected: " + dataNetwork);
        this.mPreviousConnectedDataNetworkList.add(0, dataNetwork);
        if (this.mPreviousConnectedDataNetworkList.size() > 10) {
            this.mPreviousConnectedDataNetworkList.remove(10);
        }
        updateOverallInternetDataState();
        if (dataNetwork.getNetworkCapabilities().hasCapability(4)) {
            logl("IMS data state changed from " + TelephonyUtils.dataStateToString(this.mImsDataNetworkState) + " to CONNECTED.");
            this.mImsDataNetworkState = 2;
        }
    }

    /* access modifiers changed from: private */
    public void onDataNetworkSetupRetry(DataRetryManager.DataSetupRetryEntry dataSetupRetryEntry) {
        NetworkRequestList networkRequestList = new NetworkRequestList(dataSetupRetryEntry.networkRequestList);
        networkRequestList.removeIf(new DataNetworkController$$ExternalSyntheticLambda16(this));
        if (networkRequestList.isEmpty()) {
            loge("onDataNetworkSetupRetry: Request list is empty. Abort retry.");
            dataSetupRetryEntry.setState(4);
            return;
        }
        TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) networkRequestList.get(0);
        int preferredTransportByNetworkCapability = this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(telephonyNetworkRequest.getApnTypeNetworkCapability());
        if (preferredTransportByNetworkCapability != dataSetupRetryEntry.transport) {
            log("Cannot re-satisfy " + telephonyNetworkRequest + " on " + AccessNetworkConstants.transportTypeToString(dataSetupRetryEntry.transport) + ". The preferred transport has switched to " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability) + ". " + dataSetupRetryEntry);
            dataSetupRetryEntry.setState(4);
            sendMessage(obtainMessage(5, DataEvaluation.DataEvaluationReason.PREFERRED_TRANSPORT_CHANGED));
            return;
        }
        DataEvaluation evaluateNetworkRequest = evaluateNetworkRequest(telephonyNetworkRequest, DataEvaluation.DataEvaluationReason.DATA_RETRY);
        if (!evaluateNetworkRequest.containsDisallowedReasons()) {
            DataProfile dataProfile = dataSetupRetryEntry.dataProfile;
            if (dataProfile == null) {
                dataProfile = evaluateNetworkRequest.getCandidateDataProfile();
            }
            if (dataProfile != null) {
                setupDataNetwork(dataProfile, dataSetupRetryEntry, evaluateNetworkRequest.getDataAllowedReason());
                return;
            }
            loge("onDataNetworkSetupRetry: Not able to find a suitable data profile to retry.");
            dataSetupRetryEntry.setState(2);
            return;
        }
        dataSetupRetryEntry.setState(2);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$onDataNetworkSetupRetry$27(TelephonyNetworkRequest telephonyNetworkRequest) {
        return !this.mAllNetworkRequestList.contains(telephonyNetworkRequest);
    }

    /* access modifiers changed from: private */
    public void onDataNetworkHandoverRetry(DataRetryManager.DataHandoverRetryEntry dataHandoverRetryEntry) {
        DataNetwork dataNetwork = dataHandoverRetryEntry.dataNetwork;
        if (!this.mDataNetworkList.contains(dataNetwork)) {
            log("onDataNetworkHandoverRetry: " + dataNetwork + " no longer exists.");
            dataHandoverRetryEntry.setState(4);
        } else if (!dataNetwork.isConnected()) {
            log("onDataNetworkHandoverRetry: " + dataNetwork + " is not in the right state.");
            dataHandoverRetryEntry.setState(4);
        } else {
            int preferredTransportByNetworkCapability = this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(dataNetwork.getApnTypeNetworkCapability());
            if (dataNetwork.getTransport() == preferredTransportByNetworkCapability) {
                log("onDataNetworkHandoverRetry: " + dataNetwork + " is already on the preferred transport " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability) + ".");
                dataHandoverRetryEntry.setState(4);
                return;
            }
            logl("Start handover " + dataNetwork + " to " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability) + ", " + dataHandoverRetryEntry);
            dataNetwork.startHandover(preferredTransportByNetworkCapability, dataHandoverRetryEntry);
        }
    }

    /* access modifiers changed from: private */
    public void onDataNetworkValidationStatusChanged(DataNetwork dataNetwork, int i, Uri uri) {
        String str;
        StringBuilder sb = new StringBuilder();
        sb.append("onDataNetworkValidationStatusChanged: ");
        sb.append(dataNetwork);
        sb.append(", validation status=");
        sb.append(DataUtils.validationStatusToString(i));
        if (uri != null) {
            str = ", " + uri;
        } else {
            str = "";
        }
        sb.append(str);
        log(sb.toString());
        if (!TextUtils.isEmpty(uri.toString())) {
            Intent intent = new Intent("android.telephony.action.CARRIER_SIGNAL_REDIRECTED");
            intent.putExtra("android.telephony.extra.REDIRECTION_URL", uri);
            this.mPhone.getCarrierSignalAgent().notifyCarrierSignalReceivers(intent);
            log("Notify carrier signal receivers with redirectUri: " + uri);
        }
        if (i != 1 && i != 2) {
            loge("Invalid validation status " + i + " received.");
        } else if (!this.mDataSettingsManager.isRecoveryOnBadNetworkEnabled()) {
            log("Ignore data network validation status changed because data stall recovery is disabled.");
        } else if (!dataNetwork.isInternetSupported()) {
        } else {
            if (i != 2 || (dataNetwork.getCurrentState() != null && !dataNetwork.isDisconnected())) {
                this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda48(i));
            } else {
                log("Ignoring invalid validation status for disconnected DataNetwork");
            }
        }
    }

    /* access modifiers changed from: private */
    public void onDataNetworkSuspendedStateChanged(DataNetwork dataNetwork, boolean z) {
        updateOverallInternetDataState();
        if (dataNetwork.getNetworkCapabilities().hasCapability(4)) {
            StringBuilder sb = new StringBuilder();
            sb.append("IMS data state changed from ");
            sb.append(TelephonyUtils.dataStateToString(this.mImsDataNetworkState));
            sb.append(" to ");
            sb.append(z ? "SUSPENDED" : "CONNECTED");
            logl(sb.toString());
            this.mImsDataNetworkState = z ? 3 : 2;
        }
    }

    /* access modifiers changed from: private */
    public void onDataNetworkDisconnected(DataNetwork dataNetwork, int i) {
        logl("onDataNetworkDisconnected: " + dataNetwork + ", cause=" + DataFailCause.toString(i) + "(" + i + ")");
        this.mDataNetworkList.remove(dataNetwork);
        this.mPendingImsDeregDataNetworks.remove(dataNetwork);
        this.mDataRetryManager.cancelPendingHandoverRetry(dataNetwork);
        updateOverallInternetDataState();
        if (dataNetwork.getNetworkCapabilities().hasCapability(4)) {
            logl("IMS data state changed from " + TelephonyUtils.dataStateToString(this.mImsDataNetworkState) + " to DISCONNECTED.");
            this.mImsDataNetworkState = 0;
        }
        if (this.mAnyDataNetworkExisting && this.mDataNetworkList.isEmpty()) {
            log("All data networks disconnected now.");
            this.mPendingTearDownAllNetworks = false;
            this.mAnyDataNetworkExisting = false;
            this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda55(this));
        }
        if (isMtkImsDataSupport()) {
            boolean anyMatch = this.mDataNetworkList.stream().anyMatch(new DataNetworkController$$ExternalSyntheticLambda56());
            if (!this.mDataNetworkList.isEmpty()) {
                log("data network exist " + this.mAnyDataNetworkExisting + " has ims " + anyMatch + " mDataNetworkList.size " + this.mDataNetworkList.size());
            }
            if (anyMatch && this.mDataNetworkList.size() == 1) {
                log("all data disconnect except ims, power off radio immediately");
                this.mPendingTearDownAllNetworks = false;
                this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda57());
            }
        }
        sendMessageDelayed(obtainMessage(5, DataEvaluation.DataEvaluationReason.RETRY_AFTER_DISCONNECTED), this.mDataConfigManager.getRetrySetupAfterDisconnectMillis());
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onDataNetworkDisconnected$31(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.invokeFromExecutor(new DataNetworkController$$ExternalSyntheticLambda51(this, dataNetworkControllerCallback));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onDataNetworkDisconnected$30(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.onAnyDataNetworkExistingChanged(this.mAnyDataNetworkExisting);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onDataNetworkDisconnected$32(DataNetwork dataNetwork) {
        return dataNetwork.getNetworkCapabilities().hasCapability(4) && dataNetwork.isConnected();
    }

    /* access modifiers changed from: private */
    public void onDataNetworkHandoverSucceeded(DataNetwork dataNetwork) {
        logl("Handover successfully. " + dataNetwork + " to " + AccessNetworkConstants.transportTypeToString(dataNetwork.getTransport()));
        sendMessage(obtainMessage(21, dataNetwork.getApnTypeNetworkCapability(), 0));
        sendMessage(obtainMessage(16, DataEvaluation.DataEvaluationReason.DATA_HANDOVER));
    }

    /* access modifiers changed from: private */
    public void onDataNetworkHandoverFailed(DataNetwork dataNetwork, int i, long j, int i2) {
        logl("Handover failed. " + dataNetwork + ", cause=" + DataFailCause.toString(i) + ", retryDelayMillis=" + j + "ms, handoverFailureMode=" + DataCallResponse.failureModeToString(i2));
        sendMessage(obtainMessage(16, DataEvaluation.DataEvaluationReason.DATA_HANDOVER));
        if (dataNetwork.getAttachedNetworkRequestList().isEmpty()) {
            log("onDataNetworkHandoverFailed: No network requests attached to " + dataNetwork + ". No need to retry since the network will be torn down soon.");
        } else if (i2 == 1 || (i2 == 0 && i == 2251)) {
            sendMessageDelayed(obtainMessage(21, dataNetwork.getApnTypeNetworkCapability(), 0), REEVALUATE_PREFERRED_TRANSPORT_DELAY_MILLIS);
        } else if (i2 == 3 || i2 == 0) {
            this.mDataRetryManager.evaluateDataSetupRetry(dataNetwork.getDataProfile(), DataUtils.getTargetTransport(dataNetwork.getTransport()), dataNetwork.getAttachedNetworkRequestList(), i, j);
            tearDownGracefully(dataNetwork, 13);
        } else {
            this.mDataRetryManager.evaluateDataHandoverRetry(dataNetwork, i, j);
        }
    }

    /* access modifiers changed from: private */
    public void onAttachNetworkRequestsFailed(DataNetwork dataNetwork, NetworkRequestList networkRequestList) {
        log("Failed to attach " + networkRequestList + " to " + dataNetwork);
    }

    /* access modifiers changed from: private */
    public void onDataStallReestablishInternet() {
        log("onDataStallReestablishInternet: Tear down data networks that support internet.");
        this.mDataNetworkList.stream().filter(new DataNetworkController$$ExternalSyntheticLambda17()).forEach(new DataNetworkController$$ExternalSyntheticLambda18());
    }

    private void onDataServiceBindingChanged(int i, boolean z) {
        StringBuilder sb = new StringBuilder();
        sb.append("onDataServiceBindingChanged: ");
        sb.append(AccessNetworkConstants.transportTypeToString(i));
        sb.append(" data service is ");
        sb.append(z ? "bound." : "unbound.");
        log(sb.toString());
        if (z) {
            this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda37(i));
        }
        this.mDataServiceBound.put(i, z);
    }

    /* access modifiers changed from: protected */
    public void onSimAbsent() {
        log("onSimAbsent");
        sendMessage(obtainMessage(16, DataEvaluation.DataEvaluationReason.SIM_REMOVAL));
    }

    private void onSimStateChanged(@TelephonyManager.SimState int i) {
        log("onSimStateChanged: state=" + SubscriptionInfoUpdater.simStateString(i));
        if (this.mSimState != i) {
            this.mSimState = i;
            if (i == 1) {
                onSimAbsent();
            } else if (i == 10) {
                sendMessage(obtainMessage(5, DataEvaluation.DataEvaluationReason.SIM_LOADED));
            }
        }
    }

    /* access modifiers changed from: private */
    public void onEvaluatePreferredTransport(int i) {
        int preferredTransportByNetworkCapability = this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(i);
        log("onEvaluatePreferredTransport: " + DataUtils.networkCapabilityToString(i) + " preferred on " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability));
        for (DataNetwork next : this.mDataNetworkList) {
            if (next.getApnTypeNetworkCapability() == i) {
                if (shouldIgnoreHandover(next)) {
                    log("ignore handover for " + next);
                } else if (next.getTransport() == preferredTransportByNetworkCapability) {
                    log("onEvaluatePreferredTransport:" + next + " already on " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability));
                } else if (next.isHandoverInProgress()) {
                    log("onEvaluatePreferredTransport: " + next + " handover in progress.");
                } else {
                    DataEvaluation evaluateDataNetworkHandover = evaluateDataNetworkHandover(next);
                    log("onEvaluatePreferredTransport: " + evaluateDataNetworkHandover + ", " + next);
                    if (!evaluateDataNetworkHandover.containsDisallowedReasons()) {
                        logl("Start handover " + next + " to " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability));
                        next.startHandover(preferredTransportByNetworkCapability, (DataRetryManager.DataHandoverRetryEntry) null);
                    } else {
                        if (evaluateDataNetworkHandover.containsAny(DataEvaluation.DataDisallowedReason.NOT_ALLOWED_BY_POLICY, DataEvaluation.DataDisallowedReason.NOT_IN_SERVICE, DataEvaluation.DataDisallowedReason.VOPS_NOT_SUPPORTED)) {
                            logl("onEvaluatePreferredTransport: Handover not allowed. Tear down " + next + " so a new network can be setup on " + AccessNetworkConstants.transportTypeToString(preferredTransportByNetworkCapability) + ".");
                            tearDownGracefully(next, 14);
                        } else {
                            if (evaluateDataNetworkHandover.containsAny(DataEvaluation.DataDisallowedReason.ILLEGAL_STATE, DataEvaluation.DataDisallowedReason.RETRY_SCHEDULED)) {
                                logl("onEvaluatePreferredTransport: Handover not allowed. " + next + " will remain on " + AccessNetworkConstants.transportTypeToString(next.getTransport()));
                            } else {
                                loge("onEvaluatePreferredTransport: Unexpected handover evaluation result.");
                            }
                        }
                    }
                }
            }
        }
    }

    private void updateSubscriptionPlans() {
        SubscriptionPlan[] subscriptionPlans = this.mNetworkPolicyManager.getSubscriptionPlans(this.mSubId, this.mPhone.getContext().getOpPackageName());
        this.mSubscriptionPlans.clear();
        this.mSubscriptionPlans.addAll(subscriptionPlans != null ? Arrays.asList(subscriptionPlans) : Collections.emptyList());
        this.mCongestedOverrideNetworkTypes.clear();
        this.mUnmeteredOverrideNetworkTypes.clear();
        log("Subscription plans initialized: " + this.mSubscriptionPlans);
    }

    /* access modifiers changed from: private */
    public void onLinkStatusChanged(DataNetwork dataNetwork, int i) {
        int i2 = this.mDataNetworkList.stream().anyMatch(new DataNetworkController$$ExternalSyntheticLambda23()) ? this.mDataNetworkList.stream().anyMatch(new DataNetworkController$$ExternalSyntheticLambda24()) ? 2 : 1 : 0;
        if (this.mInternetLinkStatus != i2) {
            log("Internet link status changed to " + DataUtils.linkStatusToString(i2));
            this.mInternetLinkStatus = i2;
            this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda25(this));
        }
        updateDataActivity();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onLinkStatusChanged$38(DataNetwork dataNetwork) {
        return dataNetwork.isInternetSupported() && dataNetwork.isConnected();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$onLinkStatusChanged$39(DataNetwork dataNetwork) {
        return dataNetwork.isInternetSupported() && dataNetwork.isConnected() && dataNetwork.getLinkStatus() == 2;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onLinkStatusChanged$41(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.invokeFromExecutor(new DataNetworkController$$ExternalSyntheticLambda3(this, dataNetworkControllerCallback));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onLinkStatusChanged$40(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.onPhysicalLinkStatusChanged(this.mInternetLinkStatus);
    }

    /* access modifiers changed from: private */
    public void onPcoDataChanged(DataNetwork dataNetwork) {
        int nrAdvancedCapablePcoId = this.mDataConfigManager.getNrAdvancedCapablePcoId();
        if (nrAdvancedCapablePcoId != 0) {
            boolean z = false;
            Iterator<DataNetwork> it = this.mDataNetworkList.iterator();
            while (true) {
                if (!it.hasNext()) {
                    break;
                }
                PcoData pcoData = it.next().getPcoData().get(Integer.valueOf(nrAdvancedCapablePcoId));
                if (pcoData != null) {
                    byte[] bArr = pcoData.contents;
                    if (bArr.length > 0 && bArr[bArr.length - 1] == 1) {
                        z = true;
                        break;
                    }
                }
            }
            if (z != this.mNrAdvancedCapableByPco) {
                log("onPcoDataChanged: mNrAdvancedCapableByPco = " + this.mNrAdvancedCapableByPco);
                this.mNrAdvancedCapableByPco = z;
                this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda28(this));
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onPcoDataChanged$43(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.invokeFromExecutor(new DataNetworkController$$ExternalSyntheticLambda27(this, dataNetworkControllerCallback));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onPcoDataChanged$42(DataNetworkControllerCallback dataNetworkControllerCallback) {
        dataNetworkControllerCallback.onNrAdvancedCapableByPcoChanged(this.mNrAdvancedCapableByPco);
    }

    /* access modifiers changed from: private */
    public void onNetworkCapabilitiesChanged(DataNetwork dataNetwork) {
        NetworkRequestList networkRequestList = new NetworkRequestList();
        Iterator it = this.mAllNetworkRequestList.iterator();
        while (it.hasNext()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) it.next();
            if (telephonyNetworkRequest.getState() == 0 && telephonyNetworkRequest.canBeSatisfiedBy(dataNetwork.getNetworkCapabilities())) {
                networkRequestList.add(telephonyNetworkRequest);
            }
        }
        if (!networkRequestList.isEmpty()) {
            log("Found more network requests that can be satisfied. " + networkRequestList);
            dataNetwork.attachNetworkRequests(networkRequestList);
        }
    }

    private boolean shouldReevaluateDataNetworks(NetworkRegistrationInfo networkRegistrationInfo, NetworkRegistrationInfo networkRegistrationInfo2) {
        if (networkRegistrationInfo == null || networkRegistrationInfo2 == null || networkRegistrationInfo2.getAccessNetworkTechnology() == 0) {
            return false;
        }
        if (networkRegistrationInfo.getAccessNetworkTechnology() != networkRegistrationInfo2.getAccessNetworkTechnology() || (!networkRegistrationInfo.isRoaming() && networkRegistrationInfo2.isRoaming())) {
            return true;
        }
        DataSpecificRegistrationInfo dataSpecificInfo = networkRegistrationInfo.getDataSpecificInfo();
        DataSpecificRegistrationInfo dataSpecificInfo2 = networkRegistrationInfo2.getDataSpecificInfo();
        if (dataSpecificInfo2 == null) {
            return false;
        }
        if ((dataSpecificInfo == null || dataSpecificInfo.getVopsSupportInfo() == null || dataSpecificInfo.getVopsSupportInfo().isVopsSupported()) && dataSpecificInfo2.getVopsSupportInfo() != null && !dataSpecificInfo2.getVopsSupportInfo().isVopsSupported()) {
            return true;
        }
        return false;
    }

    private boolean shouldReevaluateNetworkRequests(ServiceState serviceState, ServiceState serviceState2, int i) {
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, i);
        NetworkRegistrationInfo networkRegistrationInfo2 = serviceState2.getNetworkRegistrationInfo(2, i);
        if (networkRegistrationInfo2 == null || networkRegistrationInfo2.getAccessNetworkTechnology() == 0) {
            return false;
        }
        if (networkRegistrationInfo == null || networkRegistrationInfo.getAccessNetworkTechnology() != networkRegistrationInfo2.getAccessNetworkTechnology() || (!networkRegistrationInfo.isInService() && networkRegistrationInfo2.isInService())) {
            return true;
        }
        if (!serviceStateAllowsPSAttach(serviceState, i) && serviceStateAllowsPSAttach(serviceState2, i)) {
            return true;
        }
        DataSpecificRegistrationInfo dataSpecificInfo = networkRegistrationInfo.getDataSpecificInfo();
        DataSpecificRegistrationInfo dataSpecificInfo2 = networkRegistrationInfo2.getDataSpecificInfo();
        if (dataSpecificInfo == null) {
            return false;
        }
        if ((dataSpecificInfo2 == null || dataSpecificInfo2.getVopsSupportInfo() == null || dataSpecificInfo2.getVopsSupportInfo().isVopsSupported()) && dataSpecificInfo.getVopsSupportInfo() != null && !dataSpecificInfo.getVopsSupportInfo().isVopsSupported()) {
            return true;
        }
        return false;
    }

    private void onServiceStateChanged() {
        boolean z;
        ServiceState serviceState = this.mPhone.getServiceStateTracker().getServiceState();
        StringBuilder sb = new StringBuilder("onServiceStateChanged: ");
        int i = 0;
        if (!this.mServiceState.equals(serviceState)) {
            log("onServiceStateChanged: changed to " + serviceState);
            int[] availableTransports = this.mAccessNetworksManager.getAvailableTransports();
            int length = availableTransports.length;
            int i2 = 0;
            z = false;
            while (i < length) {
                int i3 = availableTransports[i];
                NetworkRegistrationInfo networkRegistrationInfo = this.mServiceState.getNetworkRegistrationInfo(2, i3);
                NetworkRegistrationInfo networkRegistrationInfo2 = serviceState.getNetworkRegistrationInfo(2, i3);
                sb.append("[");
                sb.append(AccessNetworkConstants.transportTypeToString(i3));
                sb.append(": ");
                String str = null;
                sb.append(networkRegistrationInfo != null ? TelephonyManager.getNetworkTypeName(networkRegistrationInfo.getAccessNetworkTechnology()) : null);
                sb.append("->");
                sb.append(networkRegistrationInfo2 != null ? TelephonyManager.getNetworkTypeName(networkRegistrationInfo2.getAccessNetworkTechnology()) : null);
                sb.append(", ");
                sb.append(networkRegistrationInfo != null ? NetworkRegistrationInfo.registrationStateToString(networkRegistrationInfo.getRegistrationState()) : null);
                sb.append("->");
                if (networkRegistrationInfo2 != null) {
                    str = NetworkRegistrationInfo.registrationStateToString(networkRegistrationInfo2.getRegistrationState());
                }
                sb.append(str);
                sb.append("] ");
                if (shouldReevaluateDataNetworks(networkRegistrationInfo, networkRegistrationInfo2) && !hasMessages(16)) {
                    sendMessage(obtainMessage(16, DataEvaluation.DataEvaluationReason.DATA_SERVICE_STATE_CHANGED));
                    z = true;
                }
                if (shouldReevaluateNetworkRequests(this.mServiceState, serviceState, i3) && !hasMessages(5)) {
                    sendMessage(obtainMessage(5, DataEvaluation.DataEvaluationReason.DATA_SERVICE_STATE_CHANGED));
                    i2 = 1;
                }
                i++;
            }
            this.mServiceState = serviceState;
            i = i2;
        } else {
            sb.append("not changed");
            z = false;
        }
        sb.append(". Evaluating network requests is ");
        String str2 = "";
        sb.append(i != 0 ? str2 : "not ");
        sb.append("needed, evaluating existing data networks is ");
        if (!z) {
            str2 = "not ";
        }
        sb.append(str2);
        sb.append("needed.");
        log(sb.toString());
    }

    private void updateOverallInternetDataState() {
        int i;
        boolean anyMatch = this.mDataNetworkList.stream().anyMatch(new DataNetworkController$$ExternalSyntheticLambda40());
        List list = (List) this.mDataNetworkList.stream().filter(new DataNetworkController$$ExternalSyntheticLambda17()).filter(new DataNetworkController$$ExternalSyntheticLambda41()).collect(Collectors.toList());
        int i2 = 0;
        boolean z = !list.isEmpty() && list.stream().allMatch(new DataNetworkController$$ExternalSyntheticLambda42());
        logv("isSuspended=" + z + ", anyInternetConnected=" + anyMatch + ", mDataNetworkList=" + this.mDataNetworkList);
        if (z) {
            i2 = 3;
        } else if (anyMatch) {
            i2 = 2;
        }
        if (this.mInternetDataNetworkState != i2) {
            logl("Internet data state changed from " + TelephonyUtils.dataStateToString(this.mInternetDataNetworkState) + " to " + TelephonyUtils.dataStateToString(i2) + ".");
            if (i2 == 2 && this.mInternetDataNetworkState == 0) {
                this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda43(list));
            } else if (i2 == 0 && ((i = this.mInternetDataNetworkState) == 2 || i == 3)) {
                this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda44());
            }
            this.mInternetDataNetworkState = i2;
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$updateOverallInternetDataState$44(DataNetwork dataNetwork) {
        return dataNetwork.isInternetSupported() && (dataNetwork.isConnected() || dataNetwork.isHandoverInProgress());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$updateOverallInternetDataState$45(DataNetwork dataNetwork) {
        return dataNetwork.isConnected() || dataNetwork.isHandoverInProgress();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ void lambda$updateOverallInternetDataState$48(DataNetworkControllerCallback dataNetworkControllerCallback) {
        Objects.requireNonNull(dataNetworkControllerCallback);
        dataNetworkControllerCallback.invokeFromExecutor(new DataNetworkController$$ExternalSyntheticLambda47(dataNetworkControllerCallback));
    }

    public DataConfigManager getDataConfigManager() {
        return this.mDataConfigManager;
    }

    public DataProfileManager getDataProfileManager() {
        return this.mDataProfileManager;
    }

    public DataSettingsManager getDataSettingsManager() {
        return this.mDataSettingsManager;
    }

    public DataRetryManager getDataRetryManager() {
        return this.mDataRetryManager;
    }

    @VisibleForTesting
    public List<SubscriptionPlan> getSubscriptionPlans() {
        return this.mSubscriptionPlans;
    }

    @VisibleForTesting
    public Set<Integer> getUnmeteredOverrideNetworkTypes() {
        return this.mUnmeteredOverrideNetworkTypes;
    }

    @VisibleForTesting
    public Set<Integer> getCongestedOverrideNetworkTypes() {
        return this.mCongestedOverrideNetworkTypes;
    }

    /* access modifiers changed from: protected */
    public int getDataNetworkType(int i) {
        NetworkRegistrationInfo networkRegistrationInfo = this.mServiceState.getNetworkRegistrationInfo(2, i);
        if (networkRegistrationInfo != null) {
            return networkRegistrationInfo.getAccessNetworkTechnology();
        }
        return 0;
    }

    /* access modifiers changed from: protected */
    public int getDataRegistrationState(ServiceState serviceState, int i) {
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, i);
        if (networkRegistrationInfo != null) {
            return networkRegistrationInfo.getRegistrationState();
        }
        return 4;
    }

    public int getDataActivity() {
        return this.mDataActivity;
    }

    public void registerDataNetworkControllerCallback(DataNetworkControllerCallback dataNetworkControllerCallback) {
        sendMessage(obtainMessage(13, dataNetworkControllerCallback));
    }

    public void unregisterDataNetworkControllerCallback(DataNetworkControllerCallback dataNetworkControllerCallback) {
        sendMessage(obtainMessage(14, dataNetworkControllerCallback));
    }

    public void tearDownAllDataNetworks(@DataNetwork.TearDownReason int i) {
        sendMessage(obtainMessage(12, i, 0));
    }

    public void onTearDownAllDataNetworks(@DataNetwork.TearDownReason int i) {
        log("onTearDownAllDataNetworks: reason=" + DataNetwork.tearDownReasonToString(i));
        if (this.mDataNetworkList.isEmpty()) {
            log("tearDownAllDataNetworks: No pending networks. All disconnected now.");
            return;
        }
        this.mPendingTearDownAllNetworks = true;
        for (DataNetwork next : this.mDataNetworkList) {
            if (isMtkImsDataSupport() && i == 3 && next.getNetworkCapabilities().hasCapability(4)) {
                log("onTearDownAllDataNetworks: ignore ims reason=" + DataNetwork.tearDownReasonToString(i));
                if (this.mDataNetworkList.size() == 1) {
                    log("all data disconnect except ims, power off radio immediately");
                    this.mPendingTearDownAllNetworks = false;
                    this.mDataNetworkControllerCallbacks.forEach(new DataNetworkController$$ExternalSyntheticLambda53());
                }
            } else if (!next.isDisconnecting()) {
                tearDownGracefully(next, i);
            }
        }
    }

    /* access modifiers changed from: private */
    public void evaluatePendingImsDeregDataNetworks() {
        Iterator<Map.Entry<DataNetwork, Runnable>> it = this.mPendingImsDeregDataNetworks.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry next = it.next();
            if (isSafeToTearDown((DataNetwork) next.getKey())) {
                log("evaluatePendingImsDeregDataNetworks: Safe to tear down data network " + next.getKey() + " now.");
                ((Runnable) next.getValue()).run();
                it.remove();
            } else {
                log("Still not safe to tear down " + next.getKey() + ".");
            }
        }
    }

    private boolean isSafeToTearDown(DataNetwork dataNetwork) {
        for (Integer intValue : SUPPORTED_IMS_FEATURES) {
            int intValue2 = intValue.intValue();
            String str = this.mImsFeaturePackageName.get(intValue2);
            if (str != null && dataNetwork.getAttachedNetworkRequestList().hasNetworkRequestsFromPackage(str) && this.mRegisteredImsFeatures.contains(Integer.valueOf(intValue2))) {
                return false;
            }
        }
        return true;
    }

    private boolean isImsGracefulTearDownSupported() {
        return this.mDataConfigManager.getImsDeregistrationDelay() > 0;
    }

    /* access modifiers changed from: private */
    public void tearDownGracefully(DataNetwork dataNetwork, @DataNetwork.TearDownReason int i) {
        long imsDeregistrationDelay = this.mDataConfigManager.getImsDeregistrationDelay();
        if (!isImsGracefulTearDownSupported() || isSafeToTearDown(dataNetwork)) {
            log("tearDownGracefully: Safe to tear down " + dataNetwork);
            dataNetwork.lambda$tearDownWhenConditionMet$7(i);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("tearDownGracefully: Not safe to tear down ");
        sb.append(dataNetwork);
        sb.append(" at this point. Wait for IMS de-registration or timeout. MMTEL=");
        String str = "registered";
        sb.append(this.mRegisteredImsFeatures.contains(1) ? str : "not registered");
        sb.append(", RCS=");
        if (!this.mRegisteredImsFeatures.contains(2)) {
            str = "not registered";
        }
        sb.append(str);
        log(sb.toString());
        Runnable tearDownWhenConditionMet = dataNetwork.tearDownWhenConditionMet(i, imsDeregistrationDelay);
        if (tearDownWhenConditionMet != null) {
            this.mPendingImsDeregDataNetworks.put(dataNetwork, tearDownWhenConditionMet);
            return;
        }
        log(dataNetwork + " is being torn down already.");
    }

    public int getInternetDataNetworkState() {
        return this.mInternetDataNetworkState;
    }

    public List<String> getDataServicePackages() {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < this.mDataServiceManagers.size(); i++) {
            arrayList.add(this.mDataServiceManagers.valueAt(i).getDataServicePackageName());
        }
        return arrayList;
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    /* access modifiers changed from: protected */
    public void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(DataNetworkController.class.getSimpleName() + "-" + this.mPhone.getPhoneId() + ":");
        androidUtilIndentingPrintWriter.increaseIndent();
        androidUtilIndentingPrintWriter.println("Current data networks:");
        androidUtilIndentingPrintWriter.increaseIndent();
        for (DataNetwork dump : this.mDataNetworkList) {
            dump.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Pending tear down data networks:");
        androidUtilIndentingPrintWriter.increaseIndent();
        for (DataNetwork dump2 : this.mPendingImsDeregDataNetworks.keySet()) {
            dump2.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Previously connected data networks: (up to 10)");
        androidUtilIndentingPrintWriter.increaseIndent();
        for (DataNetwork next : this.mPreviousConnectedDataNetworkList) {
            if (!this.mDataNetworkList.contains(next)) {
                next.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
            }
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("All telephony network requests:");
        androidUtilIndentingPrintWriter.increaseIndent();
        Iterator it = this.mAllNetworkRequestList.iterator();
        while (it.hasNext()) {
            androidUtilIndentingPrintWriter.println((TelephonyNetworkRequest) it.next());
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        StringBuilder sb = new StringBuilder();
        sb.append("IMS features registration state: MMTEL=");
        String str = "registered";
        sb.append(this.mRegisteredImsFeatures.contains(1) ? str : "not registered");
        sb.append(", RCS=");
        if (!this.mRegisteredImsFeatures.contains(2)) {
            str = "not registered";
        }
        sb.append(str);
        androidUtilIndentingPrintWriter.println(sb.toString());
        androidUtilIndentingPrintWriter.println("mServiceState=" + this.mServiceState);
        androidUtilIndentingPrintWriter.println("mPsRestricted=" + this.mPsRestricted);
        androidUtilIndentingPrintWriter.println("mAnyDataNetworkExisting=" + this.mAnyDataNetworkExisting);
        androidUtilIndentingPrintWriter.println("mInternetDataNetworkState=" + TelephonyUtils.dataStateToString(this.mInternetDataNetworkState));
        androidUtilIndentingPrintWriter.println("mImsDataNetworkState=" + TelephonyUtils.dataStateToString(this.mImsDataNetworkState));
        androidUtilIndentingPrintWriter.println("mDataServiceBound=" + this.mDataServiceBound);
        androidUtilIndentingPrintWriter.println("mSimState=" + SubscriptionInfoUpdater.simStateString(this.mSimState));
        androidUtilIndentingPrintWriter.println("mDataNetworkControllerCallbacks=" + this.mDataNetworkControllerCallbacks);
        androidUtilIndentingPrintWriter.println("Subscription plans:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mSubscriptionPlans.forEach(new DataNetworkController$$ExternalSyntheticLambda59(androidUtilIndentingPrintWriter));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Unmetered override network types=" + ((String) this.mUnmeteredOverrideNetworkTypes.stream().map(new DataConfigManager$$ExternalSyntheticLambda7()).collect(Collectors.joining(","))));
        androidUtilIndentingPrintWriter.println("Congested override network types=" + ((String) this.mCongestedOverrideNetworkTypes.stream().map(new DataConfigManager$$ExternalSyntheticLambda7()).collect(Collectors.joining(","))));
        androidUtilIndentingPrintWriter.println("mImsThrottleCounter=" + this.mImsThrottleCounter);
        androidUtilIndentingPrintWriter.println("mNetworkUnwantedCounter=" + this.mNetworkUnwantedCounter);
        androidUtilIndentingPrintWriter.println("Local logs:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("-------------------------------------");
        this.mDataProfileManager.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.println("-------------------------------------");
        this.mDataRetryManager.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.println("-------------------------------------");
        this.mDataSettingsManager.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.println("-------------------------------------");
        this.mDataStallRecoveryManager.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.println("-------------------------------------");
        this.mDataConfigManager.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
    }

    private boolean isMtkImsDataSupport() {
        return "0".equals(SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0")) || "1".equals(SystemProperties.get("ro.mtk.ims.data.feature_support"));
    }
}
