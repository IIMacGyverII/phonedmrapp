package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.SignalMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class SignalMessageHandler extends BaseMessageHandler<SignalMessage> {
    public void handle(SignalMessage signalMessage) {
    }

    public SignalMessage decode(Packet packet) {
        return new SignalMessage(packet);
    }
}
