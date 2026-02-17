package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataSettingsManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataSettingsManager$$ExternalSyntheticLambda6 implements Runnable {
    public final /* synthetic */ DataSettingsManager.DataSettingsManagerCallback f$0;
    public final /* synthetic */ boolean f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ DataSettingsManager$$ExternalSyntheticLambda6(DataSettingsManager.DataSettingsManagerCallback dataSettingsManagerCallback, boolean z, int i) {
        this.f$0 = dataSettingsManagerCallback;
        this.f$1 = z;
        this.f$2 = i;
    }

    public final void run() {
        this.f$0.onDataEnabledOverrideChanged(this.f$1, this.f$2);
    }
}
