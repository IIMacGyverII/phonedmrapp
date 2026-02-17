package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataSettingsManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataSettingsManager$$ExternalSyntheticLambda2 implements Runnable {
    public final /* synthetic */ DataSettingsManager.DataSettingsManagerCallback f$0;
    public final /* synthetic */ boolean f$1;

    public /* synthetic */ DataSettingsManager$$ExternalSyntheticLambda2(DataSettingsManager.DataSettingsManagerCallback dataSettingsManagerCallback, boolean z) {
        this.f$0 = dataSettingsManagerCallback;
        this.f$1 = z;
    }

    public final void run() {
        this.f$0.onDataRoamingEnabledChanged(this.f$1);
    }
}
