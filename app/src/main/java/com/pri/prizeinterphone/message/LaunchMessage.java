package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class LaunchMessage extends BaseMessage {
    public byte launch;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public LaunchMessage() {
        this(new Packet(Const.Command.SET_LAUNCH_INFO_CMD));
    }

    public LaunchMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.launch);
        return allocate.getArray();
    }
}
