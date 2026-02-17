package com.pri.prizeinterphone.serial.data;

import android.os.Parcel;
import android.os.Parcelable;
import android.text.TextUtils;
import androidx.annotation.NonNull;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ChannelData implements Parcelable, Cloneable {
    public static final Parcelable.Creator<ChannelData> CREATOR = new Parcelable.Creator<ChannelData>() {
        public ChannelData createFromParcel(Parcel parcel) {
            return new ChannelData(parcel);
        }

        public ChannelData[] newArray(int i) {
            return new ChannelData[i];
        }
    };
    public int _id;
    public int active;
    public int band;
    public int cc;
    public int channelMode;
    public int contactType;
    public String encryptKey;
    public int encryptSw;
    public int[] groups;
    public int inBoundSlot;
    public int interrupt;
    public int mic;
    public String name;
    public int number;
    public int outBoundSlot;
    public int power;
    public int relay;
    public int rxFreq;
    public int rxSubCode;
    public int rxType;
    public int sq;
    public int txContact;
    public int txFreq;
    public int txSubCode;
    public int txType;
    public int type;

    public interface ChannelContactType {
        public static final int ALL = 2;
        public static final int GROUP = 1;
        public static final int PERSON = 0;
    }

    public interface ChannelInterrupt {
        public static final int OFF = 2;
        public static final int OPEN = 1;
        public static final int TRANSPORT = 3;
    }

    public interface ChannelPower {
        public static final int HIGE = 1;
        public static final int LOW = 0;
    }

    public interface ChannelType {
        public static final int ANALOG = 1;
        public static final int DIGITAL = 0;
    }

    public int describeContents() {
        return 0;
    }

    public ChannelData() {
        this.type = 0;
        this.number = 0;
        this.txFreq = 401025000;
        this.rxFreq = 401025000;
        this.power = 1;
        this.cc = 1;
        this.inBoundSlot = 0;
        this.outBoundSlot = 0;
        this.channelMode = 0;
        this.contactType = 0;
        this.txContact = 1;
        this.encryptSw = 2;
        this.encryptKey = "";
        this.mic = 0;
        this.relay = 2;
        this.interrupt = 2;
        this.band = 0;
        this.sq = 2;
        this.rxType = 0;
        this.rxSubCode = 0;
        this.txType = 0;
        this.txSubCode = 0;
        this.active = 0;
        int[] iArr = new int[32];
        this.groups = iArr;
        Arrays.fill(iArr, 0);
        this.groups[0] = 1;
    }

    public ChannelData(int i, String str, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, String str2, int i14, int i15, int i16, int i17, int i18, int i19, int i20, int i21, int i22, int[] iArr) {
        this.mic = 0;
        this._id = i;
        this.name = str;
        this.type = i2;
        this.number = i3;
        this.txFreq = i4;
        this.rxFreq = i5;
        this.power = i6;
        this.cc = i7;
        this.inBoundSlot = i8;
        this.outBoundSlot = i9;
        this.channelMode = i10;
        this.contactType = i11;
        this.txContact = i12;
        this.encryptSw = i13;
        this.encryptKey = str2;
        this.relay = i14;
        this.interrupt = i15;
        this.band = i16;
        this.sq = i17;
        this.rxType = i18;
        this.rxSubCode = i19;
        this.txType = i20;
        this.txSubCode = i21;
        this.active = i22;
        this.groups = iArr;
    }

    public int getId() {
        return this._id;
    }

    public void setId(int i) {
        this._id = i;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String str) {
        this.name = str;
    }

    public int getType() {
        return this.type;
    }

    public void setType(int i) {
        this.type = i;
    }

    public int getNumber() {
        return this.number;
    }

    public void setNumber(int i) {
        this.number = i;
    }

    public int getTxFreq() {
        return this.txFreq;
    }

    public void setTxFreq(int i) {
        this.txFreq = i;
    }

    public int getRxFreq() {
        return this.rxFreq;
    }

    public void setRxFreq(int i) {
        this.rxFreq = i;
    }

    public int getPower() {
        return this.power;
    }

    public void setPower(int i) {
        this.power = i;
    }

    public int getCc() {
        return this.cc;
    }

    public void setCc(int i) {
        this.cc = i;
    }

    public int getInBoundSlot() {
        return this.inBoundSlot;
    }

    public void setInBoundSlot(int i) {
        this.inBoundSlot = i;
    }

    public int getOutBoundSlot() {
        return this.outBoundSlot;
    }

    public void setOutBoundSlot(int i) {
        this.outBoundSlot = i;
    }

    public int getChannelMode() {
        return this.channelMode;
    }

    public void setChannelMode(int i) {
        this.channelMode = i;
    }

    public int getContactType() {
        return this.contactType;
    }

    public void setContactType(int i) {
        this.contactType = i;
    }

    public int getTxContact() {
        return this.txContact;
    }

    public void setTxContact(int i) {
        this.txContact = i;
    }

    public int getEncryptSw() {
        return this.encryptSw;
    }

    public void setEncryptSw(int i) {
        this.encryptSw = i;
    }

    public String getEncryptKey() {
        return this.encryptKey;
    }

    public void setEncryptKey(String str) {
        this.encryptKey = str;
    }

    public int getRelay() {
        return this.relay;
    }

    public void setRelay(int i) {
        this.relay = i;
    }

    public int getInterrupt() {
        return this.interrupt;
    }

    public void setInterrupt(int i) {
        this.interrupt = i;
    }

    public int getBand() {
        return this.band;
    }

    public void setBand(int i) {
        this.band = i;
    }

    public int getSq() {
        return this.sq;
    }

    public void setSq(int i) {
        this.sq = i;
    }

    public int getRxType() {
        return this.rxType;
    }

    public void setRxType(int i) {
        this.rxType = i;
    }

    public int getRxSubCode() {
        return this.rxSubCode;
    }

    public void setRxSubCode(int i) {
        this.rxSubCode = i;
    }

    public int getTxType() {
        return this.txType;
    }

    public void setTxType(int i) {
        this.txType = i;
    }

    public int getTxSubCode() {
        return this.txSubCode;
    }

    public void setTxSubCode(int i) {
        this.txSubCode = i;
    }

    public int getActive() {
        return this.active;
    }

    public void setActive(int i) {
        this.active = i;
    }

    public int[] getGroups() {
        return this.groups;
    }

    public void setGroups(int[] iArr) {
        this.groups = iArr;
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this._id);
        parcel.writeString(this.name);
        parcel.writeInt(this.type);
        parcel.writeInt(this.number);
        parcel.writeInt(this.txFreq);
        parcel.writeInt(this.rxFreq);
        parcel.writeInt(this.power);
        parcel.writeInt(this.cc);
        parcel.writeInt(this.inBoundSlot);
        parcel.writeInt(this.outBoundSlot);
        parcel.writeInt(this.channelMode);
        parcel.writeInt(this.contactType);
        parcel.writeInt(this.txContact);
        parcel.writeInt(this.encryptSw);
        parcel.writeString(this.encryptKey);
        parcel.writeInt(this.relay);
        parcel.writeInt(this.interrupt);
        parcel.writeInt(this.band);
        parcel.writeInt(this.sq);
        parcel.writeInt(this.rxType);
        parcel.writeInt(this.rxSubCode);
        parcel.writeInt(this.txType);
        parcel.writeInt(this.txSubCode);
        parcel.writeInt(this.active);
        parcel.writeIntArray(this.groups);
    }

    protected ChannelData(Parcel parcel) {
        this.type = 0;
        this.number = 0;
        this.txFreq = 401025000;
        this.rxFreq = 401025000;
        this.power = 1;
        this.cc = 1;
        this.inBoundSlot = 0;
        this.outBoundSlot = 0;
        this.channelMode = 0;
        this.contactType = 0;
        this.txContact = 1;
        this.encryptSw = 2;
        this.encryptKey = "";
        this.mic = 0;
        this.relay = 2;
        this.interrupt = 2;
        this.band = 0;
        this.sq = 2;
        this.rxType = 0;
        this.rxSubCode = 0;
        this.txType = 0;
        this.txSubCode = 0;
        this.active = 0;
        this.groups = new int[32];
        this._id = parcel.readInt();
        this.name = parcel.readString();
        this.type = parcel.readInt();
        this.number = parcel.readInt();
        this.txFreq = parcel.readInt();
        this.rxFreq = parcel.readInt();
        this.power = parcel.readInt();
        this.cc = parcel.readInt();
        this.inBoundSlot = parcel.readInt();
        this.outBoundSlot = parcel.readInt();
        this.channelMode = parcel.readInt();
        this.contactType = parcel.readInt();
        this.txContact = parcel.readInt();
        this.encryptSw = parcel.readInt();
        this.encryptKey = parcel.readString();
        this.relay = parcel.readInt();
        this.interrupt = parcel.readInt();
        this.band = parcel.readInt();
        this.sq = parcel.readInt();
        this.rxType = parcel.readInt();
        this.rxSubCode = parcel.readInt();
        this.txType = parcel.readInt();
        this.txSubCode = parcel.readInt();
        this.active = parcel.readInt();
        int[] iArr = new int[32];
        this.groups = iArr;
        parcel.readIntArray(iArr);
    }

    public List<Integer> stringToIntList(String str) {
        if (TextUtils.isEmpty(str)) {
            return null;
        }
        String[] split = str.split(",");
        ArrayList arrayList = new ArrayList();
        for (String parseInt : split) {
            arrayList.add(Integer.valueOf(Integer.parseInt(parseInt)));
        }
        return arrayList;
    }

    public String intListToString(List<Integer> list) {
        String str = "";
        for (Integer next : list) {
            if (TextUtils.isEmpty(str)) {
                str = str + next + "";
            } else {
                str = str + "," + next;
            }
        }
        return str;
    }

    public String toString() {
        return "ChannelData{_id=" + this._id + ", name='" + this.name + '\'' + ", type=" + this.type + ", number=" + this.number + ", txFreq=" + this.txFreq + ", rxFreq=" + this.rxFreq + ", power=" + this.power + ", cc=" + this.cc + ", inBoundSlot=" + this.inBoundSlot + ", outBoundSlot=" + this.outBoundSlot + ", channelMode=" + this.channelMode + ", contactType=" + this.contactType + ", txContact=" + this.txContact + ", encryptSw=" + this.encryptSw + ", encryptKey='" + this.encryptKey + '\'' + ", relay=" + this.relay + ", interrupt=" + this.interrupt + ", band=" + this.band + ", sq=" + this.sq + ", rxType=" + this.rxType + ", rxSubCode=" + this.rxSubCode + ", txType=" + this.txType + ", txSubCode=" + this.txSubCode + ", active=" + this.active + ", groups=" + Arrays.toString(this.groups) + '}';
    }

    @NonNull
    public ChannelData clone() throws CloneNotSupportedException {
        ChannelData channelData = (ChannelData) super.clone();
        channelData._id = this._id;
        channelData.name = this.name;
        channelData.type = this.type;
        channelData.number = this.number;
        channelData.txFreq = this.txFreq;
        channelData.rxFreq = this.rxFreq;
        channelData.power = this.power;
        channelData.cc = this.cc;
        channelData.inBoundSlot = this.inBoundSlot;
        channelData.outBoundSlot = this.outBoundSlot;
        channelData.channelMode = this.channelMode;
        channelData.contactType = this.contactType;
        channelData.txContact = this.txContact;
        channelData.encryptSw = this.encryptSw;
        channelData.encryptKey = this.encryptKey;
        channelData.relay = this.relay;
        channelData.interrupt = this.interrupt;
        channelData.band = this.band;
        channelData.sq = this.sq;
        channelData.rxType = this.rxType;
        channelData.rxSubCode = this.rxSubCode;
        channelData.txType = this.txType;
        channelData.txSubCode = this.txSubCode;
        channelData.active = this.active;
        int i = 0;
        while (true) {
            int[] iArr = this.groups;
            if (i >= iArr.length) {
                return channelData;
            }
            channelData.groups[i] = iArr[i];
            i++;
        }
    }
}
