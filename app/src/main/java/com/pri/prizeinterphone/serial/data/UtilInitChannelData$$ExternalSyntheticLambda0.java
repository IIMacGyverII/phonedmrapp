package com.pri.prizeinterphone.serial.data;

import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class UtilInitChannelData$$ExternalSyntheticLambda0 implements Predicate {
    public final /* synthetic */ String f$0;

    public /* synthetic */ UtilInitChannelData$$ExternalSyntheticLambda0(String str) {
        this.f$0 = str;
    }

    public final boolean test(Object obj) {
        return ((UtilChannelData) obj).mDataName.equals(this.f$0);
    }
}
