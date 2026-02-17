package com.android.internal.telephony.uicc;

import java.util.function.IntPredicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class UiccController$$ExternalSyntheticLambda0 implements IntPredicate {
    public final /* synthetic */ String f$0;
    public final /* synthetic */ UiccSlot f$1;

    public /* synthetic */ UiccController$$ExternalSyntheticLambda0(String str, UiccSlot uiccSlot) {
        this.f$0 = str;
        this.f$1 = uiccSlot;
    }

    public final boolean test(int i) {
        return this.f$0.equals(this.f$1.getIccId(i));
    }
}
