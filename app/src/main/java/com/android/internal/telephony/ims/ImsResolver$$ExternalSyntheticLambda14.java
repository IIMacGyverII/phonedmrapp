package com.android.internal.telephony.ims;

import java.util.concurrent.CompletableFuture;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda14 implements Runnable {
    public final /* synthetic */ ImsResolver f$0;
    public final /* synthetic */ CompletableFuture f$1;
    public final /* synthetic */ int f$2;
    public final /* synthetic */ int f$3;

    public /* synthetic */ ImsResolver$$ExternalSyntheticLambda14(ImsResolver imsResolver, CompletableFuture completableFuture, int i, int i2) {
        this.f$0 = imsResolver;
        this.f$1 = completableFuture;
        this.f$2 = i;
        this.f$3 = i2;
    }

    public final void run() {
        this.f$0.lambda$getConfiguredImsServicePackageName$4(this.f$1, this.f$2, this.f$3);
    }
}
