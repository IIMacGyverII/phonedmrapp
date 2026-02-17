package com.android.internal.telephony.metrics;

import com.android.internal.telephony.nano.PersistAtomsProto;
import java.util.List;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class MetricsCollector$$ExternalSyntheticLambda13 implements Consumer {
    public final /* synthetic */ List f$0;

    public /* synthetic */ MetricsCollector$$ExternalSyntheticLambda13(List list) {
        this.f$0 = list;
    }

    public final void accept(Object obj) {
        this.f$0.add(MetricsCollector.buildStatsEvent((PersistAtomsProto.RcsAcsProvisioningStats) obj));
    }
}
