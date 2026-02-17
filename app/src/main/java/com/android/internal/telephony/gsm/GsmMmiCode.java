package com.android.internal.telephony.gsm;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.res.Resources;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.ResultReceiver;
import android.telephony.CarrierConfigManager;
import android.telephony.PhoneNumberUtils;
import android.telephony.TelephonyManager;
import android.telephony.gsm.SmsMessage;
import android.text.BidiFormatter;
import android.text.SpannableStringBuilder;
import android.text.TextDirectionHeuristics;
import android.text.TextUtils;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CallForwardInfo;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.GsmCdmaPhone;
import com.android.internal.telephony.MmiCode;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.gsm.SsData;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.telephony.Rlog;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GsmMmiCode extends Handler implements MmiCode {
    protected static final String ACTION_ACTIVATE = "*";
    protected static final String ACTION_DEACTIVATE = "#";
    protected static final String ACTION_ERASURE = "##";
    protected static final String ACTION_INTERROGATE = "*#";
    protected static final String ACTION_REGISTER = "**";
    protected static final char END_OF_USSD_COMMAND = '#';
    protected static final int EVENT_GET_CLIR_COMPLETE = 2;
    protected static final int EVENT_QUERY_CF_COMPLETE = 3;
    protected static final int EVENT_QUERY_COMPLETE = 5;
    protected static final int EVENT_SET_CFF_COMPLETE = 6;
    protected static final int EVENT_SET_COMPLETE = 1;
    protected static final int EVENT_USSD_CANCEL_COMPLETE = 7;
    protected static final int EVENT_USSD_COMPLETE = 4;
    static final String LOG_TAG = "GsmMmiCode";
    protected static final int MATCH_GROUP_ACTION = 2;
    protected static final int MATCH_GROUP_DIALING_NUMBER = 12;
    protected static final int MATCH_GROUP_POUND_STRING = 1;
    protected static final int MATCH_GROUP_PWD_CONFIRM = 11;
    protected static final int MATCH_GROUP_SERVICE_CODE = 3;
    protected static final int MATCH_GROUP_SIA = 5;
    protected static final int MATCH_GROUP_SIB = 7;
    protected static final int MATCH_GROUP_SIC = 9;
    protected static final int MAX_LENGTH_SHORT_CODE = 2;
    protected static final String SC_BAIC = "35";
    protected static final String SC_BAICr = "351";
    protected static final String SC_BAOC = "33";
    protected static final String SC_BAOIC = "331";
    protected static final String SC_BAOICxH = "332";
    protected static final String SC_BA_ALL = "330";
    protected static final String SC_BA_MO = "333";
    protected static final String SC_BA_MT = "353";
    protected static final String SC_CFB = "67";
    protected static final String SC_CFNR = "62";
    protected static final String SC_CFNRy = "61";
    protected static final String SC_CFU = "21";
    protected static final String SC_CF_All = "002";
    protected static final String SC_CF_All_Conditional = "004";
    protected static final String SC_CLIP = "30";
    protected static final String SC_CLIR = "31";
    protected static final String SC_PIN = "04";
    protected static final String SC_PIN2 = "042";
    protected static final String SC_PUK = "05";
    protected static final String SC_PUK2 = "052";
    protected static final String SC_PWD = "03";
    protected static final String SC_WAIT = "43";
    @UnsupportedAppUsage
    protected static Pattern sPatternSuppService = Pattern.compile("((\\*|#|\\*#|\\*\\*|##)(\\d{2,3})(\\*([^*#]*)(\\*([^*#]*)(\\*([^*#]*)(\\*([^*#]*))?)?)?)?#)(.*)");
    protected static String[] sTwoDigitNumberPattern;
    protected String mAction;
    protected ResultReceiver mCallbackReceiver;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Context mContext;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String mDialingNumber;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccRecords mIccRecords;
    protected boolean mIsCallFwdReg;
    protected boolean mIsNetworkInitiatedUSSD;
    protected boolean mIsPendingUSSD;
    protected boolean mIsSsInfo = false;
    protected boolean mIsUssdRequest;
    protected CharSequence mMessage;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected GsmCdmaPhone mPhone;
    protected String mPoundString;
    protected String mPwd;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mSc;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mSia;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mSib;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mSic;
    protected MmiCode.State mState = MmiCode.State.PENDING;
    protected UiccCardApplication mUiccApplication;

    public static boolean isVoiceUnconditionalForwarding(int i, int i2) {
        return (i == 0 || i == 4) && ((i2 & 1) != 0 || i2 == 0);
    }

    /* access modifiers changed from: protected */
    public boolean isServiceClassVoiceorNone(int i) {
        return (i & 1) != 0 || i == 0;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static GsmMmiCode newFromDialString(String str, GsmCdmaPhone gsmCdmaPhone, UiccCardApplication uiccCardApplication) {
        return newFromDialString(str, gsmCdmaPhone, uiccCardApplication, (ResultReceiver) null);
    }

    public static GsmMmiCode newFromDialString(String str, GsmCdmaPhone gsmCdmaPhone, UiccCardApplication uiccCardApplication, ResultReceiver resultReceiver) {
        if ((gsmCdmaPhone.getServiceState().getVoiceRoaming() && gsmCdmaPhone.supportsConversionOfCdmaCallerIdMmiCodesWhileRoaming()) || (isEmergencyNumber(gsmCdmaPhone, str) && isCarrierSupportCallerIdVerticalServiceCodes(gsmCdmaPhone))) {
            str = convertCdmaMmiCodesTo3gppMmiCodes(str);
        }
        Matcher matcher = sPatternSuppService.matcher(str);
        GsmMmiCode gsmMmiCode = null;
        if (matcher.matches()) {
            GsmMmiCode gsmMmiCode2 = new GsmMmiCode(gsmCdmaPhone, uiccCardApplication);
            gsmMmiCode2.mPoundString = makeEmptyNull(matcher.group(1));
            gsmMmiCode2.mAction = makeEmptyNull(matcher.group(2));
            gsmMmiCode2.mSc = makeEmptyNull(matcher.group(3));
            gsmMmiCode2.mSia = makeEmptyNull(matcher.group(5));
            gsmMmiCode2.mSib = makeEmptyNull(matcher.group(7));
            gsmMmiCode2.mSic = makeEmptyNull(matcher.group(9));
            gsmMmiCode2.mPwd = makeEmptyNull(matcher.group(11));
            String makeEmptyNull = makeEmptyNull(matcher.group(12));
            gsmMmiCode2.mDialingNumber = makeEmptyNull;
            if (makeEmptyNull != null && makeEmptyNull.endsWith(ACTION_DEACTIVATE) && str.endsWith(ACTION_DEACTIVATE)) {
                gsmMmiCode = new GsmMmiCode(gsmCdmaPhone, uiccCardApplication);
                gsmMmiCode.mPoundString = str;
            } else if (!gsmMmiCode2.isFacToDial()) {
                gsmMmiCode = gsmMmiCode2;
            }
        } else if (str.endsWith(ACTION_DEACTIVATE)) {
            gsmMmiCode = new GsmMmiCode(gsmCdmaPhone, uiccCardApplication);
            gsmMmiCode.mPoundString = str;
        } else if (!isTwoDigitShortCode(gsmCdmaPhone.getContext(), gsmCdmaPhone.getSubId(), str) && isShortCode(str, gsmCdmaPhone)) {
            gsmMmiCode = new GsmMmiCode(gsmCdmaPhone, uiccCardApplication);
            gsmMmiCode.mDialingNumber = str;
        }
        if (gsmMmiCode != null) {
            gsmMmiCode.mCallbackReceiver = resultReceiver;
        }
        return gsmMmiCode;
    }

    protected static String convertCdmaMmiCodesTo3gppMmiCodes(String str) {
        Matcher matcher = MmiCode.sPatternCdmaMmiCodeWhileRoaming.matcher(str);
        if (!matcher.matches()) {
            return str;
        }
        String makeEmptyNull = makeEmptyNull(matcher.group(1));
        String group = matcher.group(2);
        String makeEmptyNull2 = makeEmptyNull(matcher.group(3));
        if (makeEmptyNull.equals(SC_CFB) && makeEmptyNull2 != null) {
            return "#31#" + group + makeEmptyNull2;
        } else if (!makeEmptyNull.equals("82") || makeEmptyNull2 == null) {
            return str;
        } else {
            return "*31#" + group + makeEmptyNull2;
        }
    }

    public static GsmMmiCode newNetworkInitiatedUssd(String str, boolean z, GsmCdmaPhone gsmCdmaPhone, UiccCardApplication uiccCardApplication) {
        GsmMmiCode gsmMmiCode = new GsmMmiCode(gsmCdmaPhone, uiccCardApplication);
        gsmMmiCode.mMessage = str;
        gsmMmiCode.mIsUssdRequest = z;
        gsmMmiCode.mIsNetworkInitiatedUSSD = true;
        if (z) {
            gsmMmiCode.mIsPendingUSSD = true;
            gsmMmiCode.mState = MmiCode.State.PENDING;
        } else {
            gsmMmiCode.mState = MmiCode.State.COMPLETE;
        }
        return gsmMmiCode;
    }

    public static GsmMmiCode newFromUssdUserInput(String str, GsmCdmaPhone gsmCdmaPhone, UiccCardApplication uiccCardApplication) {
        GsmMmiCode gsmMmiCode = new GsmMmiCode(gsmCdmaPhone, uiccCardApplication);
        gsmMmiCode.mMessage = str;
        gsmMmiCode.mState = MmiCode.State.PENDING;
        gsmMmiCode.mIsPendingUSSD = true;
        return gsmMmiCode;
    }

    public void processSsData(AsyncResult asyncResult) {
        Rlog.d(LOG_TAG, "In processSsData");
        this.mIsSsInfo = true;
        try {
            parseSsData((SsData) asyncResult.result);
        } catch (ClassCastException e) {
            Rlog.e(LOG_TAG, "Class Cast Exception in parsing SS Data : " + e);
        } catch (NullPointerException e2) {
            Rlog.e(LOG_TAG, "Null Pointer Exception in parsing SS Data : " + e2);
        }
    }

    /* access modifiers changed from: protected */
    public void parseSsData(SsData ssData) {
        CommandException fromRilErrno = CommandException.fromRilErrno(ssData.result);
        this.mSc = getScStringFromScType(ssData.serviceType);
        this.mAction = getActionStringFromReqType(ssData.requestType);
        Rlog.d(LOG_TAG, "parseSsData msc = " + this.mSc + ", action = " + this.mAction + ", ex = " + fromRilErrno);
        int i = AnonymousClass1.$SwitchMap$com$android$internal$telephony$gsm$SsData$RequestType[ssData.requestType.ordinal()];
        if (i == 1 || i == 2 || i == 3 || i == 4) {
            if (ssData.result == 0 && ssData.serviceType.isTypeUnConditional()) {
                SsData.RequestType requestType = ssData.requestType;
                boolean z = (requestType == SsData.RequestType.SS_ACTIVATION || requestType == SsData.RequestType.SS_REGISTRATION) && isServiceClassVoiceorNone(ssData.serviceClass);
                Rlog.d(LOG_TAG, "setVoiceCallForwardingFlag cffEnabled: " + z);
                this.mPhone.setVoiceCallForwardingFlag(1, z, (String) null);
            }
            onSetComplete((Message) null, new AsyncResult((Object) null, ssData.cfInfo, fromRilErrno));
        } else if (i != 5) {
            Rlog.e(LOG_TAG, "Invaid requestType in SSData : " + ssData.requestType);
        } else if (ssData.serviceType.isTypeClir()) {
            Rlog.d(LOG_TAG, "CLIR INTERROGATION");
            onGetClirComplete(new AsyncResult((Object) null, ssData.ssInfo, fromRilErrno));
        } else if (ssData.serviceType.isTypeCF()) {
            Rlog.d(LOG_TAG, "CALL FORWARD INTERROGATION");
            onQueryCfComplete(new AsyncResult((Object) null, ssData.cfInfo, fromRilErrno));
        } else {
            onQueryComplete(new AsyncResult((Object) null, ssData.ssInfo, fromRilErrno));
        }
    }

    /* renamed from: com.android.internal.telephony.gsm.GsmMmiCode$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$gsm$SsData$RequestType;
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType;

        /* JADX WARNING: Can't wrap try/catch for region: R(46:0|(2:1|2)|3|(2:5|6)|7|9|10|11|(2:13|14)|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|45|46|47|48|49|50|51|52|(3:53|54|56)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(48:0|(2:1|2)|3|(2:5|6)|7|9|10|11|(2:13|14)|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|45|46|47|48|49|50|51|52|53|54|56) */
        /* JADX WARNING: Can't wrap try/catch for region: R(49:0|(2:1|2)|3|5|6|7|9|10|11|(2:13|14)|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|45|46|47|48|49|50|51|52|53|54|56) */
        /* JADX WARNING: Can't wrap try/catch for region: R(50:0|1|2|3|5|6|7|9|10|11|(2:13|14)|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|45|46|47|48|49|50|51|52|53|54|56) */
        /* JADX WARNING: Can't wrap try/catch for region: R(51:0|1|2|3|5|6|7|9|10|11|13|14|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|45|46|47|48|49|50|51|52|53|54|56) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:21:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:23:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:25:0x0060 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:27:0x006c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:29:0x0078 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:31:0x0084 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:33:0x0090 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:35:0x009c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:37:0x00a8 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:39:0x00b4 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:41:0x00c0 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:47:0x00dd */
        /* JADX WARNING: Missing exception handler attribute for start block: B:49:0x00e7 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:51:0x00f1 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:53:0x00fb */
        static {
            /*
                com.android.internal.telephony.gsm.SsData$ServiceType[] r0 = com.android.internal.telephony.gsm.SsData.ServiceType.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType = r0
                r1 = 1
                com.android.internal.telephony.gsm.SsData$ServiceType r2 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_CFU     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r2 = r2.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r0[r2] = r1     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                r0 = 2
                int[] r2 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.gsm.SsData$ServiceType r3 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_CF_BUSY     // Catch:{ NoSuchFieldError -> 0x001d }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2[r3] = r0     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                r2 = 3
                int[] r3 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.gsm.SsData$ServiceType r4 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_CF_NO_REPLY     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r3[r4] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                r3 = 4
                int[] r4 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.gsm.SsData$ServiceType r5 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_CF_NOT_REACHABLE     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r4[r5] = r3     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                r4 = 5
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_CF_ALL     // Catch:{ NoSuchFieldError -> 0x003e }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r5[r6] = r4     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_CF_ALL_CONDITIONAL     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r7 = 6
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_CLIP     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r7 = 7
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_CLIR     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r7 = 8
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_WAIT     // Catch:{ NoSuchFieldError -> 0x006c }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r7 = 9
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_BAOC     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r7 = 10
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x0084 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_BAOIC     // Catch:{ NoSuchFieldError -> 0x0084 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x0084 }
                r7 = 11
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x0084 }
            L_0x0084:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x0090 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_BAOIC_EXC_HOME     // Catch:{ NoSuchFieldError -> 0x0090 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x0090 }
                r7 = 12
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x0090 }
            L_0x0090:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x009c }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_BAIC     // Catch:{ NoSuchFieldError -> 0x009c }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x009c }
                r7 = 13
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x009c }
            L_0x009c:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x00a8 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_BAIC_ROAMING     // Catch:{ NoSuchFieldError -> 0x00a8 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x00a8 }
                r7 = 14
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x00a8 }
            L_0x00a8:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x00b4 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_ALL_BARRING     // Catch:{ NoSuchFieldError -> 0x00b4 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x00b4 }
                r7 = 15
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x00b4 }
            L_0x00b4:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x00c0 }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_OUTGOING_BARRING     // Catch:{ NoSuchFieldError -> 0x00c0 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x00c0 }
                r7 = 16
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x00c0 }
            L_0x00c0:
                int[] r5 = $SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType     // Catch:{ NoSuchFieldError -> 0x00cc }
                com.android.internal.telephony.gsm.SsData$ServiceType r6 = com.android.internal.telephony.gsm.SsData.ServiceType.SS_INCOMING_BARRING     // Catch:{ NoSuchFieldError -> 0x00cc }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x00cc }
                r7 = 17
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x00cc }
            L_0x00cc:
                com.android.internal.telephony.gsm.SsData$RequestType[] r5 = com.android.internal.telephony.gsm.SsData.RequestType.values()
                int r5 = r5.length
                int[] r5 = new int[r5]
                $SwitchMap$com$android$internal$telephony$gsm$SsData$RequestType = r5
                com.android.internal.telephony.gsm.SsData$RequestType r6 = com.android.internal.telephony.gsm.SsData.RequestType.SS_ACTIVATION     // Catch:{ NoSuchFieldError -> 0x00dd }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x00dd }
                r5[r6] = r1     // Catch:{ NoSuchFieldError -> 0x00dd }
            L_0x00dd:
                int[] r1 = $SwitchMap$com$android$internal$telephony$gsm$SsData$RequestType     // Catch:{ NoSuchFieldError -> 0x00e7 }
                com.android.internal.telephony.gsm.SsData$RequestType r5 = com.android.internal.telephony.gsm.SsData.RequestType.SS_DEACTIVATION     // Catch:{ NoSuchFieldError -> 0x00e7 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x00e7 }
                r1[r5] = r0     // Catch:{ NoSuchFieldError -> 0x00e7 }
            L_0x00e7:
                int[] r0 = $SwitchMap$com$android$internal$telephony$gsm$SsData$RequestType     // Catch:{ NoSuchFieldError -> 0x00f1 }
                com.android.internal.telephony.gsm.SsData$RequestType r1 = com.android.internal.telephony.gsm.SsData.RequestType.SS_REGISTRATION     // Catch:{ NoSuchFieldError -> 0x00f1 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00f1 }
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00f1 }
            L_0x00f1:
                int[] r0 = $SwitchMap$com$android$internal$telephony$gsm$SsData$RequestType     // Catch:{ NoSuchFieldError -> 0x00fb }
                com.android.internal.telephony.gsm.SsData$RequestType r1 = com.android.internal.telephony.gsm.SsData.RequestType.SS_ERASURE     // Catch:{ NoSuchFieldError -> 0x00fb }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00fb }
                r0[r1] = r3     // Catch:{ NoSuchFieldError -> 0x00fb }
            L_0x00fb:
                int[] r0 = $SwitchMap$com$android$internal$telephony$gsm$SsData$RequestType     // Catch:{ NoSuchFieldError -> 0x0105 }
                com.android.internal.telephony.gsm.SsData$RequestType r1 = com.android.internal.telephony.gsm.SsData.RequestType.SS_INTERROGATION     // Catch:{ NoSuchFieldError -> 0x0105 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0105 }
                r0[r1] = r4     // Catch:{ NoSuchFieldError -> 0x0105 }
            L_0x0105:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.gsm.GsmMmiCode.AnonymousClass1.<clinit>():void");
        }
    }

    /* access modifiers changed from: protected */
    public String getScStringFromScType(SsData.ServiceType serviceType) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$gsm$SsData$ServiceType[serviceType.ordinal()]) {
            case 1:
                return SC_CFU;
            case 2:
                return SC_CFB;
            case 3:
                return SC_CFNRy;
            case 4:
                return SC_CFNR;
            case 5:
                return SC_CF_All;
            case 6:
                return SC_CF_All_Conditional;
            case 7:
                return SC_CLIP;
            case 8:
                return SC_CLIR;
            case 9:
                return SC_WAIT;
            case 10:
                return SC_BAOC;
            case 11:
                return SC_BAOIC;
            case 12:
                return SC_BAOICxH;
            case 13:
                return SC_BAIC;
            case 14:
                return SC_BAICr;
            case 15:
                return SC_BA_ALL;
            case 16:
                return SC_BA_MO;
            case 17:
                return SC_BA_MT;
            default:
                return "";
        }
    }

    /* access modifiers changed from: protected */
    public String getActionStringFromReqType(SsData.RequestType requestType) {
        int i = AnonymousClass1.$SwitchMap$com$android$internal$telephony$gsm$SsData$RequestType[requestType.ordinal()];
        if (i == 1) {
            return ACTION_ACTIVATE;
        }
        if (i == 2) {
            return ACTION_DEACTIVATE;
        }
        if (i == 3) {
            return ACTION_REGISTER;
        }
        if (i != 4) {
            return i != 5 ? "" : ACTION_INTERROGATE;
        }
        return ACTION_ERASURE;
    }

    @UnsupportedAppUsage
    protected static String makeEmptyNull(String str) {
        if (str == null || str.length() != 0) {
            return str;
        }
        return null;
    }

    protected static boolean isEmptyOrNull(CharSequence charSequence) {
        return charSequence == null || charSequence.length() == 0;
    }

    protected static int scToCallForwardReason(String str) {
        if (str == null) {
            throw new RuntimeException("invalid call forward sc");
        } else if (str.equals(SC_CF_All)) {
            return 4;
        } else {
            if (str.equals(SC_CFU)) {
                return 0;
            }
            if (str.equals(SC_CFB)) {
                return 1;
            }
            if (str.equals(SC_CFNR)) {
                return 3;
            }
            if (str.equals(SC_CFNRy)) {
                return 2;
            }
            if (str.equals(SC_CF_All_Conditional)) {
                return 5;
            }
            throw new RuntimeException("invalid call forward sc");
        }
    }

    @UnsupportedAppUsage
    private static int siToServiceClass(String str) {
        if (str == null || str.length() == 0) {
            return 0;
        }
        int parseInt = Integer.parseInt(str, 10);
        if (parseInt == 16) {
            return 8;
        }
        if (parseInt == 99) {
            return 64;
        }
        switch (parseInt) {
            case 10:
                return 13;
            case 11:
                return 1;
            case 12:
                return 12;
            case 13:
                return 4;
            default:
                switch (parseInt) {
                    case 19:
                        return 5;
                    case 20:
                        return 48;
                    case 21:
                        return SmsMessage.MAX_USER_DATA_SEPTETS;
                    case 22:
                        return 80;
                    default:
                        switch (parseInt) {
                            case 24:
                                return 16;
                            case 25:
                                return 32;
                            case 26:
                                return 17;
                            default:
                                throw new RuntimeException("unsupported MMI service code " + str);
                        }
                }
        }
    }

    protected static int siToTime(String str) {
        if (str == null || str.length() == 0) {
            return 0;
        }
        return Integer.parseInt(str, 10);
    }

    @UnsupportedAppUsage
    protected static boolean isServiceCodeCallForwarding(String str) {
        return str != null && (str.equals(SC_CFU) || str.equals(SC_CFB) || str.equals(SC_CFNRy) || str.equals(SC_CFNR) || str.equals(SC_CF_All) || str.equals(SC_CF_All_Conditional));
    }

    @UnsupportedAppUsage
    protected static boolean isServiceCodeCallBarring(String str) {
        String[] stringArray;
        Resources system = Resources.getSystem();
        if (!(str == null || (stringArray = system.getStringArray(17236013)) == null)) {
            for (String equals : stringArray) {
                if (str.equals(equals)) {
                    return true;
                }
            }
        }
        return false;
    }

    protected static String scToBarringFacility(String str) {
        if (str == null) {
            throw new RuntimeException("invalid call barring sc");
        } else if (str.equals(SC_BAOC)) {
            return CommandsInterface.CB_FACILITY_BAOC;
        } else {
            if (str.equals(SC_BAOIC)) {
                return CommandsInterface.CB_FACILITY_BAOIC;
            }
            if (str.equals(SC_BAOICxH)) {
                return CommandsInterface.CB_FACILITY_BAOICxH;
            }
            if (str.equals(SC_BAIC)) {
                return CommandsInterface.CB_FACILITY_BAIC;
            }
            if (str.equals(SC_BAICr)) {
                return CommandsInterface.CB_FACILITY_BAICr;
            }
            if (str.equals(SC_BA_ALL)) {
                return CommandsInterface.CB_FACILITY_BA_ALL;
            }
            if (str.equals(SC_BA_MO)) {
                return CommandsInterface.CB_FACILITY_BA_MO;
            }
            if (str.equals(SC_BA_MT)) {
                return CommandsInterface.CB_FACILITY_BA_MT;
            }
            throw new RuntimeException("invalid call barring sc");
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GsmMmiCode(GsmCdmaPhone gsmCdmaPhone, UiccCardApplication uiccCardApplication) {
        super(gsmCdmaPhone.getHandler().getLooper());
        this.mPhone = gsmCdmaPhone;
        this.mContext = gsmCdmaPhone.getContext();
        this.mUiccApplication = uiccCardApplication;
        if (uiccCardApplication != null) {
            this.mIccRecords = uiccCardApplication.getIccRecords();
        }
    }

    public MmiCode.State getState() {
        return this.mState;
    }

    public CharSequence getMessage() {
        return this.mMessage;
    }

    public Phone getPhone() {
        return this.mPhone;
    }

    public void cancel() {
        MmiCode.State state = this.mState;
        if (state != MmiCode.State.COMPLETE && state != MmiCode.State.FAILED) {
            this.mState = MmiCode.State.CANCELLED;
            if (this.mIsPendingUSSD) {
                this.mPhone.mCi.cancelPendingUssd(obtainMessage(7, this));
            } else {
                this.mPhone.onMMIDone(this);
            }
        }
    }

    public boolean isCancelable() {
        return this.mIsPendingUSSD;
    }

    public boolean isNetworkInitiatedUssd() {
        return this.mIsNetworkInitiatedUSSD;
    }

    /* access modifiers changed from: protected */
    public boolean isMMI() {
        return this.mPoundString != null;
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0004, code lost:
        r1 = r1.mDialingNumber;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean isShortCode() {
        /*
            r1 = this;
            java.lang.String r0 = r1.mPoundString
            if (r0 != 0) goto L_0x0011
            java.lang.String r1 = r1.mDialingNumber
            if (r1 == 0) goto L_0x0011
            int r1 = r1.length()
            r0 = 2
            if (r1 > r0) goto L_0x0011
            r1 = 1
            goto L_0x0012
        L_0x0011:
            r1 = 0
        L_0x0012:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.gsm.GsmMmiCode.isShortCode():boolean");
    }

    public String getDialString() {
        return this.mPoundString;
    }

    public static boolean isTwoDigitShortCode(Context context, int i, String str) {
        Rlog.d(LOG_TAG, "isTwoDigitShortCode");
        if (str != null && str.length() <= 2) {
            if (sTwoDigitNumberPattern == null) {
                sTwoDigitNumberPattern = getTwoDigitNumberPattern(context, i);
            }
            for (String str2 : sTwoDigitNumberPattern) {
                Rlog.d(LOG_TAG, "Two Digit Number Pattern " + str2);
                if (str.equals(str2)) {
                    Rlog.d(LOG_TAG, "Two Digit Number Pattern -true");
                    return true;
                }
            }
            Rlog.d(LOG_TAG, "Two Digit Number Pattern -false");
        }
        return false;
    }

    private static String[] getTwoDigitNumberPattern(Context context, int i) {
        String[] strArr;
        PersistableBundle configForSubId;
        Rlog.d(LOG_TAG, "Get two digit number pattern: subId=" + i);
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) context.getSystemService("carrier_config");
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(i)) == null) {
            strArr = null;
        } else {
            Rlog.d(LOG_TAG, "Two Digit Number Pattern from carrir config");
            strArr = configForSubId.getStringArray("mmi_two_digit_number_pattern_string_array");
        }
        return strArr == null ? new String[0] : strArr;
    }

    protected static boolean isShortCode(String str, GsmCdmaPhone gsmCdmaPhone) {
        if (str == null || str.length() == 0 || isEmergencyNumber(gsmCdmaPhone, str)) {
            return false;
        }
        return isShortCodeUSSD(str, gsmCdmaPhone);
    }

    protected static boolean isShortCodeUSSD(String str, GsmCdmaPhone gsmCdmaPhone) {
        if (str == null || str.length() > 2 || (!gsmCdmaPhone.isInCall() && str.length() == 2 && str.charAt(0) == '1')) {
            return false;
        }
        return true;
    }

    public boolean isPinPukCommand() {
        String str = this.mSc;
        return str != null && (str.equals(SC_PIN) || this.mSc.equals(SC_PIN2) || this.mSc.equals(SC_PUK) || this.mSc.equals(SC_PUK2));
    }

    @UnsupportedAppUsage
    public boolean isTemporaryModeCLIR() {
        String str = this.mSc;
        return str != null && str.equals(SC_CLIR) && this.mDialingNumber != null && (isActivate() || isDeactivate());
    }

    @VisibleForTesting
    public static boolean isEmergencyNumber(Phone phone, String str) {
        try {
            return ((TelephonyManager) phone.getContext().getSystemService(TelephonyManager.class)).isEmergencyNumber(str);
        } catch (RuntimeException unused) {
            return false;
        }
    }

    @VisibleForTesting
    public static boolean isCarrierSupportCallerIdVerticalServiceCodes(Phone phone) {
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService(CarrierConfigManager.class);
        PersistableBundle configForSubId = carrierConfigManager != null ? carrierConfigManager.getConfigForSubId(phone.getSubId()) : null;
        if (configForSubId != null) {
            return configForSubId.getBoolean("carrier_supports_caller_id_vertical_service_codes_bool");
        }
        return false;
    }

    @UnsupportedAppUsage
    public int getCLIRMode() {
        String str = this.mSc;
        if (str == null || !str.equals(SC_CLIR)) {
            return 0;
        }
        if (isActivate()) {
            return 2;
        }
        return isDeactivate() ? 1 : 0;
    }

    /* access modifiers changed from: protected */
    public boolean isFacToDial() {
        PersistableBundle configForSubId = ((CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config")).getConfigForSubId(this.mPhone.getSubId());
        if (configForSubId != null) {
            String[] stringArray = configForSubId.getStringArray("feature_access_codes_string_array");
            if (!ArrayUtils.isEmpty(stringArray)) {
                for (String equals : stringArray) {
                    if (equals.equals(this.mSc)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public boolean isActivate() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_ACTIVATE);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public boolean isDeactivate() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_DEACTIVATE);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public boolean isInterrogate() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_INTERROGATE);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public boolean isRegister() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_REGISTER);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public boolean isErasure() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_ERASURE);
    }

    public boolean isPendingUSSD() {
        return this.mIsPendingUSSD;
    }

    public boolean isUssdRequest() {
        return this.mIsUssdRequest;
    }

    public boolean isSsInfo() {
        return this.mIsSsInfo;
    }

    /* JADX WARNING: Removed duplicated region for block: B:59:0x010c A[Catch:{ RuntimeException -> 0x0351 }] */
    /* JADX WARNING: Removed duplicated region for block: B:65:0x0122 A[Catch:{ RuntimeException -> 0x0351 }] */
    /* JADX WARNING: Removed duplicated region for block: B:66:0x0123 A[Catch:{ RuntimeException -> 0x0351 }] */
    @android.compat.annotation.UnsupportedAppUsage
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void processCode() throws com.android.internal.telephony.CallStateException {
        /*
            r15 = this;
            java.lang.String r0 = "04"
            java.lang.String r1 = "GsmMmiCode"
            boolean r2 = r15.isShortCode()     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x0016
            java.lang.String r0 = "processCode: isShortCode"
            com.android.telephony.Rlog.d(r1, r0)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r0 = r15.mDialingNumber     // Catch:{ RuntimeException -> 0x0351 }
            r15.sendUssd(r0)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0016:
            java.lang.String r2 = r15.mDialingNumber     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r3 = "Invalid or Unsupported MMI Code"
            if (r2 != 0) goto L_0x034b
            java.lang.String r2 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            r4 = 5
            if (r2 == 0) goto L_0x0047
            java.lang.String r5 = "30"
            boolean r2 = r2.equals(r5)     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x0047
            java.lang.String r0 = "processCode: is CLIP"
            com.android.telephony.Rlog.d(r1, r0)     // Catch:{ RuntimeException -> 0x0351 }
            boolean r0 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x0041
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r0 = r0.mCi     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r2 = r15.obtainMessage(r4, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.queryCLIP(r2)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0041:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r3)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x0047:
            java.lang.String r2 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            r5 = 1
            if (r2 == 0) goto L_0x00a9
            java.lang.String r6 = "31"
            boolean r2 = r2.equals(r6)     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x00a9
            java.lang.String r0 = "processCode: is CLIR"
            com.android.telephony.Rlog.d(r1, r0)     // Catch:{ RuntimeException -> 0x0351 }
            boolean r0 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x0074
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            boolean r0 = r0.isClirActivationAndDeactivationPrevented()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 != 0) goto L_0x0074
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r0 = r0.mCi     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r2 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.setCLIR(r5, r2)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0074:
            boolean r0 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0351 }
            r2 = 2
            if (r0 == 0) goto L_0x0090
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            boolean r0 = r0.isClirActivationAndDeactivationPrevented()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 != 0) goto L_0x0090
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r0 = r0.mCi     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r3 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.setCLIR(r2, r3)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0090:
            boolean r0 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x00a3
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r0 = r0.mCi     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r2 = r15.obtainMessage(r2, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.getCLIR(r2)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x00a3:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r3)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x00a9:
            java.lang.String r2 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            boolean r2 = isServiceCodeCallForwarding(r2)     // Catch:{ RuntimeException -> 0x0351 }
            r6 = 4
            r7 = 3
            if (r2 == 0) goto L_0x0135
            java.lang.String r0 = "processCode: is CF"
            com.android.telephony.Rlog.d(r1, r0)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r12 = r15.mSia     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r0 = r15.mSib     // Catch:{ RuntimeException -> 0x0351 }
            int r11 = siToServiceClass(r0)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r0 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            int r10 = scToCallForwardReason(r0)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r0 = r15.mSic     // Catch:{ RuntimeException -> 0x0351 }
            int r13 = siToTime(r0)     // Catch:{ RuntimeException -> 0x0351 }
            boolean r0 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x00df
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r0 = r0.mCi     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r2 = r15.obtainMessage(r7, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.queryCallForwardStatus(r10, r11, r12, r2)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x00df:
            boolean r0 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0351 }
            r2 = 0
            if (r0 == 0) goto L_0x00f4
            boolean r0 = isEmptyOrNull(r12)     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x00f0
            r15.mIsCallFwdReg = r2     // Catch:{ RuntimeException -> 0x0351 }
            r9 = r5
            goto L_0x010a
        L_0x00f0:
            r15.mIsCallFwdReg = r5     // Catch:{ RuntimeException -> 0x0351 }
        L_0x00f2:
            r9 = r7
            goto L_0x010a
        L_0x00f4:
            boolean r0 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x00fc
            r9 = r2
            goto L_0x010a
        L_0x00fc:
            boolean r0 = r15.isRegister()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x0103
            goto L_0x00f2
        L_0x0103:
            boolean r0 = r15.isErasure()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x012d
            r9 = r6
        L_0x010a:
            if (r9 == r5) goto L_0x0111
            if (r9 != r7) goto L_0x010f
            goto L_0x0111
        L_0x010f:
            r0 = r2
            goto L_0x0112
        L_0x0111:
            r0 = r5
        L_0x0112:
            java.lang.String r3 = "processCode: is CF setCallForward"
            com.android.telephony.Rlog.d(r1, r3)     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.GsmCdmaPhone r3 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r8 = r3.mCi     // Catch:{ RuntimeException -> 0x0351 }
            r3 = 6
            boolean r4 = isVoiceUnconditionalForwarding(r10, r11)     // Catch:{ RuntimeException -> 0x0351 }
            if (r4 == 0) goto L_0x0123
            goto L_0x0124
        L_0x0123:
            r5 = r2
        L_0x0124:
            android.os.Message r14 = r15.obtainMessage(r3, r5, r0, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r8.setCallForward(r9, r10, r11, r12, r13, r14)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x012d:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r2 = "invalid action"
            r0.<init>(r2)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x0135:
            java.lang.String r2 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            boolean r2 = isServiceCodeCallBarring(r2)     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x0182
            java.lang.String r11 = r15.mSia     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r0 = r15.mSib     // Catch:{ RuntimeException -> 0x0351 }
            int r12 = siToServiceClass(r0)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r0 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r9 = scToBarringFacility(r0)     // Catch:{ RuntimeException -> 0x0351 }
            boolean r0 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x015e
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r0 = r0.mCi     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r2 = r15.obtainMessage(r4, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.queryFacilityLock(r9, r11, r12, r2)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x015e:
            boolean r0 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 != 0) goto L_0x0171
            boolean r0 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x016b
            goto L_0x0171
        L_0x016b:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r3)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x0171:
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r8 = r0.mCi     // Catch:{ RuntimeException -> 0x0351 }
            boolean r10 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r13 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r8.setFacilityLock(r9, r10, r11, r12, r13)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0182:
            java.lang.String r2 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x01d1
            java.lang.String r8 = "03"
            boolean r2 = r2.equals(r8)     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x01d1
            java.lang.String r0 = r15.mSib     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r2 = r15.mSic     // Catch:{ RuntimeException -> 0x0351 }
            boolean r4 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r4 != 0) goto L_0x01a5
            boolean r4 = r15.isRegister()     // Catch:{ RuntimeException -> 0x0351 }
            if (r4 == 0) goto L_0x019f
            goto L_0x01a5
        L_0x019f:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r3)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x01a5:
            java.lang.String r3 = "**"
            r15.mAction = r3     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r3 = r15.mSia     // Catch:{ RuntimeException -> 0x0351 }
            if (r3 != 0) goto L_0x01b0
            java.lang.String r3 = "AB"
            goto L_0x01b4
        L_0x01b0:
            java.lang.String r3 = scToBarringFacility(r3)     // Catch:{ RuntimeException -> 0x0351 }
        L_0x01b4:
            java.lang.String r4 = r15.mPwd     // Catch:{ RuntimeException -> 0x0351 }
            boolean r4 = r2.equals(r4)     // Catch:{ RuntimeException -> 0x0351 }
            if (r4 == 0) goto L_0x01c9
            com.android.internal.telephony.GsmCdmaPhone r4 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r4 = r4.mCi     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r5 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r4.changeBarringPassword(r3, r0, r2, r5)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x01c9:
            r0 = 17040960(0x1040640, float:2.4249055E-38)
            r15.handlePasswordError(r0)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x01d1:
            java.lang.String r2 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x021a
            java.lang.String r8 = "43"
            boolean r2 = r2.equals(r8)     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x021a
            java.lang.String r0 = r15.mSia     // Catch:{ RuntimeException -> 0x0351 }
            int r0 = siToServiceClass(r0)     // Catch:{ RuntimeException -> 0x0351 }
            boolean r2 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 != 0) goto L_0x0209
            boolean r2 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x01f0
            goto L_0x0209
        L_0x01f0:
            boolean r2 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x0203
            com.android.internal.telephony.GsmCdmaPhone r2 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r2 = r2.mCi     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r3 = r15.obtainMessage(r4, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r2.queryCallWaiting(r0, r3)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0203:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r3)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x0209:
            com.android.internal.telephony.GsmCdmaPhone r2 = r15.mPhone     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.CommandsInterface r2 = r2.mCi     // Catch:{ RuntimeException -> 0x0351 }
            boolean r3 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r4 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r2.setCallWaiting(r3, r0, r4)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x021a:
            boolean r2 = r15.isPinPukCommand()     // Catch:{ RuntimeException -> 0x0351 }
            if (r2 == 0) goto L_0x0311
            java.lang.String r2 = r15.mSia     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r3 = r15.mSib     // Catch:{ RuntimeException -> 0x0351 }
            int r4 = r3.length()     // Catch:{ RuntimeException -> 0x0351 }
            boolean r7 = r15.isRegister()     // Catch:{ RuntimeException -> 0x0351 }
            if (r7 == 0) goto L_0x02f8
            java.lang.String r7 = r15.mSic     // Catch:{ RuntimeException -> 0x0351 }
            boolean r7 = r3.equals(r7)     // Catch:{ RuntimeException -> 0x0351 }
            if (r7 != 0) goto L_0x023e
            r0 = 17040825(0x10405b9, float:2.4248677E-38)
            r15.handlePasswordError(r0)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x023e:
            if (r4 < r6) goto L_0x02f0
            r6 = 8
            if (r4 <= r6) goto L_0x0246
            goto L_0x02f0
        L_0x0246:
            java.lang.String r4 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            boolean r4 = r4.equals(r0)     // Catch:{ RuntimeException -> 0x0351 }
            if (r4 == 0) goto L_0x0262
            com.android.internal.telephony.uicc.UiccCardApplication r4 = r15.mUiccApplication     // Catch:{ RuntimeException -> 0x0351 }
            if (r4 == 0) goto L_0x0262
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r4 = r4.getState()     // Catch:{ RuntimeException -> 0x0351 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r6 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_PUK     // Catch:{ RuntimeException -> 0x0351 }
            if (r4 != r6) goto L_0x0262
            r0 = 17040853(0x10405d5, float:2.4248755E-38)
            r15.handlePasswordError(r0)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0262:
            com.android.internal.telephony.uicc.UiccCardApplication r4 = r15.mUiccApplication     // Catch:{ RuntimeException -> 0x0351 }
            if (r4 == 0) goto L_0x02e8
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0351 }
            r4.<init>()     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r6 = "processCode: process mmi service code using UiccApp sc="
            r4.append(r6)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r6 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            r4.append(r6)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r4 = r4.toString()     // Catch:{ RuntimeException -> 0x0351 }
            com.android.telephony.Rlog.d(r1, r4)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r4 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            boolean r0 = r4.equals(r0)     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x028f
            com.android.internal.telephony.uicc.UiccCardApplication r0 = r15.mUiccApplication     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r4 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.changeIccLockPassword(r2, r3, r4)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x028f:
            java.lang.String r0 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r4 = "042"
            boolean r0 = r0.equals(r4)     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x02a4
            com.android.internal.telephony.uicc.UiccCardApplication r0 = r15.mUiccApplication     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r4 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.changeIccFdnPassword(r2, r3, r4)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x02a4:
            java.lang.String r0 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r4 = "05"
            boolean r0 = r0.equals(r4)     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x02b9
            com.android.internal.telephony.uicc.UiccCardApplication r0 = r15.mUiccApplication     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r4 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.supplyPuk(r2, r3, r4)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x02b9:
            java.lang.String r0 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r4 = "052"
            boolean r0 = r0.equals(r4)     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x02ce
            com.android.internal.telephony.uicc.UiccCardApplication r0 = r15.mUiccApplication     // Catch:{ RuntimeException -> 0x0351 }
            android.os.Message r4 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0351 }
            r0.supplyPuk2(r2, r3, r4)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x02ce:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0351 }
            r2.<init>()     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r3 = "uicc unsupported service code="
            r2.append(r3)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r3 = r15.mSc     // Catch:{ RuntimeException -> 0x0351 }
            r2.append(r3)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r2 = r2.toString()     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r2)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x02e8:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r2 = "No application mUiccApplicaiton is null"
            r0.<init>(r2)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x02f0:
            r0 = 17040507(0x104047b, float:2.4247786E-38)
            r15.handlePasswordError(r0)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x02f8:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0351 }
            r2.<init>()     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r3 = "Ivalid register/action="
            r2.append(r3)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r3 = r15.mAction     // Catch:{ RuntimeException -> 0x0351 }
            r2.append(r3)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r2 = r2.toString()     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r2)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x0311:
            java.lang.String r0 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x0340
            android.content.Context r0 = r15.mContext     // Catch:{ RuntimeException -> 0x0351 }
            android.content.res.Resources r0 = r0.getResources()     // Catch:{ RuntimeException -> 0x0351 }
            r2 = 17891366(0x1110026, float:2.66324E-38)
            boolean r0 = r0.getBoolean(r2)     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == 0) goto L_0x033a
            java.lang.String r0 = "carrier_ussd_method_int"
            int r0 = r15.getIntCarrierConfig(r0)     // Catch:{ RuntimeException -> 0x0351 }
            if (r0 == r7) goto L_0x0332
            java.lang.String r0 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0351 }
            r15.sendUssd(r0)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0332:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.String r2 = "The USSD request is not allowed over CS"
            r0.<init>(r2)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x033a:
            java.lang.String r0 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0351 }
            r15.sendUssd(r0)     // Catch:{ RuntimeException -> 0x0351 }
            goto L_0x037a
        L_0x0340:
            java.lang.String r0 = "processCode: Invalid or Unsupported MMI Code"
            com.android.telephony.Rlog.d(r1, r0)     // Catch:{ RuntimeException -> 0x0351 }
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r3)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x034b:
            java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0351 }
            r0.<init>(r3)     // Catch:{ RuntimeException -> 0x0351 }
            throw r0     // Catch:{ RuntimeException -> 0x0351 }
        L_0x0351:
            r0 = move-exception
            com.android.internal.telephony.MmiCode$State r2 = com.android.internal.telephony.MmiCode.State.FAILED
            r15.mState = r2
            android.content.Context r2 = r15.mContext
            r3 = 17040835(0x10405c3, float:2.4248705E-38)
            java.lang.CharSequence r2 = r2.getText(r3)
            r15.mMessage = r2
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "processCode: RuntimeException="
            r2.append(r3)
            r2.append(r0)
            java.lang.String r0 = r2.toString()
            com.android.telephony.Rlog.d(r1, r0)
            com.android.internal.telephony.GsmCdmaPhone r0 = r15.mPhone
            r0.onMMIDone(r15)
        L_0x037a:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.gsm.GsmMmiCode.processCode():void");
    }

    /* access modifiers changed from: protected */
    public void handlePasswordError(int i) {
        this.mState = MmiCode.State.FAILED;
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        sb.append(this.mContext.getText(i));
        this.mMessage = sb;
        this.mPhone.onMMIDone(this);
    }

    public void onUssdFinished(String str, boolean z) {
        if (this.mState == MmiCode.State.PENDING) {
            if (TextUtils.isEmpty(str)) {
                Rlog.d(LOG_TAG, "onUssdFinished: no network provided message; using default.");
                this.mMessage = this.mContext.getText(17040834);
            } else {
                this.mMessage = str;
            }
            this.mIsUssdRequest = z;
            if (!z) {
                this.mState = MmiCode.State.COMPLETE;
            }
            Rlog.d(LOG_TAG, "onUssdFinished: ussdMessage=" + str);
            this.mPhone.onMMIDone(this);
        }
    }

    public void onUssdFinishedError() {
        if (this.mState == MmiCode.State.PENDING) {
            this.mState = MmiCode.State.FAILED;
            if (TextUtils.isEmpty(this.mMessage)) {
                this.mMessage = this.mContext.getText(17040835);
            }
            Rlog.d(LOG_TAG, "onUssdFinishedError");
            this.mPhone.onMMIDone(this);
        }
    }

    public void onUssdRelease() {
        if (this.mState == MmiCode.State.PENDING) {
            this.mState = MmiCode.State.COMPLETE;
            this.mMessage = null;
            Rlog.d(LOG_TAG, "onUssdRelease");
            this.mPhone.onMMIDone(this);
        }
    }

    public void sendUssd(String str) {
        this.mIsPendingUSSD = true;
        this.mPhone.mCi.sendUSSD(str, obtainMessage(4, this));
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case 1:
                onSetComplete(message, (AsyncResult) message.obj);
                return;
            case 2:
                onGetClirComplete((AsyncResult) message.obj);
                return;
            case 3:
                onQueryCfComplete((AsyncResult) message.obj);
                return;
            case 4:
                AsyncResult asyncResult = (AsyncResult) message.obj;
                if (asyncResult.exception != null) {
                    this.mState = MmiCode.State.FAILED;
                    this.mMessage = getErrorMessage(asyncResult);
                    this.mPhone.onMMIDone(this);
                    return;
                }
                return;
            case 5:
                onQueryComplete((AsyncResult) message.obj);
                return;
            case 6:
                AsyncResult asyncResult2 = (AsyncResult) message.obj;
                if (asyncResult2.exception == null && message.arg1 == 1) {
                    this.mPhone.setVoiceCallForwardingFlag(1, message.arg2 == 1, this.mDialingNumber);
                }
                onSetComplete(message, asyncResult2);
                return;
            case 7:
                this.mPhone.onMMIDone(this);
                return;
            default:
                return;
        }
    }

    /* access modifiers changed from: protected */
    public CharSequence getErrorMessage(AsyncResult asyncResult) {
        Throwable th = asyncResult.exception;
        if (th instanceof CommandException) {
            CommandException.Error commandError = ((CommandException) th).getCommandError();
            if (commandError == CommandException.Error.FDN_CHECK_FAILURE) {
                Rlog.i(LOG_TAG, "FDN_CHECK_FAILURE");
                return this.mContext.getText(17040837);
            } else if (commandError == CommandException.Error.USSD_MODIFIED_TO_DIAL) {
                Rlog.i(LOG_TAG, "USSD_MODIFIED_TO_DIAL");
                return this.mContext.getText(17041634);
            } else if (commandError == CommandException.Error.USSD_MODIFIED_TO_SS) {
                Rlog.i(LOG_TAG, "USSD_MODIFIED_TO_SS");
                return this.mContext.getText(17041636);
            } else if (commandError == CommandException.Error.USSD_MODIFIED_TO_USSD) {
                Rlog.i(LOG_TAG, "USSD_MODIFIED_TO_USSD");
                return this.mContext.getText(17041637);
            } else if (commandError == CommandException.Error.SS_MODIFIED_TO_DIAL) {
                Rlog.i(LOG_TAG, "SS_MODIFIED_TO_DIAL");
                return this.mContext.getText(17041630);
            } else if (commandError == CommandException.Error.SS_MODIFIED_TO_USSD) {
                Rlog.i(LOG_TAG, "SS_MODIFIED_TO_USSD");
                return this.mContext.getText(17041633);
            } else if (commandError == CommandException.Error.SS_MODIFIED_TO_SS) {
                Rlog.i(LOG_TAG, "SS_MODIFIED_TO_SS");
                return this.mContext.getText(17041632);
            } else if (commandError == CommandException.Error.OEM_ERROR_1) {
                Rlog.i(LOG_TAG, "OEM_ERROR_1 USSD_MODIFIED_TO_DIAL_VIDEO");
                return this.mContext.getText(17041635);
            }
        }
        return this.mContext.getText(17040835);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public CharSequence getScString() {
        String str = this.mSc;
        if (str == null) {
            return "";
        }
        if (isServiceCodeCallBarring(str)) {
            return this.mContext.getText(17039428);
        }
        if (isServiceCodeCallForwarding(this.mSc)) {
            return this.mContext.getText(17039434);
        }
        if (this.mSc.equals(SC_CLIP)) {
            return this.mContext.getText(17039435);
        }
        if (this.mSc.equals(SC_CLIR)) {
            return this.mContext.getText(17039436);
        }
        if (this.mSc.equals(SC_PWD)) {
            return this.mContext.getText(17039559);
        }
        if (this.mSc.equals(SC_WAIT)) {
            return this.mContext.getText(17039442);
        }
        return isPinPukCommand() ? this.mContext.getText(17039558) : "";
    }

    /* access modifiers changed from: protected */
    public void onSetComplete(Message message, AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        Throwable th = asyncResult.exception;
        if (th != null) {
            this.mState = MmiCode.State.FAILED;
            if (th instanceof CommandException) {
                CommandException.Error commandError = ((CommandException) th).getCommandError();
                if (commandError == CommandException.Error.PASSWORD_INCORRECT) {
                    if (isPinPukCommand()) {
                        if (this.mSc.equals(SC_PUK) || this.mSc.equals(SC_PUK2)) {
                            sb.append(this.mContext.getText(17039795));
                        } else {
                            sb.append(this.mContext.getText(17039794));
                        }
                        int i = message.arg1;
                        if (i <= 0) {
                            Rlog.d(LOG_TAG, "onSetComplete: PUK locked, cancel as lock screen will handle this");
                            this.mState = MmiCode.State.CANCELLED;
                        } else if (i > 0) {
                            Rlog.d(LOG_TAG, "onSetComplete: attemptsRemaining=" + i);
                            sb.append(this.mContext.getResources().getQuantityString(18153472, i, new Object[]{Integer.valueOf(i)}));
                        }
                    } else {
                        sb.append(this.mContext.getText(17040960));
                    }
                } else if (commandError == CommandException.Error.SIM_PUK2) {
                    sb.append(this.mContext.getText(17039794));
                    sb.append("\n");
                    sb.append(this.mContext.getText(17040854));
                } else if (commandError == CommandException.Error.REQUEST_NOT_SUPPORTED) {
                    if (this.mSc.equals(SC_PIN)) {
                        sb.append(this.mContext.getText(17040209));
                    }
                } else if (commandError == CommandException.Error.FDN_CHECK_FAILURE) {
                    Rlog.i(LOG_TAG, "FDN_CHECK_FAILURE");
                    sb.append(this.mContext.getText(17040837));
                } else if (commandError != CommandException.Error.MODEM_ERR) {
                    sb.append(getErrorMessage(asyncResult));
                } else if (!isServiceCodeCallForwarding(this.mSc) || !this.mPhone.getServiceState().getVoiceRoaming() || this.mPhone.supports3gppCallForwardingWhileRoaming()) {
                    sb.append(getErrorMessage(asyncResult));
                } else {
                    sb.append(this.mContext.getText(17040836));
                }
            } else {
                sb.append(this.mContext.getText(17040835));
            }
        } else if (isActivate()) {
            this.mState = MmiCode.State.COMPLETE;
            if (this.mIsCallFwdReg) {
                sb.append(this.mContext.getText(17041529));
            } else {
                sb.append(this.mContext.getText(17041525));
            }
            if (this.mSc.equals(SC_CLIR)) {
                this.mPhone.saveClirSetting(1);
            }
        } else if (isDeactivate()) {
            this.mState = MmiCode.State.COMPLETE;
            sb.append(this.mContext.getText(17041524));
            if (this.mSc.equals(SC_CLIR)) {
                this.mPhone.saveClirSetting(2);
            }
        } else if (isRegister()) {
            this.mState = MmiCode.State.COMPLETE;
            sb.append(this.mContext.getText(17041529));
        } else if (isErasure()) {
            this.mState = MmiCode.State.COMPLETE;
            sb.append(this.mContext.getText(17041527));
        } else {
            this.mState = MmiCode.State.FAILED;
            sb.append(this.mContext.getText(17040835));
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onSetComplete mmi=" + this);
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    public void onGetClirComplete(AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        if (asyncResult.exception != null) {
            this.mState = MmiCode.State.FAILED;
            sb.append(getErrorMessage(asyncResult));
        } else {
            int[] iArr = (int[]) asyncResult.result;
            int i = iArr[1];
            if (i == 0) {
                sb.append(this.mContext.getText(17041528));
                this.mState = MmiCode.State.COMPLETE;
            } else if (i == 1) {
                sb.append(this.mContext.getText(17039433));
                this.mState = MmiCode.State.COMPLETE;
            } else if (i == 2) {
                sb.append(this.mContext.getText(17040835));
                this.mState = MmiCode.State.FAILED;
            } else if (i == 3) {
                int i2 = iArr[0];
                if (i2 == 1) {
                    sb.append(this.mContext.getText(17039432));
                } else if (i2 != 2) {
                    sb.append(this.mContext.getText(17039432));
                } else {
                    sb.append(this.mContext.getText(17039431));
                }
                this.mState = MmiCode.State.COMPLETE;
            } else if (i == 4) {
                int i3 = iArr[0];
                if (i3 == 1) {
                    sb.append(this.mContext.getText(17039430));
                } else if (i3 != 2) {
                    sb.append(this.mContext.getText(17039429));
                } else {
                    sb.append(this.mContext.getText(17039429));
                }
                this.mState = MmiCode.State.COMPLETE;
            }
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onGetClirComplete: mmi=" + this);
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    public CharSequence serviceClassToCFString(int i) {
        if (i == 1) {
            return this.mContext.getText(17041523);
        }
        if (i == 2) {
            return this.mContext.getText(17041516);
        }
        if (i == 4) {
            return this.mContext.getText(17041519);
        }
        if (i == 8) {
            return this.mContext.getText(17041522);
        }
        if (i == 16) {
            return this.mContext.getText(17041518);
        }
        if (i == 32) {
            return this.mContext.getText(17041517);
        }
        if (i == 64) {
            return this.mContext.getText(17041521);
        }
        if (i != 128) {
            return null;
        }
        return this.mContext.getText(17041520);
    }

    /* access modifiers changed from: protected */
    public CharSequence makeCFQueryResultMessage(CallForwardInfo callForwardInfo, int i) {
        CharSequence charSequence;
        String[] strArr = {"{0}", "{1}", "{2}"};
        CharSequence[] charSequenceArr = new CharSequence[3];
        boolean z = false;
        boolean z2 = callForwardInfo.reason == 2;
        int i2 = callForwardInfo.status;
        if (i2 == 1) {
            if (z2) {
                charSequence = this.mContext.getText(17039857);
            } else {
                charSequence = this.mContext.getText(17039856);
            }
        } else if (i2 == 0 && isEmptyOrNull(callForwardInfo.number)) {
            charSequence = this.mContext.getText(17039858);
        } else if (z2) {
            charSequence = this.mContext.getText(17039860);
        } else {
            charSequence = this.mContext.getText(17039859);
        }
        charSequenceArr[0] = serviceClassToCFString(callForwardInfo.serviceClass & i);
        charSequenceArr[1] = formatLtr(PhoneNumberUtils.stringFromStringAndTOA(callForwardInfo.number, callForwardInfo.toa));
        charSequenceArr[2] = Integer.toString(callForwardInfo.timeSeconds);
        if (callForwardInfo.reason == 0 && (i & callForwardInfo.serviceClass) == 1) {
            if (callForwardInfo.status == 1) {
                z = true;
            }
            this.mPhone.setVoiceCallForwardingFlag(1, z, callForwardInfo.number);
        }
        return TextUtils.replace(charSequence, strArr, charSequenceArr);
    }

    /* access modifiers changed from: protected */
    public String formatLtr(String str) {
        return str == null ? str : BidiFormatter.getInstance().unicodeWrap(str, TextDirectionHeuristics.LTR, true);
    }

    /* access modifiers changed from: protected */
    public void onQueryCfComplete(AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        if (asyncResult.exception != null) {
            this.mState = MmiCode.State.FAILED;
            sb.append(getErrorMessage(asyncResult));
        } else {
            CallForwardInfo[] callForwardInfoArr = (CallForwardInfo[]) asyncResult.result;
            if (callForwardInfoArr == null || callForwardInfoArr.length == 0) {
                sb.append(this.mContext.getText(17041524));
                this.mPhone.setVoiceCallForwardingFlag(1, false, (String) null);
            } else {
                SpannableStringBuilder spannableStringBuilder = new SpannableStringBuilder();
                for (int i = 1; i <= 128; i <<= 1) {
                    for (CallForwardInfo callForwardInfo : callForwardInfoArr) {
                        if ((callForwardInfo.serviceClass & i) != 0) {
                            spannableStringBuilder.append(makeCFQueryResultMessage(callForwardInfo, i));
                            spannableStringBuilder.append("\n");
                        }
                    }
                }
                sb.append(spannableStringBuilder);
            }
            this.mState = MmiCode.State.COMPLETE;
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onQueryCfComplete: mmi=" + this);
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    public void onQueryComplete(AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        if (asyncResult.exception != null) {
            this.mState = MmiCode.State.FAILED;
            sb.append(getErrorMessage(asyncResult));
        } else {
            int[] iArr = (int[]) asyncResult.result;
            if (iArr.length == 0) {
                sb.append(this.mContext.getText(17040835));
            } else if (iArr[0] == 0) {
                sb.append(this.mContext.getText(17041524));
            } else if (this.mSc.equals(SC_WAIT)) {
                sb.append(createQueryCallWaitingResultMessage(iArr[1]));
            } else if (isServiceCodeCallBarring(this.mSc)) {
                sb.append(createQueryCallBarringResultMessage(iArr[0]));
            } else if (iArr[0] == 1) {
                sb.append(this.mContext.getText(17041525));
            } else {
                sb.append(this.mContext.getText(17040835));
            }
            this.mState = MmiCode.State.COMPLETE;
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onQueryComplete: mmi=" + this);
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    public CharSequence createQueryCallWaitingResultMessage(int i) {
        StringBuilder sb = new StringBuilder(this.mContext.getText(17041526));
        for (int i2 = 1; i2 <= 128; i2 <<= 1) {
            int i3 = i2 & i;
            if (i3 != 0) {
                sb.append("\n");
                sb.append(serviceClassToCFString(i3));
            }
        }
        return sb;
    }

    /* access modifiers changed from: protected */
    public CharSequence createQueryCallBarringResultMessage(int i) {
        StringBuilder sb = new StringBuilder(this.mContext.getText(17041526));
        for (int i2 = 1; i2 <= 128; i2 <<= 1) {
            int i3 = i2 & i;
            if (i3 != 0) {
                sb.append("\n");
                sb.append(serviceClassToCFString(i3));
            }
        }
        return sb;
    }

    private int getIntCarrierConfig(String str) {
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService(CarrierConfigManager.class);
        PersistableBundle configForSubId = carrierConfigManager != null ? carrierConfigManager.getConfigForSubId(this.mPhone.getSubId()) : null;
        if (configForSubId != null) {
            return configForSubId.getInt(str);
        }
        return CarrierConfigManager.getDefaultConfig().getInt(str);
    }

    public ResultReceiver getUssdCallbackReceiver() {
        return this.mCallbackReceiver;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("GsmMmiCode {");
        sb.append("State=" + getState());
        if (this.mAction != null) {
            sb.append(" action=" + this.mAction);
        }
        if (this.mSc != null) {
            sb.append(" sc=" + this.mSc);
        }
        if (this.mSia != null) {
            sb.append(" sia=" + Rlog.pii(LOG_TAG, this.mSia));
        }
        if (this.mSib != null) {
            sb.append(" sib=" + Rlog.pii(LOG_TAG, this.mSib));
        }
        if (this.mSic != null) {
            sb.append(" sic=" + Rlog.pii(LOG_TAG, this.mSic));
        }
        if (this.mPoundString != null) {
            sb.append(" poundString=" + Rlog.pii(LOG_TAG, this.mPoundString));
        }
        if (this.mDialingNumber != null) {
            sb.append(" dialingNumber=" + Rlog.pii(LOG_TAG, this.mDialingNumber));
        }
        if (this.mPwd != null) {
            sb.append(" pwd=" + Rlog.pii(LOG_TAG, this.mPwd));
        }
        if (this.mCallbackReceiver != null) {
            sb.append(" hasReceiver");
        }
        sb.append("}");
        return sb.toString();
    }
}
