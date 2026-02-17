package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.talkbak.SendTalkbak;

public class SendTalkbakHandler extends BaseTalkbakHandler<SendTalkbak> {
    public void handle(SendTalkbak sendTalkbak) {
    }

    public SendTalkbak decode(Packet packet) {
        return new SendTalkbak(packet);
    }
}
