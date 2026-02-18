package com.pri.prizeinterphone.audio;

import android.content.Context;
import android.media.MediaPlayer;
import android.util.Log;
/* loaded from: classes4.dex */
public class SoundEffectPresenter implements ISoundEffectInterface {
    public static final String TAG = "SoundEffectPresenter";
    private static SoundEffectPresenter presenter;
    private int currentState = 3;
    private int mCurrentId = 0;
    public MediaPlayer mMediaPlayer;
    private MediaPlayer.OnCompletionListener mOnCompletionListener;

    private SoundEffectPresenter() {
    }

    public static SoundEffectPresenter getInstance() {
        if (presenter == null) {
            presenter = new SoundEffectPresenter();
        }
        return presenter;
    }

    @Override // com.pri.prizeinterphone.audio.ISoundEffectInterface
    public void registComplteLisenter(MediaPlayer.OnCompletionListener onCompletionListener) {
        this.mOnCompletionListener = onCompletionListener;
    }

    @Override // com.pri.prizeinterphone.audio.ISoundEffectInterface
    public void startPlaySound(Context context, int i) {
        Log.i(TAG, "playOrPause: " + i);
        int i2 = this.currentState;
        if (i2 == 3) {
            Log.i(TAG, "playOrPause: play new music");
            MediaPlayer create = MediaPlayer.create(context, i);
            this.mMediaPlayer = create;
            create.setAudioStreamType(3);
            this.mMediaPlayer.setLooping(false);
            this.mMediaPlayer.start();
            MediaPlayer.OnCompletionListener onCompletionListener = this.mOnCompletionListener;
            if (onCompletionListener != null) {
                this.mMediaPlayer.setOnCompletionListener(onCompletionListener);
            }
            this.mCurrentId = i;
            this.currentState = 1;
        } else if (i2 == 1) {
            if (this.mCurrentId != i) {
                Log.i(TAG, "playOrPause: stop music");
                stopPlaySound();
                startPlaySound(context, i);
                return;
            }
            Log.i(TAG, "playOrPause: pause music");
            this.mMediaPlayer.pause();
            this.currentState = 2;
        } else if (i2 != 2 || this.mMediaPlayer == null) {
        } else {
            if (this.mCurrentId != i) {
                stopPlaySound();
                startPlaySound(context, i);
                return;
            }
            Log.i(TAG, "playOrPause: restart music");
            this.mMediaPlayer.start();
            this.currentState = 1;
        }
    }

    @Override // com.pri.prizeinterphone.audio.ISoundEffectInterface
    public void stopPlaySound() {
        MediaPlayer mediaPlayer = this.mMediaPlayer;
        if (mediaPlayer != null) {
            mediaPlayer.stop();
            this.currentState = 3;
            this.mMediaPlayer.release();
            this.mMediaPlayer = null;
        }
    }
}
