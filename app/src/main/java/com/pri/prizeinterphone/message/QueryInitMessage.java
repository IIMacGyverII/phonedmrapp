package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class QueryInitMessage extends BaseMessage {
    public final byte data = 1;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public QueryInitMessage() {
        super(new Packet(Const.Command.QUERY_INIT_STATUS_CMD));
    }

    public QueryInitMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put((byte) 1);
        return allocate.getArray();
    }
}
