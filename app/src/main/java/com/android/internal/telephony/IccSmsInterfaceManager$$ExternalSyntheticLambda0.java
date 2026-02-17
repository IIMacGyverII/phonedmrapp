package com.android.internal.telephony;

import android.app.PendingIntent;
import com.android.internal.telephony.SmsDispatchersController;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class IccSmsInterfaceManager$$ExternalSyntheticLambda0 implements SmsDispatchersController.SmsInjectionCallback {
    public final /* synthetic */ IccSmsInterfaceManager f$0;
    public final /* synthetic */ PendingIntent f$1;

    public /* synthetic */ IccSmsInterfaceManager$$ExternalSyntheticLambda0(IccSmsInterfaceManager iccSmsInterfaceManager, PendingIntent pendingIntent) {
        this.f$0 = iccSmsInterfaceManager;
        this.f$1 = pendingIntent;
    }

    public final void onSmsInjectedResult(int i) {
        this.f$0.lambda$injectSmsPdu$0(this.f$1, i);
    }
}
