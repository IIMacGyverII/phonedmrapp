package com.android.internal.telephony.d2d;

import android.telephony.ims.RtpHeaderExtensionType;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RtpTransport$$ExternalSyntheticLambda6 implements Predicate {
    public final boolean test(Object obj) {
        return ((RtpHeaderExtensionType) obj).getUri().equals(RtpTransport.CALL_STATE_RTP_HEADER_EXTENSION);
    }
}
