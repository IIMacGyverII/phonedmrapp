package com.pri.prizeinterphone.record;

import android.media.AudioRecord;
import android.text.TextUtils;
import android.util.Log;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class AudioRecorder {
    private static final int AUDIO_CHANNEL = 16;
    private static final int AUDIO_ENCODING = 2;
    private static final int AUDIO_INPUT = 1;
    private static final int AUDIO_SAMPLE_RATE = 16000;
    private AudioRecord audioRecord;
    private int bufferSizeInBytes;
    /* access modifiers changed from: private */
    public String fileName;
    private List<String> filesName;
    private Status status;

    public enum Status {
        STATUS_NO_READY,
        STATUS_READY,
        STATUS_START,
        STATUS_PAUSE,
        STATUS_STOP
    }

    private static class AudioRecorderHolder {
        /* access modifiers changed from: private */
        public static AudioRecorder instance = new AudioRecorder();

        private AudioRecorderHolder() {
        }
    }

    private AudioRecorder() {
        this.bufferSizeInBytes = 0;
        this.status = Status.STATUS_NO_READY;
        this.filesName = new ArrayList();
    }

    public static AudioRecorder getInstance() {
        return AudioRecorderHolder.instance;
    }

    public void createAudio(String str, int i, int i2, int i3, int i4) {
        this.bufferSizeInBytes = AudioRecord.getMinBufferSize(i2, i3, i3);
        this.audioRecord = new AudioRecord(i, i2, i3, i4, this.bufferSizeInBytes);
        this.fileName = str;
    }

    public void createDefaultAudio(String str) {
        this.bufferSizeInBytes = AudioRecord.getMinBufferSize(AUDIO_SAMPLE_RATE, 16, 2);
        this.audioRecord = new AudioRecord(1, AUDIO_SAMPLE_RATE, 16, 2, this.bufferSizeInBytes);
        this.fileName = str;
        this.status = Status.STATUS_READY;
    }

    public void startRecord(final RecordStreamListener recordStreamListener) {
        if (this.status == Status.STATUS_NO_READY || TextUtils.isEmpty(this.fileName)) {
            throw new IllegalStateException("录音尚未初始化,请检查是否禁止了录音权限~");
        } else if (this.status != Status.STATUS_START) {
            Log.d("AudioRecorder", "===startRecord===" + this.audioRecord.getState());
            this.audioRecord.startRecording();
            new Thread(new Runnable() {
                public void run() {
                    AudioRecorder.this.writeDataTOFile(recordStreamListener);
                }
            }).start();
        } else {
            throw new IllegalStateException("正在录音");
        }
    }

    public void pauseRecord() {
        Log.d("AudioRecorder", "===pauseRecord===");
        if (this.status == Status.STATUS_START) {
            this.audioRecord.stop();
            this.status = Status.STATUS_PAUSE;
            return;
        }
        throw new IllegalStateException("没有在录音");
    }

    public void stopRecord() {
        Log.d("AudioRecorder", "===stopRecord===");
        Status status2 = this.status;
        if (status2 == Status.STATUS_NO_READY || status2 == Status.STATUS_READY) {
            throw new IllegalStateException("录音尚未开始");
        }
        this.audioRecord.stop();
        this.status = Status.STATUS_STOP;
        release();
    }

    public void release() {
        Log.d("AudioRecorder", "===release===");
        AudioRecord audioRecord2 = this.audioRecord;
        if (audioRecord2 != null) {
            audioRecord2.release();
            this.audioRecord = null;
        }
        this.status = Status.STATUS_NO_READY;
    }

    public void canel() {
        this.filesName.clear();
        this.fileName = null;
        AudioRecord audioRecord2 = this.audioRecord;
        if (audioRecord2 != null) {
            audioRecord2.release();
            this.audioRecord = null;
        }
        this.status = Status.STATUS_NO_READY;
    }

    /* access modifiers changed from: private */
    public void writeDataTOFile(RecordStreamListener recordStreamListener) {
        FileOutputStream fileOutputStream;
        int i = this.bufferSizeInBytes;
        byte[] bArr = new byte[i];
        try {
            String str = this.fileName;
            if (this.status == Status.STATUS_PAUSE) {
                str = str + this.filesName.size();
            }
            this.filesName.add(str);
            File file = new File(FileUtil.getPcmFileAbsolutePath(str));
            if (file.exists()) {
                file.delete();
            }
            fileOutputStream = new FileOutputStream(file);
        } catch (IllegalStateException e) {
            Log.e("AudioRecorder", e.getMessage());
            throw new IllegalStateException(e.getMessage());
        } catch (FileNotFoundException e2) {
            Log.e("AudioRecorder", e2.getMessage());
            fileOutputStream = null;
        }
        this.status = Status.STATUS_START;
        while (this.status == Status.STATUS_START) {
            if (!(-3 == this.audioRecord.read(bArr, 0, this.bufferSizeInBytes) || fileOutputStream == null)) {
                try {
                    fileOutputStream.write(bArr);
                    if (recordStreamListener != null) {
                        recordStreamListener.recordOfByte(bArr, 0, i);
                    }
                } catch (IOException e3) {
                    Log.e("AudioRecorder", e3.getMessage());
                }
            }
        }
        if (fileOutputStream != null) {
            try {
                fileOutputStream.close();
            } catch (IOException e4) {
                Log.e("AudioRecorder", e4.getMessage());
            }
        }
    }

    private void mergePCMFilesToWAVFile(final List<String> list) {
        new Thread(new Runnable() {
            public void run() {
                if (PcmToWav.mergePCMFilesToWAVFile(list, FileUtil.getWavFileAbsolutePath(AudioRecorder.this.fileName))) {
                    AudioRecorder.this.fileName = null;
                } else {
                    Log.e("AudioRecorder", "mergePCMFilesToWAVFile fail");
                    throw new IllegalStateException("mergePCMFilesToWAVFile fail");
                }
            }
        }).start();
    }

    private void makePCMFileToWAVFile() {
        new Thread(new Runnable() {
            public void run() {
                if (PcmToWav.makePCMFileToWAVFile(FileUtil.getPcmFileAbsolutePath(AudioRecorder.this.fileName), FileUtil.getWavFileAbsolutePath(AudioRecorder.this.fileName), true)) {
                    AudioRecorder.this.fileName = null;
                } else {
                    Log.e("AudioRecorder", "makePCMFileToWAVFile fail");
                    throw new IllegalStateException("makePCMFileToWAVFile fail");
                }
            }
        }).start();
    }

    public Status getStatus() {
        return this.status;
    }

    public int getPcmFilesCount() {
        return this.filesName.size();
    }
}
