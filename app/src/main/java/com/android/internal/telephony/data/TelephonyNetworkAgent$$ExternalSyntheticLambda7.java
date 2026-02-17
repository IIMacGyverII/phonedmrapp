package com.android.internal.telephony.data;

import android.net.KeepalivePacketData;
import com.android.internal.telephony.data.TelephonyNetworkAgent;
import java.time.Duration;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkAgent$$ExternalSyntheticLambda7 implements Runnable {
    public final /* synthetic */ TelephonyNetworkAgent.TelephonyNetworkAgentCallback f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ Duration f$2;
    public final /* synthetic */ KeepalivePacketData f$3;

    public /* synthetic */ TelephonyNetworkAgent$$ExternalSyntheticLambda7(TelephonyNetworkAgent.TelephonyNetworkAgentCallback telephonyNetworkAgentCallback, int i, Duration duration, KeepalivePacketData keepalivePacketData) {
        this.f$0 = telephonyNetworkAgentCallback;
        this.f$1 = i;
        this.f$2 = duration;
        this.f$3 = keepalivePacketData;
    }

    public final void run() {
        this.f$0.onStartSocketKeepalive(this.f$1, this.f$2, this.f$3);
    }
}
