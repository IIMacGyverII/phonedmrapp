package com.android.internal.telephony.data;

import android.net.QosFilter;
import com.android.internal.telephony.data.TelephonyNetworkAgent;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkAgent$$ExternalSyntheticLambda9 implements Consumer {
    public final /* synthetic */ int f$0;
    public final /* synthetic */ QosFilter f$1;

    public /* synthetic */ TelephonyNetworkAgent$$ExternalSyntheticLambda9(int i, QosFilter qosFilter) {
        this.f$0 = i;
        this.f$1 = qosFilter;
    }

    public final void accept(Object obj) {
        ((TelephonyNetworkAgent.TelephonyNetworkAgentCallback) obj).invokeFromExecutor(new TelephonyNetworkAgent$$ExternalSyntheticLambda6((TelephonyNetworkAgent.TelephonyNetworkAgentCallback) obj, this.f$0, this.f$1));
    }
}
