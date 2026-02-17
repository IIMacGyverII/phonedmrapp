package com.pri.prizeinterphone.state;

import com.pri.prizeinterphone.state.StateMachine;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class StateMachine$SmHandler$$ExternalSyntheticLambda0 implements Predicate {
    public final /* synthetic */ StateMachine.SmHandler.StateInfo f$0;

    public /* synthetic */ StateMachine$SmHandler$$ExternalSyntheticLambda0(StateMachine.SmHandler.StateInfo stateInfo) {
        this.f$0 = stateInfo;
    }

    public final boolean test(Object obj) {
        return StateMachine.SmHandler.lambda$removeState$0(this.f$0, (StateMachine.SmHandler.StateInfo) obj);
    }
}
