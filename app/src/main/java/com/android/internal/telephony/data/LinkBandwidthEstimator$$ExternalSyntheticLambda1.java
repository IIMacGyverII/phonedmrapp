package com.android.internal.telephony.data;

import com.android.internal.telephony.data.LinkBandwidthEstimator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class LinkBandwidthEstimator$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ LinkBandwidthEstimator.LinkBandwidthEstimatorCallback f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ LinkBandwidthEstimator$$ExternalSyntheticLambda1(LinkBandwidthEstimator.LinkBandwidthEstimatorCallback linkBandwidthEstimatorCallback, int i) {
        this.f$0 = linkBandwidthEstimatorCallback;
        this.f$1 = i;
    }

    public final void run() {
        this.f$0.onDataActivityChanged(this.f$1);
    }
}
