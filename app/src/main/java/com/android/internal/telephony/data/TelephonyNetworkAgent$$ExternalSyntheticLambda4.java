package com.android.internal.telephony.data;

import android.net.KeepalivePacketData;
import com.android.internal.telephony.data.TelephonyNetworkAgent;
import java.time.Duration;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkAgent$$ExternalSyntheticLambda4 implements Consumer {
    public final /* synthetic */ int f$0;
    public final /* synthetic */ Duration f$1;
    public final /* synthetic */ KeepalivePacketData f$2;

    public /* synthetic */ TelephonyNetworkAgent$$ExternalSyntheticLambda4(int i, Duration duration, KeepalivePacketData keepalivePacketData) {
        this.f$0 = i;
        this.f$1 = duration;
        this.f$2 = keepalivePacketData;
    }

    public final void accept(Object obj) {
        ((TelephonyNetworkAgent.TelephonyNetworkAgentCallback) obj).invokeFromExecutor(new TelephonyNetworkAgent$$ExternalSyntheticLambda7((TelephonyNetworkAgent.TelephonyNetworkAgentCallback) obj, this.f$0, this.f$1, this.f$2));
    }
}
