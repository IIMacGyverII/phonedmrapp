package com.android.internal.telephony.metrics;

import com.android.internal.telephony.Connection;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class VoiceCallSessionStats$$ExternalSyntheticLambda0 implements Function {
    public final Object apply(Object obj) {
        return Integer.valueOf(VoiceCallSessionStats.getConnectionId((Connection) obj));
    }
}
