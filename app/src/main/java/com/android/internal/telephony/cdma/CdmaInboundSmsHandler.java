package com.android.internal.telephony.cdma;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Message;
import android.os.RemoteCallback;
import android.os.SystemProperties;
import android.telephony.PhoneNumberUtils;
import androidx.core.view.InputDeviceCompat;
import androidx.fragment.app.FragmentTransaction;
import com.android.internal.telephony.HexDump;
import com.android.internal.telephony.InboundSmsHandler;
import com.android.internal.telephony.InboundSmsTracker;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.SmsConstants;
import com.android.internal.telephony.SmsMessageBase;
import com.android.internal.telephony.SmsStorageMonitor;
import com.android.internal.telephony.TelephonyComponentFactory;
import com.android.internal.telephony.WspTypeDecoder;
import com.android.internal.telephony.cdma.sms.BearerData;
import com.android.internal.telephony.cdma.sms.CdmaSmsAddress;
import com.android.internal.telephony.cdma.sms.SmsEnvelope;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import kotlin.UByte;

public class CdmaInboundSmsHandler extends InboundSmsHandler {
    private static final String SCP_TEST_ACTION = "com.android.internal.telephony.cdma.TEST_TRIGGER_SCP_MESSAGE";
    private static final String TEST_ACTION = "com.android.internal.telephony.cdma.TEST_TRIGGER_CELL_BROADCAST";
    private static final boolean TEST_MODE;
    private static CdmaCbTestBroadcastReceiver sTestBroadcastReceiver;
    private static CdmaScpTestBroadcastReceiver sTestScpBroadcastReceiver;
    private final boolean mCheckForDuplicatePortsInOmadmWapPush = Resources.getSystem().getBoolean(17891623);
    private byte[] mLastAcknowledgedSmsFingerprint;
    private byte[] mLastDispatchedSmsFingerprint;
    /* access modifiers changed from: private */
    public RemoteCallback mScpCallback;
    private final CdmaSMSDispatcher mSmsDispatcher;

    private static int resultToCause(int i) {
        if (i == -1 || i == 1) {
            return 0;
        }
        if (i != 3) {
            return i != 4 ? 39 : 4;
        }
        return 35;
    }

    /* access modifiers changed from: protected */
    public boolean is3gpp2() {
        return true;
    }

    static {
        boolean z = false;
        if (SystemProperties.getInt("ro.debuggable", 0) == 1) {
            z = true;
        }
        TEST_MODE = z;
    }

    public CdmaInboundSmsHandler(Context context, SmsStorageMonitor smsStorageMonitor, Phone phone, CdmaSMSDispatcher cdmaSMSDispatcher) {
        super("CdmaInboundSmsHandler", context, smsStorageMonitor, phone);
        this.mSmsDispatcher = cdmaSMSDispatcher;
        phone.mCi.setOnNewCdmaSms(getHandler(), 1, (Object) null);
        this.mCellBroadcastServiceManager.enable();
        this.mScpCallback = new RemoteCallback(new CdmaInboundSmsHandler$$ExternalSyntheticLambda0(this));
        if (TEST_MODE) {
            if (sTestBroadcastReceiver == null) {
                sTestBroadcastReceiver = new CdmaCbTestBroadcastReceiver();
                IntentFilter intentFilter = new IntentFilter();
                intentFilter.addAction(TEST_ACTION);
                context.registerReceiver(sTestBroadcastReceiver, intentFilter, 2);
            }
            if (sTestScpBroadcastReceiver == null) {
                sTestScpBroadcastReceiver = new CdmaScpTestBroadcastReceiver();
                IntentFilter intentFilter2 = new IntentFilter();
                intentFilter2.addAction(SCP_TEST_ACTION);
                context.registerReceiver(sTestScpBroadcastReceiver, intentFilter2, 2);
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$new$0(Bundle bundle) {
        if (bundle == null) {
            loge("SCP results error: missing extras");
            return;
        }
        String string = bundle.getString("sender");
        if (string == null) {
            loge("SCP results error: missing sender extra.");
            return;
        }
        ArrayList parcelableArrayList = bundle.getParcelableArrayList("results");
        if (parcelableArrayList == null) {
            loge("SCP results error: missing results extra.");
            return;
        }
        BearerData bearerData = new BearerData();
        bearerData.messageType = 2;
        bearerData.messageId = SmsMessage.getNextMessageId();
        bearerData.serviceCategoryProgramResults = parcelableArrayList;
        byte[] encode = BearerData.encode(bearerData);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(100);
        DataOutputStream dataOutputStream = new DataOutputStream(byteArrayOutputStream);
        try {
            dataOutputStream.writeInt(4102);
            dataOutputStream.writeInt(0);
            dataOutputStream.writeInt(0);
            CdmaSmsAddress parse = CdmaSmsAddress.parse(PhoneNumberUtils.cdmaCheckAndProcessPlusCodeForSms(string));
            dataOutputStream.write(parse.digitMode);
            dataOutputStream.write(parse.numberMode);
            dataOutputStream.write(parse.ton);
            dataOutputStream.write(parse.numberPlan);
            dataOutputStream.write(parse.numberOfDigits);
            byte[] bArr = parse.origBytes;
            dataOutputStream.write(bArr, 0, bArr.length);
            dataOutputStream.write(0);
            dataOutputStream.write(0);
            dataOutputStream.write(0);
            dataOutputStream.write(encode.length);
            dataOutputStream.write(encode, 0, encode.length);
            this.mPhone.mCi.sendCdmaSms(byteArrayOutputStream.toByteArray(), (Message) null);
        } catch (IOException e) {
            loge("exception creating SCP results PDU", (Throwable) e);
        } catch (Throwable th) {
            try {
                dataOutputStream.close();
            } catch (IOException unused) {
            }
            throw th;
        }
        try {
            dataOutputStream.close();
        } catch (IOException unused2) {
        }
    }

    /* access modifiers changed from: protected */
    public void onQuitting() {
        this.mPhone.mCi.unSetOnNewCdmaSms(getHandler());
        log("unregistered for 3GPP2 SMS");
        super.onQuitting();
    }

    public static CdmaInboundSmsHandler makeInboundSmsHandler(Context context, SmsStorageMonitor smsStorageMonitor, Phone phone, CdmaSMSDispatcher cdmaSMSDispatcher) {
        CdmaInboundSmsHandler makeCdmaInboundSmsHandler = TelephonyComponentFactory.getInstance().inject(CdmaInboundSmsHandler.class.getName()).makeCdmaInboundSmsHandler(context, smsStorageMonitor, phone, cdmaSMSDispatcher);
        makeCdmaInboundSmsHandler.start();
        return makeCdmaInboundSmsHandler;
    }

    /* access modifiers changed from: protected */
    public int dispatchMessageRadioSpecific(SmsMessageBase smsMessageBase, int i) {
        SmsMessage smsMessage = (SmsMessage) smsMessageBase;
        if (1 == smsMessage.getMessageType()) {
            log("Broadcast type message");
            this.mCellBroadcastServiceManager.sendCdmaMessageToHandler(smsMessage);
            return 1;
        }
        byte[] incomingSmsFingerprint = smsMessage.getIncomingSmsFingerprint();
        this.mLastDispatchedSmsFingerprint = incomingSmsFingerprint;
        byte[] bArr = this.mLastAcknowledgedSmsFingerprint;
        if (bArr != null && Arrays.equals(incomingSmsFingerprint, bArr)) {
            return 1;
        }
        smsMessage.parseSms();
        int teleService = smsMessage.getTeleService();
        if (teleService != 65002) {
            if (teleService != 262144) {
                switch (teleService) {
                    case InputDeviceCompat.SOURCE_TOUCHSCREEN:
                    case 4101:
                        if (smsMessage.isStatusReportMessage()) {
                            this.mSmsDispatcher.sendStatusReportMessage(smsMessage);
                            return 1;
                        }
                        break;
                    case FragmentTransaction.TRANSIT_FRAGMENT_FADE:
                        break;
                    case FragmentTransaction.TRANSIT_FRAGMENT_MATCH_ACTIVITY_OPEN:
                        break;
                    case 4102:
                        this.mCellBroadcastServiceManager.sendCdmaScpMessageToHandler(smsMessage, this.mScpCallback);
                        return 1;
                    default:
                        loge("unsupported teleservice 0x" + Integer.toHexString(teleService));
                        return 4;
                }
            }
            handleVoicemailTeleservice(smsMessage, i);
            return 1;
        } else if (!smsMessage.preprocessCdmaFdeaWap()) {
            return 1;
        } else {
            teleService = 4100;
        }
        if (!this.mStorageMonitor.isStorageAvailable() && smsMessage.getMessageClass() != SmsConstants.MessageClass.CLASS_0) {
            return 3;
        }
        if (4100 != teleService) {
            return dispatchNormalMessage(smsMessageBase, i);
        }
        return processCdmaWapPdu(smsMessage.getUserData(), smsMessage.mMessageRef, smsMessage.getOriginatingAddress(), smsMessage.getDisplayOriginatingAddress(), smsMessage.getTimestampMillis(), i);
    }

    /* access modifiers changed from: protected */
    public void acknowledgeLastIncomingSms(boolean z, int i, Message message) {
        int resultToCause = resultToCause(i);
        this.mPhone.mCi.acknowledgeLastIncomingCdmaSms(z, resultToCause, message);
        if (resultToCause == 0) {
            this.mLastAcknowledgedSmsFingerprint = this.mLastDispatchedSmsFingerprint;
        }
        this.mLastDispatchedSmsFingerprint = null;
    }

    private void handleVoicemailTeleservice(SmsMessage smsMessage, int i) {
        int numOfVoicemails = smsMessage.getNumOfVoicemails();
        log("Voicemail count=" + numOfVoicemails);
        if (numOfVoicemails < 0) {
            numOfVoicemails = -1;
        } else if (numOfVoicemails > 99) {
            numOfVoicemails = 99;
        }
        this.mPhone.setVoiceMessageCount(numOfVoicemails);
        addVoicemailSmsToMetrics(i);
    }

    private int processCdmaWapPdu(byte[] bArr, int i, String str, String str2, long j, int i2) {
        byte b;
        byte b2;
        byte[] bArr2 = bArr;
        byte b3 = bArr2[0] & UByte.MAX_VALUE;
        if (b3 != 0) {
            log("Received a WAP SMS which is not WDP. Discard.");
            return 1;
        }
        byte b4 = bArr2[1] & UByte.MAX_VALUE;
        int i3 = 3;
        byte b5 = bArr2[2] & UByte.MAX_VALUE;
        if (b5 >= b4) {
            loge("WDP bad segment #" + b5 + " expecting 0-" + (b4 - 1));
            return 1;
        }
        if (b5 == 0) {
            b2 = (bArr2[4] & UByte.MAX_VALUE) | ((bArr2[3] & UByte.MAX_VALUE) << 8);
            byte b6 = (bArr2[6] & UByte.MAX_VALUE) | ((bArr2[5] & UByte.MAX_VALUE) << 8);
            if (!this.mCheckForDuplicatePortsInOmadmWapPush || !checkDuplicatePortOmadmWapPush(bArr2, 7)) {
                b = b6;
                i3 = 7;
            } else {
                b = b6;
                i3 = 11;
            }
        } else {
            b2 = 0;
            b = 0;
        }
        log("Received WAP PDU. Type = " + b3 + ", originator = " + str + ", src-port = " + b2 + ", dst-port = " + b + ", ID = " + i + ", segment# = " + b5 + '/' + b4);
        byte[] bArr3 = new byte[(bArr2.length - i3)];
        System.arraycopy(bArr2, i3, bArr3, 0, bArr2.length - i3);
        return addTrackerToRawTableAndSendMessage(TelephonyComponentFactory.getInstance().inject(InboundSmsTracker.class.getName()).makeInboundSmsTracker(this.mContext, bArr3, j, b, true, str, str2, i, b5, b4, true, HexDump.toHexString(bArr3), false, this.mPhone.getSubId(), i2), false);
    }

    private static boolean checkDuplicatePortOmadmWapPush(byte[] bArr, int i) {
        int i2 = i + 4;
        int length = bArr.length - i2;
        byte[] bArr2 = new byte[length];
        System.arraycopy(bArr, i2, bArr2, 0, length);
        WspTypeDecoder wspTypeDecoder = new WspTypeDecoder(bArr2);
        if (wspTypeDecoder.decodeUintvarInteger(2) && wspTypeDecoder.decodeContentType(wspTypeDecoder.getDecodedDataLength() + 2)) {
            return WspTypeDecoder.CONTENT_TYPE_B_PUSH_SYNCML_NOTI.equals(wspTypeDecoder.getValueString());
        }
        return false;
    }

    private void addVoicemailSmsToMetrics(int i) {
        this.mMetrics.writeIncomingVoiceMailSms(this.mPhone.getPhoneId(), "3gpp2");
        this.mPhone.getSmsStats().onIncomingSmsVoicemail(true, i);
    }

    private class CdmaCbTestBroadcastReceiver extends InboundSmsHandler.CbTestBroadcastReceiver {
        CdmaCbTestBroadcastReceiver() {
            super(CdmaInboundSmsHandler.TEST_ACTION);
        }

        /* access modifiers changed from: protected */
        public void handleTestAction(Intent intent) {
            SmsEnvelope smsEnvelope = new SmsEnvelope();
            CdmaSmsAddress cdmaSmsAddress = new CdmaSmsAddress();
            cdmaSmsAddress.origBytes = new byte[]{-1};
            smsEnvelope.origAddress = cdmaSmsAddress;
            int intExtra = intent.getIntExtra("service_category", -1);
            smsEnvelope.serviceCategory = intExtra;
            if (intExtra == -1) {
                CdmaInboundSmsHandler.this.log("No service category, ignoring CB test intent");
                return;
            }
            byte[] access$100 = CdmaInboundSmsHandler.this.decodeHexString(intent.getStringExtra("bearer_data_string"));
            smsEnvelope.bearerData = access$100;
            if (access$100 == null) {
                CdmaInboundSmsHandler.this.log("No bearer data, ignoring CB test intent");
                return;
            }
            CdmaInboundSmsHandler.this.mCellBroadcastServiceManager.sendCdmaMessageToHandler(new SmsMessage(new CdmaSmsAddress(), smsEnvelope));
        }
    }

    private class CdmaScpTestBroadcastReceiver extends InboundSmsHandler.CbTestBroadcastReceiver {
        CdmaScpTestBroadcastReceiver() {
            super(CdmaInboundSmsHandler.SCP_TEST_ACTION);
        }

        /* access modifiers changed from: protected */
        public void handleTestAction(Intent intent) {
            SmsEnvelope smsEnvelope = new SmsEnvelope();
            CdmaSmsAddress cdmaSmsAddress = new CdmaSmsAddress();
            cdmaSmsAddress.origBytes = new byte[]{-1};
            smsEnvelope.origAddress = cdmaSmsAddress;
            byte[] access$400 = CdmaInboundSmsHandler.this.decodeHexString(intent.getStringExtra("bearer_data_string"));
            smsEnvelope.bearerData = access$400;
            if (access$400 == null) {
                CdmaInboundSmsHandler.this.log("No bearer data, ignoring SCP test intent");
                return;
            }
            CdmaSmsAddress cdmaSmsAddress2 = new CdmaSmsAddress();
            byte[] access$600 = CdmaInboundSmsHandler.this.decodeHexString(intent.getStringExtra("originating_address_string"));
            cdmaSmsAddress2.origBytes = access$600;
            if (access$600 == null) {
                CdmaInboundSmsHandler.this.log("No address data, ignoring SCP test intent");
                return;
            }
            SmsMessage smsMessage = new SmsMessage(cdmaSmsAddress2, smsEnvelope);
            smsMessage.parseSms();
            CdmaInboundSmsHandler.this.mCellBroadcastServiceManager.sendCdmaScpMessageToHandler(smsMessage, CdmaInboundSmsHandler.this.mScpCallback);
        }
    }
}
