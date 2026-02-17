package com.android.internal.telephony.dataconnection;

import android.content.Intent;
import android.telephony.DataFailCause;
import com.android.telephony.Rlog;

public class DcFailBringUp {
    static final String ACTION_FAIL_BRINGUP = "action_fail_bringup";
    static final String COUNTER = "counter";
    private static final boolean DBG = true;
    static final int DEFAULT_COUNTER = 2;
    static final int DEFAULT_FAIL_CAUSE = 65535;
    static final long DEFAULT_SUGGESTED_RETRY_TIME = -1;
    static final String FAIL_CAUSE = "fail_cause";
    static final String INTENT_BASE = DataConnection.class.getPackage().getName();
    private static final String LOG_TAG = "DcFailBringUp";
    static final String SUGGESTED_RETRY_TIME = "suggested_retry_time";
    int mCounter;
    int mFailCause;
    long mSuggestedRetryTime;

    /* access modifiers changed from: package-private */
    public void saveParameters(Intent intent, String str) {
        log(str + ".saveParameters: action=" + intent.getAction());
        this.mCounter = intent.getIntExtra(COUNTER, 2);
        this.mFailCause = DataFailCause.getFailCause(intent.getIntExtra(FAIL_CAUSE, 65535));
        this.mSuggestedRetryTime = intent.getLongExtra(SUGGESTED_RETRY_TIME, -1);
        log(str + ".saveParameters: " + this);
    }

    public void saveParameters(int i, int i2, long j) {
        this.mCounter = i;
        this.mFailCause = DataFailCause.getFailCause(i2);
        this.mSuggestedRetryTime = j;
    }

    public String toString() {
        return "{mCounter=" + this.mCounter + " mFailCause=" + this.mFailCause + " mSuggestedRetryTime=" + this.mSuggestedRetryTime + "}";
    }

    private static void log(String str) {
        Rlog.d(LOG_TAG, str);
    }
}
