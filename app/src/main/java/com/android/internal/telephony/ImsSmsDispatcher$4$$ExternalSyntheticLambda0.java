package com.android.internal.telephony;

import android.telephony.SmsMessage;
import com.android.internal.telephony.ImsSmsDispatcher;
import com.android.internal.telephony.SmsDispatchersController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsSmsDispatcher$4$$ExternalSyntheticLambda0 implements SmsDispatchersController.SmsInjectionCallback {
    public final /* synthetic */ ImsSmsDispatcher.AnonymousClass4 f$0;
    public final /* synthetic */ SmsMessage f$1;
    public final /* synthetic */ int f$2;

    public /* synthetic */ ImsSmsDispatcher$4$$ExternalSyntheticLambda0(ImsSmsDispatcher.AnonymousClass4 r1, SmsMessage smsMessage, int i) {
        this.f$0 = r1;
        this.f$1 = smsMessage;
        this.f$2 = i;
    }

    public final void onSmsInjectedResult(int i) {
        this.f$0.lambda$onSmsReceived$0(this.f$1, this.f$2, i);
    }
}
