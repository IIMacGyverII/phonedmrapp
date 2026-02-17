package com.android.internal.telephony.data;

import android.net.KeepalivePacketData;
import android.net.NetworkAgent;
import android.net.NetworkAgentConfig;
import android.net.NetworkProvider;
import android.net.NetworkScore;
import android.net.QosFilter;
import android.net.QosSessionAttributes;
import android.net.Uri;
import android.os.Looper;
import android.util.ArraySet;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.time.Duration;
import java.util.Set;
import java.util.concurrent.Executor;

public class TelephonyNetworkAgent extends NetworkAgent implements NotifyQosSessionInterface {
    private boolean mAbandoned = false;
    private final DataNetwork mDataNetwork;
    private final int mId;
    private final LocalLog mLocalLog = new LocalLog(128);
    private final String mLogTag;
    private final NetworkAgentConfig mNetworkAgentConfig;
    private final Phone mPhone;
    private final Set<TelephonyNetworkAgentCallback> mTelephonyNetworkAgentCallbacks;

    public static abstract class TelephonyNetworkAgentCallback extends DataCallback {
        public void onQosCallbackRegistered(int i, QosFilter qosFilter) {
        }

        public void onQosCallbackUnregistered(int i) {
        }

        public void onStartSocketKeepalive(int i, Duration duration, KeepalivePacketData keepalivePacketData) {
        }

        public void onStopSocketKeepalive(int i) {
        }

        public void onValidationStatus(int i, Uri uri) {
        }

        public TelephonyNetworkAgentCallback(Executor executor) {
            super(executor);
        }
    }

    /* JADX INFO: super call moved to the top of the method (can break code semantics) */
    public TelephonyNetworkAgent(Phone phone, Looper looper, DataNetwork dataNetwork, NetworkScore networkScore, NetworkAgentConfig networkAgentConfig, NetworkProvider networkProvider, TelephonyNetworkAgentCallback telephonyNetworkAgentCallback) {
        super(phone.getContext(), looper, "TelephonyNetworkAgent", dataNetwork.getNetworkCapabilities(), dataNetwork.getLinkProperties(), networkScore, networkAgentConfig, networkProvider);
        ArraySet arraySet = new ArraySet();
        this.mTelephonyNetworkAgentCallbacks = arraySet;
        register();
        this.mDataNetwork = dataNetwork;
        this.mNetworkAgentConfig = networkAgentConfig;
        arraySet.add(telephonyNetworkAgentCallback);
        this.mPhone = phone;
        int netId = getNetwork().getNetId();
        this.mId = netId;
        this.mLogTag = "TNA-" + netId;
        StringBuilder sb = new StringBuilder();
        sb.append("TelephonyNetworkAgent created, nc=");
        sb.append(dataNetwork.getNetworkCapabilities());
        sb.append(", score=");
        NetworkScore networkScore2 = networkScore;
        sb.append(networkScore);
        log(sb.toString());
    }

    public void onNetworkUnwanted() {
        if (this.mAbandoned) {
            log("The agent is already abandoned. Ignored onNetworkUnwanted.");
        } else {
            this.mDataNetwork.lambda$tearDownWhenConditionMet$7(1);
        }
    }

    public int getId() {
        return this.mId;
    }

    public void onValidationStatus(int i, Uri uri) {
        if (this.mAbandoned) {
            log("The agent is already abandoned. Ignored onValidationStatus.");
        } else {
            this.mTelephonyNetworkAgentCallbacks.forEach(new TelephonyNetworkAgent$$ExternalSyntheticLambda8(i, uri));
        }
    }

    public void onBandwidthUpdateRequested() {
        loge("onBandwidthUpdateRequested: RIL.pullLceData is not supported anymore.");
    }

    public void onStartSocketKeepalive(int i, Duration duration, KeepalivePacketData keepalivePacketData) {
        if (this.mAbandoned) {
            log("The agent is already abandoned. Ignored onStartSocketKeepalive.");
        } else {
            this.mTelephonyNetworkAgentCallbacks.forEach(new TelephonyNetworkAgent$$ExternalSyntheticLambda4(i, duration, keepalivePacketData));
        }
    }

    public void onStopSocketKeepalive(int i) {
        if (this.mAbandoned) {
            log("The agent is already abandoned. Ignored onStopSocketKeepalive.");
        } else {
            this.mTelephonyNetworkAgentCallbacks.forEach(new TelephonyNetworkAgent$$ExternalSyntheticLambda2(i));
        }
    }

    public void onQosCallbackRegistered(int i, QosFilter qosFilter) {
        if (this.mAbandoned) {
            log("The agent is already abandoned. Ignored onQosCallbackRegistered.");
        } else {
            this.mTelephonyNetworkAgentCallbacks.forEach(new TelephonyNetworkAgent$$ExternalSyntheticLambda9(i, qosFilter));
        }
    }

    public void onQosCallbackUnregistered(int i) {
        if (this.mAbandoned) {
            log("The agent is already abandoned. Ignored onQosCallbackUnregistered.");
        } else {
            this.mTelephonyNetworkAgentCallbacks.forEach(new TelephonyNetworkAgent$$ExternalSyntheticLambda1(i));
        }
    }

    public void notifyQosSessionAvailable(int i, int i2, QosSessionAttributes qosSessionAttributes) {
        TelephonyNetworkAgent.super.sendQosSessionAvailable(i, i2, qosSessionAttributes);
    }

    public void notifyQosSessionLost(int i, int i2, int i3) {
        TelephonyNetworkAgent.super.sendQosSessionLost(i, i2, i3);
    }

    public void abandon() {
        this.mAbandoned = true;
        unregister();
    }

    public void registerCallback(TelephonyNetworkAgentCallback telephonyNetworkAgentCallback) {
        this.mTelephonyNetworkAgentCallbacks.add(telephonyNetworkAgentCallback);
    }

    public void unregisterCallback(TelephonyNetworkAgentCallback telephonyNetworkAgentCallback) {
        this.mTelephonyNetworkAgentCallbacks.remove(telephonyNetworkAgentCallback);
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    private void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(this.mLogTag + ":");
        androidUtilIndentingPrintWriter.increaseIndent();
        androidUtilIndentingPrintWriter.println("Local logs:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.decreaseIndent();
    }
}
