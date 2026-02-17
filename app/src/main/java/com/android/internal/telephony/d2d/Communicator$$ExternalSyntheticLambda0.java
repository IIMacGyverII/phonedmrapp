package com.android.internal.telephony.d2d;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class Communicator$$ExternalSyntheticLambda0 implements Predicate {
    public final /* synthetic */ String f$0;

    public /* synthetic */ Communicator$$ExternalSyntheticLambda0(String str) {
        this.f$0 = str;
    }

    public final boolean test(Object obj) {
        return ((TransportProtocol) obj).getClass().getSimpleName().equals(this.f$0);
    }
}
