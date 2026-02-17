package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda54 implements Runnable {
    public final /* synthetic */ DataNetworkController.DataNetworkControllerCallback f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda54(DataNetworkController.DataNetworkControllerCallback dataNetworkControllerCallback, int i) {
        this.f$0 = dataNetworkControllerCallback;
        this.f$1 = i;
    }

    public final void run() {
        this.f$0.onDataServiceBound(this.f$1);
    }
}
