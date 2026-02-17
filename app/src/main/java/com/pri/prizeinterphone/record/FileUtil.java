package com.pri.prizeinterphone.record;

import android.os.Environment;
import android.text.TextUtils;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class FileUtil {
    private static final String AUDIO_PCM_BASEPATH = ("/" + rootPath + "/");
    private static final String AUDIO_WAV_BASEPATH = ("/" + rootPath + "/");
    private static String rootPath = "interphone";

    private static void setRootPath(String str) {
        rootPath = str;
    }

    public static String getPcmFileAbsolutePath(String str) {
        if (TextUtils.isEmpty(str)) {
            throw new NullPointerException("fileName isEmpty");
        } else if (!isSdcardExit()) {
            throw new IllegalStateException("sd card no found");
        } else if (!isSdcardExit()) {
            return "";
        } else {
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
    }

    public static String getWavFileAbsolutePath(String str) {
        if (str == null) {
            throw new NullPointerException("fileName can't be null");
        } else if (!isSdcardExit()) {
            throw new IllegalStateException("sd card no found");
        } else if (!isSdcardExit()) {
            return "";
        } else {
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
    }

    public static boolean isSdcardExit() {
        return Environment.getExternalStorageState().equals("mounted");
    }

    public static List<File> getPcmFiles() {
        ArrayList arrayList = new ArrayList();
        File file = new File(Environment.getExternalStorageDirectory().getAbsolutePath() + AUDIO_PCM_BASEPATH);
        if (file.exists()) {
            for (File add : file.listFiles()) {
                arrayList.add(add);
            }
        }
        return arrayList;
    }

    public static List<File> getWavFiles() {
        ArrayList arrayList = new ArrayList();
        File file = new File(Environment.getExternalStorageDirectory().getAbsolutePath() + AUDIO_WAV_BASEPATH);
        if (file.exists()) {
            for (File add : file.listFiles()) {
                arrayList.add(add);
            }
        }
        return arrayList;
    }
}
