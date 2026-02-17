package com.android.internal.telephony.metrics;

import com.android.internal.telephony.nano.PersistAtomsProto;
import java.util.function.IntBinaryOperator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PersistAtomsStorage$$ExternalSyntheticLambda3 implements IntBinaryOperator {
    public final /* synthetic */ PersistAtomsProto.CellularServiceState[] f$0;

    public /* synthetic */ PersistAtomsStorage$$ExternalSyntheticLambda3(PersistAtomsProto.CellularServiceState[] cellularServiceStateArr) {
        this.f$0 = cellularServiceStateArr;
    }

    public final int applyAsInt(int i, int i2) {
        return PersistAtomsStorage.lambda$findItemToEvict$4(this.f$0, i, i2);
    }
}
