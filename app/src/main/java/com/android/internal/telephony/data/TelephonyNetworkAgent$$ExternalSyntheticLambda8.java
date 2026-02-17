package com.android.internal.telephony.data;

import android.net.Uri;
import com.android.internal.telephony.data.TelephonyNetworkAgent;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class TelephonyNetworkAgent$$ExternalSyntheticLambda8 implements Consumer {
    public final /* synthetic */ int f$0;
    public final /* synthetic */ Uri f$1;

    public /* synthetic */ TelephonyNetworkAgent$$ExternalSyntheticLambda8(int i, Uri uri) {
        this.f$0 = i;
        this.f$1 = uri;
    }

    public final void accept(Object obj) {
        ((TelephonyNetworkAgent.TelephonyNetworkAgentCallback) obj).invokeFromExecutor(new TelephonyNetworkAgent$$ExternalSyntheticLambda3((TelephonyNetworkAgent.TelephonyNetworkAgentCallback) obj, this.f$0, this.f$1));
    }
}
