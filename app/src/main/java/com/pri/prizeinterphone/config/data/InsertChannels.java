package com.pri.prizeinterphone.config.data;

import android.os.Parcel;
import android.os.Parcelable;
import java.util.ArrayList;

public class InsertChannels implements Parcelable {
    public static final Parcelable.Creator<InsertChannels> CREATOR = new Parcelable.Creator<InsertChannels>() {
        public InsertChannels createFromParcel(Parcel parcel) {
            return new InsertChannels(parcel);
        }

        public InsertChannels[] newArray(int i) {
            return new InsertChannels[i];
        }
    };
    private ArrayList<InsertChannel> channels;

    public int describeContents() {
        return 0;
    }

    public String toString() {
        return "InsertChannels{channels=" + this.channels + '}';
    }

    public ArrayList<InsertChannel> getChannels() {
        return this.channels;
    }

    public void setChannels(ArrayList<InsertChannel> arrayList) {
        this.channels = arrayList;
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeTypedList(this.channels);
    }

    public void readFromParcel(Parcel parcel) {
        this.channels = parcel.createTypedArrayList(InsertChannel.CREATOR);
    }

    public InsertChannels() {
        this.channels = new ArrayList<>();
    }

    protected InsertChannels(Parcel parcel) {
        this.channels = parcel.createTypedArrayList(InsertChannel.CREATOR);
    }
}
