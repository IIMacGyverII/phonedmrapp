package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class DigitalAudioMessage extends BaseMessage {
    public byte fetch = 1;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public DigitalAudioMessage() {
        super(new Packet(Const.Command.QUERY_DIGITAL_AUDIO_RECEIVE_INFO));
    }

    public DigitalAudioMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.fetch);
        return allocate.getArray();
    }
}
