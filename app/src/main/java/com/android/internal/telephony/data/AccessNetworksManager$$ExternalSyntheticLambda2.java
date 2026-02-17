package com.android.internal.telephony.data;

import com.android.internal.telephony.data.AccessNetworksManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$$ExternalSyntheticLambda2 implements Consumer {
    public final /* synthetic */ AccessNetworksManager.QualifiedNetworks f$0;

    public /* synthetic */ AccessNetworksManager$$ExternalSyntheticLambda2(AccessNetworksManager.QualifiedNetworks qualifiedNetworks) {
        this.f$0 = qualifiedNetworks;
    }

    public final void accept(Object obj) {
        ((AccessNetworksManager.AccessNetworksManagerCallback) obj).invokeFromExecutor(new AccessNetworksManager$$ExternalSyntheticLambda0((AccessNetworksManager.AccessNetworksManagerCallback) obj, this.f$0));
    }
}
