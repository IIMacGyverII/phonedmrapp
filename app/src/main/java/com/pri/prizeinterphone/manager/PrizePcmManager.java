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

public class PrizePcmManager {
    private static final String TAG = "PrizePcmManager";
    private int BUF_SIZE = 1024;
    private int RecordChannel = 12;
    private int RecordPcmBit = 2;
    private int SAMPLE_RATE = 8000;
    private byte[] buffer;
    private int bufferSize;
    private boolean isSaveRecord = false;
    private int mFrameSize;
    private Handler mHandler = new Handler();
    /* access modifiers changed from: private */
    public boolean mIsExit = false;
    /* access modifiers changed from: private */
    public boolean mIsRecording = false;
    private FileOutputStream mOutputStream;
    private PrizeTinyService mPrizeTinyService = new PrizeTinyService();
    /* access modifiers changed from: private */
    public AudioRecord mRecord;
    private File mRecordFile;
    private final String mRecordFileDir = "/sdcard/interphone/record";
    private Thread mRecordThread = new Thread("record") {
        /* JADX WARNING: Exception block dominator not found, dom blocks: [] */
        /* JADX WARNING: Missing exception handler attribute for start block: B:4:0x000f */
        /* JADX WARNING: Removed duplicated region for block: B:4:0x000f A[LOOP:1: B:4:0x000f->B:24:0x000f, LOOP_START, SYNTHETIC] */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void run() {
            /*
                r3 = this;
            L_0x0000:
                com.pri.prizeinterphone.manager.PrizePcmManager r0 = com.pri.prizeinterphone.manager.PrizePcmManager.this
                boolean r0 = r0.mIsExit
                if (r0 != 0) goto L_0x003a
                com.pri.prizeinterphone.manager.PrizePcmManager r0 = com.pri.prizeinterphone.manager.PrizePcmManager.this
                java.lang.Object r0 = r0.mRecordWait
                monitor-enter(r0)
            L_0x000f:
                com.pri.prizeinterphone.manager.PrizePcmManager r1 = com.pri.prizeinterphone.manager.PrizePcmManager.this     // Catch:{ all -> 0x0037 }
                boolean r1 = r1.mIsRecording     // Catch:{ all -> 0x0037 }
                if (r1 != 0) goto L_0x0028
                java.lang.String r1 = "PrizePcmManager"
                java.lang.String r2 = "mRecordThread wait"
                android.util.Log.d(r1, r2)     // Catch:{ InterruptedException -> 0x000f }
                com.pri.prizeinterphone.manager.PrizePcmManager r1 = com.pri.prizeinterphone.manager.PrizePcmManager.this     // Catch:{ InterruptedException -> 0x000f }
                java.lang.Object r1 = r1.mRecordWait     // Catch:{ InterruptedException -> 0x000f }
                r1.wait()     // Catch:{ InterruptedException -> 0x000f }
                goto L_0x000f
            L_0x0028:
                monitor-exit(r0)     // Catch:{ all -> 0x0037 }
                com.pri.prizeinterphone.manager.PrizePcmManager r0 = com.pri.prizeinterphone.manager.PrizePcmManager.this
                android.media.AudioRecord r0 = r0.mRecord
                if (r0 == 0) goto L_0x0000
                com.pri.prizeinterphone.manager.PrizePcmManager r0 = com.pri.prizeinterphone.manager.PrizePcmManager.this
                r0.recordReadRun()
                goto L_0x0000
            L_0x0037:
                r3 = move-exception
                monitor-exit(r0)     // Catch:{ all -> 0x0037 }
                throw r3
            L_0x003a:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.pri.prizeinterphone.manager.PrizePcmManager.AnonymousClass1.run():void");
        }
    };
    /* access modifiers changed from: private */
    public Object mRecordWait = new Object();
    private long timestamp;

    public PrizePcmManager() {
        this.mRecordThread.start();
    }

    /* access modifiers changed from: private */
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

    /* access modifiers changed from: private */
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
            this.mHandler.post(new Runnable() {
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
        if (audioRecord != null) {
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
        if (!this.mRecordFile.getParentFile().exists()) {
            this.mRecordFile.getParentFile().mkdirs();
        }
    }

    public void createRecordFile() {
        if (DmrManager.getInstance().needSaveRecordFile()) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd-HHmmss");
            Date date = new Date();
            this.timestamp = date.getTime();
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
