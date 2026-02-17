package com.android.internal.telephony.dataconnection;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DcController$$ExternalSyntheticLambda2 implements Predicate {
    public final boolean test(Object obj) {
        return ((DataConnection) obj).getApnContexts().stream().anyMatch(new DcController$$ExternalSyntheticLambda3());
    }
}
