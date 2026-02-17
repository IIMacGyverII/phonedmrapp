package com.pri.anim.spring;

import android.os.SystemClock;
import android.view.Choreographer;

class ChoreographerSpringLooper extends SpringLooper {
    /* access modifiers changed from: private */
    public final Choreographer mChoreographer;
    /* access modifiers changed from: private */
    public final Choreographer.FrameCallback mFrameCallback = new Choreographer.FrameCallback() {
        public void doFrame(long j) {
            if (ChoreographerSpringLooper.this.mStarted && ChoreographerSpringLooper.this.mSpringSystem != null) {
                long uptimeMillis = SystemClock.uptimeMillis();
                ChoreographerSpringLooper choreographerSpringLooper = ChoreographerSpringLooper.this;
                choreographerSpringLooper.mSpringSystem.loop((double) (uptimeMillis - choreographerSpringLooper.mLastTime));
                long unused = ChoreographerSpringLooper.this.mLastTime = uptimeMillis;
                ChoreographerSpringLooper.this.mChoreographer.postFrameCallback(ChoreographerSpringLooper.this.mFrameCallback);
            }
        }
    };
    /* access modifiers changed from: private */
    public long mLastTime;
    /* access modifiers changed from: private */
    public boolean mStarted;

    public static ChoreographerSpringLooper create() {
        return new ChoreographerSpringLooper(Choreographer.getInstance());
    }

    public ChoreographerSpringLooper(Choreographer choreographer) {
        this.mChoreographer = choreographer;
    }

    public void start() {
        if (!this.mStarted) {
            this.mStarted = true;
            this.mLastTime = SystemClock.uptimeMillis();
            this.mChoreographer.removeFrameCallback(this.mFrameCallback);
            this.mChoreographer.postFrameCallback(this.mFrameCallback);
        }
    }

    public void stop() {
        this.mStarted = false;
        this.mChoreographer.removeFrameCallback(this.mFrameCallback);
    }
}
