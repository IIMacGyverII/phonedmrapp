package com.android.internal.telephony;

import android.telephony.CellInfo;
import java.util.Set;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class NetworkScanRequestTracker$$ExternalSyntheticLambda3 implements Predicate {
    public final /* synthetic */ Set f$0;

    public /* synthetic */ NetworkScanRequestTracker$$ExternalSyntheticLambda3(Set set) {
        this.f$0 = set;
    }

    public final boolean test(Object obj) {
        return NetworkScanRequestTracker.doesCellInfoCorrespondToKnownMccMnc((CellInfo) obj, this.f$0);
    }
}
