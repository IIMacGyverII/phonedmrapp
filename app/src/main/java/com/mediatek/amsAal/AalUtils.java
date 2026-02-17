package com.mediatek.amsAal;

import android.content.ComponentName;
import android.os.SystemProperties;
import android.util.Slog;
import android.util.Xml;
import com.android.internal.telephony.util.ConnectivitySettingsUtils;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

public final class AalUtils {
    private static final int AAL_DEFAULT_LEVEL = 128;
    private static final int AAL_MAX_LEVEL = 256;
    private static final int AAL_MIN_LEVEL = 0;
    public static final int AAL_MODE_BALANCE = 1;
    public static final int AAL_MODE_LOWPOWER = 2;
    public static final int AAL_MODE_PERFORMANCE = 0;
    public static final int AAL_MODE_SIZE = 3;
    private static final int AAL_NULL_LEVEL = -1;
    private static final String TAG = "AalUtils";
    private static String sAalConfigXMLPath = "/system/etc/ams_aal_config.xml";
    private static boolean sDebug = false;
    private static boolean sEnabled;
    private static AalUtils sInstance = null;
    private static boolean sIsAalSupported;
    private int mAalMode = 1;
    private Map<AalIndex, Integer> mConfig = new HashMap();
    private AalConfig mCurrentConfig = null;

    private native void setSmartBacklightStrength(int i);

    static {
        boolean equals = SystemProperties.get("ro.vendor.mtk_aal_support").equals("1");
        sIsAalSupported = equals;
        sEnabled = equals && SystemProperties.get("persist.vendor.sys.mtk_app_aal_support").equals("1");
    }

    AalUtils() {
        if (sIsAalSupported) {
            try {
                parseXML();
            } catch (XmlPullParserException e) {
                Slog.d(TAG, "XmlPullParserException fail to parseXML, " + e);
            } catch (IOException e2) {
                Slog.d(TAG, "IOException fail to parseXML, " + e2);
            } catch (Exception e3) {
                Slog.d(TAG, "fail to parseXML, " + e3);
            }
        } else if (sDebug) {
            Slog.d(TAG, "AAL is not supported");
        }
    }

    public static boolean isSupported() {
        if (sDebug) {
            Slog.d(TAG, "isSupported = " + sIsAalSupported);
        }
        return sIsAalSupported;
    }

    public static AalUtils getInstance() {
        if (sInstance == null) {
            sInstance = new AalUtils();
        }
        return sInstance;
    }

    public void setAalMode(int i) {
        if (sIsAalSupported) {
            setAalModeInternal(i);
        } else if (sDebug) {
            Slog.d(TAG, "AAL is not supported");
        }
    }

    public void setEnabled(boolean z) {
        if (sIsAalSupported) {
            setEnabledInternal(z);
        } else if (sDebug) {
            Slog.d(TAG, "AAL is not supported");
        }
    }

    /* access modifiers changed from: package-private */
    /* JADX WARNING: Code restructure failed: missing block: B:19:0x005c, code lost:
        return r3;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:8:0x0011, code lost:
        return "AAL is not enabled";
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized java.lang.String setAalModeInternal(int r3) {
        /*
            r2 = this;
            monitor-enter(r2)
            boolean r0 = sEnabled     // Catch:{ all -> 0x005d }
            if (r0 != 0) goto L_0x0012
            java.lang.String r3 = "AAL is not enabled"
            boolean r0 = sDebug     // Catch:{ all -> 0x005d }
            if (r0 == 0) goto L_0x0010
            java.lang.String r0 = "AalUtils"
            android.util.Slog.d(r0, r3)     // Catch:{ all -> 0x005d }
        L_0x0010:
            monitor-exit(r2)
            return r3
        L_0x0012:
            if (r3 < 0) goto L_0x0040
            r0 = 3
            if (r3 >= r0) goto L_0x0040
            r2.mAalMode = r3     // Catch:{ all -> 0x005d }
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x005d }
            r3.<init>()     // Catch:{ all -> 0x005d }
            java.lang.String r0 = "setAalModeInternal "
            r3.append(r0)     // Catch:{ all -> 0x005d }
            int r0 = r2.mAalMode     // Catch:{ all -> 0x005d }
            r3.append(r0)     // Catch:{ all -> 0x005d }
            java.lang.String r0 = "("
            r3.append(r0)     // Catch:{ all -> 0x005d }
            int r0 = r2.mAalMode     // Catch:{ all -> 0x005d }
            java.lang.String r0 = r2.modeToString(r0)     // Catch:{ all -> 0x005d }
            r3.append(r0)     // Catch:{ all -> 0x005d }
            java.lang.String r0 = ")"
            r3.append(r0)     // Catch:{ all -> 0x005d }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x005d }
            goto L_0x0052
        L_0x0040:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x005d }
            r0.<init>()     // Catch:{ all -> 0x005d }
            java.lang.String r1 = "unknown mode "
            r0.append(r1)     // Catch:{ all -> 0x005d }
            r0.append(r3)     // Catch:{ all -> 0x005d }
            java.lang.String r3 = r0.toString()     // Catch:{ all -> 0x005d }
        L_0x0052:
            boolean r0 = sDebug     // Catch:{ all -> 0x005d }
            if (r0 == 0) goto L_0x005b
            java.lang.String r0 = "AalUtils"
            android.util.Slog.d(r0, r3)     // Catch:{ all -> 0x005d }
        L_0x005b:
            monitor-exit(r2)
            return r3
        L_0x005d:
            r3 = move-exception
            monitor-exit(r2)
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.amsAal.AalUtils.setAalModeInternal(int):java.lang.String");
    }

    public synchronized void setEnabledInternal(boolean z) {
        sEnabled = z;
        if (!z) {
            setDefaultSmartBacklightInternal("disabled");
            SystemProperties.set("persist.vendor.sys.mtk_app_aal_support", "0");
        } else {
            SystemProperties.set("persist.vendor.sys.mtk_app_aal_support", "1");
        }
        if (sDebug) {
            Slog.d(TAG, "setEnabledInternal(" + sEnabled + ")");
        }
    }

    public synchronized void setSmartBacklightInternal(ComponentName componentName) {
        setSmartBacklightInternal(componentName, this.mAalMode);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:31:0x00b5, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:37:0x00d1, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:8:0x0011, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void setSmartBacklightInternal(android.content.ComponentName r6, int r7) {
        /*
            r5 = this;
            monitor-enter(r5)
            boolean r0 = sEnabled     // Catch:{ all -> 0x00d2 }
            if (r0 != 0) goto L_0x0012
            boolean r6 = sDebug     // Catch:{ all -> 0x00d2 }
            if (r6 == 0) goto L_0x0010
            java.lang.String r6 = "AalUtils"
            java.lang.String r7 = "AAL is not enabled"
            android.util.Slog.d(r6, r7)     // Catch:{ all -> 0x00d2 }
        L_0x0010:
            monitor-exit(r5)
            return
        L_0x0012:
            if (r7 < 0) goto L_0x00b6
            r0 = 3
            if (r7 < r0) goto L_0x0019
            goto L_0x00b6
        L_0x0019:
            com.mediatek.amsAal.AalUtils$AalConfig r0 = r5.mCurrentConfig     // Catch:{ all -> 0x00d2 }
            r1 = 128(0x80, float:1.794E-43)
            if (r0 != 0) goto L_0x0032
            boolean r0 = sDebug     // Catch:{ all -> 0x00d2 }
            if (r0 == 0) goto L_0x002a
            java.lang.String r0 = "AalUtils"
            java.lang.String r2 = "mCurrentConfig == null"
            android.util.Slog.d(r0, r2)     // Catch:{ all -> 0x00d2 }
        L_0x002a:
            com.mediatek.amsAal.AalUtils$AalConfig r0 = new com.mediatek.amsAal.AalUtils$AalConfig     // Catch:{ all -> 0x00d2 }
            r2 = 0
            r0.<init>(r2, r1)     // Catch:{ all -> 0x00d2 }
            r5.mCurrentConfig = r0     // Catch:{ all -> 0x00d2 }
        L_0x0032:
            com.mediatek.amsAal.AalUtils$AalIndex r0 = new com.mediatek.amsAal.AalUtils$AalIndex     // Catch:{ all -> 0x00d2 }
            java.lang.String r2 = r6.flattenToShortString()     // Catch:{ all -> 0x00d2 }
            r0.<init>(r7, r2)     // Catch:{ all -> 0x00d2 }
            com.mediatek.amsAal.AalUtils$AalConfig r2 = r5.getAalConfig(r0)     // Catch:{ all -> 0x00d2 }
            int r3 = r2.mLevel     // Catch:{ all -> 0x00d2 }
            r4 = -1
            if (r4 != r3) goto L_0x0057
            com.mediatek.amsAal.AalUtils$AalIndex r0 = new com.mediatek.amsAal.AalUtils$AalIndex     // Catch:{ all -> 0x00d2 }
            java.lang.String r6 = r6.getPackageName()     // Catch:{ all -> 0x00d2 }
            r0.<init>(r7, r6)     // Catch:{ all -> 0x00d2 }
            com.mediatek.amsAal.AalUtils$AalConfig r2 = r5.getAalConfig(r0)     // Catch:{ all -> 0x00d2 }
            int r6 = r2.mLevel     // Catch:{ all -> 0x00d2 }
            if (r4 != r6) goto L_0x0057
            r2.mLevel = r1     // Catch:{ all -> 0x00d2 }
        L_0x0057:
            int r6 = r2.mLevel     // Catch:{ all -> 0x00d2 }
            int r6 = r5.ensureBacklightLevel(r6)     // Catch:{ all -> 0x00d2 }
            boolean r7 = sDebug     // Catch:{ all -> 0x00d2 }
            if (r7 == 0) goto L_0x0083
            java.lang.String r7 = "AalUtils"
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d2 }
            r1.<init>()     // Catch:{ all -> 0x00d2 }
            java.lang.String r2 = "setSmartBacklight current level: "
            r1.append(r2)     // Catch:{ all -> 0x00d2 }
            com.mediatek.amsAal.AalUtils$AalConfig r2 = r5.mCurrentConfig     // Catch:{ all -> 0x00d2 }
            int r2 = r2.mLevel     // Catch:{ all -> 0x00d2 }
            r1.append(r2)     // Catch:{ all -> 0x00d2 }
            java.lang.String r2 = " for "
            r1.append(r2)     // Catch:{ all -> 0x00d2 }
            r1.append(r0)     // Catch:{ all -> 0x00d2 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x00d2 }
            android.util.Slog.d(r7, r1)     // Catch:{ all -> 0x00d2 }
        L_0x0083:
            com.mediatek.amsAal.AalUtils$AalConfig r7 = r5.mCurrentConfig     // Catch:{ all -> 0x00d2 }
            int r7 = r7.mLevel     // Catch:{ all -> 0x00d2 }
            if (r7 == r6) goto L_0x00b4
            java.lang.String r7 = "AalUtils"
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d2 }
            r1.<init>()     // Catch:{ all -> 0x00d2 }
            java.lang.String r2 = "setSmartBacklightStrength("
            r1.append(r2)     // Catch:{ all -> 0x00d2 }
            r1.append(r6)     // Catch:{ all -> 0x00d2 }
            java.lang.String r2 = ") for "
            r1.append(r2)     // Catch:{ all -> 0x00d2 }
            r1.append(r0)     // Catch:{ all -> 0x00d2 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x00d2 }
            android.util.Slog.d(r7, r1)     // Catch:{ all -> 0x00d2 }
            com.mediatek.amsAal.AalUtils$AalConfig r7 = r5.mCurrentConfig     // Catch:{ all -> 0x00d2 }
            r7.mLevel = r6     // Catch:{ all -> 0x00d2 }
            java.lang.String r0 = r0.getIndexName()     // Catch:{ all -> 0x00d2 }
            r7.mName = r0     // Catch:{ all -> 0x00d2 }
            r5.setSmartBacklightStrength(r6)     // Catch:{ all -> 0x00d2 }
        L_0x00b4:
            monitor-exit(r5)
            return
        L_0x00b6:
            boolean r6 = sDebug     // Catch:{ all -> 0x00d2 }
            if (r6 == 0) goto L_0x00d0
            java.lang.String r6 = "AalUtils"
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d2 }
            r0.<init>()     // Catch:{ all -> 0x00d2 }
            java.lang.String r1 = "Unknown mode: "
            r0.append(r1)     // Catch:{ all -> 0x00d2 }
            r0.append(r7)     // Catch:{ all -> 0x00d2 }
            java.lang.String r7 = r0.toString()     // Catch:{ all -> 0x00d2 }
            android.util.Slog.d(r6, r7)     // Catch:{ all -> 0x00d2 }
        L_0x00d0:
            monitor-exit(r5)
            return
        L_0x00d2:
            r6 = move-exception
            monitor-exit(r5)
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.amsAal.AalUtils.setSmartBacklightInternal(android.content.ComponentName, int):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:16:0x003d, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:8:0x0011, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void setDefaultSmartBacklightInternal(java.lang.String r5) {
        /*
            r4 = this;
            monitor-enter(r4)
            boolean r0 = sEnabled     // Catch:{ all -> 0x003e }
            if (r0 != 0) goto L_0x0012
            boolean r5 = sDebug     // Catch:{ all -> 0x003e }
            if (r5 == 0) goto L_0x0010
            java.lang.String r5 = "AalUtils"
            java.lang.String r0 = "AAL is not enabled"
            android.util.Slog.d(r5, r0)     // Catch:{ all -> 0x003e }
        L_0x0010:
            monitor-exit(r4)
            return
        L_0x0012:
            com.mediatek.amsAal.AalUtils$AalConfig r0 = r4.mCurrentConfig     // Catch:{ all -> 0x003e }
            if (r0 == 0) goto L_0x003c
            int r0 = r0.mLevel     // Catch:{ all -> 0x003e }
            r1 = 128(0x80, float:1.794E-43)
            if (r0 == r1) goto L_0x003c
            java.lang.String r0 = "AalUtils"
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x003e }
            r2.<init>()     // Catch:{ all -> 0x003e }
            java.lang.String r3 = "setSmartBacklightStrength(128) "
            r2.append(r3)     // Catch:{ all -> 0x003e }
            r2.append(r5)     // Catch:{ all -> 0x003e }
            java.lang.String r5 = r2.toString()     // Catch:{ all -> 0x003e }
            android.util.Slog.d(r0, r5)     // Catch:{ all -> 0x003e }
            com.mediatek.amsAal.AalUtils$AalConfig r5 = r4.mCurrentConfig     // Catch:{ all -> 0x003e }
            r5.mLevel = r1     // Catch:{ all -> 0x003e }
            r0 = 0
            r5.mName = r0     // Catch:{ all -> 0x003e }
            r4.setSmartBacklightStrength(r1)     // Catch:{ all -> 0x003e }
        L_0x003c:
            monitor-exit(r4)
            return
        L_0x003e:
            r5 = move-exception
            monitor-exit(r4)
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.amsAal.AalUtils.setDefaultSmartBacklightInternal(java.lang.String):void");
    }

    public void onAfterActivityResumed(String str, String str2) {
        setSmartBacklightInternal(new ComponentName(str, str2));
    }

    public void onUpdateSleep(boolean z, boolean z2) {
        if (sDebug) {
            Slog.d(TAG, "onUpdateSleep before=" + z + " after=" + z2);
        }
        if (z != z2 && z2) {
            setDefaultSmartBacklightInternal("for sleep");
        }
    }

    private int ensureBacklightLevel(int i) {
        if (i < 0) {
            if (!sDebug) {
                return 0;
            }
            Slog.e(TAG, "Invalid AAL backlight level: " + i);
            return 0;
        } else if (i <= 256) {
            return i;
        } else {
            if (sDebug) {
                Slog.e(TAG, "Invalid AAL backlight level: " + i);
            }
            return 256;
        }
    }

    private AalConfig getAalConfig(AalIndex aalIndex) {
        int i;
        if (this.mConfig.containsKey(aalIndex)) {
            i = this.mConfig.get(aalIndex).intValue();
        } else {
            if (sDebug) {
                Slog.d(TAG, "No config for " + aalIndex);
            }
            i = -1;
        }
        return new AalConfig(aalIndex.getIndexName(), i);
    }

    /* access modifiers changed from: private */
    public String modeToString(int i) {
        if (i == 0) {
            return "AAL_MODE_PERFORMANCE";
        }
        if (i == 1) {
            return "AAL_MODE_BALANCE";
        }
        if (i == 2) {
            return "AAL_MODE_LOWPOWER";
        }
        return "Unknown mode: " + i;
    }

    private class AalConfig {
        public int mLevel;
        public String mName;

        public AalConfig(String str, int i) {
            this.mName = str;
            this.mLevel = i;
        }
    }

    private class AalIndex {
        private int mMode;
        private String mName;

        AalIndex(int i, String str) {
            set(i, str);
        }

        private void set(int i, String str) {
            this.mMode = i;
            this.mName = str;
        }

        public int getMode() {
            return this.mMode;
        }

        public String getIndexName() {
            return this.mName;
        }

        public String toString() {
            return "(" + this.mMode + ": " + AalUtils.this.modeToString(this.mMode) + ", " + this.mName + ")";
        }

        public boolean equals(Object obj) {
            String str;
            if (obj == null) {
                return false;
            }
            if (obj == this) {
                return true;
            }
            if (!(obj instanceof AalIndex)) {
                return false;
            }
            AalIndex aalIndex = (AalIndex) obj;
            String str2 = this.mName;
            if (str2 == null && aalIndex.mName == null) {
                if (this.mMode == aalIndex.mMode) {
                    return true;
                }
                return false;
            } else if (str2 == null || (str = aalIndex.mName) == null || this.mMode != aalIndex.mMode || !str2.equals(str)) {
                return false;
            } else {
                return true;
            }
        }

        public int hashCode() {
            String str = Integer.toString(this.mMode) + ":";
            if (this.mName != null) {
                str = str + Integer.toString(this.mName.hashCode());
            }
            return str.hashCode();
        }
    }

    public int dump(PrintWriter printWriter, String[] strArr, int i) {
        if (!sIsAalSupported) {
            printWriter.println("Not support App-based AAL");
            return i;
        } else if (strArr.length <= 1) {
            printWriter.println(dumpDebugUsageInternal());
            return i;
        } else {
            String str = strArr[i];
            if ("dump".equals(str) && strArr.length == 2) {
                printWriter.println(dumpInternal());
                return i;
            } else if ("debugon".equals(str) && strArr.length == 2) {
                printWriter.println(setDebugInternal(true));
                printWriter.println("App-based AAL debug on");
                return i;
            } else if ("debugoff".equals(str) && strArr.length == 2) {
                printWriter.println(setDebugInternal(false));
                printWriter.println("App-based AAL debug off");
                return i;
            } else if ("on".equals(str) && strArr.length == 2) {
                setEnabledInternal(true);
                printWriter.println("App-based AAL on");
                return i;
            } else if (ConnectivitySettingsUtils.PRIVATE_DNS_MODE_OFF_STRING.equals(str) && strArr.length == 2) {
                setEnabledInternal(false);
                printWriter.println("App-based AAL off");
                return i;
            } else if ("mode".equals(str) && strArr.length == 3) {
                int i2 = i + 1;
                printWriter.println(setAalModeInternal(Integer.parseInt(strArr[i2])));
                printWriter.println("Done");
                return i2;
            } else if (!"set".equals(str) || !(strArr.length == 4 || strArr.length == 5)) {
                printWriter.println(dumpDebugUsageInternal());
                return i;
            } else {
                int i3 = i + 1;
                String str2 = strArr[i3];
                int i4 = i3 + 1;
                int parseInt = Integer.parseInt(strArr[i4]);
                if (strArr.length == 4) {
                    printWriter.println(setSmartBacklightTableInternal(str2, parseInt));
                } else {
                    i4++;
                    printWriter.println(setSmartBacklightTableInternal(str2, parseInt, Integer.parseInt(strArr[i4])));
                }
                printWriter.println("Done");
                return i4;
            }
        }
    }

    private String dumpDebugUsageInternal() {
        return "\nUsage:\n" + "1. App-based AAL help:\n" + "    adb shell dumpsys activity aal\n" + "2. Dump App-based AAL settings:\n" + "    adb shell dumpsys activity aal dump\n" + "1. App-based AAL debug on:\n" + "    adb shell dumpsys activity aal debugon\n" + "1. App-based AAL debug off:\n" + "    adb shell dumpsys activity aal debugoff\n" + "3. Enable App-based AAL:\n" + "    adb shell dumpsys activity aal on\n" + "4. Disable App-based AAL:\n" + "    adb shell dumpsys activity aal off\n" + "5. Set App-based AAL mode:\n" + "    adb shell dumpsys activity aal mode <mode>\n" + "6. Set App-based AAL config for current mode:\n" + "    adb shell dumpsys activity aal set <component> <value>\n" + "7. Set App-based AAL config for the mode:\n" + "    adb shell dumpsys activity aal set <component> <value> <mode>\n";
    }

    private synchronized String dumpInternal() {
        StringBuilder sb;
        sb = new StringBuilder();
        sb.append("\nApp-based AAL Mode: " + this.mAalMode + "(" + modeToString(this.mAalMode) + "), Supported: " + sIsAalSupported + ", Enabled: " + sEnabled + ", Debug: " + sDebug + "\n");
        int i = 1;
        for (AalIndex next : this.mConfig.keySet()) {
            String num = Integer.toString(this.mConfig.get(next).intValue());
            sb.append("\n" + i + ". " + next + " - " + num);
            i++;
        }
        if (i == 1) {
            sb.append("\nThere is no App-based AAL configuration.\n");
            sb.append(dumpDebugUsageInternal());
        }
        if (sDebug) {
            Slog.d(TAG, "dump config: " + sb.toString());
        }
        return sb.toString();
    }

    private synchronized String setDebugInternal(boolean z) {
        sDebug = z;
        return "Set Debug: " + z;
    }

    private synchronized String setSmartBacklightTableInternal(String str, int i) {
        return setSmartBacklightTableInternal(str, i, this.mAalMode);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:24:0x007e, code lost:
        return r3;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:8:0x0011, code lost:
        return "AAL is not enabled";
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private synchronized java.lang.String setSmartBacklightTableInternal(java.lang.String r3, int r4, int r5) {
        /*
            r2 = this;
            monitor-enter(r2)
            boolean r0 = sEnabled     // Catch:{ all -> 0x007f }
            if (r0 != 0) goto L_0x0012
            java.lang.String r3 = "AAL is not enabled"
            boolean r4 = sDebug     // Catch:{ all -> 0x007f }
            if (r4 == 0) goto L_0x0010
            java.lang.String r4 = "AalUtils"
            android.util.Slog.d(r4, r3)     // Catch:{ all -> 0x007f }
        L_0x0010:
            monitor-exit(r2)
            return r3
        L_0x0012:
            if (r5 < 0) goto L_0x0063
            r0 = 3
            if (r5 < r0) goto L_0x0018
            goto L_0x0063
        L_0x0018:
            com.mediatek.amsAal.AalUtils$AalIndex r0 = new com.mediatek.amsAal.AalUtils$AalIndex     // Catch:{ all -> 0x007f }
            r0.<init>(r5, r3)     // Catch:{ all -> 0x007f }
            boolean r3 = sDebug     // Catch:{ all -> 0x007f }
            if (r3 == 0) goto L_0x003f
            java.lang.String r3 = "AalUtils"
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x007f }
            r5.<init>()     // Catch:{ all -> 0x007f }
            java.lang.String r1 = "setSmartBacklightTable("
            r5.append(r1)     // Catch:{ all -> 0x007f }
            r5.append(r4)     // Catch:{ all -> 0x007f }
            java.lang.String r1 = ") for "
            r5.append(r1)     // Catch:{ all -> 0x007f }
            r5.append(r0)     // Catch:{ all -> 0x007f }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x007f }
            android.util.Slog.d(r3, r5)     // Catch:{ all -> 0x007f }
        L_0x003f:
            java.util.Map<com.mediatek.amsAal.AalUtils$AalIndex, java.lang.Integer> r3 = r2.mConfig     // Catch:{ all -> 0x007f }
            java.lang.Integer r5 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x007f }
            r3.put(r0, r5)     // Catch:{ all -> 0x007f }
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x007f }
            r3.<init>()     // Catch:{ all -> 0x007f }
            java.lang.String r5 = "Set("
            r3.append(r5)     // Catch:{ all -> 0x007f }
            r3.append(r4)     // Catch:{ all -> 0x007f }
            java.lang.String r4 = ") for "
            r3.append(r4)     // Catch:{ all -> 0x007f }
            r3.append(r0)     // Catch:{ all -> 0x007f }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x007f }
            monitor-exit(r2)
            return r3
        L_0x0063:
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x007f }
            r3.<init>()     // Catch:{ all -> 0x007f }
            java.lang.String r4 = "Unknown mode: "
            r3.append(r4)     // Catch:{ all -> 0x007f }
            r3.append(r5)     // Catch:{ all -> 0x007f }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x007f }
            boolean r4 = sDebug     // Catch:{ all -> 0x007f }
            if (r4 == 0) goto L_0x007d
            java.lang.String r4 = "AalUtils"
            android.util.Slog.d(r4, r3)     // Catch:{ all -> 0x007f }
        L_0x007d:
            monitor-exit(r2)
            return r3
        L_0x007f:
            r3 = move-exception
            monitor-exit(r2)
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.amsAal.AalUtils.setSmartBacklightTableInternal(java.lang.String, int, int):java.lang.String");
    }

    private void parseXML() throws XmlPullParserException, IOException {
        if (new File(sAalConfigXMLPath).exists()) {
            FileReader fileReader = new FileReader(sAalConfigXMLPath);
            XmlPullParser newPullParser = Xml.newPullParser();
            newPullParser.setInput(fileReader);
            for (int eventType = newPullParser.getEventType(); eventType != 1; eventType = newPullParser.next()) {
                if (eventType == 2 && newPullParser.getName().equals("config")) {
                    this.mConfig.put(new AalIndex(Integer.parseInt(newPullParser.getAttributeValue(0)), newPullParser.getAttributeValue(1)), Integer.valueOf(Integer.parseInt(newPullParser.getAttributeValue(2))));
                }
            }
            fileReader.close();
        } else if (sDebug) {
            Slog.d(TAG, "parseXML file not exists: " + sAalConfigXMLPath);
        }
    }
}
