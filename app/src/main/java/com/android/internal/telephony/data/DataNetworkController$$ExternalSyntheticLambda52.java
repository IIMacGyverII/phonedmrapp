package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;
import java.util.List;
import java.util.stream.Collectors;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda52 implements Runnable {
    public final /* synthetic */ DataNetworkController.DataNetworkControllerCallback f$0;
    public final /* synthetic */ List f$1;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda52(DataNetworkController.DataNetworkControllerCallback dataNetworkControllerCallback, List list) {
        this.f$0 = dataNetworkControllerCallback;
        this.f$1 = list;
    }

    public final void run() {
        this.f$0.onInternetDataNetworkConnected((List) this.f$1.stream().map(new DataNetworkController$$ExternalSyntheticLambda9()).collect(Collectors.toList()));
    }
}
