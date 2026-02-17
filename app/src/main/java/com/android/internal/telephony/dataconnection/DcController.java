package com.android.internal.telephony.dataconnection;

import android.net.LinkAddress;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.telephony.data.TrafficDescriptor;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

public class DcController extends Handler {
    private static final boolean DBG = true;
    private static final boolean VDBG = false;
    private final DataServiceManager mDataServiceManager;
    private final HashMap<Integer, DataConnection> mDcListActiveByCid = new HashMap<>();
    final ArrayList<DataConnection> mDcListAll = new ArrayList<>();
    private final DcTesterDeactivateAll mDcTesterDeactivateAll;
    private final DcTracker mDct;
    private final Phone mPhone;
    private int mPhysicalLinkStatus = -1;
    private RegistrantList mPhysicalLinkStatusChangedRegistrants = new RegistrantList();
    private final String mTag;
    private final HashMap<Integer, List<TrafficDescriptor>> mTrafficDescriptorsByCid = new HashMap<>();

    private DcController(String str, Phone phone, DcTracker dcTracker, DataServiceManager dataServiceManager, Looper looper) {
        super(looper);
        this.mPhone = phone;
        this.mDct = dcTracker;
        this.mTag = str;
        this.mDataServiceManager = dataServiceManager;
        this.mDcTesterDeactivateAll = TelephonyUtils.IS_DEBUGGABLE ? new DcTesterDeactivateAll(phone, this, this) : null;
        dataServiceManager.registerForDataCallListChanged(this, 262151);
    }

    public static DcController makeDcc(Phone phone, DcTracker dcTracker, DataServiceManager dataServiceManager, Looper looper, String str) {
        return new DcController("Dcc" + str, phone, dcTracker, dataServiceManager, looper);
    }

    /* access modifiers changed from: package-private */
    public void addDc(DataConnection dataConnection) {
        synchronized (this.mDcListAll) {
            this.mDcListAll.add(dataConnection);
        }
    }

    /* access modifiers changed from: package-private */
    public void removeDc(DataConnection dataConnection) {
        synchronized (this.mDcListAll) {
            this.mDcListActiveByCid.remove(Integer.valueOf(dataConnection.mCid));
            this.mDcListAll.remove(dataConnection);
        }
        synchronized (this.mTrafficDescriptorsByCid) {
            this.mTrafficDescriptorsByCid.remove(Integer.valueOf(dataConnection.mCid));
        }
    }

    public void addActiveDcByCid(DataConnection dataConnection) {
        if (dataConnection.mCid < 0) {
            log("addActiveDcByCid dc.mCid < 0 dc=" + dataConnection);
        }
        synchronized (this.mDcListAll) {
            this.mDcListActiveByCid.put(Integer.valueOf(dataConnection.mCid), dataConnection);
        }
        updateTrafficDescriptorsForCid(dataConnection.mCid, dataConnection.getTrafficDescriptors());
    }

    /* access modifiers changed from: package-private */
    public DataConnection getActiveDcByCid(int i) {
        DataConnection dataConnection;
        synchronized (this.mDcListAll) {
            dataConnection = this.mDcListActiveByCid.get(Integer.valueOf(i));
        }
        return dataConnection;
    }

    /* access modifiers changed from: package-private */
    public void removeActiveDcByCid(DataConnection dataConnection) {
        synchronized (this.mDcListAll) {
            if (this.mDcListActiveByCid.remove(Integer.valueOf(dataConnection.mCid)) == null) {
                log("removeActiveDcByCid removedDc=null dc=" + dataConnection);
            }
        }
        synchronized (this.mTrafficDescriptorsByCid) {
            this.mTrafficDescriptorsByCid.remove(Integer.valueOf(dataConnection.mCid));
        }
    }

    /* access modifiers changed from: package-private */
    public boolean isDefaultDataActive() {
        boolean anyMatch;
        synchronized (this.mDcListAll) {
            anyMatch = this.mDcListActiveByCid.values().stream().anyMatch(new DcController$$ExternalSyntheticLambda2());
        }
        return anyMatch;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isDefaultDataActive$0(ApnContext apnContext) {
        return apnContext.getApnTypeBitmask() == 17;
    }

    /* access modifiers changed from: package-private */
    public List<TrafficDescriptor> getTrafficDescriptorsForCid(int i) {
        List<TrafficDescriptor> list;
        synchronized (this.mTrafficDescriptorsByCid) {
            list = this.mTrafficDescriptorsByCid.get(Integer.valueOf(i));
        }
        return list;
    }

    /* access modifiers changed from: package-private */
    public void updateTrafficDescriptorsForCid(int i, List<TrafficDescriptor> list) {
        synchronized (this.mTrafficDescriptorsByCid) {
            this.mTrafficDescriptorsByCid.put(Integer.valueOf(i), list);
        }
    }

    public void handleMessage(Message message) {
        if (message.what != 262151) {
            loge("Unexpected event " + message);
            return;
        }
        AsyncResult asyncResult = (AsyncResult) message.obj;
        if (asyncResult.exception == null) {
            onDataStateChanged((ArrayList) asyncResult.result);
        } else {
            log("EVENT_DATA_STATE_CHANGED: exception; likely radio not available, ignore");
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:100:0x0351  */
    /* JADX WARNING: Removed duplicated region for block: B:102:0x035e A[ADDED_TO_REGION] */
    /* JADX WARNING: Removed duplicated region for block: B:106:0x038b  */
    /* JADX WARNING: Removed duplicated region for block: B:85:0x0323  */
    /* JADX WARNING: Removed duplicated region for block: B:88:0x032b  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void onDataStateChanged(java.util.ArrayList<android.telephony.data.DataCallResponse> r19) {
        /*
            r18 = this;
            r0 = r18
            java.util.ArrayList<com.android.internal.telephony.dataconnection.DataConnection> r1 = r0.mDcListAll
            monitor-enter(r1)
            java.util.HashMap r2 = new java.util.HashMap     // Catch:{ all -> 0x03f4 }
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.dataconnection.DataConnection> r3 = r0.mDcListActiveByCid     // Catch:{ all -> 0x03f4 }
            r2.<init>(r3)     // Catch:{ all -> 0x03f4 }
            monitor-exit(r1)     // Catch:{ all -> 0x03f4 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r3 = "onDataStateChanged: dcsList="
            r1.append(r3)
            r3 = r19
            r1.append(r3)
            java.lang.String r4 = " dcListActiveByCid="
            r1.append(r4)
            r1.append(r2)
            java.lang.String r1 = r1.toString()
            r0.log(r1)
            java.util.HashMap r1 = new java.util.HashMap
            r1.<init>()
            java.util.Iterator r4 = r19.iterator()
        L_0x0034:
            boolean r5 = r4.hasNext()
            if (r5 == 0) goto L_0x004c
            java.lang.Object r5 = r4.next()
            android.telephony.data.DataCallResponse r5 = (android.telephony.data.DataCallResponse) r5
            int r6 = r5.getId()
            java.lang.Integer r6 = java.lang.Integer.valueOf(r6)
            r1.put(r6, r5)
            goto L_0x0034
        L_0x004c:
            java.util.ArrayList r4 = new java.util.ArrayList
            r4.<init>()
            java.util.Collection r5 = r2.values()
            java.util.Iterator r5 = r5.iterator()
        L_0x0059:
            boolean r6 = r5.hasNext()
            if (r6 == 0) goto L_0x00c8
            java.lang.Object r6 = r5.next()
            com.android.internal.telephony.dataconnection.DataConnection r6 = (com.android.internal.telephony.dataconnection.DataConnection) r6
            int r7 = r6.mCid
            java.lang.Integer r7 = java.lang.Integer.valueOf(r7)
            java.lang.Object r7 = r1.get(r7)
            android.telephony.data.DataCallResponse r7 = (android.telephony.data.DataCallResponse) r7
            if (r7 != 0) goto L_0x008b
            java.lang.StringBuilder r7 = new java.lang.StringBuilder
            r7.<init>()
            java.lang.String r8 = "onDataStateChanged: add to retry dc="
            r7.append(r8)
            r7.append(r6)
            java.lang.String r7 = r7.toString()
            r0.log(r7)
            r4.add(r6)
            goto L_0x0059
        L_0x008b:
            int r8 = r6.mCid
            java.util.List r8 = r0.getTrafficDescriptorsForCid(r8)
            java.util.List r7 = r7.getTrafficDescriptors()
            boolean r9 = r8.equals(r7)
            if (r9 != 0) goto L_0x0059
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r10 = "onDataStateChanged: add to retry due to TD changed dc="
            r9.append(r10)
            r9.append(r6)
            java.lang.String r10 = ", oldTds="
            r9.append(r10)
            r9.append(r8)
            java.lang.String r8 = ", newTds="
            r9.append(r8)
            r9.append(r7)
            java.lang.String r8 = r9.toString()
            r0.log(r8)
            int r8 = r6.mCid
            r0.updateTrafficDescriptorsForCid(r8, r7)
            r4.add(r6)
            goto L_0x0059
        L_0x00c8:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r5 = "onDataStateChanged: dcsToRetry="
            r1.append(r5)
            r1.append(r4)
            java.lang.String r1 = r1.toString()
            r0.log(r1)
            java.util.ArrayList r1 = new java.util.ArrayList
            r1.<init>()
            java.util.Iterator r3 = r19.iterator()
            r5 = 0
            r6 = r5
            r7 = r6
            r8 = r7
        L_0x00e9:
            boolean r9 = r3.hasNext()
            r10 = 2
            if (r9 == 0) goto L_0x0333
            java.lang.Object r9 = r3.next()
            android.telephony.data.DataCallResponse r9 = (android.telephony.data.DataCallResponse) r9
            int r12 = r9.getId()
            java.lang.Integer r12 = java.lang.Integer.valueOf(r12)
            java.lang.Object r12 = r2.get(r12)
            com.android.internal.telephony.dataconnection.DataConnection r12 = (com.android.internal.telephony.dataconnection.DataConnection) r12
            if (r12 != 0) goto L_0x010c
            java.lang.String r9 = "onDataStateChanged: no associated DC yet, ignore"
            r0.loge(r9)
            goto L_0x00e9
        L_0x010c:
            java.util.List r13 = r12.getApnContexts()
            int r14 = r13.size()
            if (r14 != 0) goto L_0x0121
            java.lang.String r12 = "onDataStateChanged: no connected apns, ignore"
            r0.loge(r12)
        L_0x011b:
            r17 = r2
            r16 = r3
            goto L_0x031c
        L_0x0121:
            java.lang.StringBuilder r14 = new java.lang.StringBuilder
            r14.<init>()
            java.lang.String r15 = "onDataStateChanged: Found ConnId="
            r14.append(r15)
            int r15 = r9.getId()
            r14.append(r15)
            java.lang.String r15 = " newState="
            r14.append(r15)
            java.lang.String r15 = r9.toString()
            r14.append(r15)
            java.lang.String r14 = r14.toString()
            r0.log(r14)
            java.util.stream.Stream r14 = r13.stream()
            com.android.internal.telephony.dataconnection.DcController$$ExternalSyntheticLambda0 r15 = new com.android.internal.telephony.dataconnection.DcController$$ExternalSyntheticLambda0
            r15.<init>()
            boolean r14 = r14.anyMatch(r15)
            if (r14 == 0) goto L_0x015b
            int r14 = r9.getLinkStatus()
            if (r14 != r10) goto L_0x015b
            r7 = 1
        L_0x015b:
            int r14 = r9.getLinkStatus()
            if (r14 != 0) goto L_0x01e5
            com.android.internal.telephony.dataconnection.DcTracker r14 = r0.mDct
            java.util.concurrent.atomic.AtomicBoolean r14 = r14.isCleanupRequired
            boolean r14 = r14.get()
            if (r14 == 0) goto L_0x0176
            r1.addAll(r13)
            com.android.internal.telephony.dataconnection.DcTracker r12 = r0.mDct
            java.util.concurrent.atomic.AtomicBoolean r12 = r12.isCleanupRequired
            r12.set(r5)
            goto L_0x011b
        L_0x0176:
            int r14 = r9.getCause()
            int r14 = android.telephony.DataFailCause.getFailCause(r14)
            com.android.internal.telephony.Phone r15 = r0.mPhone
            android.content.Context r15 = r15.getContext()
            com.android.internal.telephony.Phone r5 = r0.mPhone
            int r5 = r5.getSubId()
            boolean r5 = android.telephony.DataFailCause.isRadioRestartFailure(r15, r14, r5)
            if (r5 == 0) goto L_0x01ab
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r12 = "onDataStateChanged: X restart radio, failCause="
            r5.append(r12)
            r5.append(r14)
            java.lang.String r5 = r5.toString()
            r0.log(r5)
            com.android.internal.telephony.dataconnection.DcTracker r5 = r0.mDct
            r5.sendRestartRadio()
            goto L_0x011b
        L_0x01ab:
            com.android.internal.telephony.dataconnection.DcTracker r5 = r0.mDct
            boolean r5 = r5.isPermanentFailure(r14)
            if (r5 == 0) goto L_0x01cc
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r12 = "onDataStateChanged: inactive, add to cleanup list. failCause="
            r5.append(r12)
            r5.append(r14)
            java.lang.String r5 = r5.toString()
            r0.log(r5)
            r1.addAll(r13)
            goto L_0x011b
        L_0x01cc:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r13 = "onDataStateChanged: inactive, add to retry list. failCause="
            r5.append(r13)
            r5.append(r14)
            java.lang.String r5 = r5.toString()
            r0.log(r5)
            r4.add(r12)
            goto L_0x011b
        L_0x01e5:
            int r5 = r9.getPduSessionId()
            r12.setPduSessionId(r5)
            r12.updatePcscfAddr(r9)
            com.android.internal.telephony.dataconnection.DataConnection$UpdateLinkPropertyResult r5 = r12.updateLinkProperty(r9)
            r12.updateResponseFields(r9)
            android.net.LinkProperties r12 = r5.oldLp
            android.net.LinkProperties r14 = r5.newLp
            boolean r12 = r12.equals(r14)
            if (r12 == 0) goto L_0x0207
            java.lang.String r5 = "onDataStateChanged: no change"
            r0.log(r5)
            goto L_0x011b
        L_0x0207:
            android.net.LinkProperties r12 = r5.oldLp
            android.net.LinkProperties r14 = r5.newLp
            boolean r12 = com.android.internal.telephony.util.LinkPropertiesUtils.isIdenticalInterfaceName(r12, r14)
            if (r12 == 0) goto L_0x0301
            android.net.LinkProperties r12 = r5.oldLp
            android.net.LinkProperties r14 = r5.newLp
            boolean r12 = com.android.internal.telephony.util.LinkPropertiesUtils.isIdenticalDnses(r12, r14)
            if (r12 == 0) goto L_0x0241
            android.net.LinkProperties r12 = r5.oldLp
            android.net.LinkProperties r14 = r5.newLp
            boolean r12 = com.android.internal.telephony.util.LinkPropertiesUtils.isIdenticalRoutes(r12, r14)
            if (r12 == 0) goto L_0x0241
            android.net.LinkProperties r12 = r5.oldLp
            android.net.LinkProperties r14 = r5.newLp
            boolean r12 = com.android.internal.telephony.util.LinkPropertiesUtils.isIdenticalHttpProxy(r12, r14)
            if (r12 == 0) goto L_0x0241
            android.net.LinkProperties r12 = r5.oldLp
            android.net.LinkProperties r14 = r5.newLp
            boolean r12 = com.android.internal.telephony.util.LinkPropertiesUtils.isIdenticalAddresses(r12, r14)
            if (r12 != 0) goto L_0x023a
            goto L_0x0241
        L_0x023a:
            java.lang.String r5 = "onDataStateChanged: no changes"
            r0.log(r5)
            goto L_0x011b
        L_0x0241:
            com.android.internal.telephony.util.LinkPropertiesUtils$CompareOrUpdateResult r12 = new com.android.internal.telephony.util.LinkPropertiesUtils$CompareOrUpdateResult
            android.net.LinkProperties r14 = r5.oldLp
            if (r14 == 0) goto L_0x024c
            java.util.List r14 = r14.getLinkAddresses()
            goto L_0x024d
        L_0x024c:
            r14 = 0
        L_0x024d:
            android.net.LinkProperties r15 = r5.newLp
            if (r15 == 0) goto L_0x0256
            java.util.List r15 = r15.getLinkAddresses()
            goto L_0x0257
        L_0x0256:
            r15 = 0
        L_0x0257:
            com.android.internal.telephony.dataconnection.DcController$$ExternalSyntheticLambda1 r11 = new com.android.internal.telephony.dataconnection.DcController$$ExternalSyntheticLambda1
            r11.<init>()
            r12.<init>(r14, r15, r11)
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r14 = "onDataStateChanged: oldLp="
            r11.append(r14)
            android.net.LinkProperties r14 = r5.oldLp
            r11.append(r14)
            java.lang.String r14 = " newLp="
            r11.append(r14)
            android.net.LinkProperties r14 = r5.newLp
            r11.append(r14)
            java.lang.String r14 = " car="
            r11.append(r14)
            r11.append(r12)
            java.lang.String r11 = r11.toString()
            r0.log(r11)
            java.util.List<T> r11 = r12.added
            java.util.Iterator r11 = r11.iterator()
            r14 = 0
        L_0x028e:
            boolean r15 = r11.hasNext()
            if (r15 == 0) goto L_0x02cf
            java.lang.Object r15 = r11.next()
            android.net.LinkAddress r15 = (android.net.LinkAddress) r15
            java.util.List<T> r10 = r12.removed
            java.util.Iterator r10 = r10.iterator()
        L_0x02a0:
            boolean r16 = r10.hasNext()
            if (r16 == 0) goto L_0x02c5
            java.lang.Object r16 = r10.next()
            android.net.LinkAddress r16 = (android.net.LinkAddress) r16
            r17 = r2
            java.net.InetAddress r2 = r16.getAddress()
            r16 = r3
            java.net.InetAddress r3 = r15.getAddress()
            boolean r2 = com.android.internal.telephony.util.NetUtils.addressTypeMatches(r2, r3)
            if (r2 == 0) goto L_0x02c0
            r14 = 1
            goto L_0x02c9
        L_0x02c0:
            r3 = r16
            r2 = r17
            goto L_0x02a0
        L_0x02c5:
            r17 = r2
            r16 = r3
        L_0x02c9:
            r3 = r16
            r2 = r17
            r10 = 2
            goto L_0x028e
        L_0x02cf:
            r17 = r2
            r16 = r3
            if (r14 == 0) goto L_0x031c
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "onDataStateChanged: addr change, cleanup apns="
            r2.append(r3)
            r2.append(r13)
            java.lang.String r3 = " oldLp="
            r2.append(r3)
            android.net.LinkProperties r3 = r5.oldLp
            r2.append(r3)
            java.lang.String r3 = " newLp="
            r2.append(r3)
            android.net.LinkProperties r3 = r5.newLp
            r2.append(r3)
            java.lang.String r2 = r2.toString()
            r0.log(r2)
            r1.addAll(r13)
            goto L_0x031c
        L_0x0301:
            r17 = r2
            r16 = r3
            r1.addAll(r13)
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "onDataStateChanged: interface change, cleanup apns="
            r2.append(r3)
            r2.append(r13)
            java.lang.String r2 = r2.toString()
            r0.log(r2)
        L_0x031c:
            int r2 = r9.getLinkStatus()
            r3 = 2
            if (r2 != r3) goto L_0x0324
            r6 = 1
        L_0x0324:
            int r2 = r9.getLinkStatus()
            r5 = 1
            if (r2 != r5) goto L_0x032c
            r8 = r5
        L_0x032c:
            r3 = r16
            r2 = r17
            r5 = 0
            goto L_0x00e9
        L_0x0333:
            r3 = r10
            r5 = 1
            com.android.internal.telephony.dataconnection.DataServiceManager r2 = r0.mDataServiceManager
            int r2 = r2.getTransportType()
            if (r2 != r5) goto L_0x0392
            com.android.internal.telephony.dataconnection.DcTracker r2 = r0.mDct
            boolean r2 = r2.getLteEndcUsingUserDataForIdleDetection()
            if (r2 == 0) goto L_0x0348
            if (r7 == 0) goto L_0x034c
            goto L_0x034a
        L_0x0348:
            if (r6 == 0) goto L_0x034c
        L_0x034a:
            r10 = r3
            goto L_0x034d
        L_0x034c:
            r10 = r5
        L_0x034d:
            int r2 = r0.mPhysicalLinkStatus
            if (r2 == r10) goto L_0x035c
            r0.mPhysicalLinkStatus = r10
            com.android.internal.telephony.RegistrantList r2 = r0.mPhysicalLinkStatusChangedRegistrants
            java.lang.Integer r3 = java.lang.Integer.valueOf(r10)
            r2.notifyResult(r3)
        L_0x035c:
            if (r8 == 0) goto L_0x036d
            if (r6 != 0) goto L_0x036d
            java.lang.String r2 = "onDataStateChanged: Data activity DORMANT. stopNetStatePoll"
            r0.log(r2)
            com.android.internal.telephony.dataconnection.DcTracker r2 = r0.mDct
            com.android.internal.telephony.DctConstants$Activity r3 = com.android.internal.telephony.DctConstants.Activity.DORMANT
            r2.sendStopNetStatPoll(r3)
            goto L_0x0392
        L_0x036d:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "onDataStateChanged: Data Activity updated to NONE. isAnyDataCallActive = "
            r2.append(r3)
            r2.append(r6)
            java.lang.String r3 = " isAnyDataCallDormant = "
            r2.append(r3)
            r2.append(r8)
            java.lang.String r2 = r2.toString()
            r0.log(r2)
            if (r6 == 0) goto L_0x0392
            com.android.internal.telephony.dataconnection.DcTracker r2 = r0.mDct
            com.android.internal.telephony.DctConstants$Activity r3 = com.android.internal.telephony.DctConstants.Activity.NONE
            r2.sendStartNetStatPoll(r3)
        L_0x0392:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "onDataStateChanged: dcsToRetry="
            r2.append(r3)
            r2.append(r4)
            java.lang.String r3 = " apnsToCleanup="
            r2.append(r3)
            r2.append(r1)
            java.lang.String r2 = r2.toString()
            r0.log(r2)
            java.util.Iterator r1 = r1.iterator()
        L_0x03b2:
            boolean r2 = r1.hasNext()
            if (r2 == 0) goto L_0x03c4
            java.lang.Object r2 = r1.next()
            com.android.internal.telephony.dataconnection.ApnContext r2 = (com.android.internal.telephony.dataconnection.ApnContext) r2
            com.android.internal.telephony.dataconnection.DcTracker r3 = r0.mDct
            r3.cleanUpConnection(r2)
            goto L_0x03b2
        L_0x03c4:
            java.util.Iterator r1 = r4.iterator()
        L_0x03c8:
            boolean r2 = r1.hasNext()
            if (r2 == 0) goto L_0x03f3
            java.lang.Object r2 = r1.next()
            com.android.internal.telephony.dataconnection.DataConnection r2 = (com.android.internal.telephony.dataconnection.DataConnection) r2
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r4 = "onDataStateChanged: send EVENT_LOST_CONNECTION dc.mTag="
            r3.append(r4)
            int r4 = r2.mTag
            r3.append(r4)
            java.lang.String r3 = r3.toString()
            r0.log(r3)
            r3 = 262153(0x40009, float:3.67355E-40)
            int r4 = r2.mTag
            r2.sendMessage((int) r3, (int) r4)
            goto L_0x03c8
        L_0x03f3:
            return
        L_0x03f4:
            r0 = move-exception
            monitor-exit(r1)     // Catch:{ all -> 0x03f4 }
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcController.onDataStateChanged(java.util.ArrayList):void");
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Object lambda$onDataStateChanged$3(Object obj) {
        LinkAddress linkAddress = (LinkAddress) obj;
        return Integer.valueOf(Objects.hash(new Object[]{linkAddress.getAddress(), Integer.valueOf(linkAddress.getPrefixLength()), Integer.valueOf(linkAddress.getScope())}));
    }

    @VisibleForTesting
    public void registerForPhysicalLinkStatusChanged(Handler handler, int i) {
        this.mPhysicalLinkStatusChangedRegistrants.addUnique(handler, i, (Object) null);
    }

    /* access modifiers changed from: package-private */
    public void unregisterForPhysicalLinkStatusChanged(Handler handler) {
        this.mPhysicalLinkStatusChangedRegistrants.remove(handler);
    }

    private void log(String str) {
        Rlog.d(this.mTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mTag, str);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        synchronized (this.mDcListAll) {
            sb.append("mDcListAll=");
            sb.append(this.mDcListAll);
            sb.append(" mDcListActiveByCid=");
            sb.append(this.mDcListActiveByCid);
        }
        synchronized (this.mTrafficDescriptorsByCid) {
            sb.append("mTrafficDescriptorsByCid=");
            sb.append(this.mTrafficDescriptorsByCid);
        }
        return sb.toString();
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println(" mPhone=" + this.mPhone);
        synchronized (this.mDcListAll) {
            printWriter.println(" mDcListAll=" + this.mDcListAll);
            printWriter.println(" mDcListActiveByCid=" + this.mDcListActiveByCid);
        }
        synchronized (this.mTrafficDescriptorsByCid) {
            printWriter.println(" mTrafficDescriptorsByCid=" + this.mTrafficDescriptorsByCid);
        }
    }
}
