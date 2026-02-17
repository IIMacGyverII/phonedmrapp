package com.android.internal.telephony.data;

import com.android.internal.telephony.data.LinkBandwidthEstimator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class LinkBandwidthEstimator$$ExternalSyntheticLambda5 implements Runnable {
    public final /* synthetic */ LinkBandwidthEstimator.LinkBandwidthEstimatorCallback f$0;

    public /* synthetic */ LinkBandwidthEstimator$$ExternalSyntheticLambda5(LinkBandwidthEstimator.LinkBandwidthEstimatorCallback linkBandwidthEstimatorCallback) {
        this.f$0 = linkBandwidthEstimatorCallback;
    }

    public final void run() {
        this.f$0.onDataActivityChanged(0);
    }
}
