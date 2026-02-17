package com.android.internal.telephony.gsm;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncResult;
import android.os.Message;
import android.os.SystemProperties;
import com.android.internal.telephony.InboundSmsHandler;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.SmsConstants;
import com.android.internal.telephony.SmsHeader;
import com.android.internal.telephony.SmsMessageBase;
import com.android.internal.telephony.SmsStorageMonitor;
import com.android.internal.telephony.VisualVoicemailSmsFilter;

public class GsmInboundSmsHandler extends InboundSmsHandler {
    private static final String TEST_ACTION = "com.android.internal.telephony.gsm.TEST_TRIGGER_CELL_BROADCAST";
    private static final boolean TEST_MODE;
    private static BroadcastReceiver sTestBroadcastReceiver;
    protected final UsimDataDownloadHandler mDataDownloadHandler;

    private static int resultToCause(int i) {
        if (i == -1 || i == 1) {
            return 0;
        }
        return i != 3 ? 255 : 211;
    }

    /* access modifiers changed from: protected */
    public boolean is3gpp2() {
        return false;
    }

    static {
        boolean z = false;
        if (SystemProperties.getInt("ro.debuggable", 0) == 1) {
            z = true;
        }
        TEST_MODE = z;
    }

    protected GsmInboundSmsHandler(Context context, SmsStorageMonitor smsStorageMonitor, Phone phone) {
        super("GsmInboundSmsHandler", context, smsStorageMonitor, phone);
        phone.mCi.setOnNewGsmSms(getHandler(), 1, (Object) null);
        this.mDataDownloadHandler = new UsimDataDownloadHandler(phone.mCi, phone.getPhoneId());
        this.mCellBroadcastServiceManager.enable();
        if (TEST_MODE && sTestBroadcastReceiver == null) {
            sTestBroadcastReceiver = new GsmCbTestBroadcastReceiver();
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(TEST_ACTION);
            context.registerReceiver(sTestBroadcastReceiver, intentFilter, 2);
        }
    }

    private class GsmCbTestBroadcastReceiver extends InboundSmsHandler.CbTestBroadcastReceiver {
        GsmCbTestBroadcastReceiver() {
            super(GsmInboundSmsHandler.TEST_ACTION);
        }

        /* access modifiers changed from: protected */
        public void handleTestAction(Intent intent) {
            byte[] byteArrayExtra = intent.getByteArrayExtra("pdu");
            if (byteArrayExtra == null) {
                byteArrayExtra = GsmInboundSmsHandler.this.decodeHexString(intent.getStringExtra("pdu_string"));
            }
            if (byteArrayExtra == null) {
                GsmInboundSmsHandler.this.log("No pdu or pdu_string extra, ignoring CB test intent");
                return;
            }
            Message obtain = Message.obtain();
            AsyncResult.forMessage(obtain, byteArrayExtra, (Throwable) null);
            GsmInboundSmsHandler.this.mCellBroadcastServiceManager.sendGsmMessageToHandler(obtain);
        }
    }

    /* access modifiers changed from: protected */
    public void onQuitting() {
        this.mPhone.mCi.unSetOnNewGsmSms(getHandler());
        log("unregistered for 3GPP SMS");
        super.onQuitting();
    }

    public static GsmInboundSmsHandler makeInboundSmsHandler(Context context, SmsStorageMonitor smsStorageMonitor, Phone phone) {
        GsmInboundSmsHandler gsmInboundSmsHandler = new GsmInboundSmsHandler(context, smsStorageMonitor, phone);
        gsmInboundSmsHandler.start();
        return gsmInboundSmsHandler;
    }

    /* access modifiers changed from: protected */
    public int dispatchMessageRadioSpecific(SmsMessageBase smsMessageBase, int i) {
        SmsHeader.PortAddrs portAddrs;
        SmsMessage smsMessage = (SmsMessage) smsMessageBase;
        boolean z = false;
        if (smsMessage.isTypeZero()) {
            int i2 = -1;
            SmsHeader userDataHeader = smsMessage.getUserDataHeader();
            if (!(userDataHeader == null || (portAddrs = userDataHeader.portAddrs) == null)) {
                i2 = portAddrs.destPort;
            }
            VisualVoicemailSmsFilter.filter(this.mContext, new byte[][]{smsMessage.getPdu()}, "3gpp", i2, this.mPhone.getSubId());
            log("Received short message type 0, Don't display or store it. Send Ack");
            addSmsTypeZeroToMetrics(i);
            return 1;
        } else if (smsMessage.isUsimDataDownload()) {
            return this.mDataDownloadHandler.handleUsimDataDownload(this.mPhone.getUsimServiceTable(), smsMessage, i);
        } else {
            if (smsMessage.isMWISetMessage()) {
                updateMessageWaitingIndicator(smsMessage.getNumOfVoicemails());
                z = smsMessage.isMwiDontStore();
                StringBuilder sb = new StringBuilder();
                sb.append("Received voice mail indicator set SMS shouldStore=");
                sb.append(!z);
                log(sb.toString());
            } else if (smsMessage.isMWIClearMessage()) {
                updateMessageWaitingIndicator(0);
                z = smsMessage.isMwiDontStore();
                StringBuilder sb2 = new StringBuilder();
                sb2.append("Received voice mail indicator clear SMS shouldStore=");
                sb2.append(!z);
                log(sb2.toString());
            }
            if (z) {
                addVoicemailSmsToMetrics(i);
                return 1;
            } else if (this.mStorageMonitor.isStorageAvailable() || smsMessage.getMessageClass() == SmsConstants.MessageClass.CLASS_0) {
                return dispatchNormalMessage(smsMessageBase, i);
            } else {
                return 3;
            }
        }
    }

    private void updateMessageWaitingIndicator(int i) {
        if (i < 0) {
            i = -1;
        } else if (i > 255) {
            i = 255;
        }
        this.mPhone.setVoiceMessageCount(i);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void acknowledgeLastIncomingSms(boolean z, int i, Message message) {
        this.mPhone.mCi.acknowledgeLastIncomingGsmSms(z, resultToCause(i), message);
    }

    private void addSmsTypeZeroToMetrics(int i) {
        this.mMetrics.writeIncomingSmsTypeZero(this.mPhone.getPhoneId(), "3gpp");
        this.mPhone.getSmsStats().onIncomingSmsTypeZero(i);
    }

    private void addVoicemailSmsToMetrics(int i) {
        this.mMetrics.writeIncomingVoiceMailSms(this.mPhone.getPhoneId(), "3gpp");
        this.mPhone.getSmsStats().onIncomingSmsVoicemail(false, i);
    }
}
