package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.LaunchMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class LaunchMessageHandler extends BaseMessageHandler<LaunchMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(LaunchMessage launchMessage) {
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public LaunchMessage decode(Packet packet) {
        return new LaunchMessage(packet);
    }
}
