package com.android.internal.telephony.data;

import android.telephony.SubscriptionPlan;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetworkController$$ExternalSyntheticLambda59 implements Consumer {
    public final /* synthetic */ AndroidUtilIndentingPrintWriter f$0;

    public /* synthetic */ DataNetworkController$$ExternalSyntheticLambda59(AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter) {
        this.f$0 = androidUtilIndentingPrintWriter;
    }

    public final void accept(Object obj) {
        this.f$0.println((SubscriptionPlan) obj);
    }
}
