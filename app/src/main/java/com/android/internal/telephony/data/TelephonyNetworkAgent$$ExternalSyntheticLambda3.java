package com.android.internal.telephony.data;

import android.net.Uri;
import com.android.internal.telephony.data.TelephonyNetworkAgent;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkAgent$$ExternalSyntheticLambda3 implements Runnable {
    public final /* synthetic */ TelephonyNetworkAgent.TelephonyNetworkAgentCallback f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ Uri f$2;

    public /* synthetic */ TelephonyNetworkAgent$$ExternalSyntheticLambda3(TelephonyNetworkAgent.TelephonyNetworkAgentCallback telephonyNetworkAgentCallback, int i, Uri uri) {
        this.f$0 = telephonyNetworkAgentCallback;
        this.f$1 = i;
        this.f$2 = uri;
    }

    public final void run() {
        this.f$0.onValidationStatus(this.f$1, this.f$2);
    }
}
