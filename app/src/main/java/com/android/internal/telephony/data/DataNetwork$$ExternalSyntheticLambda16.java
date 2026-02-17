package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$$ExternalSyntheticLambda16 implements Runnable {
    public final /* synthetic */ DataNetwork f$0;
    public final /* synthetic */ DataNetworkController.NetworkRequestList f$1;

    public /* synthetic */ DataNetwork$$ExternalSyntheticLambda16(DataNetwork dataNetwork, DataNetworkController.NetworkRequestList networkRequestList) {
        this.f$0 = dataNetwork;
        this.f$1 = networkRequestList;
    }

    public final void run() {
        this.f$0.lambda$onAttachNetworkRequests$0(this.f$1);
    }
}
