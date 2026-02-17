package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetwork;
import com.android.internal.telephony.data.DataNetworkController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$DisconnectedState$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ DataNetwork.DisconnectedState f$0;
    public final /* synthetic */ DataNetworkController.NetworkRequestList f$1;

    public /* synthetic */ DataNetwork$DisconnectedState$$ExternalSyntheticLambda1(DataNetwork.DisconnectedState disconnectedState, DataNetworkController.NetworkRequestList networkRequestList) {
        this.f$0 = disconnectedState;
        this.f$1 = networkRequestList;
    }

    public final void run() {
        this.f$0.lambda$enter$1(this.f$1);
    }
}
