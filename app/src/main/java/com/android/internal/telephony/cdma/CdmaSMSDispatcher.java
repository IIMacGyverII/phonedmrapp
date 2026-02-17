package com.android.internal.telephony.cdma;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.Message;
import com.android.internal.telephony.GsmAlphabet;
import com.android.internal.telephony.GsmCdmaPhone;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.SMSDispatcher;
import com.android.internal.telephony.SmsController;
import com.android.internal.telephony.SmsDispatchersController;
import com.android.internal.telephony.SmsHeader;
import com.android.internal.telephony.SmsMessageBase;
import com.android.internal.telephony.util.SMSDispatcherUtil;
import com.android.telephony.Rlog;

public class CdmaSMSDispatcher extends SMSDispatcher {
    private static final String TAG = "CdmaSMSDispatcher";
    private static final boolean VDBG = false;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getFormat() {
        return "3gpp2";
    }

    public CdmaSMSDispatcher(Phone phone, SmsDispatchersController smsDispatchersController) {
        super(phone, smsDispatchersController);
        Rlog.d(TAG, "CdmaSMSDispatcher created");
    }

    public void sendStatusReportMessage(SmsMessage smsMessage) {
        sendMessage(obtainMessage(10, smsMessage));
    }

    /* access modifiers changed from: protected */
    public void handleStatusReport(Object obj) {
        if (obj instanceof SmsMessage) {
            this.mSmsDispatchersController.handleSmsStatusReport("3gpp2", ((SmsMessage) obj).getPdu());
            return;
        }
        Rlog.e(TAG, "handleStatusReport() called for object type " + obj.getClass().getName());
    }

    /* access modifiers changed from: protected */
    public boolean shouldBlockSmsForEcbm() {
        return this.mPhone.isInEcm() && isCdmaMo() && !isIms();
    }

    /* access modifiers changed from: protected */
    public SmsMessageBase.SubmitPduBase getSubmitPdu(String str, String str2, String str3, boolean z, SmsHeader smsHeader, int i, int i2) {
        return SMSDispatcherUtil.getSubmitPduCdma(str, str2, str3, z, smsHeader, i);
    }

    /* access modifiers changed from: protected */
    public SmsMessageBase.SubmitPduBase getSubmitPdu(String str, String str2, int i, byte[] bArr, boolean z) {
        return SMSDispatcherUtil.getSubmitPduCdma(str, str2, i, bArr, z);
    }

    /* access modifiers changed from: protected */
    public GsmAlphabet.TextEncodingDetails calculateLength(CharSequence charSequence, boolean z) {
        return SMSDispatcherUtil.calculateLengthCdma(charSequence, z);
    }

    public void sendSms(SMSDispatcher.SmsTracker smsTracker) {
        int state = this.mPhone.getServiceState().getState();
        Rlog.d(TAG, "sendSms:  isIms()=" + isIms() + " mRetryCount=" + smsTracker.mRetryCount + " mImsRetry=" + smsTracker.mImsRetry + " mMessageRef=" + smsTracker.mMessageRef + " mUsesImsServiceForIms=" + smsTracker.mUsesImsServiceForIms + " SS=" + state + " " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
        if (isIms() || state == 0) {
            Message obtainMessage = obtainMessage(2, smsTracker);
            byte[] bArr = (byte[]) smsTracker.getData().get("pdu");
            int dataNetworkType = this.mPhone.getServiceState().getDataNetworkType();
            boolean z = (dataNetworkType == 14 || ((dataNetworkType == 13 || dataNetworkType == 19 || dataNetworkType == 20) && !this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed())) && this.mPhone.getServiceState().getVoiceNetworkType() == 7 && ((GsmCdmaPhone) this.mPhone).mCT.mState != PhoneConstants.State.IDLE;
            if ((smsTracker.mImsRetry != 0 || isIms()) && !z && !smsTracker.mUsesImsServiceForIms) {
                this.mCi.sendImsCdmaSms(bArr, smsTracker.mImsRetry, smsTracker.mMessageRef, obtainMessage);
                smsTracker.mImsRetry++;
            } else if (smsTracker.mRetryCount != 0 || !smsTracker.mExpectMore) {
                this.mCi.sendCdmaSms(bArr, obtainMessage);
            } else {
                this.mCi.sendCdmaSMSExpectMore(bArr, obtainMessage);
            }
        } else {
            smsTracker.onFailed(this.mContext, SMSDispatcher.getNotInServiceError(state), -1);
        }
    }
}
