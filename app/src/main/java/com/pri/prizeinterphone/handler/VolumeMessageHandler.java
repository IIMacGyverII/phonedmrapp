package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.VolumeMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class VolumeMessageHandler extends BaseMessageHandler<VolumeMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(VolumeMessage volumeMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public VolumeMessage decode(Packet packet) {
        return new VolumeMessage(packet);
    }
}
