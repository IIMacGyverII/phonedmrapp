package com.android.internal.telephony.euicc;

import com.android.internal.telephony.euicc.EuiccConnector;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ EuiccConnector.ConnectedState.AnonymousClass14 f$0;
    public final /* synthetic */ EuiccConnector.BaseEuiccCommandCallback f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1(EuiccConnector.ConnectedState.AnonymousClass14 r1, EuiccConnector.BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
        this.f$0 = r1;
        this.f$1 = baseEuiccCommandCallback;
        this.f$2 = i;
    }

    public final void run() {
        this.f$0.lambda$onOtaStatusChanged$1(this.f$1, this.f$2);
    }
}
