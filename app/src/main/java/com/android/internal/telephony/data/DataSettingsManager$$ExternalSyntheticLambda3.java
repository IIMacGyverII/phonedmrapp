package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataSettingsManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataSettingsManager$$ExternalSyntheticLambda3 implements Runnable {
    public final /* synthetic */ DataSettingsManager.DataSettingsManagerCallback f$0;
    public final /* synthetic */ boolean f$1;
    public final /* synthetic */ int f$2;
    public final /* synthetic */ String f$3;

    public /* synthetic */ DataSettingsManager$$ExternalSyntheticLambda3(DataSettingsManager.DataSettingsManagerCallback dataSettingsManagerCallback, boolean z, int i, String str) {
        this.f$0 = dataSettingsManagerCallback;
        this.f$1 = z;
        this.f$2 = i;
        this.f$3 = str;
    }

    public final void run() {
        this.f$0.onDataEnabledChanged(this.f$1, this.f$2, this.f$3);
    }
}
