package com.android.internal.telephony.euicc;

import com.android.internal.telephony.euicc.EuiccConnector;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ EuiccConnector.BaseEuiccCommandCallback f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda0(EuiccConnector.BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
        this.f$0 = baseEuiccCommandCallback;
        this.f$1 = i;
    }

    public final void run() {
        ((EuiccConnector.OtaStatusChangedCallback) this.f$0).onOtaStatusChanged(this.f$1);
    }
}
