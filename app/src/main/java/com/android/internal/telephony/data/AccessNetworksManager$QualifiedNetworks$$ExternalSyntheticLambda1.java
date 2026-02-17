package com.android.internal.telephony.data;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$QualifiedNetworks$$ExternalSyntheticLambda1 implements Predicate {
    public final boolean test(Object obj) {
        return DataUtils.isValidAccessNetwork(((Integer) obj).intValue());
    }
}
