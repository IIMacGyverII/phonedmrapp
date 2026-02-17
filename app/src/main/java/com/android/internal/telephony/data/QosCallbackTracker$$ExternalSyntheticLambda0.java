package com.android.internal.telephony.data;

import java.util.List;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class QosCallbackTracker$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ QosCallbackTracker f$0;
    public final /* synthetic */ List f$1;

    public /* synthetic */ QosCallbackTracker$$ExternalSyntheticLambda0(QosCallbackTracker qosCallbackTracker, List list) {
        this.f$0 = qosCallbackTracker;
        this.f$1 = list;
    }

    public final void run() {
        this.f$0.lambda$updateSessions$2(this.f$1);
    }
}
