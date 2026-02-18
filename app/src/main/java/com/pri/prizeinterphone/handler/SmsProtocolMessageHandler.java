package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.SmsProtocolMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class SmsProtocolMessageHandler extends BaseMessageHandler<SmsProtocolMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(SmsProtocolMessage smsProtocolMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public SmsProtocolMessage decode(Packet packet) {
        return new SmsProtocolMessage(packet);
    }
}
