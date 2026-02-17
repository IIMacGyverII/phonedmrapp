package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda27 implements Runnable {
    public final /* synthetic */ DataNetworkController f$0;
    public final /* synthetic */ DataNetworkController.DataNetworkControllerCallback f$1;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda27(DataNetworkController dataNetworkController, DataNetworkController.DataNetworkControllerCallback dataNetworkControllerCallback) {
        this.f$0 = dataNetworkController;
        this.f$1 = dataNetworkControllerCallback;
    }

    public final void run() {
        this.f$0.lambda$onPcoDataChanged$42(this.f$1);
    }
}
