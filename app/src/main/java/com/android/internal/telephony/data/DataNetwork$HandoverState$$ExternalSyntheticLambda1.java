package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetwork;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$HandoverState$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ DataNetwork.HandoverState f$0;
    public final /* synthetic */ long f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ DataNetwork$HandoverState$$ExternalSyntheticLambda1(DataNetwork.HandoverState handoverState, long j, int i) {
        this.f$0 = handoverState;
        this.f$1 = j;
        this.f$2 = i;
    }

    public final void run() {
        this.f$0.lambda$processMessage$0(this.f$1, this.f$2);
    }
}
