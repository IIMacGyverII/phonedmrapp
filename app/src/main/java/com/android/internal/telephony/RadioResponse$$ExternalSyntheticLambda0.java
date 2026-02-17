package com.android.internal.telephony;

import android.os.Message;
import android.telephony.NetworkScanRequest;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RadioResponse$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ RadioResponse f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ NetworkScanRequest f$2;
    public final /* synthetic */ Message f$3;

    public /* synthetic */ RadioResponse$$ExternalSyntheticLambda0(RadioResponse radioResponse, int i, NetworkScanRequest networkScanRequest, Message message) {
        this.f$0 = radioResponse;
        this.f$1 = i;
        this.f$2 = networkScanRequest;
        this.f$3 = message;
    }

    public final void run() {
        this.f$0.lambda$responseScanStatus$2(this.f$1, this.f$2, this.f$3);
    }
}
