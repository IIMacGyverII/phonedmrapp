package com.android.internal.telephony.data;

import android.telephony.data.DataCallResponse;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$$ExternalSyntheticLambda15 implements Predicate {
    public final /* synthetic */ DataNetwork f$0;

    public /* synthetic */ DataNetwork$$ExternalSyntheticLambda15(DataNetwork dataNetwork) {
        this.f$0 = dataNetwork;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$onDataStateChanged$8((DataCallResponse) obj);
    }
}
