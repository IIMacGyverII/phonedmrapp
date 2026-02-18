package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class QueryInitMessage extends BaseMessage {
    public final byte data;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public QueryInitMessage() {
        super(new Packet(Const.Command.QUERY_INIT_STATUS_CMD));
        this.data = (byte) 1;
    }

    public QueryInitMessage(Packet packet) {
        super(packet);
        this.data = (byte) 1;
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put((byte) 1);
        return allocate.getArray();
    }
}
