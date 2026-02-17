package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataNetworkController;
import java.util.Comparator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataUtils$$ExternalSyntheticLambda3 implements Comparator {
    public final int compare(Object obj, Object obj2) {
        return Integer.compare(((TelephonyNetworkRequest) ((DataNetworkController.NetworkRequestList) obj2).get(0)).getPriority(), ((TelephonyNetworkRequest) ((DataNetworkController.NetworkRequestList) obj).get(0)).getPriority());
    }
}
