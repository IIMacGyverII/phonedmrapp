package com.android.internal.telephony.data;

import com.android.internal.telephony.data.AccessNetworksManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ AccessNetworksManager.AccessNetworksManagerCallback f$0;
    public final /* synthetic */ AccessNetworksManager.QualifiedNetworks f$1;

    public /* synthetic */ AccessNetworksManager$$ExternalSyntheticLambda0(AccessNetworksManager.AccessNetworksManagerCallback accessNetworksManagerCallback, AccessNetworksManager.QualifiedNetworks qualifiedNetworks) {
        this.f$0 = accessNetworksManagerCallback;
        this.f$1 = qualifiedNetworks;
    }

    public final void run() {
        this.f$0.onPreferredTransportChanged(DataUtils.apnTypeToNetworkCapability(this.f$1.apnType));
    }
}
