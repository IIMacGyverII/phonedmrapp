package com.pri.prizeinterphone.ymodem;

import android.os.Handler;

class TimeOutHelper {
    /* access modifiers changed from: private */
    public ITimeOut listener;
    private final Handler timeoutHandler = new Handler();
    private final Runnable timer = new Runnable() {
        public void run() {
            TimeOutHelper.this.stopTimer();
            if (TimeOutHelper.this.listener != null) {
                TimeOutHelper.this.listener.onTimeOut();
            }
        }
    };

    public interface ITimeOut {
        void onTimeOut();
    }

    TimeOutHelper() {
    }

    /* access modifiers changed from: package-private */
    public void startTimer(ITimeOut iTimeOut, long j) {
        this.listener = iTimeOut;
        this.timeoutHandler.postDelayed(this.timer, j);
    }

    /* access modifiers changed from: package-private */
    public void stopTimer() {
        this.timeoutHandler.removeCallbacksAndMessages((Object) null);
    }

    /* access modifiers changed from: package-private */
    public void unRegisterListener() {
        this.listener = null;
    }
}
