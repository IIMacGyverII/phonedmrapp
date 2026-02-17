package com.android.internal.telephony.euicc;

import android.telephony.euicc.EuiccInfo;
import com.android.internal.telephony.euicc.EuiccConnector;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccConnector$ConnectedState$6$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ EuiccConnector.ConnectedState.AnonymousClass6 f$0;
    public final /* synthetic */ EuiccConnector.BaseEuiccCommandCallback f$1;
    public final /* synthetic */ EuiccInfo f$2;

    public /* synthetic */ EuiccConnector$ConnectedState$6$$ExternalSyntheticLambda0(EuiccConnector.ConnectedState.AnonymousClass6 r1, EuiccConnector.BaseEuiccCommandCallback baseEuiccCommandCallback, EuiccInfo euiccInfo) {
        this.f$0 = r1;
        this.f$1 = baseEuiccCommandCallback;
        this.f$2 = euiccInfo;
    }

    public final void run() {
        this.f$0.lambda$onSuccess$0(this.f$1, this.f$2);
    }
}
