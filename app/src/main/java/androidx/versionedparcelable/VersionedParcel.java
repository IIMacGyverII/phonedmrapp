package androidx.versionedparcelable;

import android.os.BadParcelableException;
import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.NetworkOnMainThreadException;
import android.os.Parcelable;
import android.util.Size;
import android.util.SizeF;
import android.util.SparseBooleanArray;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.collection.ArrayMap;
import androidx.collection.ArraySet;
import androidx.collection.SimpleArrayMap;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.ObjectStreamClass;
import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
public abstract class VersionedParcel {
    private static final int EX_BAD_PARCELABLE = -2;
    private static final int EX_ILLEGAL_ARGUMENT = -3;
    private static final int EX_ILLEGAL_STATE = -5;
    private static final int EX_NETWORK_MAIN_THREAD = -6;
    private static final int EX_NULL_POINTER = -4;
    private static final int EX_PARCELABLE = -9;
    private static final int EX_SECURITY = -1;
    private static final int EX_UNSUPPORTED_OPERATION = -7;
    @NonNull
    private static final String TAG = "VersionedParcel";
    private static final int TYPE_BINDER = 5;
    private static final int TYPE_FLOAT = 8;
    private static final int TYPE_INTEGER = 7;
    private static final int TYPE_PARCELABLE = 2;
    private static final int TYPE_SERIALIZABLE = 3;
    private static final int TYPE_STRING = 4;
    private static final int TYPE_VERSIONED_PARCELABLE = 1;
    @NonNull
    final SimpleArrayMap<String, Class<?>> mParcelizerCache;
    @NonNull
    final SimpleArrayMap<String, Method> mReadCache;
    @NonNull
    final SimpleArrayMap<String, Method> mWriteCache;

    /* access modifiers changed from: protected */
    public abstract void closeField();

    /* access modifiers changed from: protected */
    @NonNull
    public abstract VersionedParcel createSubParcel();

    public boolean isStream() {
        return false;
    }

    /* access modifiers changed from: protected */
    public abstract boolean readBoolean();

    /* access modifiers changed from: protected */
    @Nullable
    public abstract Bundle readBundle();

    /* access modifiers changed from: protected */
    @Nullable
    public abstract byte[] readByteArray();

    /* access modifiers changed from: protected */
    @Nullable
    public abstract CharSequence readCharSequence();

    /* access modifiers changed from: protected */
    public abstract double readDouble();

    /* access modifiers changed from: protected */
    public abstract boolean readField(int i);

    /* access modifiers changed from: protected */
    public abstract float readFloat();

    /* access modifiers changed from: protected */
    public abstract int readInt();

    /* access modifiers changed from: protected */
    public abstract long readLong();

    /* access modifiers changed from: protected */
    @Nullable
    public abstract <T extends Parcelable> T readParcelable();

    /* access modifiers changed from: protected */
    @Nullable
    public abstract String readString();

    /* access modifiers changed from: protected */
    @Nullable
    public abstract IBinder readStrongBinder();

    /* access modifiers changed from: protected */
    public abstract void setOutputField(int i);

    public void setSerializationFlags(boolean z, boolean z2) {
    }

    /* access modifiers changed from: protected */
    public abstract void writeBoolean(boolean z);

    /* access modifiers changed from: protected */
    public abstract void writeBundle(@Nullable Bundle bundle);

    /* access modifiers changed from: protected */
    public abstract void writeByteArray(@Nullable byte[] bArr);

    /* access modifiers changed from: protected */
    public abstract void writeByteArray(@Nullable byte[] bArr, int i, int i2);

    /* access modifiers changed from: protected */
    public abstract void writeCharSequence(@Nullable CharSequence charSequence);

    /* access modifiers changed from: protected */
    public abstract void writeDouble(double d);

    /* access modifiers changed from: protected */
    public abstract void writeFloat(float f);

    /* access modifiers changed from: protected */
    public abstract void writeInt(int i);

    /* access modifiers changed from: protected */
    public abstract void writeLong(long j);

    /* access modifiers changed from: protected */
    public abstract void writeParcelable(@Nullable Parcelable parcelable);

    /* access modifiers changed from: protected */
    public abstract void writeString(@Nullable String str);

    /* access modifiers changed from: protected */
    public abstract void writeStrongBinder(@Nullable IBinder iBinder);

    /* access modifiers changed from: protected */
    public abstract void writeStrongInterface(@Nullable IInterface iInterface);

    VersionedParcel(@NonNull SimpleArrayMap<String, Method> simpleArrayMap, @NonNull SimpleArrayMap<String, Method> simpleArrayMap2, @NonNull SimpleArrayMap<String, Class<?>> simpleArrayMap3) {
        this.mReadCache = simpleArrayMap;
        this.mWriteCache = simpleArrayMap2;
        this.mParcelizerCache = simpleArrayMap3;
    }

    public void writeStrongInterface(@Nullable IInterface iInterface, int i) {
        setOutputField(i);
        writeStrongInterface(iInterface);
    }

    public void writeBundle(@Nullable Bundle bundle, int i) {
        setOutputField(i);
        writeBundle(bundle);
    }

    public void writeBoolean(boolean z, int i) {
        setOutputField(i);
        writeBoolean(z);
    }

    public void writeByteArray(@Nullable byte[] bArr, int i) {
        setOutputField(i);
        writeByteArray(bArr);
    }

    public void writeByteArray(@Nullable byte[] bArr, int i, int i2, int i3) {
        setOutputField(i3);
        writeByteArray(bArr, i, i2);
    }

    public void writeCharSequence(@Nullable CharSequence charSequence, int i) {
        setOutputField(i);
        writeCharSequence(charSequence);
    }

    public void writeInt(int i, int i2) {
        setOutputField(i2);
        writeInt(i);
    }

    public void writeLong(long j, int i) {
        setOutputField(i);
        writeLong(j);
    }

    public void writeFloat(float f, int i) {
        setOutputField(i);
        writeFloat(f);
    }

    public void writeDouble(double d, int i) {
        setOutputField(i);
        writeDouble(d);
    }

    public void writeString(@Nullable String str, int i) {
        setOutputField(i);
        writeString(str);
    }

    public void writeStrongBinder(@Nullable IBinder iBinder, int i) {
        setOutputField(i);
        writeStrongBinder(iBinder);
    }

    public void writeParcelable(@Nullable Parcelable parcelable, int i) {
        setOutputField(i);
        writeParcelable(parcelable);
    }

    public boolean readBoolean(boolean z, int i) {
        if (!readField(i)) {
            return z;
        }
        return readBoolean();
    }

    public int readInt(int i, int i2) {
        if (!readField(i2)) {
            return i;
        }
        return readInt();
    }

    public long readLong(long j, int i) {
        if (!readField(i)) {
            return j;
        }
        return readLong();
    }

    public float readFloat(float f, int i) {
        if (!readField(i)) {
            return f;
        }
        return readFloat();
    }

    public double readDouble(double d, int i) {
        if (!readField(i)) {
            return d;
        }
        return readDouble();
    }

    @Nullable
    public String readString(@Nullable String str, int i) {
        if (!readField(i)) {
            return str;
        }
        return readString();
    }

    @Nullable
    public IBinder readStrongBinder(@Nullable IBinder iBinder, int i) {
        if (!readField(i)) {
            return iBinder;
        }
        return readStrongBinder();
    }

    @Nullable
    public byte[] readByteArray(@Nullable byte[] bArr, int i) {
        if (!readField(i)) {
            return bArr;
        }
        return readByteArray();
    }

    @Nullable
    public <T extends Parcelable> T readParcelable(@Nullable T t, int i) {
        if (!readField(i)) {
            return t;
        }
        return readParcelable();
    }

    @Nullable
    public Bundle readBundle(@Nullable Bundle bundle, int i) {
        if (!readField(i)) {
            return bundle;
        }
        return readBundle();
    }

    public void writeByte(byte b, int i) {
        setOutputField(i);
        writeInt(b);
    }

    @RequiresApi(21)
    public void writeSize(@Nullable Size size, int i) {
        setOutputField(i);
        Api21Impl.writeSize(this, size);
    }

    @RequiresApi(21)
    public void writeSizeF(@Nullable SizeF sizeF, int i) {
        setOutputField(i);
        Api21Impl.writeSizeF(this, sizeF);
    }

    public void writeSparseBooleanArray(@Nullable SparseBooleanArray sparseBooleanArray, int i) {
        setOutputField(i);
        if (sparseBooleanArray == null) {
            writeInt(-1);
            return;
        }
        int size = sparseBooleanArray.size();
        writeInt(size);
        for (int i2 = 0; i2 < size; i2++) {
            writeInt(sparseBooleanArray.keyAt(i2));
            writeBoolean(sparseBooleanArray.valueAt(i2));
        }
    }

    public void writeBooleanArray(@Nullable boolean[] zArr, int i) {
        setOutputField(i);
        writeBooleanArray(zArr);
    }

    /* access modifiers changed from: protected */
    public void writeBooleanArray(@Nullable boolean[] zArr) {
        if (zArr != null) {
            writeInt(r0);
            for (boolean z : zArr) {
                writeInt(z ? 1 : 0);
            }
            return;
        }
        writeInt(-1);
    }

    @Nullable
    public boolean[] readBooleanArray(@Nullable boolean[] zArr, int i) {
        if (!readField(i)) {
            return zArr;
        }
        return readBooleanArray();
    }

    /* access modifiers changed from: protected */
    @Nullable
    public boolean[] readBooleanArray() {
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        boolean[] zArr = new boolean[readInt];
        for (int i = 0; i < readInt; i++) {
            zArr[i] = readInt() != 0;
        }
        return zArr;
    }

    public void writeCharArray(@Nullable char[] cArr, int i) {
        setOutputField(i);
        if (cArr != null) {
            writeInt(r4);
            for (char writeInt : cArr) {
                writeInt(writeInt);
            }
            return;
        }
        writeInt(-1);
    }

    @Nullable
    public CharSequence readCharSequence(@Nullable CharSequence charSequence, int i) {
        if (!readField(i)) {
            return charSequence;
        }
        return readCharSequence();
    }

    @Nullable
    public char[] readCharArray(@Nullable char[] cArr, int i) {
        if (!readField(i)) {
            return cArr;
        }
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        char[] cArr2 = new char[readInt];
        for (int i2 = 0; i2 < readInt; i2++) {
            cArr2[i2] = (char) readInt();
        }
        return cArr2;
    }

    public void writeIntArray(@Nullable int[] iArr, int i) {
        setOutputField(i);
        writeIntArray(iArr);
    }

    /* access modifiers changed from: protected */
    public void writeIntArray(@Nullable int[] iArr) {
        if (iArr != null) {
            writeInt(r0);
            for (int writeInt : iArr) {
                writeInt(writeInt);
            }
            return;
        }
        writeInt(-1);
    }

    @Nullable
    public int[] readIntArray(@Nullable int[] iArr, int i) {
        if (!readField(i)) {
            return iArr;
        }
        return readIntArray();
    }

    /* access modifiers changed from: protected */
    @Nullable
    public int[] readIntArray() {
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        int[] iArr = new int[readInt];
        for (int i = 0; i < readInt; i++) {
            iArr[i] = readInt();
        }
        return iArr;
    }

    public void writeLongArray(@Nullable long[] jArr, int i) {
        setOutputField(i);
        writeLongArray(jArr);
    }

    /* access modifiers changed from: protected */
    public void writeLongArray(@Nullable long[] jArr) {
        if (jArr != null) {
            writeInt(r0);
            for (long writeLong : jArr) {
                writeLong(writeLong);
            }
            return;
        }
        writeInt(-1);
    }

    @Nullable
    public long[] readLongArray(@Nullable long[] jArr, int i) {
        if (!readField(i)) {
            return jArr;
        }
        return readLongArray();
    }

    /* access modifiers changed from: protected */
    @Nullable
    public long[] readLongArray() {
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        long[] jArr = new long[readInt];
        for (int i = 0; i < readInt; i++) {
            jArr[i] = readLong();
        }
        return jArr;
    }

    public void writeFloatArray(@Nullable float[] fArr, int i) {
        setOutputField(i);
        writeFloatArray(fArr);
    }

    /* access modifiers changed from: protected */
    public void writeFloatArray(@Nullable float[] fArr) {
        if (fArr != null) {
            writeInt(r0);
            for (float writeFloat : fArr) {
                writeFloat(writeFloat);
            }
            return;
        }
        writeInt(-1);
    }

    @Nullable
    public float[] readFloatArray(@Nullable float[] fArr, int i) {
        if (!readField(i)) {
            return fArr;
        }
        return readFloatArray();
    }

    /* access modifiers changed from: protected */
    @Nullable
    public float[] readFloatArray() {
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        float[] fArr = new float[readInt];
        for (int i = 0; i < readInt; i++) {
            fArr[i] = readFloat();
        }
        return fArr;
    }

    public void writeDoubleArray(@Nullable double[] dArr, int i) {
        setOutputField(i);
        writeDoubleArray(dArr);
    }

    /* access modifiers changed from: protected */
    public void writeDoubleArray(@Nullable double[] dArr) {
        if (dArr != null) {
            writeInt(r0);
            for (double writeDouble : dArr) {
                writeDouble(writeDouble);
            }
            return;
        }
        writeInt(-1);
    }

    @Nullable
    public double[] readDoubleArray(@Nullable double[] dArr, int i) {
        if (!readField(i)) {
            return dArr;
        }
        return readDoubleArray();
    }

    /* access modifiers changed from: protected */
    @Nullable
    public double[] readDoubleArray() {
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        double[] dArr = new double[readInt];
        for (int i = 0; i < readInt; i++) {
            dArr[i] = readDouble();
        }
        return dArr;
    }

    public <T> void writeSet(@Nullable Set<T> set, int i) {
        writeCollection(set, i);
    }

    public <T> void writeList(@Nullable List<T> list, int i) {
        writeCollection(list, i);
    }

    public <K, V> void writeMap(@Nullable Map<K, V> map, int i) {
        setOutputField(i);
        if (map == null) {
            writeInt(-1);
            return;
        }
        int size = map.size();
        writeInt(size);
        if (size != 0) {
            ArrayList arrayList = new ArrayList(size);
            ArrayList arrayList2 = new ArrayList(size);
            for (Map.Entry next : map.entrySet()) {
                arrayList.add(next.getKey());
                arrayList2.add(next.getValue());
            }
            writeCollection(arrayList);
            writeCollection(arrayList2);
        }
    }

    private <T> void writeCollection(@Nullable Collection<T> collection, int i) {
        setOutputField(i);
        writeCollection(collection);
    }

    private <T> void writeCollection(@Nullable Collection<T> collection) {
        if (collection == null) {
            writeInt(-1);
            return;
        }
        int size = collection.size();
        writeInt(size);
        if (size > 0) {
            int type = getType(collection.iterator().next());
            writeInt(type);
            switch (type) {
                case 1:
                    for (T writeVersionedParcelable : collection) {
                        writeVersionedParcelable(writeVersionedParcelable);
                    }
                    return;
                case 2:
                    for (T writeParcelable : collection) {
                        writeParcelable(writeParcelable);
                    }
                    return;
                case 3:
                    for (T writeSerializable : collection) {
                        writeSerializable(writeSerializable);
                    }
                    return;
                case 4:
                    for (T writeString : collection) {
                        writeString(writeString);
                    }
                    return;
                case 5:
                    for (T writeStrongBinder : collection) {
                        writeStrongBinder(writeStrongBinder);
                    }
                    return;
                case 7:
                    for (T intValue : collection) {
                        writeInt(intValue.intValue());
                    }
                    return;
                case 8:
                    for (T floatValue : collection) {
                        writeFloat(floatValue.floatValue());
                    }
                    return;
                default:
                    return;
            }
        }
    }

    public <T> void writeArray(@Nullable T[] tArr, int i) {
        setOutputField(i);
        writeArray(tArr);
    }

    /* access modifiers changed from: protected */
    public <T> void writeArray(@Nullable T[] tArr) {
        if (tArr == null) {
            writeInt(-1);
            return;
        }
        int length = tArr.length;
        writeInt(length);
        if (length > 0) {
            int i = 0;
            int type = getType(tArr[0]);
            writeInt(type);
            if (type == 1) {
                while (i < length) {
                    writeVersionedParcelable((VersionedParcelable) tArr[i]);
                    i++;
                }
            } else if (type == 2) {
                while (i < length) {
                    writeParcelable((Parcelable) tArr[i]);
                    i++;
                }
            } else if (type == 3) {
                while (i < length) {
                    writeSerializable((Serializable) tArr[i]);
                    i++;
                }
            } else if (type == 4) {
                while (i < length) {
                    writeString((String) tArr[i]);
                    i++;
                }
            } else if (type == 5) {
                while (i < length) {
                    writeStrongBinder((IBinder) tArr[i]);
                    i++;
                }
            }
        }
    }

    private <T> int getType(@NonNull T t) {
        if (t instanceof String) {
            return 4;
        }
        if (t instanceof Parcelable) {
            return 2;
        }
        if (t instanceof VersionedParcelable) {
            return 1;
        }
        if (t instanceof Serializable) {
            return 3;
        }
        if (t instanceof IBinder) {
            return 5;
        }
        if (t instanceof Integer) {
            return 7;
        }
        if (t instanceof Float) {
            return 8;
        }
        throw new IllegalArgumentException(t.getClass().getName() + " cannot be VersionedParcelled");
    }

    public void writeVersionedParcelable(@Nullable VersionedParcelable versionedParcelable, int i) {
        setOutputField(i);
        writeVersionedParcelable(versionedParcelable);
    }

    /* access modifiers changed from: protected */
    public void writeVersionedParcelable(@Nullable VersionedParcelable versionedParcelable) {
        if (versionedParcelable == null) {
            writeString((String) null);
            return;
        }
        writeVersionedParcelableCreator(versionedParcelable);
        VersionedParcel createSubParcel = createSubParcel();
        writeToParcel(versionedParcelable, createSubParcel);
        createSubParcel.closeField();
    }

    private void writeVersionedParcelableCreator(@NonNull VersionedParcelable versionedParcelable) {
        try {
            writeString(findParcelClass(versionedParcelable.getClass()).getName());
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(versionedParcelable.getClass().getSimpleName() + " does not have a Parcelizer", e);
        }
    }

    public void writeSerializable(@Nullable Serializable serializable, int i) {
        setOutputField(i);
        writeSerializable(serializable);
    }

    private void writeSerializable(@Nullable Serializable serializable) {
        if (serializable == null) {
            writeString((String) null);
            return;
        }
        String name = serializable.getClass().getName();
        writeString(name);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        try {
            ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
            objectOutputStream.writeObject(serializable);
            objectOutputStream.close();
            writeByteArray(byteArrayOutputStream.toByteArray());
        } catch (IOException e) {
            throw new RuntimeException("VersionedParcelable encountered IOException writing serializable object (name = " + name + ")", e);
        }
    }

    public void writeException(@Nullable Exception exc, int i) {
        setOutputField(i);
        if (exc == null) {
            writeNoException();
            return;
        }
        int i2 = 0;
        if ((exc instanceof Parcelable) && exc.getClass().getClassLoader() == Parcelable.class.getClassLoader()) {
            i2 = EX_PARCELABLE;
        } else if (exc instanceof SecurityException) {
            i2 = -1;
        } else if (exc instanceof BadParcelableException) {
            i2 = -2;
        } else if (exc instanceof IllegalArgumentException) {
            i2 = -3;
        } else if (exc instanceof NullPointerException) {
            i2 = -4;
        } else if (exc instanceof IllegalStateException) {
            i2 = -5;
        } else if (exc instanceof NetworkOnMainThreadException) {
            i2 = -6;
        } else if (exc instanceof UnsupportedOperationException) {
            i2 = EX_UNSUPPORTED_OPERATION;
        }
        writeInt(i2);
        if (i2 != 0) {
            writeString(exc.getMessage());
            if (i2 == EX_PARCELABLE) {
                writeParcelable((Parcelable) exc);
            }
        } else if (exc instanceof RuntimeException) {
            throw ((RuntimeException) exc);
        } else {
            throw new RuntimeException(exc);
        }
    }

    /* access modifiers changed from: protected */
    public void writeNoException() {
        writeInt(0);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:3:0x0007, code lost:
        r2 = readExceptionCode();
     */
    @androidx.annotation.Nullable
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.lang.Exception readException(@androidx.annotation.Nullable java.lang.Exception r1, int r2) {
        /*
            r0 = this;
            boolean r2 = r0.readField(r2)
            if (r2 != 0) goto L_0x0007
            return r1
        L_0x0007:
            int r2 = r0.readExceptionCode()
            if (r2 == 0) goto L_0x0016
            java.lang.String r1 = r0.readString()
            java.lang.Exception r0 = r0.createException(r2, r1)
            return r0
        L_0x0016:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.versionedparcelable.VersionedParcel.readException(java.lang.Exception, int):java.lang.Exception");
    }

    private int readExceptionCode() {
        return readInt();
    }

    @NonNull
    protected static Throwable getRootCause(@NonNull Throwable th) {
        while (th.getCause() != null) {
            th = th.getCause();
        }
        return th;
    }

    @NonNull
    private Exception createException(int i, String str) {
        switch (i) {
            case EX_PARCELABLE /*-9*/:
                return (Exception) readParcelable();
            case EX_UNSUPPORTED_OPERATION /*-7*/:
                return new UnsupportedOperationException(str);
            case -6:
                return new NetworkOnMainThreadException();
            case -5:
                return new IllegalStateException(str);
            case -4:
                return new NullPointerException(str);
            case -3:
                return new IllegalArgumentException(str);
            case -2:
                return new BadParcelableException(str);
            case -1:
                return new SecurityException(str);
            default:
                return new RuntimeException("Unknown exception code: " + i + " msg " + str);
        }
    }

    public byte readByte(byte b, int i) {
        if (!readField(i)) {
            return b;
        }
        return (byte) (readInt() & 255);
    }

    @RequiresApi(21)
    @Nullable
    public Size readSize(@Nullable Size size, int i) {
        if (!readField(i)) {
            return size;
        }
        return Api21Impl.readSize(this);
    }

    @RequiresApi(21)
    @Nullable
    public SizeF readSizeF(@Nullable SizeF sizeF, int i) {
        if (!readField(i)) {
            return sizeF;
        }
        return Api21Impl.readSizeF(this);
    }

    @Nullable
    public SparseBooleanArray readSparseBooleanArray(@Nullable SparseBooleanArray sparseBooleanArray, int i) {
        if (!readField(i)) {
            return sparseBooleanArray;
        }
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        SparseBooleanArray sparseBooleanArray2 = new SparseBooleanArray(readInt);
        for (int i2 = 0; i2 < readInt; i2++) {
            sparseBooleanArray2.put(readInt(), readBoolean());
        }
        return sparseBooleanArray2;
    }

    @Nullable
    public <T> Set<T> readSet(@Nullable Set<T> set, int i) {
        if (!readField(i)) {
            return set;
        }
        return (Set) readCollection(new ArraySet());
    }

    @Nullable
    public <T> List<T> readList(@Nullable List<T> list, int i) {
        if (!readField(i)) {
            return list;
        }
        return (List) readCollection(new ArrayList());
    }

    @Nullable
    private <T, S extends Collection<T>> S readCollection(@NonNull S s) {
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        if (readInt != 0) {
            int readInt2 = readInt();
            if (readInt < 0) {
                return null;
            }
            if (readInt2 == 1) {
                while (readInt > 0) {
                    s.add(readVersionedParcelable());
                    readInt--;
                }
            } else if (readInt2 == 2) {
                while (readInt > 0) {
                    s.add(readParcelable());
                    readInt--;
                }
            } else if (readInt2 == 3) {
                while (readInt > 0) {
                    s.add(readSerializable());
                    readInt--;
                }
            } else if (readInt2 == 4) {
                while (readInt > 0) {
                    s.add(readString());
                    readInt--;
                }
            } else if (readInt2 == 5) {
                while (readInt > 0) {
                    s.add(readStrongBinder());
                    readInt--;
                }
            }
        }
        return s;
    }

    @Nullable
    public <K, V> Map<K, V> readMap(@Nullable Map<K, V> map, int i) {
        if (!readField(i)) {
            return map;
        }
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        ArrayMap arrayMap = new ArrayMap(readInt);
        if (readInt == 0) {
            return arrayMap;
        }
        ArrayList arrayList = new ArrayList(readInt);
        ArrayList arrayList2 = new ArrayList(readInt);
        readCollection(arrayList);
        readCollection(arrayList2);
        for (int i2 = 0; i2 < readInt; i2++) {
            arrayMap.put(arrayList.get(i2), arrayList2.get(i2));
        }
        return arrayMap;
    }

    @Nullable
    public <T> T[] readArray(@Nullable T[] tArr, int i) {
        if (!readField(i)) {
            return tArr;
        }
        return readArray(tArr);
    }

    /* access modifiers changed from: protected */
    @Nullable
    public <T> T[] readArray(@Nullable T[] tArr) {
        int readInt = readInt();
        if (readInt < 0) {
            return null;
        }
        ArrayList arrayList = new ArrayList(readInt);
        if (readInt != 0) {
            int readInt2 = readInt();
            if (readInt < 0) {
                return null;
            }
            if (readInt2 == 1) {
                while (readInt > 0) {
                    arrayList.add(readVersionedParcelable());
                    readInt--;
                }
            } else if (readInt2 == 2) {
                while (readInt > 0) {
                    arrayList.add(readParcelable());
                    readInt--;
                }
            } else if (readInt2 == 3) {
                while (readInt > 0) {
                    arrayList.add(readSerializable());
                    readInt--;
                }
            } else if (readInt2 == 4) {
                while (readInt > 0) {
                    arrayList.add(readString());
                    readInt--;
                }
            } else if (readInt2 == 5) {
                while (readInt > 0) {
                    arrayList.add(readStrongBinder());
                    readInt--;
                }
            }
        }
        return arrayList.toArray(tArr);
    }

    @Nullable
    public <T extends VersionedParcelable> T readVersionedParcelable(@Nullable T t, int i) {
        if (!readField(i)) {
            return t;
        }
        return readVersionedParcelable();
    }

    /* access modifiers changed from: protected */
    @Nullable
    public <T extends VersionedParcelable> T readVersionedParcelable() {
        String readString = readString();
        if (readString == null) {
            return null;
        }
        return readFromParcel(readString, createSubParcel());
    }

    /* access modifiers changed from: protected */
    @Nullable
    public Serializable readSerializable() {
        String readString = readString();
        if (readString == null) {
            return null;
        }
        try {
            return (Serializable) new ObjectInputStream(new ByteArrayInputStream(readByteArray())) {
                /* access modifiers changed from: protected */
                public Class<?> resolveClass(ObjectStreamClass objectStreamClass) throws IOException, ClassNotFoundException {
                    Class<?> cls = Class.forName(objectStreamClass.getName(), false, getClass().getClassLoader());
                    if (cls != null) {
                        return cls;
                    }
                    return super.resolveClass(objectStreamClass);
                }
            }.readObject();
        } catch (IOException e) {
            throw new RuntimeException("Unable to read Serializable object (name = " + readString + ")", e);
        } catch (ClassNotFoundException e2) {
            throw new RuntimeException("Unable to read Serializable object (name = " + readString + ")", e2);
        }
    }

    /* access modifiers changed from: protected */
    @NonNull
    public <T extends VersionedParcelable> T readFromParcel(@NonNull String str, @NonNull VersionedParcel versionedParcel) {
        try {
            return (VersionedParcelable) getReadMethod(str).invoke((Object) null, new Object[]{versionedParcel});
        } catch (IllegalAccessException e) {
            throw new RuntimeException(e);
        } catch (InvocationTargetException e2) {
            Throwable cause = e2.getCause();
            if (cause instanceof RuntimeException) {
                throw ((RuntimeException) cause);
            } else if (cause instanceof Error) {
                throw ((Error) cause);
            } else {
                throw new RuntimeException(e2);
            }
        } catch (NoSuchMethodException e3) {
            throw new RuntimeException(e3);
        } catch (ClassNotFoundException e4) {
            throw new RuntimeException(e4);
        }
    }

    /* access modifiers changed from: protected */
    public <T extends VersionedParcelable> void writeToParcel(@NonNull T t, @NonNull VersionedParcel versionedParcel) {
        try {
            getWriteMethod(t.getClass()).invoke((Object) null, new Object[]{t, versionedParcel});
        } catch (IllegalAccessException e) {
            throw new RuntimeException(e);
        } catch (InvocationTargetException e2) {
            Throwable cause = e2.getCause();
            if (cause instanceof RuntimeException) {
                throw ((RuntimeException) cause);
            } else if (cause instanceof Error) {
                throw ((Error) cause);
            } else {
                throw new RuntimeException(e2);
            }
        } catch (NoSuchMethodException e3) {
            throw new RuntimeException(e3);
        } catch (ClassNotFoundException e4) {
            throw new RuntimeException(e4);
        }
    }

    @NonNull
    private Method getReadMethod(@NonNull String str) throws IllegalAccessException, NoSuchMethodException, ClassNotFoundException {
        Class<VersionedParcel> cls = VersionedParcel.class;
        Method method = this.mReadCache.get(str);
        if (method != null) {
            return method;
        }
        Method declaredMethod = Class.forName(str, true, cls.getClassLoader()).getDeclaredMethod("read", new Class[]{cls});
        this.mReadCache.put(str, declaredMethod);
        return declaredMethod;
    }

    @NonNull
    private Method getWriteMethod(@NonNull Class<?> cls) throws IllegalAccessException, NoSuchMethodException, ClassNotFoundException {
        Method method = this.mWriteCache.get(cls.getName());
        if (method != null) {
            return method;
        }
        Method declaredMethod = findParcelClass(cls).getDeclaredMethod("write", new Class[]{cls, VersionedParcel.class});
        this.mWriteCache.put(cls.getName(), declaredMethod);
        return declaredMethod;
    }

    @NonNull
    private Class<?> findParcelClass(@NonNull Class<?> cls) throws ClassNotFoundException {
        Class<?> cls2 = this.mParcelizerCache.get(cls.getName());
        if (cls2 != null) {
            return cls2;
        }
        Class<?> cls3 = Class.forName(String.format("%s.%sParcelizer", new Object[]{cls.getPackage().getName(), cls.getSimpleName()}), false, cls.getClassLoader());
        this.mParcelizerCache.put(cls.getName(), cls3);
        return cls3;
    }

    public static class ParcelException extends RuntimeException {
        public ParcelException(@Nullable Throwable th) {
            super(th);
        }
    }

    @RequiresApi(21)
    private static final class Api21Impl {
        private Api21Impl() {
        }

        @DoNotInline
        static void writeSize(@NonNull VersionedParcel versionedParcel, @Nullable Size size) {
            versionedParcel.writeBoolean(size != null);
            if (size != null) {
                versionedParcel.writeInt(size.getWidth());
                versionedParcel.writeInt(size.getHeight());
            }
        }

        @DoNotInline
        static void writeSizeF(@NonNull VersionedParcel versionedParcel, @Nullable SizeF sizeF) {
            versionedParcel.writeBoolean(sizeF != null);
            if (sizeF != null) {
                versionedParcel.writeFloat(sizeF.getWidth());
                versionedParcel.writeFloat(sizeF.getHeight());
            }
        }

        @DoNotInline
        @Nullable
        static Size readSize(@NonNull VersionedParcel versionedParcel) {
            if (versionedParcel.readBoolean()) {
                return new Size(versionedParcel.readInt(), versionedParcel.readInt());
            }
            return null;
        }

        @DoNotInline
        @Nullable
        static SizeF readSizeF(@NonNull VersionedParcel versionedParcel) {
            if (versionedParcel.readBoolean()) {
                return new SizeF(versionedParcel.readFloat(), versionedParcel.readFloat());
            }
            return null;
        }
    }
}
