package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.MonitorMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class MonitorMessageHandler extends BaseMessageHandler<MonitorMessage> {
    public void handle(MonitorMessage monitorMessage) {
    }

    public MonitorMessage decode(Packet packet) {
        return new MonitorMessage(packet);
    }
}
