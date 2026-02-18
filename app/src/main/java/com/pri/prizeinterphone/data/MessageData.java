package com.pri.prizeinterphone.data;

import android.os.Parcel;
import android.os.Parcelable;
/* loaded from: classes4.dex */
public class MessageData implements Parcelable {
    public static final Parcelable.Creator<MessageData> CREATOR = new Parcelable.Creator<MessageData>() { // from class: com.pri.prizeinterphone.data.MessageData.1
        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public MessageData createFromParcel(Parcel parcel) {
            return new MessageData(parcel);
        }

        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public MessageData[] newArray(int i) {
            return new MessageData[i];
        }
    };
    public int isRecieve;
    public String time;
    public String value;

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public MessageData(String str, String str2, int i) {
        this.time = str;
        this.value = str2;
        this.isRecieve = i;
    }

    protected MessageData(Parcel parcel) {
        this.time = parcel.readString();
        this.value = parcel.readString();
        this.isRecieve = parcel.readInt();
    }

    public void setTime(String str) {
        this.time = str;
    }

    public String getTime() {
        return this.time;
    }

    public void setValue(String str) {
        this.value = str;
    }

    public String getValue() {
        return this.value;
    }

    public void setIsRecieve(int i) {
        this.isRecieve = i;
    }

    public boolean getIsRecieve() {
        return this.isRecieve == 1;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(this.time);
        parcel.writeString(this.value);
        parcel.writeInt(this.isRecieve);
    }
}
