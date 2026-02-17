package com.android.internal.telephony.data;

import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.data.DataNetwork;
import java.util.function.BiConsumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataConfigManager$$ExternalSyntheticLambda8 implements BiConsumer {
    public final /* synthetic */ AndroidUtilIndentingPrintWriter f$0;

    public /* synthetic */ DataConfigManager$$ExternalSyntheticLambda8(AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter) {
        this.f$0 = androidUtilIndentingPrintWriter;
    }

    public final void accept(Object obj, Object obj2) {
        this.f$0.println(((String) obj) + ":" + ((DataNetwork.NetworkBandwidth) obj2));
    }
}
