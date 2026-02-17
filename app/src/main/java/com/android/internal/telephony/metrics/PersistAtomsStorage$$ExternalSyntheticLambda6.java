package com.android.internal.telephony.metrics;

import com.android.internal.telephony.nano.PersistAtomsProto;
import java.util.function.IntBinaryOperator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PersistAtomsStorage$$ExternalSyntheticLambda6 implements IntBinaryOperator {
    public final /* synthetic */ PersistAtomsProto.ImsRegistrationTermination[] f$0;

    public /* synthetic */ PersistAtomsStorage$$ExternalSyntheticLambda6(PersistAtomsProto.ImsRegistrationTermination[] imsRegistrationTerminationArr) {
        this.f$0 = imsRegistrationTerminationArr;
    }

    public final int applyAsInt(int i, int i2) {
        return PersistAtomsStorage.lambda$findItemToEvict$7(this.f$0, i, i2);
    }
}
