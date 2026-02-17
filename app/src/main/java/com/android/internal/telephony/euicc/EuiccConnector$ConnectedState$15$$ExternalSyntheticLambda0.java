package com.android.internal.telephony.euicc;

import com.android.internal.telephony.euicc.EuiccConnector;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccConnector$ConnectedState$15$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ EuiccConnector.ConnectedState.AnonymousClass15 f$0;
    public final /* synthetic */ EuiccConnector.BaseEuiccCommandCallback f$1;
    public final /* synthetic */ String f$2;

    public /* synthetic */ EuiccConnector$ConnectedState$15$$ExternalSyntheticLambda0(EuiccConnector.ConnectedState.AnonymousClass15 r1, EuiccConnector.BaseEuiccCommandCallback baseEuiccCommandCallback, String str) {
        this.f$0 = r1;
        this.f$1 = baseEuiccCommandCallback;
        this.f$2 = str;
    }

    public final void run() {
        this.f$0.lambda$onComplete$0(this.f$1, this.f$2);
    }
}
