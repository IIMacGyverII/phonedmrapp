package com.android.internal.telephony.cat;

import android.os.Parcel;
import android.os.Parcelable;

public class ToneSettings implements Parcelable {
    public static final Parcelable.Creator<ToneSettings> CREATOR = new Parcelable.Creator<ToneSettings>() {
        public ToneSettings createFromParcel(Parcel parcel) {
            return new ToneSettings(parcel);
        }

        public ToneSettings[] newArray(int i) {
            return new ToneSettings[i];
        }
    };
    public Duration duration;
    public Tone tone;
    public boolean vibrate;

    public int describeContents() {
        return 0;
    }

    public ToneSettings(Duration duration2, Tone tone2, boolean z) {
        this.duration = duration2;
        this.tone = tone2;
        this.vibrate = z;
    }

    private ToneSettings(Parcel parcel) {
        this.duration = (Duration) parcel.readParcelable(Duration.class.getClassLoader());
        this.tone = (Tone) parcel.readParcelable(Tone.class.getClassLoader());
        this.vibrate = parcel.readInt() != 1 ? false : true;
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeParcelable(this.duration, 0);
        parcel.writeParcelable(this.tone, 0);
        parcel.writeInt(this.vibrate ? 1 : 0);
    }
}
