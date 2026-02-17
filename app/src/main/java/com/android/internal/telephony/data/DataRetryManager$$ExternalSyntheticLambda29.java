package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda29 implements Consumer {
    public final /* synthetic */ DataRetryManager.DataSetupRetryEntry f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda29(DataRetryManager.DataSetupRetryEntry dataSetupRetryEntry) {
        this.f$0 = dataSetupRetryEntry;
    }

    public final void accept(Object obj) {
        ((DataRetryManager.DataRetryManagerCallback) obj).invokeFromExecutor(new DataRetryManager$$ExternalSyntheticLambda9((DataRetryManager.DataRetryManagerCallback) obj, this.f$0));
    }
}
