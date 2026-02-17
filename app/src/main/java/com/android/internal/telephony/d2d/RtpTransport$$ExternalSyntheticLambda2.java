package com.android.internal.telephony.d2d;

import android.net.Uri;
import android.telephony.ims.RtpHeaderExtensionType;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RtpTransport$$ExternalSyntheticLambda2 implements Predicate {
    public final /* synthetic */ Uri f$0;

    public /* synthetic */ RtpTransport$$ExternalSyntheticLambda2(Uri uri) {
        this.f$0 = uri;
    }

    public final boolean test(Object obj) {
        return ((RtpHeaderExtensionType) obj).getUri().equals(this.f$0);
    }
}
