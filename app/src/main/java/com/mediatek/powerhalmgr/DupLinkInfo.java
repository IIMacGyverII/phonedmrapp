package com.mediatek.powerhalmgr;

import android.os.Parcel;
import android.os.Parcelable;

public class DupLinkInfo implements Parcelable {
    public static final Parcelable.Creator<DupLinkInfo> CREATOR = new Parcelable.Creator<DupLinkInfo>() {
        public DupLinkInfo createFromParcel(Parcel parcel) {
            return new DupLinkInfo(parcel);
        }

        public DupLinkInfo[] newArray(int i) {
            return new DupLinkInfo[i];
        }
    };
    private String mDstIp;
    private int mDstPort;
    private int mProto;
    private String mSrcIp;
    private int mSrcPort;

    public int describeContents() {
        return 0;
    }

    public String getSrcIp() {
        return this.mSrcIp;
    }

    public String getDstIp() {
        return this.mDstIp;
    }

    public int getSrcPort() {
        return this.mSrcPort;
    }

    public int getDstPort() {
        return this.mDstPort;
    }

    public int getProto() {
        return this.mProto;
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(this.mSrcIp);
        parcel.writeString(this.mDstIp);
        parcel.writeInt(this.mSrcPort);
        parcel.writeInt(this.mDstPort);
        parcel.writeInt(this.mProto);
    }

    public void readFromParcel(Parcel parcel) {
        this.mSrcIp = parcel.readString();
        this.mDstIp = parcel.readString();
        this.mSrcPort = parcel.readInt();
        this.mDstPort = parcel.readInt();
        this.mProto = parcel.readInt();
    }

    public DupLinkInfo(String str, String str2, int i, int i2, int i3) {
        this.mSrcIp = str;
        this.mDstIp = str2;
        this.mSrcPort = i;
        this.mDstPort = i2;
        this.mProto = i3;
    }

    private DupLinkInfo(Parcel parcel) {
        this.mSrcIp = parcel.readString();
        this.mDstIp = parcel.readString();
        this.mSrcPort = parcel.readInt();
        this.mDstPort = parcel.readInt();
        this.mProto = parcel.readInt();
    }

    public String toString() {
        return "DupLinkInfo(" + this.mSrcIp + "," + this.mDstIp + "," + this.mSrcPort + "," + this.mDstPort + "," + this.mProto + ")";
    }
}
