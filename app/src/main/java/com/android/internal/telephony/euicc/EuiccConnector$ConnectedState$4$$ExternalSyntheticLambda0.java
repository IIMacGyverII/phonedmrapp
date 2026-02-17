package com.android.internal.telephony.euicc;

import android.service.euicc.GetEuiccProfileInfoListResult;
import com.android.internal.telephony.euicc.EuiccConnector;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccConnector$ConnectedState$4$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ EuiccConnector.ConnectedState.AnonymousClass4 f$0;
    public final /* synthetic */ EuiccConnector.BaseEuiccCommandCallback f$1;
    public final /* synthetic */ GetEuiccProfileInfoListResult f$2;

    public /* synthetic */ EuiccConnector$ConnectedState$4$$ExternalSyntheticLambda0(EuiccConnector.ConnectedState.AnonymousClass4 r1, EuiccConnector.BaseEuiccCommandCallback baseEuiccCommandCallback, GetEuiccProfileInfoListResult getEuiccProfileInfoListResult) {
        this.f$0 = r1;
        this.f$1 = baseEuiccCommandCallback;
        this.f$2 = getEuiccProfileInfoListResult;
    }

    public final void run() {
        this.f$0.lambda$onComplete$0(this.f$1, this.f$2);
    }
}
