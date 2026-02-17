package com.android.internal.telephony.d2d;

import android.telephony.ims.RtpHeaderExtension;
import android.telephony.ims.RtpHeaderExtensionType;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RtpTransport$$ExternalSyntheticLambda7 implements Predicate {
    public final /* synthetic */ RtpHeaderExtension f$0;

    public /* synthetic */ RtpTransport$$ExternalSyntheticLambda7(RtpHeaderExtension rtpHeaderExtension) {
        this.f$0 = rtpHeaderExtension;
    }

    public final boolean test(Object obj) {
        return RtpTransport.lambda$extractMessage$5(this.f$0, (RtpHeaderExtensionType) obj);
    }
}
