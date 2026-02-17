package com.android.internal.telephony.imsphone;

import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsPhoneCallTracker$$ExternalSyntheticLambda3 implements Consumer {
    public final /* synthetic */ ImsPhoneCallTracker f$0;

    public /* synthetic */ ImsPhoneCallTracker$$ExternalSyntheticLambda3(ImsPhoneCallTracker imsPhoneCallTracker) {
        this.f$0 = imsPhoneCallTracker;
    }

    public final void accept(Object obj) {
        this.f$0.lambda$hangupAllConnections$1((ImsPhoneConnection) obj);
    }
}
