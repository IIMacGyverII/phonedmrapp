package com.pri.prizeinterphone.audio;

import android.media.AudioTrack;
import android.os.Process;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
/* loaded from: classes4.dex */
public class PCMAudioPlayer {
    private static final int DEFAULT_AUDIO_FORMAT = 2;
    private static final int DEFAULT_CHANNEL_CONFIG = 12;
    private static final int DEFAULT_PLAY_MODE = 1;
    private static final int DEFAULT_SAMPLE_RATE = 8000;
    private static final int DEFAULT_STREAM_TYPE = 3;
    private static PCMAudioPlayer mInstance;
    private DataInputStream dis;
    private boolean isPlay = false;
    private int mMinBufferSize = AudioTrack.getMinBufferSize(DEFAULT_SAMPLE_RATE, 12, 2);
    private AudioTrack audioTrack = new AudioTrack(3, DEFAULT_SAMPLE_RATE, 12, 2, this.mMinBufferSize * 2, 1);
    private final ExecutorService mExecutorService = Executors.newSingleThreadExecutor();

    public static PCMAudioPlayer getInstance() {
        if (mInstance == null) {
            synchronized (PCMAudioPlayer.class) {
                if (mInstance == null) {
                    mInstance = new PCMAudioPlayer();
                }
            }
        }
        return mInstance;
    }

    private void setPath(String str) throws Exception {
        this.dis = new DataInputStream(new FileInputStream(new File(str)));
    }

    public void startPlay(String str) {
        try {
            setPath(str);
            this.isPlay = true;
            this.mExecutorService.execute(new PlayRunnable());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void stopPlay() {
        try {
            this.isPlay = false;
            AudioTrack audioTrack = this.audioTrack;
            if (audioTrack != null && audioTrack.getState() == 1) {
                this.audioTrack.stop();
            }
            DataInputStream dataInputStream = this.dis;
            if (dataInputStream != null) {
                dataInputStream.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void release() {
        AudioTrack audioTrack = this.audioTrack;
        if (audioTrack != null) {
            audioTrack.release();
        }
        this.mExecutorService.shutdownNow();
    }

    /* loaded from: classes4.dex */
    private class PlayRunnable implements Runnable {
        private PlayRunnable() {
        }

        @Override // java.lang.Runnable
        public void run() {
            try {
                Process.setThreadPriority(-19);
                byte[] bArr = new byte[PCMAudioPlayer.this.mMinBufferSize];
                PCMAudioPlayer.this.audioTrack.play();
                while (PCMAudioPlayer.this.dis.available() > 0 && PCMAudioPlayer.this.isPlay && !PCMAudioPlayer.this.isTalkSend()) {
                    int read = PCMAudioPlayer.this.dis.read(bArr);
                    if (read != -3 && read != -2 && read != 0 && read != -1) {
                        PCMAudioPlayer.this.audioTrack.write(bArr, 0, read);
                    }
                }
                PCMAudioPlayer.this.stopPlay();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean isTalkSend() {
        return PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
    }
}
