package com.android.internal.telephony.dataconnection;

import android.net.LinkProperties;
import android.net.NetworkAgent;
import android.net.NetworkAgentConfig;
import android.net.NetworkCapabilities;
import android.net.NetworkProvider;
import android.net.QosFilter;
import android.net.QosSessionAttributes;
import android.os.Handler;
import android.os.Message;
import android.telephony.AccessNetworkConstants;
import android.telephony.AnomalyReporter;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.TelephonyManager;
import android.telephony.data.QosBearerSession;
import android.util.SparseArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.SlidingWindowEventCounter;
import com.android.internal.telephony.data.KeepaliveStatus;
import com.android.internal.telephony.data.NotifyQosSessionInterface;
import com.android.internal.telephony.data.QosCallbackTracker;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class DcNetworkAgent extends NetworkAgent implements NotifyQosSessionInterface {
    private static final int EVENT_UNWANTED_TIMEOUT = 1;
    private static final int NETWORK_UNWANTED_ANOMALY_NUM_OCCURRENCES = 12;
    private static final long NETWORK_UNWANTED_ANOMALY_WINDOW_MS;
    /* access modifiers changed from: private */
    public static Map<Integer, String> sInterfaceNames = new ConcurrentHashMap();
    private static final SlidingWindowEventCounter sNetworkUnwantedCounter;
    public final DcKeepaliveTracker keepaliveTracker = new DcKeepaliveTracker();
    private DataConnection mDataConnection;
    private final Handler mHandler;
    /* access modifiers changed from: private */
    public final int mId;
    private final LocalLog mNetCapsLocalLog = new LocalLog(32);
    private NetworkCapabilities mNetworkCapabilities;
    private final Phone mPhone;
    private final Executor mQosCallbackExecutor = Executors.newSingleThreadExecutor();
    private final QosCallbackTracker mQosCallbackTracker;
    private final String mTag;
    private int mTransportType;

    static {
        long millis = TimeUnit.MINUTES.toMillis(5);
        NETWORK_UNWANTED_ANOMALY_WINDOW_MS = millis;
        sNetworkUnwantedCounter = new SlidingWindowEventCounter(millis, 12);
    }

    @VisibleForTesting
    public DcNetworkAgent(DataConnection dataConnection, Phone phone, int i, NetworkAgentConfig networkAgentConfig, NetworkProvider networkProvider, int i2) {
        super(phone.getContext(), dataConnection.getHandler().getLooper(), "DcNetworkAgent", dataConnection.getNetworkCapabilities(), dataConnection.getLinkProperties(), i, networkAgentConfig, networkProvider);
        register();
        int netId = getNetwork().getNetId();
        this.mId = netId;
        this.mTag = "DcNetworkAgent-" + netId;
        this.mPhone = phone;
        this.mHandler = new Handler(dataConnection.getHandler().getLooper()) {
            public void handleMessage(Message message) {
                if (message.what == 1) {
                    DcNetworkAgent.this.loge("onNetworkUnwanted timed out. Perform silent de-register.");
                    DcNetworkAgent dcNetworkAgent = DcNetworkAgent.this;
                    dcNetworkAgent.logd("Unregister from connectivity service. " + ((String) DcNetworkAgent.sInterfaceNames.get(Integer.valueOf(DcNetworkAgent.this.mId))) + " removed.");
                    DcNetworkAgent.sInterfaceNames.remove(Integer.valueOf(DcNetworkAgent.this.mId));
                    DcNetworkAgent.this.unregister();
                }
            }
        };
        this.mNetworkCapabilities = dataConnection.getNetworkCapabilities();
        this.mTransportType = i2;
        this.mDataConnection = dataConnection;
        if (dataConnection.getLinkProperties() != null) {
            checkDuplicateInterface(netId, dataConnection.getLinkProperties().getInterfaceName());
            logd("created for data connection " + dataConnection.getName() + ", " + dataConnection.getLinkProperties().getInterfaceName());
        } else {
            loge("The connection does not have a valid link properties.");
        }
        this.mQosCallbackTracker = new QosCallbackTracker(this, phone);
    }

    private int getNetworkType() {
        NetworkRegistrationInfo networkRegistrationInfo = this.mPhone.getServiceState().getNetworkRegistrationInfo(2, this.mTransportType);
        if (networkRegistrationInfo != null) {
            return networkRegistrationInfo.getAccessNetworkTechnology();
        }
        return 0;
    }

    private void checkDuplicateInterface(int i, String str) {
        for (Map.Entry next : sInterfaceNames.entrySet()) {
            if (Objects.equals(str, next.getValue())) {
                String str2 = "Duplicate interface " + str + " is detected. DcNetworkAgent-" + next.getKey() + " already used this interface name.";
                loge(str2);
                AnomalyReporter.reportAnomaly(UUID.fromString("02f3d3f6-4613-4415-b6cb-8d92c8a938a6"), str2, this.mPhone.getCarrierId());
                return;
            }
        }
        sInterfaceNames.put(Integer.valueOf(i), str);
    }

    /* access modifiers changed from: package-private */
    public String getTag() {
        return this.mTag;
    }

    public synchronized void acquireOwnership(DataConnection dataConnection, int i) {
        this.mDataConnection = dataConnection;
        this.mTransportType = i;
        logd(dataConnection.getName() + " acquired the ownership of this agent.");
    }

    public synchronized void releaseOwnership(DataConnection dataConnection) {
        DataConnection dataConnection2 = this.mDataConnection;
        if (dataConnection2 == null) {
            loge("releaseOwnership called on no-owner DcNetworkAgent!");
        } else if (dataConnection2 != dataConnection) {
            loge("releaseOwnership: This agent belongs to " + this.mDataConnection.getName() + ", ignored the request from " + dataConnection.getName());
        } else {
            logd("Data connection " + this.mDataConnection.getName() + " released the ownership.");
            this.mDataConnection = null;
        }
    }

    public synchronized DataConnection getDataConnection() {
        return this.mDataConnection;
    }

    public synchronized void onNetworkUnwanted() {
        this.mHandler.sendEmptyMessageDelayed(1, TimeUnit.SECONDS.toMillis(30));
        trackNetworkUnwanted();
        if (this.mDataConnection == null) {
            loge("onNetworkUnwanted found called on no-owner DcNetworkAgent!");
            return;
        }
        logd("onNetworkUnwanted called. Now tear down the data connection " + this.mDataConnection.getName());
        this.mDataConnection.tearDownAll(PhoneInternalInterface.REASON_RELEASED_BY_CONNECTIVITY_SERVICE, 2, (Message) null);
    }

    private void trackNetworkUnwanted() {
        if (sNetworkUnwantedCounter.addOccurrence()) {
            AnomalyReporter.reportAnomaly(UUID.fromString("3f578b5c-64e9-11eb-ae93-0242ac130002"), "Network Unwanted called 12 times in 5 minutes.", this.mPhone.getCarrierId());
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:14:0x002a, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onBandwidthUpdateRequested() {
        /*
            r3 = this;
            monitor-enter(r3)
            com.android.internal.telephony.dataconnection.DataConnection r0 = r3.mDataConnection     // Catch:{ all -> 0x002b }
            if (r0 != 0) goto L_0x000c
            java.lang.String r0 = "onBandwidthUpdateRequested called on no-owner DcNetworkAgent!"
            r3.loge(r0)     // Catch:{ all -> 0x002b }
            monitor-exit(r3)
            return
        L_0x000c:
            com.android.internal.telephony.Phone r0 = r3.mPhone     // Catch:{ all -> 0x002b }
            int r0 = r0.getLceStatus()     // Catch:{ all -> 0x002b }
            r1 = 1
            if (r0 != r1) goto L_0x0029
            int r0 = r3.mTransportType     // Catch:{ all -> 0x002b }
            if (r0 != r1) goto L_0x0029
            com.android.internal.telephony.Phone r0 = r3.mPhone     // Catch:{ all -> 0x002b }
            com.android.internal.telephony.CommandsInterface r0 = r0.mCi     // Catch:{ all -> 0x002b }
            com.android.internal.telephony.dataconnection.DataConnection r1 = r3.mDataConnection     // Catch:{ all -> 0x002b }
            r2 = 262158(0x4000e, float:3.67362E-40)
            android.os.Message r1 = r1.obtainMessage(r2)     // Catch:{ all -> 0x002b }
            r0.pullLceData(r1)     // Catch:{ all -> 0x002b }
        L_0x0029:
            monitor-exit(r3)
            return
        L_0x002b:
            r0 = move-exception
            monitor-exit(r3)
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcNetworkAgent.onBandwidthUpdateRequested():void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:12:0x0048, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onValidationStatus(int r4, android.net.Uri r5) {
        /*
            r3 = this;
            monitor-enter(r3)
            com.android.internal.telephony.dataconnection.DataConnection r0 = r3.mDataConnection     // Catch:{ all -> 0x0049 }
            if (r0 != 0) goto L_0x000c
            java.lang.String r4 = "onValidationStatus called on no-owner DcNetworkAgent!"
            r3.loge(r4)     // Catch:{ all -> 0x0049 }
            monitor-exit(r3)
            return
        L_0x000c:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x0049 }
            r0.<init>()     // Catch:{ all -> 0x0049 }
            java.lang.String r1 = "validation status: "
            r0.append(r1)     // Catch:{ all -> 0x0049 }
            r0.append(r4)     // Catch:{ all -> 0x0049 }
            java.lang.String r1 = " with redirection URL: "
            r0.append(r1)     // Catch:{ all -> 0x0049 }
            r0.append(r5)     // Catch:{ all -> 0x0049 }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x0049 }
            r3.logd(r0)     // Catch:{ all -> 0x0049 }
            com.android.internal.telephony.Phone r0 = r3.mPhone     // Catch:{ all -> 0x0049 }
            int r1 = r3.mTransportType     // Catch:{ all -> 0x0049 }
            com.android.internal.telephony.dataconnection.DcTracker r0 = r0.getDcTracker(r1)     // Catch:{ all -> 0x0049 }
            if (r0 == 0) goto L_0x0047
            r1 = 270380(0x4202c, float:3.78883E-40)
            com.android.internal.telephony.dataconnection.DataConnection r2 = r3.mDataConnection     // Catch:{ all -> 0x0049 }
            int r2 = r2.getCid()     // Catch:{ all -> 0x0049 }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x0049 }
            android.os.Message r4 = r0.obtainMessage(r1, r4, r2, r5)     // Catch:{ all -> 0x0049 }
            r4.sendToTarget()     // Catch:{ all -> 0x0049 }
        L_0x0047:
            monitor-exit(r3)
            return
        L_0x0049:
            r4 = move-exception
            monitor-exit(r3)
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcNetworkAgent.onValidationStatus(int, android.net.Uri):void");
    }

    private synchronized boolean isOwned(DataConnection dataConnection, String str) {
        DataConnection dataConnection2 = this.mDataConnection;
        if (dataConnection2 == null) {
            loge(str + " called on no-owner DcNetworkAgent!");
            return false;
        } else if (dataConnection2 == dataConnection) {
            return true;
        } else {
            loge(str + ": This agent belongs to " + this.mDataConnection.getName() + ", ignored the request from " + dataConnection.getName());
            return false;
        }
    }

    public synchronized void updateLegacySubtype(DataConnection dataConnection) {
        if (isOwned(dataConnection, "updateLegacySubtype")) {
            int networkType = getNetworkType();
            setLegacySubtype(networkType, TelephonyManager.getNetworkTypeName(networkType));
        }
    }

    public synchronized void sendNetworkCapabilities(NetworkCapabilities networkCapabilities, DataConnection dataConnection) {
        if (isOwned(dataConnection, "sendNetworkCapabilities")) {
            if (!networkCapabilities.equals(this.mNetworkCapabilities)) {
                String str = "Changed from " + this.mNetworkCapabilities + " to " + networkCapabilities + ", Data RAT=" + this.mPhone.getServiceState().getRilDataRadioTechnology() + ", dc=" + this.mDataConnection.getName();
                logd(str);
                this.mNetCapsLocalLog.log(str);
                if (networkCapabilities.hasCapability(12) && (this.mNetworkCapabilities == null || networkCapabilities.hasCapability(25) != this.mNetworkCapabilities.hasCapability(25))) {
                    TelephonyMetrics.getInstance().writeNetworkCapabilitiesChangedEvent(this.mPhone.getPhoneId(), networkCapabilities);
                }
                this.mNetworkCapabilities = networkCapabilities;
            }
            sendNetworkCapabilities(networkCapabilities);
        }
    }

    public synchronized void sendLinkProperties(LinkProperties linkProperties, DataConnection dataConnection) {
        if (isOwned(dataConnection, "sendLinkProperties")) {
            sInterfaceNames.put(Integer.valueOf(this.mId), dataConnection.getLinkProperties().getInterfaceName());
            sendLinkProperties(linkProperties);
        }
    }

    public synchronized void sendNetworkScore(int i, DataConnection dataConnection) {
        if (isOwned(dataConnection, "sendNetworkScore")) {
            sendNetworkScore(i);
        }
    }

    public synchronized void unregister(DataConnection dataConnection) {
        if (isOwned(dataConnection, "unregister")) {
            this.mHandler.removeMessages(1);
            logd("Unregister from connectivity service. " + sInterfaceNames.get(Integer.valueOf(this.mId)) + " removed.");
            sInterfaceNames.remove(Integer.valueOf(this.mId));
            DcNetworkAgent.super.unregister();
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:13:0x0026, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void onStartSocketKeepalive(int r5, java.time.Duration r6, android.net.KeepalivePacketData r7) {
        /*
            r4 = this;
            monitor-enter(r4)
            com.android.internal.telephony.dataconnection.DataConnection r0 = r4.mDataConnection     // Catch:{ all -> 0x0027 }
            if (r0 != 0) goto L_0x000c
            java.lang.String r5 = "onStartSocketKeepalive called on no-owner DcNetworkAgent!"
            r4.loge(r5)     // Catch:{ all -> 0x0027 }
            monitor-exit(r4)
            return
        L_0x000c:
            boolean r1 = r7 instanceof android.net.NattKeepalivePacketData     // Catch:{ all -> 0x0027 }
            if (r1 == 0) goto L_0x0020
            r1 = 262165(0x40015, float:3.67371E-40)
            long r2 = r6.getSeconds()     // Catch:{ all -> 0x0027 }
            int r6 = (int) r2     // Catch:{ all -> 0x0027 }
            android.os.Message r5 = r0.obtainMessage(r1, r5, r6, r7)     // Catch:{ all -> 0x0027 }
            r5.sendToTarget()     // Catch:{ all -> 0x0027 }
            goto L_0x0025
        L_0x0020:
            r6 = -30
            r4.sendSocketKeepaliveEvent(r5, r6)     // Catch:{ all -> 0x0027 }
        L_0x0025:
            monitor-exit(r4)
            return
        L_0x0027:
            r5 = move-exception
            monitor-exit(r4)
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcNetworkAgent.onStartSocketKeepalive(int, java.time.Duration, android.net.KeepalivePacketData):void");
    }

    public synchronized void onStopSocketKeepalive(int i) {
        DataConnection dataConnection = this.mDataConnection;
        if (dataConnection == null) {
            loge("onStopSocketKeepalive called on no-owner DcNetworkAgent!");
        } else {
            dataConnection.obtainMessage(262166, i).sendToTarget();
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onQosCallbackRegistered$0(int i, final QosFilter qosFilter) {
        this.mQosCallbackTracker.addFilter(i, new QosCallbackTracker.IFilter() {
            public boolean matchesLocalAddress(InetAddress inetAddress, int i, int i2) {
                return qosFilter.matchesLocalAddress(inetAddress, i, i2);
            }

            public boolean matchesRemoteAddress(InetAddress inetAddress, int i, int i2) {
                return qosFilter.matchesRemoteAddress(inetAddress, i, i2);
            }
        });
    }

    public void onQosCallbackRegistered(int i, QosFilter qosFilter) {
        this.mQosCallbackExecutor.execute(new DcNetworkAgent$$ExternalSyntheticLambda0(this, i, qosFilter));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onQosCallbackUnregistered$1(int i) {
        this.mQosCallbackTracker.removeFilter(i);
    }

    public void onQosCallbackUnregistered(int i) {
        this.mQosCallbackExecutor.execute(new DcNetworkAgent$$ExternalSyntheticLambda1(this, i));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateQosBearerSessions$2(List list) {
        this.mQosCallbackTracker.updateSessions(list);
    }

    /* access modifiers changed from: package-private */
    public void updateQosBearerSessions(List<QosBearerSession> list) {
        this.mQosCallbackExecutor.execute(new DcNetworkAgent$$ExternalSyntheticLambda2(this, list));
    }

    public void notifyQosSessionAvailable(int i, int i2, QosSessionAttributes qosSessionAttributes) {
        DcNetworkAgent.super.sendQosSessionAvailable(i, i2, qosSessionAttributes);
    }

    public void notifyQosSessionLost(int i, int i2, int i3) {
        DcNetworkAgent.super.sendQosSessionLost(i, i2, i3);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("DcNetworkAgent-");
        sb.append(this.mId);
        sb.append(" mDataConnection=");
        DataConnection dataConnection = this.mDataConnection;
        LinkProperties linkProperties = null;
        sb.append(dataConnection != null ? dataConnection.getName() : null);
        sb.append(" mTransportType=");
        sb.append(AccessNetworkConstants.transportTypeToString(this.mTransportType));
        sb.append(" ");
        DataConnection dataConnection2 = this.mDataConnection;
        if (dataConnection2 != null) {
            linkProperties = dataConnection2.getLinkProperties();
        }
        sb.append(linkProperties);
        sb.append(" mNetworkCapabilities=");
        sb.append(this.mNetworkCapabilities);
        return sb.toString();
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println(toString());
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("Net caps logs:");
        this.mNetCapsLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
    }

    /* access modifiers changed from: private */
    public void logd(String str) {
        Rlog.d(this.mTag, str);
    }

    /* access modifiers changed from: private */
    public void loge(String str) {
        Rlog.e(this.mTag, str);
    }

    class DcKeepaliveTracker {
        private final SparseArray<KeepaliveRecord> mKeepalives = new SparseArray<>();

        /* access modifiers changed from: package-private */
        public int keepaliveStatusErrorToPacketKeepaliveError(int i) {
            if (i == 0) {
                return 0;
            }
            if (i != 1) {
                return i != 2 ? -31 : -32;
            }
            return -30;
        }

        DcKeepaliveTracker() {
        }

        private class KeepaliveRecord {
            public int currentStatus;
            public int slotId;

            KeepaliveRecord(int i, int i2) {
                this.slotId = i;
                this.currentStatus = i2;
            }
        }

        /* access modifiers changed from: package-private */
        public int getHandleForSlot(int i) {
            for (int i2 = 0; i2 < this.mKeepalives.size(); i2++) {
                if (this.mKeepalives.valueAt(i2).slotId == i) {
                    return this.mKeepalives.keyAt(i2);
                }
            }
            return -1;
        }

        /* access modifiers changed from: package-private */
        public void handleKeepaliveStarted(int i, KeepaliveStatus keepaliveStatus) {
            int i2 = keepaliveStatus.statusCode;
            if (i2 == 0) {
                DcNetworkAgent.this.sendSocketKeepaliveEvent(i, 0);
            } else if (i2 == 1) {
                DcNetworkAgent.this.sendSocketKeepaliveEvent(i, keepaliveStatusErrorToPacketKeepaliveError(keepaliveStatus.errorCode));
                return;
            } else if (i2 != 2) {
                DcNetworkAgent dcNetworkAgent = DcNetworkAgent.this;
                dcNetworkAgent.logd("Invalid KeepaliveStatus Code: " + keepaliveStatus.statusCode);
                return;
            }
            DcNetworkAgent dcNetworkAgent2 = DcNetworkAgent.this;
            dcNetworkAgent2.logd("Adding keepalive handle=" + keepaliveStatus.sessionHandle + " slot = " + i);
            this.mKeepalives.put(keepaliveStatus.sessionHandle, new KeepaliveRecord(i, keepaliveStatus.statusCode));
        }

        /* access modifiers changed from: package-private */
        public void handleKeepaliveStatus(KeepaliveStatus keepaliveStatus) {
            KeepaliveRecord keepaliveRecord = this.mKeepalives.get(keepaliveStatus.sessionHandle);
            if (keepaliveRecord == null) {
                DcNetworkAgent dcNetworkAgent = DcNetworkAgent.this;
                dcNetworkAgent.loge("Discarding keepalive event for different data connection:" + keepaliveStatus);
                return;
            }
            int i = keepaliveRecord.currentStatus;
            if (i == 0) {
                int i2 = keepaliveStatus.statusCode;
                if (i2 != 0) {
                    if (i2 == 1) {
                        DcNetworkAgent.this.logd("Keepalive received stopped status!");
                        DcNetworkAgent.this.sendSocketKeepaliveEvent(keepaliveRecord.slotId, 0);
                        keepaliveRecord.currentStatus = 1;
                        this.mKeepalives.remove(keepaliveStatus.sessionHandle);
                        return;
                    } else if (i2 != 2) {
                        DcNetworkAgent dcNetworkAgent2 = DcNetworkAgent.this;
                        dcNetworkAgent2.loge("Invalid Keepalive Status received, " + keepaliveStatus.statusCode);
                        return;
                    }
                }
                DcNetworkAgent.this.loge("Active Keepalive received invalid status!");
            } else if (i == 1) {
                DcNetworkAgent.this.logd("Inactive Keepalive received status!");
                DcNetworkAgent.this.sendSocketKeepaliveEvent(keepaliveRecord.slotId, -31);
            } else if (i != 2) {
                DcNetworkAgent dcNetworkAgent3 = DcNetworkAgent.this;
                dcNetworkAgent3.loge("Invalid Keepalive Status received, " + keepaliveRecord.currentStatus);
            } else {
                int i3 = keepaliveStatus.statusCode;
                if (i3 == 0) {
                    DcNetworkAgent.this.logd("Pending Keepalive received active status!");
                    keepaliveRecord.currentStatus = 0;
                    DcNetworkAgent.this.sendSocketKeepaliveEvent(keepaliveRecord.slotId, 0);
                } else if (i3 == 1) {
                    DcNetworkAgent.this.sendSocketKeepaliveEvent(keepaliveRecord.slotId, keepaliveStatusErrorToPacketKeepaliveError(keepaliveStatus.errorCode));
                    keepaliveRecord.currentStatus = 1;
                    this.mKeepalives.remove(keepaliveStatus.sessionHandle);
                } else if (i3 != 2) {
                    DcNetworkAgent dcNetworkAgent4 = DcNetworkAgent.this;
                    dcNetworkAgent4.loge("Invalid Keepalive Status received, " + keepaliveStatus.statusCode);
                } else {
                    DcNetworkAgent.this.loge("Invalid unsolicied Keepalive Pending Status!");
                }
            }
        }
    }
}
