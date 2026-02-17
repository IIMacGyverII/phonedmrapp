package com.android.internal.telephony.nitz;

import android.os.PowerManager;
import com.android.internal.telephony.NitzSignal;
import com.android.internal.telephony.NitzStateMachine;
import com.android.internal.telephony.nitz.NitzSignalInputFilterPredicateFactory;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0 implements NitzSignalInputFilterPredicateFactory.TrivalentPredicate {
    public final /* synthetic */ PowerManager.WakeLock f$0;
    public final /* synthetic */ NitzStateMachine.DeviceState f$1;

    public /* synthetic */ NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0(PowerManager.WakeLock wakeLock, NitzStateMachine.DeviceState deviceState) {
        this.f$0 = wakeLock;
        this.f$1 = deviceState;
    }

    public final Boolean mustProcessNitzSignal(NitzSignal nitzSignal, NitzSignal nitzSignal2) {
        return NitzSignalInputFilterPredicateFactory.lambda$createBogusElapsedRealtimeCheck$1(this.f$0, this.f$1, nitzSignal, nitzSignal2);
    }
}
