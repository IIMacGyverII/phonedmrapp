package com.android.internal.telephony.nitz;

import com.android.internal.telephony.NitzSignal;
import com.android.internal.telephony.NitzStateMachine;
import com.android.internal.telephony.nitz.NitzSignalInputFilterPredicateFactory;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda1 implements NitzSignalInputFilterPredicateFactory.TrivalentPredicate {
    public final /* synthetic */ NitzStateMachine.DeviceState f$0;

    public /* synthetic */ NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda1(NitzStateMachine.DeviceState deviceState) {
        this.f$0 = deviceState;
    }

    public final Boolean mustProcessNitzSignal(NitzSignal nitzSignal, NitzSignal nitzSignal2) {
        return NitzSignalInputFilterPredicateFactory.lambda$createIgnoreNitzPropertyCheck$0(this.f$0, nitzSignal, nitzSignal2);
    }
}
