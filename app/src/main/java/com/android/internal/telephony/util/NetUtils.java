package com.android.internal.telephony.util;

import android.net.RouteInfo;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Collection;

public final class NetUtils {
    public static boolean addressTypeMatches(InetAddress inetAddress, InetAddress inetAddress2) {
        return ((inetAddress instanceof Inet4Address) && (inetAddress2 instanceof Inet4Address)) || ((inetAddress instanceof Inet6Address) && (inetAddress2 instanceof Inet6Address));
    }

    public static RouteInfo selectBestRoute(Collection<RouteInfo> collection, InetAddress inetAddress) {
        if (!(collection == null || inetAddress == null)) {
            RouteInfo routeInfo = null;
            for (RouteInfo next : collection) {
                if (addressTypeMatches(next.getDestination().getAddress(), inetAddress) && ((routeInfo == null || routeInfo.getDestination().getPrefixLength() < next.getDestination().getPrefixLength()) && next.matches(inetAddress))) {
                    routeInfo = next;
                }
            }
            if (routeInfo == null || routeInfo.getType() != 1) {
                return null;
            }
            return routeInfo;
        }
        return null;
    }

    public static InetAddress getNetworkPart(InetAddress inetAddress, int i) {
        byte[] address = inetAddress.getAddress();
        maskRawAddress(address, i);
        try {
            return InetAddress.getByAddress(address);
        } catch (UnknownHostException e) {
            throw new RuntimeException("getNetworkPart error - " + e.toString());
        }
    }

    public static void maskRawAddress(byte[] bArr, int i) {
        if (i < 0 || i > bArr.length * 8) {
            throw new RuntimeException("IP address with " + bArr.length + " bytes has invalid prefix length " + i);
        }
        int i2 = i / 8;
        byte b = (byte) (255 << (8 - (i % 8)));
        if (i2 < bArr.length) {
            bArr[i2] = (byte) (b & bArr[i2]);
        }
        while (true) {
            i2++;
            if (i2 < bArr.length) {
                bArr[i2] = 0;
            } else {
                return;
            }
        }
    }
}
