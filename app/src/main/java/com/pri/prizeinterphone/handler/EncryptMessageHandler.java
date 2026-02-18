package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.EncryptMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class EncryptMessageHandler extends BaseMessageHandler<EncryptMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(EncryptMessage encryptMessage) {
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public EncryptMessage decode(Packet packet) {
        return new EncryptMessage(packet);
    }
}
