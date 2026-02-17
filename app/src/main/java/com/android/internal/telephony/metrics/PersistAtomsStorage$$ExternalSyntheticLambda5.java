package com.android.internal.telephony.metrics;

import com.android.internal.telephony.nano.PersistAtomsProto;
import java.util.function.IntBinaryOperator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PersistAtomsStorage$$ExternalSyntheticLambda5 implements IntBinaryOperator {
    public final /* synthetic */ PersistAtomsProto.ImsRegistrationStats[] f$0;

    public /* synthetic */ PersistAtomsStorage$$ExternalSyntheticLambda5(PersistAtomsProto.ImsRegistrationStats[] imsRegistrationStatsArr) {
        this.f$0 = imsRegistrationStatsArr;
    }

    public final int applyAsInt(int i, int i2) {
        return PersistAtomsStorage.lambda$findItemToEvict$6(this.f$0, i, i2);
    }
}
