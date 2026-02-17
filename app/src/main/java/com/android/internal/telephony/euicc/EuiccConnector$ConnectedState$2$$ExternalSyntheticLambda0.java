package com.android.internal.telephony.euicc;

import android.service.euicc.GetDownloadableSubscriptionMetadataResult;
import com.android.internal.telephony.euicc.EuiccConnector;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccConnector$ConnectedState$2$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ EuiccConnector.ConnectedState.AnonymousClass2 f$0;
    public final /* synthetic */ EuiccConnector.BaseEuiccCommandCallback f$1;
    public final /* synthetic */ int f$2;
    public final /* synthetic */ GetDownloadableSubscriptionMetadataResult f$3;

    public /* synthetic */ EuiccConnector$ConnectedState$2$$ExternalSyntheticLambda0(EuiccConnector.ConnectedState.AnonymousClass2 r1, EuiccConnector.BaseEuiccCommandCallback baseEuiccCommandCallback, int i, GetDownloadableSubscriptionMetadataResult getDownloadableSubscriptionMetadataResult) {
        this.f$0 = r1;
        this.f$1 = baseEuiccCommandCallback;
        this.f$2 = i;
        this.f$3 = getDownloadableSubscriptionMetadataResult;
    }

    public final void run() {
        this.f$0.lambda$onComplete$0(this.f$1, this.f$2, this.f$3);
    }
}
