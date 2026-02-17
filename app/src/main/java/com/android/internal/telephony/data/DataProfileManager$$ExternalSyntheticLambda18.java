package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataProfileManager;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataProfileManager$$ExternalSyntheticLambda18 implements Runnable {
    public final /* synthetic */ DataProfileManager.DataProfileManagerCallback f$0;

    public /* synthetic */ DataProfileManager$$ExternalSyntheticLambda18(DataProfileManager.DataProfileManagerCallback dataProfileManagerCallback) {
        this.f$0 = dataProfileManagerCallback;
    }

    public final void run() {
        this.f$0.onDataProfilesChanged();
    }
}
