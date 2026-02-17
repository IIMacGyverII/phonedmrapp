package com.android.internal.telephony.imsphone;

import com.android.internal.telephony.imsphone.ImsPhoneCallTracker;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda2 implements Runnable {
    public final /* synthetic */ ImsPhoneCallTracker.MmTelFeatureListener f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda2(ImsPhoneCallTracker.MmTelFeatureListener mmTelFeatureListener, int i) {
        this.f$0 = mmTelFeatureListener;
        this.f$1 = i;
    }

    public final void run() {
        this.f$0.lambda$onVoiceMessageCountUpdate$1(this.f$1);
    }
}
