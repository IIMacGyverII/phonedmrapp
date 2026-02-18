package com.pri.prizeinterphone.serial.data;

import android.os.Parcel;
import android.os.Parcelable;
/* loaded from: classes4.dex */
public class ConversationData implements Parcelable {
    public static final Parcelable.Creator<ConversationData> CREATOR = new Parcelable.Creator<ConversationData>() { // from class: com.pri.prizeinterphone.serial.data.ConversationData.1
        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public ConversationData createFromParcel(Parcel parcel) {
            return new ConversationData(parcel);
        }

        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public ConversationData[] newArray(int i) {
            return new ConversationData[i];
        }
    };
    int _id;
    int convTarget;
    int convType;
    String name;
    Long timestamp;
    int unReadCount;

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public ConversationData() {
        this._id = 0;
        this.convType = 0;
        this.convTarget = 0;
        this.name = "";
        this.timestamp = 0L;
        this.unReadCount = 0;
    }

    public ConversationData(int i, int i2, int i3, String str, Long l, int i4) {
        this._id = 0;
        this.convType = 0;
        this.convTarget = 0;
        this.name = "";
        this._id = i;
        this.convType = i2;
        this.convTarget = i3;
        this.name = str;
        this.timestamp = l;
        this.unReadCount = i4;
    }

    public int getId() {
        return this._id;
    }

    public void setId(int i) {
        this._id = i;
    }

    public int getConvType() {
        return this.convType;
    }

    public void setConvType(int i) {
        this.convType = i;
    }

    public int getConvTarget() {
        return this.convTarget;
    }

    public void setConvTarget(int i) {
        this.convTarget = i;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String str) {
        this.name = str;
    }

    public Long getTimestamp() {
        return this.timestamp;
    }

    public void setTimestamp(Long l) {
        this.timestamp = l;
    }

    public int getUnReadCount() {
        return this.unReadCount;
    }

    public void setUnReadCount(int i) {
        this.unReadCount = i;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this._id);
        parcel.writeInt(this.convType);
        parcel.writeInt(this.convTarget);
        parcel.writeString(this.name);
        parcel.writeLong(this.timestamp.longValue());
        parcel.writeInt(this.unReadCount);
    }

    protected ConversationData(Parcel parcel) {
        this._id = 0;
        this.convType = 0;
        this.convTarget = 0;
        this.name = "";
        this.timestamp = 0L;
        this.unReadCount = 0;
        this._id = parcel.readInt();
        this.convType = parcel.readInt();
        this.convTarget = parcel.readInt();
        this.name = parcel.readString();
        this.timestamp = Long.valueOf(parcel.readLong());
        this.unReadCount = parcel.readInt();
    }

    public String toString() {
        return "ConversationData{_id=" + this._id + ", convType=" + this.convType + ", convTarget=" + this.convTarget + ", name='" + this.name + "', timestamp=" + this.timestamp + ", unReadCount=" + this.unReadCount + '}';
    }
}
