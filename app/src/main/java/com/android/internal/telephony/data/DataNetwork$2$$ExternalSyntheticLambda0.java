package com.android.internal.telephony.data;

import android.net.Uri;
import com.android.internal.telephony.data.DataNetwork;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DataNetwork$2$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ DataNetwork.AnonymousClass2 f$0;
    public final /* synthetic */ int f$1;
    public final /* synthetic */ Uri f$2;

    public /* synthetic */ DataNetwork$2$$ExternalSyntheticLambda0(DataNetwork.AnonymousClass2 r1, int i, Uri uri) {
        this.f$0 = r1;
        this.f$1 = i;
        this.f$2 = uri;
    }

    public final void run() {
        this.f$0.lambda$onValidationStatus$0(this.f$1, this.f$2);
    }
}
