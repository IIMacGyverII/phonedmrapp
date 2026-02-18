package com.pri.prizeinterphone.config.data;

import android.os.Parcel;
import android.os.Parcelable;
/* loaded from: classes4.dex */
public class InsertChannel implements Parcelable {
    public static final Parcelable.Creator<InsertChannel> CREATOR = new Parcelable.Creator<InsertChannel>() { // from class: com.pri.prizeinterphone.config.data.InsertChannel.1
        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public InsertChannel createFromParcel(Parcel parcel) {
            return new InsertChannel(parcel);
        }

        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public InsertChannel[] newArray(int i) {
            return new InsertChannel[i];
        }
    };
    private static final String TAG = "InsertChannel";
    private String band;
    protected String channeltype;
    private String colorcode;
    private String contactype;
    private String encryptSwitch;
    private String encryptText;
    private String groupvalue;
    protected String name;
    private String number;
    protected String power;
    private String recGroup;
    protected String recfreq;
    private String recvsubaudiofreq;
    private String recvsubaudiotype;
    protected String sendfreq;
    private String sendsubaudiofreq;
    private String sendsubaudiotype;
    private String slotmode;
    private String squelchlevel;

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public String getName() {
        return this.name;
    }

    public String getSendfreq() {
        return this.sendfreq;
    }

    public String getRecfreq() {
        return this.recfreq;
    }

    public String getChanneltype() {
        return this.channeltype;
    }

    public String getPower() {
        return this.power;
    }

    public String getBand() {
        return this.band;
    }

    public String getSquelchlevel() {
        return this.squelchlevel;
    }

    public String getRecvsubaudiotype() {
        return this.recvsubaudiotype;
    }

    public String getSendsubaudiotype() {
        return this.sendsubaudiotype;
    }

    public String getColorcode() {
        return this.colorcode;
    }

    public String getSlotmode() {
        return this.slotmode;
    }

    public String getContactype() {
        return this.contactype;
    }

    public String getEncryptSwitch() {
        return this.encryptSwitch;
    }

    public String getEncryptText() {
        return this.encryptText;
    }

    public String getGroupvalue() {
        return this.groupvalue;
    }

    public void setRecvsubaudiofreq(String str) {
        this.recvsubaudiofreq = str;
    }

    public void setSendsubaudiofreq(String str) {
        this.sendsubaudiofreq = str;
    }

    public String getRecvsubaudiofreq() {
        return this.recvsubaudiofreq;
    }

    public String getSendsubaudiofreq() {
        return this.sendsubaudiofreq;
    }

    public void setNumber(String str) {
        this.number = str;
    }

    public String getNumber() {
        return this.number;
    }

    public String getRecGroup() {
        return this.recGroup;
    }

    public void setRecGroup(String str) {
        this.recGroup = str;
    }

    public String toString() {
        return "InsertChannel{name='" + this.name + "', sendfreq='" + this.sendfreq + "', recfreq='" + this.recfreq + "', channeltype='" + this.channeltype + "', power='" + this.power + "', band='" + this.band + "', squelchlevel='" + this.squelchlevel + "', recvsubaudiotype='" + this.recvsubaudiotype + "', sendsubaudiotype='" + this.sendsubaudiotype + "', recvsubaudiofreq='" + this.recvsubaudiofreq + "', sendsubaudiofreq='" + this.sendsubaudiofreq + "', colorcode='" + this.colorcode + "', slotmode='" + this.slotmode + "', contactype='" + this.contactype + "', number='" + this.number + "', recGroup='" + this.recGroup + "', encryptSwitch='" + this.encryptSwitch + "', encryptText='" + this.encryptText + "', groupvalue='" + this.groupvalue + "'}";
    }

    private InsertChannel(Builder builder) {
        this.name = builder.name;
        this.sendfreq = builder.sendfreq;
        this.recfreq = builder.recfreq;
        this.channeltype = builder.channeltype;
        this.power = builder.power;
        this.band = builder.band;
        this.squelchlevel = builder.squelchlevel;
        this.recvsubaudiotype = builder.recvsubaudiotype;
        this.sendsubaudiotype = builder.sendsubaudiotype;
        this.colorcode = builder.colorcode;
        this.slotmode = builder.slotmode;
        this.contactype = builder.contactype;
        this.encryptSwitch = builder.encryptSwitch;
        this.encryptText = builder.encryptText;
        this.groupvalue = builder.groupvalue;
        setRecvsubaudiofreq(builder.recvsubaudiofreq);
        setSendsubaudiofreq(builder.sendsubaudiofreq);
        this.recvsubaudiofreq = builder.recvsubaudiofreq;
        this.sendsubaudiofreq = builder.sendsubaudiofreq;
        setNumber(builder.number);
        this.number = builder.number;
        setRecGroup(builder.recGroup);
        this.recGroup = builder.recGroup;
    }

    /* loaded from: classes4.dex */
    public static final class Builder {
        private String band;
        private String channeltype;
        private String colorcode;
        private String contactype;
        private String encryptSwitch;
        private String encryptText;
        private String groupvalue;
        private String name;
        private String number;
        private String power;
        private String recGroup;
        private String recfreq;
        private String recvsubaudiofreq;
        private String recvsubaudiotype;
        private String sendfreq;
        private String sendsubaudiofreq;
        private String sendsubaudiotype;
        private String slotmode;
        private String squelchlevel;

        public Builder withRecvSubaudioFreq(String str) {
            this.recvsubaudiofreq = str;
            return this;
        }

        public Builder withSendSubaudioFreq(String str) {
            this.sendsubaudiofreq = str;
            return this;
        }

        public Builder withNumber(String str) {
            this.number = str;
            return this;
        }

        public Builder withRecGroup(String str) {
            this.recGroup = str;
            return this;
        }

        public Builder withName(String str) {
            this.name = str;
            return this;
        }

        public Builder withSendfreq(String str) {
            this.sendfreq = str;
            return this;
        }

        public Builder withRecfreq(String str) {
            this.recfreq = str;
            return this;
        }

        public Builder withChanneltype(String str) {
            this.channeltype = str;
            return this;
        }

        public Builder withPower(String str) {
            this.power = str;
            return this;
        }

        public Builder withBand(String str) {
            this.band = str;
            return this;
        }

        public Builder withSquelchlevel(String str) {
            this.squelchlevel = str;
            return this;
        }

        public Builder withRecvsubaudiotype(String str) {
            this.recvsubaudiotype = str;
            return this;
        }

        public Builder withSendsubaudiotype(String str) {
            this.sendsubaudiotype = str;
            return this;
        }

        public Builder withColorcode(String str) {
            this.colorcode = str;
            return this;
        }

        public Builder withSlotmode(String str) {
            this.slotmode = str;
            return this;
        }

        public Builder withContactype(String str) {
            this.contactype = str;
            return this;
        }

        public Builder withEncryptSwitch(String str) {
            this.encryptSwitch = str;
            return this;
        }

        public Builder withEncryptText(String str) {
            this.encryptText = str;
            return this;
        }

        public Builder withGroupvalue(String str) {
            this.groupvalue = str;
            return this;
        }

        public InsertChannel build() {
            return new InsertChannel(this);
        }
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(this.name);
        parcel.writeString(this.sendfreq);
        parcel.writeString(this.recfreq);
        parcel.writeString(this.channeltype);
        parcel.writeString(this.power);
        parcel.writeString(this.band);
        parcel.writeString(this.squelchlevel);
        parcel.writeString(this.recvsubaudiotype);
        parcel.writeString(this.sendsubaudiotype);
        parcel.writeString(this.colorcode);
        parcel.writeString(this.slotmode);
        parcel.writeString(this.contactype);
        parcel.writeString(this.encryptSwitch);
        parcel.writeString(this.encryptText);
        parcel.writeString(this.groupvalue);
        parcel.writeString(this.recvsubaudiofreq);
        parcel.writeString(this.sendsubaudiofreq);
        parcel.writeString(this.number);
        parcel.writeString(this.recGroup);
    }

    public void readFromParcel(Parcel parcel) {
        this.name = parcel.readString();
        this.sendfreq = parcel.readString();
        this.recfreq = parcel.readString();
        this.channeltype = parcel.readString();
        this.power = parcel.readString();
        this.band = parcel.readString();
        this.squelchlevel = parcel.readString();
        this.recvsubaudiotype = parcel.readString();
        this.sendsubaudiotype = parcel.readString();
        this.colorcode = parcel.readString();
        this.slotmode = parcel.readString();
        this.contactype = parcel.readString();
        this.encryptSwitch = parcel.readString();
        this.encryptText = parcel.readString();
        this.groupvalue = parcel.readString();
        this.recvsubaudiofreq = parcel.readString();
        this.sendsubaudiofreq = parcel.readString();
        this.number = parcel.readString();
        this.recGroup = parcel.readString();
    }

    protected InsertChannel(Parcel parcel) {
        this.name = parcel.readString();
        this.sendfreq = parcel.readString();
        this.recfreq = parcel.readString();
        this.channeltype = parcel.readString();
        this.power = parcel.readString();
        this.band = parcel.readString();
        this.squelchlevel = parcel.readString();
        this.recvsubaudiotype = parcel.readString();
        this.sendsubaudiotype = parcel.readString();
        this.colorcode = parcel.readString();
        this.slotmode = parcel.readString();
        this.contactype = parcel.readString();
        this.encryptSwitch = parcel.readString();
        this.encryptText = parcel.readString();
        this.groupvalue = parcel.readString();
        this.recvsubaudiofreq = parcel.readString();
        this.sendsubaudiofreq = parcel.readString();
        this.number = parcel.readString();
        this.recGroup = parcel.readString();
    }
}
