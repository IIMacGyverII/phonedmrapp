package com.android.internal.telephony.ims;

import java.util.concurrent.LinkedBlockingQueue;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda4 implements Runnable {
    public final /* synthetic */ ImsResolver f$0;
    public final /* synthetic */ LinkedBlockingQueue f$1;
    public final /* synthetic */ boolean f$2;
    public final /* synthetic */ int f$3;
    public final /* synthetic */ int f$4;

    public /* synthetic */ ImsResolver$$ExternalSyntheticLambda4(ImsResolver imsResolver, LinkedBlockingQueue linkedBlockingQueue, boolean z, int i, int i2) {
        this.f$0 = imsResolver;
        this.f$1 = linkedBlockingQueue;
        this.f$2 = z;
        this.f$3 = i;
        this.f$4 = i2;
    }

    public final void run() {
        this.f$0.lambda$getImsServiceConfiguration$3(this.f$1, this.f$2, this.f$3, this.f$4);
    }
}
