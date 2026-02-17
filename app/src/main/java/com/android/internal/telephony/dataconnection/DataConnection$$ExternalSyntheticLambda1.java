package com.android.internal.telephony.dataconnection;

import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataConnection$$ExternalSyntheticLambda1 implements Consumer {
    public final /* synthetic */ DataConnection f$0;
    public final /* synthetic */ Consumer f$1;

    public /* synthetic */ DataConnection$$ExternalSyntheticLambda1(DataConnection dataConnection, Consumer consumer) {
        this.f$0 = dataConnection;
        this.f$1 = consumer;
    }

    public final void accept(Object obj) {
        this.f$0.lambda$startHandover$3(this.f$1, (Integer) obj);
    }
}
