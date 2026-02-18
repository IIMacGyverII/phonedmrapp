package com.pri.anim.spring;

import android.os.SystemClock;
import android.view.Choreographer;
/* loaded from: classes4.dex */
class ChoreographerSpringLooper extends SpringLooper {
    private final Choreographer mChoreographer;
    private final Choreographer.FrameCallback mFrameCallback = new Choreographer.FrameCallback() { // from class: com.pri.anim.spring.ChoreographerSpringLooper.1
        @Override // android.view.Choreographer.FrameCallback
        public void doFrame(long j) {
            if (!ChoreographerSpringLooper.this.mStarted || ChoreographerSpringLooper.this.mSpringSystem == null) {
                return;
            }
            long uptimeMillis = SystemClock.uptimeMillis();
            ChoreographerSpringLooper choreographerSpringLooper = ChoreographerSpringLooper.this;
            choreographerSpringLooper.mSpringSystem.loop(uptimeMillis - choreographerSpringLooper.mLastTime);
            ChoreographerSpringLooper.this.mLastTime = uptimeMillis;
            ChoreographerSpringLooper.this.mChoreographer.postFrameCallback(ChoreographerSpringLooper.this.mFrameCallback);
        }
    };
    private long mLastTime;
    private boolean mStarted;

    public static ChoreographerSpringLooper create() {
        return new ChoreographerSpringLooper(Choreographer.getInstance());
    }

    public ChoreographerSpringLooper(Choreographer choreographer) {
        this.mChoreographer = choreographer;
    }

    @Override // com.pri.anim.spring.SpringLooper
    public void start() {
        if (this.mStarted) {
            return;
        }
        this.mStarted = true;
        this.mLastTime = SystemClock.uptimeMillis();
        this.mChoreographer.removeFrameCallback(this.mFrameCallback);
        this.mChoreographer.postFrameCallback(this.mFrameCallback);
    }

    @Override // com.pri.anim.spring.SpringLooper
    public void stop() {
        this.mStarted = false;
        this.mChoreographer.removeFrameCallback(this.mFrameCallback);
    }
}
