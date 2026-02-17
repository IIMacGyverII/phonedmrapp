package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.res.Resources;
import android.os.AsyncResult;
import android.os.Message;
import android.telephony.PhoneNumberUtils;
import android.telephony.SmsMessage;
import android.text.TextUtils;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.MccTable;
import com.android.internal.telephony.gsm.SimTlv;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import kotlin.UByte;

public class SIMRecords extends IccRecords {
    protected static final int CFF_LINE1_MASK = 15;
    protected static final int CFF_LINE1_RESET = 240;
    protected static final int CFF_UNCONDITIONAL_ACTIVE = 10;
    protected static final int CFF_UNCONDITIONAL_DEACTIVE = 5;
    protected static final int CFIS_ADN_CAPABILITY_ID_OFFSET = 14;
    protected static final int CFIS_ADN_EXTENSION_ID_OFFSET = 15;
    protected static final int CFIS_BCD_NUMBER_LENGTH_OFFSET = 2;
    protected static final int CFIS_TON_NPI_OFFSET = 3;
    private static final int CPHS_SST_MBN_ENABLED = 48;
    private static final int CPHS_SST_MBN_MASK = 48;
    private static final boolean CRASH_RIL = false;
    private static final int EVENT_GET_AD_DONE = 9;
    private static final int EVENT_GET_ALL_SMS_DONE = 18;
    protected static final int EVENT_GET_CFF_DONE = 24;
    protected static final int EVENT_GET_CFIS_DONE = 32;
    protected static final int EVENT_GET_CPHS_MAILBOX_DONE = 11;
    protected static final int EVENT_GET_CSP_CPHS_DONE = 33;
    private static final int EVENT_GET_EHPLMN_DONE = 40;
    protected static final int EVENT_GET_FPLMN_DONE = 41;
    private static final int EVENT_GET_FPLMN_SIZE_DONE = 42;
    private static final int EVENT_GET_GID1_DONE = 34;
    private static final int EVENT_GET_GID2_DONE = 36;
    private static final int EVENT_GET_HPLMN_W_ACT_DONE = 39;
    private static final int EVENT_GET_ICCID_DONE = 4;
    private static final int EVENT_GET_IMSI_DONE = 3;
    protected static final int EVENT_GET_INFO_CPHS_DONE = 26;
    protected static final int EVENT_GET_MBDN_DONE = 6;
    protected static final int EVENT_GET_MBI_DONE = 5;
    protected static final int EVENT_GET_MSISDN_DONE = 10;
    protected static final int EVENT_GET_MWIS_DONE = 7;
    private static final int EVENT_GET_OPLMN_W_ACT_DONE = 38;
    protected static final int EVENT_GET_OPL_DONE = 16;
    private static final int EVENT_GET_PLMN_W_ACT_DONE = 37;
    protected static final int EVENT_GET_PNN_DONE = 15;
    private static final int EVENT_GET_SMS_DONE = 22;
    private static final int EVENT_GET_SPDI_DONE = 13;
    protected static final int EVENT_GET_SPN_DONE = 12;
    protected static final int EVENT_GET_SST_DONE = 17;
    private static final int EVENT_GET_VOICE_MAIL_INDICATOR_CPHS_DONE = 8;
    private static final int EVENT_MARK_SMS_READ_DONE = 19;
    private static final int EVENT_SET_CPHS_MAILBOX_DONE = 25;
    private static final int EVENT_SET_FPLMN_DONE = 43;
    private static final int EVENT_SET_MBDN_DONE = 20;
    protected static final int EVENT_SET_MSISDN_DONE = 30;
    private static final int EVENT_SMS_ON_SIM = 21;
    protected static final int EVENT_UPDATE_DONE = 14;
    private static final int FPLMN_BYTE_SIZE = 3;
    protected static final String LOG_TAG = "SIMRecords";
    private static final int SIM_RECORD_EVENT_BASE = 0;
    protected static final int TAG_FULL_NETWORK_NAME = 67;
    static final int TAG_PLMN_ADDITIONAL_INFORMATION = 128;
    protected static final int TAG_SHORT_NETWORK_NAME = 69;
    static final int TAG_SPDI = 163;
    static final int TAG_SPDI_PLMN_LIST = 128;
    private static final boolean VDBG = false;
    protected int mCallForwardingStatus;
    protected byte[] mCphsInfo = null;
    protected boolean mCspPlmnEnabled = true;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    byte[] mEfCPHS_MWI = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected byte[] mEfCff = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected byte[] mEfCfis = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    byte[] mEfLi = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    byte[] mEfMWIS = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    byte[] mEfPl = null;
    protected GetSpnFsmState mSpnState;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected UsimServiceTable mUsimServiceTable;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected VoiceMailConstants mVmConfig;

    @UnsupportedAppUsage(implicitMember = "values()[Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;")
    protected enum GetSpnFsmState {
        IDLE,
        INIT,
        READ_SPN_3GPP,
        READ_SPN_CPHS,
        READ_SPN_SHORT_CPHS
    }

    /* access modifiers changed from: protected */
    public boolean checkCdma3gCard() {
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean shallIgnoreMessage(Message message) {
        return true;
    }

    public String toString() {
        return "SimRecords: " + super.toString() + " mVmConfig" + this.mVmConfig + " callForwardingEnabled=" + this.mCallForwardingStatus + " spnState=" + this.mSpnState + " mCphsInfo=" + this.mCphsInfo + " mCspPlmnEnabled=" + this.mCspPlmnEnabled + " efMWIS=" + this.mEfMWIS + " efCPHS_MWI=" + this.mEfCPHS_MWI + " mEfCff=" + this.mEfCff + " mEfCfis=" + this.mEfCfis + " getOperatorNumeric=" + getOperatorNumeric();
    }

    public SIMRecords(UiccCardApplication uiccCardApplication, Context context, CommandsInterface commandsInterface) {
        super(uiccCardApplication, context, commandsInterface);
        this.mAdnCache = new AdnRecordCache(this.mFh);
        this.mVmConfig = new VoiceMailConstants();
        this.mRecordsRequested = false;
        this.mLockedRecordsReqReason = 0;
        this.mRecordsToLoad = 0;
        this.mCi.setOnSmsOnSim(this, 21, (Object) null);
        resetRecords();
        log("SIMRecords X ctor this=" + this);
    }

    public void dispose() {
        log("Disposing SIMRecords this=" + this);
        this.mCi.unSetOnSmsOnSim(this);
        resetRecords();
        super.dispose();
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        log("finalized");
    }

    /* access modifiers changed from: protected */
    public void resetRecords() {
        this.mImsi = null;
        this.mMsisdn = null;
        this.mVoiceMailNum = null;
        this.mMncLength = -1;
        log("setting0 mMncLength" + this.mMncLength);
        this.mIccId = null;
        this.mFullIccId = null;
        this.mCarrierNameDisplayCondition = 0;
        this.mEfMWIS = null;
        this.mEfCPHS_MWI = null;
        this.mSpdi = null;
        this.mPnnHomeName = null;
        this.mPnns = null;
        this.mOpl = null;
        this.mGid1 = null;
        this.mGid2 = null;
        this.mPlmnActRecords = null;
        this.mOplmnActRecords = null;
        this.mHplmnActRecords = null;
        this.mFplmns = null;
        this.mEhplmns = null;
        this.mAdnCache.reset();
        log("SIMRecords: onRadioOffOrNotAvailable set 'gsm.sim.operator.numeric' to operator=null");
        log("update icc_operator_numeric=" + null);
        this.mTelephonyManager.setSimOperatorNumericForPhone(this.mParentApp.getPhoneId(), "");
        this.mTelephonyManager.setSimOperatorNameForPhone(this.mParentApp.getPhoneId(), "");
        this.mTelephonyManager.setSimCountryIsoForPhone(this.mParentApp.getPhoneId(), "");
        this.mRecordsRequested = false;
        this.mLockedRecordsReqReason = 0;
        this.mLoaded.set(false);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getMsisdnNumber() {
        return this.mMsisdn;
    }

    public UsimServiceTable getUsimServiceTable() {
        return this.mUsimServiceTable;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getExtFromEf(int i) {
        return (i == 28480 && this.mParentApp.getType() == IccCardApplicationStatus.AppType.APPTYPE_USIM) ? IccConstants.EF_EXT5 : IccConstants.EF_EXT1;
    }

    public void setMsisdnNumber(String str, String str2, Message message) {
        if (!this.mDestroyed.get()) {
            this.mNewMsisdn = str2;
            this.mNewMsisdnTag = str;
            log("Set MSISDN: " + this.mNewMsisdnTag + " " + Rlog.pii(LOG_TAG, this.mNewMsisdn));
            new AdnRecordLoader(this.mFh).updateEF(new AdnRecord(this.mNewMsisdnTag, this.mNewMsisdn), IccConstants.EF_MSISDN, getExtFromEf(IccConstants.EF_MSISDN), 1, (String) null, obtainMessage(30, message));
        }
    }

    public String getMsisdnAlphaTag() {
        return this.mMsisdnTag;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getVoiceMailNumber() {
        return this.mVoiceMailNum;
    }

    public void setVoiceMailNumber(String str, String str2, Message message) {
        if (!this.mDestroyed.get()) {
            if (this.mIsVoiceMailFixed) {
                AsyncResult.forMessage(message).exception = new IccVmFixedException("Voicemail number is fixed by operator");
                message.sendToTarget();
                return;
            }
            this.mNewVoiceMailNum = str2;
            this.mNewVoiceMailTag = str;
            AdnRecord adnRecord = new AdnRecord(this.mNewVoiceMailTag, this.mNewVoiceMailNum);
            int i = this.mMailboxIndex;
            if (i != 0 && i != 255) {
                new AdnRecordLoader(this.mFh).updateEF(adnRecord, IccConstants.EF_MBDN, IccConstants.EF_EXT6, this.mMailboxIndex, (String) null, obtainMessage(20, message));
            } else if (isCphsMailboxEnabled()) {
                new AdnRecordLoader(this.mFh).updateEF(adnRecord, IccConstants.EF_MAILBOX_CPHS, IccConstants.EF_EXT1, 1, (String) null, obtainMessage(25, message));
            } else {
                AsyncResult.forMessage(message).exception = new IccVmNotSupportedException("Update SIM voice mailbox error");
                message.sendToTarget();
            }
        }
    }

    public String getVoiceMailAlphaTag() {
        return this.mVoiceMailTag;
    }

    public void setVoiceMessageWaiting(int i, int i2) {
        if (!this.mDestroyed.get() && i == 1) {
            try {
                byte[] bArr = this.mEfMWIS;
                if (bArr != null) {
                    bArr[0] = (byte) ((bArr[0] & 254) | (i2 == 0 ? (byte) 0 : 1));
                    if (i2 < 0) {
                        bArr[1] = 0;
                    } else {
                        bArr[1] = (byte) i2;
                    }
                    this.mFh.updateEFLinearFixed(IccConstants.EF_MWIS, 1, bArr, (String) null, obtainMessage(14, IccConstants.EF_MWIS, 0));
                }
                if (this.mParentApp.getType() == IccCardApplicationStatus.AppType.APPTYPE_USIM) {
                    log("[setVoiceMessageWaiting] It is USIM card, skip write CPHS file");
                    return;
                }
                byte[] bArr2 = this.mEfCPHS_MWI;
                if (bArr2 != null) {
                    bArr2[0] = (byte) ((i2 == 0 ? (byte) 5 : 10) | (bArr2[0] & 240));
                    this.mFh.updateEFTransparent(IccConstants.EF_VOICE_MAIL_INDICATOR_CPHS, bArr2, obtainMessage(14, Integer.valueOf(IccConstants.EF_VOICE_MAIL_INDICATOR_CPHS)));
                }
            } catch (ArrayIndexOutOfBoundsException e) {
                logw("Error saving voice mail state to SIM. Probably malformed SIM record", e);
            }
        }
    }

    /* access modifiers changed from: protected */
    public boolean validEfCfis(byte[] bArr) {
        if (bArr != null) {
            byte b = bArr[0];
            if (b < 1 || b > 4) {
                logw("MSP byte: " + bArr[0] + " is not between 1 and 4", (Throwable) null);
            }
            for (byte b2 : bArr) {
                if (b2 != -1) {
                    return true;
                }
            }
        }
        return false;
    }

    public int getVoiceMessageCount() {
        byte[] bArr = this.mEfMWIS;
        byte b = -1;
        boolean z = false;
        if (bArr != null) {
            if ((bArr[0] & 1) != 0) {
                z = true;
            }
            byte b2 = bArr[1] & UByte.MAX_VALUE;
            if (!z || !(b2 == 0 || b2 == 255)) {
                b = b2;
            }
            log(" VoiceMessageCount from SIM MWIS = " + b);
        } else {
            byte[] bArr2 = this.mEfCPHS_MWI;
            if (bArr2 == null) {
                return -2;
            }
            byte b3 = bArr2[0] & 15;
            if (b3 != 10) {
                b = b3 == 5 ? (byte) 0 : -2;
            }
            log(" VoiceMessageCount from SIM CPHS = " + b);
        }
        return b;
    }

    public int getVoiceCallForwardingFlag() {
        return this.mCallForwardingStatus;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setVoiceCallForwardingFlag(int i, boolean z, String str) {
        if (!this.mDestroyed.get() && i == 1) {
            this.mCallForwardingStatus = z ? 1 : 0;
            this.mRecordsEventsRegistrants.notifyResult(1);
            try {
                if (validEfCfis(this.mEfCfis)) {
                    if (z) {
                        byte[] bArr = this.mEfCfis;
                        bArr[1] = (byte) (bArr[1] | 1);
                    } else {
                        byte[] bArr2 = this.mEfCfis;
                        bArr2[1] = (byte) (bArr2[1] & 254);
                    }
                    log("setVoiceCallForwardingFlag: enable=" + z + " mEfCfis=" + IccUtils.bytesToHexString(this.mEfCfis));
                    if (z && !TextUtils.isEmpty(str)) {
                        logv("EF_CFIS: updating cf number, " + Rlog.pii(LOG_TAG, str));
                        byte[] numberToCalledPartyBCD = PhoneNumberUtils.numberToCalledPartyBCD(str, 1);
                        System.arraycopy(numberToCalledPartyBCD, 0, this.mEfCfis, 3, numberToCalledPartyBCD.length);
                        byte[] bArr3 = this.mEfCfis;
                        bArr3[2] = (byte) numberToCalledPartyBCD.length;
                        bArr3[14] = -1;
                        bArr3[15] = -1;
                    }
                    this.mFh.updateEFLinearFixed(IccConstants.EF_CFIS, 1, this.mEfCfis, (String) null, obtainMessage(14, Integer.valueOf(IccConstants.EF_CFIS)));
                } else {
                    log("setVoiceCallForwardingFlag: ignoring enable=" + z + " invalid mEfCfis=" + IccUtils.bytesToHexString(this.mEfCfis));
                }
                byte[] bArr4 = this.mEfCff;
                if (bArr4 != null) {
                    if (z) {
                        bArr4[0] = (byte) ((bArr4[0] & 240) | 10);
                    } else {
                        bArr4[0] = (byte) ((bArr4[0] & 240) | 5);
                    }
                    this.mFh.updateEFTransparent(IccConstants.EF_CFF_CPHS, bArr4, obtainMessage(14, Integer.valueOf(IccConstants.EF_CFF_CPHS)));
                }
            } catch (ArrayIndexOutOfBoundsException e) {
                logw("Error saving call forwarding flag to SIM. Probably malformed SIM record", e);
            }
        }
    }

    public void onRefresh(boolean z, int[] iArr) {
        if (z) {
            fetchSimRecords();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getOperatorNumeric() {
        String imsi = getIMSI();
        if (imsi == null) {
            log("getOperatorNumeric: IMSI == null");
            return null;
        }
        int i = this.mMncLength;
        if (i == -1 || i == 0) {
            log("getSIMOperatorNumeric: bad mncLength");
            return null;
        }
        int length = imsi.length();
        int i2 = this.mMncLength;
        if (length >= i2 + 3) {
            return imsi.substring(0, i2 + 3);
        }
        return null;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:184:0x065f, code lost:
        r0 = true;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:210:0x0704, code lost:
        r12 = move-exception;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:212:?, code lost:
        updateOperatorPlmn();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:213:0x0708, code lost:
        throw r12;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:265:0x08e9, code lost:
        r12 = th;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:266:0x08ea, code lost:
        r0 = true;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:267:0x08ec, code lost:
        r12 = e;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:268:0x08ed, code lost:
        r0 = true;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:269:0x08ef, code lost:
        if (r0 == false) goto L_?;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:280:?, code lost:
        return;
     */
    /* JADX WARNING: Exception block dominator not found, dom blocks: [B:34:0x0132, B:190:0x069f] */
    /* JADX WARNING: Removed duplicated region for block: B:278:0x0903  */
    /* JADX WARNING: Removed duplicated region for block: B:43:0x0164 A[SYNTHETIC, Splitter:B:43:0x0164] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleMessage(android.os.Message r12) {
        /*
            r11 = this;
            java.util.concurrent.atomic.AtomicBoolean r0 = r11.mDestroyed
            boolean r0 = r0.get()
            if (r0 == 0) goto L_0x0032
            boolean r0 = r11.shallIgnoreMessage(r12)
            if (r0 == 0) goto L_0x0032
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "Received message "
            r0.append(r1)
            r0.append(r12)
            java.lang.String r1 = "["
            r0.append(r1)
            int r12 = r12.what
            r0.append(r12)
            java.lang.String r12 = "]  while being destroyed. Ignoring."
            r0.append(r12)
            java.lang.String r12 = r0.toString()
            r11.loge(r12)
            return
        L_0x0032:
            r0 = 0
            r1 = 1
            int r2 = r12.what     // Catch:{ RuntimeException -> 0x08f7 }
            r3 = 1238273(0x12e501, float:1.73519E-39)
            r4 = 6
            r5 = 28490(0x6f4a, float:3.9923E-41)
            r6 = 28439(0x6f17, float:3.9852E-41)
            java.lang.String r7 = "Received a PlmnActRecord, raw="
            r8 = 255(0xff, float:3.57E-43)
            r9 = 11
            r10 = 0
            switch(r2) {
                case 3: goto L_0x08c0;
                case 4: goto L_0x0888;
                case 5: goto L_0x0828;
                case 6: goto L_0x0795;
                case 7: goto L_0x0749;
                case 8: goto L_0x0709;
                case 9: goto L_0x069d;
                case 10: goto L_0x0662;
                case 11: goto L_0x0795;
                case 12: goto L_0x0658;
                case 13: goto L_0x0647;
                case 14: goto L_0x0637;
                case 15: goto L_0x0626;
                case 16: goto L_0x0615;
                case 17: goto L_0x05ea;
                case 18: goto L_0x05d7;
                case 19: goto L_0x05bf;
                case 20: goto L_0x04ed;
                case 21: goto L_0x0497;
                case 22: goto L_0x046e;
                case 23: goto L_0x0048;
                case 24: goto L_0x0442;
                case 25: goto L_0x03fd;
                case 26: goto L_0x03d1;
                case 27: goto L_0x0048;
                case 28: goto L_0x0048;
                case 29: goto L_0x0048;
                case 30: goto L_0x03a5;
                case 31: goto L_0x0048;
                case 32: goto L_0x0379;
                case 33: goto L_0x0338;
                case 34: goto L_0x02f4;
                case 35: goto L_0x0048;
                case 36: goto L_0x02b0;
                case 37: goto L_0x026b;
                case 38: goto L_0x0226;
                case 39: goto L_0x01c7;
                case 40: goto L_0x0196;
                case 41: goto L_0x0132;
                case 42: goto L_0x00b0;
                case 43: goto L_0x004d;
                default: goto L_0x0048;
            }
        L_0x0048:
            super.handleMessage(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x004d:
            java.lang.Object r1 = r12.obj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r1 = (android.os.AsyncResult) r1     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r1.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r2 == 0) goto L_0x006d
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "Failed setting Forbidden PLMNs: "
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r1 = r1.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r12.append(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x006d:
            int r2 = r12.arg2     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Integer r2 = java.lang.Integer.valueOf(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            android.util.Pair r2 = r11.retrievePendingTransaction(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r4 = r2.first     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r4 = (android.os.Message) r4     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r2 = r2.second     // Catch:{ RuntimeException -> 0x08f7 }
            java.util.List r2 = (java.util.List) r2     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String[] r5 = new java.lang.String[r0]     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object[] r2 = r2.toArray(r5)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String[] r2 = (java.lang.String[]) r2     // Catch:{ RuntimeException -> 0x08f7 }
            r11.mFplmns = r2     // Catch:{ RuntimeException -> 0x08f7 }
            int r12 = r12.arg1     // Catch:{ RuntimeException -> 0x08f7 }
            if (r12 != r3) goto L_0x0098
            int r12 = r2.length     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Integer r12 = java.lang.Integer.valueOf(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult.forMessage(r4, r12, r10)     // Catch:{ RuntimeException -> 0x08f7 }
            r4.sendToTarget()     // Catch:{ RuntimeException -> 0x08f7 }
        L_0x0098:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "Successfully setted fplmns "
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r1 = r1.result     // Catch:{ RuntimeException -> 0x08f7 }
            r12.append(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x00b0:
            java.lang.Object r1 = r12.obj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r1 = (android.os.AsyncResult) r1     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r1.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r2 == 0) goto L_0x00c9
            java.lang.Object r12 = r1.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r12 = (android.os.Message) r12     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r2 = android.os.AsyncResult.forMessage(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r1 = r1.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r2.exception = r1     // Catch:{ RuntimeException -> 0x08f7 }
            r12.sendToTarget()     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x00c9:
            int r2 = r12.arg2     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Integer r2 = java.lang.Integer.valueOf(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            android.util.Pair r2 = r11.retrievePendingTransaction(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r3 = r2.first     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r3 = (android.os.Message) r3     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r2 = r2.second     // Catch:{ RuntimeException -> 0x08f7 }
            java.util.List r2 = (java.util.List) r2     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r1 = r1.result     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Integer r1 = (java.lang.Integer) r1     // Catch:{ RuntimeException -> 0x08f7 }
            int r1 = r1.intValue()     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 < 0) goto L_0x0111
            int r4 = r1 % 3
            if (r4 == 0) goto L_0x00ea
            goto L_0x0111
        L_0x00ea:
            int r4 = r1 / 3
            int r5 = r2.size()     // Catch:{ RuntimeException -> 0x08f7 }
            if (r5 > r4) goto L_0x00f4
            r4 = r2
            goto L_0x00f8
        L_0x00f4:
            java.util.List r4 = r2.subList(r0, r4)     // Catch:{ RuntimeException -> 0x08f7 }
        L_0x00f8:
            int r3 = r11.storePendingTransaction(r3, r4)     // Catch:{ RuntimeException -> 0x08f7 }
            byte[] r1 = com.android.internal.telephony.uicc.IccUtils.encodeFplmns(r2, r1)     // Catch:{ RuntimeException -> 0x08f7 }
            com.android.internal.telephony.uicc.IccFileHandler r2 = r11.mFh     // Catch:{ RuntimeException -> 0x08f7 }
            r4 = 28539(0x6f7b, float:3.9992E-41)
            r5 = 43
            int r12 = r12.arg1     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r12 = r11.obtainMessage(r5, r12, r3)     // Catch:{ RuntimeException -> 0x08f7 }
            r2.updateEFTransparent(r4, r1, r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x0111:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "Failed to retrieve a correct fplmn size: "
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            r12.append(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            r12 = -1
            java.lang.Integer r12 = java.lang.Integer.valueOf(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult.forMessage(r3, r12, r10)     // Catch:{ RuntimeException -> 0x08f7 }
            r3.sendToTarget()     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x0132:
            java.lang.Object r2 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r2 = (android.os.AsyncResult) r2     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r4 = r2.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r4 = (byte[]) r4     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r5 = r2.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r5 != 0) goto L_0x014a
            if (r4 != 0) goto L_0x0141
            goto L_0x014a
        L_0x0141:
            java.lang.String r5 = "Forbidden"
            java.lang.String[] r5 = r11.parseBcdPlmnList(r4, r5)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mFplmns = r5     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x0160
        L_0x014a:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r5.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r6 = "Failed getting Forbidden PLMNs: "
            r5.append(r6)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r6 = r2.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r5.append(r6)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r5 = r5.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r5)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
        L_0x0160:
            int r5 = r12.arg1     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r5 != r3) goto L_0x065f
            int r12 = r12.arg2     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Integer r12 = java.lang.Integer.valueOf(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            android.util.Pair r12 = r11.retrievePendingTransaction(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r12 = r12.first     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r12 = (android.os.Message) r12     // Catch:{ RuntimeException -> 0x08f7 }
            if (r12 == 0) goto L_0x018f
            java.lang.Throwable r1 = r2.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 != 0) goto L_0x0187
            if (r4 == 0) goto L_0x0187
            java.lang.String[] r2 = r11.mFplmns     // Catch:{ RuntimeException -> 0x08f7 }
            if (r2 == 0) goto L_0x0187
            int r1 = r2.length     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object[] r1 = java.util.Arrays.copyOf(r2, r1)     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult.forMessage(r12, r1, r10)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x018a
        L_0x0187:
            android.os.AsyncResult.forMessage(r12, r10, r1)     // Catch:{ RuntimeException -> 0x08f7 }
        L_0x018a:
            r12.sendToTarget()     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x018f:
            java.lang.String r12 = "Failed to retrieve a response message for FPLMN"
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x0196:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 != 0) goto L_0x01af
            if (r0 != 0) goto L_0x01a5
            goto L_0x01af
        L_0x01a5:
            java.lang.String r12 = "Equivalent Home"
            java.lang.String[] r12 = r11.parseBcdPlmnList(r0, r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mEhplmns = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x01af:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Failed getting Equivalent Home PLMNs: "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x01c7:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 != 0) goto L_0x020e
            if (r0 != 0) goto L_0x01d6
            goto L_0x020e
        L_0x01d6:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r7)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.PlmnActRecord[] r12 = com.android.internal.telephony.uicc.PlmnActRecord.getRecords(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mHplmnActRecords = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = "HplmnActRecord[]="
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.PlmnActRecord[] r0 = r11.mHplmnActRecords     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = java.util.Arrays.toString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x020e:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Failed getting Home PLMN with Access Tech Records: "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0226:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 != 0) goto L_0x0253
            if (r0 != 0) goto L_0x0235
            goto L_0x0253
        L_0x0235:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r7)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.PlmnActRecord[] r12 = com.android.internal.telephony.uicc.PlmnActRecord.getRecords(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mOplmnActRecords = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0253:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Failed getting Operator PLMN with Access Tech Records: "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x026b:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 != 0) goto L_0x0298
            if (r0 != 0) goto L_0x027a
            goto L_0x0298
        L_0x027a:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r7)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.PlmnActRecord[] r12 = com.android.internal.telephony.uicc.PlmnActRecord.getRecords(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mPlmnActRecords = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0298:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Failed getting User PLMN with Access Tech Records: "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x02b0:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 == 0) goto L_0x02d6
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Exception in get GID2 "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mGid2 = r10     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x02d6:
            java.lang.String r12 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mGid2 = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = "GID2: "
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = r11.mGid2     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x02f4:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 == 0) goto L_0x031a
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Exception in get GID1 "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mGid1 = r10     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x031a:
            java.lang.String r12 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mGid1 = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = "GID1: "
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = r11.mGid1     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0338:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r0 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r0 == 0) goto L_0x0358
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Exception in fetching EF_CSP data "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0358:
            java.lang.Object r12 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r12 = (byte[]) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "EF_CSP: "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.handleEfCspData(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0379:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 == 0) goto L_0x0389
            r11.mEfCfis = r10     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0389:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "EF_CFIS: "
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mEfCfis = r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x03a5:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r1 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 != 0) goto L_0x03ba
            java.lang.String r1 = r11.mNewMsisdn     // Catch:{ RuntimeException -> 0x08f7 }
            r11.mMsisdn = r1     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r1 = r11.mNewMsisdnTag     // Catch:{ RuntimeException -> 0x08f7 }
            r11.mMsisdnTag = r1     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r1 = "Success to update EF[MSISDN]"
            r11.log(r1)     // Catch:{ RuntimeException -> 0x08f7 }
        L_0x03ba:
            java.lang.Object r1 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 == 0) goto L_0x08ef
            android.os.Message r1 = (android.os.Message) r1     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r1 = android.os.AsyncResult.forMessage(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r1.exception = r2     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r12 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r12 = (android.os.Message) r12     // Catch:{ RuntimeException -> 0x08f7 }
            r12.sendToTarget()     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x03d1:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r0 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r0 == 0) goto L_0x03db
            goto L_0x065f
        L_0x03db:
            java.lang.Object r12 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r12 = (byte[]) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mCphsInfo = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = "iCPHS: "
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = r11.mCphsInfo     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x03fd:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r1 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 != 0) goto L_0x040e
            java.lang.String r1 = r11.mNewVoiceMailNum     // Catch:{ RuntimeException -> 0x08f7 }
            r11.mVoiceMailNum = r1     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r1 = r11.mNewVoiceMailTag     // Catch:{ RuntimeException -> 0x08f7 }
            r11.mVoiceMailTag = r1     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x0424
        L_0x040e:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "Set CPHS MailBox with exception: "
            r1.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.log(r1)     // Catch:{ RuntimeException -> 0x08f7 }
        L_0x0424:
            java.lang.Object r1 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 == 0) goto L_0x08ef
            java.lang.String r1 = "Callback with CPHS MB successful."
            r11.log(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r1 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r1 = (android.os.Message) r1     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r1 = android.os.AsyncResult.forMessage(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r1.exception = r2     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r12 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r12 = (android.os.Message) r12     // Catch:{ RuntimeException -> 0x08f7 }
            r12.sendToTarget()     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x0442:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 == 0) goto L_0x0452
            r11.mEfCff = r10     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0452:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "EF_CFF_CPHS: "
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mEfCff = r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x046e:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r1 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 != 0) goto L_0x047f
            java.lang.Object r12 = r12.result     // Catch:{ RuntimeException -> 0x08f7 }
            byte[] r12 = (byte[]) r12     // Catch:{ RuntimeException -> 0x08f7 }
            r11.handleSms(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x047f:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "Error on GET_SMS with exp "
            r1.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r1.append(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = r1.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x0497:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r1 = r12.result     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Integer r1 = (java.lang.Integer) r1     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r2 != 0) goto L_0x04cd
            if (r1 != 0) goto L_0x04a6
            goto L_0x04cd
        L_0x04a6:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "READ EF_SMS RECORD index="
            r12.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            r12.append(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            com.android.internal.telephony.uicc.IccFileHandler r12 = r11.mFh     // Catch:{ RuntimeException -> 0x08f7 }
            r2 = 28476(0x6f3c, float:3.9903E-41)
            int r1 = r1.intValue()     // Catch:{ RuntimeException -> 0x08f7 }
            r3 = 22
            android.os.Message r3 = r11.obtainMessage(r3)     // Catch:{ RuntimeException -> 0x08f7 }
            r12.loadEFLinearFixed(r2, r1, r3)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x04cd:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r2.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r3 = "Error on SMS_ON_SIM with exp "
            r2.append(r3)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r2.append(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = " index "
            r2.append(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            r2.append(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = r2.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x04ed:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "EVENT_SET_MBDN_DONE ex:"
            r1.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.log(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r1 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 != 0) goto L_0x0513
            java.lang.String r1 = r11.mNewVoiceMailNum     // Catch:{ RuntimeException -> 0x08f7 }
            r11.mVoiceMailNum = r1     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r1 = r11.mNewVoiceMailTag     // Catch:{ RuntimeException -> 0x08f7 }
            r11.mVoiceMailTag = r1     // Catch:{ RuntimeException -> 0x08f7 }
        L_0x0513:
            boolean r1 = r11.isCphsMailboxEnabled()     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 == 0) goto L_0x055b
            com.android.internal.telephony.uicc.AdnRecord r3 = new com.android.internal.telephony.uicc.AdnRecord     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r1 = r11.mVoiceMailTag     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = r11.mVoiceMailNum     // Catch:{ RuntimeException -> 0x08f7 }
            r3.<init>(r1, r2)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r1 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            r2 = r1
            android.os.Message r2 = (android.os.Message) r2     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r4 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r4 != 0) goto L_0x0542
            if (r1 == 0) goto L_0x0542
            android.os.Message r1 = (android.os.Message) r1     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r1 = android.os.AsyncResult.forMessage(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            r1.exception = r10     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r12 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r12 = (android.os.Message) r12     // Catch:{ RuntimeException -> 0x08f7 }
            r12.sendToTarget()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = "Callback with MBDN successful."
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x0543
        L_0x0542:
            r10 = r2
        L_0x0543:
            com.android.internal.telephony.uicc.AdnRecordLoader r2 = new com.android.internal.telephony.uicc.AdnRecordLoader     // Catch:{ RuntimeException -> 0x08f7 }
            com.android.internal.telephony.uicc.IccFileHandler r12 = r11.mFh     // Catch:{ RuntimeException -> 0x08f7 }
            r2.<init>(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            r4 = 28439(0x6f17, float:3.9852E-41)
            r5 = 28490(0x6f4a, float:3.9923E-41)
            r6 = 1
            r7 = 0
            r12 = 25
            android.os.Message r8 = r11.obtainMessage(r12, r10)     // Catch:{ RuntimeException -> 0x08f7 }
            r2.updateEF(r3, r4, r5, r6, r7, r8)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x055b:
            java.lang.Object r1 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 == 0) goto L_0x08ef
            android.content.Context r1 = r11.mContext     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "carrier_config"
            java.lang.Object r1 = r1.getSystemService(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            android.telephony.CarrierConfigManager r1 = (android.telephony.CarrierConfigManager) r1     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r2 == 0) goto L_0x05aa
            if (r1 == 0) goto L_0x05aa
            com.android.internal.telephony.SubscriptionController r2 = com.android.internal.telephony.SubscriptionController.getInstance()     // Catch:{ RuntimeException -> 0x08f7 }
            com.android.internal.telephony.uicc.UiccCardApplication r3 = r11.mParentApp     // Catch:{ RuntimeException -> 0x08f7 }
            int r3 = r3.getPhoneId()     // Catch:{ RuntimeException -> 0x08f7 }
            int r2 = r2.getSubIdUsingPhoneId(r3)     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.PersistableBundle r1 = r1.getConfigForSubId(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 == 0) goto L_0x059d
            java.lang.String r2 = "editable_voicemail_number_bool"
            boolean r1 = r1.getBoolean(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            if (r1 == 0) goto L_0x059d
            java.lang.Object r1 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r1 = (android.os.Message) r1     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r1 = android.os.AsyncResult.forMessage(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            com.android.internal.telephony.uicc.IccVmNotSupportedException r2 = new com.android.internal.telephony.uicc.IccVmNotSupportedException     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r3 = "Update SIM voice mailbox error"
            r2.<init>(r3)     // Catch:{ RuntimeException -> 0x08f7 }
            r1.exception = r2     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x05b6
        L_0x059d:
            java.lang.Object r1 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r1 = (android.os.Message) r1     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r1 = android.os.AsyncResult.forMessage(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r1.exception = r2     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x05b6
        L_0x05aa:
            java.lang.Object r1 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r1 = (android.os.Message) r1     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r1 = android.os.AsyncResult.forMessage(r1)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            r1.exception = r2     // Catch:{ RuntimeException -> 0x08f7 }
        L_0x05b6:
            java.lang.Object r12 = r12.userObj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.Message r12 = (android.os.Message) r12     // Catch:{ RuntimeException -> 0x08f7 }
            r12.sendToTarget()     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x05bf:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08f7 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r2 = "marked read: sms "
            r1.append(r2)     // Catch:{ RuntimeException -> 0x08f7 }
            int r12 = r12.arg1     // Catch:{ RuntimeException -> 0x08f7 }
            r1.append(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.String r12 = r1.toString()     // Catch:{ RuntimeException -> 0x08f7 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x05d7:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r0 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r0 == 0) goto L_0x05e1
            goto L_0x065f
        L_0x05e1:
            java.lang.Object r12 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.util.ArrayList r12 = (java.util.ArrayList) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.handleSmses(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x05ea:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 == 0) goto L_0x05f7
            goto L_0x065f
        L_0x05f7:
            com.android.internal.telephony.uicc.UsimServiceTable r12 = new com.android.internal.telephony.uicc.UsimServiceTable     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mUsimServiceTable = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = "SST: "
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.UsimServiceTable r0 = r11.mUsimServiceTable     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0615:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r0 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r0 == 0) goto L_0x061e
            goto L_0x065f
        L_0x061e:
            java.lang.Object r12 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.util.ArrayList r12 = (java.util.ArrayList) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.parseEfOpl(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0626:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r0 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r0 == 0) goto L_0x062f
            goto L_0x065f
        L_0x062f:
            java.lang.Object r12 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.util.ArrayList r12 = (java.util.ArrayList) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.parseEfPnn(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0637:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08f7 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08f7 }
            if (r12 == 0) goto L_0x08ef
            java.lang.String r1 = "update failed. "
            r11.logw(r1, r12)     // Catch:{ RuntimeException -> 0x08f7 }
            goto L_0x08ef
        L_0x0647:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 == 0) goto L_0x0654
            goto L_0x065f
        L_0x0654:
            r11.parseEfSpdi(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0658:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.getSpnFsm(r0, r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
        L_0x065f:
            r0 = r1
            goto L_0x08ef
        L_0x0662:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r0 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r0 == 0) goto L_0x0670
            java.lang.String r12 = "Invalid or missing EF[MSISDN]"
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0670:
            java.lang.Object r12 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.AdnRecord r12 = (com.android.internal.telephony.uicc.AdnRecord) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = r12.getNumber()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mMsisdn = r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.getAlphaTag()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mMsisdnTag = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = "MSISDN: "
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = "SIMRecords"
            java.lang.String r2 = r11.mMsisdn     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = com.android.telephony.Rlog.pii(r0, r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x069d:
            r11.mMncLength = r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.CarrierTestOverride r0 = r11.mCarrierTestOverride     // Catch:{ all -> 0x0704 }
            boolean r0 = r0.isInTestMode()     // Catch:{ all -> 0x0704 }
            if (r0 != 0) goto L_0x06b3
            java.lang.Object r12 = r12.obj     // Catch:{ all -> 0x0704 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ all -> 0x0704 }
            java.lang.Object r0 = r12.result     // Catch:{ all -> 0x0704 }
            byte[] r0 = (byte[]) r0     // Catch:{ all -> 0x0704 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ all -> 0x0704 }
            if (r12 == 0) goto L_0x06b7
        L_0x06b3:
            r11.updateOperatorPlmn()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x06b7:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ all -> 0x0704 }
            r12.<init>()     // Catch:{ all -> 0x0704 }
            java.lang.String r2 = "EF_AD: "
            r12.append(r2)     // Catch:{ all -> 0x0704 }
            java.lang.String r2 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ all -> 0x0704 }
            r12.append(r2)     // Catch:{ all -> 0x0704 }
            java.lang.String r12 = r12.toString()     // Catch:{ all -> 0x0704 }
            r11.log(r12)     // Catch:{ all -> 0x0704 }
            int r12 = r0.length     // Catch:{ all -> 0x0704 }
            r2 = 3
            if (r12 >= r2) goto L_0x06d9
            java.lang.String r12 = "Corrupt AD data on SIM"
            r11.log(r12)     // Catch:{ all -> 0x0704 }
            goto L_0x06b3
        L_0x06d9:
            int r12 = r0.length     // Catch:{ all -> 0x0704 }
            if (r12 != r2) goto L_0x06e2
            java.lang.String r12 = "MNC length not present in EF_AD"
            r11.log(r12)     // Catch:{ all -> 0x0704 }
            goto L_0x06b3
        L_0x06e2:
            byte r12 = r0[r2]     // Catch:{ all -> 0x0704 }
            r12 = r12 & 15
            r0 = 2
            if (r12 == r0) goto L_0x0701
            if (r12 != r2) goto L_0x06ec
            goto L_0x0701
        L_0x06ec:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x0704 }
            r0.<init>()     // Catch:{ all -> 0x0704 }
            java.lang.String r2 = "Received invalid or unset MNC Length="
            r0.append(r2)     // Catch:{ all -> 0x0704 }
            r0.append(r12)     // Catch:{ all -> 0x0704 }
            java.lang.String r12 = r0.toString()     // Catch:{ all -> 0x0704 }
            r11.log(r12)     // Catch:{ all -> 0x0704 }
            goto L_0x06b3
        L_0x0701:
            r11.mMncLength = r12     // Catch:{ all -> 0x0704 }
            goto L_0x06b3
        L_0x0704:
            r12 = move-exception
            r11.updateOperatorPlmn()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            throw r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
        L_0x0709:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r0 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r0 = (byte[]) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r2.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r3 = "EF_CPHS_MWI: "
            r2.append(r3)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r3 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r2.append(r3)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = r2.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r2 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 == 0) goto L_0x0745
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "EVENT_GET_VOICE_MAIL_INDICATOR_CPHS_DONE exception = "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0745:
            r11.mEfCPHS_MWI = r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0749:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r2 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r2 = (byte[]) r2     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r3.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r4 = "EF_MWIS : "
            r3.append(r4)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r4 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r3.append(r4)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r3 = r3.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r3)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r3 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r3 == 0) goto L_0x0785
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "EVENT_GET_MWIS_DONE exception = "
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0785:
            byte r12 = r2[r0]     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12 = r12 & r8
            if (r12 != r8) goto L_0x0791
            java.lang.String r12 = "SIMRecords: Uninitialized record MWIS"
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0791:
            r11.mEfMWIS = r2     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0795:
            r11.mVoiceMailNum = r10     // Catch:{ RuntimeException -> 0x08f7 }
            r11.mVoiceMailTag = r10     // Catch:{ RuntimeException -> 0x08f7 }
            java.lang.Object r0 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r2 = r0.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 == 0) goto L_0x07d7
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Invalid or missing EF"
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            int r2 = r12.what     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 != r9) goto L_0x07b2
            java.lang.String r2 = "[MAILBOX]"
            goto L_0x07b4
        L_0x07b2:
            java.lang.String r2 = "[MBDN]"
        L_0x07b4:
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            int r12 = r12.what     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 != r4) goto L_0x065f
            int r12 = r11.mRecordsToLoad     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            int r12 = r12 + r1
            r11.mRecordsToLoad = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.AdnRecordLoader r12 = new com.android.internal.telephony.uicc.AdnRecordLoader     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.IccFileHandler r0 = r11.mFh     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.Message r0 = r11.obtainMessage(r9)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.loadFromEF(r6, r5, r1, r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x07d7:
            java.lang.Object r0 = r0.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.AdnRecord r0 = (com.android.internal.telephony.uicc.AdnRecord) r0     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r2.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r3 = "VM: "
            r2.append(r3)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r2.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            int r3 = r12.what     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r3 != r9) goto L_0x07ef
            java.lang.String r3 = " EF[MAILBOX]"
            goto L_0x07f1
        L_0x07ef:
            java.lang.String r3 = " EF[MBDN]"
        L_0x07f1:
            r2.append(r3)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = r2.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            boolean r2 = r0.isEmpty()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r2 == 0) goto L_0x081a
            int r12 = r12.what     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 != r4) goto L_0x081a
            int r12 = r11.mRecordsToLoad     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            int r12 = r12 + r1
            r11.mRecordsToLoad = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.AdnRecordLoader r12 = new com.android.internal.telephony.uicc.AdnRecordLoader     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.IccFileHandler r0 = r11.mFh     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.Message r0 = r11.obtainMessage(r9)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.loadFromEF(r6, r5, r1, r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x081a:
            java.lang.String r12 = r0.getNumber()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mVoiceMailNum = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.getAlphaTag()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mVoiceMailTag = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0828:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r2 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r2 = (byte[]) r2     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 != 0) goto L_0x085b
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r3 = "EF_MBI: "
            r12.append(r3)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r3 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r3)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte r12 = r2[r0]     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12 = r12 & r8
            r11.mMailboxIndex = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 == 0) goto L_0x085b
            if (r12 == r8) goto L_0x085b
            java.lang.String r12 = "Got valid mailbox number for MBDN"
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0 = r1
        L_0x085b:
            int r12 = r11.mRecordsToLoad     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            int r12 = r12 + r1
            r11.mRecordsToLoad = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r0 == 0) goto L_0x0878
            com.android.internal.telephony.uicc.AdnRecordLoader r12 = new com.android.internal.telephony.uicc.AdnRecordLoader     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.IccFileHandler r0 = r11.mFh     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0 = 28615(0x6fc7, float:4.0098E-41)
            r2 = 28616(0x6fc8, float:4.01E-41)
            int r3 = r11.mMailboxIndex     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.Message r4 = r11.obtainMessage(r4)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.loadFromEF(r0, r2, r3, r4)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0878:
            com.android.internal.telephony.uicc.AdnRecordLoader r12 = new com.android.internal.telephony.uicc.AdnRecordLoader     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            com.android.internal.telephony.uicc.IccFileHandler r0 = r11.mFh     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.Message r0 = r11.obtainMessage(r9)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.loadFromEF(r6, r5, r1, r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x0888:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Object r2 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            byte[] r2 = (byte[]) r2     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r12 == 0) goto L_0x0896
            goto L_0x065f
        L_0x0896:
            int r12 = r2.length     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = com.android.internal.telephony.uicc.IccUtils.bcdToString(r2, r0, r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mIccId = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            int r12 = r2.length     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = com.android.internal.telephony.uicc.IccUtils.bchToString(r2, r0, r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.mFullIccId = r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = "iccid: "
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = r11.mFullIccId     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r0 = android.telephony.SubscriptionInfo.givePrintableIccid(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r12.append(r0)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r12.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.log(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x08c0:
            java.lang.Object r12 = r12.obj     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            android.os.AsyncResult r12 = (android.os.AsyncResult) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r0 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            if (r0 == 0) goto L_0x08e0
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.<init>()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r2 = "Exception querying IMSI, Exception:"
            r0.append(r2)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.Throwable r12 = r12.exception     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r0.append(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = r0.toString()     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.loge(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x08e0:
            java.lang.Object r12 = r12.result     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            java.lang.String r12 = (java.lang.String) r12     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            r11.setImsi(r12)     // Catch:{ RuntimeException -> 0x08ec, all -> 0x08e9 }
            goto L_0x065f
        L_0x08e9:
            r12 = move-exception
            r0 = r1
            goto L_0x0901
        L_0x08ec:
            r12 = move-exception
            r0 = r1
            goto L_0x08f8
        L_0x08ef:
            if (r0 == 0) goto L_0x0900
        L_0x08f1:
            r11.onRecordLoaded()
            goto L_0x0900
        L_0x08f5:
            r12 = move-exception
            goto L_0x0901
        L_0x08f7:
            r12 = move-exception
        L_0x08f8:
            java.lang.String r1 = "Exception parsing SIM record"
            r11.logw(r1, r12)     // Catch:{ all -> 0x08f5 }
            if (r0 == 0) goto L_0x0900
            goto L_0x08f1
        L_0x0900:
            return
        L_0x0901:
            if (r0 == 0) goto L_0x0906
            r11.onRecordLoaded()
        L_0x0906:
            throw r12
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.SIMRecords.handleMessage(android.os.Message):void");
    }

    private class EfPlLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_PL";
        }

        private EfPlLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            SIMRecords sIMRecords = SIMRecords.this;
            sIMRecords.mEfPl = (byte[]) asyncResult.result;
            sIMRecords.log("EF_PL=" + IccUtils.bytesToHexString(SIMRecords.this.mEfPl));
        }
    }

    private class EfUsimLiLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_LI";
        }

        private EfUsimLiLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            SIMRecords sIMRecords = SIMRecords.this;
            sIMRecords.mEfLi = (byte[]) asyncResult.result;
            sIMRecords.log("EF_LI=" + IccUtils.bytesToHexString(SIMRecords.this.mEfLi));
        }
    }

    /* access modifiers changed from: protected */
    public void handleFileUpdate(int i) {
        if (i != 28435) {
            if (i == 28437) {
                this.mRecordsToLoad++;
                log("[CSP] SIM Refresh for EF_CSP_CPHS");
                this.mFh.loadEFTransparent(IccConstants.EF_CSP_CPHS, obtainMessage(33));
                return;
            } else if (i == 28439) {
                this.mRecordsToLoad++;
                new AdnRecordLoader(this.mFh).loadFromEF(IccConstants.EF_MAILBOX_CPHS, IccConstants.EF_EXT1, 1, obtainMessage(11));
                return;
            } else if (i == 28475) {
                log("SIM Refresh called for EF_FDN");
                this.mParentApp.queryFdn();
                this.mAdnCache.reset();
                return;
            } else if (i == 28480) {
                this.mRecordsToLoad++;
                log("SIM Refresh called for EF_MSISDN");
                new AdnRecordLoader(this.mFh).loadFromEF(IccConstants.EF_MSISDN, getExtFromEf(IccConstants.EF_MSISDN), 1, obtainMessage(10));
                return;
            } else if (i == 28615) {
                this.mRecordsToLoad++;
                new AdnRecordLoader(this.mFh).loadFromEF(IccConstants.EF_MBDN, IccConstants.EF_EXT6, this.mMailboxIndex, obtainMessage(6));
                return;
            } else if (i != 28619) {
                this.mLoaded.set(false);
                this.mAdnCache.reset();
                fetchSimRecords();
                return;
            }
        }
        log("SIM Refresh called for EF_CFIS or EF_CFF_CPHS");
        loadCallForwardingRecords();
    }

    private void dispatchGsmMessage(SmsMessage smsMessage) {
        this.mNewSmsRegistrants.notifyResult(smsMessage);
    }

    private void handleSms(byte[] bArr) {
        log("handleSms status : " + bArr[0]);
        if ((bArr[0] & 7) == 3) {
            int length = bArr.length - 1;
            byte[] bArr2 = new byte[length];
            System.arraycopy(bArr, 1, bArr2, 0, length);
            dispatchGsmMessage(SmsMessage.createFromPdu(bArr2, "3gpp"));
        }
    }

    private void handleSmses(ArrayList<byte[]> arrayList) {
        int size = arrayList.size();
        for (int i = 0; i < size; i++) {
            byte[] bArr = arrayList.get(i);
            log("handleSmses status " + i + ": " + bArr[0]);
            if ((bArr[0] & 7) == 3) {
                int length = bArr.length - 1;
                byte[] bArr2 = new byte[length];
                System.arraycopy(bArr, 1, bArr2, 0, length);
                dispatchGsmMessage(SmsMessage.createFromPdu(bArr2, "3gpp"));
                bArr[0] = 1;
            }
        }
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

    /* access modifiers changed from: protected */
    public void setVoiceCallForwardingFlagFromSimRecords() {
        int i = 1;
        if (validEfCfis(this.mEfCfis)) {
            this.mCallForwardingStatus = this.mEfCfis[1] & 1;
            log("EF_CFIS: callForwardingEnabled=" + this.mCallForwardingStatus);
            return;
        }
        byte[] bArr = this.mEfCff;
        if (bArr != null) {
            if ((bArr[0] & 15) != 10) {
                i = 0;
            }
            this.mCallForwardingStatus = i;
            log("EF_CFF: callForwardingEnabled=" + this.mCallForwardingStatus);
            return;
        }
        this.mCallForwardingStatus = -1;
        log("EF_CFIS and EF_CFF not valid. callForwardingEnabled=" + this.mCallForwardingStatus);
    }

    private void setSimLanguageFromEF() {
        if (Resources.getSystem().getBoolean(17891823)) {
            setSimLanguage(this.mEfLi, this.mEfPl);
        } else {
            log("Not using EF LI/EF PL");
        }
    }

    private void onLockedAllRecordsLoaded() {
        setSimLanguageFromEF();
        setVoiceCallForwardingFlagFromSimRecords();
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
        setSimLanguageFromEF();
        setVoiceCallForwardingFlagFromSimRecords();
        String operatorNumeric = getOperatorNumeric();
        if (TextUtils.isEmpty(operatorNumeric) || !checkCdma3gCard()) {
            log("onAllRecordsLoaded empty 'gsm.sim.operator.numeric' skipping");
        } else {
            log("onAllRecordsLoaded set 'gsm.sim.operator.numeric' to operator='" + operatorNumeric + "'");
            this.mTelephonyManager.setSimOperatorNumericForPhone(this.mParentApp.getPhoneId(), operatorNumeric);
        }
        String imsi = getIMSI();
        if (TextUtils.isEmpty(imsi) || imsi.length() < 3 || !checkCdma3gCard()) {
            log("onAllRecordsLoaded empty imsi skipping setting mcc");
        } else {
            log("onAllRecordsLoaded set mcc imsi" + "");
            this.mTelephonyManager.setSimCountryIsoForPhone(this.mParentApp.getPhoneId(), MccTable.countryCodeForMcc(imsi.substring(0, 3)));
        }
        setVoiceMailByCountry(operatorNumeric);
        this.mLoaded.set(true);
        this.mRecordsLoadedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
    }

    /* access modifiers changed from: protected */
    public void setVoiceMailByCountry(String str) {
        if (!this.mDestroyed.get() && this.mVmConfig.containsCarrier(str)) {
            this.mIsVoiceMailFixed = true;
            this.mVoiceMailNum = this.mVmConfig.getVoiceMailNumber(str);
            this.mVoiceMailTag = this.mVmConfig.getVoiceMailTag(str);
        }
    }

    public void getForbiddenPlmns(Message message) {
        this.mFh.loadEFTransparent(IccConstants.EF_FPLMN, obtainMessage(41, 1238273, storePendingTransaction(message)));
    }

    public void setForbiddenPlmns(Message message, List<String> list) {
        this.mFh.getEFTransparentRecordSize(IccConstants.EF_FPLMN, obtainMessage(42, 1238273, storePendingTransaction(message, list)));
    }

    public void onReady() {
        fetchSimRecords();
    }

    /* access modifiers changed from: protected */
    public void onLocked() {
        log("only fetch EF_LI, EF_PL and EF_ICCID in locked state");
        super.onLocked();
        loadEfLiAndEfPl();
        this.mFh.loadEFTransparent(IccConstants.EF_ICCID, obtainMessage(4));
        this.mRecordsToLoad++;
    }

    private void loadEfLiAndEfPl() {
        if (this.mParentApp.getType() == IccCardApplicationStatus.AppType.APPTYPE_USIM) {
            this.mFh.loadEFTransparent(IccConstants.EF_LI, obtainMessage(100, new EfUsimLiLoaded()));
            this.mRecordsToLoad++;
            this.mFh.loadEFTransparent(IccConstants.EF_PL, obtainMessage(100, new EfPlLoaded()));
            this.mRecordsToLoad++;
        }
    }

    /* access modifiers changed from: protected */
    public void loadCallForwardingRecords() {
        this.mRecordsRequested = true;
        this.mFh.loadEFLinearFixed(IccConstants.EF_CFIS, 1, obtainMessage(32));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_CFF_CPHS, obtainMessage(24));
        this.mRecordsToLoad++;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void fetchSimRecords() {
        this.mRecordsRequested = true;
        log("fetchSimRecords " + this.mRecordsToLoad);
        this.mCi.getIMSIForApp(this.mParentApp.getAid(), obtainMessage(3));
        this.mRecordsToLoad = this.mRecordsToLoad + 1;
        this.mFh.loadEFTransparent(IccConstants.EF_ICCID, obtainMessage(4));
        this.mRecordsToLoad++;
        new AdnRecordLoader(this.mFh).loadFromEF(IccConstants.EF_MSISDN, getExtFromEf(IccConstants.EF_MSISDN), 1, obtainMessage(10));
        this.mRecordsToLoad++;
        this.mFh.loadEFLinearFixed(IccConstants.EF_MBI, 1, obtainMessage(5));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_AD, obtainMessage(9));
        this.mRecordsToLoad++;
        this.mFh.loadEFLinearFixed(IccConstants.EF_MWIS, 1, obtainMessage(7));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_VOICE_MAIL_INDICATOR_CPHS, obtainMessage(8));
        this.mRecordsToLoad++;
        loadCallForwardingRecords();
        getSpnFsm(true, (AsyncResult) null);
        this.mFh.loadEFTransparent(IccConstants.EF_SPDI, obtainMessage(13));
        this.mRecordsToLoad++;
        this.mFh.loadEFLinearFixedAll(IccConstants.EF_PNN, obtainMessage(15));
        this.mRecordsToLoad++;
        this.mFh.loadEFLinearFixedAll(IccConstants.EF_OPL, obtainMessage(16));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_SST, obtainMessage(17));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_INFO_CPHS, obtainMessage(26));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_CSP_CPHS, obtainMessage(33));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_GID1, obtainMessage(34));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_GID2, obtainMessage(36));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_PLMN_W_ACT, obtainMessage(37));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_OPLMN_W_ACT, obtainMessage(38));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_HPLMN_W_ACT, obtainMessage(39));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_EHPLMN, obtainMessage(40));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_FPLMN, obtainMessage(41, 1238272, -1));
        this.mRecordsToLoad++;
        loadEfLiAndEfPl();
        this.mFh.getEFLinearRecordSize(IccConstants.EF_SMS, obtainMessage(28));
        this.mRecordsToLoad++;
        log("fetchSimRecords " + this.mRecordsToLoad + " requested: " + this.mRecordsRequested);
    }

    public int getCarrierNameDisplayCondition() {
        return this.mCarrierNameDisplayCondition;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void getSpnFsm(boolean z, AsyncResult asyncResult) {
        GetSpnFsmState getSpnFsmState;
        if (z) {
            GetSpnFsmState getSpnFsmState2 = this.mSpnState;
            if (getSpnFsmState2 == GetSpnFsmState.READ_SPN_3GPP || getSpnFsmState2 == GetSpnFsmState.READ_SPN_CPHS || getSpnFsmState2 == GetSpnFsmState.READ_SPN_SHORT_CPHS || getSpnFsmState2 == (getSpnFsmState = GetSpnFsmState.INIT)) {
                this.mSpnState = GetSpnFsmState.INIT;
                return;
            }
            this.mSpnState = getSpnFsmState;
        }
        int i = AnonymousClass1.$SwitchMap$com$android$internal$telephony$uicc$SIMRecords$GetSpnFsmState[this.mSpnState.ordinal()];
        if (i == 1) {
            setServiceProviderName((String) null);
            this.mFh.loadEFTransparent(IccConstants.EF_SPN, obtainMessage(12));
            this.mRecordsToLoad++;
            this.mSpnState = GetSpnFsmState.READ_SPN_3GPP;
        } else if (i == 2) {
            if (asyncResult == null || asyncResult.exception != null) {
                this.mSpnState = GetSpnFsmState.READ_SPN_CPHS;
            } else {
                byte[] bArr = (byte[]) asyncResult.result;
                this.mCarrierNameDisplayCondition = IccRecords.convertSpnDisplayConditionToBitmask(bArr[0] & UByte.MAX_VALUE);
                setServiceProviderName(IccUtils.adnStringFieldToString(bArr, 1, bArr.length - 1));
                String serviceProviderName = getServiceProviderName();
                if (serviceProviderName == null || serviceProviderName.length() == 0) {
                    this.mSpnState = GetSpnFsmState.READ_SPN_CPHS;
                } else {
                    log("Load EF_SPN: " + serviceProviderName + " carrierNameDisplayCondition: " + this.mCarrierNameDisplayCondition);
                    this.mTelephonyManager.setSimOperatorNameForPhone(this.mParentApp.getPhoneId(), serviceProviderName);
                    this.mSpnState = GetSpnFsmState.IDLE;
                }
            }
            if (this.mSpnState == GetSpnFsmState.READ_SPN_CPHS) {
                this.mFh.loadEFTransparent(IccConstants.EF_SPN_CPHS, obtainMessage(12));
                this.mRecordsToLoad++;
                this.mCarrierNameDisplayCondition = 0;
            }
        } else if (i == 3) {
            if (asyncResult == null || asyncResult.exception != null) {
                this.mSpnState = GetSpnFsmState.READ_SPN_SHORT_CPHS;
            } else {
                byte[] bArr2 = (byte[]) asyncResult.result;
                setServiceProviderName(IccUtils.adnStringFieldToString(bArr2, 0, bArr2.length));
                String serviceProviderName2 = getServiceProviderName();
                if (serviceProviderName2 == null || serviceProviderName2.length() == 0) {
                    this.mSpnState = GetSpnFsmState.READ_SPN_SHORT_CPHS;
                } else {
                    this.mCarrierNameDisplayCondition = 0;
                    log("Load EF_SPN_CPHS: " + serviceProviderName2);
                    this.mTelephonyManager.setSimOperatorNameForPhone(this.mParentApp.getPhoneId(), serviceProviderName2);
                    this.mSpnState = GetSpnFsmState.IDLE;
                }
            }
            if (this.mSpnState == GetSpnFsmState.READ_SPN_SHORT_CPHS) {
                this.mFh.loadEFTransparent(IccConstants.EF_SPN_SHORT_CPHS, obtainMessage(12));
                this.mRecordsToLoad++;
            }
        } else if (i != 4) {
            this.mSpnState = GetSpnFsmState.IDLE;
        } else {
            if (asyncResult == null || asyncResult.exception != null) {
                setServiceProviderName((String) null);
                log("No SPN loaded in either CHPS or 3GPP");
            } else {
                byte[] bArr3 = (byte[]) asyncResult.result;
                setServiceProviderName(IccUtils.adnStringFieldToString(bArr3, 0, bArr3.length));
                String serviceProviderName3 = getServiceProviderName();
                if (serviceProviderName3 == null || serviceProviderName3.length() == 0) {
                    log("No SPN loaded in either CHPS or 3GPP");
                } else {
                    this.mCarrierNameDisplayCondition = 0;
                    log("Load EF_SPN_SHORT_CPHS: " + serviceProviderName3);
                    this.mTelephonyManager.setSimOperatorNameForPhone(this.mParentApp.getPhoneId(), serviceProviderName3);
                }
            }
            this.mSpnState = GetSpnFsmState.IDLE;
        }
    }

    /* renamed from: com.android.internal.telephony.uicc.SIMRecords$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$uicc$SIMRecords$GetSpnFsmState;

        /* JADX WARNING: Can't wrap try/catch for region: R(8:0|1|2|3|4|5|6|(3:7|8|10)) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        static {
            /*
                com.android.internal.telephony.uicc.SIMRecords$GetSpnFsmState[] r0 = com.android.internal.telephony.uicc.SIMRecords.GetSpnFsmState.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$uicc$SIMRecords$GetSpnFsmState = r0
                com.android.internal.telephony.uicc.SIMRecords$GetSpnFsmState r1 = com.android.internal.telephony.uicc.SIMRecords.GetSpnFsmState.INIT     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$SIMRecords$GetSpnFsmState     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.uicc.SIMRecords$GetSpnFsmState r1 = com.android.internal.telephony.uicc.SIMRecords.GetSpnFsmState.READ_SPN_3GPP     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$SIMRecords$GetSpnFsmState     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.uicc.SIMRecords$GetSpnFsmState r1 = com.android.internal.telephony.uicc.SIMRecords.GetSpnFsmState.READ_SPN_CPHS     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$SIMRecords$GetSpnFsmState     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.uicc.SIMRecords$GetSpnFsmState r1 = com.android.internal.telephony.uicc.SIMRecords.GetSpnFsmState.READ_SPN_SHORT_CPHS     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.SIMRecords.AnonymousClass1.<clinit>():void");
        }
    }

    private void parseEfSpdi(byte[] bArr) {
        byte[] bArr2;
        SimTlv simTlv = new SimTlv(bArr, 0, bArr.length);
        while (true) {
            if (!simTlv.isValidObject()) {
                bArr2 = null;
                break;
            }
            if (simTlv.getTag() == TAG_SPDI) {
                simTlv = new SimTlv(simTlv.getData(), 0, simTlv.getData().length);
            }
            if (simTlv.getTag() == 128) {
                bArr2 = simTlv.getData();
                break;
            }
            simTlv.nextObject();
        }
        if (bArr2 != null) {
            ArrayList arrayList = new ArrayList(bArr2.length / 3);
            for (int i = 0; i + 2 < bArr2.length; i += 3) {
                String bcdPlmnToString = IccUtils.bcdPlmnToString(bArr2, i);
                if (!TextUtils.isEmpty(bcdPlmnToString)) {
                    arrayList.add(bcdPlmnToString);
                }
            }
            log("parseEfSpdi: " + arrayList);
            this.mSpdi = (String[]) arrayList.toArray(new String[arrayList.size()]);
        }
    }

    private void parseEfPnn(ArrayList<byte[]> arrayList) {
        if (arrayList != null) {
            int size = arrayList.size();
            ArrayList arrayList2 = new ArrayList(size);
            for (int i = 0; i < size; i++) {
                byte[] bArr = arrayList.get(i);
                SimTlv simTlv = new SimTlv(bArr, 0, bArr.length);
                String str = null;
                String str2 = null;
                while (simTlv.isValidObject()) {
                    int tag = simTlv.getTag();
                    if (tag == 67) {
                        str = IccUtils.networkNameToString(simTlv.getData(), 0, simTlv.getData().length);
                    } else if (tag == 69) {
                        str2 = IccUtils.networkNameToString(simTlv.getData(), 0, simTlv.getData().length);
                    }
                    simTlv.nextObject();
                }
                arrayList2.add(new IccRecords.PlmnNetworkName(str, str2));
            }
            log("parseEfPnn: " + arrayList2);
            IccRecords.PlmnNetworkName[] plmnNetworkNameArr = (IccRecords.PlmnNetworkName[]) arrayList2.toArray(new IccRecords.PlmnNetworkName[0]);
            this.mPnns = plmnNetworkNameArr;
            if (plmnNetworkNameArr.length > 0) {
                this.mPnnHomeName = plmnNetworkNameArr[0].getName();
            }
        }
    }

    private void parseEfOpl(ArrayList<byte[]> arrayList) {
        if (arrayList != null) {
            int size = arrayList.size();
            ArrayList arrayList2 = new ArrayList(size);
            for (int i = 0; i < size; i++) {
                byte[] bArr = arrayList.get(i);
                if (bArr.length != 8) {
                    loge("Invalid length for OPL record " + bArr);
                } else {
                    String bcdPlmnToString = IccUtils.bcdPlmnToString(bArr, 0);
                    if (bcdPlmnToString.length() < 5) {
                        loge("Invalid length for decoded PLMN " + bcdPlmnToString);
                    } else {
                        arrayList2.add(new IccRecords.OperatorPlmnInfo(bcdPlmnToString, IccUtils.bytesToInt(bArr, 3, 2), IccUtils.bytesToInt(bArr, 5, 2), IccUtils.bytesToInt(bArr, 7, 1)));
                    }
                }
            }
            log("parseEfOpl: " + arrayList2);
            this.mOpl = (IccRecords.OperatorPlmnInfo[]) arrayList2.toArray(new IccRecords.OperatorPlmnInfo[0]);
        }
    }

    private String[] parseBcdPlmnList(byte[] bArr, String str) {
        log("Received " + str + " PLMNs, raw=" + IccUtils.bytesToHexString(bArr));
        if (bArr.length == 0 || bArr.length % 3 != 0) {
            loge("Received invalid " + str + " PLMN list");
            return null;
        }
        int length = bArr.length / 3;
        String[] strArr = new String[length];
        int i = 0;
        for (int i2 = 0; i2 < length; i2++) {
            String bcdPlmnToString = IccUtils.bcdPlmnToString(bArr, i2 * 3);
            strArr[i] = bcdPlmnToString;
            if (!TextUtils.isEmpty(bcdPlmnToString)) {
                i++;
            }
        }
        return (String[]) Arrays.copyOf(strArr, i);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isCphsMailboxEnabled() {
        byte[] bArr = this.mCphsInfo;
        if (bArr != null && (bArr[1] & 48) == 48) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        if (this.mParentApp != null) {
            Rlog.d(LOG_TAG, "[SIMRecords-" + this.mParentApp.getPhoneId() + "] " + str);
            return;
        }
        Rlog.d(LOG_TAG, "[SIMRecords] " + str);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loge(String str) {
        if (this.mParentApp != null) {
            Rlog.e(LOG_TAG, "[SIMRecords-" + this.mParentApp.getPhoneId() + "] " + str);
            return;
        }
        Rlog.e(LOG_TAG, "[SIMRecords] " + str);
    }

    /* access modifiers changed from: protected */
    public void logw(String str, Throwable th) {
        if (this.mParentApp != null) {
            Rlog.w(LOG_TAG, "[SIMRecords-" + this.mParentApp.getPhoneId() + "] " + str, th);
            return;
        }
        Rlog.w(LOG_TAG, "[SIMRecords] " + str, th);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void logv(String str) {
        if (this.mParentApp != null) {
            Rlog.v(LOG_TAG, "[SIMRecords-" + this.mParentApp.getPhoneId() + "] " + str);
            return;
        }
        Rlog.v(LOG_TAG, "[SIMRecords] " + str);
    }

    public boolean isCspPlmnEnabled() {
        return this.mCspPlmnEnabled;
    }

    private void handleEfCspData(byte[] bArr) {
        int length = bArr.length / 2;
        this.mCspPlmnEnabled = true;
        for (int i = 0; i < length; i++) {
            int i2 = i * 2;
            if (bArr[i2] == -64) {
                StringBuilder sb = new StringBuilder();
                sb.append("[CSP] found ValueAddedServicesGroup, value ");
                int i3 = i2 + 1;
                sb.append(bArr[i3]);
                log(sb.toString());
                if ((bArr[i3] & 128) == 128) {
                    this.mCspPlmnEnabled = true;
                    return;
                }
                this.mCspPlmnEnabled = false;
                log("[CSP] Set Automatic Network Selection");
                this.mNetworkSelectionModeAutomaticRegistrants.notifyRegistrants();
                return;
            }
        }
        log("[CSP] Value Added Service Group (0xC0), not found!");
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("SIMRecords: " + this);
        printWriter.println(" extends:");
        super.dump(fileDescriptor, printWriter, strArr);
        printWriter.println(" mVmConfig=" + this.mVmConfig);
        printWriter.println(" mCallForwardingStatus=" + this.mCallForwardingStatus);
        printWriter.println(" mSpnState=" + this.mSpnState);
        printWriter.println(" mCphsInfo=" + this.mCphsInfo);
        printWriter.println(" mCspPlmnEnabled=" + this.mCspPlmnEnabled);
        printWriter.println(" mEfMWIS[]=" + Arrays.toString(this.mEfMWIS));
        printWriter.println(" mEfCPHS_MWI[]=" + Arrays.toString(this.mEfCPHS_MWI));
        printWriter.println(" mEfCff[]=" + Arrays.toString(this.mEfCff));
        printWriter.println(" mEfCfis[]=" + Arrays.toString(this.mEfCfis));
        printWriter.println(" mCarrierNameDisplayCondition=" + this.mCarrierNameDisplayCondition);
        printWriter.println(" mSpdi[]=" + this.mSpdi);
        printWriter.println(" mUsimServiceTable=" + this.mUsimServiceTable);
        printWriter.println(" mGid1=" + this.mGid1);
        if (this.mCarrierTestOverride.isInTestMode()) {
            printWriter.println(" mFakeGid1=" + this.mCarrierTestOverride.getFakeGid1());
        }
        printWriter.println(" mGid2=" + this.mGid2);
        if (this.mCarrierTestOverride.isInTestMode()) {
            printWriter.println(" mFakeGid2=" + this.mCarrierTestOverride.getFakeGid2());
        }
        printWriter.println(" mPnnHomeName=" + this.mPnnHomeName);
        if (this.mCarrierTestOverride.isInTestMode()) {
            printWriter.println(" mFakePnnHomeName=" + this.mCarrierTestOverride.getFakePnnHomeName());
        }
        printWriter.println(" mPlmnActRecords[]=" + Arrays.toString(this.mPlmnActRecords));
        printWriter.println(" mOplmnActRecords[]=" + Arrays.toString(this.mOplmnActRecords));
        printWriter.println(" mHplmnActRecords[]=" + Arrays.toString(this.mHplmnActRecords));
        printWriter.println(" mFplmns[]=" + Arrays.toString(this.mFplmns));
        printWriter.println(" mEhplmns[]=" + Arrays.toString(this.mEhplmns));
        printWriter.flush();
    }
}
