package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.PowerSaveMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class PowerSaveMessageHandler extends BaseMessageHandler<PowerSaveMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(PowerSaveMessage powerSaveMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public PowerSaveMessage decode(Packet packet) {
        return new PowerSaveMessage(packet);
    }
}
