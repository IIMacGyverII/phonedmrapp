package com.android.internal.telephony.util;

import android.net.NetworkCapabilities;
import com.android.net.module.annotation.VisibleForTesting;

public final class NetworkCapabilitiesUtils {
    private static final int[] DISPLAY_TRANSPORT_PRIORITIES = {4, 0, 5, 2, 1, 3, 8};
    private static final long FORCE_RESTRICTED_CAPABILITIES = packBitList(29, 22, 26);
    @VisibleForTesting
    public static final long RESTRICTED_CAPABILITIES = packBitList(31, 5, 2, 10, 29, 3, 7, 4, 23, 8, 27, 30, 9, 33);
    @VisibleForTesting
    public static final long UNRESTRICTED_CAPABILITIES = packBitList(12, 0, 1, 6);

    public static int getDisplayTransport(int[] iArr) {
        for (int i : DISPLAY_TRANSPORT_PRIORITIES) {
            if (CollectionUtils.contains(iArr, i)) {
                return i;
            }
        }
        if (iArr.length >= 1) {
            return iArr[0];
        }
        throw new IllegalArgumentException("No transport in the provided array");
    }

    public static boolean inferRestrictedCapability(NetworkCapabilities networkCapabilities) {
        for (int hasCapability : unpackBits(FORCE_RESTRICTED_CAPABILITIES)) {
            if (networkCapabilities.hasCapability(hasCapability)) {
                return true;
            }
        }
        for (int hasCapability2 : unpackBits(UNRESTRICTED_CAPABILITIES)) {
            if (networkCapabilities.hasCapability(hasCapability2)) {
                return false;
            }
        }
        for (int hasCapability3 : unpackBits(RESTRICTED_CAPABILITIES)) {
            if (networkCapabilities.hasCapability(hasCapability3)) {
                return true;
            }
        }
        return false;
    }

    public static int[] unpackBits(long j) {
        int[] iArr = new int[Long.bitCount(j)];
        int i = 0;
        int i2 = 0;
        while (j != 0) {
            if ((j & 1) == 1) {
                iArr[i] = i2;
                i++;
            }
            j >>>= 1;
            i2++;
        }
        return iArr;
    }

    public static long packBitList(int... iArr) {
        return packBits(iArr);
    }

    public static long packBits(int[] iArr) {
        long j = 0;
        for (int i : iArr) {
            j |= 1 << i;
        }
        return j;
    }
}
