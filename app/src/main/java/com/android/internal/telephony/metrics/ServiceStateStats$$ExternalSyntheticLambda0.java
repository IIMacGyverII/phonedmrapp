package com.android.internal.telephony.metrics;

import com.android.internal.telephony.metrics.ServiceStateStats;
import java.util.function.UnaryOperator;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ServiceStateStats$$ExternalSyntheticLambda0 implements UnaryOperator {
    public final /* synthetic */ ServiceStateStats f$0;
    public final /* synthetic */ long f$1;

    public /* synthetic */ ServiceStateStats$$ExternalSyntheticLambda0(ServiceStateStats serviceStateStats, long j) {
        this.f$0 = serviceStateStats;
        this.f$1 = j;
    }

    public final Object apply(Object obj) {
        return this.f$0.lambda$onImsVoiceRegistrationChanged$1(this.f$1, (ServiceStateStats.TimestampedServiceState) obj);
    }
}
