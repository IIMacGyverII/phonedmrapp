package com.pri.prizeinterphone.talkbak;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class SendTalkbak extends BaseTalkbak {
    public byte dataInfo = 1;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public SendTalkbak() {
        super(new Packet(Const.Command.SET_LAUNCH_INFO_CMD));
    }

    public SendTalkbak(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.put(this.dataInfo);
        return allocate.getArray();
    }
}
