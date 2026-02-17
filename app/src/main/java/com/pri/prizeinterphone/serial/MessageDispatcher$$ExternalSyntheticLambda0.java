package com.pri.prizeinterphone.serial;

import com.pri.prizeinterphone.handler.MessageHandler;
import com.pri.prizeinterphone.protocol.Packet;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class MessageDispatcher$$ExternalSyntheticLambda0 implements Runnable {
    public final /* synthetic */ MessageHandler f$0;
    public final /* synthetic */ Packet f$1;

    public /* synthetic */ MessageDispatcher$$ExternalSyntheticLambda0(MessageHandler messageHandler, Packet packet) {
        this.f$0 = messageHandler;
        this.f$1 = packet;
    }

    public final void run() {
        this.f$0.handle(this.f$1);
    }
}
