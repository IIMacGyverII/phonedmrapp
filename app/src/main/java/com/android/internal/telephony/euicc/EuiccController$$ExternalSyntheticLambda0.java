package com.android.internal.telephony.euicc;

import android.app.PendingIntent;
import android.content.Intent;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccController$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ EuiccController f$0;
    public final /* synthetic */ PendingIntent f$1;
    public final /* synthetic */ int f$2;
    public final /* synthetic */ Intent f$3;

    public /* synthetic */ EuiccController$$ExternalSyntheticLambda0(EuiccController euiccController, PendingIntent pendingIntent, int i, Intent intent) {
        this.f$0 = euiccController;
        this.f$1 = pendingIntent;
        this.f$2 = i;
        this.f$3 = intent;
    }

    public final void run() {
        this.f$0.lambda$refreshSubscriptionsAndSendResult$0(this.f$1, this.f$2, this.f$3);
    }
}
