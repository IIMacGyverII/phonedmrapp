package com.android.internal.telephony.uicc;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.telephony.SubscriptionInfo;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Pair;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.MccTable;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.InterPhoneService;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

public abstract class IccRecords extends Handler implements IccConstants {
    public static final int CALL_FORWARDING_STATUS_DISABLED = 0;
    public static final int CALL_FORWARDING_STATUS_ENABLED = 1;
    public static final int CALL_FORWARDING_STATUS_UNKNOWN = -1;
    public static final int CARRIER_NAME_DISPLAY_CONDITION_BITMASK_PLMN = 1;
    public static final int CARRIER_NAME_DISPLAY_CONDITION_BITMASK_SPN = 2;
    protected static final boolean DBG = true;
    public static final int DEFAULT_CARRIER_NAME_DISPLAY_CONDITION = 0;
    public static final int DEFAULT_VOICE_MESSAGE_COUNT = -2;
    protected static final int EVENT_AKA_AUTHENTICATE_DONE = 90;
    protected static final int EVENT_APP_DETECTED = 260;
    protected static final int EVENT_APP_LOCKED = 258;
    protected static final int EVENT_APP_NETWORK_LOCKED = 259;
    protected static final int EVENT_APP_READY = 257;
    public static final int EVENT_CFI = 1;
    public static final int EVENT_GET_ICC_RECORD_DONE = 100;
    protected static final int EVENT_GET_SMS_RECORD_SIZE_DONE = 28;
    public static final int EVENT_MWI = 0;
    public static final int EVENT_REFRESH = 31;
    public static final int EVENT_SPN = 2;
    protected static final int HANDLER_ACTION_BASE = 1238272;
    protected static final int HANDLER_ACTION_NONE = 1238272;
    protected static final int HANDLER_ACTION_SEND_RESPONSE = 1238273;
    private static final long ICC_SIM_CHALLENGE_TIMEOUT_MILLIS = 2500;
    public static final int INVALID_CARRIER_NAME_DISPLAY_CONDITION_BITMASK = -1;
    protected static final int LOCKED_RECORDS_REQ_REASON_LOCKED = 1;
    protected static final int LOCKED_RECORDS_REQ_REASON_NETWORK_LOCKED = 2;
    protected static final int LOCKED_RECORDS_REQ_REASON_NONE = 0;
    protected static final String[] MCCMNC_CODES_HAVING_3DIGITS_MNC = {"302370", "302720", "310260", "405025", "405026", "405027", "405028", "405029", "405030", "405031", "405032", "405033", "405034", "405035", "405036", "405037", "405038", "405039", "405040", "405041", "405042", "405043", "405044", "405045", "405046", "405047", "405750", "405751", "405752", "405753", "405754", "405755", "405756", "405799", "405800", "405801", "405802", "405803", "405804", "405805", "405806", "405807", "405808", "405809", "405810", "405811", "405812", "405813", "405814", "405815", "405816", "405817", "405818", "405819", "405820", "405821", "405822", "405823", "405824", "405825", "405826", "405827", "405828", "405829", "405830", "405831", "405832", "405833", "405834", "405835", "405836", "405837", "405838", "405839", "405840", "405841", "405842", "405843", "405844", "405845", "405846", "405847", "405848", "405849", "405850", "405851", "405852", "405853", "405854", "405855", "405856", "405857", "405858", "405859", "405860", "405861", "405862", "405863", "405864", "405865", "405866", "405867", "405868", "405869", "405870", "405871", "405872", "405873", "405874", "405875", "405876", "405877", "405878", "405879", "405880", "405881", "405882", "405883", "405884", "405885", "405886", "405908", "405909", "405910", "405911", "405912", "405913", "405914", "405915", "405916", "405917", "405918", "405919", "405920", "405921", "405922", "405923", "405924", "405925", "405926", "405927", "405928", "405929", "405930", "405931", "405932", "502142", "502143", "502145", "502146", "502147", "502148"};
    public static final int PLMN_MAX_LENGTH = 6;
    public static final int PLMN_MIN_LENGTH = 5;
    protected static final int SYSTEM_EVENT_BASE = 256;
    protected static final int UNINITIALIZED = -1;
    protected static final int UNKNOWN = 0;
    public static final int UNKNOWN_VOICE_MESSAGE_COUNT = -1;
    protected static final boolean VDBG = false;
    protected static AtomicInteger sNextRequestId = new AtomicInteger(1);
    protected AdnRecordCache mAdnCache;
    protected int mCarrierNameDisplayCondition;
    CarrierTestOverride mCarrierTestOverride;
    protected CommandsInterface mCi;
    protected Context mContext;
    protected AtomicBoolean mDestroyed = new AtomicBoolean(false);
    protected String[] mEhplmns;
    protected IccFileHandler mFh;
    protected String[] mFplmns;
    protected String mFullIccId;
    protected String mGid1;
    protected String mGid2;
    protected PlmnActRecord[] mHplmnActRecords;
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PROTECTED)
    public String mIccId;
    protected String mImsi;
    protected RegistrantList mImsiReadyRegistrants = new RegistrantList();
    protected boolean mIsVoiceMailFixed = false;
    protected AtomicBoolean mLoaded = new AtomicBoolean(false);
    protected RegistrantList mLockedRecordsLoadedRegistrants = new RegistrantList();
    protected int mLockedRecordsReqReason = 0;
    protected int mMailboxIndex = 0;
    protected int mMncLength = -1;
    protected String mMsisdn = null;
    protected String mMsisdnTag = null;
    protected RegistrantList mNetworkLockedRecordsLoadedRegistrants = new RegistrantList();
    protected RegistrantList mNetworkSelectionModeAutomaticRegistrants = new RegistrantList();
    protected String mNewMsisdn = null;
    protected String mNewMsisdnTag = null;
    protected RegistrantList mNewSmsRegistrants = new RegistrantList();
    protected String mNewVoiceMailNum = null;
    protected String mNewVoiceMailTag = null;
    protected OperatorPlmnInfo[] mOpl;
    protected PlmnActRecord[] mOplmnActRecords;
    protected UiccCardApplication mParentApp;
    protected final HashMap<Integer, Pair<Message, Object>> mPendingTransactions = new HashMap<>();
    protected PlmnActRecord[] mPlmnActRecords;
    protected String mPnnHomeName;
    protected PlmnNetworkName[] mPnns;
    protected String mPrefLang;
    protected RegistrantList mRecordsEventsRegistrants = new RegistrantList();
    protected RegistrantList mRecordsLoadedRegistrants = new RegistrantList();
    protected RegistrantList mRecordsOverrideRegistrants = new RegistrantList();
    protected boolean mRecordsRequested = false;
    protected int mRecordsToLoad;
    protected int mSmsCountOnIcc = 0;
    protected String[] mSpdi;
    private String mSpn;
    protected RegistrantList mSpnUpdatedRegistrants = new RegistrantList();
    protected TelephonyManager mTelephonyManager;
    protected String mVoiceMailNum = null;
    protected String mVoiceMailTag = null;

    @Retention(RetentionPolicy.SOURCE)
    public @interface CarrierNameDisplayConditionBitmask {
    }

    public interface IccRecordLoaded {
        String getEfName();

        void onRecordLoaded(AsyncResult asyncResult);
    }

    public static int convertSpnDisplayConditionToBitmask(int i) {
        int i2 = 1;
        if ((i & 1) != 1) {
            i2 = 0;
        }
        return (i & 2) == 0 ? i2 | 2 : i2;
    }

    public String getEfGbabp() {
        return null;
    }

    public byte[] getEfPsismsc() {
        return null;
    }

    public byte[] getEfSmsp() {
        return null;
    }

    public IsimRecords getIsimRecords() {
        return null;
    }

    public int getMncLength() {
        return 0;
    }

    public String getNAI() {
        return null;
    }

    public String getOperatorNumeric() {
        return null;
    }

    public String getSpNameInEfSpn() {
        return null;
    }

    public UsimServiceTable getUsimServiceTable() {
        return null;
    }

    public int getVoiceCallForwardingFlag() {
        return -1;
    }

    public abstract int getVoiceMessageCount();

    /* access modifiers changed from: protected */
    public abstract void handleFileUpdate(int i);

    public boolean isCspPlmnEnabled() {
        return false;
    }

    public String isOperatorMvnoForEfPnn() {
        return null;
    }

    public boolean isProvisioned() {
        return true;
    }

    /* access modifiers changed from: protected */
    public abstract void log(String str);

    /* access modifiers changed from: protected */
    public abstract void loge(String str);

    /* access modifiers changed from: protected */
    public abstract void onAllRecordsLoaded();

    /* access modifiers changed from: protected */
    public abstract void onReady();

    /* access modifiers changed from: protected */
    public abstract void onRecordLoaded();

    public abstract void onRefresh(boolean z, int[] iArr);

    public void setVoiceCallForwardingFlag(int i, boolean z, String str) {
    }

    public abstract void setVoiceMailNumber(String str, String str2, Message message);

    public abstract void setVoiceMessageWaiting(int i, int i2);

    private static class AuthAsyncResponse {
        public IccIoResult authRsp;
        public Throwable exception;

        private AuthAsyncResponse() {
        }
    }

    public String toString() {
        String str;
        String str2;
        String str3;
        String givePrintableIccid = SubscriptionInfo.givePrintableIccid(this.mFullIccId);
        StringBuilder sb = new StringBuilder();
        sb.append("mDestroyed=");
        sb.append(this.mDestroyed);
        sb.append(" mContext=");
        sb.append(this.mContext);
        sb.append(" mCi=");
        sb.append(this.mCi);
        sb.append(" mFh=");
        sb.append(this.mFh);
        sb.append(" mParentApp=");
        sb.append(this.mParentApp);
        sb.append(" recordsToLoad=");
        sb.append(this.mRecordsToLoad);
        sb.append(" adnCache=");
        sb.append(this.mAdnCache);
        sb.append(" recordsRequested=");
        sb.append(this.mRecordsRequested);
        sb.append(" lockedRecordsReqReason=");
        sb.append(this.mLockedRecordsReqReason);
        sb.append(" iccid=");
        sb.append(givePrintableIccid);
        String str4 = "";
        if (this.mCarrierTestOverride.isInTestMode()) {
            str = "mFakeIccid=" + this.mCarrierTestOverride.getFakeIccid();
        } else {
            str = str4;
        }
        sb.append(str);
        sb.append(" msisdnTag=");
        sb.append(this.mMsisdnTag);
        sb.append(" voiceMailNum=");
        sb.append(Rlog.pii(false, this.mVoiceMailNum));
        sb.append(" voiceMailTag=");
        sb.append(this.mVoiceMailTag);
        sb.append(" voiceMailNum=");
        sb.append(Rlog.pii(false, this.mNewVoiceMailNum));
        sb.append(" newVoiceMailTag=");
        sb.append(this.mNewVoiceMailTag);
        sb.append(" isVoiceMailFixed=");
        sb.append(this.mIsVoiceMailFixed);
        sb.append(" mImsi=");
        if (this.mImsi != null) {
            str2 = this.mImsi.substring(0, 6) + Rlog.pii(false, this.mImsi.substring(6));
        } else {
            str2 = "null";
        }
        sb.append(str2);
        if (this.mCarrierTestOverride.isInTestMode()) {
            str3 = " mFakeImsi=" + this.mCarrierTestOverride.getFakeIMSI();
        } else {
            str3 = str4;
        }
        sb.append(str3);
        sb.append(" mncLength=");
        sb.append(this.mMncLength);
        sb.append(" mailboxIndex=");
        sb.append(this.mMailboxIndex);
        sb.append(" spn=");
        sb.append(this.mSpn);
        if (this.mCarrierTestOverride.isInTestMode()) {
            str4 = " mFakeSpn=" + this.mCarrierTestOverride.getFakeSpn();
        }
        sb.append(str4);
        return sb.toString();
    }

    public IccRecords(UiccCardApplication uiccCardApplication, Context context, CommandsInterface commandsInterface) {
        this.mContext = context;
        this.mCi = commandsInterface;
        this.mFh = uiccCardApplication.getIccFileHandler();
        this.mParentApp = uiccCardApplication;
        this.mTelephonyManager = (TelephonyManager) this.mContext.getSystemService("phone");
        this.mCarrierTestOverride = new CarrierTestOverride(this.mParentApp.getPhoneId());
        this.mCi.registerForIccRefresh(this, 31, (Object) null);
        this.mParentApp.registerForReady(this, 257, (Object) null);
        this.mParentApp.registerForDetected(this, 260, (Object) null);
        this.mParentApp.registerForLocked(this, 258, (Object) null);
        this.mParentApp.registerForNetworkLocked(this, 259, (Object) null);
    }

    public void setCarrierTestOverride(String str, String str2, String str3, String str4, String str5, String str6, String str7) {
        this.mCarrierTestOverride.override(str, str2, str3, str4, str5, str6, str7);
        this.mTelephonyManager.setSimOperatorNameForPhone(this.mParentApp.getPhoneId(), str7);
        this.mTelephonyManager.setSimOperatorNumericForPhone(this.mParentApp.getPhoneId(), str);
        this.mRecordsOverrideRegistrants.notifyRegistrants();
    }

    public void dispose() {
        this.mDestroyed.set(true);
        this.mCi.unregisterForIccRefresh(this);
        this.mParentApp.unregisterForReady(this);
        this.mParentApp.unregisterForDetected(this);
        this.mParentApp.unregisterForLocked(this);
        this.mParentApp.unregisterForNetworkLocked(this);
        this.mParentApp = null;
        this.mFh = null;
        this.mCi = null;
        this.mContext = null;
        AdnRecordCache adnRecordCache = this.mAdnCache;
        if (adnRecordCache != null) {
            adnRecordCache.reset();
        }
        this.mLoaded.set(false);
    }

    /* access modifiers changed from: protected */
    public void onDetected() {
        this.mRecordsRequested = false;
        this.mLoaded.set(false);
    }

    /* access modifiers changed from: protected */
    public void onLocked() {
        this.mRecordsRequested = false;
        this.mLoaded.set(false);
    }

    public AdnRecordCache getAdnCache() {
        return this.mAdnCache;
    }

    public int storePendingTransaction(Message message) {
        return storePendingTransaction(message, (Object) null);
    }

    public int storePendingTransaction(Message message, Object obj) {
        int andIncrement = sNextRequestId.getAndIncrement();
        Pair pair = new Pair(message, obj);
        synchronized (this.mPendingTransactions) {
            this.mPendingTransactions.put(Integer.valueOf(andIncrement), pair);
        }
        return andIncrement;
    }

    public Pair<Message, Object> retrievePendingTransaction(Integer num) {
        Pair<Message, Object> remove;
        synchronized (this.mPendingTransactions) {
            remove = this.mPendingTransactions.remove(num);
        }
        return remove;
    }

    public String getIccId() {
        String fakeIccid;
        if (!this.mCarrierTestOverride.isInTestMode() || (fakeIccid = this.mCarrierTestOverride.getFakeIccid()) == null) {
            return this.mIccId;
        }
        return fakeIccid;
    }

    public String getFullIccId() {
        return this.mFullIccId;
    }

    public void registerForRecordsLoaded(Handler handler, int i, Object obj) {
        if (!this.mDestroyed.get()) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mRecordsLoadedRegistrants.add(registrant);
            if (getRecordsLoaded()) {
                registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
            }
        }
    }

    public void unregisterForRecordsLoaded(Handler handler) {
        this.mRecordsLoadedRegistrants.remove(handler);
    }

    public void unregisterForRecordsOverride(Handler handler) {
        this.mRecordsOverrideRegistrants.remove(handler);
    }

    public void registerForRecordsOverride(Handler handler, int i, Object obj) {
        if (!this.mDestroyed.get()) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mRecordsOverrideRegistrants.add(registrant);
            if (getRecordsLoaded()) {
                registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
            }
        }
    }

    public void registerForLockedRecordsLoaded(Handler handler, int i, Object obj) {
        if (!this.mDestroyed.get()) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mLockedRecordsLoadedRegistrants.add(registrant);
            if (getLockedRecordsLoaded()) {
                registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
            }
        }
    }

    public void unregisterForLockedRecordsLoaded(Handler handler) {
        this.mLockedRecordsLoadedRegistrants.remove(handler);
    }

    public void registerForNetworkLockedRecordsLoaded(Handler handler, int i, Object obj) {
        if (!this.mDestroyed.get()) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mNetworkLockedRecordsLoadedRegistrants.add(registrant);
            if (getNetworkLockedRecordsLoaded()) {
                registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
            }
        }
    }

    public void unregisterForNetworkLockedRecordsLoaded(Handler handler) {
        this.mNetworkLockedRecordsLoadedRegistrants.remove(handler);
    }

    public void registerForImsiReady(Handler handler, int i, Object obj) {
        if (!this.mDestroyed.get()) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mImsiReadyRegistrants.add(registrant);
            if (getIMSI() != null) {
                registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
            }
        }
    }

    public void unregisterForImsiReady(Handler handler) {
        this.mImsiReadyRegistrants.remove(handler);
    }

    public void registerForSpnUpdate(Handler handler, int i, Object obj) {
        if (!this.mDestroyed.get()) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mSpnUpdatedRegistrants.add(registrant);
            if (!TextUtils.isEmpty(this.mSpn)) {
                registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
            }
        }
    }

    public void unregisterForSpnUpdate(Handler handler) {
        this.mSpnUpdatedRegistrants.remove(handler);
    }

    public void registerForRecordsEvents(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mRecordsEventsRegistrants.add(registrant);
        registrant.notifyResult(0);
        registrant.notifyResult(1);
    }

    public void unregisterForRecordsEvents(Handler handler) {
        this.mRecordsEventsRegistrants.remove(handler);
    }

    public void registerForNewSms(Handler handler, int i, Object obj) {
        this.mNewSmsRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForNewSms(Handler handler) {
        this.mNewSmsRegistrants.remove(handler);
    }

    public void registerForNetworkSelectionModeAutomatic(Handler handler, int i, Object obj) {
        this.mNetworkSelectionModeAutomaticRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForNetworkSelectionModeAutomatic(Handler handler) {
        this.mNetworkSelectionModeAutomaticRegistrants.remove(handler);
    }

    public String getIMSI() {
        String fakeIMSI;
        if (!this.mCarrierTestOverride.isInTestMode() || (fakeIMSI = this.mCarrierTestOverride.getFakeIMSI()) == null) {
            return this.mImsi;
        }
        return fakeIMSI;
    }

    public void setImsi(String str) {
        String stripTrailingFs = IccUtils.stripTrailingFs(str);
        this.mImsi = stripTrailingFs;
        if (!Objects.equals(stripTrailingFs, str)) {
            loge("Invalid IMSI padding digits received.");
        }
        if (TextUtils.isEmpty(this.mImsi)) {
            this.mImsi = null;
        }
        String str2 = this.mImsi;
        if (str2 != null && !str2.matches("[0-9]+")) {
            loge("Invalid non-numeric IMSI digits received.");
            this.mImsi = null;
        }
        String str3 = this.mImsi;
        if (str3 != null && (str3.length() < 6 || this.mImsi.length() > 15)) {
            loge("invalid IMSI " + this.mImsi);
            this.mImsi = null;
        }
        log("IMSI: mMncLength=" + this.mMncLength);
        String str4 = this.mImsi;
        if (str4 != null && str4.length() >= 6) {
            log("IMSI: " + this.mImsi.substring(0, 6) + Rlog.pii(false, this.mImsi.substring(6)));
        }
        updateOperatorPlmn();
        this.mImsiReadyRegistrants.notifyRegistrants();
    }

    /* access modifiers changed from: protected */
    public void updateOperatorPlmn() {
        String imsi = getIMSI();
        if (imsi != null) {
            int i = this.mMncLength;
            if ((i == 0 || i == 2) && imsi.length() >= 6) {
                String substring = imsi.substring(0, 6);
                String[] strArr = MCCMNC_CODES_HAVING_3DIGITS_MNC;
                int length = strArr.length;
                int i2 = 0;
                while (true) {
                    if (i2 >= length) {
                        break;
                    } else if (strArr[i2].equals(substring)) {
                        this.mMncLength = 3;
                        log("IMSI: setting1 mMncLength=" + this.mMncLength);
                        break;
                    } else {
                        i2++;
                    }
                }
            }
            if (this.mMncLength == 0) {
                try {
                    this.mMncLength = MccTable.smallestDigitsMccForMnc(Integer.parseInt(imsi.substring(0, 3)));
                    log("setting2 mMncLength=" + this.mMncLength);
                } catch (NumberFormatException unused) {
                    loge("Corrupt IMSI! setting3 mMncLength=" + this.mMncLength);
                }
            }
            int i3 = this.mMncLength;
            if (i3 != 0 && i3 != -1 && imsi.length() >= this.mMncLength + 3) {
                log("update mccmnc=" + imsi.substring(0, this.mMncLength + 3));
                MccTable.updateMccMncConfiguration(this.mContext, imsi.substring(0, this.mMncLength + 3));
            }
        }
    }

    public String getMsisdnNumber() {
        return this.mMsisdn;
    }

    public String getGid1() {
        String fakeGid1;
        if (!this.mCarrierTestOverride.isInTestMode() || (fakeGid1 = this.mCarrierTestOverride.getFakeGid1()) == null) {
            return this.mGid1;
        }
        return fakeGid1;
    }

    public String getGid2() {
        String fakeGid2;
        if (!this.mCarrierTestOverride.isInTestMode() || (fakeGid2 = this.mCarrierTestOverride.getFakeGid2()) == null) {
            return this.mGid2;
        }
        return fakeGid2;
    }

    public String getPnnHomeName() {
        String fakePnnHomeName;
        if (!this.mCarrierTestOverride.isInTestMode() || (fakePnnHomeName = this.mCarrierTestOverride.getFakePnnHomeName()) == null) {
            return this.mPnnHomeName;
        }
        return fakePnnHomeName;
    }

    public PlmnNetworkName[] getPnns() {
        return this.mPnns;
    }

    public OperatorPlmnInfo[] getOpl() {
        return this.mOpl;
    }

    public void setMsisdnNumber(String str, String str2, Message message) {
        loge("setMsisdn() should not be invoked on base IccRecords");
        AsyncResult.forMessage(message).exception = new IccIoResult(106, (int) InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT, (byte[]) null).getException();
        message.sendToTarget();
    }

    public String getMsisdnAlphaTag() {
        return this.mMsisdnTag;
    }

    public String getVoiceMailNumber() {
        return this.mVoiceMailNum;
    }

    public String getServiceProviderName() {
        String fakeSpn;
        if (!this.mCarrierTestOverride.isInTestMode() || (fakeSpn = this.mCarrierTestOverride.getFakeSpn()) == null) {
            return this.mSpn;
        }
        return fakeSpn;
    }

    public String getServiceProviderNameWithBrandOverride() {
        UiccCardApplication uiccCardApplication = this.mParentApp;
        if (!(uiccCardApplication == null || uiccCardApplication.getUiccProfile() == null)) {
            String operatorBrandOverride = this.mParentApp.getUiccProfile().getOperatorBrandOverride();
            if (!TextUtils.isEmpty(operatorBrandOverride)) {
                return operatorBrandOverride;
            }
        }
        return this.mSpn;
    }

    /* access modifiers changed from: protected */
    public void setServiceProviderName(String str) {
        if (!TextUtils.equals(this.mSpn, str)) {
            this.mSpn = str != null ? str.trim() : null;
            this.mSpnUpdatedRegistrants.notifyRegistrants();
        }
    }

    public String getVoiceMailAlphaTag() {
        return this.mVoiceMailTag;
    }

    public boolean getRecordsLoaded() {
        return this.mRecordsToLoad == 0 && this.mRecordsRequested;
    }

    /* access modifiers changed from: protected */
    public boolean getLockedRecordsLoaded() {
        return this.mRecordsToLoad == 0 && this.mLockedRecordsReqReason == 1;
    }

    /* access modifiers changed from: protected */
    public boolean getNetworkLockedRecordsLoaded() {
        return this.mRecordsToLoad == 0 && this.mLockedRecordsReqReason == 2;
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 28) {
            AsyncResult asyncResult = (AsyncResult) message.obj;
            if (asyncResult.exception != null) {
                onRecordLoaded();
                loge("Exception in EVENT_GET_SMS_RECORD_SIZE_DONE " + asyncResult.exception);
                return;
            }
            int[] iArr = (int[]) asyncResult.result;
            try {
                this.mSmsCountOnIcc = iArr[2];
                log("EVENT_GET_SMS_RECORD_SIZE_DONE Size " + iArr[0] + " total " + iArr[1] + " record " + iArr[2]);
            } catch (ArrayIndexOutOfBoundsException e) {
                this.mSmsCountOnIcc = -1;
                loge("ArrayIndexOutOfBoundsException in EVENT_GET_SMS_RECORD_SIZE_DONE: " + e.toString());
            } catch (Throwable th) {
                onRecordLoaded();
                throw th;
            }
            onRecordLoaded();
        } else if (i == 31) {
            AsyncResult asyncResult2 = (AsyncResult) message.obj;
            log("Card REFRESH occurred: ");
            if (asyncResult2.exception == null) {
                handleRefresh((IccRefreshResponse) asyncResult2.result);
                return;
            }
            loge("Icc refresh Exception: " + asyncResult2.exception);
        } else if (i == 90) {
            AsyncResult asyncResult3 = (AsyncResult) message.obj;
            AuthAsyncResponse authAsyncResponse = (AuthAsyncResponse) asyncResult3.userObj;
            log("EVENT_AKA_AUTHENTICATE_DONE");
            synchronized (authAsyncResponse) {
                Throwable th2 = asyncResult3.exception;
                if (th2 != null) {
                    authAsyncResponse.exception = th2;
                    loge("Exception ICC SIM AKA: " + asyncResult3.exception);
                } else {
                    Object obj = asyncResult3.result;
                    if (obj == null) {
                        authAsyncResponse.exception = new NullPointerException("Null SIM authentication response");
                        loge("EVENT_AKA_AUTHENTICATE_DONE: null response");
                    } else {
                        try {
                            authAsyncResponse.authRsp = (IccIoResult) obj;
                        } catch (ClassCastException e2) {
                            authAsyncResponse.exception = e2;
                            loge("Failed to parse ICC SIM AKA contents: " + e2);
                        }
                    }
                }
                authAsyncResponse.notifyAll();
            }
        } else if (i != 100) {
            switch (i) {
                case 257:
                    this.mLockedRecordsReqReason = 0;
                    onReady();
                    return;
                case 258:
                    this.mLockedRecordsReqReason = 1;
                    onLocked();
                    return;
                case 259:
                    this.mLockedRecordsReqReason = 2;
                    onLocked();
                    return;
                case 260:
                    this.mLockedRecordsReqReason = 0;
                    onDetected();
                    return;
                default:
                    super.handleMessage(message);
                    return;
            }
        } else {
            try {
                AsyncResult asyncResult4 = (AsyncResult) message.obj;
                IccRecordLoaded iccRecordLoaded = (IccRecordLoaded) asyncResult4.userObj;
                log(iccRecordLoaded.getEfName() + " LOADED");
                if (asyncResult4.exception != null) {
                    loge("Record Load Exception: " + asyncResult4.exception);
                } else {
                    iccRecordLoaded.onRecordLoaded(asyncResult4);
                }
            } catch (RuntimeException e3) {
                loge("Exception parsing SIM record: " + e3);
            } catch (Throwable th3) {
                onRecordLoaded();
                throw th3;
            }
            onRecordLoaded();
        }
    }

    public String getSimLanguage() {
        return this.mPrefLang;
    }

    /* access modifiers changed from: protected */
    public void setSimLanguage(byte[] bArr, byte[] bArr2) {
        String[] locales = this.mContext.getAssets().getLocales();
        try {
            this.mPrefLang = findBestLanguage(bArr, locales);
        } catch (UnsupportedEncodingException unused) {
            log("Unable to parse EF-LI: " + Arrays.toString(bArr));
        }
        if (this.mPrefLang == null) {
            try {
                this.mPrefLang = findBestLanguage(bArr2, locales);
            } catch (UnsupportedEncodingException unused2) {
                log("Unable to parse EF-PL: " + Arrays.toString(bArr));
            }
        }
    }

    protected static String findBestLanguage(byte[] bArr, String[] strArr) throws UnsupportedEncodingException {
        if (!(bArr == null || strArr == null)) {
            for (int i = 0; i + 1 < bArr.length; i += 2) {
                String str = new String(bArr, i, 2, "ISO-8859-1");
                for (int i2 = 0; i2 < strArr.length; i2++) {
                    String str2 = strArr[i2];
                    if (str2 != null && str2.length() >= 2 && strArr[i2].substring(0, 2).equalsIgnoreCase(str)) {
                        return str;
                    }
                }
            }
        }
        return null;
    }

    /* access modifiers changed from: protected */
    public void handleRefresh(IccRefreshResponse iccRefreshResponse) {
        if (iccRefreshResponse == null) {
            log("handleRefresh received without input");
        } else if (!TextUtils.isEmpty(iccRefreshResponse.aid) && !iccRefreshResponse.aid.equals(this.mParentApp.getAid())) {
        } else {
            if (iccRefreshResponse.refreshResult != 0) {
                log("handleRefresh with unknown operation");
                return;
            }
            log("handleRefresh with SIM_FILE_UPDATED");
            handleFileUpdate(iccRefreshResponse.efId);
        }
    }

    public int getCarrierNameDisplayCondition() {
        return this.mCarrierNameDisplayCondition;
    }

    public String[] getServiceProviderDisplayInformation() {
        return this.mSpdi;
    }

    /* JADX WARNING: type inference failed for: r6v4, types: [java.lang.Object[]] */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.lang.String[] getHomePlmns() {
        /*
            r6 = this;
            java.lang.Class<java.lang.String> r0 = java.lang.String.class
            java.lang.String r1 = r6.getOperatorNumeric()
            java.lang.String[] r2 = r6.getEhplmns()
            java.lang.String[] r6 = r6.getServiceProviderDisplayInformation()
            boolean r3 = com.android.internal.telephony.util.ArrayUtils.isEmpty(r2)
            r4 = 0
            r5 = 1
            if (r3 == 0) goto L_0x001a
            java.lang.String[] r2 = new java.lang.String[r5]
            r2[r4] = r1
        L_0x001a:
            boolean r3 = com.android.internal.telephony.util.ArrayUtils.isEmpty(r6)
            if (r3 != 0) goto L_0x002e
            r3 = 2
            java.lang.String[][] r3 = new java.lang.String[r3][]
            r3[r4] = r2
            r3[r5] = r6
            java.lang.Object[] r6 = com.android.internal.telephony.util.ArrayUtils.concatElements(r0, r3)
            r2 = r6
            java.lang.String[] r2 = (java.lang.String[]) r2
        L_0x002e:
            java.lang.Object[] r6 = com.android.internal.telephony.util.ArrayUtils.appendElement(r0, r2, r1)
            java.lang.String[] r6 = (java.lang.String[]) r6
            return r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.IccRecords.getHomePlmns():java.lang.String[]");
    }

    public boolean isLoaded() {
        return this.mLoaded.get();
    }

    public String[] getEhplmns() {
        return this.mEhplmns;
    }

    public String[] getPlmnsFromHplmnActRecord() {
        PlmnActRecord[] plmnActRecordArr = this.mHplmnActRecords;
        if (plmnActRecordArr == null) {
            return null;
        }
        String[] strArr = new String[plmnActRecordArr.length];
        int i = 0;
        while (true) {
            PlmnActRecord[] plmnActRecordArr2 = this.mHplmnActRecords;
            if (i >= plmnActRecordArr2.length) {
                return strArr;
            }
            strArr[i] = plmnActRecordArr2[i].plmn;
            i++;
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:42:0x008e, code lost:
        r8 = r9.payload;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:43:0x0090, code lost:
        if (r8 == null) goto L_?;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:58:?, code lost:
        return new java.lang.String(r8);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:59:?, code lost:
        return null;
     */
    /* JADX WARNING: Removed duplicated region for block: B:11:0x0032 A[Catch:{ InterruptedException -> 0x0036 }] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.lang.String getIccSimChallengeResponse(int r9, java.lang.String r10) {
        /*
            r8 = this;
            com.android.internal.telephony.CommandsInterface r0 = r8.mCi
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r8.mParentApp
            r2 = 0
            if (r0 == 0) goto L_0x009b
            if (r1 != 0) goto L_0x000b
            goto L_0x009b
        L_0x000b:
            com.android.internal.telephony.uicc.IccRecords$AuthAsyncResponse r3 = new com.android.internal.telephony.uicc.IccRecords$AuthAsyncResponse
            r3.<init>()
            monitor-enter(r3)
            java.lang.String r1 = r1.getAid()     // Catch:{ all -> 0x0098 }
            r4 = 90
            r5 = 0
            android.os.Message r4 = r8.obtainMessage(r4, r5, r5, r3)     // Catch:{ all -> 0x0098 }
            r0.requestIccSimAuthentication(r9, r10, r1, r4)     // Catch:{ all -> 0x0098 }
            long r9 = android.os.SystemClock.elapsedRealtime()     // Catch:{ all -> 0x0098 }
        L_0x0023:
            r0 = 2500(0x9c4, double:1.235E-320)
            long r4 = r9 + r0
            long r6 = android.os.SystemClock.elapsedRealtime()     // Catch:{ InterruptedException -> 0x0036 }
            long r4 = r4 - r6
            r6 = 0
            int r6 = (r4 > r6 ? 1 : (r4 == r6 ? 0 : -1))
            if (r6 <= 0) goto L_0x003d
            r3.wait(r4)     // Catch:{ InterruptedException -> 0x0036 }
            goto L_0x003d
        L_0x0036:
            java.lang.String r4 = "IccRecords"
            java.lang.String r5 = "getIccSimChallengeResponse: InterruptedException."
            com.android.telephony.Rlog.w(r4, r5)     // Catch:{ all -> 0x0098 }
        L_0x003d:
            long r4 = android.os.SystemClock.elapsedRealtime()     // Catch:{ all -> 0x0098 }
            long r4 = r4 - r9
            int r4 = (r4 > r0 ? 1 : (r4 == r0 ? 0 : -1))
            if (r4 >= 0) goto L_0x004e
            com.android.internal.telephony.uicc.IccIoResult r4 = r3.authRsp     // Catch:{ all -> 0x0098 }
            if (r4 != 0) goto L_0x004e
            java.lang.Throwable r4 = r3.exception     // Catch:{ all -> 0x0098 }
            if (r4 == 0) goto L_0x0023
        L_0x004e:
            long r4 = android.os.SystemClock.elapsedRealtime()     // Catch:{ all -> 0x0098 }
            long r4 = r4 - r9
            int r9 = (r4 > r0 ? 1 : (r4 == r0 ? 0 : -1))
            if (r9 < 0) goto L_0x0066
            com.android.internal.telephony.uicc.IccIoResult r9 = r3.authRsp     // Catch:{ all -> 0x0098 }
            if (r9 != 0) goto L_0x0066
            java.lang.Throwable r9 = r3.exception     // Catch:{ all -> 0x0098 }
            if (r9 != 0) goto L_0x0066
            java.lang.String r9 = "getIccSimChallengeResponse timeout!"
            r8.loge(r9)     // Catch:{ all -> 0x0098 }
            monitor-exit(r3)     // Catch:{ all -> 0x0098 }
            return r2
        L_0x0066:
            java.lang.Throwable r9 = r3.exception     // Catch:{ all -> 0x0098 }
            if (r9 == 0) goto L_0x0082
            java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ all -> 0x0098 }
            r9.<init>()     // Catch:{ all -> 0x0098 }
            java.lang.String r10 = "getIccSimChallengeResponse exception: "
            r9.append(r10)     // Catch:{ all -> 0x0098 }
            java.lang.Throwable r10 = r3.exception     // Catch:{ all -> 0x0098 }
            r9.append(r10)     // Catch:{ all -> 0x0098 }
            java.lang.String r9 = r9.toString()     // Catch:{ all -> 0x0098 }
            r8.loge(r9)     // Catch:{ all -> 0x0098 }
            monitor-exit(r3)     // Catch:{ all -> 0x0098 }
            return r2
        L_0x0082:
            com.android.internal.telephony.uicc.IccIoResult r9 = r3.authRsp     // Catch:{ all -> 0x0098 }
            if (r9 != 0) goto L_0x008d
            java.lang.String r9 = "getIccSimChallengeResponse: No authentication response"
            r8.loge(r9)     // Catch:{ all -> 0x0098 }
            monitor-exit(r3)     // Catch:{ all -> 0x0098 }
            return r2
        L_0x008d:
            monitor-exit(r3)     // Catch:{ all -> 0x0098 }
            byte[] r8 = r9.payload
            if (r8 == 0) goto L_0x0097
            java.lang.String r2 = new java.lang.String
            r2.<init>(r8)
        L_0x0097:
            return r2
        L_0x0098:
            r8 = move-exception
            monitor-exit(r3)     // Catch:{ all -> 0x0098 }
            throw r8
        L_0x009b:
            java.lang.String r9 = "getIccSimChallengeResponse: Fail, ci or parentApp is null"
            r8.loge(r9)
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.IccRecords.getIccSimChallengeResponse(int, java.lang.String):java.lang.String");
    }

    public int getSmsCapacityOnIcc() {
        log("getSmsCapacityOnIcc: " + this.mSmsCountOnIcc);
        return this.mSmsCountOnIcc;
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        String str;
        printWriter.println("IccRecords: " + this);
        printWriter.println(" mDestroyed=" + this.mDestroyed);
        printWriter.println(" mCi=" + this.mCi);
        printWriter.println(" mFh=" + this.mFh);
        printWriter.println(" mParentApp=" + this.mParentApp);
        printWriter.println(" recordsLoadedRegistrants: size=" + this.mRecordsLoadedRegistrants.size());
        for (int i = 0; i < this.mRecordsLoadedRegistrants.size(); i++) {
            printWriter.println("  recordsLoadedRegistrants[" + i + "]=" + ((Registrant) this.mRecordsLoadedRegistrants.get(i)).getHandler());
        }
        printWriter.println(" mLockedRecordsLoadedRegistrants: size=" + this.mLockedRecordsLoadedRegistrants.size());
        for (int i2 = 0; i2 < this.mLockedRecordsLoadedRegistrants.size(); i2++) {
            printWriter.println("  mLockedRecordsLoadedRegistrants[" + i2 + "]=" + ((Registrant) this.mLockedRecordsLoadedRegistrants.get(i2)).getHandler());
        }
        printWriter.println(" mNetworkLockedRecordsLoadedRegistrants: size=" + this.mNetworkLockedRecordsLoadedRegistrants.size());
        for (int i3 = 0; i3 < this.mNetworkLockedRecordsLoadedRegistrants.size(); i3++) {
            printWriter.println("  mLockedRecordsLoadedRegistrants[" + i3 + "]=" + ((Registrant) this.mNetworkLockedRecordsLoadedRegistrants.get(i3)).getHandler());
        }
        printWriter.println(" mImsiReadyRegistrants: size=" + this.mImsiReadyRegistrants.size());
        for (int i4 = 0; i4 < this.mImsiReadyRegistrants.size(); i4++) {
            printWriter.println("  mImsiReadyRegistrants[" + i4 + "]=" + ((Registrant) this.mImsiReadyRegistrants.get(i4)).getHandler());
        }
        printWriter.println(" mRecordsEventsRegistrants: size=" + this.mRecordsEventsRegistrants.size());
        for (int i5 = 0; i5 < this.mRecordsEventsRegistrants.size(); i5++) {
            printWriter.println("  mRecordsEventsRegistrants[" + i5 + "]=" + ((Registrant) this.mRecordsEventsRegistrants.get(i5)).getHandler());
        }
        printWriter.println(" mNewSmsRegistrants: size=" + this.mNewSmsRegistrants.size());
        for (int i6 = 0; i6 < this.mNewSmsRegistrants.size(); i6++) {
            printWriter.println("  mNewSmsRegistrants[" + i6 + "]=" + ((Registrant) this.mNewSmsRegistrants.get(i6)).getHandler());
        }
        printWriter.println(" mNetworkSelectionModeAutomaticRegistrants: size=" + this.mNetworkSelectionModeAutomaticRegistrants.size());
        for (int i7 = 0; i7 < this.mNetworkSelectionModeAutomaticRegistrants.size(); i7++) {
            printWriter.println("  mNetworkSelectionModeAutomaticRegistrants[" + i7 + "]=" + ((Registrant) this.mNetworkSelectionModeAutomaticRegistrants.get(i7)).getHandler());
        }
        printWriter.println(" mRecordsRequested=" + this.mRecordsRequested);
        printWriter.println(" mLockedRecordsReqReason=" + this.mLockedRecordsReqReason);
        printWriter.println(" mRecordsToLoad=" + this.mRecordsToLoad);
        printWriter.println(" mRdnCache=" + this.mAdnCache);
        printWriter.println(" iccid=" + SubscriptionInfo.givePrintableIccid(this.mFullIccId));
        printWriter.println(" mMsisdn=" + Rlog.pii(false, this.mMsisdn));
        printWriter.println(" mMsisdnTag=" + this.mMsisdnTag);
        printWriter.println(" mVoiceMailNum=" + Rlog.pii(false, this.mVoiceMailNum));
        printWriter.println(" mVoiceMailTag=" + this.mVoiceMailTag);
        printWriter.println(" mNewVoiceMailNum=" + Rlog.pii(false, this.mNewVoiceMailNum));
        printWriter.println(" mNewVoiceMailTag=" + this.mNewVoiceMailTag);
        printWriter.println(" mIsVoiceMailFixed=" + this.mIsVoiceMailFixed);
        StringBuilder sb = new StringBuilder();
        sb.append(" mImsi=");
        if (this.mImsi != null) {
            str = this.mImsi.substring(0, 6) + Rlog.pii(false, this.mImsi.substring(6));
        } else {
            str = "null";
        }
        sb.append(str);
        printWriter.println(sb.toString());
        if (this.mCarrierTestOverride.isInTestMode()) {
            printWriter.println(" mFakeImsi=" + this.mCarrierTestOverride.getFakeIMSI());
        }
        printWriter.println(" mMncLength=" + this.mMncLength);
        printWriter.println(" mMailboxIndex=" + this.mMailboxIndex);
        printWriter.println(" mSpn=" + this.mSpn);
        if (this.mCarrierTestOverride.isInTestMode()) {
            printWriter.println(" mFakeSpn=" + this.mCarrierTestOverride.getFakeSpn());
        }
        printWriter.flush();
    }

    public static String getNetworkNameForPlmnFromPnnOpl(PlmnNetworkName[] plmnNetworkNameArr, OperatorPlmnInfo[] operatorPlmnInfoArr, String str, int i) {
        PlmnNetworkName plmnNetworkName;
        if (operatorPlmnInfoArr != null && plmnNetworkNameArr != null && str != null && str.length() >= 5 && str.length() <= 6) {
            int length = operatorPlmnInfoArr.length;
            int i2 = 0;
            while (true) {
                if (i2 >= length) {
                    break;
                }
                int pnnIdx = operatorPlmnInfoArr[i2].getPnnIdx(str, i);
                if (pnnIdx < 0) {
                    i2++;
                } else if (pnnIdx < plmnNetworkNameArr.length && (plmnNetworkName = plmnNetworkNameArr[pnnIdx]) != null) {
                    return plmnNetworkName.getName();
                } else {
                    Rlog.e("IccRecords", "Invalid PNN record for Record" + pnnIdx);
                }
            }
        }
        return null;
    }

    public static final class OperatorPlmnInfo {
        public final int lacTacEnd;
        public final int lacTacStart;
        public final String plmnNumericPattern;
        public final int pnnRecordId;

        public OperatorPlmnInfo(String str, int i, int i2, int i3) {
            this.plmnNumericPattern = str;
            this.lacTacStart = i;
            this.lacTacEnd = i2;
            this.pnnRecordId = i3;
        }

        public int getPnnIdx(String str, int i) {
            int i2;
            if (str != null && str.length() == this.plmnNumericPattern.length()) {
                for (int i3 = 0; i3 < str.length(); i3++) {
                    if (str.charAt(i3) != this.plmnNumericPattern.charAt(i3) && this.plmnNumericPattern.charAt(i3) != 'D') {
                        return -1;
                    }
                }
                int i4 = this.lacTacStart;
                if (i4 == 0 && this.lacTacEnd == 65534) {
                    i2 = this.pnnRecordId;
                } else if (i >= i4 && i <= this.lacTacEnd) {
                    i2 = this.pnnRecordId;
                }
                return i2 - 1;
            }
            return -1;
        }

        public int hashCode() {
            return Objects.hash(new Object[]{this.plmnNumericPattern, Integer.valueOf(this.lacTacStart), Integer.valueOf(this.lacTacEnd), Integer.valueOf(this.pnnRecordId)});
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (!(obj instanceof OperatorPlmnInfo)) {
                return false;
            }
            OperatorPlmnInfo operatorPlmnInfo = (OperatorPlmnInfo) obj;
            if (TextUtils.equals(this.plmnNumericPattern, operatorPlmnInfo.plmnNumericPattern) && this.lacTacStart == operatorPlmnInfo.lacTacStart && this.lacTacEnd == operatorPlmnInfo.lacTacEnd && this.pnnRecordId == operatorPlmnInfo.pnnRecordId) {
                return true;
            }
            return false;
        }

        public String toString() {
            return "{plmnNumericPattern = " + this.plmnNumericPattern + ", lacTacStart = " + this.lacTacStart + ", lacTacEnd = " + this.lacTacEnd + ", pnnRecordId = " + this.pnnRecordId + "}";
        }
    }

    public static final class PlmnNetworkName {
        public final String fullName;
        public final String shortName;

        public PlmnNetworkName(String str, String str2) {
            this.fullName = str;
            this.shortName = str2;
        }

        public String getName() {
            if (!TextUtils.isEmpty(this.fullName)) {
                return this.fullName;
            }
            return this.shortName;
        }

        public int hashCode() {
            return Objects.hash(new Object[]{this.fullName, this.shortName});
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (!(obj instanceof PlmnNetworkName)) {
                return false;
            }
            PlmnNetworkName plmnNetworkName = (PlmnNetworkName) obj;
            if (!TextUtils.equals(this.fullName, plmnNetworkName.fullName) || !TextUtils.equals(this.shortName, plmnNetworkName.shortName)) {
                return false;
            }
            return true;
        }

        public String toString() {
            return "{fullName = " + this.fullName + ", shortName = " + this.shortName + "}";
        }
    }

    public void setEfGbabp(String str, Message message) {
        if (message != null) {
            AsyncResult.forMessage(message, (Object) null, new IccException("Default setEfGbabp exception."));
            message.sendToTarget();
        }
    }
}
