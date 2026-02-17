package com.android.internal.telephony.uicc;

import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import com.android.internal.telephony.uicc.UiccCarrierPrivilegeRules;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class UiccPkcs15 extends Handler {
    private static final String ACRF_PATH = "4300";
    public static final String AC_OID = "060A2A864886FC6B81480101";
    private static final String CARRIER_RULE_AID = "FFFFFFFFFFFF";
    private static final boolean DBG = true;
    private static final String EFODF_PATH = "5031";
    private static final int EVENT_CLOSE_LOGICAL_CHANNEL_DONE = 7;
    private static final int EVENT_LOAD_ACCF_DONE = 6;
    private static final int EVENT_LOAD_ACMF_DONE = 4;
    private static final int EVENT_LOAD_ACRF_DONE = 5;
    private static final int EVENT_LOAD_DODF_DONE = 3;
    private static final int EVENT_LOAD_ODF_DONE = 2;
    private static final int EVENT_SELECT_PKCS15_DONE = 1;
    private static final String LOG_TAG = "UiccPkcs15";
    private static final String REFRESH_TAG_LEN = "08";
    private static final String TAG_ASN_OCTET_STRING = "04";
    private static final String TAG_ASN_OID = "06";
    private static final String TAG_ASN_SEQUENCE = "30";
    private static final String TAG_DODF = "A1";
    private static final String TAG_ODF = "A7";
    private static final String TAG_TARGET_AID = "A0";
    /* access modifiers changed from: private */
    public int mChannelId = -1;
    private FileHandler mFh;
    private Message mLoadedCallback;
    private Pkcs15Selector mPkcs15Selector;
    private List<String> mRules = null;
    /* access modifiers changed from: private */
    public UiccProfile mUiccProfile;

    private class FileHandler extends Handler {
        protected static final int EVENT_READ_BINARY_DONE = 102;
        protected static final int EVENT_SELECT_FILE_DONE = 101;
        private Message mCallback;
        private String mFileId;
        final String mPkcs15Path;

        public FileHandler(String str) {
            UiccPkcs15.log("Creating FileHandler, pkcs15Path: " + str);
            this.mPkcs15Path = str;
        }

        public boolean loadFile(String str, Message message) {
            UiccPkcs15.log("loadFile: " + str);
            if (str == null || message == null) {
                return false;
            }
            this.mFileId = str;
            this.mCallback = message;
            selectFile();
            return true;
        }

        private void selectFile() {
            if (UiccPkcs15.this.mChannelId >= 0) {
                UiccPkcs15.this.mUiccProfile.iccTransmitApduLogicalChannel(UiccPkcs15.this.mChannelId, 0, 164, 0, 4, 2, this.mFileId, obtainMessage(101));
            } else {
                UiccPkcs15.log("EF based");
            }
        }

        private void readBinary() {
            if (UiccPkcs15.this.mChannelId >= 0) {
                UiccPkcs15.this.mUiccProfile.iccTransmitApduLogicalChannel(UiccPkcs15.this.mChannelId, 0, 176, 0, 0, 0, "", obtainMessage(102));
            } else {
                UiccPkcs15.log("EF based");
            }
        }

        public void handleMessage(Message message) {
            Object obj;
            UiccPkcs15.log("handleMessage: " + message.what);
            AsyncResult asyncResult = (AsyncResult) message.obj;
            IccException iccException = null;
            if (asyncResult.exception != null || (obj = asyncResult.result) == null) {
                UiccPkcs15.log("Error: " + asyncResult.exception);
                AsyncResult.forMessage(this.mCallback, (Object) null, asyncResult.exception);
                this.mCallback.sendToTarget();
                return;
            }
            int i = message.what;
            if (i == 101) {
                readBinary();
            } else if (i != 102) {
                UiccPkcs15.log("Unknown event" + message.what);
            } else {
                IccIoResult iccIoResult = (IccIoResult) obj;
                String upperCase = IccUtils.bytesToHexString(iccIoResult.payload).toUpperCase(Locale.US);
                UiccPkcs15.log("IccIoResult: " + iccIoResult + " payload: " + upperCase);
                Message message2 = this.mCallback;
                if (upperCase == null) {
                    iccException = new IccException("Error: null response for " + this.mFileId);
                }
                AsyncResult.forMessage(message2, upperCase, iccException);
                this.mCallback.sendToTarget();
            }
        }
    }

    private class Pkcs15Selector extends Handler {
        private static final int EVENT_OPEN_LOGICAL_CHANNEL_DONE = 201;
        private static final String PKCS15_AID = "A000000063504B43532D3135";
        private Message mCallback;

        public Pkcs15Selector(Message message) {
            this.mCallback = message;
            UiccPkcs15.this.mUiccProfile.iccOpenLogicalChannel(PKCS15_AID, 4, obtainMessage(EVENT_OPEN_LOGICAL_CHANNEL_DONE));
        }

        public void handleMessage(Message message) {
            Object obj;
            UiccPkcs15.log("handleMessage: " + message.what);
            if (message.what != EVENT_OPEN_LOGICAL_CHANNEL_DONE) {
                UiccPkcs15.log("Unknown event" + message.what);
                return;
            }
            AsyncResult asyncResult = (AsyncResult) message.obj;
            if (asyncResult.exception != null || (obj = asyncResult.result) == null) {
                UiccPkcs15.log("error: " + asyncResult.exception);
                AsyncResult.forMessage(this.mCallback, (Object) null, asyncResult.exception);
            } else {
                UiccPkcs15.this.mChannelId = ((int[]) obj)[0];
                UiccPkcs15.log("mChannelId: " + UiccPkcs15.this.mChannelId);
                AsyncResult.forMessage(this.mCallback, (Object) null, (Throwable) null);
            }
            this.mCallback.sendToTarget();
        }
    }

    public UiccPkcs15(UiccProfile uiccProfile, Message message) {
        log("Creating UiccPkcs15");
        this.mUiccProfile = uiccProfile;
        this.mLoadedCallback = message;
        this.mPkcs15Selector = new Pkcs15Selector(obtainMessage(1));
    }

    public void handleMessage(Message message) {
        Object obj;
        Object obj2;
        Object obj3;
        Object obj4;
        log("handleMessage: " + message.what);
        AsyncResult asyncResult = (AsyncResult) message.obj;
        switch (message.what) {
            case 1:
                if (asyncResult.exception == null) {
                    FileHandler fileHandler = new FileHandler((String) asyncResult.result);
                    this.mFh = fileHandler;
                    if (!fileHandler.loadFile(EFODF_PATH, obtainMessage(2))) {
                        startFromAcrf();
                        return;
                    }
                    return;
                }
                log("select pkcs15 failed: " + asyncResult.exception);
                this.mLoadedCallback.sendToTarget();
                return;
            case 2:
                if (asyncResult.exception != null || (obj = asyncResult.result) == null) {
                    startFromAcrf();
                    return;
                }
                if (!this.mFh.loadFile(parseOdf((String) obj), obtainMessage(3))) {
                    startFromAcrf();
                    return;
                }
                return;
            case 3:
                if (asyncResult.exception != null || (obj2 = asyncResult.result) == null) {
                    startFromAcrf();
                    return;
                }
                if (!this.mFh.loadFile(parseDodf((String) obj2), obtainMessage(4))) {
                    startFromAcrf();
                    return;
                }
                return;
            case 4:
                if (asyncResult.exception != null || (obj3 = asyncResult.result) == null) {
                    startFromAcrf();
                    return;
                }
                if (!this.mFh.loadFile(parseAcmf((String) obj3), obtainMessage(5))) {
                    startFromAcrf();
                    return;
                }
                return;
            case 5:
                if (asyncResult.exception != null || asyncResult.result == null) {
                    cleanUp();
                    return;
                }
                this.mRules = new ArrayList();
                if (!this.mFh.loadFile(parseAcrf((String) asyncResult.result), obtainMessage(6))) {
                    cleanUp();
                    return;
                }
                return;
            case 6:
                if (asyncResult.exception == null && (obj4 = asyncResult.result) != null) {
                    parseAccf((String) obj4);
                }
                cleanUp();
                return;
            case 7:
                return;
            default:
                Rlog.e(LOG_TAG, "Unknown event " + message.what);
                return;
        }
    }

    private void startFromAcrf() {
        log("Fallback to use ACRF_PATH");
        if (!this.mFh.loadFile(ACRF_PATH, obtainMessage(5))) {
            cleanUp();
        }
    }

    private void cleanUp() {
        log("cleanUp");
        int i = this.mChannelId;
        if (i >= 0) {
            this.mUiccProfile.iccCloseLogicalChannel(i, obtainMessage(7));
            this.mChannelId = -1;
        }
        this.mLoadedCallback.sendToTarget();
    }

    private String parseOdf(String str) {
        try {
            UiccCarrierPrivilegeRules.TLV tlv = new UiccCarrierPrivilegeRules.TLV(TAG_ODF);
            tlv.parse(str, false);
            String value = tlv.getValue();
            UiccCarrierPrivilegeRules.TLV tlv2 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE);
            UiccCarrierPrivilegeRules.TLV tlv3 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_OCTET_STRING);
            tlv2.parse(value, true);
            tlv3.parse(tlv2.getValue(), true);
            return tlv3.getValue();
        } catch (IllegalArgumentException | IndexOutOfBoundsException e) {
            log("Error: " + e);
            return null;
        }
    }

    private String parseDodf(String str) {
        while (!str.isEmpty()) {
            UiccCarrierPrivilegeRules.TLV tlv = new UiccCarrierPrivilegeRules.TLV(TAG_DODF);
            try {
                str = tlv.parse(str, false);
                String parse = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE).parse(new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE).parse(tlv.getValue(), false), false);
                if (parse.startsWith(TAG_TARGET_AID)) {
                    parse = new UiccCarrierPrivilegeRules.TLV(TAG_TARGET_AID).parse(parse, false);
                }
                if (parse.startsWith(TAG_DODF)) {
                    UiccCarrierPrivilegeRules.TLV tlv2 = new UiccCarrierPrivilegeRules.TLV(TAG_DODF);
                    tlv2.parse(parse, true);
                    String value = tlv2.getValue();
                    UiccCarrierPrivilegeRules.TLV tlv3 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE);
                    tlv3.parse(value, true);
                    String value2 = tlv3.getValue();
                    UiccCarrierPrivilegeRules.TLV tlv4 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_OID);
                    tlv4.parse(value2, false);
                    if (tlv4.getValue().equals(AC_OID)) {
                        String parse2 = tlv4.parse(value2, false);
                        UiccCarrierPrivilegeRules.TLV tlv5 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE);
                        UiccCarrierPrivilegeRules.TLV tlv6 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_OCTET_STRING);
                        tlv5.parse(parse2, true);
                        tlv6.parse(tlv5.getValue(), true);
                        return tlv6.getValue();
                    }
                }
            } catch (IllegalArgumentException | IndexOutOfBoundsException e) {
                log("Error: " + e);
                return null;
            }
        }
        return null;
    }

    private String parseAcmf(String str) {
        try {
            UiccCarrierPrivilegeRules.TLV tlv = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE);
            tlv.parse(str, false);
            String value = tlv.getValue();
            UiccCarrierPrivilegeRules.TLV tlv2 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_OCTET_STRING);
            if (!tlv2.parseLength(value).equals(REFRESH_TAG_LEN)) {
                log("Error: refresh tag in ACMF must be 8.");
                return null;
            }
            String parse = tlv2.parse(value, false);
            UiccCarrierPrivilegeRules.TLV tlv3 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE);
            UiccCarrierPrivilegeRules.TLV tlv4 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_OCTET_STRING);
            tlv3.parse(parse, true);
            tlv4.parse(tlv3.getValue(), true);
            return tlv4.getValue();
        } catch (IllegalArgumentException | IndexOutOfBoundsException e) {
            log("Error: " + e);
            return null;
        }
    }

    private String parseAcrf(String str) {
        String str2 = null;
        while (!str.isEmpty()) {
            UiccCarrierPrivilegeRules.TLV tlv = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE);
            try {
                str = tlv.parse(str, false);
                String value = tlv.getValue();
                if (value.startsWith(TAG_TARGET_AID)) {
                    UiccCarrierPrivilegeRules.TLV tlv2 = new UiccCarrierPrivilegeRules.TLV(TAG_TARGET_AID);
                    UiccCarrierPrivilegeRules.TLV tlv3 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_OCTET_STRING);
                    UiccCarrierPrivilegeRules.TLV tlv4 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE);
                    UiccCarrierPrivilegeRules.TLV tlv5 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_OCTET_STRING);
                    String parse = tlv2.parse(value, false);
                    tlv3.parse(tlv2.getValue(), true);
                    if (CARRIER_RULE_AID.equals(tlv3.getValue())) {
                        tlv4.parse(parse, true);
                        tlv5.parse(tlv4.getValue(), true);
                        str2 = tlv5.getValue();
                    }
                }
            } catch (IllegalArgumentException | IndexOutOfBoundsException e) {
                log("Error: " + e);
            }
        }
        return str2;
    }

    private void parseAccf(String str) {
        while (!str.isEmpty()) {
            UiccCarrierPrivilegeRules.TLV tlv = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_SEQUENCE);
            UiccCarrierPrivilegeRules.TLV tlv2 = new UiccCarrierPrivilegeRules.TLV(TAG_ASN_OCTET_STRING);
            try {
                str = tlv.parse(str, false);
                tlv2.parse(tlv.getValue(), true);
                if (!tlv2.getValue().isEmpty()) {
                    this.mRules.add(tlv2.getValue());
                }
            } catch (IllegalArgumentException | IndexOutOfBoundsException e) {
                log("Error: " + e);
                return;
            }
        }
    }

    public List<String> getRules() {
        return this.mRules;
    }

    /* access modifiers changed from: private */
    public static void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        if (this.mRules != null) {
            printWriter.println(" mRules:");
            for (String str : this.mRules) {
                printWriter.println("  " + str);
            }
        }
    }
}
