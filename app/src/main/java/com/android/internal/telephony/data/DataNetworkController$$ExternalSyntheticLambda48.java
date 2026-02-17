package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda48 implements Consumer {
    public final /* synthetic */ int f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda48(int i) {
        this.f$0 = i;
    }

    public final void accept(Object obj) {
        ((DataNetworkController.DataNetworkControllerCallback) obj).invokeFromExecutor(new DataNetworkController$$ExternalSyntheticLambda46((DataNetworkController.DataNetworkControllerCallback) obj, this.f$0));
    }
}
