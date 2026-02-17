package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.DigitalAudioMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class DigitalAudioMessageHandler extends BaseMessageHandler<DigitalAudioMessage> {
    public void handle(DigitalAudioMessage digitalAudioMessage) {
    }

    public DigitalAudioMessage decode(Packet packet) {
        return new DigitalAudioMessage(packet);
    }
}
