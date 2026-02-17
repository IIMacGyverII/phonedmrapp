package com.android.internal.telephony.dataconnection;

import java.util.List;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DcNetworkAgent$$ExternalSyntheticLambda2 implements Runnable {
    public final /* synthetic */ DcNetworkAgent f$0;
    public final /* synthetic */ List f$1;

    public /* synthetic */ DcNetworkAgent$$ExternalSyntheticLambda2(DcNetworkAgent dcNetworkAgent, List list) {
        this.f$0 = dcNetworkAgent;
        this.f$1 = list;
    }

    public final void run() {
        this.f$0.lambda$updateQosBearerSessions$2(this.f$1);
    }
}
