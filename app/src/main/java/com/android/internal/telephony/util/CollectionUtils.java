package com.android.internal.telephony.util;

import android.util.SparseArray;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Objects;
import java.util.function.Predicate;

public final class CollectionUtils {
    private CollectionUtils() {
    }

    public static <T> boolean isEmpty(T[] tArr) {
        return tArr == null || tArr.length == 0;
    }

    public static <T> boolean isEmpty(Collection<T> collection) {
        return collection == null || collection.isEmpty();
    }

    public static int[] toIntArray(Collection<Integer> collection) {
        int[] iArr = new int[collection.size()];
        int i = 0;
        for (Integer intValue : collection) {
            iArr[i] = intValue.intValue();
            i++;
        }
        return iArr;
    }

    public static long[] toLongArray(Collection<Long> collection) {
        long[] jArr = new long[collection.size()];
        int i = 0;
        for (Long longValue : collection) {
            jArr[i] = longValue.longValue();
            i++;
        }
        return jArr;
    }

    public static <T> boolean all(Collection<T> collection, Predicate<T> predicate) {
        for (T test : collection) {
            if (!predicate.test(test)) {
                return false;
            }
        }
        return true;
    }

    public static <T> boolean any(Collection<T> collection, Predicate<T> predicate) {
        return indexOf(collection, predicate) >= 0;
    }

    public static <T> int indexOf(Collection<T> collection, Predicate<T> predicate) {
        int i = 0;
        for (T test : collection) {
            if (predicate.test(test)) {
                return i;
            }
            i++;
        }
        return -1;
    }

    public static <T> boolean any(SparseArray<T> sparseArray, Predicate<T> predicate) {
        for (int i = 0; i < sparseArray.size(); i++) {
            if (predicate.test(sparseArray.valueAt(i))) {
                return true;
            }
        }
        return false;
    }

    public static boolean contains(short[] sArr, short s) {
        if (sArr == null) {
            return false;
        }
        for (short s2 : sArr) {
            if (s2 == s) {
                return true;
            }
        }
        return false;
    }

    public static boolean contains(int[] iArr, int i) {
        if (iArr == null) {
            return false;
        }
        for (int i2 : iArr) {
            if (i2 == i) {
                return true;
            }
        }
        return false;
    }

    public static <T> boolean contains(T[] tArr, T t) {
        return indexOf(tArr, t) != -1;
    }

    public static <T> int indexOf(T[] tArr, T t) {
        if (tArr == null) {
            return -1;
        }
        for (int i = 0; i < tArr.length; i++) {
            if (Objects.equals(tArr[i], t)) {
                return i;
            }
        }
        return -1;
    }

    public static <T> ArrayList<T> filter(Collection<T> collection, Predicate<T> predicate) {
        ArrayList<T> arrayList = new ArrayList<>();
        for (T next : collection) {
            if (predicate.test(next)) {
                arrayList.add(next);
            }
        }
        return arrayList;
    }

    public static long total(long[] jArr) {
        long j = 0;
        if (jArr != null) {
            for (long j2 : jArr) {
                j += j2;
            }
        }
        return j;
    }

    public static <T> boolean containsAny(Collection<T> collection, Collection<? extends T> collection2) {
        for (Object contains : collection2) {
            if (collection.contains(contains)) {
                return true;
            }
        }
        return false;
    }

    public static <T> boolean containsAll(Collection<T> collection, Collection<? extends T> collection2) {
        return collection.containsAll(collection2);
    }
}
