package com.android.internal.telephony.data;

import android.os.Parcel;
import android.os.Parcelable;

public class KeepaliveStatus implements Parcelable {
    public static final Parcelable.Creator<KeepaliveStatus> CREATOR = new Parcelable.Creator<KeepaliveStatus>() {
        public KeepaliveStatus createFromParcel(Parcel parcel) {
            return new KeepaliveStatus(parcel);
        }

        public KeepaliveStatus[] newArray(int i) {
            return new KeepaliveStatus[i];
        }
    };
    public static final int ERROR_NONE = 0;
    public static final int ERROR_NO_RESOURCES = 2;
    public static final int ERROR_UNKNOWN = 3;
    public static final int ERROR_UNSUPPORTED = 1;
    public static final int INVALID_HANDLE = Integer.MAX_VALUE;
    public static final int STATUS_ACTIVE = 0;
    public static final int STATUS_INACTIVE = 1;
    public static final int STATUS_PENDING = 2;
    public final int errorCode;
    public final int sessionHandle;
    @KeepaliveStatusCode
    public final int statusCode;

    public @interface KeepaliveStatusCode {
    }

    public int describeContents() {
        return 0;
    }

    public KeepaliveStatus(int i) {
        this.sessionHandle = Integer.MAX_VALUE;
        this.statusCode = 1;
        this.errorCode = i;
    }

    public KeepaliveStatus(int i, @KeepaliveStatusCode int i2) {
        this.sessionHandle = i;
        this.statusCode = i2;
        this.errorCode = 0;
    }

    public String toString() {
        return String.format("{errorCode=%d, sessionHandle=%d, statusCode=%d}", new Object[]{Integer.valueOf(this.errorCode), Integer.valueOf(this.sessionHandle), Integer.valueOf(this.statusCode)});
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this.errorCode);
        parcel.writeInt(this.sessionHandle);
        parcel.writeInt(this.statusCode);
    }

    private KeepaliveStatus(Parcel parcel) {
        this.errorCode = parcel.readInt();
        this.sessionHandle = parcel.readInt();
        this.statusCode = parcel.readInt();
    }
}
