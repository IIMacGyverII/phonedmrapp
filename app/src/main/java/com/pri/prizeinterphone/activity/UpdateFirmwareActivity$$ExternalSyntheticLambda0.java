package com.pri.prizeinterphone.activity;

import android.app.Instrumentation;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class UpdateFirmwareActivity$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ Instrumentation f$0;

    public /* synthetic */ UpdateFirmwareActivity$$ExternalSyntheticLambda0(Instrumentation instrumentation) {
        this.f$0 = instrumentation;
    }

    public final void run() {
        this.f$0.sendKeyDownUpSync(3);
    }
}
