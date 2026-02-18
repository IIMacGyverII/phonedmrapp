package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.RelayMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class RelayMessageHandler extends BaseMessageHandler<RelayMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(RelayMessage relayMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public RelayMessage decode(Packet packet) {
        return new RelayMessage(packet);
    }
}
