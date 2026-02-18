package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class DigitalAudioMessage extends BaseMessage {
    public byte fetch;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public DigitalAudioMessage() {
        super(new Packet(Const.Command.QUERY_DIGITAL_AUDIO_RECEIVE_INFO));
        this.fetch = (byte) 1;
    }

    public DigitalAudioMessage(Packet packet) {
        super(packet);
        this.fetch = (byte) 1;
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.fetch);
        return allocate.getArray();
    }
}
