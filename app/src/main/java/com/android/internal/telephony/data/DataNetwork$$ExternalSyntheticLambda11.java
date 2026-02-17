package com.android.internal.telephony.data;

import android.net.NetworkCapabilities;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$$ExternalSyntheticLambda11 implements Consumer {
    public final /* synthetic */ NetworkCapabilities.Builder f$0;

    public /* synthetic */ DataNetwork$$ExternalSyntheticLambda11(NetworkCapabilities.Builder builder) {
        this.f$0 = builder;
    }

    public final void accept(Object obj) {
        this.f$0.addCapability(((Integer) obj).intValue());
    }
}
