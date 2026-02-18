package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.talkbak.SendTalkbak;
/* loaded from: classes4.dex */
public class SendTalkbakHandler extends BaseTalkbakHandler<SendTalkbak> {
    @Override // com.pri.prizeinterphone.handler.BaseTalkbakHandler
    public void handle(SendTalkbak sendTalkbak) {
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.pri.prizeinterphone.handler.BaseTalkbakHandler
    public SendTalkbak decode(Packet packet) {
        return new SendTalkbak(packet);
    }
}
