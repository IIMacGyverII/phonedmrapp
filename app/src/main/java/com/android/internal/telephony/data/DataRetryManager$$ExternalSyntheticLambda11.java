package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.List;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda11 implements Runnable {
    public final /* synthetic */ DataRetryManager.DataRetryManagerCallback f$0;
    public final /* synthetic */ List f$1;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda11(DataRetryManager.DataRetryManagerCallback dataRetryManagerCallback, List list) {
        this.f$0 = dataRetryManagerCallback;
        this.f$1 = list;
    }

    public final void run() {
        this.f$0.onThrottleStatusChanged(this.f$1);
    }
}
