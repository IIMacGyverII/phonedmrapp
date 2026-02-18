package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.DigitalAudioMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class DigitalAudioMessageHandler extends BaseMessageHandler<DigitalAudioMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(DigitalAudioMessage digitalAudioMessage) {
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public DigitalAudioMessage decode(Packet packet) {
        return new DigitalAudioMessage(packet);
    }
}
