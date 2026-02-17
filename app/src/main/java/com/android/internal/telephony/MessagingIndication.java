package com.android.internal.telephony;

import android.hardware.radio.messaging.CdmaSmsMessage;
import android.hardware.radio.messaging.IRadioMessagingIndication;
import android.os.AsyncResult;
import android.telephony.SmsMessage;
import androidx.core.view.PointerIconCompat;
import com.android.internal.telephony.uicc.IccUtils;

public class MessagingIndication extends IRadioMessagingIndication.Stub {
    private final RIL mRil;

    public String getInterfaceHash() {
        return "5237ec5f500627b6b844b155e356e603157f9ba6";
    }

    public int getInterfaceVersion() {
        return 1;
    }

    public MessagingIndication(RIL ril) {
        this.mRil = ril;
    }

    public void cdmaNewSms(int i, CdmaSmsMessage cdmaSmsMessage) {
        this.mRil.processIndication(2, i);
        this.mRil.unsljLog(PointerIconCompat.TYPE_GRAB);
        SmsMessage smsMessage = new SmsMessage(RILUtils.convertHalCdmaSmsMessage(cdmaSmsMessage));
        Registrant registrant = this.mRil.mCdmaSmsRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, smsMessage, (Throwable) null));
        }
    }

    public void cdmaRuimSmsStorageFull(int i) {
        this.mRil.processIndication(2, i);
        this.mRil.unsljLog(1022);
        Registrant registrant = this.mRil.mIccSmsFullRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant();
        }
    }

    public void newBroadcastSms(int i, byte[] bArr) {
        this.mRil.processIndication(2, i);
        this.mRil.unsljLogvRet(PointerIconCompat.TYPE_GRABBING, IccUtils.bytesToHexString(bArr));
        Registrant registrant = this.mRil.mGsmBroadcastSmsRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, bArr, (Throwable) null));
        }
    }

    public void newSms(int i, byte[] bArr) {
        SmsMessage smsMessage;
        this.mRil.processIndication(2, i);
        this.mRil.unsljLog(1003);
        com.android.internal.telephony.gsm.SmsMessage createFromPdu = com.android.internal.telephony.gsm.SmsMessage.createFromPdu(bArr);
        Registrant registrant = this.mRil.mGsmSmsRegistrant;
        if (registrant != null) {
            if (createFromPdu == null) {
                smsMessage = null;
            } else {
                smsMessage = new SmsMessage(createFromPdu);
            }
            registrant.notifyRegistrant(new AsyncResult((Object) null, smsMessage, (Throwable) null));
        }
    }

    public void newSmsOnSim(int i, int i2) {
        this.mRil.processIndication(2, i);
        this.mRil.unsljLog(1005);
        Registrant registrant = this.mRil.mSmsOnSimRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, Integer.valueOf(i2), (Throwable) null));
        }
    }

    public void newSmsStatusReport(int i, byte[] bArr) {
        this.mRil.processIndication(2, i);
        this.mRil.unsljLog(1004);
        Registrant registrant = this.mRil.mSmsStatusRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, bArr, (Throwable) null));
        }
    }

    public void simSmsStorageFull(int i) {
        this.mRil.processIndication(2, i);
        this.mRil.unsljLog(PointerIconCompat.TYPE_TOP_RIGHT_DIAGONAL_DOUBLE_ARROW);
        Registrant registrant = this.mRil.mIccSmsFullRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant();
        }
    }
}
