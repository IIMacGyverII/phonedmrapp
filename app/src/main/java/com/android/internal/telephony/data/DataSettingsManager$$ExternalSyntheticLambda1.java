package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataSettingsManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataSettingsManager$$ExternalSyntheticLambda1 implements Consumer {
    public final /* synthetic */ boolean f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ DataSettingsManager$$ExternalSyntheticLambda1(boolean z, int i) {
        this.f$0 = z;
        this.f$1 = i;
    }

    public final void accept(Object obj) {
        ((DataSettingsManager.DataSettingsManagerCallback) obj).invokeFromExecutor(new DataSettingsManager$$ExternalSyntheticLambda6((DataSettingsManager.DataSettingsManagerCallback) obj, this.f$0, this.f$1));
    }
}
