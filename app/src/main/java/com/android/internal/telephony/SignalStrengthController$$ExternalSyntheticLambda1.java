package com.android.internal.telephony;

import com.android.internal.telephony.SignalStrengthController;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SignalStrengthController$$ExternalSyntheticLambda1 implements Predicate {
    public final /* synthetic */ SignalStrengthController.SignalRequestRecord f$0;

    public /* synthetic */ SignalStrengthController$$ExternalSyntheticLambda1(SignalStrengthController.SignalRequestRecord signalRequestRecord) {
        this.f$0 = signalRequestRecord;
    }

    public final boolean test(Object obj) {
        return SignalStrengthController.lambda$handleMessage$0(this.f$0, (SignalStrengthController.SignalRequestRecord) obj);
    }
}
