package com.android.internal.telephony;

import java.util.concurrent.Executor;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class ImsSmsDispatcher$$ExternalSyntheticLambda0 implements Executor {
    public final /* synthetic */ ImsSmsDispatcher f$0;

    public /* synthetic */ ImsSmsDispatcher$$ExternalSyntheticLambda0(ImsSmsDispatcher imsSmsDispatcher) {
        this.f$0 = imsSmsDispatcher;
    }

    public final void execute(Runnable runnable) {
        this.f$0.post(runnable);
    }
}
