package com.android.internal.telephony.ims;

import java.util.concurrent.CountDownLatch;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsServiceController$$ExternalSyntheticLambda3 implements Consumer {
    public final /* synthetic */ CountDownLatch f$0;

    public /* synthetic */ ImsServiceController$$ExternalSyntheticLambda3(CountDownLatch countDownLatch) {
        this.f$0 = countDownLatch;
    }

    public final void accept(Object obj) {
        ImsServiceController.lambda$grantPermissionsToService$3(this.f$0, (Boolean) obj);
    }
}
