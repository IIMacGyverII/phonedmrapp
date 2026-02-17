package com.android.internal.telephony.euicc;

import android.service.euicc.GetDefaultDownloadableSubscriptionListResult;
import com.android.internal.telephony.euicc.EuiccConnector;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccConnector$ConnectedState$5$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ EuiccConnector.ConnectedState.AnonymousClass5 f$0;
    public final /* synthetic */ EuiccConnector.BaseEuiccCommandCallback f$1;
    public final /* synthetic */ int f$2;
    public final /* synthetic */ GetDefaultDownloadableSubscriptionListResult f$3;

    public /* synthetic */ EuiccConnector$ConnectedState$5$$ExternalSyntheticLambda0(EuiccConnector.ConnectedState.AnonymousClass5 r1, EuiccConnector.BaseEuiccCommandCallback baseEuiccCommandCallback, int i, GetDefaultDownloadableSubscriptionListResult getDefaultDownloadableSubscriptionListResult) {
        this.f$0 = r1;
        this.f$1 = baseEuiccCommandCallback;
        this.f$2 = i;
        this.f$3 = getDefaultDownloadableSubscriptionListResult;
    }

    public final void run() {
        this.f$0.lambda$onComplete$0(this.f$1, this.f$2, this.f$3);
    }
}
