package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class VolumeMessage extends BaseMessage {
    public byte vol = 8;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public VolumeMessage() {
        super(new Packet(Const.Command.SET_VOL_CMD));
    }

    public VolumeMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.vol);
        return allocate.getArray();
    }
}
