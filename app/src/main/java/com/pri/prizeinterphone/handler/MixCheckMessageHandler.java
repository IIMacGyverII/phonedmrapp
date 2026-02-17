package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.MixCheckMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class MixCheckMessageHandler extends BaseMessageHandler<MixCheckMessage> {
    public void handle(MixCheckMessage mixCheckMessage) {
    }

    public MixCheckMessage decode(Packet packet) {
        return new MixCheckMessage(packet);
    }
}
