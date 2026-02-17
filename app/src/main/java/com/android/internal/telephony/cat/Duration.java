package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.Parcel;
import android.os.Parcelable;

public class Duration implements Parcelable {
    public static final Parcelable.Creator<Duration> CREATOR = new Parcelable.Creator<Duration>() {
        public Duration createFromParcel(Parcel parcel) {
            return new Duration(parcel);
        }

        public Duration[] newArray(int i) {
            return new Duration[i];
        }
    };
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int timeInterval;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public TimeUnit timeUnit;

    public int describeContents() {
        return 0;
    }

    public enum TimeUnit {
        MINUTE(0),
        SECOND(1),
        TENTH_SECOND(2);
        
        private int mValue;

        private TimeUnit(int i) {
            this.mValue = i;
        }

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public int value() {
            return this.mValue;
        }
    }

    public Duration(int i, TimeUnit timeUnit2) {
        this.timeInterval = i;
        this.timeUnit = timeUnit2;
    }

    private Duration(Parcel parcel) {
        this.timeInterval = parcel.readInt();
        this.timeUnit = TimeUnit.values()[parcel.readInt()];
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this.timeInterval);
        parcel.writeInt(this.timeUnit.ordinal());
    }
}
