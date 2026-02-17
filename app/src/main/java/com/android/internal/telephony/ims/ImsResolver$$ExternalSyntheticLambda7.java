package com.android.internal.telephony.ims;

import com.android.internal.telephony.ims.ImsResolver;
import java.util.Objects;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsResolver$$ExternalSyntheticLambda7 implements Predicate {
    public final /* synthetic */ String f$0;

    public /* synthetic */ ImsResolver$$ExternalSyntheticLambda7(String str) {
        this.f$0 = str;
    }

    public final boolean test(Object obj) {
        return Objects.equals(((ImsResolver.ImsServiceInfo) obj).name.getPackageName(), this.f$0);
    }
}
