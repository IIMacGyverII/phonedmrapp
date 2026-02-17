package com.android.internal.telephony.dataconnection;

import android.net.NetworkRequest;
import android.os.Message;
import android.telephony.data.ApnSetting;
import android.text.TextUtils;
import android.util.ArraySet;
import android.util.SparseIntArray;
import com.android.internal.telephony.DctConstants;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.RetryManager;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

public class ApnContext {
    protected static final boolean DBG = false;
    private static final String SLOG_TAG = "ApnContext";
    private static final LocalLog sLocalLog = new LocalLog(256);
    public final String LOG_TAG;
    private ApnSetting mApnSetting;
    private final String mApnType;
    private boolean mConcurrentVoiceAndDataAllowed;
    private final AtomicInteger mConnectionGeneration;
    private DataConnection mDataConnection;
    AtomicBoolean mDataEnabled;
    private final DcTracker mDcTracker;
    private final ArraySet<NetworkRequest> mNetworkRequests;
    private final Phone mPhone;
    private int mPriority;
    private String mReason;
    private final Object mRefCountLock;
    private final SparseIntArray mRetriesLeftPerErrorCode;
    private final RetryManager mRetryManager;
    private DctConstants.State mState;
    private final LocalLog mStateLocalLog;

    private void log(String str) {
    }

    public boolean isDependencyMet() {
        return true;
    }

    public ApnContext(Phone phone, int i, String str, DcTracker dcTracker, int i2) {
        this(phone, ApnSetting.getApnTypeString(i), str, dcTracker, i2);
    }

    public ApnContext(Phone phone, String str, String str2, DcTracker dcTracker, int i) {
        this.mRefCountLock = new Object();
        this.mConnectionGeneration = new AtomicInteger(0);
        this.mNetworkRequests = new ArraySet<>();
        this.mStateLocalLog = new LocalLog(32);
        this.mRetriesLeftPerErrorCode = new SparseIntArray();
        this.mPhone = phone;
        this.mApnType = str;
        this.mState = DctConstants.State.IDLE;
        setReason(PhoneInternalInterface.REASON_DATA_ENABLED);
        this.mDataEnabled = new AtomicBoolean(false);
        this.mPriority = i;
        this.LOG_TAG = str2;
        this.mDcTracker = dcTracker;
        this.mRetryManager = new RetryManager(phone, dcTracker.getDataThrottler(), ApnSetting.getApnTypesBitmaskFromString(str));
    }

    public String getApnType() {
        return this.mApnType;
    }

    public int getApnTypeBitmask() {
        return ApnSetting.getApnTypesBitmaskFromString(this.mApnType);
    }

    public synchronized DataConnection getDataConnection() {
        return this.mDataConnection;
    }

    public int getPriority() {
        return this.mPriority;
    }

    public void setPriority(int i) {
        this.mPriority = i;
    }

    public synchronized void setDataConnection(DataConnection dataConnection) {
        log("setDataConnectionAc: old=" + this.mDataConnection + ",new=" + dataConnection + " this=" + this);
        this.mDataConnection = dataConnection;
    }

    public synchronized void releaseDataConnection(String str) {
        DataConnection dataConnection = this.mDataConnection;
        if (dataConnection != null) {
            dataConnection.tearDown(this, str, (Message) null);
            this.mDataConnection = null;
        }
        setState(DctConstants.State.IDLE);
    }

    public synchronized ApnSetting getApnSetting() {
        log("getApnSetting: apnSetting=" + this.mApnSetting);
        return this.mApnSetting;
    }

    public synchronized void setApnSetting(ApnSetting apnSetting) {
        log("setApnSetting: apnSetting=" + apnSetting);
        this.mApnSetting = apnSetting;
    }

    public synchronized void setWaitingApns(ArrayList<ApnSetting> arrayList) {
        this.mRetryManager.setWaitingApns(arrayList);
    }

    public ApnSetting getNextApnSetting() {
        return this.mRetryManager.getNextApnSetting();
    }

    public long getDelayForNextApn(boolean z) {
        return this.mRetryManager.getDelayForNextApn(z || isFastRetryReason());
    }

    public void markApnPermanentFailed(ApnSetting apnSetting) {
        this.mRetryManager.markApnPermanentFailed(apnSetting);
    }

    public ArrayList<ApnSetting> getWaitingApns() {
        return this.mRetryManager.getWaitingApns();
    }

    public synchronized void setConcurrentVoiceAndDataAllowed(boolean z) {
        this.mConcurrentVoiceAndDataAllowed = z;
    }

    public synchronized boolean isConcurrentVoiceAndDataAllowed() {
        return this.mConcurrentVoiceAndDataAllowed;
    }

    public synchronized void setState(DctConstants.State state) {
        log("setState: " + state + ", previous state:" + this.mState);
        if (this.mState != state) {
            LocalLog localLog = this.mStateLocalLog;
            localLog.log("State changed from " + this.mState + " to " + state);
            this.mState = state;
        }
        if (this.mState == DctConstants.State.FAILED) {
            this.mRetryManager.getWaitingApns().clear();
        }
    }

    public synchronized DctConstants.State getState() {
        return this.mState;
    }

    public boolean isDisconnected() {
        DctConstants.State state = getState();
        return state == DctConstants.State.IDLE || state == DctConstants.State.FAILED;
    }

    public synchronized void setReason(String str) {
        log("set reason as " + str + ",current state " + this.mState);
        this.mReason = str;
    }

    public synchronized String getReason() {
        return this.mReason;
    }

    public boolean isReady() {
        return this.mDataEnabled.get() && isDependencyMet();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
        r1 = r1.mState;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean isConnectable() {
        /*
            r1 = this;
            boolean r0 = r1.isReady()
            if (r0 == 0) goto L_0x0016
            com.android.internal.telephony.DctConstants$State r1 = r1.mState
            com.android.internal.telephony.DctConstants$State r0 = com.android.internal.telephony.DctConstants.State.IDLE
            if (r1 == r0) goto L_0x0014
            com.android.internal.telephony.DctConstants$State r0 = com.android.internal.telephony.DctConstants.State.RETRYING
            if (r1 == r0) goto L_0x0014
            com.android.internal.telephony.DctConstants$State r0 = com.android.internal.telephony.DctConstants.State.FAILED
            if (r1 != r0) goto L_0x0016
        L_0x0014:
            r1 = 1
            goto L_0x0017
        L_0x0016:
            r1 = 0
        L_0x0017:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.ApnContext.isConnectable():boolean");
    }

    private boolean isFastRetryReason() {
        return PhoneInternalInterface.REASON_NW_TYPE_CHANGED.equals(this.mReason) || PhoneInternalInterface.REASON_APN_CHANGED.equals(this.mReason);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
        r1 = r1.mState;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean isConnectedOrConnecting() {
        /*
            r1 = this;
            boolean r0 = r1.isReady()
            if (r0 == 0) goto L_0x0016
            com.android.internal.telephony.DctConstants$State r1 = r1.mState
            com.android.internal.telephony.DctConstants$State r0 = com.android.internal.telephony.DctConstants.State.CONNECTED
            if (r1 == r0) goto L_0x0014
            com.android.internal.telephony.DctConstants$State r0 = com.android.internal.telephony.DctConstants.State.CONNECTING
            if (r1 == r0) goto L_0x0014
            com.android.internal.telephony.DctConstants$State r0 = com.android.internal.telephony.DctConstants.State.RETRYING
            if (r1 != r0) goto L_0x0016
        L_0x0014:
            r1 = 1
            goto L_0x0017
        L_0x0016:
            r1 = 0
        L_0x0017:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.ApnContext.isConnectedOrConnecting():boolean");
    }

    public void setEnabled(boolean z) {
        log("set enabled as " + z + ", current state is " + this.mDataEnabled.get());
        this.mDataEnabled.set(z);
    }

    public boolean isEnabled() {
        return this.mDataEnabled.get();
    }

    public boolean isProvisioningApn() {
        ApnSetting apnSetting;
        String string = this.mPhone.getContext().getResources().getString(17040839);
        if (TextUtils.isEmpty(string) || (apnSetting = this.mApnSetting) == null || apnSetting.getApnName() == null) {
            return false;
        }
        return this.mApnSetting.getApnName().equals(string);
    }

    public static void requestLog(ApnContext apnContext, String str) {
        if (apnContext != null) {
            String str2 = "[ApnContext:" + apnContext.getApnType() + "] " + str;
            LocalLog localLog = sLocalLog;
            synchronized (localLog) {
                localLog.log(str2);
            }
        }
    }

    public void requestNetwork(NetworkRequest networkRequest, int i, Message message) {
        synchronized (this.mRefCountLock) {
            this.mNetworkRequests.add(networkRequest);
            requestLog(this, "requestNetwork for " + networkRequest + ", type=" + DcTracker.requestTypeToString(i));
            this.mDcTracker.enableApn(ApnSetting.getApnTypesBitmaskFromString(this.mApnType), i, message);
            DataConnection dataConnection = this.mDataConnection;
            if (dataConnection != null) {
                dataConnection.reevaluateDataConnectionProperties();
            }
        }
    }

    public void releaseNetwork(NetworkRequest networkRequest, int i) {
        synchronized (this.mRefCountLock) {
            if (this.mNetworkRequests.contains(networkRequest)) {
                this.mNetworkRequests.remove(networkRequest);
                DataConnection dataConnection = this.mDataConnection;
                if (dataConnection != null) {
                    dataConnection.reevaluateDataConnectionProperties();
                }
                requestLog(this, "releaseNetwork left with " + this.mNetworkRequests.size() + " requests.");
                if (this.mNetworkRequests.size() == 0 || i == 2 || i == 3) {
                    this.mDcTracker.disableApn(ApnSetting.getApnTypesBitmaskFromString(this.mApnType), i);
                }
            }
        }
    }

    public boolean hasRestrictedRequests(boolean z) {
        synchronized (this.mRefCountLock) {
            Iterator<NetworkRequest> it = this.mNetworkRequests.iterator();
            while (it.hasNext()) {
                NetworkRequest next = it.next();
                if (!z || !next.hasCapability(2)) {
                    if (!next.hasCapability(13)) {
                        return true;
                    }
                }
            }
            return false;
        }
    }

    public void resetErrorCodeRetries() {
        requestLog(this, "resetErrorCodeRetries");
        String[] stringArray = this.mPhone.getContext().getResources().getStringArray(17236018);
        synchronized (this.mRetriesLeftPerErrorCode) {
            this.mRetriesLeftPerErrorCode.clear();
            for (String str : stringArray) {
                String[] split = str.split(",");
                if (split == null || split.length != 2) {
                    log("Exception parsing config_retries_per_error_code: " + str);
                } else {
                    try {
                        int parseInt = Integer.parseInt(split[0]);
                        int parseInt2 = Integer.parseInt(split[1]);
                        if (parseInt2 > 0 && parseInt > 0) {
                            this.mRetriesLeftPerErrorCode.put(parseInt, parseInt2);
                        }
                    } catch (NumberFormatException e) {
                        log("Exception parsing config_retries_per_error_code: " + e);
                    }
                }
            }
        }
    }

    public boolean restartOnError(int i) {
        int i2;
        boolean z;
        synchronized (this.mRetriesLeftPerErrorCode) {
            i2 = this.mRetriesLeftPerErrorCode.get(i);
            z = false;
            if (i2 != 0) {
                if (i2 != 1) {
                    this.mRetriesLeftPerErrorCode.put(i, i2 - 1);
                } else {
                    resetErrorCodeRetries();
                    z = true;
                }
            }
        }
        requestLog(this, "restartOnError(" + i + ") found " + i2 + " and returned " + z);
        return z;
    }

    public int incAndGetConnectionGeneration() {
        return this.mConnectionGeneration.incrementAndGet();
    }

    public int getConnectionGeneration() {
        return this.mConnectionGeneration.get();
    }

    /* access modifiers changed from: package-private */
    public long getRetryAfterDisconnectDelay() {
        return this.mRetryManager.getRetryAfterDisconnectDelay();
    }

    public static int getApnTypeFromNetworkRequest(NetworkRequest networkRequest) {
        boolean z = false;
        if (networkRequest.getTransportTypes().length > 0 && !networkRequest.hasTransport(0)) {
            return 0;
        }
        int i = networkRequest.hasCapability(12) ? 17 : 0;
        boolean z2 = true;
        if (networkRequest.hasCapability(0)) {
            if (i != 0) {
                z = true;
            }
            i = 2;
        }
        if (networkRequest.hasCapability(1)) {
            if (i != 0) {
                z = true;
            }
            i = 4;
        }
        if (networkRequest.hasCapability(2)) {
            if (i != 0) {
                z = true;
            }
            i = 8;
        }
        if (networkRequest.hasCapability(3)) {
            if (i != 0) {
                z = true;
            }
            i = 32;
        }
        if (networkRequest.hasCapability(4)) {
            if (i != 0) {
                z = true;
            }
            i = 64;
        }
        if (networkRequest.hasCapability(5)) {
            if (i != 0) {
                z = true;
            }
            i = 128;
        }
        if (networkRequest.hasCapability(7)) {
            if (i != 0) {
                z = true;
            }
            i = 256;
        }
        if (networkRequest.hasCapability(10)) {
            if (i != 0) {
                z = true;
            }
            i = 512;
        }
        if (networkRequest.hasCapability(23)) {
            if (i != 0) {
                z = true;
            }
            i = 1024;
        }
        if (networkRequest.hasCapability(9)) {
            if (i != 0) {
                z = true;
            }
            i = 2048;
        }
        if (networkRequest.hasCapability(29)) {
            if (i == 0) {
                z2 = z;
            }
            i = 16384;
            z = z2;
        }
        if (z) {
            Rlog.d(SLOG_TAG, "Multiple apn types specified in request - result is unspecified!");
        }
        if (i == 0) {
            Rlog.d(SLOG_TAG, "Unsupported NetworkRequest in Telephony: nr=" + networkRequest);
        }
        return i;
    }

    public List<NetworkRequest> getNetworkRequests() {
        ArrayList arrayList;
        synchronized (this.mRefCountLock) {
            arrayList = new ArrayList(this.mNetworkRequests);
        }
        return arrayList;
    }

    public synchronized String toString() {
        return "{mApnType=" + this.mApnType + " mState=" + getState() + " mWaitingApns={" + this.mRetryManager.getWaitingApns() + " priority=" + this.mPriority + "} mApnSetting={" + this.mApnSetting + "} mReason=" + this.mReason + " mDataEnabled=" + this.mDataEnabled + "}";
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        synchronized (this.mRefCountLock) {
            indentingPrintWriter.println(toString());
            if (this.mNetworkRequests.size() > 0) {
                indentingPrintWriter.println("NetworkRequests:");
                indentingPrintWriter.increaseIndent();
                Iterator<NetworkRequest> it = this.mNetworkRequests.iterator();
                while (it.hasNext()) {
                    indentingPrintWriter.println(it.next());
                }
                indentingPrintWriter.decreaseIndent();
            }
            indentingPrintWriter.println("Historical APN state:");
            indentingPrintWriter.increaseIndent();
            this.mStateLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
            indentingPrintWriter.decreaseIndent();
            indentingPrintWriter.println(this.mRetryManager);
            indentingPrintWriter.println("--------------------------");
        }
    }

    public static void dumpLocalLog(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("Local log:");
        LocalLog localLog = sLocalLog;
        synchronized (localLog) {
            localLog.dump(fileDescriptor, printWriter, strArr);
        }
    }
}
