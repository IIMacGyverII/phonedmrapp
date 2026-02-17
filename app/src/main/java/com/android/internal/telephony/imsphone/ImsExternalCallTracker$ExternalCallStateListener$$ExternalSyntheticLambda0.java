package com.android.internal.telephony.imsphone;

import com.android.internal.telephony.imsphone.ImsExternalCallTracker;
import java.util.List;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsExternalCallTracker$ExternalCallStateListener$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ ImsExternalCallTracker.ExternalCallStateListener f$0;
    public final /* synthetic */ List f$1;

    public /* synthetic */ ImsExternalCallTracker$ExternalCallStateListener$$ExternalSyntheticLambda0(ImsExternalCallTracker.ExternalCallStateListener externalCallStateListener, List list) {
        this.f$0 = externalCallStateListener;
        this.f$1 = list;
    }

    public final void run() {
        this.f$0.lambda$onImsExternalCallStateUpdate$0(this.f$1);
    }
}
