package com.pri.prizeinterphone.record;

import android.os.Environment;
import android.text.TextUtils;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
/* loaded from: classes4.dex */
public class FileUtil {
    private static String rootPath = "interphone";
    private static final String AUDIO_PCM_BASEPATH = "/" + rootPath + "/";
    private static final String AUDIO_WAV_BASEPATH = "/" + rootPath + "/";

    private static void setRootPath(String str) {
        rootPath = str;
    }

    public static String getPcmFileAbsolutePath(String str) {
        if (TextUtils.isEmpty(str)) {
            throw new NullPointerException("fileName isEmpty");
        }
        if (!isSdcardExit()) {
            throw new IllegalStateException("sd card no found");
        }
        if (isSdcardExit()) {
            if (!str.endsWith(".pcm")) {
                str = str + ".pcm";
            }
            String str2 = Environment.getExternalStorageDirectory().getAbsolutePath() + AUDIO_PCM_BASEPATH;
            File file = new File(str2);
            if (!file.exists()) {
                file.mkdirs();
            }
            return str2 + str;
        }
        return "";
    }

    public static String getWavFileAbsolutePath(String str) {
        if (str == null) {
            throw new NullPointerException("fileName can't be null");
        }
        if (!isSdcardExit()) {
            throw new IllegalStateException("sd card no found");
        }
        if (isSdcardExit()) {
            if (!str.endsWith(".wav")) {
                str = str + ".wav";
            }
            String str2 = Environment.getExternalStorageDirectory().getAbsolutePath() + AUDIO_WAV_BASEPATH;
            File file = new File(str2);
            if (!file.exists()) {
                file.mkdirs();
            }
            return str2 + str;
        }
        return "";
    }

    public static boolean isSdcardExit() {
        return Environment.getExternalStorageState().equals("mounted");
    }

    public static List<File> getPcmFiles() {
        ArrayList arrayList = new ArrayList();
        File file = new File(Environment.getExternalStorageDirectory().getAbsolutePath() + AUDIO_PCM_BASEPATH);
        if (file.exists()) {
            for (File file2 : file.listFiles()) {
                arrayList.add(file2);
            }
        }
        return arrayList;
    }

    public static List<File> getWavFiles() {
        ArrayList arrayList = new ArrayList();
        File file = new File(Environment.getExternalStorageDirectory().getAbsolutePath() + AUDIO_WAV_BASEPATH);
        if (file.exists()) {
            for (File file2 : file.listFiles()) {
                arrayList.add(file2);
            }
        }
        return arrayList;
    }
}
