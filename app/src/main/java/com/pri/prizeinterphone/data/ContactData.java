package com.pri.prizeinterphone.data;

import android.graphics.Bitmap;
import android.os.Parcel;
import android.os.Parcelable;
/* loaded from: classes4.dex */
public class ContactData implements Parcelable {
    public static final Parcelable.Creator<ContactData> CREATOR = new Parcelable.Creator<ContactData>() { // from class: com.pri.prizeinterphone.data.ContactData.1
        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public ContactData createFromParcel(Parcel parcel) {
            return new ContactData(parcel);
        }

        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public ContactData[] newArray(int i) {
            return new ContactData[i];
        }
    };
    public Bitmap bitmap;
    public String id;
    public String name;

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public ContactData(String str, String str2, Bitmap bitmap) {
        this.id = str;
        this.name = str2;
        this.bitmap = bitmap;
    }

    protected ContactData(Parcel parcel) {
        this.id = parcel.readString();
        this.name = parcel.readString();
        this.bitmap = (Bitmap) parcel.readParcelable(Bitmap.class.getClassLoader());
    }

    public void setId(String str) {
        this.id = str;
    }

    public String getId() {
        return this.id;
    }

    public void setName(String str) {
        this.name = str;
    }

    public String getName() {
        return this.name;
    }

    public void setBitmap(Bitmap bitmap) {
        this.bitmap = bitmap;
    }

    public Bitmap getBitmap() {
        return this.bitmap;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(this.id);
        parcel.writeString(this.name);
        parcel.writeParcelable(this.bitmap, i);
    }
}
