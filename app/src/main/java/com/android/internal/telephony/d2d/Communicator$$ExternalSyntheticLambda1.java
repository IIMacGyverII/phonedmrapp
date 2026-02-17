package com.android.internal.telephony.d2d;

import java.util.Optional;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class Communicator$$ExternalSyntheticLambda1 implements Predicate {
    public final /* synthetic */ Optional f$0;

    public /* synthetic */ Communicator$$ExternalSyntheticLambda1(Optional optional) {
        this.f$0 = optional;
    }

    public final boolean test(Object obj) {
        return Communicator.lambda$setTransportActive$3(this.f$0, (TransportProtocol) obj);
    }
}
