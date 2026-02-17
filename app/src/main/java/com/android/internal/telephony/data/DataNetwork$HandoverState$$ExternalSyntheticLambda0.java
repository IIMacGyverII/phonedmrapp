package com.android.internal.telephony.data;

import android.telephony.data.DataCallResponse;
import com.android.internal.telephony.data.DataNetwork;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$HandoverState$$ExternalSyntheticLambda0 implements Predicate {
    public final /* synthetic */ DataNetwork.HandoverState f$0;

    public /* synthetic */ DataNetwork$HandoverState$$ExternalSyntheticLambda0(DataNetwork.HandoverState handoverState) {
        this.f$0 = handoverState;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$shouldDeferDataStateChangedEvent$1((DataCallResponse) obj);
    }
}
