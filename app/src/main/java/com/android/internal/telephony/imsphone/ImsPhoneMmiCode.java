package com.android.internal.telephony.imsphone;

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
import android.telephony.ims.ImsCallForwardInfo;
import android.telephony.ims.ImsSsData;
import android.telephony.ims.ImsSsInfo;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import com.android.ims.ImsException;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CallForwardInfo;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.MmiCode;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.gsm.GsmMmiCode;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.telephony.Rlog;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ImsPhoneMmiCode extends Handler implements MmiCode {
    protected static final String ACTION_ACTIVATE = "*";
    protected static final String ACTION_DEACTIVATE = "#";
    protected static final String ACTION_ERASURE = "##";
    protected static final String ACTION_INTERROGATE = "*#";
    protected static final String ACTION_REGISTER = "**";
    protected static final char END_OF_USSD_COMMAND = '#';
    protected static final int EVENT_GET_CLIR_COMPLETE = 6;
    protected static final int EVENT_QUERY_CF_COMPLETE = 1;
    protected static final int EVENT_QUERY_COMPLETE = 3;
    protected static final int EVENT_QUERY_ICB_COMPLETE = 10;
    protected static final int EVENT_SET_CFF_COMPLETE = 4;
    protected static final int EVENT_SET_COMPLETE = 0;
    protected static final int EVENT_SUPP_SVC_QUERY_COMPLETE = 7;
    protected static final int EVENT_USSD_CANCEL_COMPLETE = 5;
    protected static final int EVENT_USSD_COMPLETE = 2;
    protected static final String IcbAnonymousMmi = "Anonymous Incoming Call Barring";
    protected static final String IcbDnMmi = "Specific Incoming Call Barring";
    static final String LOG_TAG = "ImsPhoneMmiCode";
    protected static final int MATCH_GROUP_ACTION = 2;
    protected static final int MATCH_GROUP_DIALING_NUMBER = 12;
    protected static final int MATCH_GROUP_POUND_STRING = 1;
    protected static final int MATCH_GROUP_PWD_CONFIRM = 11;
    protected static final int MATCH_GROUP_SERVICE_CODE = 3;
    protected static final int MATCH_GROUP_SIA = 5;
    protected static final int MATCH_GROUP_SIB = 7;
    protected static final int MATCH_GROUP_SIC = 9;
    protected static final int MAX_LENGTH_SHORT_CODE = 2;
    protected static final int NUM_PRESENTATION_ALLOWED = 0;
    protected static final int NUM_PRESENTATION_RESTRICTED = 1;
    protected static final String SC_BAIC = "35";
    protected static final String SC_BAICa = "157";
    protected static final String SC_BAICr = "351";
    protected static final String SC_BAOC = "33";
    protected static final String SC_BAOIC = "331";
    protected static final String SC_BAOICxH = "332";
    protected static final String SC_BA_ALL = "330";
    protected static final String SC_BA_MO = "333";
    protected static final String SC_BA_MT = "353";
    protected static final String SC_BS_MT = "156";
    protected static final String SC_CFB = "67";
    protected static final String SC_CFNR = "62";
    protected static final String SC_CFNRy = "61";
    protected static final String SC_CFU = "21";
    protected static final String SC_CFUT = "22";
    protected static final String SC_CF_All = "002";
    protected static final String SC_CF_All_Conditional = "004";
    protected static final String SC_CLIP = "30";
    protected static final String SC_CLIR = "31";
    protected static final String SC_CNAP = "300";
    protected static final String SC_COLP = "76";
    protected static final String SC_COLR = "77";
    protected static final String SC_PIN = "04";
    protected static final String SC_PIN2 = "042";
    protected static final String SC_PUK = "05";
    protected static final String SC_PUK2 = "052";
    protected static final String SC_PWD = "03";
    protected static final String SC_WAIT = "43";
    @Deprecated
    public static final String UT_BUNDLE_KEY_CLIR = "queryClir";
    @Deprecated
    public static final String UT_BUNDLE_KEY_SSINFO = "imsSsInfo";
    protected static Pattern sPatternSuppService = Pattern.compile("((\\*|#|\\*#|\\*\\*|##)(\\d{2,3})(\\*([^*#]*)(\\*([^*#]*)(\\*([^*#]*)(\\*([^*#]*))?)?)?)?#)(.*)");
    protected static String[] sTwoDigitNumberPattern;
    protected String mAction;
    protected ResultReceiver mCallbackReceiver;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Context mContext;
    protected String mDialingNumber;
    protected IccRecords mIccRecords;
    protected boolean mIsCallFwdReg;
    protected boolean mIsNetworkInitiatedUSSD;
    protected boolean mIsPendingUSSD;
    protected boolean mIsSsInfo = false;
    protected boolean mIsUssdRequest;
    protected CharSequence mMessage;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsPhone mPhone;
    protected String mPoundString;
    protected String mPwd;
    protected String mSc;
    protected String mSia;
    protected String mSib;
    protected String mSic;
    protected MmiCode.State mState = MmiCode.State.PENDING;

    /* access modifiers changed from: protected */
    public String getActionStringFromReqType(int i) {
        if (i == 0) {
            return ACTION_ACTIVATE;
        }
        if (i == 1) {
            return ACTION_DEACTIVATE;
        }
        if (i == 2) {
            return ACTION_INTERROGATE;
        }
        if (i == 3) {
            return ACTION_REGISTER;
        }
        if (i != 4) {
            return null;
        }
        return ACTION_ERASURE;
    }

    /* access modifiers changed from: protected */
    public String getScStringFromScType(int i) {
        switch (i) {
            case 0:
                return SC_CFU;
            case 1:
                return SC_CFB;
            case 2:
                return SC_CFNRy;
            case 3:
                return SC_CFNR;
            case 4:
                return SC_CF_All;
            case 5:
                return SC_CF_All_Conditional;
            case 7:
                return SC_CLIP;
            case 8:
                return SC_CLIR;
            case 9:
                return SC_COLP;
            case 10:
                return SC_COLR;
            case 11:
                return SC_CNAP;
            case 12:
                return SC_WAIT;
            case 13:
                return SC_BAOC;
            case 14:
                return SC_BAOIC;
            case 15:
                return SC_BAOICxH;
            case 16:
                return SC_BAIC;
            case 17:
                return SC_BAICr;
            case 18:
                return SC_BA_ALL;
            case 19:
                return SC_BA_MO;
            case 20:
                return SC_BA_MT;
            case 21:
                return SC_BS_MT;
            case 22:
                return SC_BAICa;
            default:
                return null;
        }
    }

    /* access modifiers changed from: protected */
    public boolean isServiceClassVoiceVideoOrNone(int i) {
        return i == 0 || i == 1 || i == 80;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @VisibleForTesting
    public static ImsPhoneMmiCode newFromDialString(String str, ImsPhone imsPhone) {
        return newFromDialString(str, imsPhone, (ResultReceiver) null);
    }

    public static ImsPhoneMmiCode newFromDialString(String str, ImsPhone imsPhone, ResultReceiver resultReceiver) {
        if ((imsPhone.getDefaultPhone().getServiceState().getVoiceRoaming() && imsPhone.getDefaultPhone().supportsConversionOfCdmaCallerIdMmiCodesWhileRoaming()) || (isEmergencyNumber(imsPhone, str) && isCarrierSupportCallerIdVerticalServiceCodes(imsPhone))) {
            str = convertCdmaMmiCodesTo3gppMmiCodes(str);
        }
        Matcher matcher = sPatternSuppService.matcher(str);
        if (matcher.matches()) {
            ImsPhoneMmiCode imsPhoneMmiCode = new ImsPhoneMmiCode(imsPhone);
            imsPhoneMmiCode.mPoundString = makeEmptyNull(matcher.group(1));
            imsPhoneMmiCode.mAction = makeEmptyNull(matcher.group(2));
            imsPhoneMmiCode.mSc = makeEmptyNull(matcher.group(3));
            imsPhoneMmiCode.mSia = makeEmptyNull(matcher.group(5));
            imsPhoneMmiCode.mSib = makeEmptyNull(matcher.group(7));
            imsPhoneMmiCode.mSic = makeEmptyNull(matcher.group(9));
            imsPhoneMmiCode.mPwd = makeEmptyNull(matcher.group(11));
            String makeEmptyNull = makeEmptyNull(matcher.group(12));
            imsPhoneMmiCode.mDialingNumber = makeEmptyNull;
            imsPhoneMmiCode.mCallbackReceiver = resultReceiver;
            if (makeEmptyNull == null || !makeEmptyNull.endsWith(ACTION_DEACTIVATE) || !str.endsWith(ACTION_DEACTIVATE)) {
                return imsPhoneMmiCode;
            }
            ImsPhoneMmiCode imsPhoneMmiCode2 = new ImsPhoneMmiCode(imsPhone);
            imsPhoneMmiCode2.mPoundString = str;
            return imsPhoneMmiCode2;
        } else if (str.endsWith(ACTION_DEACTIVATE)) {
            ImsPhoneMmiCode imsPhoneMmiCode3 = new ImsPhoneMmiCode(imsPhone);
            imsPhoneMmiCode3.mPoundString = str;
            return imsPhoneMmiCode3;
        } else if (GsmMmiCode.isTwoDigitShortCode(imsPhone.getContext(), imsPhone.getSubId(), str) || !isShortCode(str, imsPhone)) {
            return null;
        } else {
            ImsPhoneMmiCode imsPhoneMmiCode4 = new ImsPhoneMmiCode(imsPhone);
            imsPhoneMmiCode4.mDialingNumber = str;
            return imsPhoneMmiCode4;
        }
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

    public static ImsPhoneMmiCode newNetworkInitiatedUssd(String str, boolean z, ImsPhone imsPhone) {
        ImsPhoneMmiCode imsPhoneMmiCode = new ImsPhoneMmiCode(imsPhone);
        imsPhoneMmiCode.mMessage = str;
        imsPhoneMmiCode.mIsUssdRequest = z;
        imsPhoneMmiCode.mIsNetworkInitiatedUSSD = true;
        if (z) {
            imsPhoneMmiCode.mIsPendingUSSD = true;
            imsPhoneMmiCode.mState = MmiCode.State.PENDING;
        } else {
            imsPhoneMmiCode.mState = MmiCode.State.COMPLETE;
        }
        return imsPhoneMmiCode;
    }

    public static ImsPhoneMmiCode newFromUssdUserInput(String str, ImsPhone imsPhone) {
        ImsPhoneMmiCode imsPhoneMmiCode = new ImsPhoneMmiCode(imsPhone);
        imsPhoneMmiCode.mMessage = str;
        imsPhoneMmiCode.mState = MmiCode.State.PENDING;
        imsPhoneMmiCode.mIsPendingUSSD = true;
        return imsPhoneMmiCode;
    }

    protected static String makeEmptyNull(String str) {
        if (str == null || str.length() != 0) {
            return str;
        }
        return null;
    }

    protected static boolean isScMatchesSuppServType(String str) {
        Matcher matcher = sPatternSuppService.matcher(str);
        if (matcher.matches()) {
            String makeEmptyNull = makeEmptyNull(matcher.group(3));
            if (!makeEmptyNull.equals(SC_CFUT) && !makeEmptyNull.equals(SC_BS_MT)) {
                return false;
            }
            return true;
        }
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
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

    protected static boolean isServiceCodeCallForwarding(String str) {
        return str != null && (str.equals(SC_CFU) || str.equals(SC_CFB) || str.equals(SC_CFNRy) || str.equals(SC_CFNR) || str.equals(SC_CF_All) || str.equals(SC_CF_All_Conditional));
    }

    protected static boolean isServiceCodeCallBarring(String str) {
        String[] stringArray;
        Resources system = Resources.getSystem();
        if (!(str == null || (stringArray = system.getStringArray(17236014)) == null)) {
            for (String equals : stringArray) {
                if (str.equals(equals)) {
                    return true;
                }
            }
        }
        return false;
    }

    static boolean isPinPukCommand(String str) {
        return str != null && (str.equals(SC_PIN) || str.equals(SC_PIN2) || str.equals(SC_PUK) || str.equals(SC_PUK2));
    }

    public static boolean isSuppServiceCodes(String str, Phone phone) {
        if (phone != null && phone.getServiceState().getVoiceRoaming() && phone.getDefaultPhone().supportsConversionOfCdmaCallerIdMmiCodesWhileRoaming()) {
            str = convertCdmaMmiCodesTo3gppMmiCodes(str);
        }
        Matcher matcher = sPatternSuppService.matcher(str);
        if (!matcher.matches()) {
            return false;
        }
        String makeEmptyNull = makeEmptyNull(matcher.group(3));
        if (isServiceCodeCallForwarding(makeEmptyNull) || isServiceCodeCallBarring(makeEmptyNull)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_CFUT)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_CLIP)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_CLIR)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_COLP)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_COLR)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_CNAP)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_BS_MT)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_BAICa)) {
            return true;
        }
        if (makeEmptyNull != null && makeEmptyNull.equals(SC_PWD)) {
            return true;
        }
        if ((makeEmptyNull == null || !makeEmptyNull.equals(SC_WAIT)) && !isPinPukCommand(makeEmptyNull)) {
            return false;
        }
        return true;
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

    public ImsPhoneMmiCode(ImsPhone imsPhone) {
        super(imsPhone.getHandler().getLooper());
        this.mPhone = imsPhone;
        this.mContext = imsPhone.getContext();
        this.mIccRecords = this.mPhone.mDefaultPhone.getIccRecords();
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
                this.mPhone.cancelUSSD(obtainMessage(5, this));
            } else {
                this.mPhone.onMMIDone(this);
            }
        }
    }

    public boolean isCancelable() {
        return this.mIsPendingUSSD;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getDialingNumber() {
        return this.mDialingNumber;
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
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneMmiCode.isShortCode():boolean");
    }

    public String getDialString() {
        return this.mPoundString;
    }

    protected static boolean isShortCode(String str, ImsPhone imsPhone) {
        if (str == null || str.length() == 0 || isEmergencyNumber(imsPhone, str)) {
            return false;
        }
        return isShortCodeUSSD(str, imsPhone);
    }

    protected static boolean isShortCodeUSSD(String str, ImsPhone imsPhone) {
        if (str == null || str.length() > 2 || (!imsPhone.isInCall() && str.length() == 2 && str.charAt(0) == '1')) {
            return false;
        }
        return true;
    }

    public boolean isPinPukCommand() {
        return isPinPukCommand(this.mSc);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @VisibleForTesting
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

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
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
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isActivate() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_ACTIVATE);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isDeactivate() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_DEACTIVATE);
    }

    /* access modifiers changed from: protected */
    public boolean isInterrogate() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_INTERROGATE);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isRegister() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_REGISTER);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
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

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isSupportedOverImsPhone() {
        String str;
        String str2;
        String str3;
        String str4;
        String str5;
        String str6;
        String str7;
        String str8;
        if (isShortCode()) {
            return true;
        }
        if (isServiceCodeCallForwarding(this.mSc) || isServiceCodeCallBarring(this.mSc) || (((str = this.mSc) != null && str.equals(SC_WAIT)) || (((str2 = this.mSc) != null && str2.equals(SC_CLIR)) || (((str3 = this.mSc) != null && str3.equals(SC_CLIP)) || (((str4 = this.mSc) != null && str4.equals(SC_COLR)) || (((str5 = this.mSc) != null && str5.equals(SC_COLP)) || (((str6 = this.mSc) != null && str6.equals(SC_BS_MT)) || ((str7 = this.mSc) != null && str7.equals(SC_BAICa))))))))) {
            try {
                int siToServiceClass = siToServiceClass(this.mSib);
                if (siToServiceClass == 0 || siToServiceClass == 1 || siToServiceClass == 80) {
                    return true;
                }
                return false;
            } catch (RuntimeException e) {
                Rlog.d(LOG_TAG, "Invalid service class " + e);
            }
        } else if (isPinPukCommand() || (((str8 = this.mSc) != null && (str8.equals(SC_PWD) || this.mSc.equals(SC_CLIP) || this.mSc.equals(SC_CLIR))) || this.mPoundString == null)) {
            return false;
        } else {
            return true;
        }
    }

    public int callBarAction(String str) {
        if (isActivate()) {
            return 1;
        }
        if (isDeactivate()) {
            return 0;
        }
        if (isRegister()) {
            if (!isEmptyOrNull(str)) {
                return 3;
            }
            throw new RuntimeException("invalid action");
        } else if (isErasure()) {
            return 4;
        } else {
            throw new RuntimeException("invalid action");
        }
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(5:143|144|145|146|252) */
    /* JADX WARNING: Can't wrap try/catch for region: R(5:149|150|151|152|253) */
    /* JADX WARNING: Can't wrap try/catch for region: R(5:64|65|66|67|245) */
    /* JADX WARNING: Can't wrap try/catch for region: R(5:72|73|74|75|246) */
    /* JADX WARNING: Code restructure failed: missing block: B:263:?, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:264:?, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:270:?, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:271:?, code lost:
        return;
     */
    /* JADX WARNING: Missing exception handler attribute for start block: B:145:0x0221 */
    /* JADX WARNING: Missing exception handler attribute for start block: B:151:0x023d */
    /* JADX WARNING: Missing exception handler attribute for start block: B:66:0x010b */
    /* JADX WARNING: Missing exception handler attribute for start block: B:74:0x012d */
    /* JADX WARNING: Removed duplicated region for block: B:28:0x006e A[Catch:{ RuntimeException -> 0x0458 }] */
    /* JADX WARNING: Removed duplicated region for block: B:33:0x0076 A[Catch:{ RuntimeException -> 0x0458 }] */
    /* JADX WARNING: Unknown top exception splitter block from list: {B:145:0x0221=Splitter:B:145:0x0221, B:66:0x010b=Splitter:B:66:0x010b, B:74:0x012d=Splitter:B:74:0x012d, B:151:0x023d=Splitter:B:151:0x023d} */
    @android.compat.annotation.UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void processCode() throws com.android.internal.telephony.CallStateException {
        /*
            r15 = this;
            java.lang.String r0 = "ImsPhoneMmiCode"
            boolean r1 = r15.isShortCode()     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = "' over CS pipe."
            java.lang.String r3 = "cs_fallback"
            if (r1 != 0) goto L_0x0434
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            boolean r1 = isServiceCodeCallForwarding(r1)     // Catch:{ RuntimeException -> 0x0458 }
            r4 = 3
            r5 = 1
            r6 = 0
            if (r1 == 0) goto L_0x0092
            java.lang.String r1 = "processCode: is CF"
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r10 = r15.mSia     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            int r9 = scToCallForwardReason(r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r15.mSib     // Catch:{ RuntimeException -> 0x0458 }
            int r11 = siToServiceClass(r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r15.mSic     // Catch:{ RuntimeException -> 0x0458 }
            int r12 = siToTime(r1)     // Catch:{ RuntimeException -> 0x0458 }
            boolean r1 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0041
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            android.os.Message r2 = r15.obtainMessage(r5, r15)     // Catch:{ RuntimeException -> 0x0458 }
            r1.getCallForwardingOption(r9, r11, r2)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0041:
            boolean r1 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            r2 = 4
            if (r1 == 0) goto L_0x0056
            boolean r1 = isEmptyOrNull(r10)     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0052
            r15.mIsCallFwdReg = r6     // Catch:{ RuntimeException -> 0x0458 }
            r8 = r5
            goto L_0x006c
        L_0x0052:
            r15.mIsCallFwdReg = r5     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0054:
            r8 = r4
            goto L_0x006c
        L_0x0056:
            boolean r1 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x005e
            r8 = r6
            goto L_0x006c
        L_0x005e:
            boolean r1 = r15.isRegister()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0065
            goto L_0x0054
        L_0x0065:
            boolean r1 = r15.isErasure()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x008a
            r8 = r2
        L_0x006c:
            if (r9 == 0) goto L_0x0073
            if (r9 != r2) goto L_0x0071
            goto L_0x0073
        L_0x0071:
            r1 = r6
            goto L_0x0074
        L_0x0073:
            r1 = r5
        L_0x0074:
            if (r8 == r5) goto L_0x007a
            if (r8 != r4) goto L_0x0079
            goto L_0x007a
        L_0x0079:
            r5 = r6
        L_0x007a:
            java.lang.String r3 = "processCode: is CF setCallForward"
            com.android.telephony.Rlog.d(r0, r3)     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.imsphone.ImsPhone r7 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            android.os.Message r13 = r15.obtainMessage(r2, r1, r5, r15)     // Catch:{ RuntimeException -> 0x0458 }
            r7.setCallForwardingOption(r8, r9, r10, r11, r12, r13)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x008a:
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = "invalid action"
            r1.<init>(r2)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0092:
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            boolean r1 = isServiceCodeCallBarring(r1)     // Catch:{ RuntimeException -> 0x0458 }
            r7 = 7
            java.lang.String r8 = "Invalid or Unsupported MMI Code"
            if (r1 == 0) goto L_0x00de
            java.lang.String r12 = r15.mSia     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r10 = scToBarringFacility(r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r15.mSib     // Catch:{ RuntimeException -> 0x0458 }
            int r14 = siToServiceClass(r1)     // Catch:{ RuntimeException -> 0x0458 }
            boolean r1 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x00bc
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            android.os.Message r2 = r15.obtainMessage(r7, r15)     // Catch:{ RuntimeException -> 0x0458 }
            r1.getCallBarring(r10, r2, r14)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x00bc:
            boolean r1 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 != 0) goto L_0x00cf
            boolean r1 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x00c9
            goto L_0x00cf
        L_0x00c9:
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r8)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x00cf:
            com.android.internal.telephony.imsphone.ImsPhone r9 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            boolean r11 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            android.os.Message r13 = r15.obtainMessage(r6, r15)     // Catch:{ RuntimeException -> 0x0458 }
            r9.setCallBarring(r10, r11, r12, r13, r14)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x00de:
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            r9 = 2
            r10 = 6
            if (r1 == 0) goto L_0x0150
            java.lang.String r11 = "31"
            boolean r1 = r1.equals(r11)     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0150
            boolean r1 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = "processCode: Could not get UT handle for updateCLIR."
            if (r1 == 0) goto L_0x0110
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.Phone r1 = r1.getDefaultPhone()     // Catch:{ RuntimeException -> 0x0458 }
            boolean r1 = r1.isClirActivationAndDeactivationPrevented()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 != 0) goto L_0x0110
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ Exception -> 0x010b }
            android.os.Message r3 = r15.obtainMessage(r6, r15)     // Catch:{ Exception -> 0x010b }
            r1.setOutgoingCallerIdDisplay(r5, r3)     // Catch:{ Exception -> 0x010b }
            goto L_0x0481
        L_0x010b:
            com.android.telephony.Rlog.d(r0, r2)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0110:
            boolean r1 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0132
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.Phone r1 = r1.getDefaultPhone()     // Catch:{ RuntimeException -> 0x0458 }
            boolean r1 = r1.isClirActivationAndDeactivationPrevented()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 != 0) goto L_0x0132
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ Exception -> 0x012d }
            android.os.Message r3 = r15.obtainMessage(r6, r15)     // Catch:{ Exception -> 0x012d }
            r1.setOutgoingCallerIdDisplay(r9, r3)     // Catch:{ Exception -> 0x012d }
            goto L_0x0481
        L_0x012d:
            com.android.telephony.Rlog.d(r0, r2)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0132:
            boolean r1 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x014a
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ Exception -> 0x0143 }
            android.os.Message r2 = r15.obtainMessage(r10, r15)     // Catch:{ Exception -> 0x0143 }
            r1.getOutgoingCallerIdDisplay(r2)     // Catch:{ Exception -> 0x0143 }
            goto L_0x0481
        L_0x0143:
            java.lang.String r1 = "processCode: Could not get UT handle for queryCLIR."
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x014a:
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r8)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0150:
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x01a3
            java.lang.String r11 = "30"
            boolean r1 = r1.equals(r11)     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x01a3
            boolean r1 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0174
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ Exception -> 0x016d }
            android.os.Message r2 = r15.obtainMessage(r7, r15)     // Catch:{ Exception -> 0x016d }
            r1.queryCLIP(r2)     // Catch:{ Exception -> 0x016d }
            goto L_0x0481
        L_0x016d:
            java.lang.String r1 = "processCode: Could not get UT handle for queryCLIP."
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0174:
            boolean r1 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 != 0) goto L_0x0187
            boolean r1 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0181
            goto L_0x0187
        L_0x0181:
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r8)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0187:
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x019c }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x019c }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x019c }
            boolean r2 = r15.isActivate()     // Catch:{ ImsException -> 0x019c }
            android.os.Message r3 = r15.obtainMessage(r6, r15)     // Catch:{ ImsException -> 0x019c }
            r1.updateCLIP(r2, r3)     // Catch:{ ImsException -> 0x019c }
            goto L_0x0481
        L_0x019c:
            java.lang.String r1 = "processCode: Could not get UT handle for updateCLIP."
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x01a3:
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x01fc
            java.lang.String r11 = "76"
            boolean r1 = r1.equals(r11)     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x01fc
            boolean r1 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x01cd
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x01c6 }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x01c6 }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x01c6 }
            android.os.Message r2 = r15.obtainMessage(r7, r15)     // Catch:{ ImsException -> 0x01c6 }
            r1.queryCOLP(r2)     // Catch:{ ImsException -> 0x01c6 }
            goto L_0x0481
        L_0x01c6:
            java.lang.String r1 = "processCode: Could not get UT handle for queryCOLP."
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x01cd:
            boolean r1 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 != 0) goto L_0x01e0
            boolean r1 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x01da
            goto L_0x01e0
        L_0x01da:
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r8)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x01e0:
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x01f5 }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x01f5 }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x01f5 }
            boolean r2 = r15.isActivate()     // Catch:{ ImsException -> 0x01f5 }
            android.os.Message r3 = r15.obtainMessage(r6, r15)     // Catch:{ ImsException -> 0x01f5 }
            r1.updateCOLP(r2, r3)     // Catch:{ ImsException -> 0x01f5 }
            goto L_0x0481
        L_0x01f5:
            java.lang.String r1 = "processCode: Could not get UT handle for updateCOLP."
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x01fc:
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0266
            java.lang.String r11 = "77"
            boolean r1 = r1.equals(r11)     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0266
            boolean r1 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = "processCode: Could not get UT handle for updateCOLR."
            if (r1 == 0) goto L_0x0226
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x0221 }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x0221 }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x0221 }
            android.os.Message r3 = r15.obtainMessage(r6, r15)     // Catch:{ ImsException -> 0x0221 }
            r1.updateCOLR(r5, r3)     // Catch:{ ImsException -> 0x0221 }
            goto L_0x0481
        L_0x0221:
            com.android.telephony.Rlog.d(r0, r2)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0226:
            boolean r1 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0242
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x023d }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x023d }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x023d }
            android.os.Message r3 = r15.obtainMessage(r6, r15)     // Catch:{ ImsException -> 0x023d }
            r1.updateCOLR(r6, r3)     // Catch:{ ImsException -> 0x023d }
            goto L_0x0481
        L_0x023d:
            com.android.telephony.Rlog.d(r0, r2)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0242:
            boolean r1 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0260
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x0259 }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x0259 }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x0259 }
            android.os.Message r2 = r15.obtainMessage(r7, r15)     // Catch:{ ImsException -> 0x0259 }
            r1.queryCOLR(r2)     // Catch:{ ImsException -> 0x0259 }
            goto L_0x0481
        L_0x0259:
            java.lang.String r1 = "processCode: Could not get UT handle for queryCOLR."
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0260:
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r8)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0266:
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            r7 = 10
            if (r1 == 0) goto L_0x0297
            java.lang.String r11 = "156"
            boolean r1 = r1.equals(r11)     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0297
            boolean r1 = r15.isInterrogate()     // Catch:{ ImsException -> 0x0290 }
            if (r1 == 0) goto L_0x028b
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x0290 }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x0290 }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x0290 }
            android.os.Message r2 = r15.obtainMessage(r7, r15)     // Catch:{ ImsException -> 0x0290 }
            r1.queryCallBarring(r7, r2)     // Catch:{ ImsException -> 0x0290 }
            goto L_0x0481
        L_0x028b:
            r15.processIcbMmiCodeForUpdate()     // Catch:{ ImsException -> 0x0290 }
            goto L_0x0481
        L_0x0290:
            java.lang.String r1 = "processCode: Could not get UT handle for ICB."
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0297:
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x02de
            java.lang.String r11 = "157"
            boolean r1 = r1.equals(r11)     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x02de
            boolean r1 = r15.isInterrogate()     // Catch:{ ImsException -> 0x02d7 }
            if (r1 == 0) goto L_0x02ba
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x02d7 }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x02d7 }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x02d7 }
            android.os.Message r2 = r15.obtainMessage(r7, r15)     // Catch:{ ImsException -> 0x02d7 }
            r1.queryCallBarring(r10, r2)     // Catch:{ ImsException -> 0x02d7 }
            goto L_0x0481
        L_0x02ba:
            boolean r1 = r15.isActivate()     // Catch:{ ImsException -> 0x02d7 }
            if (r1 == 0) goto L_0x02c1
            goto L_0x02c5
        L_0x02c1:
            r15.isDeactivate()     // Catch:{ ImsException -> 0x02d7 }
            r5 = r6
        L_0x02c5:
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ ImsException -> 0x02d7 }
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r1.mCT     // Catch:{ ImsException -> 0x02d7 }
            com.android.ims.ImsUtInterface r1 = r1.getUtInterface()     // Catch:{ ImsException -> 0x02d7 }
            android.os.Message r2 = r15.obtainMessage(r6, r15)     // Catch:{ ImsException -> 0x02d7 }
            r3 = 0
            r1.updateCallBarring(r10, r5, r2, r3)     // Catch:{ ImsException -> 0x02d7 }
            goto L_0x0481
        L_0x02d7:
            java.lang.String r1 = "processCode: Could not get UT handle for ICBa."
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x02de:
            java.lang.String r1 = r15.mSc     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0323
            java.lang.String r7 = "43"
            boolean r1 = r1.equals(r7)     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0323
            java.lang.String r1 = r15.mSib     // Catch:{ RuntimeException -> 0x0458 }
            int r1 = siToServiceClass(r1)     // Catch:{ RuntimeException -> 0x0458 }
            boolean r2 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r2 != 0) goto L_0x0314
            boolean r2 = r15.isDeactivate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r2 == 0) goto L_0x02fd
            goto L_0x0314
        L_0x02fd:
            boolean r1 = r15.isInterrogate()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x030e
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            android.os.Message r2 = r15.obtainMessage(r4, r15)     // Catch:{ RuntimeException -> 0x0458 }
            r1.getCallWaiting(r2)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x030e:
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r8)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0314:
            com.android.internal.telephony.imsphone.ImsPhone r2 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            boolean r3 = r15.isActivate()     // Catch:{ RuntimeException -> 0x0458 }
            android.os.Message r4 = r15.obtainMessage(r6, r15)     // Catch:{ RuntimeException -> 0x0458 }
            r2.setCallWaiting(r3, r1, r4)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x0323:
            java.lang.String r1 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x0429
            android.content.Context r1 = r15.mContext     // Catch:{ RuntimeException -> 0x0458 }
            android.content.res.Resources r1 = r1.getResources()     // Catch:{ RuntimeException -> 0x0458 }
            r6 = 17891366(0x1110026, float:2.66324E-38)
            boolean r1 = r1.getBoolean(r6)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r6 = "processCode: Sending ussd string '"
            if (r1 == 0) goto L_0x0408
            java.lang.String r1 = "carrier_ussd_method_int"
            int r1 = r15.getIntCarrierConfig(r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r7 = "' over IMS pipe."
            if (r1 == 0) goto L_0x03af
            if (r1 == r5) goto L_0x038d
            if (r1 == r9) goto L_0x036c
            if (r1 != r4) goto L_0x0349
            goto L_0x038d
        L_0x0349:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r6)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = com.android.telephony.Rlog.pii(r0, r2)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = "' over CS pipe.(unsupported method)"
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x0458 }
            com.android.telephony.Rlog.i(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.CallStateException r1 = new com.android.internal.telephony.CallStateException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r3)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x036c:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r6)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r4 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r4 = com.android.telephony.Rlog.pii(r0, r4)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r4)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x0458 }
            com.android.telephony.Rlog.i(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.CallStateException r1 = new com.android.internal.telephony.CallStateException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r3)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x038d:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r6)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = com.android.telephony.Rlog.pii(r0, r2)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r7)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x0458 }
            com.android.telephony.Rlog.i(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            r15.sendUssd(r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x03af:
            com.android.internal.telephony.imsphone.ImsPhone r1 = r15.mPhone     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.Phone r1 = r1.getDefaultPhone()     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.ServiceStateTracker r1 = r1.getServiceStateTracker()     // Catch:{ RuntimeException -> 0x0458 }
            android.telephony.ServiceState r1 = r1.mSS     // Catch:{ RuntimeException -> 0x0458 }
            int r1 = r1.getState()     // Catch:{ RuntimeException -> 0x0458 }
            if (r1 == 0) goto L_0x03e5
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = "processCode: CS is out of service, sending ussd string '"
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = com.android.telephony.Rlog.pii(r0, r2)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r7)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x0458 }
            com.android.telephony.Rlog.i(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            r15.sendUssd(r1)     // Catch:{ RuntimeException -> 0x0458 }
            goto L_0x0481
        L_0x03e5:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r6)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = com.android.telephony.Rlog.pii(r0, r2)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r2 = "' over CS pipe (allowed over ims)."
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x0458 }
            com.android.telephony.Rlog.i(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.CallStateException r1 = new com.android.internal.telephony.CallStateException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r3)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0408:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r6)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r4 = r15.mPoundString     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r4 = com.android.telephony.Rlog.pii(r0, r4)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r4)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x0458 }
            com.android.telephony.Rlog.i(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.CallStateException r1 = new com.android.internal.telephony.CallStateException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r3)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0429:
            java.lang.String r1 = "processCode: invalid or unsupported MMI"
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r8)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0434:
            java.lang.String r1 = "processCode: isShortCode"
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>()     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r4 = "processCode: Sending short code '"
            r1.append(r4)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r4 = r15.mDialingNumber     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r4)     // Catch:{ RuntimeException -> 0x0458 }
            r1.append(r2)     // Catch:{ RuntimeException -> 0x0458 }
            java.lang.String r1 = r1.toString()     // Catch:{ RuntimeException -> 0x0458 }
            com.android.telephony.Rlog.d(r0, r1)     // Catch:{ RuntimeException -> 0x0458 }
            com.android.internal.telephony.CallStateException r1 = new com.android.internal.telephony.CallStateException     // Catch:{ RuntimeException -> 0x0458 }
            r1.<init>(r3)     // Catch:{ RuntimeException -> 0x0458 }
            throw r1     // Catch:{ RuntimeException -> 0x0458 }
        L_0x0458:
            r1 = move-exception
            com.android.internal.telephony.MmiCode$State r2 = com.android.internal.telephony.MmiCode.State.FAILED
            r15.mState = r2
            android.content.Context r2 = r15.mContext
            r3 = 17040835(0x10405c3, float:2.4248705E-38)
            java.lang.CharSequence r2 = r2.getText(r3)
            r15.mMessage = r2
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "processCode: RuntimeException = "
            r2.append(r3)
            r2.append(r1)
            java.lang.String r1 = r2.toString()
            com.android.telephony.Rlog.d(r0, r1)
            com.android.internal.telephony.imsphone.ImsPhone r0 = r15.mPhone
            r0.onMMIDone(r15)
        L_0x0481:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneMmiCode.processCode():void");
    }

    public void onUssdFinished(String str, boolean z) {
        if (this.mState == MmiCode.State.PENDING) {
            if (TextUtils.isEmpty(str)) {
                this.mMessage = this.mContext.getText(17040834);
                Rlog.v(LOG_TAG, "onUssdFinished: no message; using: " + this.mMessage);
            } else {
                Rlog.v(LOG_TAG, "onUssdFinished: message: " + str);
                this.mMessage = str;
            }
            this.mIsUssdRequest = z;
            if (!z) {
                this.mState = MmiCode.State.COMPLETE;
            }
            this.mPhone.onMMIDone(this);
        }
    }

    public void onUssdFinishedError() {
        if (this.mState == MmiCode.State.PENDING) {
            this.mState = MmiCode.State.FAILED;
            if (TextUtils.isEmpty(this.mMessage)) {
                this.mMessage = this.mContext.getText(17040835);
            }
            Rlog.d(LOG_TAG, "onUssdFinishedError: mmi=" + this);
            this.mPhone.onMMIDone(this);
        }
    }

    public void sendUssd(String str) {
        this.mIsPendingUSSD = true;
        this.mPhone.sendUSSD(str, obtainMessage(2, this));
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i != 10) {
            switch (i) {
                case 0:
                    onSetComplete(message, (AsyncResult) message.obj);
                    return;
                case 1:
                    onQueryCfComplete((AsyncResult) message.obj);
                    return;
                case 2:
                    AsyncResult asyncResult = (AsyncResult) message.obj;
                    if (asyncResult.exception != null) {
                        this.mState = MmiCode.State.FAILED;
                        this.mMessage = getErrorMessage(asyncResult);
                        this.mPhone.onMMIDone(this);
                        return;
                    }
                    return;
                case 3:
                    onQueryComplete((AsyncResult) message.obj);
                    return;
                case 4:
                    AsyncResult asyncResult2 = (AsyncResult) message.obj;
                    if (asyncResult2.exception == null && message.arg1 == 1) {
                        boolean z = message.arg2 == 1;
                        IccRecords iccRecords = this.mIccRecords;
                        if (iccRecords != null) {
                            this.mPhone.setVoiceCallForwardingFlag(iccRecords, 1, z, this.mDialingNumber);
                        }
                    }
                    onSetComplete(message, asyncResult2);
                    return;
                case 5:
                    this.mPhone.onMMIDone(this);
                    return;
                case 6:
                    onQueryClirComplete((AsyncResult) message.obj);
                    return;
                case 7:
                    onSuppSvcQueryComplete((AsyncResult) message.obj);
                    return;
                default:
                    return;
            }
        } else {
            onIcbQueryComplete((AsyncResult) message.obj);
        }
    }

    /* access modifiers changed from: protected */
    public void processIcbMmiCodeForUpdate() {
        String str = this.mSia;
        try {
            this.mPhone.mCT.getUtInterface().updateCallBarring(10, callBarAction(str), obtainMessage(0, this), str != null ? str.split("\\$") : null);
        } catch (ImsException unused) {
            Rlog.d(LOG_TAG, "processIcbMmiCodeForUpdate:Could not get UT handle for updating ICB.");
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CharSequence getErrorMessage(AsyncResult asyncResult) {
        CharSequence mmiErrorMessage = getMmiErrorMessage(asyncResult);
        return mmiErrorMessage != null ? mmiErrorMessage : this.mContext.getText(17040835);
    }

    /* access modifiers changed from: protected */
    public CharSequence getMmiErrorMessage(AsyncResult asyncResult) {
        ImsException imsException = asyncResult.exception;
        if (imsException instanceof ImsException) {
            int code = imsException.getCode();
            if (code == 241) {
                return this.mContext.getText(17040837);
            }
            switch (code) {
                case 822:
                    return this.mContext.getText(17041630);
                case 823:
                    return this.mContext.getText(17041633);
                case 824:
                    return this.mContext.getText(17041632);
                case 825:
                    return this.mContext.getText(17041631);
                default:
                    return null;
            }
        } else {
            if (imsException instanceof CommandException) {
                CommandException commandException = (CommandException) imsException;
                if (commandException.getCommandError() == CommandException.Error.FDN_CHECK_FAILURE) {
                    return this.mContext.getText(17040837);
                }
                if (commandException.getCommandError() == CommandException.Error.SS_MODIFIED_TO_DIAL) {
                    return this.mContext.getText(17041630);
                }
                if (commandException.getCommandError() == CommandException.Error.SS_MODIFIED_TO_USSD) {
                    return this.mContext.getText(17041633);
                }
                if (commandException.getCommandError() == CommandException.Error.SS_MODIFIED_TO_SS) {
                    return this.mContext.getText(17041632);
                }
                if (commandException.getCommandError() == CommandException.Error.SS_MODIFIED_TO_DIAL_VIDEO) {
                    return this.mContext.getText(17041631);
                }
                if (commandException.getCommandError() == CommandException.Error.INTERNAL_ERR) {
                    return this.mContext.getText(17040835);
                }
            }
            return null;
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
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
        if (this.mSc.equals(SC_PWD)) {
            return this.mContext.getText(17039559);
        }
        if (this.mSc.equals(SC_WAIT)) {
            return this.mContext.getText(17039442);
        }
        if (this.mSc.equals(SC_CLIP)) {
            return this.mContext.getText(17039435);
        }
        if (this.mSc.equals(SC_CLIR)) {
            return this.mContext.getText(17039436);
        }
        if (this.mSc.equals(SC_COLP)) {
            return this.mContext.getText(17039440);
        }
        if (this.mSc.equals(SC_COLR)) {
            return this.mContext.getText(17039441);
        }
        if (this.mSc.equals(SC_BS_MT)) {
            return IcbDnMmi;
        }
        return this.mSc.equals(SC_BAICa) ? IcbAnonymousMmi : "";
    }

    /* access modifiers changed from: protected */
    public void onSetComplete(Message message, AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        Throwable th = asyncResult.exception;
        if (th != null) {
            this.mState = MmiCode.State.FAILED;
            if (th instanceof CommandException) {
                CommandException commandException = (CommandException) th;
                if (commandException.getCommandError() == CommandException.Error.PASSWORD_INCORRECT) {
                    sb.append(this.mContext.getText(17040960));
                } else {
                    CharSequence mmiErrorMessage = getMmiErrorMessage(asyncResult);
                    if (mmiErrorMessage != null) {
                        sb.append(mmiErrorMessage);
                    } else if (commandException.getMessage() != null) {
                        sb.append(commandException.getMessage());
                    } else {
                        sb.append(this.mContext.getText(17040835));
                    }
                }
            } else if (th instanceof ImsException) {
                sb.append(getImsErrorMessage(asyncResult));
            }
        } else {
            Object obj = asyncResult.result;
            if (obj != null && (obj instanceof Integer) && ((Integer) obj).intValue() == 255) {
                this.mState = MmiCode.State.FAILED;
                sb = null;
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
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onSetComplete: mmi=" + this);
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
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
        charSequenceArr[1] = PhoneNumberUtils.stringFromStringAndTOA(callForwardInfo.number, callForwardInfo.toa);
        charSequenceArr[2] = Integer.toString(callForwardInfo.timeSeconds);
        if (callForwardInfo.reason == 0 && (i & callForwardInfo.serviceClass) == 1) {
            if (callForwardInfo.status == 1) {
                z = true;
            }
            this.mPhone.setVoiceCallForwardingFlag(this.mIccRecords, 1, z, callForwardInfo.number);
        }
        return TextUtils.replace(charSequence, strArr, charSequenceArr);
    }

    /* access modifiers changed from: protected */
    public void onQueryCfComplete(AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        Throwable th = asyncResult.exception;
        if (th != null) {
            this.mState = MmiCode.State.FAILED;
            if (th instanceof ImsException) {
                sb.append(getImsErrorMessage(asyncResult));
            } else {
                sb.append(getErrorMessage(asyncResult));
            }
        } else {
            Object obj = asyncResult.result;
            if (!(obj instanceof CallForwardInfo[]) || ((CallForwardInfo[]) obj)[0].status != 255) {
                CallForwardInfo[] callForwardInfoArr = (CallForwardInfo[]) obj;
                if (callForwardInfoArr == null || callForwardInfoArr.length == 0) {
                    sb.append(this.mContext.getText(17041524));
                    this.mPhone.setVoiceCallForwardingFlag(this.mIccRecords, 1, false, (String) null);
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
            } else {
                this.mState = MmiCode.State.FAILED;
                sb = null;
            }
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onQueryCfComplete: mmi=" + this);
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    public void onSuppSvcQueryComplete(AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        this.mState = MmiCode.State.FAILED;
        Throwable th = asyncResult.exception;
        if (th != null) {
            if (th instanceof ImsException) {
                sb.append(getImsErrorMessage(asyncResult));
            } else {
                sb.append(getErrorMessage(asyncResult));
            }
        } else if (asyncResult.result instanceof ImsSsInfo) {
            Rlog.d(LOG_TAG, "onSuppSvcQueryComplete: Received CLIP/COLP/COLR Response.");
            ImsSsInfo imsSsInfo = (ImsSsInfo) asyncResult.result;
            if (imsSsInfo != null) {
                Rlog.d(LOG_TAG, "onSuppSvcQueryComplete: ImsSsInfo mStatus = " + imsSsInfo.getStatus());
                if (imsSsInfo.getProvisionStatus() == 0) {
                    sb.append(this.mContext.getText(17041528));
                    this.mState = MmiCode.State.COMPLETE;
                } else if (imsSsInfo.getStatus() == 0) {
                    sb.append(this.mContext.getText(17041524));
                    this.mState = MmiCode.State.COMPLETE;
                } else if (imsSsInfo.getStatus() == 1) {
                    sb.append(this.mContext.getText(17041525));
                    this.mState = MmiCode.State.COMPLETE;
                } else {
                    sb.append(this.mContext.getText(17040835));
                }
            } else {
                sb.append(this.mContext.getText(17040835));
            }
        } else {
            Rlog.d(LOG_TAG, "onSuppSvcQueryComplete: Received Call Barring/CSFB CLIP Response.");
            int[] iArr = (int[]) asyncResult.result;
            if (iArr == null || iArr.length == 0) {
                sb.append(this.mContext.getText(17040835));
            } else if (iArr[0] != 0) {
                sb.append(this.mContext.getText(17041525));
                this.mState = MmiCode.State.COMPLETE;
            } else {
                sb.append(this.mContext.getText(17041524));
                this.mState = MmiCode.State.COMPLETE;
            }
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onSuppSvcQueryComplete mmi=" + this);
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    public void onIcbQueryComplete(AsyncResult asyncResult) {
        List list;
        Rlog.d(LOG_TAG, "onIcbQueryComplete mmi=" + this);
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        Throwable th = asyncResult.exception;
        if (th != null) {
            this.mState = MmiCode.State.FAILED;
            if (th instanceof ImsException) {
                sb.append(getImsErrorMessage(asyncResult));
            } else {
                sb.append(getErrorMessage(asyncResult));
            }
        } else {
            try {
                list = (List) asyncResult.result;
            } catch (ClassCastException unused) {
                list = Arrays.asList((ImsSsInfo[]) asyncResult.result);
            }
            if (list == null || list.size() == 0) {
                sb.append(this.mContext.getText(17041524));
            } else {
                int size = list.size();
                for (int i = 0; i < size; i++) {
                    ImsSsInfo imsSsInfo = (ImsSsInfo) list.get(i);
                    if (imsSsInfo.getIncomingCommunicationBarringNumber() != null) {
                        sb.append("Num: " + imsSsInfo.getIncomingCommunicationBarringNumber() + " status: " + imsSsInfo.getStatus() + "\n");
                    } else if (imsSsInfo.getStatus() == 1) {
                        sb.append(this.mContext.getText(17041525));
                    } else {
                        sb.append(this.mContext.getText(17041524));
                    }
                }
            }
            this.mState = MmiCode.State.COMPLETE;
        }
        this.mMessage = sb;
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    public void onQueryClirComplete(AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        MmiCode.State state = MmiCode.State.FAILED;
        this.mState = state;
        Throwable th = asyncResult.exception;
        if (th == null) {
            int[] iArr = (int[]) asyncResult.result;
            Rlog.d(LOG_TAG, "onQueryClirComplete: CLIR param n=" + iArr[0] + " m=" + iArr[1]);
            int i = iArr[1];
            if (i == 0) {
                sb.append(this.mContext.getText(17041528));
                this.mState = MmiCode.State.COMPLETE;
            } else if (i == 1) {
                sb.append(this.mContext.getText(17039433));
                this.mState = MmiCode.State.COMPLETE;
            } else if (i == 3) {
                int i2 = iArr[0];
                if (i2 == 0) {
                    sb.append(this.mContext.getText(17039432));
                    this.mState = MmiCode.State.COMPLETE;
                } else if (i2 == 1) {
                    sb.append(this.mContext.getText(17039432));
                    this.mState = MmiCode.State.COMPLETE;
                } else if (i2 != 2) {
                    sb.append(this.mContext.getText(17040835));
                    this.mState = state;
                } else {
                    sb.append(this.mContext.getText(17039431));
                    this.mState = MmiCode.State.COMPLETE;
                }
            } else if (i != 4) {
                sb.append(this.mContext.getText(17040835));
                this.mState = state;
            } else {
                int i3 = iArr[0];
                if (i3 == 0) {
                    sb.append(this.mContext.getText(17039429));
                    this.mState = MmiCode.State.COMPLETE;
                } else if (i3 == 1) {
                    sb.append(this.mContext.getText(17039430));
                    this.mState = MmiCode.State.COMPLETE;
                } else if (i3 != 2) {
                    sb.append(this.mContext.getText(17040835));
                    this.mState = state;
                } else {
                    sb.append(this.mContext.getText(17039429));
                    this.mState = MmiCode.State.COMPLETE;
                }
            }
        } else if (th instanceof ImsException) {
            sb.append(getImsErrorMessage(asyncResult));
        } else {
            sb.append(getErrorMessage(asyncResult));
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onQueryClirComplete mmi=" + this);
        this.mPhone.onMMIDone(this);
    }

    /* access modifiers changed from: protected */
    public void onQueryComplete(AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        this.mState = MmiCode.State.FAILED;
        Throwable th = asyncResult.exception;
        if (th == null) {
            Object obj = asyncResult.result;
            if (!(obj instanceof int[]) || ((int[]) obj)[0] != 255) {
                int[] iArr = (int[]) obj;
                if (iArr == null || iArr.length == 0) {
                    sb.append(this.mContext.getText(17040835));
                } else if (iArr[0] == 0) {
                    sb.append(this.mContext.getText(17041524));
                    this.mState = MmiCode.State.COMPLETE;
                } else if (this.mSc.equals(SC_WAIT)) {
                    sb.append(createQueryCallWaitingResultMessage(iArr[1]));
                    this.mState = MmiCode.State.COMPLETE;
                } else if (iArr[0] == 1) {
                    sb.append(this.mContext.getText(17041525));
                    this.mState = MmiCode.State.COMPLETE;
                } else {
                    sb.append(this.mContext.getText(17040835));
                }
            } else {
                sb = null;
            }
        } else if (th instanceof ImsException) {
            sb.append(getImsErrorMessage(asyncResult));
        } else {
            sb.append(getErrorMessage(asyncResult));
        }
        this.mMessage = sb;
        Rlog.d(LOG_TAG, "onQueryComplete mmi=" + this);
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
    public CharSequence getImsErrorMessage(AsyncResult asyncResult) {
        ImsException imsException = asyncResult.exception;
        CharSequence mmiErrorMessage = getMmiErrorMessage(asyncResult);
        if (mmiErrorMessage != null) {
            return mmiErrorMessage;
        }
        if (imsException.getMessage() != null) {
            return imsException.getMessage();
        }
        return getErrorMessage(asyncResult);
    }

    private int getIntCarrierConfig(String str) {
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config");
        PersistableBundle configForSubId = carrierConfigManager != null ? carrierConfigManager.getConfigForSubId(this.mPhone.getSubId()) : null;
        if (configForSubId != null) {
            return configForSubId.getInt(str);
        }
        return CarrierConfigManager.getDefaultConfig().getInt(str);
    }

    public ResultReceiver getUssdCallbackReceiver() {
        return this.mCallbackReceiver;
    }

    public void processImsSsData(AsyncResult asyncResult) throws ImsException {
        try {
            parseSsData((ImsSsData) asyncResult.result);
        } catch (ClassCastException | NullPointerException unused) {
            throw new ImsException("Exception in parsing SS Data", 0);
        }
    }

    /* access modifiers changed from: package-private */
    public void parseSsData(ImsSsData imsSsData) {
        ImsException imsException = imsSsData.getResult() != 0 ? new ImsException((String) null, imsSsData.getResult()) : null;
        this.mSc = getScStringFromScType(imsSsData.getServiceType());
        this.mAction = getActionStringFromReqType(imsSsData.getRequestType());
        Rlog.d(LOG_TAG, "parseSsData msc = " + this.mSc + ", action = " + this.mAction + ", ex = " + imsException);
        int requestType = imsSsData.getRequestType();
        boolean z = false;
        if (!(requestType == 0 || requestType == 1)) {
            if (requestType != 2) {
                if (!(requestType == 3 || requestType == 4)) {
                    Rlog.e(LOG_TAG, "Invaid requestType in SSData : " + imsSsData.getRequestType());
                    return;
                }
            } else if (imsSsData.isTypeClir()) {
                Rlog.d(LOG_TAG, "CLIR INTERROGATION");
                onQueryClirComplete(new AsyncResult((Object) null, imsSsData.getSuppServiceInfoCompat(), imsException));
                return;
            } else if (imsSsData.isTypeCF()) {
                Rlog.d(LOG_TAG, "CALL FORWARD INTERROGATION");
                List callForwardInfo = imsSsData.getCallForwardInfo();
                onQueryCfComplete(new AsyncResult((Object) null, this.mPhone.handleCfQueryResult(callForwardInfo != null ? (ImsCallForwardInfo[]) callForwardInfo.toArray(new ImsCallForwardInfo[callForwardInfo.size()]) : null), imsException));
                return;
            } else if (imsSsData.isTypeBarring()) {
                onSuppSvcQueryComplete(new AsyncResult((Object) null, imsSsData.getSuppServiceInfoCompat(), imsException));
                return;
            } else if (imsSsData.isTypeColr() || imsSsData.isTypeClip() || imsSsData.isTypeColp()) {
                onSuppSvcQueryComplete(new AsyncResult((Object) null, imsSsData.getSuppServiceInfo().get(0), imsException));
                return;
            } else if (imsSsData.isTypeIcb()) {
                onIcbQueryComplete(new AsyncResult((Object) null, imsSsData.getSuppServiceInfo(), imsException));
                return;
            } else {
                onQueryComplete(new AsyncResult((Object) null, imsSsData.getSuppServiceInfoCompat(), imsException));
                return;
            }
        }
        if (imsSsData.getResult() == 0 && imsSsData.isTypeUnConditional()) {
            if ((imsSsData.getRequestType() == 0 || imsSsData.getRequestType() == 3) && isServiceClassVoiceVideoOrNone(imsSsData.getServiceClass())) {
                z = true;
            }
            Rlog.d(LOG_TAG, "setCallForwardingFlag cffEnabled: " + z);
            if (this.mIccRecords != null) {
                Rlog.d(LOG_TAG, "setVoiceCallForwardingFlag done from SS Info.");
                this.mPhone.setVoiceCallForwardingFlag(1, z, (String) null);
            } else {
                Rlog.e(LOG_TAG, "setCallForwardingFlag aborted. sim records is null.");
            }
        }
        onSetComplete((Message) null, new AsyncResult((Object) null, imsSsData.getCallForwardInfo(), imsException));
    }

    public boolean isSsInfo() {
        return this.mIsSsInfo;
    }

    public void setIsSsInfo(boolean z) {
        this.mIsSsInfo = z;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("ImsPhoneMmiCode {");
        sb.append("State=" + getState());
        if (this.mAction != null) {
            sb.append(" action=" + this.mAction);
        }
        if (this.mSc != null) {
            sb.append(" sc=" + this.mSc);
        }
        if (this.mSia != null) {
            sb.append(" sia=" + this.mSia);
        }
        if (this.mSib != null) {
            sb.append(" sib=" + this.mSib);
        }
        if (this.mSic != null) {
            sb.append(" sic=" + this.mSic);
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

    public boolean isNetworkInitiatedUssd() {
        return this.mIsNetworkInitiatedUSSD;
    }
}
