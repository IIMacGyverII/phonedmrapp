package com.pri.prizeinterphone.shellexec;

import android.util.Log;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.Objects;
/* loaded from: classes4.dex */
public class ExecShell {
    private static final String TAG = "ExecShell";
    private static volatile ExecShell instance;

    private ExecShell() {
    }

    public static ExecShell getInstance() {
        if (instance == null) {
            synchronized (ExecShell.class) {
                if (instance == null) {
                    instance = new ExecShell();
                }
            }
        }
        return instance;
    }

    public void playRuntime(String str) {
        try {
            Process exec = Runtime.getRuntime().exec(str);
            InputStream inputStream = exec.getInputStream();
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
            while (true) {
                String readLine = bufferedReader.readLine();
                if (readLine != null) {
                    PrintStream printStream = System.out;
                    printStream.println("------ playRuntime line = " + readLine + "  ------");
                } else {
                    bufferedReader.close();
                    exec.waitFor();
                    inputStream.close();
                    exec.destroy();
                    PrintStream printStream2 = System.out;
                    printStream2.println("------ ShellExec playRuntime " + str + " end ------");
                    return;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            PrintStream printStream3 = System.out;
            printStream3.println("------ playRuntime IOException ------ " + e.getMessage());
        } catch (InterruptedException e2) {
            PrintStream printStream4 = System.out;
            printStream4.println("------ playRuntime InterruptedException ------ " + e2.getMessage());
            e2.printStackTrace();
        }
    }

    public synchronized String runCmd(String[] strArr, String str) throws Throwable {
        InputStream inputStream = null;
        Objects.requireNonNull(str);
        StringBuilder sb = new StringBuilder("");
        ProcessBuilder processBuilder = new ProcessBuilder(strArr);
        processBuilder.directory(new File(str));
        processBuilder.redirectErrorStream(true);
        Process process = null;
        try {
            process = processBuilder.start();
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (process == null) {
            Log.e(TAG, "execute'" + sb.toString() + "'command error!!!!!!!!!!!!!");
            return sb.toString();
        }
        try {
            inputStream = process.getInputStream();
        } catch (Exception e2) {
            e2.printStackTrace();
            for (String str2 : strArr) {
                sb.append(str2 + " ");
            }
            sb.append("ERROR!!!");
            Log.e(TAG, "execute'" + sb.toString() + "'command error!!!!!!!!!!!!!");
        }
        try {
        if (inputStream == null) {
            return sb.toString();
        }
            byte[] bArr = new byte[16];
            while (true) {
                int read = inputStream.read(bArr);
                if (read == -1) {
                    break;
                }
                sb.append(new String(bArr, 0, read));
            }
            inputStream.close();
            return sb.toString();
        } catch (Throwable th) {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (Throwable th2) {
                    th.addSuppressed(th2);
                }
            }
            throw th;
        }
    }
}
