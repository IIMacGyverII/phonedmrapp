package com.android.internal.telephony.data;

import com.android.internal.telephony.data.AccessNetworksManager;
import com.android.internal.telephony.dataconnection.DataThrottler;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda2 implements Runnable {
    public final /* synthetic */ AccessNetworksManager.QualifiedNetworksServiceConnection f$0;
    public final /* synthetic */ DataThrottler f$1;

    public /* synthetic */ AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda2(AccessNetworksManager.QualifiedNetworksServiceConnection qualifiedNetworksServiceConnection, DataThrottler dataThrottler) {
        this.f$0 = qualifiedNetworksServiceConnection;
        this.f$1 = dataThrottler;
    }

    public final void run() {
        this.f$0.lambda$registerDataThrottler$1(this.f$1);
    }
}
