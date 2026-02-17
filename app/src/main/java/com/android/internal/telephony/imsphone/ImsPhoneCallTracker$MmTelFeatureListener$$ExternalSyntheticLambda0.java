package com.android.internal.telephony.imsphone;

import com.android.internal.telephony.util.TelephonyUtils;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ Runnable f$0;

    public /* synthetic */ ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda0(Runnable runnable) {
        this.f$0 = runnable;
    }

    public final void run() {
        TelephonyUtils.runWithCleanCallingIdentity(this.f$0);
    }
}
