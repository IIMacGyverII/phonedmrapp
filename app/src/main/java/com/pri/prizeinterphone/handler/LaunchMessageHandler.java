package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.LaunchMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class LaunchMessageHandler extends BaseMessageHandler<LaunchMessage> {
    public void handle(LaunchMessage launchMessage) {
    }

    public LaunchMessage decode(Packet packet) {
        return new LaunchMessage(packet);
    }
}
