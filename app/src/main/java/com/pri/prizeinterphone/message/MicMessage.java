package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class MicMessage extends BaseMessage {
    public byte gain;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public MicMessage() {
        super(new Packet(Const.Command.SET_GAIN_MIC_CMD));
    }

    public MicMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.gain);
        return allocate.getArray();
    }
}
