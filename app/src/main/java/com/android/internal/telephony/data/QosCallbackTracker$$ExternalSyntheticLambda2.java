package com.android.internal.telephony.data;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class QosCallbackTracker$$ExternalSyntheticLambda2 implements Runnable {
    public final /* synthetic */ QosCallbackTracker f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ QosCallbackTracker$$ExternalSyntheticLambda2(QosCallbackTracker qosCallbackTracker, int i) {
        this.f$0 = qosCallbackTracker;
        this.f$1 = i;
    }

    public final void run() {
        this.f$0.lambda$removeFilter$1(this.f$1);
    }
}
