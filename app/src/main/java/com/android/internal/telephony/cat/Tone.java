package com.android.internal.telephony.cat;

import android.os.Parcel;
import android.os.Parcelable;

public enum Tone implements Parcelable {
    DIAL((String) 1),
    BUSY((String) 2),
    CONGESTION((String) 3),
    RADIO_PATH_ACK((String) 4),
    RADIO_PATH_NOT_AVAILABLE((String) 5),
    ERROR_SPECIAL_INFO((String) 6),
    CALL_WAITING((String) 7),
    RINGING((String) 8),
    GENERAL_BEEP((String) 16),
    POSITIVE_ACK((String) 17),
    NEGATIVE_ACK((String) 18),
    INCOMING_SPEECH_CALL((String) 19),
    INCOMING_SMS((String) 20),
    CRITICAL_ALERT((String) 21),
    VIBRATE_ONLY((String) 32),
    HAPPY((String) 48),
    SAD((String) 49),
    URGENT((String) 50),
    QUESTION((String) 51),
    MESSAGE_RECEIVED((String) 52),
    MELODY_1((String) 64),
    MELODY_2((String) 65),
    MELODY_3((String) 66),
    MELODY_4((String) 67),
    MELODY_5((String) 68),
    MELODY_6((String) 69),
    MELODY_7((String) 70),
    MELODY_8((String) 71);
    
    public static final Parcelable.Creator<Tone> CREATOR = null;
    private int mValue;

    public int describeContents() {
        return 0;
    }

    static {
        CREATOR = new Parcelable.Creator<Tone>() {
            public Tone createFromParcel(Parcel parcel) {
                return Tone.values()[parcel.readInt()];
            }

            public Tone[] newArray(int i) {
                return new Tone[i];
            }
        };
    }

    private Tone(int i) {
        this.mValue = i;
    }

    public static Tone fromInt(int i) {
        for (Tone tone : values()) {
            if (tone.mValue == i) {
                return tone;
            }
        }
        return null;
    }

    private Tone(Parcel parcel) {
        this.mValue = parcel.readInt();
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(ordinal());
    }
}
