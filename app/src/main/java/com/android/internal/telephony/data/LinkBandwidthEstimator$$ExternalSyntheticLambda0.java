package com.android.internal.telephony.data;

import com.android.internal.telephony.data.LinkBandwidthEstimator;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class LinkBandwidthEstimator$$ExternalSyntheticLambda0 implements Consumer {
    public final /* synthetic */ int f$0;

    public /* synthetic */ LinkBandwidthEstimator$$ExternalSyntheticLambda0(int i) {
        this.f$0 = i;
    }

    public final void accept(Object obj) {
        ((LinkBandwidthEstimator.LinkBandwidthEstimatorCallback) obj).invokeFromExecutor(new LinkBandwidthEstimator$$ExternalSyntheticLambda1((LinkBandwidthEstimator.LinkBandwidthEstimatorCallback) obj, this.f$0));
    }
}
