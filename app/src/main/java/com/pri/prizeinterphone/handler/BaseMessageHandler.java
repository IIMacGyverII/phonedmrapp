package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.Message;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public abstract class BaseMessageHandler<T extends Message> implements MessageHandler {
    public abstract T decode(Packet packet);

    public abstract void handle(T t);

    @Override // com.pri.prizeinterphone.handler.MessageHandler
    public void handle(Packet packet) {
        T decode = decode(packet);
        if (decode != null) {
            decode.decode();
            handle(decode);
        }
    }
}
