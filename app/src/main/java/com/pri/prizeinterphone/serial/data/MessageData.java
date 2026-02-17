package com.pri.prizeinterphone.serial.data;

import android.os.Parcel;
import android.os.Parcelable;

public class MessageData implements Parcelable {
    public static final Parcelable.Creator<MessageData> CREATOR = new Parcelable.Creator<MessageData>() {
        public MessageData createFromParcel(Parcel parcel) {
            return new MessageData(parcel);
        }

        public MessageData[] newArray(int i) {
            return new MessageData[i];
        }
    };
    public String content;
    public int convType;
    public int conv_target;
    public int direction;
    public int from;
    public long id;
    public int status;
    public long timestamp;
    public int to;

    public interface SmsDirection {
        public static final int RECEIVE = 1;
        public static final int SENT = 0;
    }

    public interface SmsStatus {
        public static final int MESSAGE_STATUS_FAIL = 3;
        public static final int MESSAGE_STATUS_READ = 1;
        public static final int MESSAGE_STATUS_SUCCESS = 2;
        public static final int MESSAGE_STATUS_UNREAD = 0;
    }

    public int describeContents() {
        return 0;
    }

    public MessageData(long j, int i, int i2, int i3, int i4, String str, int i5, long j2, int i6) {
        this.id = j;
        this.convType = i;
        this.conv_target = i2;
        this.from = i3;
        this.to = i4;
        this.content = str;
        this.status = i5;
        this.timestamp = j2;
        this.direction = i6;
    }

    public MessageData() {
        this.id = 0;
        this.convType = 0;
        this.conv_target = 1;
        this.from = 1;
        this.to = 1;
        this.status = 0;
        this.timestamp = 0;
        this.direction = 0;
    }

    protected MessageData(Parcel parcel) {
        this.id = 0;
        this.convType = 0;
        this.conv_target = 1;
        this.from = 1;
        this.to = 1;
        this.status = 0;
        this.timestamp = 0;
        this.direction = 0;
        this.id = parcel.readLong();
        this.convType = parcel.readInt();
        this.conv_target = parcel.readInt();
        this.from = parcel.readInt();
        this.to = parcel.readInt();
        this.content = parcel.readString();
        this.status = parcel.readInt();
        this.timestamp = parcel.readLong();
        this.direction = parcel.readInt();
    }

    public int getConvType() {
        return this.convType;
    }

    public void setConvType(int i) {
        this.convType = i;
    }

    public int getConv_target() {
        return this.conv_target;
    }

    public void setConv_target(int i) {
        this.conv_target = i;
    }

    public int getFrom() {
        return this.from;
    }

    public void setFrom(int i) {
        this.from = i;
    }

    public int getTo() {
        return this.to;
    }

    public void setTo(int i) {
        this.to = i;
    }

    public String getContent() {
        return this.content;
    }

    public void setContent(String str) {
        this.content = str;
    }

    public int getStatus() {
        return this.status;
    }

    public void setStatus(int i) {
        this.status = i;
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

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeLong(this.id);
        parcel.writeInt(this.convType);
        parcel.writeInt(this.conv_target);
        parcel.writeInt(this.from);
        parcel.writeInt(this.to);
        parcel.writeString(this.content);
        parcel.writeInt(this.status);
        parcel.writeLong(this.timestamp);
        parcel.writeInt(this.direction);
    }

    public String toString() {
        return "MessageData{id=" + this.id + ", convType=" + this.convType + ", conv_target=" + this.conv_target + ", from=" + this.from + ", to=" + this.to + ", content='" + this.content + '\'' + ", status=" + this.status + ", timestamp=" + this.timestamp + ", direction=" + this.direction + '}';
    }
}
