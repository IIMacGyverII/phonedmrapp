package com.android.internal.telephony;

import android.net.NetworkRequest;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class NetworkFactoryLegacyImpl$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ NetworkFactoryLegacyImpl f$0;
    public final /* synthetic */ NetworkRequest f$1;

    public /* synthetic */ NetworkFactoryLegacyImpl$$ExternalSyntheticLambda1(NetworkFactoryLegacyImpl networkFactoryLegacyImpl, NetworkRequest networkRequest) {
        this.f$0 = networkFactoryLegacyImpl;
        this.f$1 = networkRequest;
    }

    public final void run() {
        this.f$0.lambda$releaseRequestAsUnfulfillableByAnyFactory$0(this.f$1);
    }
}
