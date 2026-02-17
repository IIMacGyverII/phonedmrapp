package com.mediatek.powerhalmgr;

import android.os.Parcel;
import android.os.Parcelable;
import java.util.Arrays;

public class BoosterInfo implements Parcelable {
    public static final int BOOSTER_ACTION_ADD_BY_LINKINFO = 4;
    public static final int BOOSTER_ACTION_ADD_BY_UID = 1;
    public static final int BOOSTER_ACTION_BASE = 0;
    public static final int BOOSTER_ACTION_DEL_ALL = 7;
    public static final int BOOSTER_ACTION_DEL_BY_LINKINFO = 5;
    public static final int BOOSTER_ACTION_DEL_BY_LINKINFO_ALL = 6;
    public static final int BOOSTER_ACTION_DEL_BY_UID = 2;
    public static final int BOOSTER_ACTION_DEL_BY_UID_ALL = 3;
    public static final int BOOSTER_GROUP_A = (0 + 1);
    public static final int BOOSTER_GROUP_B = (0 + 2);
    public static int BOOSTER_GROUP_BASE;
    public static final int BOOSTER_GROUP_C = (0 + 3);
    public static final int BOOSTER_GROUP_D;
    public static final int BOOSTER_GROUP_MAX;
    public static final Parcelable.Creator<BoosterInfo> CREATOR = new Parcelable.Creator<BoosterInfo>() {
        public BoosterInfo createFromParcel(Parcel parcel) {
            return new BoosterInfo(parcel);
        }

        public BoosterInfo[] newArray(int i) {
            return new BoosterInfo[i];
        }
    };
    private int mAction;
    private String mDstIp;
    private int mDstPort;
    private int mGroup;
    private String[] mMoreInfo;
    private int[] mMoreValue;
    private int mProto;
    private String mSrcIp;
    private int mSrcPort;
    private int mUid;

    public int describeContents() {
        return 0;
    }

    static {
        int i = 0 + 4;
        BOOSTER_GROUP_D = i;
        BOOSTER_GROUP_MAX = i;
    }

    public BoosterInfo(BoosterInfo boosterInfo) {
        this(boosterInfo.mGroup, boosterInfo.mAction, boosterInfo.mUid, boosterInfo.mSrcIp, boosterInfo.mDstIp, boosterInfo.mSrcPort, boosterInfo.mDstPort, boosterInfo.mProto, boosterInfo.mMoreInfo, boosterInfo.mMoreValue);
    }

    public BoosterInfo(int i, int i2, int i3) {
        this(i, i2, i3, (String) null, (String) null, -1, -1, -1, (String[]) null, (int[]) null);
    }

    public BoosterInfo(int i, int i2, String str, String str2, int i3, int i4, int i5) {
        this(i, i2, -1, str, str2, i3, i4, i5, (String[]) null, (int[]) null);
    }

    public BoosterInfo(int i, int i2) {
        this(i, i2, -1, (String) null, (String) null, -1, -1, -1, (String[]) null, (int[]) null);
    }

    public BoosterInfo(int i, int i2, int i3, String str, String str2, int i4, int i5, int i6) {
        this(i, i2, i3, str, str2, i4, i5, i6, (String[]) null, (int[]) null);
    }

    public BoosterInfo(int i, int i2, String[] strArr, int[] iArr) {
        this(i, i2, -1, (String) null, (String) null, -1, -1, -1, strArr, iArr);
    }

    public BoosterInfo(int i, int i2, int i3, String str, String str2, int i4, int i5, int i6, String[] strArr, int[] iArr) {
        this.mGroup = i;
        this.mAction = i2;
        this.mUid = i3;
        this.mSrcIp = str;
        this.mDstIp = str2;
        this.mSrcPort = i4;
        this.mDstPort = i5;
        this.mProto = i6;
        this.mMoreInfo = strArr;
        this.mMoreValue = iArr;
    }

    private BoosterInfo(Parcel parcel) {
        this.mGroup = -1;
        this.mAction = -1;
        this.mUid = -1;
        this.mSrcIp = null;
        this.mDstIp = null;
        this.mSrcPort = -1;
        this.mDstPort = -1;
        this.mProto = -1;
        this.mMoreInfo = null;
        this.mMoreValue = null;
        readFromParcel(parcel);
    }

    public int getGroup() {
        return this.mGroup;
    }

    public int getAction() {
        return this.mAction;
    }

    public int getUid() {
        return this.mUid;
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

    public String[] getMoreInfo() {
        return this.mMoreInfo;
    }

    public int[] getMoreValue() {
        return this.mMoreValue;
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this.mGroup);
        parcel.writeInt(this.mAction);
        parcel.writeInt(this.mUid);
        parcel.writeString(this.mSrcIp);
        parcel.writeString(this.mDstIp);
        parcel.writeInt(this.mSrcPort);
        parcel.writeInt(this.mDstPort);
        parcel.writeInt(this.mProto);
        parcel.writeStringArray(this.mMoreInfo);
        parcel.writeIntArray(this.mMoreValue);
    }

    private void readFromParcel(Parcel parcel) {
        this.mGroup = parcel.readInt();
        this.mAction = parcel.readInt();
        this.mUid = parcel.readInt();
        this.mSrcIp = parcel.readString();
        this.mDstIp = parcel.readString();
        this.mSrcPort = parcel.readInt();
        this.mDstPort = parcel.readInt();
        this.mProto = parcel.readInt();
        this.mMoreInfo = parcel.createStringArray();
        this.mMoreValue = parcel.createIntArray();
    }

    public String toString() {
        return "BoosterInfo(" + this.mGroup + "," + this.mAction + "," + this.mUid + "," + this.mSrcIp + "," + this.mDstIp + "," + this.mSrcPort + "," + this.mDstPort + "," + this.mProto + "," + Arrays.toString(this.mMoreInfo) + "," + Arrays.toString(this.mMoreValue) + ")";
    }
}
