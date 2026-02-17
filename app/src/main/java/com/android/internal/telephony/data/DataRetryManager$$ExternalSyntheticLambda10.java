package com.android.internal.telephony.data;

import android.telephony.data.DataProfile;
import com.android.internal.telephony.data.DataNetworkController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataRetryManager$$ExternalSyntheticLambda10 implements Runnable {
    public final /* synthetic */ DataRetryManager f$0;
    public final /* synthetic */ DataProfile f$1;
    public final /* synthetic */ int f$2;
    public final /* synthetic */ DataNetworkController.NetworkRequestList f$3;
    public final /* synthetic */ int f$4;
    public final /* synthetic */ long f$5;

    public /* synthetic */ DataRetryManager$$ExternalSyntheticLambda10(DataRetryManager dataRetryManager, DataProfile dataProfile, int i, DataNetworkController.NetworkRequestList networkRequestList, int i2, long j) {
        this.f$0 = dataRetryManager;
        this.f$1 = dataProfile;
        this.f$2 = i;
        this.f$3 = networkRequestList;
        this.f$4 = i2;
        this.f$5 = j;
    }

    public final void run() {
        this.f$0.lambda$evaluateDataSetupRetry$4(this.f$1, this.f$2, this.f$3, this.f$4, this.f$5);
    }
}
