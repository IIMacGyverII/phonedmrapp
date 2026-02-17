package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.SendSmsMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class SendSmsMessageHandler extends BaseMessageHandler<SendSmsMessage> {
    public void handle(SendSmsMessage sendSmsMessage) {
    }

    public SendSmsMessage decode(Packet packet) {
        return new SendSmsMessage(packet);
    }
}
