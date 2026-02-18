package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.MonitorMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class MonitorMessageHandler extends BaseMessageHandler<MonitorMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(MonitorMessage monitorMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public MonitorMessage decode(Packet packet) {
        return new MonitorMessage(packet);
    }
}
