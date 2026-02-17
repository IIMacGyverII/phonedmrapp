package com.android.internal.telephony.data;

import com.android.internal.telephony.data.LinkBandwidthEstimator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class LinkBandwidthEstimator$$ExternalSyntheticLambda4 implements Runnable {
    public final /* synthetic */ LinkBandwidthEstimator.LinkBandwidthEstimatorCallback f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ LinkBandwidthEstimator$$ExternalSyntheticLambda4(LinkBandwidthEstimator.LinkBandwidthEstimatorCallback linkBandwidthEstimatorCallback, int i, int i2) {
        this.f$0 = linkBandwidthEstimatorCallback;
        this.f$1 = i;
        this.f$2 = i2;
    }

    public final void run() {
        this.f$0.onBandwidthChanged(this.f$1, this.f$2);
    }
}
