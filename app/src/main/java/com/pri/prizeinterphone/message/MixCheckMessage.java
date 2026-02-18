package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class MixCheckMessage extends BaseMessage {
    public byte cc;
    public byte channelMode;
    public byte contactType;
    public byte[] encryptKey;
    public byte encryptSw;
    public int[] groupList;
    public byte inboundSlot;
    public int localID;
    public byte mic;
    public byte outboundSlot;
    public byte power;
    public byte pwrSave;
    public byte relay;
    public byte rxDly;
    public int rxFreq;
    public byte rxSubCode;
    public byte rxType;
    public byte sq;
    public int txContact;
    public int txFreq;
    public byte txSubCode;
    public byte txType;
    public byte volume;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public MixCheckMessage() {
        super(new Packet(Const.Command.SET_MIX_CHECK_INFO_CMD));
        this.rxFreq = 401025000;
        this.txFreq = 401025000;
        this.localID = 1;
        this.groupList = new int[32];
        this.encryptSw = (byte) 2;
        this.encryptKey = new byte[8];
        this.pwrSave = (byte) 2;
    }

    public MixCheckMessage(Packet packet) {
        super(packet);
        this.rxFreq = 401025000;
        this.txFreq = 401025000;
        this.localID = 1;
        this.groupList = new int[32];
        this.encryptSw = (byte) 2;
        this.encryptKey = new byte[8];
        this.pwrSave = (byte) 2;
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(1024);
        allocate.putInt(this.rxFreq);
        allocate.putInt(this.txFreq);
        allocate.putInt(this.localID);
        ByteBuf allocate2 = ByteBuf.allocate(1024);
        for (int i : this.groupList) {
            allocate2.putInt(i);
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
