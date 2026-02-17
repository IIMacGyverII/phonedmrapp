package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda9 implements Runnable {
    public final /* synthetic */ DataRetryManager.DataRetryManagerCallback f$0;
    public final /* synthetic */ DataRetryManager.DataSetupRetryEntry f$1;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda9(DataRetryManager.DataRetryManagerCallback dataRetryManagerCallback, DataRetryManager.DataSetupRetryEntry dataSetupRetryEntry) {
        this.f$0 = dataRetryManagerCallback;
        this.f$1 = dataSetupRetryEntry;
    }

    public final void run() {
        this.f$0.onDataNetworkSetupRetry(this.f$1);
    }
}
