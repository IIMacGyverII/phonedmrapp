package androidx.core.os;

import android.annotation.SuppressLint;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.SparseArray;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class ParcelCompat {
    public static boolean readBoolean(@NonNull Parcel parcel) {
        return parcel.readInt() != 0;
    }

    public static void writeBoolean(@NonNull Parcel parcel, boolean z) {
        parcel.writeInt(z ? 1 : 0);
    }

    public static <T> void readList(@NonNull Parcel parcel, @NonNull List<? super T> list, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
        TiramisuImpl.readList(parcel, list, classLoader, cls);
    }

    @SuppressLint({"ConcreteCollection", "NullableCollection"})
    @Nullable
    public static <T> ArrayList<T> readArrayList(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<? extends T> cls) {
        return TiramisuImpl.readArrayList(parcel, classLoader, cls);
    }

    @SuppressLint({"ArrayReturn", "NullableCollection"})
    @Nullable
    public static <T> T[] readArray(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
        return TiramisuImpl.readArray(parcel, classLoader, cls);
    }

    @Nullable
    public static <T> SparseArray<T> readSparseArray(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<? extends T> cls) {
        return TiramisuImpl.readSparseArray(parcel, classLoader, cls);
    }

    public static <K, V> void readMap(@NonNull Parcel parcel, @NonNull Map<? super K, ? super V> map, @Nullable ClassLoader classLoader, @NonNull Class<K> cls, @NonNull Class<V> cls2) {
        TiramisuImpl.readMap(parcel, map, classLoader, cls, cls2);
    }

    @SuppressLint({"ConcreteCollection", "NullableCollection"})
    @Nullable
    public static <K, V> HashMap<K, V> readHashMap(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<? extends K> cls, @NonNull Class<? extends V> cls2) {
        return TiramisuImpl.readHashMap(parcel, classLoader, cls, cls2);
    }

    @Nullable
    public static <T extends Parcelable> T readParcelable(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
        return TiramisuImpl.readParcelable(parcel, classLoader, cls);
    }

    @RequiresApi(30)
    @Nullable
    public static <T> Parcelable.Creator<T> readParcelableCreator(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
        return TiramisuImpl.readParcelableCreator(parcel, classLoader, cls);
    }

    @SuppressLint({"ArrayReturn", "NullableCollection"})
    @Nullable
    public static <T> T[] readParcelableArray(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
        return TiramisuImpl.readParcelableArray(parcel, classLoader, cls);
    }

    @RequiresApi(api = 29)
    @NonNull
    public static <T> List<T> readParcelableList(@NonNull Parcel parcel, @NonNull List<T> list, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
        return TiramisuImpl.readParcelableList(parcel, list, classLoader, cls);
    }

    @Nullable
    public static <T extends Serializable> T readSerializable(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
        return TiramisuImpl.readSerializable(parcel, classLoader, cls);
    }

    private ParcelCompat() {
    }

    @RequiresApi(29)
    static class Api29Impl {
        private Api29Impl() {
        }

        @DoNotInline
        static final <T extends Parcelable> List<T> readParcelableList(@NonNull Parcel parcel, @NonNull List<T> list, @Nullable ClassLoader classLoader) {
            return parcel.readParcelableList(list, classLoader);
        }
    }

    @RequiresApi(30)
    static class Api30Impl {
        private Api30Impl() {
        }

        @DoNotInline
        static final Parcelable.Creator<?> readParcelableCreator(@NonNull Parcel parcel, @Nullable ClassLoader classLoader) {
            return parcel.readParcelableCreator(classLoader);
        }
    }

    @RequiresApi(33)
    static class TiramisuImpl {
        private TiramisuImpl() {
        }

        @DoNotInline
        static <T extends Serializable> T readSerializable(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
            return (Serializable) parcel.readSerializable(classLoader, cls);
        }

        @DoNotInline
        static <T extends Parcelable> T readParcelable(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
            return (Parcelable) parcel.readParcelable(classLoader, cls);
        }

        @DoNotInline
        public static <T> Parcelable.Creator<T> readParcelableCreator(Parcel parcel, ClassLoader classLoader, Class<T> cls) {
            return parcel.readParcelableCreator(classLoader, cls);
        }

        @DoNotInline
        static <T> T[] readParcelableArray(@NonNull Parcel parcel, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
            return parcel.readParcelableArray(classLoader, cls);
        }

        @DoNotInline
        static <T> List<T> readParcelableList(@NonNull Parcel parcel, @NonNull List<T> list, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
            return parcel.readParcelableList(list, classLoader, cls);
        }

        @DoNotInline
        public static <T> void readList(@NonNull Parcel parcel, @NonNull List<? super T> list, @Nullable ClassLoader classLoader, @NonNull Class<T> cls) {
            parcel.readList(list, classLoader, cls);
        }

        @DoNotInline
        public static <T> ArrayList<T> readArrayList(Parcel parcel, ClassLoader classLoader, Class<? extends T> cls) {
            return parcel.readArrayList(classLoader, cls);
        }

        @DoNotInline
        public static <T> T[] readArray(Parcel parcel, ClassLoader classLoader, Class<T> cls) {
            return parcel.readArray(classLoader, cls);
        }

        @DoNotInline
        public static <T> SparseArray<T> readSparseArray(Parcel parcel, ClassLoader classLoader, Class<? extends T> cls) {
            return parcel.readSparseArray(classLoader, cls);
        }

        @DoNotInline
        public static <K, V> void readMap(Parcel parcel, Map<? super K, ? super V> map, ClassLoader classLoader, Class<K> cls, Class<V> cls2) {
            parcel.readMap(map, classLoader, cls, cls2);
        }

        @DoNotInline
        public static <V, K> HashMap<K, V> readHashMap(Parcel parcel, ClassLoader classLoader, Class<? extends K> cls, Class<? extends V> cls2) {
            return parcel.readHashMap(classLoader, cls, cls2);
        }
    }
}
