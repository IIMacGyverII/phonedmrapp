package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ DataRetryManager.DataRetryManagerCallback f$0;
    public final /* synthetic */ DataNetwork f$1;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda0(DataRetryManager.DataRetryManagerCallback dataRetryManagerCallback, DataNetwork dataNetwork) {
        this.f$0 = dataRetryManagerCallback;
        this.f$1 = dataNetwork;
    }

    public final void run() {
        this.f$0.onDataNetworkHandoverRetryStopped(this.f$1);
    }
}
