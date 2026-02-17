package com.android.internal.telephony.gsm;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.AsyncResult;
import android.os.Message;
import com.android.internal.telephony.GsmAlphabet;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.SMSDispatcher;
import com.android.internal.telephony.SmsController;
import com.android.internal.telephony.SmsDispatchersController;
import com.android.internal.telephony.SmsHeader;
import com.android.internal.telephony.SmsMessageBase;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.util.SMSDispatcherUtil;
import com.android.telephony.Rlog;
import java.util.HashMap;
import java.util.concurrent.atomic.AtomicReference;

public class GsmSMSDispatcher extends SMSDispatcher {
    private static final String TAG = "GsmSMSDispatcher";
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected GsmInboundSmsHandler mGsmInboundSmsHandler;
    protected AtomicReference<IccRecords> mIccRecords = new AtomicReference<>();
    protected AtomicReference<UiccCardApplication> mUiccApplication = new AtomicReference<>();
    protected UiccController mUiccController = null;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getFormat() {
        return "3gpp";
    }

    /* access modifiers changed from: protected */
    public boolean shouldBlockSmsForEcbm() {
        return false;
    }

    public GsmSMSDispatcher(Phone phone, SmsDispatchersController smsDispatchersController, GsmInboundSmsHandler gsmInboundSmsHandler) {
        super(phone, smsDispatchersController);
        this.mCi.setOnSmsStatus(this, 10, (Object) null);
        this.mGsmInboundSmsHandler = gsmInboundSmsHandler;
        UiccController instance = UiccController.getInstance();
        this.mUiccController = instance;
        instance.registerForIccChanged(this, 15, (Object) null);
        Rlog.d(TAG, "GsmSMSDispatcher created");
    }

    public void dispose() {
        super.dispose();
        this.mCi.unSetOnSmsStatus(this);
        this.mUiccController.unregisterForIccChanged(this);
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 14) {
            this.mGsmInboundSmsHandler.sendMessage(1, message.obj);
        } else if (i != 15) {
            super.handleMessage(message);
        } else {
            onUpdateIccAvailability();
        }
    }

    /* access modifiers changed from: protected */
    public SmsMessageBase.SubmitPduBase getSubmitPdu(String str, String str2, String str3, boolean z, SmsHeader smsHeader, int i, int i2) {
        return SMSDispatcherUtil.getSubmitPduGsm(str, str2, str3, z, i2);
    }

    /* access modifiers changed from: protected */
    public SmsMessageBase.SubmitPduBase getSubmitPdu(String str, String str2, int i, byte[] bArr, boolean z) {
        return SMSDispatcherUtil.getSubmitPduGsm(str, str2, i, bArr, z);
    }

    /* access modifiers changed from: protected */
    public GsmAlphabet.TextEncodingDetails calculateLength(CharSequence charSequence, boolean z) {
        return SMSDispatcherUtil.calculateLengthGsm(charSequence, z);
    }

    /* access modifiers changed from: protected */
    public void handleStatusReport(Object obj) {
        if (obj instanceof AsyncResult) {
            this.mSmsDispatchersController.handleSmsStatusReport("3gpp", (byte[]) ((AsyncResult) obj).result);
            this.mCi.acknowledgeLastIncomingGsmSms(true, 0, (Message) null);
            return;
        }
        Rlog.e(TAG, "handleStatusReport() called for object type " + obj.getClass().getName());
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public void sendSms(SMSDispatcher.SmsTracker smsTracker) {
        int state = this.mPhone.getServiceState().getState();
        Rlog.d(TAG, "sendSms:  isIms()=" + isIms() + " mRetryCount=" + smsTracker.mRetryCount + " mImsRetry=" + smsTracker.mImsRetry + " mMessageRef=" + smsTracker.mMessageRef + " mUsesImsServiceForIms=" + smsTracker.mUsesImsServiceForIms + " SS=" + state + " " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
        if (isIms() || state == 0 || this.mPhone.getServiceState().getRilDataRadioTechnology() == 20) {
            Message obtainMessage = obtainMessage(2, smsTracker);
            HashMap<String, Object> data = smsTracker.getData();
            byte[] bArr = (byte[]) data.get("pdu");
            byte[] bArr2 = (byte[]) data.get("smsc");
            if (smsTracker.mRetryCount > 0) {
                byte b = bArr[0];
                if ((b & 1) == 1) {
                    bArr[0] = (byte) (b | 4);
                    bArr[1] = (byte) smsTracker.mMessageRef;
                }
            }
            if ((smsTracker.mImsRetry != 0 || isIms()) && !smsTracker.mUsesImsServiceForIms) {
                this.mCi.sendImsGsmSms(IccUtils.bytesToHexString(bArr2), IccUtils.bytesToHexString(bArr), smsTracker.mImsRetry, smsTracker.mMessageRef, obtainMessage);
                smsTracker.mImsRetry++;
            } else if (smsTracker.mRetryCount != 0 || !smsTracker.mExpectMore) {
                this.mCi.sendSMS(IccUtils.bytesToHexString(bArr2), IccUtils.bytesToHexString(bArr), obtainMessage);
            } else {
                this.mCi.sendSMSExpectMore(IccUtils.bytesToHexString(bArr2), IccUtils.bytesToHexString(bArr), obtainMessage);
            }
        } else {
            smsTracker.onFailed(this.mContext, SMSDispatcher.getNotInServiceError(state), -1);
        }
    }

    /* access modifiers changed from: protected */
    public UiccCardApplication getUiccCardApplication() {
        Rlog.d(TAG, "GsmSMSDispatcher: subId = " + this.mPhone.getSubId() + " slotId = " + this.mPhone.getPhoneId());
        return this.mUiccController.getUiccCardApplication(this.mPhone.getPhoneId(), 1);
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:3:0x0005, code lost:
        r0 = getUiccCardApplication();
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onUpdateIccAvailability() {
        /*
            r4 = this;
            com.android.internal.telephony.uicc.UiccController r0 = r4.mUiccController
            if (r0 != 0) goto L_0x0005
            return
        L_0x0005:
            com.android.internal.telephony.uicc.UiccCardApplication r0 = r4.getUiccCardApplication()
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.UiccCardApplication> r1 = r4.mUiccApplication
            java.lang.Object r1 = r1.get()
            com.android.internal.telephony.uicc.UiccCardApplication r1 = (com.android.internal.telephony.uicc.UiccCardApplication) r1
            if (r1 == r0) goto L_0x0064
            java.lang.String r2 = "GsmSMSDispatcher"
            r3 = 0
            if (r1 == 0) goto L_0x003a
            java.lang.String r1 = "Removing stale icc objects."
            com.android.telephony.Rlog.d(r2, r1)
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r1 = r4.mIccRecords
            java.lang.Object r1 = r1.get()
            if (r1 == 0) goto L_0x0030
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r1 = r4.mIccRecords
            java.lang.Object r1 = r1.get()
            com.android.internal.telephony.uicc.IccRecords r1 = (com.android.internal.telephony.uicc.IccRecords) r1
            r1.unregisterForNewSms(r4)
        L_0x0030:
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r1 = r4.mIccRecords
            r1.set(r3)
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.UiccCardApplication> r1 = r4.mUiccApplication
            r1.set(r3)
        L_0x003a:
            if (r0 == 0) goto L_0x0064
            java.lang.String r1 = "New Uicc application found"
            com.android.telephony.Rlog.d(r2, r1)
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.UiccCardApplication> r1 = r4.mUiccApplication
            r1.set(r0)
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r1 = r4.mIccRecords
            com.android.internal.telephony.uicc.IccRecords r0 = r0.getIccRecords()
            r1.set(r0)
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r0 = r4.mIccRecords
            java.lang.Object r0 = r0.get()
            if (r0 == 0) goto L_0x0064
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r0 = r4.mIccRecords
            java.lang.Object r0 = r0.get()
            com.android.internal.telephony.uicc.IccRecords r0 = (com.android.internal.telephony.uicc.IccRecords) r0
            r1 = 14
            r0.registerForNewSms(r4, r1, r3)
        L_0x0064:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.gsm.GsmSMSDispatcher.onUpdateIccAvailability():void");
    }
}
