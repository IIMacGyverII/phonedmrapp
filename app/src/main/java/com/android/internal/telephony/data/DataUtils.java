package com.android.internal.telephony.data;

import android.os.SystemClock;
import android.telephony.data.DataProfile;
import android.util.ArrayMap;
import com.android.internal.telephony.data.DataNetworkController;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DataUtils {
    private static final SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("HH:mm:ss.SSS", Locale.US);

    public static int apnTypeToNetworkCapability(int i) {
        switch (i) {
            case 2:
                return 0;
            case 4:
                return 1;
            case 8:
                return 2;
            case 17:
                return 12;
            case 32:
                return 3;
            case 64:
                return 4;
            case 128:
                return 5;
            case 256:
                return 7;
            case 512:
                return 10;
            case 1024:
                return 23;
            case 2048:
                return 9;
            case 4096:
                return 30;
            case 8192:
                return 31;
            case 16384:
                return 29;
            default:
                return -1;
        }
    }

    public static int getSourceTransport(int i) {
        return i == 1 ? 2 : 1;
    }

    public static int getTargetTransport(int i) {
        return i == 1 ? 2 : 1;
    }

    public static boolean isValidAccessNetwork(int i) {
        switch (i) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                return true;
            default:
                return false;
        }
    }

    public static int networkCapabilityToApnType(int i) {
        if (i == 0) {
            return 2;
        }
        if (i == 1) {
            return 4;
        }
        if (i == 2) {
            return 8;
        }
        if (i == 3) {
            return 32;
        }
        if (i == 4) {
            return 64;
        }
        if (i == 5) {
            return 128;
        }
        if (i == 7) {
            return 256;
        }
        if (i == 12) {
            return 17;
        }
        if (i == 23) {
            return 1024;
        }
        if (i == 9) {
            return 2048;
        }
        if (i == 10) {
            return 512;
        }
        switch (i) {
            case 29:
                return 16384;
            case 30:
                return 4096;
            case 31:
                return 8192;
            default:
                return 0;
        }
    }

    public static int networkTypeToAccessNetworkType(int i) {
        switch (i) {
            case 1:
            case 2:
            case 16:
                return 1;
            case 3:
            case 8:
            case 9:
            case 10:
            case 15:
            case 17:
                return 2;
            case 4:
            case 5:
            case 6:
            case 7:
            case 12:
            case 14:
                return 4;
            case 13:
            case 19:
                return 3;
            case 18:
                return 5;
            case 20:
                return 6;
            default:
                return 0;
        }
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static int getNetworkCapabilityFromString(java.lang.String r11) {
        /*
            java.util.Locale r0 = java.util.Locale.ROOT
            java.lang.String r11 = r11.toUpperCase(r0)
            r11.hashCode()
            int r0 = r11.hashCode()
            r1 = 12
            r2 = 10
            r3 = 9
            r4 = 5
            r5 = 4
            r6 = 3
            r7 = 2
            r8 = 1
            r9 = 0
            r10 = -1
            switch(r0) {
                case -471939055: goto L_0x00c9;
                case -317644959: goto L_0x00bd;
                case 65769: goto L_0x00b1;
                case 66516: goto L_0x00a5;
                case 68061: goto L_0x0099;
                case 72623: goto L_0x008e;
                case 76162: goto L_0x0083;
                case 76467: goto L_0x0078;
                case 2128202: goto L_0x006b;
                case 2163958: goto L_0x005f;
                case 2556894: goto L_0x0053;
                case 2644129: goto L_0x0046;
                case 2688090: goto L_0x003a;
                case 906932318: goto L_0x002d;
                case 1353037633: goto L_0x0020;
                default: goto L_0x001d;
            }
        L_0x001d:
            r11 = r10
            goto L_0x00d4
        L_0x0020:
            java.lang.String r0 = "INTERNET"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x0029
            goto L_0x001d
        L_0x0029:
            r11 = 14
            goto L_0x00d4
        L_0x002d:
            java.lang.String r0 = "PRIORITIZE_LATENCY"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x0036
            goto L_0x001d
        L_0x0036:
            r11 = 13
            goto L_0x00d4
        L_0x003a:
            java.lang.String r0 = "XCAP"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x0043
            goto L_0x001d
        L_0x0043:
            r11 = r1
            goto L_0x00d4
        L_0x0046:
            java.lang.String r0 = "VSIM"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x004f
            goto L_0x001d
        L_0x004f:
            r11 = 11
            goto L_0x00d4
        L_0x0053:
            java.lang.String r0 = "SUPL"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x005c
            goto L_0x001d
        L_0x005c:
            r11 = r2
            goto L_0x00d4
        L_0x005f:
            java.lang.String r0 = "FOTA"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x0068
            goto L_0x001d
        L_0x0068:
            r11 = r3
            goto L_0x00d4
        L_0x006b:
            java.lang.String r0 = "EIMS"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x0074
            goto L_0x001d
        L_0x0074:
            r11 = 8
            goto L_0x00d4
        L_0x0078:
            java.lang.String r0 = "MMS"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x0081
            goto L_0x001d
        L_0x0081:
            r11 = 7
            goto L_0x00d4
        L_0x0083:
            java.lang.String r0 = "MCX"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x008c
            goto L_0x001d
        L_0x008c:
            r11 = 6
            goto L_0x00d4
        L_0x008e:
            java.lang.String r0 = "IMS"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x0097
            goto L_0x001d
        L_0x0097:
            r11 = r4
            goto L_0x00d4
        L_0x0099:
            java.lang.String r0 = "DUN"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x00a3
            goto L_0x001d
        L_0x00a3:
            r11 = r5
            goto L_0x00d4
        L_0x00a5:
            java.lang.String r0 = "CBS"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x00af
            goto L_0x001d
        L_0x00af:
            r11 = r6
            goto L_0x00d4
        L_0x00b1:
            java.lang.String r0 = "BIP"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x00bb
            goto L_0x001d
        L_0x00bb:
            r11 = r7
            goto L_0x00d4
        L_0x00bd:
            java.lang.String r0 = "ENTERPRISE"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x00c7
            goto L_0x001d
        L_0x00c7:
            r11 = r8
            goto L_0x00d4
        L_0x00c9:
            java.lang.String r0 = "PRIORITIZE_BANDWIDTH"
            boolean r11 = r11.equals(r0)
            if (r11 != 0) goto L_0x00d3
            goto L_0x001d
        L_0x00d3:
            r11 = r9
        L_0x00d4:
            switch(r11) {
                case 0: goto L_0x00f0;
                case 1: goto L_0x00ed;
                case 2: goto L_0x00ea;
                case 3: goto L_0x00e9;
                case 4: goto L_0x00e8;
                case 5: goto L_0x00e7;
                case 6: goto L_0x00e4;
                case 7: goto L_0x00e3;
                case 8: goto L_0x00e2;
                case 9: goto L_0x00e1;
                case 10: goto L_0x00e0;
                case 11: goto L_0x00dd;
                case 12: goto L_0x00dc;
                case 13: goto L_0x00d9;
                case 14: goto L_0x00d8;
                default: goto L_0x00d7;
            }
        L_0x00d7:
            return r10
        L_0x00d8:
            return r1
        L_0x00d9:
            r11 = 34
            return r11
        L_0x00dc:
            return r3
        L_0x00dd:
            r11 = 30
            return r11
        L_0x00e0:
            return r8
        L_0x00e1:
            return r6
        L_0x00e2:
            return r2
        L_0x00e3:
            return r9
        L_0x00e4:
            r11 = 23
            return r11
        L_0x00e7:
            return r5
        L_0x00e8:
            return r7
        L_0x00e9:
            return r4
        L_0x00ea:
            r11 = 31
            return r11
        L_0x00ed:
            r11 = 29
            return r11
        L_0x00f0:
            r11 = 35
            return r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.DataUtils.getNetworkCapabilityFromString(java.lang.String):int");
    }

    public static Set<Integer> getNetworkCapabilitiesFromString(String str) {
        if (!str.matches("(\\s*[a-zA-Z]+\\s*)(\\|\\s*[a-zA-Z]+\\s*)*")) {
            return Collections.singleton(-1);
        }
        return (Set) Arrays.stream(str.split("\\s*\\|\\s*")).map(new DataNetworkController$HandoverRule$$ExternalSyntheticLambda0()).map(new DataUtils$$ExternalSyntheticLambda4()).collect(Collectors.toSet());
    }

    public static String networkCapabilityToString(int i) {
        switch (i) {
            case 0:
                return "MMS";
            case 1:
                return "SUPL";
            case 2:
                return "DUN";
            case 3:
                return "FOTA";
            case 4:
                return "IMS";
            case 5:
                return "CBS";
            case 6:
                return "WIFI_P2P";
            case 7:
                return "IA";
            case 8:
                return "RCS";
            case 9:
                return "XCAP";
            case 10:
                return "EIMS";
            case 11:
                return "NOT_METERED";
            case 12:
                return "INTERNET";
            case 13:
                return "NOT_RESTRICTED";
            case 14:
                return "TRUSTED";
            case 15:
                return "NOT_VPN";
            case 16:
                return "VALIDATED";
            case 17:
                return "CAPTIVE_PORTAL";
            case 18:
                return "NOT_ROAMING";
            case 19:
                return "FOREGROUND";
            case 20:
                return "NOT_CONGESTED";
            case 21:
                return "NOT_SUSPENDED";
            case 22:
                return "OEM_PAID";
            case 23:
                return "MCX";
            case 24:
                return "PARTIAL_CONNECTIVITY";
            case 25:
                return "TEMPORARILY_NOT_METERED";
            case 26:
                return "OEM_PRIVATE";
            case 27:
                return "VEHICLE_INTERNAL";
            case 28:
                return "NOT_VCN_MANAGED";
            case 29:
                return "ENTERPRISE";
            case 30:
                return "VSIM";
            case 31:
                return "BIP";
            case 32:
                return "HEAD_UNIT";
            case 33:
                return "MMTEL";
            case 34:
                return "PRIORITIZE_LATENCY";
            case 35:
                return "PRIORITIZE_BANDWIDTH";
            default:
                return "Unknown(" + i + ")";
        }
    }

    public static String networkCapabilitiesToString(Collection<Integer> collection) {
        if (collection == null || collection.isEmpty()) {
            return "";
        }
        return "[" + ((String) collection.stream().map(new DataUtils$$ExternalSyntheticLambda1()).collect(Collectors.joining("|"))) + "]";
    }

    public static String networkCapabilitiesToString(int[] iArr) {
        if (iArr == null) {
            return "";
        }
        return "[" + ((String) Arrays.stream(iArr).mapToObj(new DataUtils$$ExternalSyntheticLambda0()).collect(Collectors.joining("|"))) + "]";
    }

    public static String validationStatusToString(int i) {
        if (i == 1) {
            return "VALID";
        }
        if (i == 2) {
            return "INVALID";
        }
        return "UNKNOWN(" + i + ")";
    }

    public static String elapsedTimeToString(long j) {
        return j != 0 ? systemTimeToString((System.currentTimeMillis() - SystemClock.elapsedRealtime()) + j) : "never";
    }

    public static String systemTimeToString(long j) {
        return j != 0 ? TIME_FORMAT.format(Long.valueOf(j)) : "never";
    }

    public static String imsFeatureToString(int i) {
        if (i == 1) {
            return "MMTEL";
        }
        if (i == 2) {
            return "RCS";
        }
        return "Unknown(" + i + ")";
    }

    public static int getHighestPriorityNetworkCapabilityFromDataProfile(DataConfigManager dataConfigManager, DataProfile dataProfile) {
        if (dataProfile.getApnSetting() == null || dataProfile.getApnSetting().getApnTypes().isEmpty()) {
            return -1;
        }
        Stream map = dataProfile.getApnSetting().getApnTypes().stream().map(new DataConfigManager$$ExternalSyntheticLambda14());
        Objects.requireNonNull(dataConfigManager);
        return ((Integer) ((List) map.sorted(Comparator.comparing(new DataNetwork$$ExternalSyntheticLambda2(dataConfigManager)).reversed()).collect(Collectors.toList())).get(0)).intValue();
    }

    public static List<DataNetworkController.NetworkRequestList> getGroupedNetworkRequestList(DataNetworkController.NetworkRequestList networkRequestList) {
        ArrayMap arrayMap = new ArrayMap();
        Iterator it = networkRequestList.iterator();
        while (it.hasNext()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) it.next();
            ((DataNetworkController.NetworkRequestList) arrayMap.computeIfAbsent((Set) Arrays.stream(telephonyNetworkRequest.getCapabilities()).boxed().collect(Collectors.toSet()), new DataUtils$$ExternalSyntheticLambda2())).add(telephonyNetworkRequest);
        }
        return (List) new ArrayList(arrayMap.values()).stream().sorted(new DataUtils$$ExternalSyntheticLambda3()).collect(Collectors.toList());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ DataNetworkController.NetworkRequestList lambda$getGroupedNetworkRequestList$0(Set set) {
        return new DataNetworkController.NetworkRequestList();
    }

    public static String linkStatusToString(int i) {
        if (i == -1) {
            return "UNKNOWN";
        }
        if (i == 0) {
            return "INACTIVE";
        }
        if (i == 1) {
            return "DORMANT";
        }
        if (i == 2) {
            return "ACTIVE";
        }
        return "UNKNOWN(" + i + ")";
    }

    public static String dataActivityToString(int i) {
        if (i == 0) {
            return "NONE";
        }
        if (i == 1) {
            return "IN";
        }
        if (i == 2) {
            return "OUT";
        }
        if (i == 3) {
            return "INOUT";
        }
        if (i == 4) {
            return "DORMANT";
        }
        return "UNKNOWN(" + i + ")";
    }
}
