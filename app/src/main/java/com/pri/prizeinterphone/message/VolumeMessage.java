package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class VolumeMessage extends BaseMessage {
    public byte vol;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public VolumeMessage() {
        super(new Packet(Const.Command.SET_VOL_CMD));
        this.vol = (byte) 8;
    }

    public VolumeMessage(Packet packet) {
        super(packet);
        this.vol = (byte) 8;
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.vol);
        return allocate.getArray();
    }
}
