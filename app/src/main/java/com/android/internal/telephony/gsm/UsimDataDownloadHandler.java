package com.android.internal.telephony.gsm;

import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.telephony.PhoneNumberUtils;
import android.telephony.gsm.SmsMessage;
import com.android.internal.telephony.CallFailCause;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.cat.ComprehensionTlvTag;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.uicc.IccIoResult;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UsimServiceTable;
import com.android.telephony.Rlog;
import kotlin.UByte;

public class UsimDataDownloadHandler extends Handler {
    private static final int BER_SMS_PP_DOWNLOAD_TAG = 209;
    private static final int DEV_ID_NETWORK = 131;
    private static final int DEV_ID_UICC = 129;
    private static final int EVENT_SEND_ENVELOPE_RESPONSE = 2;
    private static final int EVENT_START_DATA_DOWNLOAD = 1;
    private static final int EVENT_WRITE_SMS_COMPLETE = 3;
    private static final String TAG = "UsimDataDownloadHandler";
    private final CommandsInterface mCi;
    private final int mPhoneId;

    private static int getEnvelopeBodyLength(int i, int i2) {
        int i3 = i2 + 5 + (i2 > 127 ? 2 : 1);
        return i != 0 ? i3 + 2 + i : i3;
    }

    private static boolean is7bitDcs(int i) {
        return (i & SmsMessage.MAX_USER_DATA_BYTES) == 0 || (i & CallFailCause.DIAL_MODIFIED_TO_USSD) == 240;
    }

    public UsimDataDownloadHandler(CommandsInterface commandsInterface, int i) {
        this.mCi = commandsInterface;
        this.mPhoneId = i;
    }

    /* access modifiers changed from: package-private */
    public int handleUsimDataDownload(UsimServiceTable usimServiceTable, SmsMessage smsMessage, int i) {
        if (usimServiceTable == null || !usimServiceTable.isAvailable(UsimServiceTable.UsimService.DATA_DL_VIA_SMS_PP)) {
            Rlog.d(TAG, "DATA_DL_VIA_SMS_PP service not available, storing message to UICC.");
            this.mCi.writeSmsToSim(3, IccUtils.bytesToHexString(PhoneNumberUtils.networkPortionToCalledPartyBCDWithLength(smsMessage.getServiceCenterAddress())), IccUtils.bytesToHexString(smsMessage.getPdu()), obtainMessage(3));
            addUsimDataDownloadToMetrics(false, i);
            return -1;
        }
        Rlog.d(TAG, "Received SMS-PP data download, sending to UICC.");
        return startDataDownload(smsMessage, i);
    }

    public int startDataDownload(SmsMessage smsMessage, int i) {
        if (sendMessage(obtainMessage(1, i, 0, smsMessage))) {
            return -1;
        }
        Rlog.e(TAG, "startDataDownload failed to send message to start data download.");
        return 2;
    }

    private void handleDataDownload(SmsMessage smsMessage, int i) {
        int i2;
        int i3 = i;
        int dataCodingScheme = smsMessage.getDataCodingScheme();
        int protocolIdentifier = smsMessage.getProtocolIdentifier();
        byte[] pdu = smsMessage.getPdu();
        byte b = pdu[0] & UByte.MAX_VALUE;
        int i4 = b + 1;
        int length = pdu.length - i4;
        int envelopeBodyLength = getEnvelopeBodyLength(b, length);
        int i5 = envelopeBodyLength + 1 + (envelopeBodyLength > 127 ? 2 : 1);
        byte[] bArr = new byte[i5];
        bArr[0] = -47;
        if (envelopeBodyLength > 127) {
            bArr[1] = -127;
            i2 = 2;
        } else {
            i2 = 1;
        }
        int i6 = i2 + 1;
        bArr[i2] = (byte) envelopeBodyLength;
        int i7 = i6 + 1;
        bArr[i6] = (byte) (ComprehensionTlvTag.DEVICE_IDENTITIES.value() | 128);
        int i8 = i7 + 1;
        bArr[i7] = 2;
        int i9 = i8 + 1;
        bArr[i8] = -125;
        int i10 = i9 + 1;
        bArr[i9] = -127;
        if (b != 0) {
            int i11 = i10 + 1;
            bArr[i10] = (byte) ComprehensionTlvTag.ADDRESS.value();
            int i12 = i11 + 1;
            bArr[i11] = (byte) b;
            System.arraycopy(pdu, 1, bArr, i12, b);
            i10 = i12 + b;
        }
        int i13 = i10 + 1;
        bArr[i10] = (byte) (ComprehensionTlvTag.SMS_TPDU.value() | 128);
        if (length > 127) {
            bArr[i13] = -127;
            i13++;
        }
        int i14 = i13 + 1;
        bArr[i13] = (byte) length;
        System.arraycopy(pdu, i4, bArr, i14, length);
        if (i14 + length != i5) {
            Rlog.e(TAG, "startDataDownload() calculated incorrect envelope length, aborting.");
            acknowledgeSmsWithError(255);
            addUsimDataDownloadToMetrics(false, i3);
            return;
        }
        this.mCi.sendEnvelopeWithStatus(IccUtils.bytesToHexString(bArr), obtainMessage(2, new int[]{dataCodingScheme, protocolIdentifier}));
        addUsimDataDownloadToMetrics(true, i3);
    }

    private void sendSmsAckForEnvelopeResponse(IccIoResult iccIoResult, int i, int i2) {
        boolean z;
        byte[] bArr;
        int i3;
        int i4 = iccIoResult.sw1;
        int i5 = iccIoResult.sw2;
        if ((i4 == 144 && i5 == 0) || i4 == 145) {
            Rlog.d(TAG, "USIM data download succeeded: " + iccIoResult.toString());
            z = true;
        } else if (i4 == 147 && i5 == 0) {
            Rlog.e(TAG, "USIM data download failed: Toolkit busy");
            acknowledgeSmsWithError(CommandsInterface.GSM_SMS_FAIL_CAUSE_USIM_APP_TOOLKIT_BUSY);
            return;
        } else {
            if (i4 == 98 || i4 == 99) {
                Rlog.e(TAG, "USIM data download failed: " + iccIoResult.toString());
            } else {
                Rlog.e(TAG, "Unexpected SW1/SW2 response from UICC: " + iccIoResult.toString());
            }
            z = false;
        }
        byte[] bArr2 = iccIoResult.payload;
        if (bArr2 != null && bArr2.length != 0) {
            int i6 = 2;
            if (z) {
                bArr = new byte[(bArr2.length + 5)];
                bArr[0] = 0;
                bArr[1] = 7;
            } else {
                bArr = new byte[(bArr2.length + 6)];
                bArr[0] = 0;
                bArr[1] = -43;
                bArr[2] = 7;
                i6 = 3;
            }
            int i7 = i6 + 1;
            bArr[i6] = (byte) i2;
            int i8 = i7 + 1;
            bArr[i7] = (byte) i;
            if (is7bitDcs(i)) {
                i3 = i8 + 1;
                bArr[i8] = (byte) ((bArr2.length * 8) / 7);
            } else {
                i3 = i8 + 1;
                bArr[i8] = (byte) bArr2.length;
            }
            System.arraycopy(bArr2, 0, bArr, i3, bArr2.length);
            this.mCi.acknowledgeIncomingGsmSmsWithPdu(z, IccUtils.bytesToHexString(bArr), (Message) null);
        } else if (z) {
            this.mCi.acknowledgeLastIncomingGsmSms(true, 0, (Message) null);
        } else {
            acknowledgeSmsWithError(CommandsInterface.GSM_SMS_FAIL_CAUSE_USIM_DATA_DOWNLOAD_ERROR);
        }
    }

    private void acknowledgeSmsWithError(int i) {
        this.mCi.acknowledgeLastIncomingGsmSms(false, i, (Message) null);
    }

    private void addUsimDataDownloadToMetrics(boolean z, int i) {
        TelephonyMetrics.getInstance().writeIncomingSMSPP(this.mPhoneId, "3gpp", z);
        PhoneFactory.getPhone(this.mPhoneId).getSmsStats().onIncomingSmsPP(i, z);
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            handleDataDownload((SmsMessage) message.obj, message.arg1);
        } else if (i == 2) {
            AsyncResult asyncResult = (AsyncResult) message.obj;
            if (asyncResult.exception != null) {
                Rlog.e(TAG, "UICC Send Envelope failure, exception: " + asyncResult.exception);
                acknowledgeSmsWithError(CommandsInterface.GSM_SMS_FAIL_CAUSE_USIM_DATA_DOWNLOAD_ERROR);
                return;
            }
            int[] iArr = (int[]) asyncResult.userObj;
            sendSmsAckForEnvelopeResponse((IccIoResult) asyncResult.result, iArr[0], iArr[1]);
        } else if (i != 3) {
            Rlog.e(TAG, "Ignoring unexpected message, what=" + message.what);
        } else {
            Throwable th = ((AsyncResult) message.obj).exception;
            if (th == null) {
                Rlog.d(TAG, "Successfully wrote SMS-PP message to UICC");
                this.mCi.acknowledgeLastIncomingGsmSms(true, 0, (Message) null);
                return;
            }
            Rlog.d(TAG, "Failed to write SMS-PP message to UICC", th);
            this.mCi.acknowledgeLastIncomingGsmSms(false, 255, (Message) null);
        }
    }
}
