package com.android.internal.telephony.data;

import android.telephony.data.ThrottleStatus;
import com.android.internal.telephony.data.AccessNetworksManager;
import java.util.function.Predicate;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda0 implements Predicate {
    public final /* synthetic */ AccessNetworksManager.ThrottleStatusChangedCallback f$0;

    public /* synthetic */ AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda0(AccessNetworksManager.ThrottleStatusChangedCallback throttleStatusChangedCallback) {
        this.f$0 = throttleStatusChangedCallback;
    }

    public final boolean test(Object obj) {
        return this.f$0.lambda$onThrottleStatusChanged$0((ThrottleStatus) obj);
    }
}
