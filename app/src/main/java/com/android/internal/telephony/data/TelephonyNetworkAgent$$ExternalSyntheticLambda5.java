package com.android.internal.telephony.data;

import com.android.internal.telephony.data.TelephonyNetworkAgent;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkAgent$$ExternalSyntheticLambda5 implements Runnable {
    public final /* synthetic */ TelephonyNetworkAgent.TelephonyNetworkAgentCallback f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ TelephonyNetworkAgent$$ExternalSyntheticLambda5(TelephonyNetworkAgent.TelephonyNetworkAgentCallback telephonyNetworkAgentCallback, int i) {
        this.f$0 = telephonyNetworkAgentCallback;
        this.f$1 = i;
    }

    public final void run() {
        this.f$0.onQosCallbackUnregistered(this.f$1);
    }
}
