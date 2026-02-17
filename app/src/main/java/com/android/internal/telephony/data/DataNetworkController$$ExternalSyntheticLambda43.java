package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;
import java.util.List;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda43 implements Consumer {
    public final /* synthetic */ List f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda43(List list) {
        this.f$0 = list;
    }

    public final void accept(Object obj) {
        ((DataNetworkController.DataNetworkControllerCallback) obj).invokeFromExecutor(new DataNetworkController$$ExternalSyntheticLambda52((DataNetworkController.DataNetworkControllerCallback) obj, this.f$0));
    }
}
