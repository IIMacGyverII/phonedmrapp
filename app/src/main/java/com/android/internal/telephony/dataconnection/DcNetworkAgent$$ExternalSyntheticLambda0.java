package com.android.internal.telephony.dataconnection;

import android.net.QosFilter;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DcNetworkAgent$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ DcNetworkAgent f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ QosFilter f$2;

    public /* synthetic */ DcNetworkAgent$$ExternalSyntheticLambda0(DcNetworkAgent dcNetworkAgent, int i, QosFilter qosFilter) {
        this.f$0 = dcNetworkAgent;
        this.f$1 = i;
        this.f$2 = qosFilter;
    }

    public final void run() {
        this.f$0.lambda$onQosCallbackRegistered$0(this.f$1, this.f$2);
    }
}
