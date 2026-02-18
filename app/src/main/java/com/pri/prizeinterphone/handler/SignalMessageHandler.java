package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.SignalMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class SignalMessageHandler extends BaseMessageHandler<SignalMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(SignalMessage signalMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public SignalMessage decode(Packet packet) {
        return new SignalMessage(packet);
    }
}
