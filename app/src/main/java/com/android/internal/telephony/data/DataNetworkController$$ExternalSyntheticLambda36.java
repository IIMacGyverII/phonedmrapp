package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda36 implements Runnable {
    public final /* synthetic */ DataNetworkController.DataNetworkControllerCallback f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda36(DataNetworkController.DataNetworkControllerCallback dataNetworkControllerCallback) {
        this.f$0 = dataNetworkControllerCallback;
    }

    public final void run() {
        this.f$0.onAnyDataNetworkExistingChanged(false);
    }
}
