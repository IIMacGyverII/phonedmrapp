package com.android.internal.telephony.data;

import android.net.QosFilter;
import com.android.internal.telephony.data.TelephonyNetworkAgent;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkAgent$$ExternalSyntheticLambda6 implements Runnable {
    public final /* synthetic */ TelephonyNetworkAgent.TelephonyNetworkAgentCallback f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ QosFilter f$2;

    public /* synthetic */ TelephonyNetworkAgent$$ExternalSyntheticLambda6(TelephonyNetworkAgent.TelephonyNetworkAgentCallback telephonyNetworkAgentCallback, int i, QosFilter qosFilter) {
        this.f$0 = telephonyNetworkAgentCallback;
        this.f$1 = i;
        this.f$2 = qosFilter;
    }

    public final void run() {
        this.f$0.onQosCallbackRegistered(this.f$1, this.f$2);
    }
}
