package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.res.Resources;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.os.AsyncResult;
import android.os.Message;
import android.telephony.SubscriptionManager;
import android.text.TextUtils;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.BitwiseInputStream;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.GsmAlphabet;
import com.android.internal.telephony.MccTable;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Locale;
import kotlin.UByte;
import kotlin.jvm.internal.ByteCompanionObject;

public class RuimRecords extends IccRecords {
    private static final int EVENT_APP_LOCKED = 32;
    private static final int EVENT_APP_NETWORK_LOCKED = 33;
    private static final int EVENT_GET_ALL_SMS_DONE = 18;
    protected static final int EVENT_GET_CDMA_SUBSCRIPTION_DONE = 10;
    private static final int EVENT_GET_DEVICE_IDENTITY_DONE = 4;
    private static final int EVENT_GET_ICCID_DONE = 5;
    private static final int EVENT_GET_SMS_DONE = 22;
    protected static final int EVENT_GET_SST_DONE = 17;
    private static final int EVENT_MARK_SMS_READ_DONE = 19;
    private static final int EVENT_SMS_ON_RUIM = 21;
    private static final int EVENT_UPDATE_DONE = 14;
    private static final int IMSI_MIN_LENGTH = 10;
    static final String LOG_TAG = "RuimRecords";
    protected boolean mCsimSpnDisplayCondition = false;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public byte[] mEFli = null;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public byte[] mEFpl = null;
    /* access modifiers changed from: private */
    public String mHomeNetworkId;
    /* access modifiers changed from: private */
    public String mHomeSystemId;
    /* access modifiers changed from: private */
    public String mMdn;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String mMin;
    protected String mMin2Min1;
    protected String mMyMobileNumber;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String mNai;
    private boolean mOtaCommited = false;
    protected String mPrlVersion;

    private static boolean isPrintableAscii(char c) {
        return (' ' <= c && c <= '~') || c == 13 || c == 10;
    }

    /* access modifiers changed from: protected */
    public void onGetImsiDone(String str) {
    }

    public String toString() {
        return "RuimRecords: " + super.toString() + " m_ota_commited" + this.mOtaCommited + " mMyMobileNumber=xxxx mMin2Min1=" + this.mMin2Min1 + " mPrlVersion=" + this.mPrlVersion + " mEFpl=" + this.mEFpl + " mEFli=" + this.mEFli + " mCsimSpnDisplayCondition=" + this.mCsimSpnDisplayCondition + " mMdn=" + this.mMdn + " mMin=" + this.mMin + " mHomeSystemId=" + this.mHomeSystemId + " mHomeNetworkId=" + this.mHomeNetworkId;
    }

    public RuimRecords(UiccCardApplication uiccCardApplication, Context context, CommandsInterface commandsInterface) {
        super(uiccCardApplication, context, commandsInterface);
        this.mAdnCache = new AdnRecordCache(this.mFh);
        this.mRecordsRequested = false;
        this.mLockedRecordsReqReason = 0;
        this.mRecordsToLoad = 0;
        resetRecords();
        log("RuimRecords X ctor this=" + this);
    }

    public void dispose() {
        log("Disposing RuimRecords " + this);
        resetRecords();
        super.dispose();
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        log("RuimRecords finalized");
    }

    /* access modifiers changed from: protected */
    public void resetRecords() {
        this.mMncLength = -1;
        log("setting0 mMncLength" + this.mMncLength);
        this.mIccId = null;
        this.mFullIccId = null;
        this.mAdnCache.reset();
        this.mRecordsRequested = false;
        this.mLockedRecordsReqReason = 0;
        this.mLoaded.set(false);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getMdnNumber() {
        return this.mMyMobileNumber;
    }

    public String getCdmaMin() {
        return this.mMin2Min1;
    }

    public String getPrlVersion() {
        return this.mPrlVersion;
    }

    public String getNAI() {
        return this.mNai;
    }

    public void setVoiceMailNumber(String str, String str2, Message message) {
        AsyncResult.forMessage(message).exception = new IccException("setVoiceMailNumber not implemented");
        message.sendToTarget();
        loge("method setVoiceMailNumber is not implemented");
    }

    public void onRefresh(boolean z, int[] iArr) {
        if (z) {
            fetchRuimRecords();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getRUIMOperatorNumeric() {
        String imsi = getIMSI();
        if (imsi == null) {
            return null;
        }
        int i = this.mMncLength;
        if (i == -1 || i == 0) {
            return imsi.substring(0, MccTable.smallestDigitsMccForMnc(Integer.parseInt(imsi.substring(0, 3))) + 3);
        }
        return imsi.substring(0, i + 3);
    }

    private class EfPlLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_PL";
        }

        private EfPlLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            RuimRecords.this.mEFpl = (byte[]) asyncResult.result;
            RuimRecords ruimRecords = RuimRecords.this;
            ruimRecords.log("EF_PL=" + IccUtils.bytesToHexString(RuimRecords.this.mEFpl));
        }
    }

    private class EfCsimLiLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_CSIM_LI";
        }

        private EfCsimLiLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            RuimRecords.this.mEFli = (byte[]) asyncResult.result;
            for (int i = 0; i < RuimRecords.this.mEFli.length; i += 2) {
                int i2 = i + 1;
                switch (RuimRecords.this.mEFli[i2]) {
                    case 1:
                        RuimRecords.this.mEFli[i] = 101;
                        RuimRecords.this.mEFli[i2] = 110;
                        break;
                    case 2:
                        RuimRecords.this.mEFli[i] = 102;
                        RuimRecords.this.mEFli[i2] = 114;
                        break;
                    case 3:
                        RuimRecords.this.mEFli[i] = 101;
                        RuimRecords.this.mEFli[i2] = 115;
                        break;
                    case 4:
                        RuimRecords.this.mEFli[i] = 106;
                        RuimRecords.this.mEFli[i2] = 97;
                        break;
                    case 5:
                        RuimRecords.this.mEFli[i] = 107;
                        RuimRecords.this.mEFli[i2] = 111;
                        break;
                    case 6:
                        RuimRecords.this.mEFli[i] = 122;
                        RuimRecords.this.mEFli[i2] = 104;
                        break;
                    case 7:
                        RuimRecords.this.mEFli[i] = 104;
                        RuimRecords.this.mEFli[i2] = 101;
                        break;
                    default:
                        RuimRecords.this.mEFli[i] = 32;
                        RuimRecords.this.mEFli[i2] = 32;
                        break;
                }
            }
            RuimRecords ruimRecords = RuimRecords.this;
            ruimRecords.log("EF_LI=" + IccUtils.bytesToHexString(RuimRecords.this.mEFli));
        }
    }

    private class EfCsimSpnLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_CSIM_SPN";
        }

        private EfCsimSpnLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            byte[] bArr = (byte[]) asyncResult.result;
            RuimRecords.this.log("CSIM_SPN=" + IccUtils.bytesToHexString(bArr));
            RuimRecords.this.mCsimSpnDisplayCondition = (bArr[0] & 1) != 0;
            byte b = bArr[1];
            byte b2 = bArr[2];
            byte[] bArr2 = new byte[32];
            System.arraycopy(bArr, 3, bArr2, 0, bArr.length - 3 < 32 ? bArr.length - 3 : 32);
            int i = 0;
            while (i < 32 && (bArr2[i] & UByte.MAX_VALUE) != 255) {
                i++;
            }
            if (i == 0) {
                RuimRecords.this.setServiceProviderName("");
                return;
            }
            if (b != 0) {
                if (b != 2) {
                    if (b != 3) {
                        if (b == 4) {
                            RuimRecords.this.setServiceProviderName(new String(bArr2, 0, i, "utf-16"));
                        } else if (b != 8) {
                            if (b != 9) {
                                try {
                                    RuimRecords.this.log("SPN encoding not supported");
                                } catch (Exception e) {
                                    RuimRecords.this.log("spn decode error: " + e);
                                }
                            }
                        }
                    }
                    RuimRecords.this.setServiceProviderName(GsmAlphabet.gsm7BitPackedToString(bArr2, 0, (i * 8) / 7));
                } else {
                    String str = new String(bArr2, 0, i, "US-ASCII");
                    if (RuimRecords.isPrintableAsciiOnly(str)) {
                        RuimRecords.this.setServiceProviderName(str);
                    } else {
                        RuimRecords.this.log("Some corruption in SPN decoding = " + str);
                        RuimRecords.this.log("Using ENCODING_GSM_7BIT_ALPHABET scheme...");
                        RuimRecords.this.setServiceProviderName(GsmAlphabet.gsm7BitPackedToString(bArr2, 0, (i * 8) / 7));
                    }
                }
                RuimRecords.this.log("spn=" + RuimRecords.this.getServiceProviderName());
                RuimRecords.this.log("spnCondition=" + RuimRecords.this.mCsimSpnDisplayCondition);
                RuimRecords ruimRecords = RuimRecords.this;
                ruimRecords.mTelephonyManager.setSimOperatorNameForPhone(ruimRecords.mParentApp.getPhoneId(), RuimRecords.this.getServiceProviderName());
            }
            RuimRecords.this.setServiceProviderName(new String(bArr2, 0, i, "ISO-8859-1"));
            RuimRecords.this.log("spn=" + RuimRecords.this.getServiceProviderName());
            RuimRecords.this.log("spnCondition=" + RuimRecords.this.mCsimSpnDisplayCondition);
            RuimRecords ruimRecords2 = RuimRecords.this;
            ruimRecords2.mTelephonyManager.setSimOperatorNameForPhone(ruimRecords2.mParentApp.getPhoneId(), RuimRecords.this.getServiceProviderName());
        }
    }

    /* access modifiers changed from: private */
    public static boolean isPrintableAsciiOnly(CharSequence charSequence) {
        int length = charSequence.length();
        for (int i = 0; i < length; i++) {
            if (!isPrintableAscii(charSequence.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    private class EfCsimMdnLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_CSIM_MDN";
        }

        private EfCsimMdnLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            byte[] bArr = (byte[]) asyncResult.result;
            RuimRecords ruimRecords = RuimRecords.this;
            ruimRecords.log("CSIM_MDN=" + IccUtils.bytesToHexString(bArr));
            RuimRecords.this.mMdn = IccUtils.cdmaBcdToString(bArr, 1, bArr[0] & 15);
            RuimRecords ruimRecords2 = RuimRecords.this;
            ruimRecords2.log("CSIM MDN=" + RuimRecords.this.mMdn);
        }
    }

    @VisibleForTesting
    public class EfCsimImsimLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_CSIM_IMSIM";
        }

        public EfCsimImsimLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            byte[] bArr = (byte[]) asyncResult.result;
            if (bArr == null || bArr.length < 10) {
                RuimRecords.this.loge("Invalid IMSI from EF_CSIM_IMSIM");
                return;
            }
            RuimRecords ruimRecords = RuimRecords.this;
            ruimRecords.log("data=" + Rlog.pii(RuimRecords.LOG_TAG, IccUtils.bytesToHexString(bArr)));
            if ((bArr[7] & 128) == 128) {
                String decodeImsi = decodeImsi(bArr);
                if (TextUtils.isEmpty(RuimRecords.this.mImsi)) {
                    RuimRecords ruimRecords2 = RuimRecords.this;
                    ruimRecords2.mImsi = decodeImsi;
                    ruimRecords2.log("IMSI=" + Rlog.pii(RuimRecords.LOG_TAG, RuimRecords.this.mImsi));
                }
                RuimRecords.this.mMin = decodeImsi.substring(5, 15);
                RuimRecords ruimRecords3 = RuimRecords.this;
                ruimRecords3.log("min present=" + Rlog.pii(RuimRecords.LOG_TAG, RuimRecords.this.mMin));
                RuimRecords ruimRecords4 = RuimRecords.this;
                ruimRecords4.onGetImsiDone(ruimRecords4.mImsi);
                return;
            }
            RuimRecords.this.log("min not present");
        }

        private int decodeImsiDigits(int i, int i2) {
            int i3 = 1;
            for (int i4 = 0; i4 < i2; i4++) {
                i += i3;
                if ((i / i3) % 10 == 0) {
                    i -= i3 * 10;
                }
                i3 *= 10;
            }
            return i;
        }

        @VisibleForTesting
        public String decodeImsi(byte[] bArr) {
            int decodeImsiDigits = decodeImsiDigits(((bArr[9] & 3) << 8) | (bArr[8] & UByte.MAX_VALUE), 3);
            int decodeImsiDigits2 = decodeImsiDigits(bArr[6] & ByteCompanionObject.MAX_VALUE, 2);
            int i = ((bArr[2] & 3) << 8) + (bArr[1] & UByte.MAX_VALUE);
            byte b = bArr[4];
            int i2 = (((bArr[5] & UByte.MAX_VALUE) << 8) | (b & UByte.MAX_VALUE)) >> 6;
            int i3 = (b >> 2) & 15;
            if (i3 > 9) {
                i3 = 0;
            }
            int decodeImsiDigits3 = decodeImsiDigits(i, 3);
            int decodeImsiDigits4 = decodeImsiDigits(i2, 3);
            int decodeImsiDigits5 = decodeImsiDigits((bArr[3] & UByte.MAX_VALUE) | ((b & 3) << 8), 3);
            StringBuilder sb = new StringBuilder();
            Locale locale = Locale.US;
            sb.append(String.format(locale, "%03d", new Object[]{Integer.valueOf(decodeImsiDigits)}));
            sb.append(String.format(locale, TimeModel.ZERO_LEADING_NUMBER_FORMAT, new Object[]{Integer.valueOf(decodeImsiDigits2)}));
            sb.append(String.format(locale, "%03d", new Object[]{Integer.valueOf(decodeImsiDigits3)}));
            sb.append(String.format(locale, "%03d", new Object[]{Integer.valueOf(decodeImsiDigits4)}));
            sb.append(String.format(locale, TimeModel.NUMBER_FORMAT, new Object[]{Integer.valueOf(i3)}));
            sb.append(String.format(locale, "%03d", new Object[]{Integer.valueOf(decodeImsiDigits5)}));
            return sb.toString();
        }
    }

    private class EfCsimCdmaHomeLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_CSIM_CDMAHOME";
        }

        private EfCsimCdmaHomeLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            ArrayList arrayList = (ArrayList) asyncResult.result;
            RuimRecords ruimRecords = RuimRecords.this;
            ruimRecords.log("CSIM_CDMAHOME data size=" + arrayList.size());
            if (!arrayList.isEmpty()) {
                StringBuilder sb = new StringBuilder();
                StringBuilder sb2 = new StringBuilder();
                Iterator it = arrayList.iterator();
                while (it.hasNext()) {
                    byte[] bArr = (byte[]) it.next();
                    if (bArr.length == 5) {
                        byte b = ((bArr[1] & UByte.MAX_VALUE) << 8) | (bArr[0] & UByte.MAX_VALUE);
                        byte b2 = bArr[2] & UByte.MAX_VALUE;
                        sb.append(b);
                        sb.append(',');
                        sb2.append(b2 | ((bArr[3] & UByte.MAX_VALUE) << 8));
                        sb2.append(',');
                    }
                }
                sb.setLength(sb.length() - 1);
                sb2.setLength(sb2.length() - 1);
                RuimRecords.this.mHomeSystemId = sb.toString();
                RuimRecords.this.mHomeNetworkId = sb2.toString();
            }
        }
    }

    private class EfCsimEprlLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_CSIM_EPRL";
        }

        private EfCsimEprlLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            RuimRecords.this.onGetCSimEprlDone(asyncResult);
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void onGetCSimEprlDone(AsyncResult asyncResult) {
        byte[] bArr = (byte[]) asyncResult.result;
        log("CSIM_EPRL=" + IccUtils.bytesToHexString(bArr));
        if (bArr.length > 3) {
            this.mPrlVersion = Integer.toString((bArr[3] & UByte.MAX_VALUE) | ((bArr[2] & UByte.MAX_VALUE) << 8));
        }
        log("CSIM PRL version=" + this.mPrlVersion);
    }

    private class EfCsimMipUppLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_CSIM_MIPUPP";
        }

        private EfCsimMipUppLoaded() {
        }

        /* access modifiers changed from: package-private */
        public boolean checkLengthLegal(int i, int i2) {
            if (i >= i2) {
                return true;
            }
            Log.e(RuimRecords.LOG_TAG, "CSIM MIPUPP format error, length = " + i + "expected length at least =" + i2);
            return false;
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            byte[] bArr = (byte[]) asyncResult.result;
            if (bArr.length < 1) {
                Log.e(RuimRecords.LOG_TAG, "MIPUPP read error");
                return;
            }
            BitwiseInputStream bitwiseInputStream = new BitwiseInputStream(bArr);
            try {
                int read = bitwiseInputStream.read(8) << 3;
                if (checkLengthLegal(read, 1)) {
                    int i = read - 1;
                    if (bitwiseInputStream.read(1) == 1) {
                        if (checkLengthLegal(i, 11)) {
                            bitwiseInputStream.skip(11);
                            i -= 11;
                        } else {
                            return;
                        }
                    }
                    if (checkLengthLegal(i, 4)) {
                        int read2 = bitwiseInputStream.read(4);
                        int i2 = i - 4;
                        int i3 = 0;
                        while (i3 < read2 && checkLengthLegal(i2, 4)) {
                            int read3 = bitwiseInputStream.read(4);
                            int i4 = i2 - 4;
                            if (checkLengthLegal(i4, 8)) {
                                int read4 = bitwiseInputStream.read(8);
                                int i5 = i4 - 8;
                                if (read3 != 0) {
                                    int i6 = read4 << 3;
                                    int i7 = i6 + 102;
                                    if (checkLengthLegal(i5, i7)) {
                                        bitwiseInputStream.skip(i6 + 101);
                                        int i8 = i5 - i7;
                                        if (bitwiseInputStream.read(1) == 1) {
                                            if (checkLengthLegal(i8, 32)) {
                                                bitwiseInputStream.skip(32);
                                                i8 -= 32;
                                            } else {
                                                return;
                                            }
                                        }
                                        if (checkLengthLegal(i8, 5)) {
                                            bitwiseInputStream.skip(4);
                                            i2 = (i8 - 4) - 1;
                                            if (bitwiseInputStream.read(1) == 1) {
                                                if (checkLengthLegal(i2, 32)) {
                                                    bitwiseInputStream.skip(32);
                                                    i2 -= 32;
                                                } else {
                                                    return;
                                                }
                                            }
                                            i3++;
                                        } else {
                                            return;
                                        }
                                    } else {
                                        return;
                                    }
                                } else if (checkLengthLegal(i5, read4 << 3)) {
                                    char[] cArr = new char[read4];
                                    for (int i9 = 0; i9 < read4; i9++) {
                                        cArr[i9] = (char) (bitwiseInputStream.read(8) & 255);
                                    }
                                    RuimRecords.this.mNai = new String(cArr);
                                    if (Log.isLoggable(RuimRecords.LOG_TAG, 2)) {
                                        Log.v(RuimRecords.LOG_TAG, "MIPUPP Nai = " + RuimRecords.this.mNai);
                                        return;
                                    }
                                    return;
                                } else {
                                    return;
                                }
                            } else {
                                return;
                            }
                        }
                    }
                }
            } catch (Exception unused) {
                Log.e(RuimRecords.LOG_TAG, "MIPUPP read Exception error!");
            }
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:52:0x0110  */
    /* JADX WARNING: Removed duplicated region for block: B:56:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleMessage(android.os.Message r6) {
        /*
            r5 = this;
            java.lang.String r0 = "RuimRecords"
            java.util.concurrent.atomic.AtomicBoolean r1 = r5.mDestroyed
            boolean r1 = r1.get()
            if (r1 == 0) goto L_0x002e
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "Received message "
            r0.append(r1)
            r0.append(r6)
            java.lang.String r1 = "["
            r0.append(r1)
            int r6 = r6.what
            r0.append(r6)
            java.lang.String r6 = "] while being destroyed. Ignoring."
            r0.append(r6)
            java.lang.String r6 = r0.toString()
            r5.loge(r6)
            return
        L_0x002e:
            r1 = 0
            int r2 = r6.what     // Catch:{ RuntimeException -> 0x0104 }
            r3 = 4
            if (r2 == r3) goto L_0x00f7
            r4 = 5
            if (r2 == r4) goto L_0x00b9
            r4 = 10
            if (r2 == r4) goto L_0x007d
            r3 = 14
            if (r2 == r3) goto L_0x006e
            r3 = 21
            if (r2 == r3) goto L_0x0056
            r3 = 22
            if (r2 == r3) goto L_0x0056
            switch(r2) {
                case 17: goto L_0x004f;
                case 18: goto L_0x0056;
                case 19: goto L_0x0056;
                default: goto L_0x004a;
            }     // Catch:{ RuntimeException -> 0x0104 }
        L_0x004a:
            super.handleMessage(r6)     // Catch:{ RuntimeException -> 0x0104 }
            goto L_0x00fc
        L_0x004f:
            java.lang.String r6 = "Event EVENT_GET_SST_DONE Received"
            r5.log(r6)     // Catch:{ RuntimeException -> 0x0104 }
            goto L_0x00fc
        L_0x0056:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0104 }
            r2.<init>()     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.String r3 = "Event not supported: "
            r2.append(r3)     // Catch:{ RuntimeException -> 0x0104 }
            int r6 = r6.what     // Catch:{ RuntimeException -> 0x0104 }
            r2.append(r6)     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.String r6 = r2.toString()     // Catch:{ RuntimeException -> 0x0104 }
            com.android.telephony.Rlog.w(r0, r6)     // Catch:{ RuntimeException -> 0x0104 }
            goto L_0x00fc
        L_0x006e:
            java.lang.Object r6 = r6.obj     // Catch:{ RuntimeException -> 0x0104 }
            android.os.AsyncResult r6 = (android.os.AsyncResult) r6     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.Throwable r6 = r6.exception     // Catch:{ RuntimeException -> 0x0104 }
            if (r6 == 0) goto L_0x00fc
            java.lang.String r2 = "RuimRecords update failed"
            com.android.telephony.Rlog.i(r0, r2, r6)     // Catch:{ RuntimeException -> 0x0104 }
            goto L_0x00fc
        L_0x007d:
            java.lang.Object r6 = r6.obj     // Catch:{ RuntimeException -> 0x0104 }
            android.os.AsyncResult r6 = (android.os.AsyncResult) r6     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.Object r2 = r6.result     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.String[] r2 = (java.lang.String[]) r2     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.Throwable r6 = r6.exception     // Catch:{ RuntimeException -> 0x0104 }
            if (r6 == 0) goto L_0x008b
            goto L_0x00fc
        L_0x008b:
            r6 = r2[r1]     // Catch:{ RuntimeException -> 0x0104 }
            r5.mMyMobileNumber = r6     // Catch:{ RuntimeException -> 0x0104 }
            r6 = 3
            r6 = r2[r6]     // Catch:{ RuntimeException -> 0x0104 }
            r5.mMin2Min1 = r6     // Catch:{ RuntimeException -> 0x0104 }
            r6 = r2[r3]     // Catch:{ RuntimeException -> 0x0104 }
            r5.mPrlVersion = r6     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0104 }
            r6.<init>()     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.String r2 = "MDN: "
            r6.append(r2)     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.String r2 = r5.mMyMobileNumber     // Catch:{ RuntimeException -> 0x0104 }
            r6.append(r2)     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.String r2 = " MIN: "
            r6.append(r2)     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.String r2 = r5.mMin2Min1     // Catch:{ RuntimeException -> 0x0104 }
            r6.append(r2)     // Catch:{ RuntimeException -> 0x0104 }
            java.lang.String r6 = r6.toString()     // Catch:{ RuntimeException -> 0x0104 }
            r5.log(r6)     // Catch:{ RuntimeException -> 0x0104 }
            goto L_0x00fc
        L_0x00b9:
            r2 = 1
            java.lang.Object r6 = r6.obj     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            android.os.AsyncResult r6 = (android.os.AsyncResult) r6     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.Object r3 = r6.result     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            byte[] r3 = (byte[]) r3     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.Throwable r6 = r6.exception     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            if (r6 == 0) goto L_0x00c7
            goto L_0x00ef
        L_0x00c7:
            int r6 = r3.length     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.String r6 = com.android.internal.telephony.uicc.IccUtils.bcdToString(r3, r1, r6)     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            r5.mIccId = r6     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            int r6 = r3.length     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.String r6 = com.android.internal.telephony.uicc.IccUtils.bchToString(r3, r1, r6)     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            r5.mFullIccId = r6     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            r6.<init>()     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.String r1 = "iccid: "
            r6.append(r1)     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.String r1 = r5.mFullIccId     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.String r1 = android.telephony.SubscriptionInfo.givePrintableIccid(r1)     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            r6.append(r1)     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            java.lang.String r6 = r6.toString()     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
            r5.log(r6)     // Catch:{ RuntimeException -> 0x00f4, all -> 0x00f1 }
        L_0x00ef:
            r1 = r2
            goto L_0x00fc
        L_0x00f1:
            r6 = move-exception
            r1 = r2
            goto L_0x010e
        L_0x00f4:
            r6 = move-exception
            r1 = r2
            goto L_0x0105
        L_0x00f7:
            java.lang.String r6 = "Event EVENT_GET_DEVICE_IDENTITY_DONE Received"
            r5.log(r6)     // Catch:{ RuntimeException -> 0x0104 }
        L_0x00fc:
            if (r1 == 0) goto L_0x010d
        L_0x00fe:
            r5.onRecordLoaded()
            goto L_0x010d
        L_0x0102:
            r6 = move-exception
            goto L_0x010e
        L_0x0104:
            r6 = move-exception
        L_0x0105:
            java.lang.String r2 = "Exception parsing RUIM record"
            com.android.telephony.Rlog.w(r0, r2, r6)     // Catch:{ all -> 0x0102 }
            if (r1 == 0) goto L_0x010d
            goto L_0x00fe
        L_0x010d:
            return
        L_0x010e:
            if (r1 == 0) goto L_0x0113
            r5.onRecordLoaded()
        L_0x0113:
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.RuimRecords.handleMessage(android.os.Message):void");
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static String[] getAssetLanguages(Context context) {
        String[] locales = context.getAssets().getLocales();
        String[] strArr = new String[locales.length];
        for (int i = 0; i < locales.length; i++) {
            String str = locales[i];
            int indexOf = str.indexOf(45);
            if (indexOf < 0) {
                strArr[i] = str;
            } else {
                strArr[i] = str.substring(0, indexOf);
            }
        }
        return strArr;
    }

    /* access modifiers changed from: protected */
    public void onRecordLoaded() {
        this.mRecordsToLoad--;
        log("onRecordLoaded " + this.mRecordsToLoad + " requested: " + this.mRecordsRequested);
        if (getRecordsLoaded()) {
            onAllRecordsLoaded();
        } else if (getLockedRecordsLoaded() || getNetworkLockedRecordsLoaded()) {
            onLockedAllRecordsLoaded();
        } else if (this.mRecordsToLoad < 0) {
            loge("recordsToLoad <0, programmer error suspected");
            this.mRecordsToLoad = 0;
        }
    }

    private void onLockedAllRecordsLoaded() {
        int i = this.mLockedRecordsReqReason;
        if (i == 1) {
            this.mLockedRecordsLoadedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        } else if (i == 2) {
            this.mNetworkLockedRecordsLoadedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        } else {
            loge("onLockedAllRecordsLoaded: unexpected mLockedRecordsReqReason " + this.mLockedRecordsReqReason);
        }
    }

    /* access modifiers changed from: protected */
    public void onAllRecordsLoaded() {
        log("record load complete");
        if (Resources.getSystem().getBoolean(17891823)) {
            setSimLanguage(this.mEFli, this.mEFpl);
        }
        this.mLoaded.set(true);
        this.mRecordsLoadedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        if (!TextUtils.isEmpty(this.mMdn)) {
            int subIdUsingPhoneId = SubscriptionController.getInstance().getSubIdUsingPhoneId(this.mParentApp.getUiccProfile().getPhoneId());
            if (SubscriptionManager.isValidSubscriptionId(subIdUsingPhoneId)) {
                SubscriptionManager.from(this.mContext).setDisplayNumber(this.mMdn, subIdUsingPhoneId);
            } else {
                log("Cannot call setDisplayNumber: invalid subId");
            }
        }
    }

    public void onReady() {
        fetchRuimRecords();
        this.mCi.getCDMASubscription(obtainMessage(10));
    }

    /* access modifiers changed from: protected */
    public void onLocked() {
        log("only fetch EF_ICCID in locked state");
        super.onLocked();
        this.mFh.loadEFTransparent(IccConstants.EF_ICCID, obtainMessage(5));
        this.mRecordsToLoad++;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void fetchRuimRecords() {
        this.mRecordsRequested = true;
        log("fetchRuimRecords " + this.mRecordsToLoad);
        this.mFh.loadEFTransparent(IccConstants.EF_ICCID, obtainMessage(5));
        this.mRecordsToLoad = this.mRecordsToLoad + 1;
        this.mFh.loadEFTransparent(IccConstants.EF_PL, obtainMessage(100, new EfPlLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(28474, obtainMessage(100, new EfCsimLiLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(28481, obtainMessage(100, new EfCsimSpnLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFLinearFixed(IccConstants.EF_CSIM_MDN, 1, obtainMessage(100, new EfCsimMdnLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_CSIM_IMSIM, obtainMessage(100, new EfCsimImsimLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFLinearFixedAll(IccConstants.EF_CSIM_CDMAHOME, obtainMessage(100, new EfCsimCdmaHomeLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent((int) IccConstants.EF_CSIM_EPRL, 4, obtainMessage(100, new EfCsimEprlLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_CSIM_MIPUPP, obtainMessage(100, new EfCsimMipUppLoaded()));
        this.mRecordsToLoad++;
        this.mFh.getEFLinearRecordSize(IccConstants.EF_SMS, obtainMessage(28));
        this.mRecordsToLoad++;
        log("fetchRuimRecords " + this.mRecordsToLoad + " requested: " + this.mRecordsRequested);
    }

    public boolean isProvisioned() {
        if (TelephonyProperties.test_csim().orElse(Boolean.FALSE).booleanValue()) {
            return true;
        }
        UiccCardApplication uiccCardApplication = this.mParentApp;
        if (uiccCardApplication == null) {
            return false;
        }
        if (uiccCardApplication.getType() == IccCardApplicationStatus.AppType.APPTYPE_CSIM && (this.mMdn == null || this.mMin == null)) {
            return false;
        }
        return true;
    }

    public void setVoiceMessageWaiting(int i, int i2) {
        log("RuimRecords:setVoiceMessageWaiting - NOP for CDMA");
    }

    public int getVoiceMessageCount() {
        log("RuimRecords:getVoiceMessageCount - NOP for CDMA");
        return 0;
    }

    /* access modifiers changed from: protected */
    public void handleFileUpdate(int i) {
        this.mLoaded.set(false);
        this.mAdnCache.reset();
        fetchRuimRecords();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getMdn() {
        return this.mMdn;
    }

    public String getMin() {
        return this.mMin;
    }

    public String getSid() {
        return this.mHomeSystemId;
    }

    public String getNid() {
        return this.mHomeNetworkId;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean getCsimSpnDisplayCondition() {
        return this.mCsimSpnDisplayCondition;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        if (this.mParentApp != null) {
            Rlog.d(LOG_TAG, "[RuimRecords-" + this.mParentApp.getPhoneId() + "] " + str);
            return;
        }
        Rlog.d(LOG_TAG, "[RuimRecords] " + str);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loge(String str) {
        if (this.mParentApp != null) {
            Rlog.e(LOG_TAG, "[RuimRecords-" + this.mParentApp.getPhoneId() + "] " + str);
            return;
        }
        Rlog.e(LOG_TAG, "[RuimRecords] " + str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("RuimRecords: " + this);
        printWriter.println(" extends:");
        super.dump(fileDescriptor, printWriter, strArr);
        printWriter.println(" mOtaCommited=" + this.mOtaCommited);
        printWriter.println(" mMyMobileNumber=" + this.mMyMobileNumber);
        printWriter.println(" mMin2Min1=" + this.mMin2Min1);
        printWriter.println(" mPrlVersion=" + this.mPrlVersion);
        printWriter.println(" mEFpl[]=" + Arrays.toString(this.mEFpl));
        printWriter.println(" mEFli[]=" + Arrays.toString(this.mEFli));
        printWriter.println(" mCsimSpnDisplayCondition=" + this.mCsimSpnDisplayCondition);
        printWriter.println(" mMdn=" + this.mMdn);
        printWriter.println(" mMin=" + this.mMin);
        printWriter.println(" mHomeSystemId=" + this.mHomeSystemId);
        printWriter.println(" mHomeNetworkId=" + this.mHomeNetworkId);
        printWriter.flush();
    }
}
