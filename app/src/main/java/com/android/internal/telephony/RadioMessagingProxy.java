package com.android.internal.telephony;

import android.hardware.radio.messaging.CdmaBroadcastSmsConfigInfo;
import android.hardware.radio.messaging.CdmaSmsAck;
import android.hardware.radio.messaging.CdmaSmsMessage;
import android.hardware.radio.messaging.CdmaSmsWriteArgs;
import android.hardware.radio.messaging.GsmBroadcastSmsConfigInfo;
import android.hardware.radio.messaging.GsmSmsMessage;
import android.hardware.radio.messaging.IRadioMessaging;
import android.hardware.radio.messaging.ImsSmsMessage;
import android.hardware.radio.messaging.SmsWriteArgs;
import android.os.RemoteException;
import android.telephony.Rlog;
import com.android.internal.telephony.cdma.CdmaSmsBroadcastConfigInfo;
import com.android.internal.telephony.gsm.SmsBroadcastConfigInfo;
import java.util.ArrayList;

public class RadioMessagingProxy extends RadioServiceProxy {
    private static final String TAG = "RadioMessagingProxy";
    private volatile IRadioMessaging mMessagingProxy = null;

    public void setAidl(HalVersion halVersion, IRadioMessaging iRadioMessaging) {
        this.mHalVersion = halVersion;
        this.mMessagingProxy = iRadioMessaging;
        this.mIsAidl = true;
        Rlog.d(TAG, "AIDL initialized");
    }

    public IRadioMessaging getAidl() {
        return this.mMessagingProxy;
    }

    public void clear() {
        super.clear();
        this.mMessagingProxy = null;
    }

    public boolean isEmpty() {
        return this.mRadioProxy == null && this.mMessagingProxy == null;
    }

    public void acknowledgeIncomingGsmSmsWithPdu(int i, boolean z, String str) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.acknowledgeIncomingGsmSmsWithPdu(i, z, str);
            } else {
                this.mRadioProxy.acknowledgeIncomingGsmSmsWithPdu(i, z, str);
            }
        }
    }

    public void acknowledgeLastIncomingCdmaSms(int i, boolean z, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                CdmaSmsAck cdmaSmsAck = new CdmaSmsAck();
                cdmaSmsAck.errorClass = z;
                cdmaSmsAck.smsCauseCode = i2;
                this.mMessagingProxy.acknowledgeLastIncomingCdmaSms(i, cdmaSmsAck);
                return;
            }
            android.hardware.radio.V1_0.CdmaSmsAck cdmaSmsAck2 = new android.hardware.radio.V1_0.CdmaSmsAck();
            cdmaSmsAck2.errorClass = z ^ true ? 1 : 0;
            cdmaSmsAck2.smsCauseCode = i2;
            this.mRadioProxy.acknowledgeLastIncomingCdmaSms(i, cdmaSmsAck2);
        }
    }

    public void acknowledgeLastIncomingGsmSms(int i, boolean z, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.acknowledgeLastIncomingGsmSms(i, z, i2);
            } else {
                this.mRadioProxy.acknowledgeLastIncomingGsmSms(i, z, i2);
            }
        }
    }

    public void deleteSmsOnRuim(int i, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.deleteSmsOnRuim(i, i2);
            } else {
                this.mRadioProxy.deleteSmsOnRuim(i, i2);
            }
        }
    }

    public void deleteSmsOnSim(int i, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.deleteSmsOnSim(i, i2);
            } else {
                this.mRadioProxy.deleteSmsOnSim(i, i2);
            }
        }
    }

    public void getCdmaBroadcastConfig(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.getCdmaBroadcastConfig(i);
            } else {
                this.mRadioProxy.getCdmaBroadcastConfig(i);
            }
        }
    }

    public void getGsmBroadcastConfig(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.getGsmBroadcastConfig(i);
            } else {
                this.mRadioProxy.getGsmBroadcastConfig(i);
            }
        }
    }

    public void getSmscAddress(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.getSmscAddress(i);
            } else {
                this.mRadioProxy.getSmscAddress(i);
            }
        }
    }

    public void reportSmsMemoryStatus(int i, boolean z) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.reportSmsMemoryStatus(i, z);
            } else {
                this.mRadioProxy.reportSmsMemoryStatus(i, z);
            }
        }
    }

    public void responseAcknowledgement() throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.responseAcknowledgement();
            } else {
                this.mRadioProxy.responseAcknowledgement();
            }
        }
    }

    public void sendCdmaSms(int i, byte[] bArr) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.sendCdmaSms(i, RILUtils.convertToHalCdmaSmsMessageAidl(bArr));
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.sendCdmaSms_1_6(i, RILUtils.convertToHalCdmaSmsMessage(bArr));
            } else {
                this.mRadioProxy.sendCdmaSms(i, RILUtils.convertToHalCdmaSmsMessage(bArr));
            }
        }
    }

    public void sendCdmaSmsExpectMore(int i, byte[] bArr) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.sendCdmaSmsExpectMore(i, RILUtils.convertToHalCdmaSmsMessageAidl(bArr));
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.sendCdmaSmsExpectMore_1_6(i, RILUtils.convertToHalCdmaSmsMessage(bArr));
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                this.mRadioProxy.sendCdmaSmsExpectMore(i, RILUtils.convertToHalCdmaSmsMessage(bArr));
            } else {
                this.mRadioProxy.sendCdmaSms(i, RILUtils.convertToHalCdmaSmsMessage(bArr));
            }
        }
    }

    public void sendImsSms(int i, String str, String str2, byte[] bArr, int i2, int i3) throws RemoteException {
        if (!isEmpty()) {
            boolean z = true;
            if (isAidl()) {
                ImsSmsMessage imsSmsMessage = new ImsSmsMessage();
                imsSmsMessage.tech = 0;
                imsSmsMessage.retry = ((byte) i2) >= 1;
                imsSmsMessage.messageRef = i3;
                if (str2 != null) {
                    imsSmsMessage.gsmMessage = new GsmSmsMessage[]{RILUtils.convertToHalGsmSmsMessageAidl(str, str2)};
                    imsSmsMessage.cdmaMessage = new CdmaSmsMessage[0];
                }
                if (bArr != null) {
                    imsSmsMessage.gsmMessage = new GsmSmsMessage[0];
                    imsSmsMessage.cdmaMessage = new CdmaSmsMessage[]{RILUtils.convertToHalCdmaSmsMessageAidl(bArr)};
                }
                this.mMessagingProxy.sendImsSms(i, imsSmsMessage);
                return;
            }
            android.hardware.radio.V1_0.ImsSmsMessage imsSmsMessage2 = new android.hardware.radio.V1_0.ImsSmsMessage();
            imsSmsMessage2.tech = 0;
            if (((byte) i2) < 1) {
                z = false;
            }
            imsSmsMessage2.retry = z;
            imsSmsMessage2.messageRef = i3;
            if (str2 != null) {
                imsSmsMessage2.gsmMessage.add(RILUtils.convertToHalGsmSmsMessage(str, str2));
            }
            if (bArr != null) {
                imsSmsMessage2.cdmaMessage.add(RILUtils.convertToHalCdmaSmsMessage(bArr));
            }
            this.mRadioProxy.sendImsSms(i, imsSmsMessage2);
        }
    }

    public void sendSms(int i, String str, String str2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.sendSms(i, RILUtils.convertToHalGsmSmsMessageAidl(str, str2));
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.sendSms_1_6(i, RILUtils.convertToHalGsmSmsMessage(str, str2));
            } else {
                this.mRadioProxy.sendSms(i, RILUtils.convertToHalGsmSmsMessage(str, str2));
            }
        }
    }

    public void sendSmsExpectMore(int i, String str, String str2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.sendSmsExpectMore(i, RILUtils.convertToHalGsmSmsMessageAidl(str, str2));
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.sendSmsExpectMore_1_6(i, RILUtils.convertToHalGsmSmsMessage(str, str2));
            } else {
                this.mRadioProxy.sendSMSExpectMore(i, RILUtils.convertToHalGsmSmsMessage(str, str2));
            }
        }
    }

    public void setCdmaBroadcastActivation(int i, boolean z) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.setCdmaBroadcastActivation(i, z);
            } else {
                this.mRadioProxy.setCdmaBroadcastActivation(i, z);
            }
        }
    }

    public void setCdmaBroadcastConfig(int i, CdmaSmsBroadcastConfigInfo[] cdmaSmsBroadcastConfigInfoArr) throws RemoteException {
        if (!isEmpty()) {
            int i2 = 0;
            if (isAidl()) {
                ArrayList arrayList = new ArrayList();
                int length = cdmaSmsBroadcastConfigInfoArr.length;
                while (i2 < length) {
                    CdmaSmsBroadcastConfigInfo cdmaSmsBroadcastConfigInfo = cdmaSmsBroadcastConfigInfoArr[i2];
                    for (int fromServiceCategory = cdmaSmsBroadcastConfigInfo.getFromServiceCategory(); fromServiceCategory <= cdmaSmsBroadcastConfigInfo.getToServiceCategory(); fromServiceCategory++) {
                        CdmaBroadcastSmsConfigInfo cdmaBroadcastSmsConfigInfo = new CdmaBroadcastSmsConfigInfo();
                        cdmaBroadcastSmsConfigInfo.serviceCategory = fromServiceCategory;
                        cdmaBroadcastSmsConfigInfo.language = cdmaSmsBroadcastConfigInfo.getLanguage();
                        cdmaBroadcastSmsConfigInfo.selected = cdmaSmsBroadcastConfigInfo.isSelected();
                        arrayList.add(cdmaBroadcastSmsConfigInfo);
                    }
                    i2++;
                }
                this.mMessagingProxy.setCdmaBroadcastConfig(i, (CdmaBroadcastSmsConfigInfo[]) arrayList.stream().toArray(new RadioMessagingProxy$$ExternalSyntheticLambda0()));
                return;
            }
            ArrayList arrayList2 = new ArrayList();
            int length2 = cdmaSmsBroadcastConfigInfoArr.length;
            while (i2 < length2) {
                CdmaSmsBroadcastConfigInfo cdmaSmsBroadcastConfigInfo2 = cdmaSmsBroadcastConfigInfoArr[i2];
                for (int fromServiceCategory2 = cdmaSmsBroadcastConfigInfo2.getFromServiceCategory(); fromServiceCategory2 <= cdmaSmsBroadcastConfigInfo2.getToServiceCategory(); fromServiceCategory2++) {
                    android.hardware.radio.V1_0.CdmaBroadcastSmsConfigInfo cdmaBroadcastSmsConfigInfo2 = new android.hardware.radio.V1_0.CdmaBroadcastSmsConfigInfo();
                    cdmaBroadcastSmsConfigInfo2.serviceCategory = fromServiceCategory2;
                    cdmaBroadcastSmsConfigInfo2.language = cdmaSmsBroadcastConfigInfo2.getLanguage();
                    cdmaBroadcastSmsConfigInfo2.selected = cdmaSmsBroadcastConfigInfo2.isSelected();
                    arrayList2.add(cdmaBroadcastSmsConfigInfo2);
                }
                i2++;
            }
            this.mRadioProxy.setCdmaBroadcastConfig(i, arrayList2);
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ CdmaBroadcastSmsConfigInfo[] lambda$setCdmaBroadcastConfig$0(int i) {
        return new CdmaBroadcastSmsConfigInfo[i];
    }

    public void setGsmBroadcastActivation(int i, boolean z) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.setGsmBroadcastActivation(i, z);
            } else {
                this.mRadioProxy.setGsmBroadcastActivation(i, z);
            }
        }
    }

    public void setGsmBroadcastConfig(int i, SmsBroadcastConfigInfo[] smsBroadcastConfigInfoArr) throws RemoteException {
        if (!isEmpty()) {
            int i2 = 0;
            if (isAidl()) {
                GsmBroadcastSmsConfigInfo[] gsmBroadcastSmsConfigInfoArr = new GsmBroadcastSmsConfigInfo[smsBroadcastConfigInfoArr.length];
                while (i2 < smsBroadcastConfigInfoArr.length) {
                    GsmBroadcastSmsConfigInfo gsmBroadcastSmsConfigInfo = new GsmBroadcastSmsConfigInfo();
                    gsmBroadcastSmsConfigInfo.fromServiceId = smsBroadcastConfigInfoArr[i2].getFromServiceId();
                    gsmBroadcastSmsConfigInfo.toServiceId = smsBroadcastConfigInfoArr[i2].getToServiceId();
                    gsmBroadcastSmsConfigInfo.fromCodeScheme = smsBroadcastConfigInfoArr[i2].getFromCodeScheme();
                    gsmBroadcastSmsConfigInfo.toCodeScheme = smsBroadcastConfigInfoArr[i2].getToCodeScheme();
                    gsmBroadcastSmsConfigInfo.selected = smsBroadcastConfigInfoArr[i2].isSelected();
                    gsmBroadcastSmsConfigInfoArr[i2] = gsmBroadcastSmsConfigInfo;
                    i2++;
                }
                this.mMessagingProxy.setGsmBroadcastConfig(i, gsmBroadcastSmsConfigInfoArr);
                return;
            }
            ArrayList arrayList = new ArrayList();
            while (i2 < smsBroadcastConfigInfoArr.length) {
                android.hardware.radio.V1_0.GsmBroadcastSmsConfigInfo gsmBroadcastSmsConfigInfo2 = new android.hardware.radio.V1_0.GsmBroadcastSmsConfigInfo();
                gsmBroadcastSmsConfigInfo2.fromServiceId = smsBroadcastConfigInfoArr[i2].getFromServiceId();
                gsmBroadcastSmsConfigInfo2.toServiceId = smsBroadcastConfigInfoArr[i2].getToServiceId();
                gsmBroadcastSmsConfigInfo2.fromCodeScheme = smsBroadcastConfigInfoArr[i2].getFromCodeScheme();
                gsmBroadcastSmsConfigInfo2.toCodeScheme = smsBroadcastConfigInfoArr[i2].getToCodeScheme();
                gsmBroadcastSmsConfigInfo2.selected = smsBroadcastConfigInfoArr[i2].isSelected();
                arrayList.add(gsmBroadcastSmsConfigInfo2);
                i2++;
            }
            this.mRadioProxy.setGsmBroadcastConfig(i, arrayList);
        }
    }

    public void setSmscAddress(int i, String str) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mMessagingProxy.setSmscAddress(i, str);
            } else {
                this.mRadioProxy.setSmscAddress(i, str);
            }
        }
    }

    public void writeSmsToRuim(int i, int i2, byte[] bArr) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                CdmaSmsWriteArgs cdmaSmsWriteArgs = new CdmaSmsWriteArgs();
                cdmaSmsWriteArgs.status = RILUtils.convertToHalSmsWriteArgsStatusAidl(i2);
                cdmaSmsWriteArgs.message = RILUtils.convertToHalCdmaSmsMessageAidl(bArr);
                this.mMessagingProxy.writeSmsToRuim(i, cdmaSmsWriteArgs);
                return;
            }
            android.hardware.radio.V1_0.CdmaSmsWriteArgs cdmaSmsWriteArgs2 = new android.hardware.radio.V1_0.CdmaSmsWriteArgs();
            cdmaSmsWriteArgs2.status = RILUtils.convertToHalSmsWriteArgsStatus(i2);
            cdmaSmsWriteArgs2.message = RILUtils.convertToHalCdmaSmsMessage(bArr);
            this.mRadioProxy.writeSmsToRuim(i, cdmaSmsWriteArgs2);
        }
    }

    public void writeSmsToSim(int i, int i2, String str, String str2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                SmsWriteArgs smsWriteArgs = new SmsWriteArgs();
                smsWriteArgs.status = RILUtils.convertToHalSmsWriteArgsStatusAidl(i2);
                smsWriteArgs.smsc = str;
                smsWriteArgs.pdu = str2;
                this.mMessagingProxy.writeSmsToSim(i, smsWriteArgs);
                return;
            }
            android.hardware.radio.V1_0.SmsWriteArgs smsWriteArgs2 = new android.hardware.radio.V1_0.SmsWriteArgs();
            smsWriteArgs2.status = RILUtils.convertToHalSmsWriteArgsStatus(i2);
            smsWriteArgs2.smsc = str;
            smsWriteArgs2.pdu = str2;
            this.mRadioProxy.writeSmsToSim(i, smsWriteArgs2);
        }
    }
}
