package com.android.internal.telephony.metrics;

import com.android.internal.telephony.nano.PersistAtomsProto;
import java.util.function.IntBinaryOperator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PersistAtomsStorage$$ExternalSyntheticLambda4 implements IntBinaryOperator {
    public final /* synthetic */ PersistAtomsProto.CellularDataServiceSwitch[] f$0;

    public /* synthetic */ PersistAtomsStorage$$ExternalSyntheticLambda4(PersistAtomsProto.CellularDataServiceSwitch[] cellularDataServiceSwitchArr) {
        this.f$0 = cellularDataServiceSwitchArr;
    }

    public final int applyAsInt(int i, int i2) {
        return PersistAtomsStorage.lambda$findItemToEvict$5(this.f$0, i, i2);
    }
}
