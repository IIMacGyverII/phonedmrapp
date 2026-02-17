package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataSettingsManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataSettingsManager$$ExternalSyntheticLambda4 implements Consumer {
    public final /* synthetic */ boolean f$0;

    public /* synthetic */ DataSettingsManager$$ExternalSyntheticLambda4(boolean z) {
        this.f$0 = z;
    }

    public final void accept(Object obj) {
        ((DataSettingsManager.DataSettingsManagerCallback) obj).invokeFromExecutor(new DataSettingsManager$$ExternalSyntheticLambda2((DataSettingsManager.DataSettingsManagerCallback) obj, this.f$0));
    }
}
