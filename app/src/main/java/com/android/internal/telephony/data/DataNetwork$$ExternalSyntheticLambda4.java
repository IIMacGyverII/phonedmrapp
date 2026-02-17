package com.android.internal.telephony.data;

import android.net.LinkAddress;
import java.util.Objects;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$$ExternalSyntheticLambda4 implements Function {
    public final Object apply(Object obj) {
        return Integer.valueOf(Objects.hash(new Object[]{((LinkAddress) obj).getAddress(), Integer.valueOf(((LinkAddress) obj).getPrefixLength()), Integer.valueOf(((LinkAddress) obj).getScope())}));
    }
}
