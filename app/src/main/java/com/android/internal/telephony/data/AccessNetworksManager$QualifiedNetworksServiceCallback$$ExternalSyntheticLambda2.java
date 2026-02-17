package com.android.internal.telephony.data;

import com.android.internal.telephony.data.AccessNetworksManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda2 implements Runnable {
    public final /* synthetic */ AccessNetworksManager.AccessNetworksManagerCallback f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda2(AccessNetworksManager.AccessNetworksManagerCallback accessNetworksManagerCallback, int i) {
        this.f$0 = accessNetworksManagerCallback;
        this.f$1 = i;
    }

    public final void run() {
        this.f$0.onPreferredTransportChanged(DataUtils.apnTypeToNetworkCapability(this.f$1));
    }
}
