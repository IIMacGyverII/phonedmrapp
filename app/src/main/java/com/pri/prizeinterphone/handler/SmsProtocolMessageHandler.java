package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.SmsProtocolMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class SmsProtocolMessageHandler extends BaseMessageHandler<SmsProtocolMessage> {
    public void handle(SmsProtocolMessage smsProtocolMessage) {
    }

    public SmsProtocolMessage decode(Packet packet) {
        return new SmsProtocolMessage(packet);
    }
}
