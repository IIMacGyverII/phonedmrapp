package com.android.internal.telephony;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import androidx.core.os.EnvironmentCompat;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;

public class SimActivationTracker {
    private static final boolean DBG = true;
    private static final String LOG_TAG = "SAT";
    /* access modifiers changed from: private */
    public static final boolean VDBG = Rlog.isLoggable(LOG_TAG, 2);
    private int mDataActivationState;
    private final LocalLog mDataActivationStateLog = new LocalLog(8);
    private Phone mPhone;
    private final BroadcastReceiver mReceiver;
    private int mVoiceActivationState;
    private final LocalLog mVoiceActivationStateLog = new LocalLog(8);

    private static boolean isValidActivationState(int i) {
        return i == 0 || i == 1 || i == 2 || i == 3 || i == 4;
    }

    private static String toString(int i) {
        return i != 0 ? i != 1 ? i != 2 ? i != 3 ? i != 4 ? "invalid" : "restricted" : "deactivated" : "activated" : "activating" : EnvironmentCompat.MEDIA_UNKNOWN;
    }

    public SimActivationTracker(Phone phone) {
        this.mPhone = phone;
        this.mVoiceActivationState = 0;
        this.mDataActivationState = 0;
        AnonymousClass1 r3 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                if (SimActivationTracker.VDBG) {
                    SimActivationTracker simActivationTracker = SimActivationTracker.this;
                    simActivationTracker.log("action: " + action);
                }
                if ("android.intent.action.SIM_STATE_CHANGED".equals(action) && "ABSENT".equals(intent.getStringExtra("ss"))) {
                    SimActivationTracker.this.log("onSimAbsent, reset activation state to UNKNOWN");
                    SimActivationTracker.this.setVoiceActivationState(0);
                    SimActivationTracker.this.setDataActivationState(0);
                }
            }
        };
        this.mReceiver = r3;
        this.mPhone.getContext().registerReceiver(r3, new IntentFilter("android.intent.action.SIM_STATE_CHANGED"));
    }

    public void setVoiceActivationState(int i) {
        if (!isValidActivationState(i) || 4 == i) {
            throw new IllegalArgumentException("invalid voice activation state: " + i);
        }
        log("setVoiceActivationState=" + i);
        this.mVoiceActivationState = i;
        this.mVoiceActivationStateLog.log(toString(i));
        this.mPhone.notifyVoiceActivationStateChanged(i);
    }

    public void setDataActivationState(int i) {
        if (isValidActivationState(i)) {
            log("setDataActivationState=" + i);
            this.mDataActivationState = i;
            this.mDataActivationStateLog.log(toString(i));
            this.mPhone.notifyDataActivationStateChanged(i);
            return;
        }
        throw new IllegalArgumentException("invalid data activation state: " + i);
    }

    public int getVoiceActivationState() {
        return this.mVoiceActivationState;
    }

    public int getDataActivationState() {
        return this.mDataActivationState;
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(LOG_TAG, "[" + this.mPhone.getPhoneId() + "]" + str);
    }

    private void loge(String str) {
        Rlog.e(LOG_TAG, "[" + this.mPhone.getPhoneId() + "]" + str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        printWriter.println(" mVoiceActivationState Log:");
        indentingPrintWriter.increaseIndent();
        this.mVoiceActivationStateLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        printWriter.println(" mDataActivationState Log:");
        indentingPrintWriter.increaseIndent();
        this.mDataActivationStateLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
    }

    public void dispose() {
        this.mPhone.getContext().unregisterReceiver(this.mReceiver);
    }
}
