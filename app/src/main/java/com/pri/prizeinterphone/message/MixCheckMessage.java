package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class MixCheckMessage extends BaseMessage {
    public byte cc;
    public byte channelMode;
    public byte contactType;
    public byte[] encryptKey = new byte[8];
    public byte encryptSw = 2;
    public int[] groupList = new int[32];
    public byte inboundSlot;
    public int localID = 1;
    public byte mic;
    public byte outboundSlot;
    public byte power;
    public byte pwrSave = 2;
    public byte relay;
    public byte rxDly;
    public int rxFreq = 401025000;
    public byte rxSubCode;
    public byte rxType;
    public byte sq;
    public int txContact;
    public int txFreq = 401025000;
    public byte txSubCode;
    public byte txType;
    public byte volume;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public MixCheckMessage() {
        super(new Packet(Const.Command.SET_MIX_CHECK_INFO_CMD));
    }

    public MixCheckMessage(Packet packet) {
        super(packet);
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.putInt(this.rxFreq);
        allocate.putInt(this.txFreq);
        allocate.putInt(this.localID);
        ByteBuf allocate2 = ByteBuf.allocate(1024);
        for (int putInt : this.groupList) {
            allocate2.putInt(putInt);
        }
        allocate.put(allocate2.getArray());
        allocate.putInt(this.txContact);
        allocate.put(this.contactType);
        allocate.put(this.power);
        allocate.put(this.cc);
        allocate.put(this.inboundSlot);
        allocate.put(this.outboundSlot);
        allocate.put(this.channelMode);
        allocate.put(this.encryptSw);
        allocate.put(this.encryptKey);
        allocate.put(this.pwrSave);
        allocate.put(this.volume);
        allocate.put(this.mic);
        allocate.put(this.relay);
        allocate.put(this.sq);
        allocate.put(this.rxType);
        allocate.put(this.rxSubCode);
        allocate.put(this.txType);
        allocate.put(this.txSubCode);
        allocate.put(this.rxDly);
        return allocate.getArray();
    }
}
