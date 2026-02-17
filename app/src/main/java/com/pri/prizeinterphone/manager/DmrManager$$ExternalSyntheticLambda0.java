package com.pri.prizeinterphone.manager;

import java.util.function.Consumer;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class DmrManager$$ExternalSyntheticLambda0 implements Consumer {
    public final /* synthetic */ byte f$0;

    public /* synthetic */ DmrManager$$ExternalSyntheticLambda0(byte b) {
        this.f$0 = b;
    }

    public final void accept(Object obj) {
        ((InterruptResultListener) obj).onReceiveInterrupt(Byte.toUnsignedInt(this.f$0));
    }
}
