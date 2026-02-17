package com.android.internal.telephony.dataconnection;

import android.os.Message;
import android.telephony.data.DataProfile;
import com.android.internal.telephony.dataconnection.DataConnection;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataConnection$$ExternalSyntheticLambda7 implements Consumer {
    public final /* synthetic */ DataConnection f$0;
    public final /* synthetic */ DataConnection f$1;
    public final /* synthetic */ DataConnection.ConnectionParams f$2;
    public final /* synthetic */ Message f$3;
    public final /* synthetic */ DataProfile f$4;
    public final /* synthetic */ boolean f$5;
    public final /* synthetic */ boolean f$6;

    public /* synthetic */ DataConnection$$ExternalSyntheticLambda7(DataConnection dataConnection, DataConnection dataConnection2, DataConnection.ConnectionParams connectionParams, Message message, DataProfile dataProfile, boolean z, boolean z2) {
        this.f$0 = dataConnection;
        this.f$1 = dataConnection2;
        this.f$2 = connectionParams;
        this.f$3 = message;
        this.f$4 = dataProfile;
        this.f$5 = z;
        this.f$6 = z2;
    }

    public final void accept(Object obj) {
        this.f$0.lambda$connect$1(this.f$1, this.f$2, this.f$3, this.f$4, this.f$5, this.f$6, (Integer) obj);
    }
}
