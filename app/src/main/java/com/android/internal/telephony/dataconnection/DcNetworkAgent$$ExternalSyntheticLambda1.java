package com.android.internal.telephony.dataconnection;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DcNetworkAgent$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ DcNetworkAgent f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ DcNetworkAgent$$ExternalSyntheticLambda1(DcNetworkAgent dcNetworkAgent, int i) {
        this.f$0 = dcNetworkAgent;
        this.f$1 = i;
    }

    public final void run() {
        this.f$0.lambda$onQosCallbackUnregistered$1(this.f$1);
    }
}
