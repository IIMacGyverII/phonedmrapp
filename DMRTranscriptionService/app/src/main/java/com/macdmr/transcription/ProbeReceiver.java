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
        // 6. uart: exchange a real frame with the MCU (needs the OEM app disabled, else two readers share the port)
        if (intent != null && intent.getBooleanExtra("uart", false)) {
            try {
                // module power/PTT GPIOs: /sys/devices/platform/dmr009/{pwd,ptt,pd,debug} (OEM ReadFileUtils: "pwd :1" = powered)
                for (String nname : new String[] { "pwd", "ptt", "pd", "debug" }) Log.i(TAG, "sysfs " + nname + " = " + sysRead(nname));
                String pwd = sysRead("pwd").trim();
                boolean powered = pwd.equals("pwd :1") || pwd.startsWith("FAIL");   // unreadable -> assume on, never wait for a boot
                byte[] q = frame((byte) 0x32, new byte[] { 1 });            // SignalMessage: QUERY_SIGNAL_STRENGTH, fetch=1
                try (FileInputStream in = new FileInputStream("/dev/ttyS0"); FileOutputStream out = new FileOutputStream("/dev/ttyS0")) {
                    while (in.available() > 0) in.read(new byte[Math.min(in.available(), 4096)]);   // drain stale bytes
                    if (!powered) {
                        Log.i(TAG, "module is OFF -> pwd=1 (power up), waiting for the boot announcement (0xAA/0xBF)");
                        sysWrite("pwd", "1");
                        Log.i(TAG, "sysfs pwd now = " + sysRead("pwd"));
                        byte[] bb = new byte[512]; int bn = 0; long b0 = System.currentTimeMillis();
                        while (System.currentTimeMillis() - b0 < 8000 && bn < bb.length) {
                            int a = in.available();
                            if (a > 0) { int r = in.read(bb, bn, Math.min(a, bb.length - bn)); if (r > 0) bn += r; }
                            else Thread.sleep(20);
                        }
                        Log.i(TAG, "boot bytes (" + bn + " in " + (System.currentTimeMillis() - b0) + " ms): " + hex(bb, bn));
                    }
                    Log.i(TAG, "UART tx: " + hex(q, q.length));
                    out.write(q); out.flush();
                    byte[] buf = new byte[256]; int n = 0; long t0 = System.currentTimeMillis();
                    while (System.currentTimeMillis() - t0 < 1500 && n < buf.length) {
                        int a = in.available();
                        if (a > 0) { int r = in.read(buf, n, Math.min(a, buf.length - n)); if (r > 0) n += r; }
                        else Thread.sleep(10);
                        if (n >= 9 && buf[0] == 0x68 && n >= 9 + (((buf[6] & 0xFF) << 8) | (buf[7] & 0xFF))) break;
                    }
                    Log.i(TAG, "UART rx (" + n + " bytes, " + (System.currentTimeMillis() - t0) + " ms): " + hex(buf, n));
                    if (n >= 9 && buf[0] == 0x68) {
                        int len = ((buf[6] & 0xFF) << 8) | (buf[7] & 0xFF);
                        Log.i(TAG, "UART reply cmd=0x" + Integer.toHexString(buf[1] & 0xFF) + " rw=" + buf[2] + " sr=" + buf[3] + " len=" + len
                                + (len >= 1 ? " body[0]=" + (buf[8] & 0xFF) + " (RSSI raw -> " + (-(120 - (buf[8] & 0xFF) / 2.0)) + " dBm)" : ""));
                    }
                }
            } catch (Throwable t) {
                Log.i(TAG, "UART exchange: FAIL " + t);
            }
        }
        Log.i(TAG, "probe done");
    }

    /** OEM frame: 68 cmd rw=1 sr=1 ck(2,BE) len(2,BE) body 10; checksum = one's-complement 16-bit sum over the frame with ck=0. */
    static byte[] frame(byte cmd, byte[] body) {
        byte[] f = new byte[9 + body.length];
        f[0] = 0x68; f[1] = cmd; f[2] = 1; f[3] = 1; f[4] = 0; f[5] = 0;
        f[6] = (byte) (body.length >> 8); f[7] = (byte) body.length;
        System.arraycopy(body, 0, f, 8, body.length);
        f[f.length - 1] = 0x10;
        long sum = 0; int i = 0;
        for (; i + 1 < f.length; i += 2) sum += (((f[i] & 0xFF) << 8) | (f[i + 1] & 0xFF));
        if (i < f.length) sum += (f[i] & 0xFF) << 8;
        while ((sum >> 16) > 0) sum = (sum & 0xFFFF) + (sum >> 16);
        int ck = ((int) sum) ^ 0xFFFF;
        f[4] = (byte) (ck >> 8); f[5] = (byte) ck;
        return f;
    }

    static String sysRead(String node) {
        try (FileInputStream f = new FileInputStream("/sys/devices/platform/dmr009/" + node)) {
            byte[] b = new byte[64]; int n = f.read(b); return n > 0 ? new String(b, 0, n).trim() : "(empty)";
        } catch (Throwable t) { return "FAIL " + t; }
    }

    static void sysWrite(String node, String v) {
        try (FileOutputStream f = new FileOutputStream("/sys/devices/platform/dmr009/" + node)) { f.write(v.getBytes()); }
        catch (Throwable t) { Log.i(TAG, "sysfs write " + node + ": FAIL " + t); }
    }

    static String hex(byte[] b, int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) sb.append(String.format("%02X ", b[i] & 0xFF));
        return sb.toString().trim();
    }
}
