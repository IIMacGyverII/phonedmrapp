package com.android.internal.telephony;

import android.os.Message;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RadioResponse$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ RadioResponse f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ Message f$2;

    public /* synthetic */ RadioResponse$$ExternalSyntheticLambda1(RadioResponse radioResponse, int i, Message message) {
        this.f$0 = radioResponse;
        this.f$1 = i;
        this.f$2 = message;
    }

    public final void run() {
        this.f$0.lambda$getDataRegistrationStateResponse_1_5$1(this.f$1, this.f$2);
    }
}
