package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.RelayMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class RelayMessageHandler extends BaseMessageHandler<RelayMessage> {
    public void handle(RelayMessage relayMessage) {
    }

    public RelayMessage decode(Packet packet) {
        return new RelayMessage(packet);
    }
}
