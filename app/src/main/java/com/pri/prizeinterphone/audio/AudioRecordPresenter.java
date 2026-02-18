package com.pri.prizeinterphone.audio;

import android.content.Context;
import android.media.AudioRecord;
import android.os.Environment;
import android.os.Process;
import android.util.Log;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
/* loaded from: classes4.dex */
public class AudioRecordPresenter implements IAudioRecordInterface {
    private static final String FILE_NAME = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC) + File.separator + "test.pcm";
    public static final String TAG = "AudioRecordPresenter";
    private static AudioRecordPresenter presenter;
    private Context context;
    private boolean isRecording;
    private File mLastRecordFile;
    private FileOutputStream mOutputStream;
    private String mRecordFileDir;
    private File mTempRecordFile;
    private Thread recordingThread;
    private AudioRecord mAudioRecord = null;
    private int recordBufsize = 0;
    private int mCurrentId = 0;

    private AudioRecordPresenter() {
    }

    public static AudioRecordPresenter getInstance() {
        if (presenter == null) {
            presenter = new AudioRecordPresenter();
        }
        return presenter;
    }

    public void init(Context context) {
        this.context = context;
    }

    private void createAudioRecord() {
        this.recordBufsize = AudioRecord.getMinBufferSize(44100, 16, 2);
        this.mAudioRecord = new AudioRecord(1, 44100, 16, 2, this.recordBufsize);
    }

    @Override // com.pri.prizeinterphone.audio.IAudioRecordInterface
    public void startRecord(String str) {
        createAudioRecord();
        this.mRecordFileDir = str;
        this.mTempRecordFile = new File(this.mRecordFileDir + "/record.pcm");
        checkEnvirement();
        try {
            this.mOutputStream = new FileOutputStream(this.mTempRecordFile);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        if (this.isRecording) {
            return;
        }
        this.isRecording = true;
        this.mAudioRecord.startRecording();
        Log.i(TAG, "开始录音 mOutputStream=" + this.mOutputStream);
        Thread thread = new Thread(new Runnable() { // from class: com.pri.prizeinterphone.audio.AudioRecordPresenter$$ExternalSyntheticLambda0
            @Override // java.lang.Runnable
            public final void run() {
                AudioRecordPresenter.this.lambda$startRecord$0();
            }
        });
        this.recordingThread = thread;
        thread.start();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public /* synthetic */ void lambda$startRecord$0() {
        Process.setThreadPriority(-19);
        if (this.mAudioRecord.getState() == 0) {
            Log.d(TAG, "startRecord unInit");
            return;
        }
        int i = this.recordBufsize;
        byte[] bArr = new byte[i];
        while (this.isRecording) {
            this.mAudioRecord.read(bArr, 0, i);
            try {
                this.mOutputStream.write(bArr);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        Log.v(TAG, "recording  thread end");
    }

    private void checkEnvirement() {
        File file = new File(this.mRecordFileDir);
        if (!file.exists()) {
            file.mkdir();
        }
        if (this.mTempRecordFile.getParentFile().exists()) {
            return;
        }
        this.mTempRecordFile.getParentFile().mkdirs();
    }

    @Override // com.pri.prizeinterphone.audio.IAudioRecordInterface
    public void stopRecord() {
        this.isRecording = false;
        AudioRecord audioRecord = this.mAudioRecord;
        if (audioRecord != null) {
            audioRecord.stop();
            Log.i(TAG, "停止录音");
            this.mAudioRecord.release();
            this.mAudioRecord = null;
            this.recordingThread = null;
        }
        try {
            this.mOutputStream.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
        String str = this.mRecordFileDir + "/" + simpleDateFormat.format(new Date()) + ".pcm";
        this.mTempRecordFile.renameTo(new File(str));
        Log.i(TAG, "stopRecord: 录音保存在" + str);
        PCMAudioPlayer.getInstance().startPlay(str);
    }
}
