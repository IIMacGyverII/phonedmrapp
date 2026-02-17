package com.android.internal.telephony.d2d;

import com.android.internal.telephony.d2d.Communicator;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RtpTransport$$ExternalSyntheticLambda3 implements Function {
    public final /* synthetic */ RtpTransport f$0;

    public /* synthetic */ RtpTransport$$ExternalSyntheticLambda3(RtpTransport rtpTransport) {
        this.f$0 = rtpTransport;
    }

    public final Object apply(Object obj) {
        return this.f$0.lambda$sendMessages$3((Communicator.Message) obj);
    }
}
