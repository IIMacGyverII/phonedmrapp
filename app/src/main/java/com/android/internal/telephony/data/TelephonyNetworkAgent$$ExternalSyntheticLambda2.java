package com.android.internal.telephony.data;

import com.android.internal.telephony.data.TelephonyNetworkAgent;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkAgent$$ExternalSyntheticLambda2 implements Consumer {
    public final /* synthetic */ int f$0;

    public /* synthetic */ TelephonyNetworkAgent$$ExternalSyntheticLambda2(int i) {
        this.f$0 = i;
    }

    public final void accept(Object obj) {
        ((TelephonyNetworkAgent.TelephonyNetworkAgentCallback) obj).invokeFromExecutor(new TelephonyNetworkAgent$$ExternalSyntheticLambda0((TelephonyNetworkAgent.TelephonyNetworkAgentCallback) obj, this.f$0));
    }
}
