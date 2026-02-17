package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.VolumeMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class VolumeMessageHandler extends BaseMessageHandler<VolumeMessage> {
    public void handle(VolumeMessage volumeMessage) {
    }

    public VolumeMessage decode(Packet packet) {
        return new VolumeMessage(packet);
    }
}
