package com.pri.prizeinterphone.talkbak;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class SendTalkbak extends BaseTalkbak {
    public byte dataInfo;

    @Override // com.pri.prizeinterphone.talkbak.BaseTalkbak
    protected void decodeBody(byte[] bArr) {
    }

    public SendTalkbak() {
        super(new Packet(Const.Command.SET_LAUNCH_INFO_CMD));
        this.dataInfo = (byte) 1;
    }

    public SendTalkbak(Packet packet) {
        super(packet);
        this.dataInfo = (byte) 1;
    }

    @Override // com.pri.prizeinterphone.talkbak.BaseTalkbak
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.dataInfo);
        return allocate.getArray();
    }
}
