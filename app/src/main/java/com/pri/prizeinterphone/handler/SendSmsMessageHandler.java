package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.SendSmsMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class SendSmsMessageHandler extends BaseMessageHandler<SendSmsMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(SendSmsMessage sendSmsMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public SendSmsMessage decode(Packet packet) {
        return new SendSmsMessage(packet);
    }
}
