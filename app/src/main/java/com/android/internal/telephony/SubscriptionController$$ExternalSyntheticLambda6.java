package com.android.internal.telephony;

import android.telephony.SubscriptionInfo;
import com.android.internal.telephony.uicc.IccUtils;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class SubscriptionController$$ExternalSyntheticLambda6 implements Predicate {
    public final /* synthetic */ String f$0;

    public /* synthetic */ SubscriptionController$$ExternalSyntheticLambda6(String str) {
        this.f$0 = str;
    }

    public final boolean test(Object obj) {
        return IccUtils.stripTrailingFs(((SubscriptionInfo) obj).getIccId()).equals(IccUtils.stripTrailingFs(this.f$0));
    }
}
