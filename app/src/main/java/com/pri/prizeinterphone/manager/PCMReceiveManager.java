package com.pri.prizeinterphone.manager;

import android.media.AudioTrack;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.ITinyRecvCallback;
import android.os.Looper;
import android.os.Message;
import android.os.PrizeTinyService;
import android.util.Log;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
/* loaded from: classes4.dex */
public class PCMReceiveManager {
    private static final int DEFAULT_AUDIO_FORMAT = 2;
    private static final int DEFAULT_CHANNEL_CONFIG = 12;
    private static final int DEFAULT_PLAY_MODE = 1;
    private static final int DEFAULT_SAMPLE_RATE = 8000;
    private static final int DEFAULT_STREAM_TYPE = 3;
    public static final int PCM_READ_DATA = 1;
    private static final String TAG = "PCMReceiveManager";
    private AudioTrack mAudioTrack;
    private ITinyRecvCallback mCallback;
    private int mMinBufferSize;
    private FileOutputStream mOutputStream;
    private PrizeTinyService mPrizeTinyService;
    private HandlerThread mReadThread;
    private Handler mReadThreadHandler;
    private File mRecordFile;
    private final String mRecordFileDir;
    private Object mSyncTrack;
    private long timestamp;

    private PCMReceiveManager() {
        this.mRecordFileDir = "/sdcard/interphone/record";
        this.mSyncTrack = new Object();
        this.mCallback = new ITinyRecvCallback.Stub() { // from class: com.pri.prizeinterphone.manager.PCMReceiveManager.1
            public void onRecv(byte[] bArr, int i) {
                new String(bArr);
                Log.d(PCMReceiveManager.TAG, "onRecv " + i);
                PCMReceiveManager.this.mReadThreadHandler.sendMessage(PCMReceiveManager.this.mReadThreadHandler.obtainMessage(1, i, 0, bArr));
            }
        };
        this.mPrizeTinyService = new PrizeTinyService();
        initPcmRead();
    }

    /* loaded from: classes4.dex */
    private static class SingletonHolder {
        private static final PCMReceiveManager INSTANCE = new PCMReceiveManager();

        private SingletonHolder() {
        }
    }

    public static PCMReceiveManager getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private void initAudioTrack() {
        this.mMinBufferSize = AudioTrack.getMinBufferSize(DEFAULT_SAMPLE_RATE, 12, 2);
        this.mAudioTrack = new AudioTrack(3, DEFAULT_SAMPLE_RATE, 12, 2, this.mMinBufferSize * 2, 1);
        Log.d(TAG, "init audiotrack stram:3,rate:8000,chennel:12,format:2");
    }

    private void startAudioTrack() {
        initAudioTrack();
        try {
            this.mAudioTrack.play();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void releaseAutioTrack() {
        AudioTrack audioTrack = this.mAudioTrack;
        if (audioTrack != null) {
            audioTrack.release();
            this.mAudioTrack = null;
        }
    }

    private void stopAudioTrack() {
        try {
            AudioTrack audioTrack = this.mAudioTrack;
            if (audioTrack != null && audioTrack.getState() == 1) {
                this.mAudioTrack.stop();
            }
            releaseAutioTrack();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void initPcmRead() {
        HandlerThread handlerThread = new HandlerThread("readpcm");
        this.mReadThread = handlerThread;
        handlerThread.start();
        this.mReadThreadHandler = new WorkHandler(this.mReadThread.getLooper());
        this.mPrizeTinyService.registerRecvCallback(this.mCallback);
    }

    /* loaded from: classes4.dex */
    public class WorkHandler extends Handler {
        public WorkHandler(Looper looper) {
            super(looper);
        }

        @Override // android.os.Handler
        public void handleMessage(Message message) {
            if (message.what != 1) {
                return;
            }
            int i = message.arg1;
            PCMReceiveManager.this.writeAudioTrack((byte[]) message.obj, i);
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void writeAudioTrack(byte[] bArr, int i) {
        synchronized (this.mSyncTrack) {
            AudioTrack audioTrack = this.mAudioTrack;
            if (audioTrack != null) {
                int write = audioTrack.write(bArr, 0, i);
                if (DmrManager.getInstance().needSaveRecordFile()) {
                    try {
                        FileOutputStream fileOutputStream = this.mOutputStream;
                        if (fileOutputStream != null) {
                            fileOutputStream.write(bArr);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                Log.d(TAG, "writeAudioTrack " + write);
            }
        }
    }

    public void startPcmRead() {
        Date date = null;
        Log.d(TAG, "startPcmRead");
        synchronized (this.mSyncTrack) {
            startAudioTrack();
        }
        PrizeTinyService prizeTinyService = this.mPrizeTinyService;
        if (prizeTinyService != null) {
            prizeTinyService.openRecvPcm();
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
            }
        }
    }

    public void stopPcmRead() {
        Log.d(TAG, "stopPcmRead");
        synchronized (this.mSyncTrack) {
            stopAudioTrack();
        }
        PrizeTinyService prizeTinyService = this.mPrizeTinyService;
        if (prizeTinyService != null) {
            prizeTinyService.closeRecvPcm();
        }
        Handler handler = this.mReadThreadHandler;
        if (handler != null) {
            handler.removeMessages(1);
        }
        try {
            FileOutputStream fileOutputStream = this.mOutputStream;
            if (fileOutputStream != null) {
                fileOutputStream.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
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

    public long getTimestamp() {
        return this.timestamp;
    }

    public String getRecordFilePath() {
        File file = this.mRecordFile;
        return file != null ? file.getAbsolutePath() : "";
    }

    public String getRecordFileName() {
        File file = this.mRecordFile;
        return file != null ? file.getName() : "";
    }

    public void releaseService() {
        this.mPrizeTinyService = null;
    }
}
