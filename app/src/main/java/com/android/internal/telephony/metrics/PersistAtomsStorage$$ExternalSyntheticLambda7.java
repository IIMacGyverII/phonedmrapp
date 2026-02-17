package com.android.internal.telephony.metrics;

import com.android.internal.telephony.nano.PersistAtomsProto;
import java.util.function.IntPredicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class PersistAtomsStorage$$ExternalSyntheticLambda7 implements IntPredicate {
    public final /* synthetic */ PersistAtomsProto.VoiceCallSession[] f$0;

    public /* synthetic */ PersistAtomsStorage$$ExternalSyntheticLambda7(PersistAtomsProto.VoiceCallSession[] voiceCallSessionArr) {
        this.f$0 = voiceCallSessionArr;
    }

    public final boolean test(int i) {
        return PersistAtomsStorage.lambda$findItemToEvict$8(this.f$0, i);
    }
}
