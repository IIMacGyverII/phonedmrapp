package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class PowerSaveMessage extends BaseMessage {
    public byte pwrSave;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public PowerSaveMessage() {
        super(new Packet(Const.Command.SET_POWER_SAVE_MODE_CMD));
    }

    public PowerSaveMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.pwrSave);
        return allocate.getArray();
    }
}
