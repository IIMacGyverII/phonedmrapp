package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.euicc.EuiccPort;
import com.android.internal.telephony.uicc.euicc.async.AsyncResultCallback;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class EuiccPort$$ExternalSyntheticLambda52 implements EuiccPort.ApduExceptionHandler {
    public final /* synthetic */ AsyncResultCallback f$0;

    public /* synthetic */ EuiccPort$$ExternalSyntheticLambda52(AsyncResultCallback asyncResultCallback) {
        this.f$0 = asyncResultCallback;
    }

    public final void handleException(Throwable th) {
        this.f$0.onException(new EuiccCardException("Cannot send APDU.", th));
    }
}
