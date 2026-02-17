package com.android.internal.telephony.imsphone;

import android.os.AsyncResult;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsPhone$$ExternalSyntheticLambda6 implements Runnable {
    public final /* synthetic */ ImsPhone f$0;
    public final /* synthetic */ boolean f$1;
    public final /* synthetic */ int f$2;
    public final /* synthetic */ AsyncResult f$3;

    public /* synthetic */ ImsPhone$$ExternalSyntheticLambda6(ImsPhone imsPhone, boolean z, int i, AsyncResult asyncResult) {
        this.f$0 = imsPhone;
        this.f$1 = z;
        this.f$2 = i;
        this.f$3 = asyncResult;
    }

    public final void run() {
        this.f$0.lambda$initiateSilentRedial$0(this.f$1, this.f$2, this.f$3);
    }
}
