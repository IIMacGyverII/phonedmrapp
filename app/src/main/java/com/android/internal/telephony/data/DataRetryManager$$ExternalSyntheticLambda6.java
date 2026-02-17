package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataRetryManager;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda6 implements Predicate {
    public final /* synthetic */ Class f$0;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda6(Class cls) {
        this.f$0 = cls;
    }

    public final boolean test(Object obj) {
        return this.f$0.isInstance((DataRetryManager.DataRetryEntry) obj);
    }
}
