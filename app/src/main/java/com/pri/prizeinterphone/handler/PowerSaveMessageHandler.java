package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.PowerSaveMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class PowerSaveMessageHandler extends BaseMessageHandler<PowerSaveMessage> {
    public void handle(PowerSaveMessage powerSaveMessage) {
    }

    public PowerSaveMessage decode(Packet packet) {
        return new PowerSaveMessage(packet);
    }
}
