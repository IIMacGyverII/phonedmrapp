package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.telephony.SubscriptionManager;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;

public class SmsStorageMonitor extends Handler {
    private static final int EVENT_ICC_FULL = 1;
    protected static final int EVENT_RADIO_ON = 3;
    protected static final int EVENT_REPORT_MEMORY_STATUS_DONE = 2;
    private static final String TAG = "SmsStorageMonitor";
    protected static final int WAKE_LOCK_TIMEOUT = 5000;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final CommandsInterface mCi;
    protected final Context mContext;
    protected Phone mPhone;
    private boolean mReportMemoryStatusPending;
    private final BroadcastReceiver mResultReceiver;
    protected boolean mStorageAvailable = true;
    protected PowerManager.WakeLock mWakeLock;

    public SmsStorageMonitor(Phone phone) {
        AnonymousClass1 r1 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if (intent.getAction().equals("android.intent.action.DEVICE_STORAGE_FULL")) {
                    SmsStorageMonitor smsStorageMonitor = SmsStorageMonitor.this;
                    smsStorageMonitor.mStorageAvailable = false;
                    smsStorageMonitor.mCi.reportSmsMemoryStatus(false, smsStorageMonitor.obtainMessage(2));
                } else if (intent.getAction().equals("android.intent.action.DEVICE_STORAGE_NOT_FULL")) {
                    SmsStorageMonitor smsStorageMonitor2 = SmsStorageMonitor.this;
                    smsStorageMonitor2.mStorageAvailable = true;
                    smsStorageMonitor2.mCi.reportSmsMemoryStatus(true, smsStorageMonitor2.obtainMessage(2));
                }
            }
        };
        this.mResultReceiver = r1;
        this.mPhone = phone;
        Context context = phone.getContext();
        this.mContext = context;
        CommandsInterface commandsInterface = phone.mCi;
        this.mCi = commandsInterface;
        createWakelock();
        commandsInterface.setOnIccSmsFull(this, 1, (Object) null);
        commandsInterface.registerForOn(this, 3, (Object) null);
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.intent.action.DEVICE_STORAGE_FULL");
        intentFilter.addAction("android.intent.action.DEVICE_STORAGE_NOT_FULL");
        context.registerReceiver(r1, intentFilter);
    }

    public void dispose() {
        this.mCi.unSetOnIccSmsFull(this);
        this.mCi.unregisterForOn(this);
        this.mContext.unregisterReceiver(this.mResultReceiver);
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            handleIccFull();
        } else if (i != 2) {
            if (i == 3 && this.mReportMemoryStatusPending) {
                Rlog.v(TAG, "Sending pending memory status report : mStorageAvailable = " + this.mStorageAvailable);
                this.mCi.reportSmsMemoryStatus(this.mStorageAvailable, obtainMessage(2));
            }
        } else if (((AsyncResult) message.obj).exception != null) {
            this.mReportMemoryStatusPending = true;
            Rlog.v(TAG, "Memory status report to modem pending : mStorageAvailable = " + this.mStorageAvailable);
        } else {
            this.mReportMemoryStatusPending = false;
        }
    }

    private void createWakelock() {
        PowerManager.WakeLock newWakeLock = ((PowerManager) this.mContext.getSystemService(XmlTagConst.TAG_POWER)).newWakeLock(1, TAG);
        this.mWakeLock = newWakeLock;
        newWakeLock.setReferenceCounted(true);
    }

    public void handleIccFull() {
        Intent intent = new Intent("android.provider.Telephony.SIM_FULL");
        intent.setComponent(SmsApplication.getDefaultSimFullApplication(this.mContext, false));
        this.mWakeLock.acquire(5000);
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, this.mPhone.getPhoneId());
        this.mContext.sendBroadcast(intent, "android.permission.RECEIVE_SMS");
    }

    public boolean isStorageAvailable() {
        return this.mStorageAvailable;
    }
}
