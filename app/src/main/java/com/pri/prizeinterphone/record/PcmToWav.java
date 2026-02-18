package com.pri.prizeinterphone.record;

import android.util.Log;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
/* loaded from: classes4.dex */
public class PcmToWav {
    public static boolean mergePCMFilesToWAVFile(List<String> list, String str) {
        File[] fileArr = new File[list.size()];
        int size = list.size();
        int i = 0;
        for (int i2 = 0; i2 < size; i2++) {
            File file = new File(list.get(i2));
            fileArr[i2] = file;
            i = (int) (i + file.length());
        }
        WaveHeader waveHeader = new WaveHeader();
        waveHeader.fileLength = i + 36;
        waveHeader.FmtHdrLeth = 16;
        waveHeader.BitsPerSample = (short) 16;
        waveHeader.Channels = (short) 2;
        waveHeader.FormatTag = (short) 1;
        waveHeader.SamplesPerSec = 8000;
        short s = (short) ((2 * 16) / 8);
        waveHeader.BlockAlign = s;
        waveHeader.AvgBytesPerSec = s * 8000;
        waveHeader.DataHdrLeth = i;
        try {
            byte[] header = waveHeader.getHeader();
            if (header.length != 44) {
                return false;
            }
            File file2 = new File(str);
            if (file2.exists()) {
                file2.delete();
            }
            try {
                byte[] bArr = new byte[4096];
                BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(str));
                bufferedOutputStream.write(header, 0, header.length);
                for (int i3 = 0; i3 < size; i3++) {
                    BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream(fileArr[i3]));
                    for (int read = bufferedInputStream.read(bArr); read != -1; read = bufferedInputStream.read(bArr)) {
                        bufferedOutputStream.write(bArr);
                    }
                    bufferedInputStream.close();
                }
                bufferedOutputStream.close();
                clearFiles(list);
                Log.i("PcmToWav", "mergePCMFilesToWAVFile  success!" + new SimpleDateFormat("yyyy-MM-dd hh:mm").format(new Date()));
                return true;
            } catch (FileNotFoundException e) {
                Log.e("PcmToWav", e.getMessage());
                return false;
            } catch (IOException e2) {
                Log.e("PcmToWav", e2.getMessage());
                return false;
            }
        } catch (IOException e3) {
            Log.e("PcmToWav", e3.getMessage());
            return false;
        }
    }

    public static boolean makePCMFileToWAVFile(String str, String str2, boolean z) {
        File file = new File(str);
        if (file.exists()) {
            int length = (int) file.length();
            WaveHeader waveHeader = new WaveHeader();
            waveHeader.fileLength = length + 36;
            waveHeader.FmtHdrLeth = 16;
            waveHeader.BitsPerSample = (short) 16;
            waveHeader.Channels = (short) 2;
            waveHeader.FormatTag = (short) 1;
            waveHeader.SamplesPerSec = 8000;
            short s = (short) ((2 * 16) / 8);
            waveHeader.BlockAlign = s;
            waveHeader.AvgBytesPerSec = s * 8000;
            waveHeader.DataHdrLeth = length;
            try {
                byte[] header = waveHeader.getHeader();
                if (header.length != 44) {
                    return false;
                }
                File file2 = new File(str2);
                if (file2.exists()) {
                    file2.delete();
                }
                try {
                    byte[] bArr = new byte[4096];
                    BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(str2));
                    bufferedOutputStream.write(header, 0, header.length);
                    BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream(file));
                    for (int read = bufferedInputStream.read(bArr); read != -1; read = bufferedInputStream.read(bArr)) {
                        bufferedOutputStream.write(bArr);
                    }
                    bufferedInputStream.close();
                    bufferedOutputStream.close();
                    if (z) {
                        file.delete();
                    }
                    Log.i("PcmToWav", "makePCMFileToWAVFile  success!" + new SimpleDateFormat("yyyy-MM-dd hh:mm").format(new Date()));
                    return true;
                } catch (FileNotFoundException e) {
                    Log.e("PcmToWav", e.getMessage());
                    return false;
                } catch (IOException e2) {
                    Log.e("PcmToWav", e2.getMessage());
                    return false;
                }
            } catch (IOException e3) {
                Log.e("PcmToWav", e3.getMessage());
                return false;
            }
        }
        return false;
    }

    private static void clearFiles(List<String> list) {
        for (int i = 0; i < list.size(); i++) {
            File file = new File(list.get(i));
            if (file.exists()) {
                file.delete();
            }
        }
    }
}
