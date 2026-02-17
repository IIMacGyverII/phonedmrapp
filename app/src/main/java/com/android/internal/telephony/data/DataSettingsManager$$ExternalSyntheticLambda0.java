package com.android.internal.telephony.data;

import com.android.internal.telephony.data.DataSettingsManager;
import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataSettingsManager$$ExternalSyntheticLambda0 implements Consumer {
    public final /* synthetic */ boolean f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ String f$2;

    public /* synthetic */ DataSettingsManager$$ExternalSyntheticLambda0(boolean z, int i, String str) {
        this.f$0 = z;
        this.f$1 = i;
        this.f$2 = str;
    }

    public final void accept(Object obj) {
        ((DataSettingsManager.DataSettingsManagerCallback) obj).invokeFromExecutor(new DataSettingsManager$$ExternalSyntheticLambda3((DataSettingsManager.DataSettingsManagerCallback) obj, this.f$0, this.f$1, this.f$2));
    }
}
