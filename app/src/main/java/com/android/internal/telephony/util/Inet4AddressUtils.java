package com.android.internal.telephony.util;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import kotlin.UByte;

public class Inet4AddressUtils {
    public static Inet4Address intToInet4AddressHTL(int i) {
        return intToInet4AddressHTH(Integer.reverseBytes(i));
    }

    public static Inet4Address intToInet4AddressHTH(int i) {
        try {
            return (Inet4Address) InetAddress.getByAddress(new byte[]{(byte) ((i >> 24) & 255), (byte) ((i >> 16) & 255), (byte) ((i >> 8) & 255), (byte) (i & 255)});
        } catch (UnknownHostException unused) {
            throw new AssertionError();
        }
    }

    public static int inet4AddressToIntHTH(Inet4Address inet4Address) throws IllegalArgumentException {
        byte[] address = inet4Address.getAddress();
        return (address[3] & UByte.MAX_VALUE) | ((address[0] & UByte.MAX_VALUE) << 24) | ((address[1] & UByte.MAX_VALUE) << 16) | ((address[2] & UByte.MAX_VALUE) << 8);
    }

    public static int inet4AddressToIntHTL(Inet4Address inet4Address) {
        return Integer.reverseBytes(inet4AddressToIntHTH(inet4Address));
    }

    public static int prefixLengthToV4NetmaskIntHTH(int i) throws IllegalArgumentException {
        if (i < 0 || i > 32) {
            throw new IllegalArgumentException("Invalid prefix length (0 <= prefix <= 32)");
        } else if (i == 0) {
            return 0;
        } else {
            return -1 << (32 - i);
        }
    }

    public static int prefixLengthToV4NetmaskIntHTL(int i) throws IllegalArgumentException {
        return Integer.reverseBytes(prefixLengthToV4NetmaskIntHTH(i));
    }

    public static int netmaskToPrefixLength(Inet4Address inet4Address) {
        int inet4AddressToIntHTH = inet4AddressToIntHTH(inet4Address);
        int bitCount = Integer.bitCount(inet4AddressToIntHTH);
        if (Integer.numberOfTrailingZeros(inet4AddressToIntHTH) == 32 - bitCount) {
            return bitCount;
        }
        throw new IllegalArgumentException("Non-contiguous netmask: " + Integer.toHexString(inet4AddressToIntHTH));
    }

    public static int getImplicitNetmask(Inet4Address inet4Address) {
        byte b = inet4Address.getAddress()[0] & UByte.MAX_VALUE;
        if (b < 128) {
            return 8;
        }
        if (b < 192) {
            return 16;
        }
        return b < 224 ? 24 : 32;
    }

    public static Inet4Address getBroadcastAddress(Inet4Address inet4Address, int i) throws IllegalArgumentException {
        return intToInet4AddressHTH(inet4AddressToIntHTH(inet4Address) | (~prefixLengthToV4NetmaskIntHTH(i)));
    }

    public static Inet4Address getPrefixMaskAsInet4Address(int i) throws IllegalArgumentException {
        return intToInet4AddressHTH(prefixLengthToV4NetmaskIntHTH(i));
    }

    public static String trimAddressZeros(String str) {
        if (str == null) {
            return null;
        }
        String[] split = str.split("\\.");
        if (split.length != 4) {
            return str;
        }
        StringBuilder sb = new StringBuilder(16);
        int i = 0;
        while (i < 4) {
            try {
                if (split[i].length() > 3) {
                    return str;
                }
                sb.append(Integer.parseInt(split[i]));
                if (i < 3) {
                    sb.append('.');
                }
                i++;
            } catch (NumberFormatException unused) {
                return str;
            }
        }
        return sb.toString();
    }
}
