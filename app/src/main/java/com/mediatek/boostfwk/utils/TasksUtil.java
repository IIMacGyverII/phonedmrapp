package com.mediatek.boostfwk.utils;

import android.content.Context;
import android.os.Process;
import android.os.StrictMode;
import android.view.WindowManager;
import java.io.File;

public final class TasksUtil {
    private static final String[] BINK_WEBVIEW_PROCESS = {"gpu_process", "leged_process_"};
    public static final String BLINK_WEBVIEW_RENDER_NAME = "CrGpuMain";
    private static final int[] CMDLINE_OUT = {4096};
    public static final String[] FLUTTER_RENDER_TASK = {"JNISurfaceTextu", "1.raster"};
    private static final String[] GAME_TASKS = {"UnityMain", "MainThread-UE4"};
    private static final String[] GL_TASKS = {"GLThread", "GNaviMap-GL", "Tmcom-MapRender"};
    private static final int STRICT_MODE_DETECT_THREAD_DISK_READ = 2;
    private static final String TAG = "TasksUtil";
    public static final String WEB_RENDER_NAME = "Chrome_InProcGp";
    private static final String sAppBrandUI = "appbrand";
    private static final String sFlutterEngineName = "flutter_engine";
    private static final String sRenderThreadName = "RenderThread";
    private static final String[] sSpecialTaskList = {WEB_RENDER_NAME, "Chrome_IOThread", "hippy.js"};

    private TasksUtil() {
    }

    /* JADX WARNING: Code restructure failed: missing block: B:14:0x007d, code lost:
        r4 = -1;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static int findRenderTheadTid(int r7) {
        /*
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "/proc/"
            r0.append(r1)
            r0.append(r7)
            java.lang.String r2 = "/task"
            r0.append(r2)
            java.lang.String r0 = r0.toString()
            r2 = 1024(0x400, float:1.435E-42)
            int[] r2 = new int[r2]
            int[] r0 = android.os.Process.getPids(r0, r2)
            int r2 = r0.length
            r3 = 0
        L_0x0020:
            if (r3 >= r2) goto L_0x007d
            r4 = r0[r3]
            if (r4 >= 0) goto L_0x0027
            goto L_0x007d
        L_0x0027:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            r5.append(r1)
            r5.append(r7)
            java.lang.String r6 = "/task/"
            r5.append(r6)
            r5.append(r4)
            java.lang.String r6 = "/comm"
            r5.append(r6)
            java.lang.String r5 = r5.toString()
            java.lang.String r5 = readCmdlineFromProcfs(r5)
            if (r5 == 0) goto L_0x007a
            java.lang.String r6 = ""
            boolean r6 = r5.equals(r6)
            if (r6 != 0) goto L_0x007a
            java.lang.String r5 = r5.trim()
            java.lang.String r6 = "RenderThread"
            boolean r5 = r5.equals(r6)
            if (r5 == 0) goto L_0x007a
            boolean r0 = com.mediatek.boostfwk.utils.Config.isBoostFwkLogEnable()
            if (r0 == 0) goto L_0x007e
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "renderthread tid = "
            r0.append(r1)
            r0.append(r4)
            java.lang.String r0 = r0.toString()
            java.lang.String r1 = "TasksUtil"
            com.mediatek.boostfwk.utils.LogUtil.mLogd(r1, r0)
            goto L_0x007e
        L_0x007a:
            int r3 = r3 + 1
            goto L_0x0020
        L_0x007d:
            r4 = -1
        L_0x007e:
            boolean r0 = com.mediatek.boostfwk.utils.Config.isBoostFwkLogEnable()
            if (r0 == 0) goto L_0x00a2
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "pid = "
            r0.append(r1)
            r0.append(r7)
            java.lang.String r7 = "render thread id = "
            r0.append(r7)
            r0.append(r4)
            java.lang.String r7 = r0.toString()
            java.lang.String r0 = "ScrollIdentify"
            com.mediatek.boostfwk.utils.LogUtil.mLogd(r0, r7)
        L_0x00a2:
            return r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.boostfwk.utils.TasksUtil.findRenderTheadTid(int):int");
    }

    public static int findFlutterRenderTidForPid() {
        int myPid = Process.myPid();
        int[] pids = Process.getPids("/proc/" + myPid + "/task", new int[1024]);
        int length = pids.length;
        int i = -1;
        for (int i2 = 0; i2 < length; i2++) {
            int i3 = pids[i2];
            if (i3 < 0) {
                break;
            }
            String readCmdlineFromProcfs = readCmdlineFromProcfs("/proc/" + myPid + "/task/" + i3 + "/comm");
            if (readCmdlineFromProcfs != null && !readCmdlineFromProcfs.equals("")) {
                String trim = readCmdlineFromProcfs.trim();
                String[] strArr = FLUTTER_RENDER_TASK;
                int length2 = strArr.length;
                int i4 = 0;
                while (true) {
                    if (i4 >= length2) {
                        break;
                    } else if (trim.equals(strArr[i4])) {
                        if (LogUtil.DEBUG) {
                            LogUtil.mLogd(TAG, "findFlutterRenderTidForPid tid = " + i3);
                        }
                        i = i3;
                    } else {
                        i4++;
                    }
                }
            }
            if (i > 0) {
                break;
            }
        }
        return i;
    }

    public static int findGPUProcessPid() {
        int[] pids = Process.getPids("/proc/", new int[1024]);
        for (int i : pids) {
            if (i >= 0) {
                String readCmdlineFromProcfs = readCmdlineFromProcfs("/proc/" + i + "/comm");
                if (readCmdlineFromProcfs != null && !readCmdlineFromProcfs.equals("")) {
                    String lowerCase = readCmdlineFromProcfs.trim().toLowerCase();
                    for (String contains : BINK_WEBVIEW_PROCESS) {
                        if (lowerCase.contains(contains)) {
                            if (LogUtil.DEBUG) {
                                LogUtil.mLogd(TAG, "findGPUProcessPid pid=" + i);
                            }
                            return i;
                        }
                    }
                    continue;
                }
            }
        }
        return -1;
    }

    private static String readCmdlineFromProcfs(String str) {
        String[] strArr = new String[1];
        return !Process.readProcFile(str, CMDLINE_OUT, strArr, (long[]) null, (float[]) null) ? "" : strArr[0];
    }

    public static boolean isAppBrand() {
        int myPid = Process.myPid();
        String readCmdlineFromProcfs = readCmdlineFromProcfs("/proc/" + myPid + "/comm");
        if (readCmdlineFromProcfs == null || !readCmdlineFromProcfs.contains(sAppBrandUI)) {
            return false;
        }
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "This is app brand.");
        }
        return true;
    }

    public static boolean isWebview() {
        return hasCrossPlatformTask();
    }

    private static boolean hasCrossPlatformTask() {
        int myPid = Process.myPid();
        int[] pids = Process.getPids("/proc/" + myPid + "/task", new int[1024]);
        int length = pids.length;
        int i = 0;
        for (int i2 = 0; i2 < length; i2++) {
            int i3 = pids[i2];
            if (i3 < 0) {
                break;
            }
            String readCmdlineFromProcfs = readCmdlineFromProcfs("/proc/" + myPid + "/task/" + i3 + "/comm");
            if (readCmdlineFromProcfs != null && !readCmdlineFromProcfs.equals("")) {
                String[] strArr = sSpecialTaskList;
                int length2 = strArr.length;
                int i4 = 0;
                while (true) {
                    if (i4 >= length2) {
                        break;
                    }
                    if (readCmdlineFromProcfs.trim().equals(strArr[i4])) {
                        i++;
                        break;
                    }
                    i4++;
                }
            }
        }
        if (i == 0) {
            return false;
        }
        return true;
    }

    public static boolean fullscreenAndGl(WindowManager.LayoutParams layoutParams) {
        return Util.IsFullScreen(layoutParams) && hasGLTask();
    }

    public static boolean hasGLTask() {
        return containTask(Process.myPid(), GL_TASKS, true);
    }

    public static boolean containTask(int i, String[] strArr, boolean z) {
        int[] pids = Process.getPids("/proc/" + i + "/task", new int[1024]);
        int length = pids.length;
        int i2 = 0;
        for (int i3 = 0; i3 < length; i3++) {
            int i4 = pids[i3];
            if (i4 < 0) {
                break;
            }
            String readCmdlineFromProcfs = readCmdlineFromProcfs("/proc/" + i + "/task/" + i4 + "/comm");
            if (readCmdlineFromProcfs != null && !readCmdlineFromProcfs.equals("")) {
                int length2 = strArr.length;
                int i5 = 0;
                while (true) {
                    if (i5 >= length2) {
                        break;
                    }
                    String str = strArr[i5];
                    if ((!z || !readCmdlineFromProcfs.trim().contains(str)) && !readCmdlineFromProcfs.trim().equals(str)) {
                        i5++;
                    }
                }
                i2++;
            }
        }
        if (i2 == 0) {
            return false;
        }
        return true;
    }

    public static boolean isGameAPP(String str) {
        return Util.isGameApp(str) || containTask(Process.myPid(), GAME_TASKS, false);
    }

    public static boolean isFlutterApp(Context context) {
        Process.myPid();
        File[] listFiles = context.getCodeCacheDir().listFiles();
        if (listFiles == null || listFiles.length == 0) {
            return false;
        }
        boolean z = false;
        for (File name : listFiles) {
            if (sFlutterEngineName.equals(name.getName())) {
                if (Config.isBoostFwkLogEnable()) {
                    LogUtil.mLogd(TAG, "This is flutter.");
                }
                z = true;
            }
        }
        return z;
    }

    public static boolean isSpeicalAPP(Context context) {
        Process.myPid();
        String packageName = context.getPackageName();
        if (packageName != null && "android".equals(packageName)) {
            return false;
        }
        boolean isFlutterApp = isFlutterApp(context);
        boolean isAppBrand = isAppBrand();
        boolean hasCrossPlatformTask = hasCrossPlatformTask();
        if (!isFlutterApp && !isAppBrand && !hasCrossPlatformTask) {
            return false;
        }
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "This is speical app.");
        }
        return true;
    }

    public static boolean isSpeicalAPPWOWebView(Context context) {
        Process.myPid();
        String packageName = context.getPackageName();
        if (packageName != null && "android".equals(packageName)) {
            return false;
        }
        boolean isFlutterApp = isFlutterApp(context);
        boolean isAppBrand = isAppBrand();
        if (!isFlutterApp && !isAppBrand) {
            return false;
        }
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "This is speical app.");
        }
        return true;
    }

    public static boolean isAPPInStrictMode(String str) {
        boolean z = false;
        if (str != null && str.contains("webview")) {
            StrictMode.ThreadPolicy threadPolicy = StrictMode.getThreadPolicy();
            if (threadPolicy == null) {
                return false;
            }
            String replace = threadPolicy.toString().replace("[StrictMode.ThreadPolicy; mask=", "").replace("]", "");
            if (!(replace == null || replace == "")) {
                if ((Integer.parseInt(replace) & 2) != 0) {
                    z = true;
                }
                if (Config.isBoostFwkLogEnable() && z) {
                    LogUtil.mLogd(TAG, "This is app in strictmode -> " + str + " mask:" + replace);
                }
            }
        }
        return z;
    }
}
