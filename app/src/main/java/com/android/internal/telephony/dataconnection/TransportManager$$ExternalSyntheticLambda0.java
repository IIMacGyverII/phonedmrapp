package com.android.internal.telephony.dataconnection;

import com.android.internal.telephony.dataconnection.TransportManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TransportManager$$ExternalSyntheticLambda0 implements TransportManager.HandoverParams.HandoverCallback {
    public final /* synthetic */ TransportManager f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ TransportManager$$ExternalSyntheticLambda0(TransportManager transportManager, int i, int i2) {
        this.f$0 = transportManager;
        this.f$1 = i;
        this.f$2 = i2;
    }

    public final void onCompleted(boolean z, boolean z2) {
        this.f$0.lambda$evaluateTransportPreference$0(this.f$1, this.f$2, z, z2);
    }
}
