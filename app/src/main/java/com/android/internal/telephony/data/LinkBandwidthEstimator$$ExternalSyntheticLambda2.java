package com.android.internal.telephony.data;

import com.android.internal.telephony.data.LinkBandwidthEstimator;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class LinkBandwidthEstimator$$ExternalSyntheticLambda2 implements Consumer {
    public final /* synthetic */ int f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ LinkBandwidthEstimator$$ExternalSyntheticLambda2(int i, int i2) {
        this.f$0 = i;
        this.f$1 = i2;
    }

    public final void accept(Object obj) {
        ((LinkBandwidthEstimator.LinkBandwidthEstimatorCallback) obj).invokeFromExecutor(new LinkBandwidthEstimator$$ExternalSyntheticLambda4((LinkBandwidthEstimator.LinkBandwidthEstimatorCallback) obj, this.f$0, this.f$1));
    }
}
