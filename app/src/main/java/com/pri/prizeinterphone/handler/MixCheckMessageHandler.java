package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.MixCheckMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class MixCheckMessageHandler extends BaseMessageHandler<MixCheckMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(MixCheckMessage mixCheckMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public MixCheckMessage decode(Packet packet) {
        return new MixCheckMessage(packet);
    }
}
