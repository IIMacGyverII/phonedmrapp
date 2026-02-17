package com.android.internal.telephony.data;

import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.TelephonyNetworkSpecifier;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.telephony.AccessNetworkConstants;
import android.telephony.SubscriptionManager;
import android.telephony.data.ApnSetting;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.NetworkFactory;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.dataconnection.ApnContext;
import com.android.internal.telephony.dataconnection.DataConnection;
import com.android.internal.telephony.dataconnection.DcTracker;
import com.android.internal.telephony.dataconnection.TransportManager;
import com.android.internal.telephony.metrics.NetworkRequestsStats;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

public class TelephonyNetworkFactory extends NetworkFactory {
    protected static final int ACTION_NO_OP = 0;
    protected static final int ACTION_RELEASE = 2;
    protected static final int ACTION_REQUEST = 1;
    protected static final boolean DBG = true;
    @VisibleForTesting
    public static final int EVENT_ACTIVE_PHONE_SWITCH = 1;
    private static final int EVENT_DATA_HANDOVER_COMPLETED = 6;
    private static final int EVENT_DATA_HANDOVER_NEEDED = 5;
    private static final int EVENT_NETWORK_RELEASE = 4;
    private static final int EVENT_NETWORK_REQUEST = 3;
    @VisibleForTesting
    public static final int EVENT_SUBSCRIPTION_CHANGED = 2;
    private static final int REQUEST_LOG_SIZE = 256;
    private static final int TELEPHONY_NETWORK_SCORE = 50;
    public final String LOG_TAG;
    private AccessNetworksManager mAccessNetworksManager;
    @VisibleForTesting
    public final Handler mInternalHandler;
    private final LocalLog mLocalLog = new LocalLog(256);
    private final Map<TelephonyNetworkRequest, Integer> mNetworkRequests = new HashMap();
    /* access modifiers changed from: private */
    public final Map<Message, TransportManager.HandoverParams> mPendingHandovers = new HashMap();
    private final Phone mPhone;
    private final PhoneSwitcher mPhoneSwitcher;
    private final SubscriptionController mSubscriptionController;
    private int mSubscriptionId;
    private final SubscriptionManager.OnSubscriptionsChangedListener mSubscriptionsChangedListener;

    private static int getAction(boolean z, boolean z2) {
        if (z || !z2) {
            return (!z || z2) ? 0 : 2;
        }
        return 1;
    }

    /* access modifiers changed from: protected */
    public boolean mtkIgnoreCapabilityCheck(TelephonyNetworkRequest telephonyNetworkRequest, int i) {
        return false;
    }

    /* JADX WARNING: Illegal instructions before constructor call */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public TelephonyNetworkFactory(android.os.Looper r7, com.android.internal.telephony.Phone r8) {
        /*
            r6 = this;
            android.content.Context r0 = r8.getContext()
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "TelephonyNetworkFactory["
            r1.append(r2)
            int r3 = r8.getPhoneId()
            r1.append(r3)
            java.lang.String r3 = "]"
            r1.append(r3)
            java.lang.String r1 = r1.toString()
            r4 = 0
            r6.<init>(r7, r0, r1, r4)
            com.android.internal.telephony.LocalLog r0 = new com.android.internal.telephony.LocalLog
            r1 = 256(0x100, float:3.59E-43)
            r0.<init>(r1)
            r6.mLocalLog = r0
            java.util.HashMap r0 = new java.util.HashMap
            r0.<init>()
            r6.mNetworkRequests = r0
            java.util.HashMap r0 = new java.util.HashMap
            r0.<init>()
            r6.mPendingHandovers = r0
            com.android.internal.telephony.data.TelephonyNetworkFactory$1 r0 = new com.android.internal.telephony.data.TelephonyNetworkFactory$1
            r0.<init>()
            r6.mSubscriptionsChangedListener = r0
            r6.mPhone = r8
            com.android.internal.telephony.data.TelephonyNetworkFactory$InternalHandler r1 = new com.android.internal.telephony.data.TelephonyNetworkFactory$InternalHandler
            r1.<init>(r7)
            r6.mInternalHandler = r1
            com.android.internal.telephony.SubscriptionController r7 = com.android.internal.telephony.SubscriptionController.getInstance()
            r6.mSubscriptionController = r7
            com.android.internal.telephony.data.AccessNetworksManager r5 = r8.getAccessNetworksManager()
            r6.mAccessNetworksManager = r5
            int r5 = r8.getPhoneId()
            android.net.NetworkCapabilities r7 = r6.makeNetworkFilter(r7, r5)
            r6.setCapabilityFilter(r7)
            r7 = 50
            r6.setScoreFilter((int) r7)
            com.android.internal.telephony.data.PhoneSwitcher r7 = com.android.internal.telephony.data.PhoneSwitcher.getInstance()
            r6.mPhoneSwitcher = r7
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            r5.append(r2)
            int r2 = r8.getPhoneId()
            r5.append(r2)
            r5.append(r3)
            java.lang.String r2 = r5.toString()
            r6.LOG_TAG = r2
            r2 = 1
            r7.registerForActivePhoneSwitch(r1, r2, r4)
            boolean r7 = r8.isUsingNewDataStack()
            if (r7 != 0) goto L_0x0095
            com.android.internal.telephony.dataconnection.TransportManager r7 = r8.getTransportManager()
            r2 = 5
            r7.registerForHandoverNeededEvent(r1, r2)
        L_0x0095:
            r7 = -1
            r6.mSubscriptionId = r7
            android.content.Context r7 = r8.getContext()
            android.telephony.SubscriptionManager r7 = android.telephony.SubscriptionManager.from(r7)
            r7.addOnSubscriptionsChangedListener(r0)
            r6.register()
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.TelephonyNetworkFactory.<init>(android.os.Looper, com.android.internal.telephony.Phone):void");
    }

    private NetworkCapabilities makeNetworkFilter(SubscriptionController subscriptionController, int i) {
        return makeNetworkFilter(subscriptionController.getSubIdUsingPhoneId(i));
    }

    @VisibleForTesting
    public NetworkCapabilities makeNetworkFilter(int i) {
        return new NetworkCapabilities.Builder().addTransportType(0).addCapability(0).addCapability(1).addCapability(2).addCapability(3).addCapability(4).addCapability(5).addCapability(7).addCapability(8).addCapability(33).addCapability(9).addCapability(29).addCapability(10).addCapability(13).addCapability(28).addCapability(12).addCapability(23).addCapability(34).addCapability(35).addCapability(31).addCapability(30).addEnterpriseId(1).addEnterpriseId(2).addEnterpriseId(3).addEnterpriseId(4).addEnterpriseId(5).setNetworkSpecifier(new TelephonyNetworkSpecifier.Builder().setSubscriptionId(i).build()).build();
    }

    private class InternalHandler extends Handler {
        InternalHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            switch (message.what) {
                case 1:
                    TelephonyNetworkFactory.this.onActivePhoneSwitch();
                    return;
                case 2:
                    TelephonyNetworkFactory.this.onSubIdChange();
                    return;
                case 3:
                    TelephonyNetworkFactory.this.onNeedNetworkFor(message);
                    return;
                case 4:
                    TelephonyNetworkFactory.this.onReleaseNetworkFor(message);
                    return;
                case 5:
                    TransportManager.HandoverParams handoverParams = (TransportManager.HandoverParams) ((AsyncResult) message.obj).result;
                    TelephonyNetworkFactory.this.onDataHandoverNeeded(handoverParams.apnType, handoverParams.targetTransport, handoverParams);
                    return;
                case 6:
                    Bundle data = message.getData();
                    NetworkRequest networkRequest = (NetworkRequest) data.getParcelable(DcTracker.DATA_COMPLETE_MSG_EXTRA_NETWORK_REQUEST);
                    boolean z = data.getBoolean(DcTracker.DATA_COMPLETE_MSG_EXTRA_SUCCESS);
                    int i = data.getInt(DcTracker.DATA_COMPLETE_MSG_EXTRA_TRANSPORT_TYPE);
                    boolean z2 = data.getBoolean(DcTracker.DATA_COMPLETE_MSG_EXTRA_HANDOVER_FAILURE_FALLBACK);
                    TransportManager.HandoverParams handoverParams2 = (TransportManager.HandoverParams) TelephonyNetworkFactory.this.mPendingHandovers.remove(message);
                    if (handoverParams2 != null) {
                        TelephonyNetworkFactory.this.onDataHandoverSetupCompleted(networkRequest, z, i, z2, handoverParams2);
                        return;
                    } else {
                        TelephonyNetworkFactory.this.logl("Handover completed but cannot find handover entry!");
                        return;
                    }
                default:
                    return;
            }
        }
    }

    private int getTransportTypeFromNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        if (PhoneFactory.getDefaultPhone().isUsingNewDataStack()) {
            int apnTypeNetworkCapability = telephonyNetworkRequest.getApnTypeNetworkCapability();
            if (apnTypeNetworkCapability >= 0) {
                return this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(apnTypeNetworkCapability);
            }
            return 1;
        }
        return this.mAccessNetworksManager.getCurrentTransport(ApnContext.getApnTypeFromNetworkRequest(telephonyNetworkRequest.getNativeNetworkRequest()));
    }

    private void requestNetworkInternal(TelephonyNetworkRequest telephonyNetworkRequest, int i, int i2, Message message) {
        NetworkRequestsStats.addNetworkRequest(telephonyNetworkRequest.getNativeNetworkRequest(), this.mSubscriptionId);
        if (this.mPhone.isUsingNewDataStack()) {
            this.mPhone.getDataNetworkController().addNetworkRequest(telephonyNetworkRequest);
        } else if (this.mPhone.getDcTracker(i2) != null) {
            this.mPhone.getDcTracker(i2).requestNetwork(telephonyNetworkRequest.getNativeNetworkRequest(), i, message);
        }
    }

    private void releaseNetworkInternal(TelephonyNetworkRequest telephonyNetworkRequest) {
        this.mPhone.getDataNetworkController().removeNetworkRequest(telephonyNetworkRequest);
    }

    private void releaseNetworkInternal(TelephonyNetworkRequest telephonyNetworkRequest, int i, int i2) {
        if (this.mPhone.isUsingNewDataStack()) {
            this.mPhone.getDataNetworkController().removeNetworkRequest(telephonyNetworkRequest);
        } else if (this.mPhone.getDcTracker(i2) != null) {
            this.mPhone.getDcTracker(i2).releaseNetwork(telephonyNetworkRequest.getNativeNetworkRequest(), i);
        }
    }

    /* access modifiers changed from: private */
    public void onActivePhoneSwitch() {
        logl("onActivePhoneSwitch");
        for (Map.Entry next : this.mNetworkRequests.entrySet()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) next.getKey();
            int i = -1;
            boolean z = ((Integer) next.getValue()).intValue() != -1;
            boolean shouldApplyNetworkRequest = this.mPhoneSwitcher.shouldApplyNetworkRequest(telephonyNetworkRequest, this.mPhone.getPhoneId());
            int action = getAction(z, shouldApplyNetworkRequest);
            if (action != 0 && !mtkIgnoreCapabilityCheck(telephonyNetworkRequest, getAction(z, shouldApplyNetworkRequest))) {
                StringBuilder sb = new StringBuilder();
                sb.append("onActivePhoneSwitch: ");
                sb.append(action == 1 ? "Requesting" : "Releasing");
                sb.append(" network request ");
                sb.append(telephonyNetworkRequest);
                logl(sb.toString());
                int transportTypeFromNetworkRequest = getTransportTypeFromNetworkRequest(telephonyNetworkRequest);
                if (action == 1) {
                    requestNetworkInternal(telephonyNetworkRequest, 1, getTransportTypeFromNetworkRequest(telephonyNetworkRequest), (Message) null);
                } else if (action == 2) {
                    if (this.mPhone.isUsingNewDataStack()) {
                        releaseNetworkInternal(telephonyNetworkRequest);
                    } else {
                        releaseNetworkInternal(telephonyNetworkRequest, 2, getTransportTypeFromNetworkRequest(telephonyNetworkRequest));
                    }
                }
                Map<TelephonyNetworkRequest, Integer> map = this.mNetworkRequests;
                if (shouldApplyNetworkRequest) {
                    i = transportTypeFromNetworkRequest;
                }
                map.put(telephonyNetworkRequest, Integer.valueOf(i));
            }
        }
    }

    /* access modifiers changed from: private */
    public void onSubIdChange() {
        int subIdUsingPhoneId = this.mSubscriptionController.getSubIdUsingPhoneId(this.mPhone.getPhoneId());
        if (this.mSubscriptionId != subIdUsingPhoneId) {
            logl("onSubIdChange " + this.mSubscriptionId + "->" + subIdUsingPhoneId);
            this.mSubscriptionId = subIdUsingPhoneId;
            setCapabilityFilter(makeNetworkFilter(subIdUsingPhoneId));
        }
    }

    public void needNetworkFor(NetworkRequest networkRequest) {
        Message obtainMessage = this.mInternalHandler.obtainMessage(3);
        obtainMessage.obj = networkRequest;
        obtainMessage.sendToTarget();
    }

    /* access modifiers changed from: private */
    public void onNeedNetworkFor(Message message) {
        TelephonyNetworkRequest telephonyNetworkRequest = new TelephonyNetworkRequest((NetworkRequest) message.obj, this.mPhone);
        boolean shouldApplyNetworkRequest = this.mPhoneSwitcher.shouldApplyNetworkRequest(telephonyNetworkRequest, this.mPhone.getPhoneId());
        this.mNetworkRequests.put(telephonyNetworkRequest, Integer.valueOf(shouldApplyNetworkRequest ? getTransportTypeFromNetworkRequest(telephonyNetworkRequest) : -1));
        logl("onNeedNetworkFor " + telephonyNetworkRequest + " shouldApply " + shouldApplyNetworkRequest);
        if (shouldApplyNetworkRequest || mtkIgnoreCapabilityCheck(telephonyNetworkRequest, 1)) {
            requestNetworkInternal(telephonyNetworkRequest, 1, getTransportTypeFromNetworkRequest(telephonyNetworkRequest), (Message) null);
        }
    }

    public void releaseNetworkFor(NetworkRequest networkRequest) {
        Message obtainMessage = this.mInternalHandler.obtainMessage(4);
        obtainMessage.obj = networkRequest;
        obtainMessage.sendToTarget();
    }

    /* access modifiers changed from: private */
    public void onReleaseNetworkFor(Message message) {
        TelephonyNetworkRequest telephonyNetworkRequest = new TelephonyNetworkRequest((NetworkRequest) message.obj, this.mPhone);
        boolean z = this.mNetworkRequests.get(telephonyNetworkRequest).intValue() != -1;
        this.mNetworkRequests.remove(telephonyNetworkRequest);
        logl("onReleaseNetworkFor " + telephonyNetworkRequest + " applied " + z);
        if (!z && !mtkIgnoreCapabilityCheck(telephonyNetworkRequest, 2)) {
            return;
        }
        if (this.mPhone.isUsingNewDataStack()) {
            releaseNetworkInternal(telephonyNetworkRequest);
            return;
        }
        releaseNetworkInternal(telephonyNetworkRequest, 1, 1);
        releaseNetworkInternal(telephonyNetworkRequest, 1, 2);
    }

    /* access modifiers changed from: private */
    public void onDataHandoverNeeded(int i, int i2, TransportManager.HandoverParams handoverParams) {
        log("onDataHandoverNeeded: apnType=" + ApnSetting.getApnTypeString(i) + ", target transport=" + AccessNetworkConstants.transportTypeToString(i2));
        if (this.mAccessNetworksManager.getCurrentTransport(i) == i2) {
            log("APN type " + ApnSetting.getApnTypeString(i) + " is already on " + AccessNetworkConstants.transportTypeToString(i2));
            return;
        }
        boolean z = false;
        for (Map.Entry next : this.mNetworkRequests.entrySet()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) next.getKey();
            int intValue = ((Integer) next.getValue()).intValue();
            boolean z2 = intValue != -1;
            if (ApnContext.getApnTypeFromNetworkRequest(telephonyNetworkRequest.getNativeNetworkRequest()) == i && z2 && intValue != i2) {
                DcTracker dcTracker = this.mPhone.getDcTracker(intValue);
                if (dcTracker != null) {
                    DataConnection dataConnectionByApnType = dcTracker.getDataConnectionByApnType(ApnSetting.getApnTypeString(i));
                    if (dataConnectionByApnType == null || !dataConnectionByApnType.isActive()) {
                        log("The network request is on transport " + AccessNetworkConstants.transportTypeToString(intValue) + ", but no live data connection. Just move the request to transport " + AccessNetworkConstants.transportTypeToString(i2) + ", dc=" + dataConnectionByApnType);
                        next.setValue(Integer.valueOf(i2));
                        releaseNetworkInternal(telephonyNetworkRequest, 1, intValue);
                        requestNetworkInternal(telephonyNetworkRequest, 1, i2, (Message) null);
                    } else {
                        Message obtainMessage = this.mInternalHandler.obtainMessage(6);
                        obtainMessage.getData().putParcelable(DcTracker.DATA_COMPLETE_MSG_EXTRA_NETWORK_REQUEST, telephonyNetworkRequest.getNativeNetworkRequest());
                        this.mPendingHandovers.put(obtainMessage, handoverParams);
                        requestNetworkInternal(telephonyNetworkRequest, 2, i2, obtainMessage);
                        log("Requested handover " + ApnSetting.getApnTypeString(i) + " to " + AccessNetworkConstants.transportTypeToString(i2) + ". " + telephonyNetworkRequest);
                        z = true;
                    }
                } else {
                    log("DcTracker on " + AccessNetworkConstants.transportTypeToString(intValue) + " is not available.");
                }
            }
        }
        if (!z) {
            log("No handover request pending. Handover process is now completed");
            handoverParams.callback.onCompleted(true, false);
        }
    }

    /* access modifiers changed from: private */
    public void onDataHandoverSetupCompleted(NetworkRequest networkRequest, boolean z, int i, boolean z2, TransportManager.HandoverParams handoverParams) {
        log("onDataHandoverSetupCompleted: " + networkRequest + ", success=" + z + ", targetTransport=" + AccessNetworkConstants.transportTypeToString(i) + ", fallback=" + z2);
        TelephonyNetworkRequest telephonyNetworkRequest = new TelephonyNetworkRequest(networkRequest, this.mPhone);
        if (!z2) {
            releaseNetworkInternal(telephonyNetworkRequest, z ? 3 : 2, DataUtils.getSourceTransport(i));
            if (this.mNetworkRequests.containsKey(telephonyNetworkRequest)) {
                this.mNetworkRequests.put(telephonyNetworkRequest, Integer.valueOf(i));
            }
        } else if (!z) {
            releaseNetworkInternal(telephonyNetworkRequest, 1, i);
        }
        handoverParams.callback.onCompleted(z, z2);
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        Rlog.d(this.LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    public void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        String str;
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println("TelephonyNetworkFactory-" + this.mPhone.getPhoneId());
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("Network Requests:");
        indentingPrintWriter.increaseIndent();
        for (Map.Entry next : this.mNetworkRequests.entrySet()) {
            int intValue = ((Integer) next.getValue()).intValue();
            StringBuilder sb = new StringBuilder();
            sb.append((TelephonyNetworkRequest) next.getKey());
            if (intValue != -1) {
                str = " applied on " + intValue;
            } else {
                str = " not applied";
            }
            sb.append(str);
            indentingPrintWriter.println(sb.toString());
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.print("Local logs:");
        indentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.decreaseIndent();
    }
}
