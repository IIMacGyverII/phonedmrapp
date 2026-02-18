package com.pri.prizeinterphone.config.data;

import android.os.Parcel;
import android.os.Parcelable;
import android.util.SparseArray;
/* loaded from: classes4.dex */
public class InsertConfig implements Parcelable {
    public static final Parcelable.Creator<InsertConfig> CREATOR = new Parcelable.Creator<InsertConfig>() { // from class: com.pri.prizeinterphone.config.data.InsertConfig.1
        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public InsertConfig createFromParcel(Parcel parcel) {
            return new InsertConfig(parcel);
        }

        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public InsertConfig[] newArray(int i) {
            return new InsertConfig[i];
        }
    };
    private SparseArray<InsertChannels> insertChannels;
    private int localNumber;

    @Override // android.os.Parcelable
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

    @Override // android.os.Parcelable
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
