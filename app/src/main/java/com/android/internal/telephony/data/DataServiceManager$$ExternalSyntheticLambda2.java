package com.android.internal.telephony.data;

import java.util.concurrent.CountDownLatch;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataServiceManager$$ExternalSyntheticLambda2 implements Consumer {
    public final /* synthetic */ DataServiceManager f$0;
    public final /* synthetic */ CountDownLatch f$1;

    public /* synthetic */ DataServiceManager$$ExternalSyntheticLambda2(DataServiceManager dataServiceManager, CountDownLatch countDownLatch) {
        this.f$0 = dataServiceManager;
        this.f$1 = countDownLatch;
    }

    public final void accept(Object obj) {
        this.f$0.lambda$grantPermissionsToService$0(this.f$1, (Boolean) obj);
    }
}
