package com.android.internal.telephony;

import com.android.internal.telephony.SignalStrengthController;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SignalStrengthController$$ExternalSyntheticLambda3 implements Predicate {
    public final /* synthetic */ int f$0;

    public /* synthetic */ SignalStrengthController$$ExternalSyntheticLambda3(int i) {
        this.f$0 = i;
    }

    public final boolean test(Object obj) {
        return SignalStrengthController.lambda$updateAlwaysReportSignalStrength$3(this.f$0, (SignalStrengthController.SignalRequestRecord) obj);
    }
}
