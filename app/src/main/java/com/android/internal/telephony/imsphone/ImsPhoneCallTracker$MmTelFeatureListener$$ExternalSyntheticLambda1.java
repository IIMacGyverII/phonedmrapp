package com.android.internal.telephony.imsphone;

import android.os.Bundle;
import com.android.ims.internal.IImsCallSession;
import com.android.internal.telephony.imsphone.ImsPhoneCallTracker;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ ImsPhoneCallTracker.MmTelFeatureListener f$0;
    public final /* synthetic */ IImsCallSession f$1;
    public final /* synthetic */ Bundle f$2;

    public /* synthetic */ ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda1(ImsPhoneCallTracker.MmTelFeatureListener mmTelFeatureListener, IImsCallSession iImsCallSession, Bundle bundle) {
        this.f$0 = mmTelFeatureListener;
        this.f$1 = iImsCallSession;
        this.f$2 = bundle;
    }

    public final void run() {
        this.f$0.lambda$onIncomingCall$0(this.f$1, this.f$2);
    }
}
