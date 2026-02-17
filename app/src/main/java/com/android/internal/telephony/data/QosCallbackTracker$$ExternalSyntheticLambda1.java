package com.android.internal.telephony.data;

import com.android.internal.telephony.data.QosCallbackTracker;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class QosCallbackTracker$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ QosCallbackTracker f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ QosCallbackTracker.IFilter f$2;

    public /* synthetic */ QosCallbackTracker$$ExternalSyntheticLambda1(QosCallbackTracker qosCallbackTracker, int i, QosCallbackTracker.IFilter iFilter) {
        this.f$0 = qosCallbackTracker;
        this.f$1 = i;
        this.f$2 = iFilter;
    }

    public final void run() {
        this.f$0.lambda$addFilter$0(this.f$1, this.f$2);
    }
}
