package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import java.util.Arrays;
/* loaded from: classes4.dex */
public class DigitalMessage extends BaseMessage {
    public byte cc;
    public byte channelMode;
    public byte contactType;
    public byte[] encryptKey;
    public byte encryptSw;
    public int[] groupList;
    public byte inboundSlot;
    public int localId;
    public byte mic;
    public byte outboundSlot;
    public byte power;
    public byte pwrSave;
    public byte relay;
    public int rxFreq;
    public int txContact;
    public int txFreq;
    public byte volume;

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected void decodeBody(byte[] bArr) {
    }

    public DigitalMessage() {
        this((byte) Const.Command.SET_DIGITAL_INFO_CMD);
    }

    public DigitalMessage(@Const.DigitalCmdType byte b) {
        super(new Packet(b));
        this.rxFreq = 401025000;
        this.txFreq = 401025000;
        this.localId = 1;
        int[] iArr = new int[32];
        this.groupList = iArr;
        this.txContact = 1;
        this.contactType = (byte) 1;
        this.power = (byte) 1;
        this.cc = (byte) 1;
        this.inboundSlot = (byte) 0;
        this.outboundSlot = (byte) 0;
        this.channelMode = (byte) 0;
        this.encryptSw = (byte) 2;
        this.encryptKey = new byte[8];
        this.pwrSave = (byte) 1;
        this.volume = (byte) 8;
        this.mic = (byte) 0;
        this.relay = (byte) 2;
        Arrays.fill(iArr, 0);
        this.groupList[0] = 1;
    }

    public int getRxFreq() {
        return this.rxFreq;
    }

    public void setRxFreq(int i) {
        this.rxFreq = i;
    }

    public int getTxFreq() {
        return this.txFreq;
    }

    public void setTxFreq(int i) {
        this.txFreq = i;
    }

    public int getLocalId() {
        return this.localId;
    }

    public void setLocalId(int i) {
        this.localId = i;
    }

    public int[] getGroupList() {
        return this.groupList;
    }

    public void setGroupList(int[] iArr) {
        this.groupList = iArr;
    }

    public int getTxContact() {
        return this.txContact;
    }

    public void setTxContact(int i) {
        this.txContact = i;
    }

    public byte getContactType() {
        return this.contactType;
    }

    public void setContactType(byte b) {
        this.contactType = b;
    }

    public DigitalMessage(Packet packet) {
        super(packet);
        this.rxFreq = 401025000;
        this.txFreq = 401025000;
        this.localId = 1;
        this.groupList = new int[32];
        this.txContact = 1;
        this.contactType = (byte) 1;
        this.power = (byte) 1;
        this.cc = (byte) 1;
        this.inboundSlot = (byte) 0;
        this.outboundSlot = (byte) 0;
        this.channelMode = (byte) 0;
        this.encryptSw = (byte) 2;
        this.encryptKey = new byte[8];
        this.pwrSave = (byte) 1;
        this.volume = (byte) 8;
        this.mic = (byte) 0;
        this.relay = (byte) 2;
    }

    @Override // com.pri.prizeinterphone.message.BaseMessage
    protected byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(163);
        allocate.putInt(this.rxFreq);
        allocate.putInt(this.txFreq);
        allocate.putInt(this.localId);
        ByteBuf allocate2 = ByteBuf.allocate(128);
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
        return allocate.getArray();
    }

    public String toString() {
        return "DigitalMessage{rxFreq=" + this.rxFreq + ", txFreq=" + this.txFreq + ", localId=" + this.localId + ", groupList=[" + Arrays.toString(this.groupList) + "], txContact=" + this.txContact + ", contactType=" + ((int) this.contactType) + ", power=" + ((int) this.power) + ", cc=" + ((int) this.cc) + ", inboundSlot=" + ((int) this.inboundSlot) + ", outboundSlot=" + ((int) this.outboundSlot) + ", channelMode=" + ((int) this.channelMode) + ", encryptSw=" + ((int) this.encryptSw) + ", encryptKey=" + Arrays.toString(this.encryptKey) + ", pwrSave=" + ((int) this.pwrSave) + ", volume=" + ((int) this.volume) + ", mic=" + ((int) this.mic) + ", relay=" + ((int) this.relay) + '}';
    }
}
