package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.EncryptMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class EncryptMessageHandler extends BaseMessageHandler<EncryptMessage> {
    public void handle(EncryptMessage encryptMessage) {
    }

    public EncryptMessage decode(Packet packet) {
        return new EncryptMessage(packet);
    }
}
