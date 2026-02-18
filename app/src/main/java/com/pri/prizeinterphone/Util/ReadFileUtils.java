package com.pri.prizeinterphone.Util;

import android.util.Log;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.StringJoiner;
import java.util.function.Consumer;
import java.util.stream.Stream;
/* loaded from: classes4.dex */
public class ReadFileUtils {
    private static final String DMR009_FILENAME = "/sys/devices/platform/dmr009/debug";
    private static final String DMR009_PTT = "/sys/devices/platform/dmr009/ptt";
    private static final String DMR009_PWD = "/sys/devices/platform/dmr009/pwd";
    private static final String TAG = "ReadFileUtils";
    private static volatile ReadFileUtils instance;

    private ReadFileUtils() {
    }

    public static ReadFileUtils getInstance() {
        if (instance == null) {
            synchronized (ReadFileUtils.class) {
                if (instance == null) {
                    instance = new ReadFileUtils();
                }
            }
        }
        return instance;
    }

    public String readFile() {
        return readFile(DMR009_FILENAME, false);
    }

    public String readFile(String str, boolean z) {
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader(new File(str)));
            if (z) {
                String readLine = bufferedReader.readLine();
                bufferedReader.close();
                return readLine;
            }
            Stream<String> lines = bufferedReader.lines();
            final StringJoiner stringJoiner = new StringJoiner("\n");
            lines.forEach(new Consumer() { // from class: com.pri.prizeinterphone.Util.ReadFileUtils$$ExternalSyntheticLambda0
                @Override // java.util.function.Consumer
                public final void accept(Object obj) {
                    stringJoiner.add((String) obj);
                }
            });
            String stringJoiner2 = stringJoiner.toString();
            bufferedReader.close();
            return stringJoiner2;
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }

    public String readFileDate() {
        try {
            byte[] bArr = new byte[4];
            new FileInputStream(DMR009_FILENAME).read(bArr);
            return new String(bArr);
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }

    private String readFilePwd() {
        return readFile(DMR009_PWD, false);
    }

    private boolean writeFilePwd(String str) {
        return writeFileData(DMR009_PWD, str);
    }

    private String readFilePtt() {
        return readFile(DMR009_PTT, false);
    }

    private boolean writeFilePtt(String str) {
        return writeFileData(DMR009_PTT, str);
    }

    public void pullUpPwdFoot() {
        Log.d(TAG, "pullUpPwdFoot");
        if ("pwd :0".equals(getInstance().readFilePwd().trim())) {
            writeFilePwd("1");
        }
    }

    public void pullDownPwdFoot() {
        Log.d(TAG, "pullDownPwdFoot");
        if ("pwd :1".equals(getInstance().readFilePwd().trim())) {
            writeFilePwd("0");
        }
    }

    public void pullUpPttFoot() {
        Log.d(TAG, "pullUpPttFoot");
        if ("ptt :0".equals(getInstance().readFilePtt().trim())) {
            writeFilePtt("1");
        }
    }

    public void pullDownPttFoot() {
        Log.d(TAG, "pullDownPttFoot");
        if ("ptt :1".equals(getInstance().readFilePtt().trim())) {
            writeFilePtt("0");
        }
    }

    public void setDmrUpdateCondition() {
        Log.d(TAG, "setDmrUpdateCondition");
        pullDownPwdFoot();
        try {
            Thread.sleep(50L);
            pullDownPttFoot();
            try {
                Thread.sleep(50L);
                pullUpPwdFoot();
                try {
                    Thread.sleep(1000L);
                    pullUpPttFoot();
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            } catch (InterruptedException e2) {
                throw new RuntimeException(e2);
            }
        } catch (InterruptedException e3) {
            throw new RuntimeException(e3);
        }
    }

    public boolean writeFileData(String str, String str2) {
        try {
            BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(str));
            bufferedWriter.write(str2);
            bufferedWriter.close();
            Log.d(TAG, "writeFileData write " + str2 + " ok");
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            Log.d(TAG, "writeFileData write " + str2 + " failed!");
            return false;
        }
    }
}
