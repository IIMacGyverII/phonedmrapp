package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.SquelchMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class SquelchMessageHandler extends BaseMessageHandler<SquelchMessage> {
    public void handle(SquelchMessage squelchMessage) {
    }

    public SquelchMessage decode(Packet packet) {
        return new SquelchMessage(packet);
    }
}
