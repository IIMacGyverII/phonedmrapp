package com.android.internal.telephony.metrics;

import com.android.internal.telephony.metrics.ServiceStateStats;
import java.util.function.UnaryOperator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ServiceStateStats$$ExternalSyntheticLambda1 implements UnaryOperator {
    public final /* synthetic */ long f$0;

    public /* synthetic */ ServiceStateStats$$ExternalSyntheticLambda1(long j) {
        this.f$0 = j;
    }

    public final Object apply(Object obj) {
        return ServiceStateStats.lambda$conclude$0(this.f$0, (ServiceStateStats.TimestampedServiceState) obj);
    }
}
