package com.android.internal.telephony.metrics;

import com.android.internal.telephony.nano.PersistAtomsProto;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class VoiceCallRatTracker$$ExternalSyntheticLambda2 implements Consumer {
    public final /* synthetic */ VoiceCallRatTracker f$0;

    public /* synthetic */ VoiceCallRatTracker$$ExternalSyntheticLambda2(VoiceCallRatTracker voiceCallRatTracker) {
        this.f$0 = voiceCallRatTracker;
    }

    public final void accept(Object obj) {
        this.f$0.addProto((PersistAtomsProto.VoiceCallRatUsage) obj);
    }
}
