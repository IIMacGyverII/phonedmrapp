package com.android.internal.telephony;

import android.content.Context;
import android.os.Bundle;

public class BlockChecker {
    private static final String TAG = "BlockChecker";
    private static final boolean VDBG = false;

    @Deprecated
    public static boolean isBlocked(Context context, String str) {
        return isBlocked(context, str, (Bundle) null);
    }

    public static boolean isBlocked(Context context, String str, Bundle bundle) {
        return getBlockStatus(context, str, bundle) != 0;
    }

    /* JADX WARNING: Removed duplicated region for block: B:12:0x0048  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static int getBlockStatus(android.content.Context r4, java.lang.String r5, android.os.Bundle r6) {
        /*
            java.lang.String r0 = "BlockChecker"
            long r1 = java.lang.System.nanoTime()
            int r4 = android.provider.BlockedNumberContract.SystemContract.shouldSystemBlockNumber(r4, r5, r6)     // Catch:{ Exception -> 0x0023 }
            if (r4 == 0) goto L_0x0039
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x0021 }
            r6.<init>()     // Catch:{ Exception -> 0x0021 }
            r6.append(r5)     // Catch:{ Exception -> 0x0021 }
            java.lang.String r5 = " is blocked."
            r6.append(r5)     // Catch:{ Exception -> 0x0021 }
            java.lang.String r5 = r6.toString()     // Catch:{ Exception -> 0x0021 }
            com.android.telephony.Rlog.d(r0, r5)     // Catch:{ Exception -> 0x0021 }
            goto L_0x0039
        L_0x0021:
            r5 = move-exception
            goto L_0x0025
        L_0x0023:
            r5 = move-exception
            r4 = 0
        L_0x0025:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r3 = "Exception checking for blocked number: "
            r6.append(r3)
            r6.append(r5)
            java.lang.String r5 = r6.toString()
            com.android.telephony.Rlog.e(r0, r5)
        L_0x0039:
            long r5 = java.lang.System.nanoTime()
            long r5 = r5 - r1
            r1 = 1000000(0xf4240, double:4.940656E-318)
            long r5 = r5 / r1
            int r5 = (int) r5
            r6 = 500(0x1f4, float:7.0E-43)
            if (r5 > r6) goto L_0x0048
            goto L_0x0061
        L_0x0048:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r1 = "Blocked number lookup took: "
            r6.append(r1)
            r6.append(r5)
            java.lang.String r5 = " ms."
            r6.append(r5)
            java.lang.String r5 = r6.toString()
            com.android.telephony.Rlog.d(r0, r5)
        L_0x0061:
            return r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.BlockChecker.getBlockStatus(android.content.Context, java.lang.String, android.os.Bundle):int");
    }
}
