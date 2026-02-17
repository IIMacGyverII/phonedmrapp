package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda27 implements Runnable {
    public final /* synthetic */ DataRetryManager.DataRetryManagerCallback f$0;
    public final /* synthetic */ DataRetryManager.DataHandoverRetryEntry f$1;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda27(DataRetryManager.DataRetryManagerCallback dataRetryManagerCallback, DataRetryManager.DataHandoverRetryEntry dataHandoverRetryEntry) {
        this.f$0 = dataRetryManagerCallback;
        this.f$1 = dataHandoverRetryEntry;
    }

    public final void run() {
        this.f$0.onDataNetworkHandoverRetry(this.f$1);
    }
}
