package com.pri.prizeinterphone.message;

import com.pri.prizeinterphone.Util.ByteBuf;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;

public class AnalogMessage extends BaseMessage {
    private static final String TAG = "AnalogMessage";
    public byte band;
    public byte monitor;
    public byte power;
    public byte pwrSave;
    public byte relay;
    public int rxFreq;
    public byte rxSubCode;
    public byte rxType;
    public byte sq;
    public int txFreq;
    public byte txSubCode;
    public byte txType;
    public byte volume;

    /* access modifiers changed from: protected */
    public void decodeBody(byte[] bArr) {
    }

    public AnalogMessage() {
        this((byte) Const.Command.SET_ANALOG_INFO_CMD);
    }

    public AnalogMessage(@Const.AnalogCmdType byte b) {
        super(new Packet(b));
        this.rxFreq = 4010250;
        this.txFreq = 4010250;
        this.band = 1;
        this.sq = 2;
        this.pwrSave = 2;
        this.volume = 8;
        this.monitor = 2;
        this.relay = 2;
    }

    public AnalogMessage(Packet packet) {
        super(packet);
        this.rxFreq = 4010250;
        this.txFreq = 4010250;
        this.band = 1;
        this.sq = 2;
        this.pwrSave = 2;
        this.volume = 8;
        this.monitor = 2;
        this.relay = 2;
    }

    /* access modifiers changed from: protected */
    public byte[] encodeBody() {
        ByteBuf allocate = ByteBuf.allocate(19);
        allocate.putInt(this.rxFreq);
        allocate.putInt(this.txFreq);
        allocate.put(this.band);
        allocate.put(this.power);
        allocate.put(this.sq);
        allocate.put(this.rxType);
        allocate.put(this.rxSubCode);
        allocate.put(this.txType);
        allocate.put(this.txSubCode);
        allocate.put(this.pwrSave);
        allocate.put(this.volume);
        allocate.put(this.monitor);
        allocate.put(this.relay);
        return allocate.getArray();
    }

    public String toString() {
        return "AnalogMessage{rxFreq=" + this.rxFreq + ", txFreq=" + this.txFreq + ", band=" + this.band + ", power=" + this.power + ", sq=" + this.sq + ", rxType=" + this.rxType + ", rxSubCode=" + this.rxSubCode + ", txType=" + this.txType + ", txSubCode=" + this.txSubCode + ", pwrSave=" + this.pwrSave + ", volume=" + this.volume + ", monitor=" + this.monitor + ", relay=" + this.relay + '}';
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

    public byte getBand() {
        return this.band;
    }

    public void setBand(byte b) {
        this.band = b;
    }

    public byte getPower() {
        return this.power;
    }

    public void setPower(byte b) {
        this.power = b;
    }

    public byte getSq() {
        return this.sq;
    }

    public void setSq(byte b) {
        this.sq = b;
    }

    public byte getRxType() {
        return this.rxType;
    }

    public void setRxType(byte b) {
        this.rxType = b;
    }

    public byte getRxSubCode() {
        return this.rxSubCode;
    }

    public void setRxSubCode(byte b) {
        this.rxSubCode = b;
    }

    public byte getTxType() {
        return this.txType;
    }

    public void setTxType(byte b) {
        this.txType = b;
    }

    public byte getTxSubCode() {
        return this.txSubCode;
    }

    public void setTxSubCode(byte b) {
        this.txSubCode = b;
    }

    public byte getPwrSave() {
        return this.pwrSave;
    }

    public void setPwrSave(byte b) {
        this.pwrSave = b;
    }

    public byte getVolume() {
        return this.volume;
    }

    public void setVolume(byte b) {
        this.volume = b;
    }

    public byte getMonitor() {
        return this.monitor;
    }

    public void setMonitor(byte b) {
        this.monitor = b;
    }

    public byte getRelay() {
        return this.relay;
    }

    public void setRelay(byte b) {
        this.relay = b;
    }
}
