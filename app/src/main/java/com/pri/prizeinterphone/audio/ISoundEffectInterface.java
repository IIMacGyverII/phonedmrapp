package com.pri.prizeinterphone.audio;

import android.content.Context;
import android.media.MediaPlayer;
/* loaded from: classes4.dex */
public interface ISoundEffectInterface {
    public static final int PLAYER_STATE_PAUSE = 2;
    public static final int PLAYER_STATE_PLAY = 1;
    public static final int PLAYER_STATE_STOP = 3;

    void registComplteLisenter(MediaPlayer.OnCompletionListener onCompletionListener);

    void startPlaySound(Context context, int i);

    void stopPlaySound();
}
