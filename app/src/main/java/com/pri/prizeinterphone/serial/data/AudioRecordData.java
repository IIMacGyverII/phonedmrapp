package com.pri.prizeinterphone.serial.data;

import android.os.Parcel;
import android.os.Parcelable;
/* loaded from: classes4.dex */
public class AudioRecordData implements Parcelable {
    public static final Parcelable.Creator<AudioRecordData> CREATOR = new Parcelable.Creator<AudioRecordData>() { // from class: com.pri.prizeinterphone.serial.data.AudioRecordData.1
        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public AudioRecordData createFromParcel(Parcel parcel) {
            return new AudioRecordData(parcel);
        }

        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public AudioRecordData[] newArray(int i) {
            return new AudioRecordData[i];
        }
    };
    public String channelName;
    public int direction;
    public String filePath;
    public long id;
    public boolean isplay;
    public String name;
    public long timestamp;

    /* loaded from: classes4.dex */
    public interface SmsDirection {
        public static final int RECEIVE = 1;
        public static final int SENT = 0;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public AudioRecordData(long j, String str, String str2, long j2, int i, String str3) {
        this.isplay = false;
        this.id = j;
        this.name = str;
        this.channelName = str2;
        this.timestamp = j2;
        this.direction = i;
        this.filePath = str3;
    }

    public AudioRecordData() {
        this.id = 0L;
        this.name = "";
        this.channelName = "";
        this.timestamp = 0L;
        this.direction = 0;
        this.filePath = "";
        this.isplay = false;
    }

    protected AudioRecordData(Parcel parcel) {
        this.id = 0L;
        this.name = "";
        this.channelName = "";
        this.timestamp = 0L;
        this.direction = 0;
        this.filePath = "";
        this.isplay = false;
        this.id = parcel.readLong();
        this.name = parcel.readString();
        this.channelName = parcel.readString();
        this.timestamp = parcel.readInt();
        this.direction = parcel.readInt();
        this.filePath = parcel.readString();
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeLong(this.id);
        parcel.writeString(this.name);
        parcel.writeString(this.channelName);
        parcel.writeLong(this.timestamp);
        parcel.writeInt(this.direction);
        parcel.writeString(this.filePath);
    }

    public long getId() {
        return this.id;
    }

    public void setId(long j) {
        this.id = j;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String str) {
        this.name = str;
    }

    public String getChannelName() {
        return this.channelName;
    }

    public void setChannelName(String str) {
        this.channelName = str;
    }

    public long getTimestamp() {
        return this.timestamp;
    }

    public void setTimestamp(long j) {
        this.timestamp = j;
    }

    public int getDirection() {
        return this.direction;
    }

    public void setDirection(int i) {
        this.direction = i;
    }

    public String getFilePath() {
        return this.filePath;
    }

    public void setFilePath(String str) {
        this.filePath = str;
    }

    public boolean isIsplay() {
        return this.isplay;
    }

    public void setIsplay(boolean z) {
        this.isplay = z;
    }

    public String toString() {
        return "AudioRecordData{id=" + this.id + ", name='" + this.name + "', channelName='" + this.channelName + "', timestamp=" + this.timestamp + ", direction=" + this.direction + ", filePath='" + this.filePath + "'}";
    }
}
