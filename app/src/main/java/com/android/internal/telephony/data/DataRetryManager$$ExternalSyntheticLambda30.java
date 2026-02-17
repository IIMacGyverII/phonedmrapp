package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda30 implements Consumer {
    public final /* synthetic */ DataRetryManager.DataHandoverRetryEntry f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda30(DataRetryManager.DataHandoverRetryEntry dataHandoverRetryEntry) {
        this.f$0 = dataHandoverRetryEntry;
    }

    public final void accept(Object obj) {
        ((DataRetryManager.DataRetryManagerCallback) obj).invokeFromExecutor(new DataRetryManager$$ExternalSyntheticLambda27((DataRetryManager.DataRetryManagerCallback) obj, this.f$0));
    }
}
