package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda26 implements Consumer {
    public final /* synthetic */ DataNetwork f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda26(DataNetwork dataNetwork) {
        this.f$0 = dataNetwork;
    }

    public final void accept(Object obj) {
        ((DataRetryManager.DataRetryManagerCallback) obj).invokeFromExecutor(new DataRetryManager$$ExternalSyntheticLambda0((DataRetryManager.DataRetryManagerCallback) obj, this.f$0));
    }
}
