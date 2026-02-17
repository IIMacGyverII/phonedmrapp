package com.android.internal.telephony.data;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda3 implements Runnable {
    public final /* synthetic */ DataRetryManager f$0;
    public final /* synthetic */ DataNetwork f$1;
    public final /* synthetic */ int f$2;
    public final /* synthetic */ long f$3;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda3(DataRetryManager dataRetryManager, DataNetwork dataNetwork, int i, long j) {
        this.f$0 = dataRetryManager;
        this.f$1 = dataNetwork;
        this.f$2 = i;
        this.f$3 = j;
    }

    public final void run() {
        this.f$0.lambda$evaluateDataHandoverRetry$5(this.f$1, this.f$2, this.f$3);
    }
}
