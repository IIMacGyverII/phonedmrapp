package com.android.internal.telephony.cdnr;

import android.os.Parcel;
import android.os.Parcelable;
import java.util.Objects;

public class CarrierDisplayNameData implements Parcelable {
    public static final Parcelable.Creator<CarrierDisplayNameData> CREATOR = new Parcelable.Creator<CarrierDisplayNameData>() {
        public CarrierDisplayNameData createFromParcel(Parcel parcel) {
            return new CarrierDisplayNameData(parcel);
        }

        public CarrierDisplayNameData[] newArray(int i) {
            return new CarrierDisplayNameData[i];
        }
    };
    private final String mDataSpn;
    private final String mPlmn;
    private final boolean mShowPlmn;
    private final boolean mShowSpn;
    private final String mSpn;

    public int describeContents() {
        return 0;
    }

    private CarrierDisplayNameData(String str, String str2, boolean z, String str3, boolean z2) {
        this.mSpn = str;
        this.mDataSpn = str2;
        this.mShowSpn = z;
        this.mPlmn = str3;
        this.mShowPlmn = z2;
    }

    public String getSpn() {
        return this.mSpn;
    }

    public String getDataSpn() {
        return this.mDataSpn;
    }

    public String getPlmn() {
        return this.mPlmn;
    }

    public boolean shouldShowSpn() {
        return this.mShowSpn;
    }

    public boolean shouldShowPlmn() {
        return this.mShowPlmn;
    }

    public String toString() {
        return String.format("{ spn = %s, dataSpn = %s, showSpn = %b, plmn = %s, showPlmn = %b", new Object[]{this.mSpn, this.mDataSpn, Boolean.valueOf(this.mShowSpn), this.mPlmn, Boolean.valueOf(this.mShowPlmn)});
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(this.mSpn);
        parcel.writeString(this.mDataSpn);
        parcel.writeString(this.mPlmn);
        parcel.writeBoolean(this.mShowSpn);
        parcel.writeBoolean(this.mShowPlmn);
    }

    private CarrierDisplayNameData(Parcel parcel) {
        this.mSpn = parcel.readString();
        this.mDataSpn = parcel.readString();
        this.mPlmn = parcel.readString();
        this.mShowSpn = parcel.readBoolean();
        this.mShowPlmn = parcel.readBoolean();
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        CarrierDisplayNameData carrierDisplayNameData = (CarrierDisplayNameData) obj;
        if (this.mShowSpn != carrierDisplayNameData.mShowSpn || this.mShowPlmn != carrierDisplayNameData.mShowPlmn || !Objects.equals(this.mSpn, carrierDisplayNameData.mSpn) || !Objects.equals(this.mDataSpn, carrierDisplayNameData.mDataSpn) || !Objects.equals(this.mPlmn, carrierDisplayNameData.mPlmn)) {
            return false;
        }
        return true;
    }

    public int hashCode() {
        return Objects.hash(new Object[]{this.mSpn, this.mDataSpn, this.mPlmn, Boolean.valueOf(this.mShowSpn), Boolean.valueOf(this.mShowPlmn)});
    }

    public static final class Builder {
        private String mDataSpn = null;
        private String mPlmn = null;
        private boolean mShowPlmn = false;
        private boolean mShowSpn = false;
        private String mSpn = null;

        public CarrierDisplayNameData build() {
            return new CarrierDisplayNameData(this.mSpn, this.mDataSpn, this.mShowSpn, this.mPlmn, this.mShowPlmn);
        }

        public Builder setSpn(String str) {
            this.mSpn = str;
            return this;
        }

        public Builder setDataSpn(String str) {
            this.mDataSpn = str;
            return this;
        }

        public Builder setPlmn(String str) {
            this.mPlmn = str;
            return this;
        }

        public Builder setShowSpn(boolean z) {
            this.mShowSpn = z;
            return this;
        }

        public Builder setShowPlmn(boolean z) {
            this.mShowPlmn = z;
            return this;
        }
    }
}
