package com.pri.prizeinterphone.talkbak;

import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.SerialManager;
/* loaded from: classes4.dex */
public abstract class BaseTalkbak implements Talkbak {
    public final Packet packet;

    protected abstract void decodeBody(byte[] bArr);

    protected abstract byte[] encodeBody();

    public BaseTalkbak(Packet packet) {
        this.packet = packet;
    }

    @Override // com.pri.prizeinterphone.talkbak.Talkbak
    public void encode() {
        Packet packet = this.packet;
        packet.rw = (byte) 1;
        packet.sr = (byte) 1;
        packet.body = encodeBody();
    }

    @Override // com.pri.prizeinterphone.talkbak.Talkbak
    public void decode() {
        byte[] bArr = this.packet.body;
        if (bArr == null || bArr.length <= 0) {
            return;
        }
        decodeBody(bArr);
    }

    @Override // com.pri.prizeinterphone.talkbak.Talkbak
    public void send() {
        encode();
        SerialManager.getInstance().send(this.packet);
    }
}
