package com.pri.prizeinterphone.manager;

import android.media.AudioRecord;
import android.media.AudioTrack;
import android.os.Handler;
import android.os.PrizeTinyService;
import android.os.SystemProperties;
import android.util.Log;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
/* loaded from: classes4.dex */
public class PrizePcmManager {
    private static final String TAG = "PrizePcmManager";
    private byte[] buffer;
    private int bufferSize;
    private int mFrameSize;
    private FileOutputStream mOutputStream;
    private AudioRecord mRecord;
    private File mRecordFile;
    private long timestamp;
    private boolean mIsExit = false;
    private boolean mIsRecording = false;
    private boolean isSaveRecord = false;
    private Object mRecordWait = new Object();
    private int SAMPLE_RATE = 8000;
    private int BUF_SIZE = 1024;
    private int RecordChannel = 12;
    private int RecordPcmBit = 2;
    private final String mRecordFileDir = "/sdcard/interphone/record";
    private Handler mHandler = new Handler();
    private Thread mRecordThread = new Thread("record") { // from class: com.pri.prizeinterphone.manager.PrizePcmManager.1
        @Override // java.lang.Thread, java.lang.Runnable
        public void run() {
            while (!PrizePcmManager.this.mIsExit) {
                synchronized (PrizePcmManager.this.mRecordWait) {
                    while (!PrizePcmManager.this.mIsRecording) {
                        try {
                            Log.d(PrizePcmManager.TAG, "mRecordThread wait");
                            PrizePcmManager.this.mRecordWait.wait();
                        } catch (InterruptedException unused) {
                        }
                    }
                }
                if (PrizePcmManager.this.mRecord != null) {
                    PrizePcmManager.this.recordReadRun();
                }
            }
        }
    };
    private PrizeTinyService mPrizeTinyService = new PrizeTinyService();

    public PrizePcmManager() {
        this.mRecordThread.start();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void recordReadRun() {
        Log.d(TAG, "recordReadRun mIsRecording:" + this.mIsRecording + ",mFrameSize:" + this.mFrameSize + ",bufferSize:" + this.bufferSize);
        int i = this.bufferSize;
        int i2 = this.mFrameSize;
        if (i < i2) {
            this.bufferSize = i2;
        }
        this.buffer = new byte[this.bufferSize];
        while (this.mIsRecording) {
            int read = this.mRecord.read(this.buffer, 0, this.bufferSize);
            if (read > 0) {
                this.mPrizeTinyService.writeFrame(this.buffer, read);
                if (DmrManager.getInstance().needSaveRecordFile() && this.isSaveRecord) {
                    try {
                        this.mOutputStream.write(this.buffer);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void notifyRecordThread() {
        synchronized (this.mRecordWait) {
            this.mIsRecording = true;
            Log.d(TAG, "notify record thread");
            this.mRecordWait.notifyAll();
        }
    }

    private void initRecord() {
        if (this.mRecord != null) {
            Log.d(TAG, "initRecord stopRecord");
            stopRecord();
        }
        if (SystemProperties.getInt("debug.channel", 2) == 2) {
            this.RecordChannel = 12;
        } else {
            this.RecordChannel = 16;
        }
        this.SAMPLE_RATE = SystemProperties.getInt("debug.rate", 8000);
        if (SystemProperties.getInt("debug.bits", 16) == 16) {
            this.RecordPcmBit = 2;
        } else {
            this.RecordPcmBit = 22;
        }
        Log.d(TAG, "initRecord RecordChannel:" + this.RecordChannel + ",SAMPLE_RATE:" + this.SAMPLE_RATE + ",RecordPcmBit:" + this.RecordPcmBit);
        int minBufferSize = AudioRecord.getMinBufferSize(this.SAMPLE_RATE, this.RecordChannel, this.RecordPcmBit);
        this.bufferSize = minBufferSize;
        int max = Math.max(minBufferSize, AudioTrack.getMinBufferSize(this.SAMPLE_RATE, this.RecordChannel, this.RecordPcmBit));
        this.bufferSize = max;
        this.bufferSize = (max / 8) * 8;
        this.mRecord = new AudioRecord(1, this.SAMPLE_RATE, this.RecordChannel, this.RecordPcmBit, this.bufferSize);
        Log.d(TAG, "initRecord bufferSize:" + this.bufferSize);
    }

    public long getTimestamp() {
        return this.timestamp;
    }

    private boolean startRecord() {
        try {
            this.mRecord.startRecording();
            this.mHandler.post(new Runnable() { // from class: com.pri.prizeinterphone.manager.PrizePcmManager.2
                @Override // java.lang.Runnable
                public void run() {
                    PrizePcmManager.this.notifyRecordThread();
                }
            });
            return true;
        } catch (Exception e) {
            Log.d(TAG, "startRecord error");
            e.printStackTrace();
            return false;
        }
    }

    public int startPcmRecord() {
        if (!this.mPrizeTinyService.openWritePcm()) {
            Log.d(TAG, "open write pcm error");
            return -1;
        }
        int frameSize = this.mPrizeTinyService.getFrameSize();
        this.mFrameSize = frameSize;
        if (frameSize <= 0) {
            Log.d(TAG, "get frame size error");
            this.mPrizeTinyService.closeWritePcm();
            return -2;
        }
        Log.d(TAG, "clien get frame size:" + this.mFrameSize);
        initRecord();
        return !startRecord() ? -3 : 0;
    }

    private void stopRecord() {
        FileOutputStream fileOutputStream;
        this.mIsRecording = false;
        AudioRecord audioRecord = this.mRecord;
        if (audioRecord == null) {
            return;
        }
        try {
            audioRecord.stop();
            this.mRecord.release();
            this.mRecord = null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (DmrManager.getInstance().needSaveRecordFile() && (fileOutputStream = this.mOutputStream) != null) {
            try {
                fileOutputStream.close();
            } catch (IOException e2) {
                e2.printStackTrace();
            }
        }
        Log.d(TAG, "stopRecord mIsRecording:" + this.mIsRecording);
    }

    public void stopPcmRecord() {
        stopRecord();
        this.mPrizeTinyService.closeWritePcm();
    }

    public String getRecordFilePath() {
        File file = this.mRecordFile;
        return file != null ? file.getAbsolutePath() : "";
    }

    public String getRecordFileName() {
        File file = this.mRecordFile;
        return file != null ? file.getName() : "";
    }

    private void checkEnvirement() {
        File file = new File("/sdcard/interphone/record");
        if (!file.exists()) {
            file.mkdir();
        }
        if (this.mRecordFile.getParentFile().exists()) {
            return;
        }
        this.mRecordFile.getParentFile().mkdirs();
    }

    public void createRecordFile() {
        Date date = null;
        if (DmrManager.getInstance().needSaveRecordFile()) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd-HHmmss");
            this.timestamp = new Date().getTime();
            this.mRecordFile = new File("/sdcard/interphone/record/" + (simpleDateFormat.format(date) + ".pcm"));
            checkEnvirement();
            try {
                this.mOutputStream = new FileOutputStream(this.mRecordFile);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
            this.isSaveRecord = true;
        }
    }

    public boolean getSaveRecord() {
        return this.isSaveRecord;
    }

    public void setSaveRecord(boolean z) {
        this.isSaveRecord = z;
    }
}
