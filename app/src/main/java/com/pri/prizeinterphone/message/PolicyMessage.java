package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class PolicyMessage extends BaseMessage {
    public byte policy;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public PolicyMessage() {
        super(new Packet(Const.Command.SET_POLITE_POLICY_CMD));
    }

    public PolicyMessage(Packet packet) {
        super(packet);
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.policy);
        return allocate.getArray();
    }
}
