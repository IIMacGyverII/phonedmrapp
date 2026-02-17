package com.android.internal.telephony.data;

import com.android.internal.telephony.data.AccessNetworksManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda1 implements Consumer {
    public final /* synthetic */ int f$0;

    public /* synthetic */ AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda1(int i) {
        this.f$0 = i;
    }

    public final void accept(Object obj) {
        ((AccessNetworksManager.AccessNetworksManagerCallback) obj).invokeFromExecutor(new AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda2((AccessNetworksManager.AccessNetworksManagerCallback) obj, this.f$0));
    }
}
