package com.pri.prizeinterphone.serial.data;

import android.os.Parcel;
import android.os.Parcelable;

public class MessageListData implements Parcelable {
    public static final Parcelable.Creator<MessageListData> CREATOR = new Parcelable.Creator<MessageListData>() {
        public MessageListData createFromParcel(Parcel parcel) {
            return new MessageListData(parcel);
        }

        public MessageListData[] newArray(int i) {
            return new MessageListData[i];
        }
    };
    public String id;
    public String value;

    public int describeContents() {
        return 0;
    }

    public MessageListData(String str, String str2) {
        this.id = str;
        this.value = str2;
    }

    protected MessageListData(Parcel parcel) {
        this.id = parcel.readString();
        this.value = parcel.readString();
    }

    public void setId(String str) {
        this.id = str;
    }

    public String getId() {
        return this.id;
    }

    public void setValue(String str) {
        this.value = str;
    }

    public String getValue() {
        return this.value;
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(this.id);
        parcel.writeString(this.value);
    }
}
