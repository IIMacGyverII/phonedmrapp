package com.android.internal.telephony.ims;

import com.android.internal.telephony.ims.ImsResolver;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda5 implements Predicate {
    public final /* synthetic */ ImsResolver.ImsServiceInfo f$0;

    public /* synthetic */ ImsResolver$$ExternalSyntheticLambda5(ImsResolver.ImsServiceInfo imsServiceInfo) {
        this.f$0 = imsServiceInfo;
    }

    public final boolean test(Object obj) {
        return ((String) obj).equals(this.f$0.name.getPackageName());
    }
}
