package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class VersionMessage extends BaseMessage {
    public int version;
    public String versionName;

    public VersionMessage() {
        super(new Packet(Const.Command.QUERY_VERSION_CMD));
    }

    public VersionMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
        this.version = ByteBuffer.wrap(bArr).order(ByteOrder.LITTLE_ENDIAN).getInt();
        this.versionName = new String(bArr);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put((byte) 1);
        return allocate.getArray();
    }
}
