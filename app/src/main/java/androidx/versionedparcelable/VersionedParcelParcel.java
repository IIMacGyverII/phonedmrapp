package androidx.versionedparcelable;

import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.SparseIntArray;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import androidx.collection.SimpleArrayMap;
import java.lang.reflect.Method;

@RestrictTo({RestrictTo.Scope.LIBRARY})
class VersionedParcelParcel extends VersionedParcel {
    private static final boolean DEBUG = false;
    @NonNull
    private static final String TAG = "VersionedParcelParcel";
    private int mCurrentField;
    private final int mEnd;
    private int mFieldId;
    private int mNextRead;
    private final int mOffset;
    @NonNull
    private final Parcel mParcel;
    @NonNull
    private final SparseIntArray mPositionLookup;
    @NonNull
    private final String mPrefix;

    VersionedParcelParcel(@NonNull Parcel parcel) {
        this(parcel, parcel.dataPosition(), parcel.dataSize(), "", new SimpleArrayMap(), new SimpleArrayMap(), new SimpleArrayMap());
    }

    private VersionedParcelParcel(@NonNull Parcel parcel, int i, int i2, @NonNull String str, @NonNull SimpleArrayMap<String, Method> simpleArrayMap, @NonNull SimpleArrayMap<String, Method> simpleArrayMap2, @NonNull SimpleArrayMap<String, Class<?>> simpleArrayMap3) {
        super(simpleArrayMap, simpleArrayMap2, simpleArrayMap3);
        this.mPositionLookup = new SparseIntArray();
        this.mCurrentField = -1;
        this.mFieldId = -1;
        this.mParcel = parcel;
        this.mOffset = i;
        this.mEnd = i2;
        this.mNextRead = i;
        this.mPrefix = str;
    }

    public boolean readField(int i) {
        while (this.mNextRead < this.mEnd) {
            int i2 = this.mFieldId;
            if (i2 == i) {
                return true;
            }
            if (String.valueOf(i2).compareTo(String.valueOf(i)) > 0) {
                return false;
            }
            this.mParcel.setDataPosition(this.mNextRead);
            int readInt = this.mParcel.readInt();
            this.mFieldId = this.mParcel.readInt();
            this.mNextRead += readInt;
        }
        if (this.mFieldId == i) {
            return true;
        }
        return false;
    }

    public void setOutputField(int i) {
        closeField();
        this.mCurrentField = i;
        this.mPositionLookup.put(i, this.mParcel.dataPosition());
        writeInt(0);
        writeInt(i);
    }

    public void closeField() {
        int i = this.mCurrentField;
        if (i >= 0) {
            int i2 = this.mPositionLookup.get(i);
            int dataPosition = this.mParcel.dataPosition();
            this.mParcel.setDataPosition(i2);
            this.mParcel.writeInt(dataPosition - i2);
            this.mParcel.setDataPosition(dataPosition);
        }
    }

    /* access modifiers changed from: protected */
    @NonNull
    public VersionedParcel createSubParcel() {
        Parcel parcel = this.mParcel;
        int dataPosition = parcel.dataPosition();
        int i = this.mNextRead;
        if (i == this.mOffset) {
            i = this.mEnd;
        }
        int i2 = i;
        return new VersionedParcelParcel(parcel, dataPosition, i2, this.mPrefix + "  ", this.mReadCache, this.mWriteCache, this.mParcelizerCache);
    }

    public void writeByteArray(byte[] bArr) {
        if (bArr != null) {
            this.mParcel.writeInt(bArr.length);
            this.mParcel.writeByteArray(bArr);
            return;
        }
        this.mParcel.writeInt(-1);
    }

    public void writeByteArray(byte[] bArr, int i, int i2) {
        if (bArr != null) {
            this.mParcel.writeInt(bArr.length);
            this.mParcel.writeByteArray(bArr, i, i2);
            return;
        }
        this.mParcel.writeInt(-1);
    }

    public void writeInt(int i) {
        this.mParcel.writeInt(i);
    }

    public void writeLong(long j) {
        this.mParcel.writeLong(j);
    }

    public void writeFloat(float f) {
        this.mParcel.writeFloat(f);
    }

    public void writeDouble(double d) {
        this.mParcel.writeDouble(d);
    }

    public void writeString(String str) {
        this.mParcel.writeString(str);
    }

    public void writeStrongBinder(IBinder iBinder) {
        this.mParcel.writeStrongBinder(iBinder);
    }

    public void writeParcelable(Parcelable parcelable) {
        this.mParcel.writeParcelable(parcelable, 0);
    }

    public void writeBoolean(boolean z) {
        this.mParcel.writeInt(z ? 1 : 0);
    }

    public void writeStrongInterface(IInterface iInterface) {
        this.mParcel.writeStrongInterface(iInterface);
    }

    public void writeBundle(Bundle bundle) {
        this.mParcel.writeBundle(bundle);
    }

    /* access modifiers changed from: protected */
    public void writeCharSequence(CharSequence charSequence) {
        TextUtils.writeToParcel(charSequence, this.mParcel, 0);
    }

    /* access modifiers changed from: protected */
    @Nullable
    public CharSequence readCharSequence() {
        return (CharSequence) TextUtils.CHAR_SEQUENCE_CREATOR.createFromParcel(this.mParcel);
    }

    public int readInt() {
        return this.mParcel.readInt();
    }

    public long readLong() {
        return this.mParcel.readLong();
    }

    public float readFloat() {
        return this.mParcel.readFloat();
    }

    public double readDouble() {
        return this.mParcel.readDouble();
    }

    @Nullable
    public String readString() {
        return this.mParcel.readString();
    }

    @Nullable
    public IBinder readStrongBinder() {
        return this.mParcel.readStrongBinder();
    }

    @Nullable
    public byte[] readByteArray() {
        int readInt = this.mParcel.readInt();
        if (readInt < 0) {
            return null;
        }
        byte[] bArr = new byte[readInt];
        this.mParcel.readByteArray(bArr);
        return bArr;
    }

    @Nullable
    public <T extends Parcelable> T readParcelable() {
        return this.mParcel.readParcelable(getClass().getClassLoader());
    }

    @Nullable
    public Bundle readBundle() {
        return this.mParcel.readBundle(getClass().getClassLoader());
    }

    public boolean readBoolean() {
        return this.mParcel.readInt() != 0;
    }
}
