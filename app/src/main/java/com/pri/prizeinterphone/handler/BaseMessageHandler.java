package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.Message;
import com.pri.prizeinterphone.protocol.Packet;

public abstract class BaseMessageHandler<T extends Message> implements MessageHandler {
    public abstract T decode(Packet packet);

    public abstract void handle(T t);

    public void handle(Packet packet) {
        Message decode = decode(packet);
        if (decode != null) {
            decode.decode();
            handle(decode);
        }
    }
}
