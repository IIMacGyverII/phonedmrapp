package androidx.versionedparcelable;

import android.annotation.SuppressLint;
import android.os.Parcel;
import android.os.Parcelable;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;

@SuppressLint({"BanParcelableUsage"})
@RestrictTo({RestrictTo.Scope.LIBRARY})
public class ParcelImpl implements Parcelable {
    public static final Parcelable.Creator<ParcelImpl> CREATOR = new Parcelable.Creator<ParcelImpl>() {
        @NonNull
        public ParcelImpl createFromParcel(@NonNull Parcel parcel) {
            return new ParcelImpl(parcel);
        }

        @NonNull
        public ParcelImpl[] newArray(int i) {
            return new ParcelImpl[i];
        }
    };
    @Nullable
    private final VersionedParcelable mParcel;

    public int describeContents() {
        return 0;
    }

    public ParcelImpl(@Nullable VersionedParcelable versionedParcelable) {
        this.mParcel = versionedParcelable;
    }

    protected ParcelImpl(@NonNull Parcel parcel) {
        this.mParcel = new VersionedParcelParcel(parcel).readVersionedParcelable();
    }

    @Nullable
    public <T extends VersionedParcelable> T getVersionedParcel() {
        return this.mParcel;
    }

    public void writeToParcel(@NonNull Parcel parcel, int i) {
        new VersionedParcelParcel(parcel).writeVersionedParcelable(this.mParcel);
    }
}
