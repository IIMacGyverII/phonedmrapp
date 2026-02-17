package com.android.internal.telephony.data;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda32 implements Predicate {
    public final /* synthetic */ String f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda32(String str) {
        this.f$0 = str;
    }

    public final boolean test(Object obj) {
        return this.f$0.equals(((DataNetwork) obj).getLinkProperties().getInterfaceName());
    }
}
