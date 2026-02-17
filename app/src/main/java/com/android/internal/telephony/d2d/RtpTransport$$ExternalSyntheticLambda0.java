package com.android.internal.telephony.d2d;

import android.telephony.ims.RtpHeaderExtension;
import java.util.function.Function;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RtpTransport$$ExternalSyntheticLambda0 implements Function {
    public final /* synthetic */ RtpTransport f$0;

    public /* synthetic */ RtpTransport$$ExternalSyntheticLambda0(RtpTransport rtpTransport) {
        this.f$0 = rtpTransport;
    }

    public final Object apply(Object obj) {
        return this.f$0.lambda$onRtpHeaderExtensionsReceived$4((RtpHeaderExtension) obj);
    }
}
