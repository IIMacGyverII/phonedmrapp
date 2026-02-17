package com.android.internal.telephony.data;

import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataConfigManager$$ExternalSyntheticLambda4 implements Consumer {
    public final /* synthetic */ AndroidUtilIndentingPrintWriter f$0;

    public /* synthetic */ DataConfigManager$$ExternalSyntheticLambda4(AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter) {
        this.f$0 = androidUtilIndentingPrintWriter;
    }

    public final void accept(Object obj) {
        this.f$0.println((DataRetryManager.DataSetupRetryRule) obj);
    }
}
