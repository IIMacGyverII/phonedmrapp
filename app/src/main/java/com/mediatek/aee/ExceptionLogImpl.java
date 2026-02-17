package com.mediatek.aee;

import android.os.Process;
import android.os.SystemProperties;
import android.util.Log;
import com.mediatek.dx.DexOptExtFactory;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ExceptionLogImpl extends ExceptionLog {
    public static final byte AEE_EXCEPTION_JNI = 1;
    public static final byte AEE_WARNING_JNI = 0;
    public static final String TAG = "AES";
    private static int[] mZygotePids;
    private final String FILE_OBSERVER_NULL_PATH = "Unhandled exception in FileObserver com.android.server.BootReceiver";
    private final String[] FalseAlarmCases = {"Process: system_server", "Subject: LazyAlarmStore", "TerribleFailure: Removed TIME_TICK alarm", "android.util.Log.wtf", "android.util.Slog.wtf", "com.android.server.alarm.LazyAlarmStore.remove", "=====case end=====", "Process: system_server", "Subject: ActivityManager", "TerribleFailure: Background started FGS", "=====case end====="};
    private final String SEND_NON_PROTECTED_BROADCAST = "Sending non-protected broadcast";
    private final String[] protectedBroadcastFilter = {"android.intent.action.CALL_EMERGENCY", "com.debug.loggerui.ADB_CMD", "com.mediatek.log2server.EXCEPTION_HAPPEND", "com.mediatek.omacp.capability.result", "com.mediatek.autounlock", "com.mtk.autotest.heartset.stop", "com.mtk.fts.ACTION", "com.android.systemui.demo", "ATG_MQTT_MqttService.pingSender", "AUTO_SUBMIT_STATUS"};

    private static native long SFMatter(long j, long j2);

    private static native void WDTMatter(long j);

    private static native boolean getNativeExceptionPidListImpl(int[] iArr);

    private static native void report(String str, String str2, String str3, String str4, String str5, long j);

    private static native void switchFtraceImpl(int i);

    private static native void systemreportImpl(byte b, String str, String str2, String str3, String str4);

    static {
        Log.i(TAG, "load Exception Log jni");
        System.loadLibrary("mediatek_exceptionlog");
    }

    public void handle(String str, String str2, String str3) {
        String str4 = str;
        String str5 = str2;
        Log.w(TAG, "Exception Log handling...");
        if (!str4.startsWith("data_app") || str5.contains("com.android.development") || SystemProperties.getInt("persist.vendor.mtk.aee.filter", 1) != 1) {
            long j = 0;
            String[] split = str5.split("\n+");
            Pattern compile = Pattern.compile("^Process:\\s+(.*)");
            Pattern compile2 = Pattern.compile("^Package:\\s+(.*)");
            String str6 = "";
            String str7 = str6;
            for (String str8 : split) {
                Matcher matcher = compile.matcher(str8);
                if (matcher.matches()) {
                    str6 = matcher.group(1);
                }
                Matcher matcher2 = compile2.matcher(str8);
                if (matcher2.matches()) {
                    str7 = str7 + matcher2.group(1) + "\n";
                }
            }
            if (!str3.equals("")) {
                j = Long.parseLong(str3);
            }
            long j2 = j;
            if (!str4.equals("system_server_wtf") || !isSkipSystemWtfReport(str5)) {
                report(str6, str7, str2, "Backtrace of all threads:\n\n", str, j2);
                return;
            }
            return;
        }
        Log.w(TAG, "Skipped - do not care third party apk");
    }

    public void systemreport(byte b, String str, String str2, String str3) {
        systemreportImpl(b, str, getThreadStackTrace(), str2, str3);
    }

    public boolean getNativeExceptionPidList(int[] iArr) {
        return getNativeExceptionPidListImpl(iArr);
    }

    public void switchFtrace(int i) {
        if (i == 3) {
            DexOptExtFactory.getInstance().makeDexOpExt().notifySpeedUp();
        }
        switchFtraceImpl(i);
    }

    public boolean isJavaProcess(int i) {
        if (i <= 0) {
            return false;
        }
        if (mZygotePids == null) {
            mZygotePids = Process.getPidsForCommands(new String[]{"zygote64", "zygote"});
        }
        if (mZygotePids != null) {
            int parentPid = Process.getParentPid(i);
            for (int i2 : mZygotePids) {
                if (parentPid == i2) {
                    return true;
                }
            }
        }
        Log.w(TAG, "pid: " + i + " is not a Java process");
        return false;
    }

    /* JADX WARNING: Removed duplicated region for block: B:46:0x00ed A[SYNTHETIC, Splitter:B:46:0x00ed] */
    /* JADX WARNING: Removed duplicated region for block: B:53:0x00f9 A[SYNTHETIC, Splitter:B:53:0x00f9] */
    /* JADX WARNING: Removed duplicated region for block: B:58:0x0104 A[SYNTHETIC, Splitter:B:58:0x0104] */
    /* JADX WARNING: Removed duplicated region for block: B:76:? A[RETURN, SYNTHETIC] */
    /* JADX WARNING: Removed duplicated region for block: B:77:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void readTransactionInfoFromFile(int r8, java.util.ArrayList<java.lang.Integer> r9) {
        /*
            r7 = this;
            java.lang.String r7 = "IOException when close buffer reader:"
            java.lang.String r0 = "AES"
            java.lang.String r1 = "outgoing transaction.+from.+to (\\d+):.+code.+"
            java.util.regex.Pattern r1 = java.util.regex.Pattern.compile(r1)
            r2 = 0
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r3.<init>()     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            java.lang.String r4 = "/sys/kernel/debug/binder/proc/"
            r3.append(r4)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            java.lang.String r4 = java.lang.Integer.toString(r8)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r3.append(r4)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            java.lang.String r3 = r3.toString()     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            java.io.File r4 = new java.io.File     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r4.<init>(r3)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            boolean r3 = r4.exists()     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            if (r3 != 0) goto L_0x0040
            java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r9.<init>()     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            java.lang.String r1 = "Filepath isn't exist: /d/binder/proc/"
            r9.append(r1)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r9.append(r8)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            java.lang.String r8 = r9.toString()     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            android.util.Log.w(r0, r8)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            return
        L_0x0040:
            android.util.ArrayMap r8 = new android.util.ArrayMap     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r8.<init>()     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            java.io.BufferedReader r3 = new java.io.BufferedReader     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            java.io.FileReader r5 = new java.io.FileReader     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r5.<init>(r4)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r3.<init>(r5)     // Catch:{ FileNotFoundException -> 0x00f1, IOException -> 0x00e5 }
            r2 = 0
            r4 = 1
        L_0x0051:
            java.lang.String r5 = r3.readLine()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            if (r5 == 0) goto L_0x00aa
            java.lang.String r5 = r5.trim()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            if (r2 != 0) goto L_0x0067
            java.lang.String r6 = "context binder"
            boolean r5 = r6.equals(r5)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            if (r5 == 0) goto L_0x0051
            r2 = r4
            goto L_0x0051
        L_0x0067:
            java.lang.String r6 = "outgoing transaction"
            boolean r6 = r5.contains(r6)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            if (r6 == 0) goto L_0x00a2
            java.util.regex.Matcher r5 = r1.matcher(r5)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            boolean r6 = r5.find()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            if (r6 == 0) goto L_0x0051
            java.lang.String r5 = r5.group(r4)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            java.lang.Integer r5 = java.lang.Integer.valueOf(r5)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            int r6 = r8.indexOfKey(r5)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            if (r6 < 0) goto L_0x009a
            java.lang.Object r5 = r8.valueAt(r6)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            java.lang.Integer r5 = (java.lang.Integer) r5     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            int r5 = r5.intValue()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            int r5 = r5 + r4
            java.lang.Integer r5 = java.lang.Integer.valueOf(r5)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            r8.setValueAt(r6, r5)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            goto L_0x0051
        L_0x009a:
            java.lang.Integer r6 = java.lang.Integer.valueOf(r4)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            r8.put(r5, r6)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            goto L_0x0051
        L_0x00a2:
            java.lang.String r6 = "node"
            boolean r5 = r5.startsWith(r6)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            if (r5 == 0) goto L_0x0051
        L_0x00aa:
            java.util.Set r8 = r8.entrySet()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            java.util.Iterator r8 = r8.iterator()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
        L_0x00b2:
            boolean r1 = r8.hasNext()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            if (r1 == 0) goto L_0x00d6
            java.lang.Object r1 = r8.next()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            java.util.Map$Entry r1 = (java.util.Map.Entry) r1     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            java.lang.Object r2 = r1.getValue()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            java.lang.Integer r2 = (java.lang.Integer) r2     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            int r2 = r2.intValue()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            r4 = 10
            if (r2 <= r4) goto L_0x00b2
            java.lang.Object r1 = r1.getKey()     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            java.lang.Integer r1 = (java.lang.Integer) r1     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            r9.add(r1)     // Catch:{ FileNotFoundException -> 0x00e0, IOException -> 0x00dd, all -> 0x00da }
            goto L_0x00b2
        L_0x00d6:
            r3.close()     // Catch:{ IOException -> 0x00fd }
            goto L_0x0101
        L_0x00da:
            r8 = move-exception
            r2 = r3
            goto L_0x0102
        L_0x00dd:
            r8 = move-exception
            r2 = r3
            goto L_0x00e6
        L_0x00e0:
            r8 = move-exception
            r2 = r3
            goto L_0x00f2
        L_0x00e3:
            r8 = move-exception
            goto L_0x0102
        L_0x00e5:
            r8 = move-exception
        L_0x00e6:
            java.lang.String r9 = "IOException when gettting Binder. "
            android.util.Log.e(r0, r9, r8)     // Catch:{ all -> 0x00e3 }
            if (r2 == 0) goto L_0x0101
            r2.close()     // Catch:{ IOException -> 0x00fd }
            goto L_0x0101
        L_0x00f1:
            r8 = move-exception
        L_0x00f2:
            java.lang.String r9 = "FileNotFoundException"
            android.util.Log.e(r0, r9, r8)     // Catch:{ all -> 0x00e3 }
            if (r2 == 0) goto L_0x0101
            r2.close()     // Catch:{ IOException -> 0x00fd }
            goto L_0x0101
        L_0x00fd:
            r8 = move-exception
            android.util.Log.e(r0, r7, r8)
        L_0x0101:
            return
        L_0x0102:
            if (r2 == 0) goto L_0x010c
            r2.close()     // Catch:{ IOException -> 0x0108 }
            goto L_0x010c
        L_0x0108:
            r9 = move-exception
            android.util.Log.e(r0, r7, r9)
        L_0x010c:
            throw r8
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.aee.ExceptionLogImpl.readTransactionInfoFromFile(int, java.util.ArrayList):void");
    }

    private static String getThreadStackTrace() {
        StringWriter stringWriter = new StringWriter();
        try {
            Thread currentThread = Thread.currentThread();
            StackTraceElement[] stackTrace = currentThread.getStackTrace();
            StringBuilder sb = new StringBuilder();
            sb.append("\"");
            sb.append(currentThread.getName());
            sb.append("\" ");
            sb.append(currentThread.isDaemon() ? "daemon" : "");
            sb.append(" prio=");
            sb.append(currentThread.getPriority());
            sb.append(" Thread id=");
            sb.append(currentThread.getId());
            sb.append(" ");
            sb.append(currentThread.getState());
            sb.append("\n");
            stringWriter.write(sb.toString());
            for (StackTraceElement stackTraceElement : stackTrace) {
                stringWriter.write("\t" + stackTraceElement + "\n");
            }
            stringWriter.write("\n");
            return stringWriter.toString();
        } catch (IOException unused) {
            return "IOException";
        } catch (OutOfMemoryError unused2) {
            return "java.lang.OutOfMemoryError";
        }
    }

    private static String getAllThreadStackTraces() {
        Map<Thread, StackTraceElement[]> allStackTraces = Thread.getAllStackTraces();
        StringWriter stringWriter = new StringWriter();
        try {
            for (Map.Entry next : allStackTraces.entrySet()) {
                StackTraceElement[] stackTraceElementArr = (StackTraceElement[]) next.getValue();
                Thread thread = (Thread) next.getKey();
                StringBuilder sb = new StringBuilder();
                sb.append("\"");
                sb.append(thread.getName());
                sb.append("\" ");
                sb.append(thread.isDaemon() ? "daemon" : "");
                sb.append(" prio=");
                sb.append(thread.getPriority());
                sb.append(" Thread id=");
                sb.append(thread.getId());
                sb.append(" ");
                sb.append(thread.getState());
                sb.append("\n");
                stringWriter.write(sb.toString());
                for (StackTraceElement stackTraceElement : stackTraceElementArr) {
                    stringWriter.write("\t" + stackTraceElement + "\n");
                }
                stringWriter.write("\n");
            }
            return stringWriter.toString();
        } catch (IOException unused) {
            return "IOException";
        } catch (OutOfMemoryError unused2) {
            return "java.lang.OutOfMemoryError";
        }
    }

    public void WDTMatterJava(long j) {
        WDTMatter(j);
    }

    public long SFMatterJava(long j, long j2) {
        return SFMatter(j, j2);
    }

    private boolean isSkipSystemWtfReport(String str) {
        if (!isSkipReportFromProtectedBroadcast(str) && !isSkipReportFromNullFilePath(str) && !isSkipFalseAlarmCases(str)) {
            return false;
        }
        return true;
    }

    private boolean isSkipReportFromProtectedBroadcast(String str) {
        if (str.contains("Sending non-protected broadcast")) {
            int i = 0;
            while (true) {
                String[] strArr = this.protectedBroadcastFilter;
                if (i >= strArr.length) {
                    break;
                } else if (str.contains(strArr[i])) {
                    return true;
                } else {
                    i++;
                }
            }
        }
        return false;
    }

    private boolean isSkipFalseAlarmCases(String str) {
        int i = 0;
        boolean z = true;
        while (true) {
            String[] strArr = this.FalseAlarmCases;
            if (i >= strArr.length) {
                return false;
            }
            if (!strArr[i].equals("=====case end=====")) {
                if (!str.contains(this.FalseAlarmCases[i])) {
                    z = false;
                }
            } else if (z) {
                return true;
            } else {
                z = true;
            }
            i++;
        }
    }

    private boolean isSkipReportFromNullFilePath(String str) {
        return str.contains("Unhandled exception in FileObserver com.android.server.BootReceiver");
    }
}
