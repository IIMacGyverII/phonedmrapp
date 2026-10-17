package com.macdmr.transcription;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.lang.reflect.Method;

/**
 * Standalone-app feasibility probe (2026-10-17). From an ordinary, unprivileged app process
 * (untrusted_app SELinux domain, no system uid) try to touch what the OEM radio app relies on:
 * the MCU UART (/dev/ttyS0) and the vendor audio binder (android.os.PrizeTinyService / "tinyservice").
 *
 *   adb shell am broadcast -a com.macdmr.transcription.PROBE [--ez deep true]
 *
 * Results go to logcat under the tag "StandaloneProbe". "deep" also opens/closes the PCM streams.
 */
public class ProbeReceiver extends BroadcastReceiver {
    private static final String TAG = "StandaloneProbe";

    @Override
    public void onReceive(Context context, Intent intent) {
        boolean deep = intent != null && intent.getBooleanExtra("deep", false);
        Log.i(TAG, "uid=" + android.os.Process.myUid() + " deep=" + deep);
        try {
            boolean ok = org.lsposed.hiddenapibypass.HiddenApiBypass.addHiddenApiExemptions("");
            Log.i(TAG, "hidden-API bypass: " + ok);
        } catch (Throwable t) { Log.i(TAG, "hidden-API bypass: FAIL " + t); }

        // 1. UART
        try (FileInputStream in = new FileInputStream("/dev/ttyS0")) {
            Log.i(TAG, "UART read-open: OK (fd valid=" + in.getFD().valid() + ")");
        } catch (Throwable t) {
            Log.i(TAG, "UART read-open: FAIL " + t);
        }
        try (FileOutputStream out = new FileOutputStream("/dev/ttyS0")) {
            Log.i(TAG, "UART write-open: OK");
        } catch (Throwable t) {
            Log.i(TAG, "UART write-open: FAIL " + t);
        }

        // 2. binder lookup
        try {
            Class<?> sm = Class.forName("android.os.ServiceManager");
            Method get = sm.getMethod("getService", String.class);
            Object b = get.invoke(null, "tinyservice");
            Log.i(TAG, "ServiceManager.getService(tinyservice): " + (b == null ? "NULL (not found / SELinux find denied)" : "OK " + b));
        } catch (Throwable t) {
            Log.i(TAG, "ServiceManager lookup: FAIL " + t);
        }

        // 3. vendor wrapper class + side-effect-free call
        Object svc = null;
        try {
            Class<?> c = Class.forName("android.os.PrizeTinyService");
            for (java.lang.reflect.Constructor<?> k : c.getDeclaredConstructors()) Log.i(TAG, "  ctor: " + k);
            for (Method m : c.getDeclaredMethods()) Log.i(TAG, "  method: " + m);
            java.lang.reflect.Constructor<?> k0 = c.getDeclaredConstructors()[0];
            k0.setAccessible(true);
            Object[] args = new Object[k0.getParameterTypes().length];
            for (int i = 0; i < args.length; i++) {
                Class<?> pt = k0.getParameterTypes()[i];
                args[i] = Context.class.isAssignableFrom(pt) ? context : (pt == int.class ? 0 : (pt == boolean.class ? false : null));
            }
            svc = k0.newInstance(args);
            Log.i(TAG, "PrizeTinyService instantiated: " + svc);
            Method fs = c.getMethod("getFrameSize");
            Object r = fs.invoke(svc);
            Log.i(TAG, "getFrameSize(): " + r);
        } catch (Throwable t) {
            Log.i(TAG, "PrizeTinyService: FAIL " + t + (t.getCause() != null ? " cause=" + t.getCause() : ""));
        }

        // 4. deep: open/close both PCM directions
        if (deep && svc != null) {
            try {
                Class<?> c = svc.getClass();
                Object o1 = c.getMethod("openRecvPcm").invoke(svc);
                Log.i(TAG, "openRecvPcm(): " + o1);
                Thread.sleep(300);
                c.getMethod("closeRecvPcm").invoke(svc);
                Log.i(TAG, "closeRecvPcm(): done");
                Object o2 = c.getMethod("openWritePcm").invoke(svc);
                Log.i(TAG, "openWritePcm(): " + o2);
                Log.i(TAG, "getFrameSize() while write open: " + c.getMethod("getFrameSize").invoke(svc));
                c.getMethod("closeWritePcm").invoke(svc);
                Log.i(TAG, "closeWritePcm(): done");
            } catch (Throwable t) {
                Log.i(TAG, "deep PCM: FAIL " + t + (t.getCause() != null ? " cause=" + t.getCause() : ""));
            }
        }
        // 5. deep: the raw ITinyService also has openSerialPort(int,int)/closeSerialPort()
        if (deep) {
            try {
                Class<?> sm = Class.forName("android.os.ServiceManager");
                Object b = sm.getMethod("getService", String.class).invoke(null, "tinyservice");
                Class<?> stub = Class.forName("android.os.ITinyService$Stub");
                Object itiny = stub.getMethod("asInterface", android.os.IBinder.class).invoke(null, b);
                Class<?> ic = Class.forName("android.os.ITinyService");
                Object r = ic.getMethod("openSerialPort", int.class, int.class).invoke(itiny, 57600, 0);
                Log.i(TAG, "ITinyService.openSerialPort(57600,0): " + r);
                ic.getMethod("closeSerialPort").invoke(itiny);
                Log.i(TAG, "ITinyService.closeSerialPort(): done");
                Object r2 = ic.getMethod("startRecvPcm").invoke(itiny);
                Log.i(TAG, "ITinyService.startRecvPcm(): " + r2);
                ic.getMethod("stopRecvPcm").invoke(itiny);
                Log.i(TAG, "ITinyService.stopRecvPcm(): done");
            } catch (Throwable t) {
                Log.i(TAG, "ITinyService raw: FAIL " + t + (t.getCause() != null ? " cause=" + t.getCause() : ""));
            }
        }
        Log.i(TAG, "probe done");
    }
}
