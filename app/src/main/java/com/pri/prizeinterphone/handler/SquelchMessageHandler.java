package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.SquelchMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class SquelchMessageHandler extends BaseMessageHandler<SquelchMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(SquelchMessage squelchMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public SquelchMessage decode(Packet packet) {
        return new SquelchMessage(packet);
    }
}
