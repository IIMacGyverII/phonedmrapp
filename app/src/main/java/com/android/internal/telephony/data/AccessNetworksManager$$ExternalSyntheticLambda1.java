package com.android.internal.telephony.data;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$$ExternalSyntheticLambda1 implements Executor {
    public final /* synthetic */ AccessNetworksManager f$0;

    public /* synthetic */ AccessNetworksManager$$ExternalSyntheticLambda1(AccessNetworksManager accessNetworksManager) {
        this.f$0 = accessNetworksManager;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
