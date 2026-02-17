package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda14 implements Function {
    public final Object apply(Object obj) {
        return DataUtils.networkCapabilitiesToString(((TelephonyNetworkRequest) ((DataNetworkController.NetworkRequestList) obj).get(0)).getCapabilities());
    }
}
