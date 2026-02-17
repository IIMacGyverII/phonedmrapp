package com.pri.prizeinterphone.serial.data;

import android.graphics.Bitmap;
import android.os.Parcel;
import android.os.Parcelable;

public class ContactData implements Parcelable {
    public static final Parcelable.Creator<ContactData> CREATOR = new Parcelable.Creator<ContactData>() {
        public ContactData createFromParcel(Parcel parcel) {
            return new ContactData(parcel);
        }

        public ContactData[] newArray(int i) {
            return new ContactData[i];
        }
    };
    public int _id;
    public int active;
    public Bitmap bitmap;
    public String name;
    public String number;
    public int type;

    public interface ContactType {
        public static final int GROUP = 1;
        public static final int PERSON = 0;
    }

    public int describeContents() {
        return 0;
    }

    public ContactData() {
        this.type = 0;
        this.active = 0;
    }

    public ContactData(int i, int i2, String str, String str2, int i3, Bitmap bitmap2) {
        this._id = i;
        this.name = str;
        this.bitmap = bitmap2;
        this.number = str2;
        this.type = i2;
        this.active = i3;
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

    public Bitmap getBitmap() {
        return this.bitmap;
    }

    public void setBitmap(Bitmap bitmap2) {
        this.bitmap = bitmap2;
    }

    public String getNumber() {
        return this.number;
    }

    public void setNumber(String str) {
        this.number = str;
    }

    public int getType() {
        return this.type;
    }

    public void setType(int i) {
        this.type = i;
    }

    public int getActive() {
        return this.active;
    }

    public void setActive(int i) {
        this.active = i;
    }

    protected ContactData(Parcel parcel) {
        this.type = 0;
        this.active = 0;
        this._id = parcel.readInt();
        this.type = parcel.readInt();
        this.name = parcel.readString();
        this.number = parcel.readString();
        this.active = parcel.readInt();
        this.bitmap = (Bitmap) parcel.readParcelable(Bitmap.class.getClassLoader());
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this._id);
        parcel.writeInt(this.type);
        parcel.writeString(this.name);
        parcel.writeString(this.number);
        parcel.writeInt(this.active);
        parcel.writeParcelable(this.bitmap, i);
    }

    public String toString() {
        return "ContactData{id='" + this._id + '\'' + ", type=" + this.type + ", name='" + this.name + '\'' + ", number='" + this.number + '\'' + ", active=" + this.active + ", bitmap=" + this.bitmap + '}';
    }
}
