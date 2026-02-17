package com.android.internal.telephony.dataconnection;

import android.net.LinkProperties;
import android.os.Message;
import android.telephony.data.DataProfile;
import android.telephony.data.TrafficDescriptor;
import com.android.internal.telephony.dataconnection.DataConnection;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataConnection$$ExternalSyntheticLambda8 implements Consumer {
    public final /* synthetic */ DataConnection f$0;
    public final /* synthetic */ DataConnection.ConnectionParams f$1;
    public final /* synthetic */ DataProfile f$2;
    public final /* synthetic */ boolean f$3;
    public final /* synthetic */ boolean f$4;
    public final /* synthetic */ int f$5;
    public final /* synthetic */ LinkProperties f$6;
    public final /* synthetic */ TrafficDescriptor f$7;
    public final /* synthetic */ boolean f$8;
    public final /* synthetic */ Message f$9;

    public /* synthetic */ DataConnection$$ExternalSyntheticLambda8(DataConnection dataConnection, DataConnection.ConnectionParams connectionParams, DataProfile dataProfile, boolean z, boolean z2, int i, LinkProperties linkProperties, TrafficDescriptor trafficDescriptor, boolean z3, Message message) {
        this.f$0 = dataConnection;
        this.f$1 = connectionParams;
        this.f$2 = dataProfile;
        this.f$3 = z;
        this.f$4 = z2;
        this.f$5 = i;
        this.f$6 = linkProperties;
        this.f$7 = trafficDescriptor;
        this.f$8 = z3;
        this.f$9 = message;
    }

    public final void accept(Object obj) {
        this.f$0.lambda$connect$2(this.f$1, this.f$2, this.f$3, this.f$4, this.f$5, this.f$6, this.f$7, this.f$8, this.f$9, (Integer) obj);
    }
}
