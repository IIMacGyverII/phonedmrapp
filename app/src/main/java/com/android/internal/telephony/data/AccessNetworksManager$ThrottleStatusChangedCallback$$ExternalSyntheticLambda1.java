package com.android.internal.telephony.data;

import com.android.internal.telephony.data.AccessNetworksManager;
import java.util.List;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ AccessNetworksManager.ThrottleStatusChangedCallback f$0;
    public final /* synthetic */ List f$1;

    public /* synthetic */ AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda1(AccessNetworksManager.ThrottleStatusChangedCallback throttleStatusChangedCallback, List list) {
        this.f$0 = throttleStatusChangedCallback;
        this.f$1 = list;
    }

    public final void run() {
        this.f$0.lambda$onThrottleStatusChanged$1(this.f$1);
    }
}
