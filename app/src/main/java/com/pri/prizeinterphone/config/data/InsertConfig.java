package com.pri.prizeinterphone.config.data;

import android.os.Parcel;
import android.os.Parcelable;
import android.util.SparseArray;

public class InsertConfig implements Parcelable {
    public static final Parcelable.Creator<InsertConfig> CREATOR = new Parcelable.Creator<InsertConfig>() {
        public InsertConfig createFromParcel(Parcel parcel) {
            return new InsertConfig(parcel);
        }

        public InsertConfig[] newArray(int i) {
            return new InsertConfig[i];
        }
    };
    private SparseArray<InsertChannels> insertChannels;
    private int localNumber;

    public int describeContents() {
        return 0;
    }

    public String toString() {
        return "InsertConfig{localNumber=" + this.localNumber + ", insertChannels=" + this.insertChannels + '}';
    }

    public int getLocalNumber() {
        return this.localNumber;
    }

    public void setLocalNumber(int i) {
        this.localNumber = i;
    }

    public SparseArray<InsertChannels> getInsertChannels() {
        return this.insertChannels;
    }

    public void setInsertChannels(SparseArray<InsertChannels> sparseArray) {
        this.insertChannels = sparseArray;
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this.localNumber);
        parcel.writeSparseArray(this.insertChannels);
    }

    public void readFromParcel(Parcel parcel) {
        this.localNumber = parcel.readInt();
        this.insertChannels = parcel.readSparseArray(InsertChannels.class.getClassLoader());
    }

    public InsertConfig() {
        this.insertChannels = new SparseArray<>();
    }

    protected InsertConfig(Parcel parcel) {
        this.localNumber = parcel.readInt();
        this.insertChannels = parcel.readSparseArray(InsertChannels.class.getClassLoader());
    }
}
