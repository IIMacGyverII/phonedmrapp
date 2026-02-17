package com.android.internal.telephony.data;

import com.android.internal.telephony.dataconnection.DataThrottler;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$$ExternalSyntheticLambda5 implements Runnable {
    public final /* synthetic */ AccessNetworksManager f$0;
    public final /* synthetic */ DataThrottler f$1;

    public /* synthetic */ AccessNetworksManager$$ExternalSyntheticLambda5(AccessNetworksManager accessNetworksManager, DataThrottler dataThrottler) {
        this.f$0 = accessNetworksManager;
        this.f$1 = dataThrottler;
    }

    public final void run() {
        this.f$0.lambda$registerDataThrottler$0(this.f$1);
    }
}
