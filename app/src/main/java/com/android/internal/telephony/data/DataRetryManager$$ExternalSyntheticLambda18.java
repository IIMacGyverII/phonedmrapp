package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.List;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda18 implements Consumer {
    public final /* synthetic */ List f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda18(List list) {
        this.f$0 = list;
    }

    public final void accept(Object obj) {
        ((DataRetryManager.DataRetryManagerCallback) obj).invokeFromExecutor(new DataRetryManager$$ExternalSyntheticLambda22((DataRetryManager.DataRetryManagerCallback) obj, this.f$0));
    }
}
