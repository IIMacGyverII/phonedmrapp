package com.pri.prizeinterphone.ymodem;

import android.os.Handler;
/* loaded from: classes4.dex */
class TimeOutHelper {
    private ITimeOut listener;
    private final Handler timeoutHandler = new Handler();
    private final Runnable timer = new Runnable() { // from class: com.pri.prizeinterphone.ymodem.TimeOutHelper.1
        @Override // java.lang.Runnable
        public void run() {
            TimeOutHelper.this.stopTimer();
            if (TimeOutHelper.this.listener != null) {
                TimeOutHelper.this.listener.onTimeOut();
            }
        }
    };

    /* loaded from: classes4.dex */
    public interface ITimeOut {
        void onTimeOut();
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public void startTimer(ITimeOut iTimeOut, long j) {
        this.listener = iTimeOut;
        this.timeoutHandler.postDelayed(this.timer, j);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public void stopTimer() {
        this.timeoutHandler.removeCallbacksAndMessages(null);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public void unRegisterListener() {
        this.listener = null;
    }
}
