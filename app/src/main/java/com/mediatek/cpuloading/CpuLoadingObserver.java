package com.mediatek.cpuloading;

import android.os.UEventObserver;

public class CpuLoadingObserver {
    private static final String BACKGROUND_CPUS_PATH = "/dev/cpuset/background/cpus";
    private static int DEFAULT_SPECIFY_THRESHOLD = 85;
    private static int DEFAULT_THRESHOLD = 85;
    private static int DEFAULT_WINDOW = 10;
    private static final String OVER_THRESHOLD = "/proc/cpu_loading/overThrhld";
    private static final String POLLING_ON_OFF = "/proc/cpu_loading/onoff";
    private static final String POLLING_TIME_SECOND = "/proc/cpu_loading/poltime_secs";
    private static final String SPECIFY_32BIT_CPUS_PATH = "sys/devices/system/cpu/aarch32_el0";
    private static final String SPECIFY_CPUS = "/proc/cpu_loading/specify_cpus";
    private static final String SPECIFY_OVER_THRESHOLD = "/proc/cpu_loading/specify_overThrhld";
    /* access modifiers changed from: private */
    public static int SPECIFY_RELEASE_TARGET = 15;
    private static final String TAG = "CpuLoadingObserver";
    private static final String UEVENT_PATH = "DEVPATH=/devices/virtual/misc/cpu_loading";
    /* access modifiers changed from: private */
    public Observer mObserver;
    private String mSpecifyCpus;
    private int mSpecifyThreshold;
    private int mThreshold;
    private MyUEventObserver mUEventObserver;
    private int mWindow;

    public interface Observer {
        void onHighCpuLoading(int i);
    }

    public CpuLoadingObserver() {
        this.mThreshold = DEFAULT_THRESHOLD;
        this.mWindow = DEFAULT_WINDOW;
        this.mSpecifyThreshold = DEFAULT_SPECIFY_THRESHOLD;
        this.mSpecifyCpus = "";
        this.mUEventObserver = new MyUEventObserver();
        this.mSpecifyCpus = readSpecifyCpus();
    }

    public void setObserver(Observer observer) {
        this.mObserver = observer;
    }

    public void startObserving() {
        writeFile(POLLING_ON_OFF, "1");
        writeFile(OVER_THRESHOLD, String.valueOf(this.mThreshold));
        writeFile(POLLING_TIME_SECOND, String.valueOf(this.mWindow));
        if (!this.mSpecifyCpus.equals("")) {
            writeFile(SPECIFY_CPUS, this.mSpecifyCpus);
            writeFile(SPECIFY_OVER_THRESHOLD, String.valueOf(this.mSpecifyThreshold));
        }
        this.mUEventObserver.startObserving(UEVENT_PATH);
    }

    private String readSpecifyCpus() {
        String readFile = readFile(SPECIFY_32BIT_CPUS_PATH);
        if (readFile.equals("")) {
            readFile = readFile(BACKGROUND_CPUS_PATH);
        }
        if (readFile.equals("")) {
            return "";
        }
        String[] split = readFile.split("-");
        if (split.length != 2) {
            return readFile;
        }
        return split[1].trim() + split[0].trim();
    }

    public void stopObserving() {
        writeFile(POLLING_ON_OFF, "0");
        this.mUEventObserver.stopObserving();
        this.mObserver = null;
    }

    /* JADX WARNING: Removed duplicated region for block: B:19:0x0033 A[SYNTHETIC, Splitter:B:19:0x0033] */
    /* JADX WARNING: Removed duplicated region for block: B:26:0x0041 A[SYNTHETIC, Splitter:B:26:0x0041] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void writeFile(java.lang.String r3, java.lang.String r4) {
        /*
            r2 = this;
            if (r3 != 0) goto L_0x0003
            return
        L_0x0003:
            java.io.File r2 = new java.io.File
            r2.<init>(r3)
            r3 = 0
            android.os.StrictMode$ThreadPolicy r0 = android.os.StrictMode.allowThreadDiskReads()
            android.os.StrictMode.allowThreadDiskWrites()
            java.io.FileOutputStream r1 = new java.io.FileOutputStream     // Catch:{ IOException -> 0x002d }
            r1.<init>(r2)     // Catch:{ IOException -> 0x002d }
            byte[] r2 = r4.getBytes()     // Catch:{ IOException -> 0x0028, all -> 0x0025 }
            r1.write(r2)     // Catch:{ IOException -> 0x0028, all -> 0x0025 }
            r1.flush()     // Catch:{ IOException -> 0x0028, all -> 0x0025 }
            r1.close()     // Catch:{ IOException -> 0x0023 }
            goto L_0x003b
        L_0x0023:
            r2 = move-exception
            goto L_0x0038
        L_0x0025:
            r2 = move-exception
            r3 = r1
            goto L_0x003f
        L_0x0028:
            r2 = move-exception
            r3 = r1
            goto L_0x002e
        L_0x002b:
            r2 = move-exception
            goto L_0x003f
        L_0x002d:
            r2 = move-exception
        L_0x002e:
            r2.printStackTrace()     // Catch:{ all -> 0x002b }
            if (r3 == 0) goto L_0x003b
            r3.close()     // Catch:{ IOException -> 0x0037 }
            goto L_0x003b
        L_0x0037:
            r2 = move-exception
        L_0x0038:
            r2.printStackTrace()
        L_0x003b:
            android.os.StrictMode.setThreadPolicy(r0)
            return
        L_0x003f:
            if (r3 == 0) goto L_0x0049
            r3.close()     // Catch:{ IOException -> 0x0045 }
            goto L_0x0049
        L_0x0045:
            r3 = move-exception
            r3.printStackTrace()
        L_0x0049:
            android.os.StrictMode.setThreadPolicy(r0)
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.cpuloading.CpuLoadingObserver.writeFile(java.lang.String, java.lang.String):void");
    }

    /* JADX WARNING: Removed duplicated region for block: B:24:0x0045 A[SYNTHETIC, Splitter:B:24:0x0045] */
    /* JADX WARNING: Removed duplicated region for block: B:32:0x0052 A[SYNTHETIC, Splitter:B:32:0x0052] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private java.lang.String readFile(java.lang.String r6) {
        /*
            r5 = this;
            java.lang.String r5 = ""
            if (r6 != 0) goto L_0x0005
            return r5
        L_0x0005:
            java.io.File r0 = new java.io.File
            r0.<init>(r6)
            r6 = 0
            java.io.FileInputStream r1 = new java.io.FileInputStream     // Catch:{ IOException -> 0x003d, all -> 0x003b }
            r1.<init>(r0)     // Catch:{ IOException -> 0x003d, all -> 0x003b }
            java.io.InputStreamReader r6 = new java.io.InputStreamReader     // Catch:{ IOException -> 0x0039 }
            java.lang.String r0 = "UTF-8"
            r6.<init>(r1, r0)     // Catch:{ IOException -> 0x0039 }
            java.io.StringWriter r0 = new java.io.StringWriter     // Catch:{ IOException -> 0x0039 }
            r0.<init>()     // Catch:{ IOException -> 0x0039 }
            r2 = 1024(0x400, float:1.435E-42)
            char[] r2 = new char[r2]     // Catch:{ IOException -> 0x0039 }
        L_0x0020:
            r3 = -1
            int r4 = r6.read(r2)     // Catch:{ IOException -> 0x0039 }
            if (r3 == r4) goto L_0x002c
            r3 = 0
            r0.write(r2, r3, r4)     // Catch:{ IOException -> 0x0039 }
            goto L_0x0020
        L_0x002c:
            java.lang.String r5 = r0.toString()     // Catch:{ IOException -> 0x0039 }
            r1.close()     // Catch:{ IOException -> 0x0034 }
            goto L_0x0038
        L_0x0034:
            r6 = move-exception
            r6.printStackTrace()
        L_0x0038:
            return r5
        L_0x0039:
            r6 = move-exception
            goto L_0x0040
        L_0x003b:
            r5 = move-exception
            goto L_0x0050
        L_0x003d:
            r0 = move-exception
            r1 = r6
            r6 = r0
        L_0x0040:
            r6.printStackTrace()     // Catch:{ all -> 0x004e }
            if (r1 == 0) goto L_0x004d
            r1.close()     // Catch:{ IOException -> 0x0049 }
            goto L_0x004d
        L_0x0049:
            r6 = move-exception
            r6.printStackTrace()
        L_0x004d:
            return r5
        L_0x004e:
            r5 = move-exception
            r6 = r1
        L_0x0050:
            if (r6 == 0) goto L_0x005a
            r6.close()     // Catch:{ IOException -> 0x0056 }
            goto L_0x005a
        L_0x0056:
            r6 = move-exception
            r6.printStackTrace()
        L_0x005a:
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.cpuloading.CpuLoadingObserver.readFile(java.lang.String):java.lang.String");
    }

    private class MyUEventObserver extends UEventObserver {
        private MyUEventObserver() {
        }

        public void onUEvent(UEventObserver.UEvent uEvent) {
            String str = uEvent.get("over");
            String str2 = uEvent.get("specify_over");
            if (str != null && str.equals("1")) {
                CpuLoadingObserver.this.mObserver.onHighCpuLoading(-1);
            } else if (str2 != null && str2.equals("1")) {
                CpuLoadingObserver.this.mObserver.onHighCpuLoading(CpuLoadingObserver.SPECIFY_RELEASE_TARGET);
            }
        }
    }
}
