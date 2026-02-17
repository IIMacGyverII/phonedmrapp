package com.android.internal.telephony;

import com.android.telephony.Rlog;

public class DebugService {
    private static String TAG = "DebugService";

    public DebugService() {
        log("DebugService:");
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* JADX WARNING: Code restructure failed: missing block: B:16:0x003c, code lost:
        if (r0.equals("--metrics") == false) goto L_0x0013;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void dump(java.io.FileDescriptor r4, java.io.PrintWriter r5, java.lang.String[] r6) {
        /*
            r3 = this;
            if (r6 == 0) goto L_0x0061
            int r3 = r6.length
            if (r3 <= 0) goto L_0x0061
            r3 = 0
            r0 = r6[r3]
            r0.hashCode()
            r1 = -1
            int r2 = r0.hashCode()
            switch(r2) {
                case -1953159389: goto L_0x0036;
                case 513805138: goto L_0x002b;
                case 674382917: goto L_0x0020;
                case 950313125: goto L_0x0015;
                default: goto L_0x0013;
            }
        L_0x0013:
            r3 = r1
            goto L_0x003f
        L_0x0015:
            java.lang.String r3 = "--metricsproto"
            boolean r3 = r0.equals(r3)
            if (r3 != 0) goto L_0x001e
            goto L_0x0013
        L_0x001e:
            r3 = 3
            goto L_0x003f
        L_0x0020:
            java.lang.String r3 = "--saveatoms"
            boolean r3 = r0.equals(r3)
            if (r3 != 0) goto L_0x0029
            goto L_0x0013
        L_0x0029:
            r3 = 2
            goto L_0x003f
        L_0x002b:
            java.lang.String r3 = "--metricsprototext"
            boolean r3 = r0.equals(r3)
            if (r3 != 0) goto L_0x0034
            goto L_0x0013
        L_0x0034:
            r3 = 1
            goto L_0x003f
        L_0x0036:
            java.lang.String r2 = "--metrics"
            boolean r0 = r0.equals(r2)
            if (r0 != 0) goto L_0x003f
            goto L_0x0013
        L_0x003f:
            switch(r3) {
                case 0: goto L_0x0054;
                case 1: goto L_0x0054;
                case 2: goto L_0x0043;
                case 3: goto L_0x0054;
                default: goto L_0x0042;
            }
        L_0x0042:
            goto L_0x0061
        L_0x0043:
            java.lang.String r3 = "Saving atoms.."
            log(r3)
            com.android.internal.telephony.metrics.MetricsCollector r3 = com.android.internal.telephony.PhoneFactory.getMetricsCollector()
            com.android.internal.telephony.metrics.PersistAtomsStorage r3 = r3.getAtomsStorage()
            r3.flushAtoms()
            return
        L_0x0054:
            java.lang.String r3 = "Collecting telephony metrics.."
            log(r3)
            com.android.internal.telephony.metrics.TelephonyMetrics r3 = com.android.internal.telephony.metrics.TelephonyMetrics.getInstance()
            r3.dump(r4, r5, r6)
            return
        L_0x0061:
            java.lang.String r3 = "Dump telephony."
            log(r3)
            com.android.internal.telephony.PhoneFactory.dump(r4, r5, r6)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.DebugService.dump(java.io.FileDescriptor, java.io.PrintWriter, java.lang.String[]):void");
    }

    private static void log(String str) {
        String str2 = TAG;
        Rlog.d(str2, "DebugService " + str);
    }
}
